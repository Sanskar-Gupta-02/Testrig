import { APIRequestContext, expect } from "@playwright/test";
import { Logger } from "winston";

export const apiFixture = {
    logger: undefined as Logger,
    request: undefined as APIRequestContext,
    expect: expect,
};
