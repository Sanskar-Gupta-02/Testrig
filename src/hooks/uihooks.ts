import { BeforeAll, AfterAll, Before, After, setDefaultTimeout, Status } from "@cucumber/cucumber";
import { Browser, BrowserContext } from "@playwright/test";
import { pageFixture } from "./pagefixtures";
import { invokeBrowser } from "../Helper/browsers/browserManager";
import { getEnv } from "../env/env";
import { createLogger } from "winston";
import { options } from "../Helper/utilities/logger";
import { FrameworkConstant } from "../env/frameworkConstant";
import { saveLocalDateFormatPatternToFile } from "../Helper/utilities/Common.utils";
import { APIRequestContext, request } from "@playwright/test";
import * as path from "path";
import { apiFixture } from "./apifixtures";
import { APICommon } from "../Helper/utilities/api.utils";
import { EmailService } from "../Helper/utilities/emailService";
import { getEmailService } from "../Helper/utilities/emailServiceFactory";
import { ZephyrUtility } from "../Helper/utilities/zephyrUtility";
import { getScenarioContext, startScenarioContext } from "./scenarioContext";

export let emailService: EmailService;

import * as fs from "fs-extra";

let browser: Browser;
let globalTestCycleKey: string | null = null;
setDefaultTimeout(1000 * FrameworkConstant.FrameWorkMaxTime());

BeforeAll(async function () {
    getEnv();
    saveLocalDateFormatPatternToFile();
    browser = await invokeBrowser();
    emailService = getEmailService();
    globalTestCycleKey = await ZephyrUtility.createTestCycle();
});

Before(async function ({ pickle }) {
    startScenarioContext();
    const context = await browser.newContext({
        //viewport: FrameworkConstant.viewportWidthHeight(),
        ignoreHTTPSErrors: true,
        recordVideo: {
            dir: "reports/videos",
        },
    });
    await context.tracing.start({
        screenshots: true,
        snapshots: true,
        sources: true,
    });
    context.setDefaultTimeout(1000 * FrameworkConstant.actionTimeout());
    pageFixture.page = await context.newPage();
    pageFixture.logger = createLogger(options(`${pickle.name}_${pickle.id}`));
    pageFixture.currentFeature = pickle.uri ? path.basename(pickle.uri, ".feature").toLowerCase() : undefined;
    const requests: APIRequestContext = await request.newContext({
        baseURL: process.env.APIBASEURL,
        ignoreHTTPSErrors: true,
        extraHTTPHeaders: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
    });
    apiFixture.request = requests;
    apiFixture.logger = createLogger(options(`${pickle.name}_${pickle.id}`));
    // Ensure artifact directories exist
    fs.ensureDirSync("traces");
    fs.ensureDirSync("reports/screenshots");
    fs.ensureDirSync("reports/videos");

    this.context = context;
    this.browser = browser;
});

async function handleDeleteOnboarding(pickle) {
    const hasTag: boolean = (pickle.tags as { name: string }[]).some(tag => tag.name === "@deleteOnboarding");
    if (!hasTag) return;

    await APICommon.deleteOnboarding();
}

async function handleDeletePkycOnboarding(pickle) {
    const hasTag: boolean = (pickle.tags as { name: string }[]).some(tag => tag.name === "@deletePkycOnboarding");
    if (!hasTag) return;

    await APICommon.deletePkycOnboarding();
}

async function handleDeleteAutocreatedProspect(pickle) {
    const hasTag: boolean = (pickle.tags as { name: string }[]).some(tag => tag.name === "@deleteAutocreatedProspect");
    if (!hasTag) return;

    await APICommon.deleteAutocreatedProspect();
}

async function handleDeletePkycAutocreatedProspect(pickle) {
    const hasTag: boolean = (pickle.tags as { name: string }[]).some(
        tag => tag.name === "@deletePkycAutocreatedProspect",
    );
    if (!hasTag) return;

    await APICommon.deletePkycAutocreatedProspect();
}

async function deleteCreatedProspect(pickle) {
    const hasTag: boolean = (pickle.tags as { name: string }[]).some(tag => tag.name === "@deleteCreatedProspect");
    if (!hasTag) return;

    await APICommon.deleteCreatedProspect();
}

async function handleDeleteAutocreatedOnboarding(pickle) {
    const hasTag: boolean = (pickle.tags as { name: string }[]).some(
        tag => tag.name === "@deleteAutocreatedOnboarding",
    );
    if (!hasTag) return;

    await APICommon.deleteAutocreatedOnboarding();
}

async function handleDeleteDataRequest(pickle) {
    const hasTag: boolean = (pickle.tags as { name: string }[]).some(tag => tag.name === "@deleteDataRequest");
    if (!hasTag) return;

    await APICommon.deleteDataRequest();
}

After(async function ({ pickle, result }) {
    const context = this.context as BrowserContext;
    let apiRequest: APIRequestContext | undefined;
    let videoPathPromise: Promise<string> | undefined;
    let img: Buffer | undefined;
    let videoBuffer: Buffer | undefined;
    const safeName = pickle.name.replace(/[^a-zA-Z0-9]/g, "_");
    const timestamp = Date.now();

    try {
        await handleDeleteOnboarding(pickle);
        await handleDeleteAutocreatedOnboarding(pickle);
        await handleDeleteAutocreatedProspect(pickle);
        await deleteCreatedProspect(pickle);
        await handleDeleteDataRequest(pickle);
        await handleDeletePkycOnboarding(pickle);
        await handleDeletePkycAutocreatedProspect(pickle);

        if (result?.status === Status.FAILED) {
            const tracePath = `traces/${safeName}-${timestamp}.zip`;
            await context.tracing.stop({ path: tracePath });
            console.log(`Trace saved: ${tracePath}`);
            img = await pageFixture.page.screenshot({
                path: `./reports/screenshots/${safeName}-${timestamp}.png`,
            });
        } else {
            await context.tracing.stop();
        }
        videoPathPromise = pageFixture.page.video()?.path();
        console.log(`Scenario: ${pickle.name}, Status: ${result?.status}`);

        if (process.env.ZEPHYR_SCALE_API_RUN_MODE?.toLowerCase() === "true") {
            const status = result?.status === Status.PASSED ? "Pass" : "Fail";
            try {
                await ZephyrUtility.createTestExecution(pickle.name, status, globalTestCycleKey);
                console.log(`📌 Zephyr updated for ${pickle.name} with status ${status}`);
            } catch (err) {
                console.error(`❌ Failed to update Zephyr for ${pickle.name}:`, err);
            }
        }
    } finally {
        apiRequest = getScenarioContext().api.request;
        try {
            await pageFixture.page?.close();
        } finally {
            try {
                await context?.close();
            } finally {
                try {
                    if (apiRequest) {
                        await apiRequest.dispose();
                    }
                } finally {
                    APICommon.clearStoreData();
                }
            }
        }
    }

    if (result?.status === Status.FAILED && videoPathPromise !== undefined) {
        videoBuffer = fs.readFileSync(await videoPathPromise);
    }

    if (result?.status === Status.FAILED) {
        if (img) this.attach(img, "image/png");
        if (videoBuffer) this.attach(videoBuffer, "video/webm");
    }
});

AfterAll(async function () {
    await browser.close();
});
