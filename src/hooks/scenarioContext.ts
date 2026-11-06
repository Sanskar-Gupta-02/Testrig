import { IWorld, world } from "@cucumber/cucumber";
import { APIRequestContext, BrowserContext, Dialog, Page } from "@playwright/test";
import { Logger } from "winston";

export interface ApiResponse {
    status: () => number;
    headers: () => Record<string, string>;
    json: () => Promise<unknown>;
    text: () => Promise<string>;
}

export interface ScenarioContext {
    api: {
        logger?: Logger;
        request?: APIRequestContext;
    };
    page: {
        page?: Page;
        logger?: Logger;
        dialog?: Dialog;
        currentFeature?: string;
        additionalContexts: BrowserContext[];
    };
    stepData: {
        otp?: string;
        firstTab?: Page;
    };
    apiCommon: {
        endPoint: string;
        response: ApiResponse | null;
        pathParam: string;
        queryParams: Record<string, string>;
        requestBody: Record<string, string>;
        headers: Record<string, string>;
        storeData: Record<string, string>;
        rawPayload: unknown;
    };
}

interface ScenarioWorld extends IWorld {
    scenarioContext?: ScenarioContext;
}

const featureStoredData = new Map<string, Record<string, string>>();

export function startScenarioContext(featureUri: string): ScenarioContext {
    let storedData = featureStoredData.get(featureUri);
    if (!storedData) {
        storedData = {};
        featureStoredData.set(featureUri, storedData);
    }

    const state: ScenarioContext = {
        api: {},
        page: {
            additionalContexts: [],
        },
        stepData: {},
        apiCommon: {
            endPoint: "",
            response: null,
            pathParam: "",
            queryParams: {},
            requestBody: {},
            headers: {},
            storeData: storedData,
            rawPayload: null,
        },
    };
    (world as ScenarioWorld).scenarioContext = state;
    return state;
}

export function clearFeatureStoredData(): void {
    featureStoredData.clear();
}

export function getScenarioContext(): ScenarioContext {
    const state = (world as ScenarioWorld).scenarioContext;
    if (!state) {
        throw new Error("Scenario context has not been initialized");
    }
    return state;
}
