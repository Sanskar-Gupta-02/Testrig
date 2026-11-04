import { EmailService } from "../Helper/utilities/emailService";

export let emailService: EmailService;

export function setEmailService(service: EmailService): void {
    emailService = service;
}
