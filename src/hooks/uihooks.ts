import { BeforeAll, AfterAll, Before, After, setDefaultTimeout, Status } from "@cucumber/cucumber";
import { Browser, BrowserContext } from "@playwright/test";
import { pageFixture } from "./pagefixtures";
import { invokeBrowser } from "../Helper/browsers/browserManager";
import { getEnv } from "../env/env";
import { createLogger } from "winston";
import { getScenarioSafeName, options } from "../Helper/utilities/logger";
import { FrameworkConstant } from "../env/frameworkConstant";
import { saveLocalDateFormatPatternToFile } from "../Helper/utilities/Common.utils";
import { APIRequestContext, request } from "@playwright/test";
import * as path from "path";
import { apiFixture } from "./apifixtures";
import { APICommon } from "../Helper/utilities/api.utils";
import { EmailService } from "../Helper/utilities/emailService";
import { getEmailService } from "../Helper/utilities/emailServiceFactory";
import { ZephyrUtility } from "../Helper/utilities/zephyrUtility";

export let emailService: EmailService;

import * as fs from "fs-extra";

let browser: Browser;
let context: BrowserContext;
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
    context = await browser.newContext({
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
    const hasTag: boolean = (pickle.tags as { name: string }[]).some(tag => tag.name === "@deletePkycAutocreatedProspect");
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
    await handleDeleteOnboarding(pickle);
    await handleDeleteAutocreatedOnboarding(pickle);
    await handleDeleteAutocreatedProspect(pickle);
    await deleteCreatedProspect(pickle);
    await handleDeleteDataRequest(pickle);
    await handleDeletePkycOnboarding(pickle);
    await handleDeletePkycAutocreatedProspect(pickle);
    // Safe filename
    const safeName = pickle.name.replace(/[^a-zA-Z0-9]/g, '_');
    const timestamp = Date.now();
    
    let img: Buffer | undefined;
    let videoBuffer: Buffer | undefined;

        try {
        // STOP TRACING
        if (result?.status === Status.FAILED) {
            const tracePath = `traces/${safeName}-${timestamp}.zip`;

            await context.tracing.stop({
                path: tracePath,
            });
            console.log(`Trace saved: ${tracePath}`);
        } else {
            await context.tracing.stop();
        }
        // Screenshot (on failure)
        if (result?.status === Status.FAILED) {
            img = await pageFixture.page.screenshot({
                path: `./reports/screenshots/${safeName}-${timestamp}.png`
            });
        }
        // Video handling (video is finalized on page/context close)
        var videoPathPromise = pageFixture.page.video()?.path();
    } catch (error) {
        console.error("❌ Error in After Hook:", error);
    }
    // Close resources
    await pageFixture.page.close();
    await context.close();

    if (result?.status === Status.FAILED && videoPathPromise) {
    const videoPath = await videoPathPromise;
    videoBuffer = fs.readFileSync(videoPath);
    }

    // Attach artifacts to report
    if (result?.status === Status.FAILED) {
        if (img) {
            await this.attach(img, "image/png");
        }
        if (videoBuffer) {
            await this.attach(videoBuffer, "video/webm");
        }
    }
    // Logging
    console.log(`Scenario: ${pickle.name}, Status: ${result?.status}`);
    // 🔗 Push execution results to Zephyr Scale
    // Zephyr Integration
    if (process.env.ZEPHYR_SCALE_API_RUN_MODE?.toLowerCase() === "true") {
        const status = result?.status === Status.PASSED ? "Pass" : "Fail";
        const scenarioName = pickle.name;

        try {
            await ZephyrUtility.createTestExecution(scenarioName, status, globalTestCycleKey);
            console.log(`📌 Zephyr updated for ${scenarioName} with status ${status}`);
        } catch (err) {
            console.error(`❌ Failed to update Zephyr for ${scenarioName}:`, err);
        }
    }
    APICommon.clearStoreData();
});

AfterAll(async function () {
    await browser.close();
});