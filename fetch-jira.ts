import * as fs from "fs";

const ticket = process.argv[2];
if (!ticket) {
    console.error("Usage: ts-node fetch-jira.ts <TICKET_KEY>");
    process.exit(1);
}

interface JiraDescriptionContent {
    type: string;
    content?: JiraDescriptionContent[];
    text?: string;
}

interface JiraDescription {
    type: string;
    content: JiraDescriptionContent[];
}

interface JiraIssueFields {
    summary: string;
    description?: JiraDescription | string;
    customfield_10176?: string;
    customfield_10177?: string;
    [key: string]: unknown;
}

interface JiraIssueResponse {
    fields: JiraIssueFields;
    [key: string]: unknown;
}

fetch(`https://${process.env.JIRA_DOMAIN}/rest/api/3/issue/${ticket}`, {
    headers: {
        Authorization: "Basic " + Buffer.from(`${process.env.JIRA_EMAIL}:${process.env.JIRA_TOKEN}`).toString("base64"),
        Accept: "application/json",
    },
})
    .then(res => res.json() as Promise<JiraIssueResponse>)
    .then((data: JiraIssueResponse) => {
        const fields = data.fields;
        const description =
            typeof fields.description === "object" && fields.description !== null && "content" in fields.description
                ? fields.description.content
                      .map((block: JiraDescriptionContent) =>
                          Array.isArray(block.content)
                              ? block.content.map((c: JiraDescriptionContent) => c.text ?? "").join(" ")
                              : "",
                      )
                      .join("\n")
                : typeof fields.description === "string"
                  ? fields.description
                  : "";

        // Extract requirements and responses from the description (Atlassian Document Format)
        function flattenADF(adf: unknown): string {
            if (!adf) return "";
            if (typeof adf === "string") return adf;
            if (Array.isArray(adf)) return adf.map(flattenADF).join("\n");
            if (typeof adf === "object" && adf !== null) {
                if ((adf as { content?: unknown }).content) return flattenADF((adf as { content?: unknown }).content);
                if ((adf as { text?: string }).text) return String((adf as { text?: string }).text);
                return Object.values(adf).map(flattenADF).join("\n");
            }
            return "";
        }
        let requirements = "";
        let responses = "";
        let descString = "";
        if (typeof fields.description === "string") {
            descString = fields.description;
        } else if (typeof fields.description === "object" && fields.description !== null) {
            descString = flattenADF(fields.description);
        }
        const reqMatch = descString.match(/Requirements[\r\n]+([\s\S]*?)(?:\n\n|Responses:|$)/i);
        if (reqMatch) requirements = reqMatch[1].trim();
        const respMatch = descString.match(
            /Responses:[\r\n]+([\s\S]*?)(?:\n\n|Acceptance Criteria:|Technical Notes:|$)/i,
        );
        if (respMatch) responses = respMatch[1].trim();

        const result = {
            ticket,
            title: fields.summary,
            description,
            requirements,
            responses,
            acceptance_criteria: flattenADF(fields.customfield_10176).split("\n").filter(Boolean),
            technical_notes: flattenADF(fields.customfield_10177).split("\n").filter(Boolean),
        };
        fs.writeFileSync(`${ticket}.json`, JSON.stringify(result, null, 2));
        console.log(`Saved ticket info to ${ticket}.json`);
    })
    .catch(err => {
        console.error("Error:", err.message);
        process.exit(1);
    });
