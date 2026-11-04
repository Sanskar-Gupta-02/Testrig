import * as path from "path";
import { AuthConfig } from "../../env/authConfig";
import { request, APIRequestContext, APIResponse } from "@playwright/test";
import * as fs from "fs";
import { EmailService } from "./emailService";

interface TokenResponse {
    access_token: string;
    token_type: string;
    expires_in: number;
    expires_on?: number;
    not_before?: number;
    refresh_token?: string;
    scope?: string;
    id_token?: string;
    resource?: string;
    tenant_id?: string;
    upn?: string;
    unique_name?: string;
    roles?: string[];
}

interface EmailAddress {
    address: string;
    name?: string;
}

interface EmailRecipient {
    emailAddress: EmailAddress;
}

interface Message {
    id: string;
    toRecipients: EmailRecipient[];
}

interface MessagesResponse {
    value: Message[];
}

interface Attachment {
    name: string;
    contentBytes: string;
    contentType: string;
    size: number;
}

interface AttachmentsResponse {
    value: Attachment[];
}

interface EmailMessage {
    bodyPreview: string;
    body: {
        content: string;
        contentType: string;
    };
    subject: string;
}

export class GraphAPI implements EmailService {
    private static response: APIResponse | null = null;
    private static token: string | null = null;

    private static async getPlaywrightRequest(): Promise<APIRequestContext> {
        return request.newContext();
    }

    /**
     * Get an access token from Microsoft Graph API
     * @returns Promise<void>
     */
    public static async getToken(): Promise<void> {
        const request = await this.getPlaywrightRequest();
        try {
            const response: APIResponse = await request.post(
                `${AuthConfig.graphBaseUrl()}/${AuthConfig.tenantId()}/oauth2/v2.0/token`,
                {
                    form: {
                        client_id: AuthConfig.clientId(),
                        client_secret: AuthConfig.clientSecret(),
                        scope: AuthConfig.scope(),
                        username: AuthConfig.username(),
                        password: AuthConfig.password(),
                        grant_type: AuthConfig.grantType(),
                    },
                },
            );

            if (response.ok()) {
                const data: TokenResponse = (await response.json()) as TokenResponse;
                this.token = data.access_token;
            } else {
                const errorText = await response.text();
                throw new Error(`Failed to fetch token: ${response.status()} ${errorText}`);
            }
        } catch (error) {
            if (error instanceof Error) {
                console.error("Error getting token:", error.message);
            } else {
                console.error("Unknown error getting token:", error);
            }
            throw error; // Re-throw to handle in calling code
        } finally {
            await request.dispose(); // Clean up the request context
        }
    }

    public static async getMessageIdForMail(fromEmailId: string, toEmailId: string): Promise<string | null> {
        let messageId: string | null = null;
        const request = await GraphAPI.getPlaywrightRequest();
        await GraphAPI.getToken();

        if (!GraphAPI.token) {
            throw new Error("Token is null");
        }

        for (let i = 0; i < 30; i++) {
            try {
                const response = await request.get(
                    `${AuthConfig.apiBaseUrl()}/v1.0/me/messages?$filter=startswith(from/emailAddress/address, '${fromEmailId}')`,
                    {
                        headers: { Authorization: `Bearer ${GraphAPI.token}` },
                    },
                );

                if (!response.ok()) {
                    throw new Error(`Request failed with status ${response.status()}`);
                }

                const responseBody: MessagesResponse = (await response.json()) as MessagesResponse;

                if (!responseBody.value || responseBody.value.length === 0) {
                    throw new Error("No emails found");
                }

                // Find the first message matching the recipient
                const matchingMessage = responseBody.value.find(
                    message => message.toRecipients[0]?.emailAddress?.address === toEmailId,
                );

                if (matchingMessage) {
                    messageId = matchingMessage.id;
                    break;
                }

                await new Promise(resolve => setTimeout(resolve, 1000)); // wait for 1 second
            } catch (error) {
                if (error instanceof Error) {
                    console.error(`Attempt ${i + 1} failed:`, error.message);
                }
                await new Promise(resolve => setTimeout(resolve, 1000));
            }
        }

        await request.dispose(); // Clean up the request context
        return messageId;
    }

    async deleteAllMailsByUsingMessageIds(fromEmail?: string, toEmail?: string): Promise<void> {
        const request = await GraphAPI.getPlaywrightRequest();
        await GraphAPI.getToken();
        if (!GraphAPI.token) throw new Error("Token is null");

        try {
            let url = `${AuthConfig.apiBaseUrl()}/v1.0/me/messages`;
            // If fromEmail or toEmail is provided, filter messages
            if (fromEmail || toEmail) {
                const filters: string[] = [];
                if (fromEmail) filters.push(`startswith(from/emailAddress/address, '${fromEmail}')`);
                if (toEmail) filters.push(`toRecipients/any(r: r/emailAddress/address eq '${toEmail}')`);
                url += `?$filter=${filters.join(" and ")}`;
            }
            const response = await request.get(url, {
                headers: { Authorization: `Bearer ${GraphAPI.token}` },
            });

            if (!response.ok()) {
                throw new Error(`Failed to fetch messages: ${response.status()}`);
            }

            const responseBody: MessagesResponse = (await response.json()) as MessagesResponse;
            const messages = responseBody.value;
            if (!messages || messages.length === 0) return;

            // Further filter by toEmail if both fromEmail and toEmail are provided (since Graph API filter may not be enough)
            let filteredMessages = messages;
            if (fromEmail && toEmail) {
                filteredMessages = messages.filter(
                    msg =>
                        msg.toRecipients.some(r => r.emailAddress.address === toEmail) &&
                        msg.toRecipients.length > 0 &&
                        msg.toRecipients[0].emailAddress.address !== undefined,
                );
            }

            for (const message of filteredMessages) {
                const deleteResponse = await request.post(
                    `${AuthConfig.apiBaseUrl()}/v1.0/me/messages/${message.id}/move`,
                    {
                        data: { destinationId: "recoverableitemspurges" },
                        headers: {
                            "Authorization": `Bearer ${GraphAPI.token}`,
                            "Content-Type": "application/json",
                        },
                    },
                );
                if (!deleteResponse.ok()) {
                    console.error(`Failed to delete message ${message.id}: ${deleteResponse.status()}`);
                }
            }
            console.log("All matching messages deleted successfully");
        } catch (error) {
            console.error("Error deleting messages:", error instanceof Error ? error.message : String(error));
            throw error;
        } finally {
            await request.dispose(); // Clean up the request context
        }
    }

    private async deleteMailsByUsingMessageIds(messageID: string): Promise<void> {
        const request = await GraphAPI.getPlaywrightRequest();
        await GraphAPI.getToken();
        if (!GraphAPI.token) throw new Error("Token is null");

        await request.post(`${AuthConfig.apiBaseUrl()}/v1.0/me/messages/${messageID}/move`, {
            data: { destinationId: "recoverableitemspurges" },
            headers: {
                "Authorization": `Bearer ${GraphAPI.token}`,
                "Content-Type": "application/json",
            },
        });
    }

    async downloadAttachments(fromEmailId: string, toEmailId: string, fileName: string): Promise<void> {
        const request = await GraphAPI.getPlaywrightRequest();
        try {
            const messageId = await GraphAPI.getMessageIdForMail(fromEmailId, toEmailId);
            if (!messageId) {
                throw new Error("Message not found");
            }

            const response = await request.get(`${AuthConfig.apiBaseUrl()}/v1.0/me/messages/${messageId}/attachments`, {
                headers: { Authorization: `Bearer ${GraphAPI.token}` },
            });

            if (!response.ok()) {
                throw new Error(`Failed to fetch attachments: ${response.status()}`);
            }

            const responseBody: AttachmentsResponse = (await response.json()) as AttachmentsResponse;
            if (!responseBody.value || responseBody.value.length === 0) {
                throw new Error("No attachments found");
            }

            const fileExtension = fileName.split(".").pop()?.toLowerCase();
            const matchingAttachment = responseBody.value.find(attachment =>
                attachment.name.toLowerCase().endsWith(`.${fileExtension}`),
            );

            if (!matchingAttachment) {
                throw new Error(`Attachment with type ${fileExtension} not found`);
            }

            const rootPath = path.resolve(__dirname, "../../downloads");
            await fs.promises.mkdir(rootPath, { recursive: true });

            const filePath = path.join(rootPath, fileName);
            const buffer = Buffer.from(matchingAttachment.contentBytes, "base64");
            await fs.promises.writeFile(filePath, buffer);

            await this.deleteMailsByUsingMessageIds(messageId);
        } catch (error) {
            console.error("Error downloading attachment:", error instanceof Error ? error.message : String(error));
            throw error;
        } finally {
            await request.dispose();
        }
    }

    async getOtp(fromEmailId: string, toEmailId: string): Promise<string> {
        const request = await GraphAPI.getPlaywrightRequest();
        try {
            const messageId = await GraphAPI.getMessageIdForMail(fromEmailId, toEmailId);
            if (!messageId) {
                throw new Error("Message not found");
            }

            const response = await request.get(`${AuthConfig.apiBaseUrl()}/v1.0/me/messages/${messageId}`, {
                headers: { Authorization: `Bearer ${GraphAPI.token}` },
            });

            if (!response.ok()) {
                throw new Error(`Failed to fetch message: ${response.status()}`);
            }

            const responseBody: EmailMessage = (await response.json()) as EmailMessage;
            const otpMatch = responseBody.bodyPreview.match(/Your one-time verification code is:\s*(\d{6})/);

            if (!otpMatch || !otpMatch[1]) {
                throw new Error("OTP not found in email");
            }

            const otp = otpMatch[1];
            await this.deleteMailsByUsingMessageIds(messageId);
            return otp;
        } catch (error) {
            console.error("Error getting OTP:", error instanceof Error ? error.message : String(error));
            throw error;
        } finally {
            await request.dispose();
        }
    }

    async getLink(fromEmailId: string, toEmailId: string): Promise<string> {
        const request = await GraphAPI.getPlaywrightRequest();
        const messageId = await GraphAPI.getMessageIdForMail(fromEmailId, toEmailId);
        if (!messageId) throw new Error("Message ID is null");

        const response = await request.get(`${AuthConfig.apiBaseUrl()}/v1.0/me/messages/${messageId}`, {
            headers: { Authorization: `Bearer ${GraphAPI.token}` },
        });

        const responseBody: EmailMessage = (await response.json()) as EmailMessage;
        const link = `${process.env.BASEURL}${responseBody.body.content
            .split(">" + process.env.BASEURL)[1]
            .split("</div>")[0]
            .split("</a>")[0]
            .replace("amp;", "")}`;
        await this.deleteMailsByUsingMessageIds(messageId);
        return link;
    }

    async getLinkCustomMail(fromEmailId: string, toEmailId: string): Promise<string> {
        const request = await GraphAPI.getPlaywrightRequest();
        const messageId = await GraphAPI.getMessageIdForMail(fromEmailId, toEmailId);
        if (!messageId) throw new Error("Message ID is null");

        const response = await request.get(`${AuthConfig.apiBaseUrl()}/v1.0/me/messages/${messageId}`, {
            headers: { Authorization: `Bearer ${GraphAPI.token}` },
        });

        const responseBody: EmailMessage = (await response.json()) as EmailMessage;
        const link = `${process.env.BASEURL}${responseBody.body.content
            .split('<a href=\\"' + process.env.BASEURL)[1]
            .split('\\"')[0]
            .replace("amp;", "")}`;
        await this.deleteMailsByUsingMessageIds(messageId);
        return link;
    }

    async verifyEmailSubject(fromEmailId: string, toEmailId: string): Promise<string> {
        const request = await GraphAPI.getPlaywrightRequest();
        const messageId = await GraphAPI.getMessageIdForMail(fromEmailId, toEmailId);
        if (!messageId) throw new Error("Message ID is null");

        const response = await request.get(`${AuthConfig.apiBaseUrl()}/v1.0/me/messages/${messageId}`, {
            headers: { Authorization: `Bearer ${GraphAPI.token}` },
        });

        const responseBody: EmailMessage = (await response.json()) as EmailMessage;
        const subject = responseBody.subject.trim();
        await this.deleteMailsByUsingMessageIds(messageId);
        return subject;
    }

    async verifyEmailBodyPreview(fromEmailId: string, toEmailId: string): Promise<string> {
        const request = await GraphAPI.getPlaywrightRequest();
        const messageId = await GraphAPI.getMessageIdForMail(fromEmailId, toEmailId);
        if (!messageId) throw new Error("Message ID is null");

        const response = await request.get(`${AuthConfig.apiBaseUrl()}/v1.0/me/messages/${messageId}`, {
            headers: { Authorization: `Bearer ${GraphAPI.token}` },
        });

        const responseBody: EmailMessage = (await response.json()) as EmailMessage;
        const bodyPreview = responseBody.bodyPreview.trim();
        await this.deleteMailsByUsingMessageIds(messageId);
        return bodyPreview;
    }

    async verifyEmailBody(fromEmailId: string, toEmailId: string): Promise<string> {
        const request = await GraphAPI.getPlaywrightRequest();
        const messageId = await GraphAPI.getMessageIdForMail(fromEmailId, toEmailId);
        if (!messageId) throw new Error("Message ID is null");

        const response = await request.get(`${AuthConfig.apiBaseUrl()}/v1.0/me/messages/${messageId}`, {
            headers: { Authorization: `Bearer ${GraphAPI.token}` },
        });

        const responseBody: EmailMessage = (await response.json()) as EmailMessage;
        const body = responseBody.body.content.trim();
        await this.deleteMailsByUsingMessageIds(messageId);
        return body;
    }

    async getAllMessageIdForMailContent(messageHeader: string): Promise<string[]> {
        const request = await GraphAPI.getPlaywrightRequest();
        await GraphAPI.getToken();
        try {
            if (!GraphAPI.token) {
                throw new Error("Authentication token is not available");
            }

            const response = await request.get(
                `${AuthConfig.apiBaseUrl()}/v1.0/me/messages?$search="${encodeURIComponent(messageHeader)}"`,
                {
                    headers: { Authorization: `Bearer ${GraphAPI.token}` },
                },
            );

            if (!response.ok()) {
                throw new Error(`Failed to fetch messages: ${response.status()} ${await response.text()}`);
            }

            const responseBody: MessagesResponse = (await response.json()) as MessagesResponse;

            if (!responseBody.value || responseBody.value.length === 0) {
                return []; // Return empty array if no messages found
            }

            // Extract message IDs using map for cleaner code
            return responseBody.value.map(message => message.id);
        } catch (error) {
            console.error("Error fetching message IDs:", error instanceof Error ? error.message : String(error));
            throw error; // Re-throw to allow caller to handle
        } finally {
            await request.dispose(); // Clean up the request context
        }
    }

    async getEmailBodyWithoutDeletingTheMail(messageId: string): Promise<string> {
        const request = await GraphAPI.getPlaywrightRequest();
        await GraphAPI.getToken();
        if (!GraphAPI.token) throw new Error("Token is null");

        const response = await request.get(`${AuthConfig.apiBaseUrl()}/v1.0/me/messages/${messageId}`, {
            headers: { Authorization: `Bearer ${GraphAPI.token}` },
        });

        const responseBody: EmailMessage = (await response.json()) as EmailMessage;
        return responseBody.body.content.trim();
    }

    async getEmailSubjectWithoutDeletingTheMail(fromEmail: string, toEmail: string): Promise<string> {
        const request = await GraphAPI.getPlaywrightRequest();
        await GraphAPI.getToken();
        try {
            const messageId = await GraphAPI.getMessageIdForMail(fromEmail, toEmail);
            if (!messageId) throw new Error("Message ID is null");
            if (!GraphAPI.token) throw new Error("Token is null");

            const response = await request.get(`${AuthConfig.apiBaseUrl()}/v1.0/me/messages/${messageId}`, {
                headers: { Authorization: `Bearer ${GraphAPI.token}` },
            });

            const responseBody: EmailMessage = (await response.json()) as EmailMessage;
            return responseBody.subject.trim();
        } finally {
            await request.dispose();
        }
    }
}
