import { BeforeAll, Before, After, setDefaultTimeout } from "@cucumber/cucumber";
import { getEnv } from "../env/env";
import { APIRequestContext, request } from "@playwright/test";
import { apiFixture } from "./apifixtures";
import { createLogger } from "winston";
import { options } from "../Helper/utilities/logger";
import { APICommon } from "../Helper/utilities/api.utils";
import { FrameworkConstant } from "../env/frameworkConstant";

setDefaultTimeout(1000 * FrameworkConstant.FrameWorkMaxTime());
BeforeAll(function () {
    getEnv();
});

Before(async function ({ pickle }) {
    const requests: APIRequestContext = await request.newContext({
        baseURL: process.env.APIBASEURL,
        ignoreHTTPSErrors: true,
        extraHTTPHeaders: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
    });
    apiFixture.request = requests;
    apiFixture.logger = createLogger(options(pickle.name + pickle.id));
});

After(function () {
    APICommon.clearStoreData();
});
