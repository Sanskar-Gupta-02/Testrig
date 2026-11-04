import { Dialog, expect, Page } from "@playwright/test";
import { Logger } from "winston";

export const pageFixture = {
    expect: expect,
    page: undefined as Page,
    logger: undefined as Logger,
    dialog: undefined as Dialog,
    currentFeature: undefined as string | undefined,
};
