import { EmailService } from "./emailService";
import { GraphAPI } from "./graphAPI";
import { MailpitService } from "./mailpitAPI";

export function getEmailService(): EmailService {
    if (process.env.EMAILSERVICE === "mailpit") {
        return new MailpitService();
    }
    return new GraphAPI();
}

export function getOutlookEmailService(): EmailService {
    return new GraphAPI();
}
