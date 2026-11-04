export interface EmailService {
    getOtp(from: string, to: string): Promise<string>;
    getLink(from: string, to: string): Promise<string>;
    getLinkCustomMail(from: string, to: string): Promise<string>;
    downloadAttachments(from: string, to: string, fileName: string): Promise<void>;
    verifyEmailSubject(from: string, to: string): Promise<string>;
    verifyEmailBodyPreview(from: string, to: string): Promise<string>;
    verifyEmailBody(from: string, to: string): Promise<string>;
    getAllMessageIdForMailContent(messageID: string): Promise<string[]>;
    getEmailBodyWithoutDeletingTheMail(messageId: string): Promise<string>;
    deleteAllMailsByUsingMessageIds(fromEmail?: string, toEmail?: string): Promise<void>;
    getEmailSubjectWithoutDeletingTheMail(fromEmail: string, toEmail: string): Promise<string>;
}
