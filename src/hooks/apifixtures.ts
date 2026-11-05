import { APIRequestContext, expect } from "@playwright/test";
import { Logger } from "winston";
import { getScenarioContext } from "./scenarioContext";

export const apiFixture = {
    get logger(): Logger {
        return getScenarioContext().api.logger;
    },
    set logger(logger: Logger) {
        getScenarioContext().api.logger = logger;
    },
    get request(): APIRequestContext {
        return getScenarioContext().api.request;
    },
    set request(request: APIRequestContext) {
        getScenarioContext().api.request = request;
    },
    expect: expect,
};
