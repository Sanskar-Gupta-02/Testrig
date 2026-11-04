import * as fs from "fs-extra";
import * as path from "path";
import { transports, format } from "winston";

export function getScenarioSafeName(scenarioName: string, scenarioId?: string): string {
    const base = `${scenarioName}${scenarioId ? `-${scenarioId}` : ""}`;
    const sanitized = base
        .normalize("NFKD")
        .replace(/[^\w.-]+/g, "-")
        .replace(/-+/g, "-")
        .replace(/^-+|-+$/g, "")
        .toLowerCase();

    const shortName = sanitized.slice(0, 80) || "scenario";
    const idSuffix = scenarioId ? `-${scenarioId.replace(/[^a-zA-Z0-9]+/g, "").slice(0, 8)}` : "";
    return `${shortName}${idSuffix}`.slice(0, 120);
}

export function options(scenarioName: string, scenarioId?: string) {
    const safeName = getScenarioSafeName(scenarioName, scenarioId);
    const logFilePath = path.resolve(process.cwd(), "reports", "logs", safeName, "log.log");
    fs.ensureDirSync(path.dirname(logFilePath));

    return {
        transports: [
            new transports.File({
                filename: logFilePath,
                level: "info",
                format: format.combine(
                    format.timestamp({ format: "MMM-DDD-YYYY HH:MM:SS" }),
                    format.align(),
                    format.printf((info: { level: string; timestamp: string; message: string }) => {
                        return `${info.level}: ${info.timestamp}: ${info.message}`;
                    }),
                ),
            }),
        ],
    };
}
