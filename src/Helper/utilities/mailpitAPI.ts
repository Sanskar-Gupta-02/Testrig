import { request, APIRequestContext } from "@playwright/test";
import * as path from "path";
import * as fs from "fs";
import { AuthConfig } from "../../env/authConfig"; // for BASE_URL if needed
import { EmailService } from "./emailService";
import { pageFixture } from "../../hooks/pagefixtures";

type MailpitMessage = {
    ID: string;
    To: string[];
    From: string[];
    Subject: string;
    Date: string;
};

type MailpitAttachment = {
    CID: string;
    Name: string;
    ContentType: string;
    Data: string;
};

type MailpitEmail = {
    Text: string;
    Subject: string;
    Attachments: MailpitAttachment[];
};

export class MailpitService implements EmailService {
    private static get apiBaseUrl(): string {
        return AuthConfig.mailpitApiBaseUrl();
    }

    private static async getPlaywrightRequest(): Promise<APIRequestContext> {
        return request.newContext({ ignoreHTTPSErrors: true });
    }

    private static buildQuery(toEmail: string, fromEmail?: string) {
        let query = `to:${toEmail}`;
        if (fromEmail) query += ` from:${fromEmail}`;
        return encodeURIComponent(query);
    }

    // --- Helper: Only allow one matching email ---
    private static async getUniqueMessageId(fromEmail: string, toEmail: string, timeoutMs = 30000): Promise<string> {
        const req: APIRequestContext = await MailpitService.getPlaywrightRequest();
        try {
            const search = async (query: string, timeout: number) => {
                const res = await req.get(`${this.apiBaseUrl}search?query=${query}`, { timeout });
                if (!res.ok()) {
                    throw new Error(`Mailpit search failed with HTTP ${res.status()}`);
                }
                const data = (await res.json()) as { count: number; messages: MailpitMessage[] };
                if (!data || !Number.isInteger(data.count) || data.count < 0 || !Array.isArray(data.messages) ||
                    (data.count === 1 && !data.messages[0]?.ID)) {
                    throw new Error("Mailpit search returned an invalid response; check the configured API endpoint.");
                }
                return data;
            };
            const query = this.buildQuery(toEmail, fromEmail);
            const deadline = Date.now() + timeoutMs;
            while (Date.now() < deadline) {
                const data = await search(query, Math.max(1, Math.min(10000, deadline - Date.now())));
                if (data.count === 1) {
                    return data.messages[0].ID;
                }
                if (data.count > 1) {
                    throw new Error(`More than one message found for to:${toEmail} from:${fromEmail}`);
                }
                const remainingMs = deadline - Date.now();
                if (remainingMs > 0) {
                    await new Promise(resolve => setTimeout(resolve, Math.min(1000, remainingMs)));
                }
            }
            let diagnostic: string;
            try {
                const recipientMatches = await search(this.buildQuery(toEmail), 5000);
                diagnostic = `Recipient-only matches: ${recipientMatches.count}. ` +
                    (recipientMatches.count > 0
                        ? "Check the sender filter and email arrival timing."
                        : "Check OTP delivery, recipient address, Mailpit environment, and concurrent mailbox cleanup.");
            } catch {
                diagnostic = "Recipient-only diagnostic search failed.";
            }
            throw new Error(`No message found within ${timeoutMs / 1000}s for to:${toEmail} from:${fromEmail}. ${diagnostic}`);
        } finally {
            await req.dispose();
        }
    }

    async getOtp(fromEmail: string, toEmail: string): Promise<string> {
        const req: APIRequestContext = await MailpitService.getPlaywrightRequest();
        try {
            const messageId = await MailpitService.getUniqueMessageId(fromEmail, toEmail, 60000);
            const res = await req.get(`${MailpitService.apiBaseUrl}message/${messageId}`);
            const email = (await res.json()) as MailpitEmail;
            const otpMatch = email.Text.match(/Your one-time verification code is:\s*(\d{6})/);

            if (!otpMatch || !otpMatch[1]) throw new Error("OTP not found in email");
            const otp = otpMatch[1];
            await this.deleteAllMailsByUsingMessageIds(fromEmail, toEmail);
            return otp;
        } finally {
            await req.dispose();
        }
    }

    async getLink(fromEmail: string, toEmail: string): Promise<string> {
        const req: APIRequestContext = await MailpitService.getPlaywrightRequest();
        try {
            const messageId = await MailpitService.getUniqueMessageId(fromEmail, toEmail);
            const res = await req.get(`${MailpitService.apiBaseUrl}message/${messageId}`);
            const email = (await res.json()) as MailpitEmail;
            const urlRegex = /(https?:\/\/[^\s]+)/g;
            const match = email.Text.match(urlRegex);
            const link = match ? match[0] : null;
            pageFixture.logger.info(`link: ${link}`);
            await this.deleteAllMailsByUsingMessageIds(fromEmail, toEmail);
            return link;
        } catch (error) {
            pageFixture.logger.error(`Error occurred while fetching link from email: ${error}`);
        } finally {
            await req.dispose();
        }
    }

    async getLinkCustomMail(fromEmail: string, toEmail: string): Promise<string> {
        const req: APIRequestContext = await MailpitService.getPlaywrightRequest();
        try {
            const messageId = await MailpitService.getUniqueMessageId(fromEmail, toEmail);
            const res = await req.get(`${MailpitService.apiBaseUrl}message/${messageId}`);
            const email = (await res.json()) as MailpitEmail;
            const baseUrl = process.env.BASEURL;
            const link =
                baseUrl +
                email.Text.split('<a href=\\"' + baseUrl)[1]
                    .trim()
                    .split('\\"')[0]
                    .replace("amp;", "");
            await this.deleteAllMailsByUsingMessageIds(fromEmail, toEmail);
            return link;
        } finally {
            await req.dispose();
        }
    }

    async downloadAttachments(fromEmail: string, toEmail: string, fileName: string): Promise<void> {
        const req: APIRequestContext = await MailpitService.getPlaywrightRequest();
        try {
            const messageId = await MailpitService.getUniqueMessageId(fromEmail, toEmail);
            const res = await req.get(`${MailpitService.apiBaseUrl}message/${messageId}`);
            const email = (await res.json()) as MailpitEmail;

            if (!email.Attachments || email.Attachments.length === 0) {
                throw new Error("No attachments found");
            }
            const ext = fileName.split(".").pop()?.toLowerCase();
            const attachment = email.Attachments.find(a => a.Name.toLowerCase().endsWith(`.${ext}`));
            if (!attachment) throw new Error(`Attachment with type .${ext} not found`);

            const rootPath = path.resolve(__dirname, "../../downloads");
            await fs.promises.mkdir(rootPath, { recursive: true });
            const filePath = path.join(rootPath, fileName);
            const buffer = Buffer.from(attachment.Data, "base64");
            await fs.promises.writeFile(filePath, buffer);

            await this.deleteAllMailsByUsingMessageIds(fromEmail, toEmail);
        } finally {
            await req.dispose();
        }
    }

    async verifyEmailSubject(fromEmail: string, toEmail: string): Promise<string> {
        const req: APIRequestContext = await MailpitService.getPlaywrightRequest();
        try {
            const messageId = await MailpitService.getUniqueMessageId(fromEmail, toEmail);
            const res = await req.get(`${MailpitService.apiBaseUrl}message/${messageId}`);
            const email = (await res.json()) as MailpitEmail;
            await this.deleteAllMailsByUsingMessageIds(fromEmail, toEmail);
            return email.Subject.trim();
        } finally {
            await req.dispose();
        }
    }

    async verifyEmailBodyPreview(fromEmail: string, toEmail: string): Promise<string> {
        const req: APIRequestContext = await MailpitService.getPlaywrightRequest();
        try {
            const messageId = await MailpitService.getUniqueMessageId(fromEmail, toEmail);
            const res = await req.get(`${MailpitService.apiBaseUrl}message/${messageId}`);
            const email = (await res.json()) as MailpitEmail;
            await this.deleteAllMailsByUsingMessageIds(fromEmail, toEmail);
            return email.Text.trim().slice(0, 100);
        } finally {
            await req.dispose();
        }
    }

    async verifyEmailBody(fromEmail: string, toEmail: string): Promise<string> {
        const req: APIRequestContext = await MailpitService.getPlaywrightRequest();
        try {
            const messageId = await MailpitService.getUniqueMessageId(fromEmail, toEmail);
            const res = await req.get(`${MailpitService.apiBaseUrl}message/${messageId}`);
            const email = (await res.json()) as MailpitEmail;
            await this.deleteAllMailsByUsingMessageIds(fromEmail, toEmail);
            return email.Text.trim();
        } finally {
            await req.dispose();
        }
    }

    async getAllMessageIdForMailContent(messageHeader: string): Promise<string[]> {
        const req: APIRequestContext = await MailpitService.getPlaywrightRequest();
        try {
            const query = MailpitService.buildQuery(messageHeader);
            const res = await req.get(`${MailpitService.apiBaseUrl}search?query=${query}`);
            const data = (await res.json()) as { count: number; messages: MailpitMessage[] };
            if (!data.count || !data.messages || data.messages.length === 0) return [];
            return data.messages.map((msg: MailpitMessage) => msg.ID);
        } finally {
            await req.dispose();
        }
    }

    async getEmailBodyWithoutDeletingTheMail(messageId: string): Promise<string> {
        const req: APIRequestContext = await MailpitService.getPlaywrightRequest();
        try {
            const res = await req.get(`${MailpitService.apiBaseUrl}message/${messageId}`);
            const email = (await res.json()) as MailpitEmail;
            return email.Text.trim();
        } finally {
            await req.dispose();
        }
    }

    // For test cleanup: deletes all messages for given to/from (use with care)
    async deleteAllMailsByUsingMessageIds(fromEmail: string, toEmail: string): Promise<void> {
        const req: APIRequestContext = await MailpitService.getPlaywrightRequest();
        try {
            const query = MailpitService.buildQuery(toEmail, fromEmail);
            const res = await req.delete(`${MailpitService.apiBaseUrl}search?query=${query}`);
            if (!res.ok()) {
                throw new Error(`Failed to search mails: ${res.status()}`);
            }
        } finally {
            await req.dispose();
        }
    }

    async getEmailSubjectWithoutDeletingTheMail(fromEmail: string, toEmail: string): Promise<string> {
        const req: APIRequestContext = await MailpitService.getPlaywrightRequest();
        try {
            const messageId = await MailpitService.getUniqueMessageId(fromEmail, toEmail);
            const res = await req.get(`${MailpitService.apiBaseUrl}message/${messageId}`);
            const email = (await res.json()) as MailpitEmail;
            return email.Subject.trim();
        } finally {
            await req.dispose();
        }
    }
}
