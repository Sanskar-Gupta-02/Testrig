import axios from "axios";
import * as fs from "fs";
import * as path from "path";

export class ZephyrUtility {
    private static get headers() {
        return {
            "Authorization": `Bearer ${process.env.ZEPHYR_AUTH_TOKEN}`,
            "Content-Type": "application/json",
        };
    }

    /**
     * Create a new Zephyr Test Cycle
     */
    static async createTestCycle(): Promise<string | null> {
        if (!process.env.ZEPHYR_AUTH_TOKEN || !process.env.ZEPHYR_PROJECT_KEY) {
            console.warn("ZephyrScale skipped: Missing ZEPHYR_AUTH_TOKEN or ZEPHYR_PROJECT_KEY in .env file.");
            return null;
        }

        const request = {
            projectKey: process.env.ZEPHYR_PROJECT_KEY,
            name: `AutomationTestCycle_${process.env.npm_config_PROJECT}_${process.env.npm_config_ENV}_${new Date().toISOString().replace(/[:.]/g, "-")}`,
        };

        try {
            const response = await axios.post(`${process.env.ZEPHYR_BASE_URL}/v2/testcycles`, request, {
                headers: this.headers,
            });
            const data = response.data as { key: string };
            return data.key; // testCycle.key in C#
        } catch (error) {
            throw new Error(`Failed to create test cycle: ${(error as Error).message}`);
        }
    }

    /**
     * Create Test Execution(s) for a given scenario
     */
    static async createTestExecution(scenarioName: string, status: string, testCycleKey: string): Promise<void> {
        if (!process.env.ZEPHYR_AUTH_TOKEN || !process.env.ZEPHYR_PROJECT_KEY) {
            throw new Error("ZephyrScale not initiated: Missing API Token or Project Key");
        }

        let ids: string | undefined;
        try {
            ids = scenarioName.split("#ENG-")[1];
        } catch {
            // Log scenario names that don't follow the expected format
            const filePath = path.join(__dirname, "../../reports/logs/zephyr-missing-ids.txt");
            fs.appendFileSync(filePath, `${scenarioName}\n`);
            return;
        }

        if (!ids) return;

        const idList = ids
            .split(",")
            .map(id => id.trim())
            .filter(id => id.length > 0);

        for (const id of idList) {
            const testExecution = {
                projectKey: process.env.ZEPHYR_PROJECT_KEY,
                testCaseKey: `${process.env.ZEPHYR_PROJECT_KEY}-${id}`,
                testCycleKey,
                statusName: status,
                environmentName: process.env.npm_config_ENV?.toUpperCase() || "STG",
            };

            await axios.post(`${process.env.ZEPHYR_BASE_URL}/v2/testexecutions`, testExecution, {
                headers: this.headers,
            });
        }
    }
}
