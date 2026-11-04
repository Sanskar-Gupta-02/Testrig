import * as path from "path";
import * as fs from "fs";
import { MailpitService } from "../utilities/mailpitAPI";
import { GraphAPI } from "../utilities/graphAPI";

// 1. Load the pairs from JSON
const pairsPath = path.resolve(__dirname, "../../../emailPairs.json");
const emailPairs = JSON.parse(fs.readFileSync(pairsPath, "utf-8")) as { from: string; to: string }[];

async function cleanupAllMailboxes() {
    for (const { from, to } of emailPairs) {
        // Mailpit
        try {
            await new MailpitService().deleteAllMailsByUsingMessageIds(from, to);
            console.log(`[Mailpit] Cleaned: from ${from} to ${to}`);
        } catch (e) {
            console.log(
                `[Mailpit] Skipped or failed for: from ${from} to ${to} (${e instanceof Error ? e.message : e})`,
            );
        }
        // GraphAPI
        try {
            await new GraphAPI().deleteAllMailsByUsingMessageIds(from, to);
            console.log(`[GraphAPI] Cleaned: from ${from} to ${to}`);
        } catch (e) {
            console.log(
                `[GraphAPI] Skipped or failed for: from ${from} to ${to} (${e instanceof Error ? e.message : e})`,
            );
        }
    }
    process.exit(0);
}

cleanupAllMailboxes().catch(err => {
    console.error("Unhandled error in cleanupAllMailboxes:", err);
    process.exit(0);
});
