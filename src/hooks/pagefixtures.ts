import { Dialog, expect, Page } from "@playwright/test";
import { Logger } from "winston";
import { getScenarioContext } from "./scenarioContext";

export const pageFixture = {
    expect: expect,
    get page(): Page {
        return getScenarioContext().page.page;
    },
    set page(page: Page) {
        getScenarioContext().page.page = page;
    },
    get logger(): Logger {
        return getScenarioContext().page.logger;
    },
    set logger(logger: Logger) {
        getScenarioContext().page.logger = logger;
    },
    get dialog(): Dialog {
        return getScenarioContext().page.dialog;
    },
    set dialog(dialog: Dialog) {
        getScenarioContext().page.dialog = dialog;
    },
    get currentFeature(): string | undefined {
        return getScenarioContext().page.currentFeature;
    },
    set currentFeature(currentFeature: string | undefined) {
        getScenarioContext().page.currentFeature = currentFeature;
    },
};
