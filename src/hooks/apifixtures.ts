import { APIRequestContext, expect } from "@playwright/test";
import { Logger } from "winston";
import { getScenarioContext } from "./scenarioContext";

export const apiFixture = {
    get logger(): Logger {
        const logger = getScenarioContext().api.logger;
        if (!logger) {
            throw new Error("API fixture logger has not been initialized for this scenario");
        }
        return logger;
    },
    set logger(logger: Logger) {
        getScenarioContext().api.logger = logger;
    },
    get request(): APIRequestContext {
        const request = getScenarioContext().api.request;
        if (!request) {
            throw new Error("API request context has not been initialized for this scenario");
        }
        return request;
    },
    set request(request: APIRequestContext) {
        getScenarioContext().api.request = request;
    },
    expect: expect,
};
