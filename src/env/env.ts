import * as dotenv from "dotenv";
import * as path from "path";
import * as fs from "fs";

export function getEnv(): void {
    const project = process.env.npm_config_PROJECT || "KYC360";
    const env = process.env.npm_config_ENV || "dev";

    // Load secrets and sensitive config from .env file
    const envFilePath = path.resolve(__dirname, `.env.${project}.${env}`);
    dotenv.config({ path: envFilePath });

    // Load non-sensitive environment-specific IDs from envConfig.json
    const envConfigPath = path.resolve(__dirname, `../testData/${project}/API/${env}/envConfig.json`);
    if (fs.existsSync(envConfigPath)) {
        const envConfig = JSON.parse(fs.readFileSync(envConfigPath, "utf-8")) as Record<string, string>;
        for (const [key, value] of Object.entries(envConfig)) {
            // dotenv.config does not overwrite existing env vars; mirror that behaviour here
            if (process.env[key] === undefined) {
                process.env[key] = value;
            }
        }
    } else {
        console.warn(
            `envConfig.json not found for project "${project}" and environment "${env}" at ${envConfigPath}. ` +
                `Environment-specific values from this file will not be loaded, and any dependent placeholders may remain unresolved.`,
        );
    }
}
