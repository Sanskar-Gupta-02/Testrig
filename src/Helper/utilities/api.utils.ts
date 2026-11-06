import * as fs from "fs/promises";
import * as path from "path";
import { diff } from "deep-diff";
import Ajv, { JSONSchemaType } from "ajv";
// eslint-disable-next-line @typescript-eslint/no-require-imports
import isEqual = require("lodash.isequal");
import { DateTime } from "ts-luxon";
import { apiFixture } from "../../hooks/apifixtures";
import FormData from "form-data";
import { pageFixture } from "../../hooks/pagefixtures";
import { ApiResponse, getScenarioContext } from "../../hooks/scenarioContext";

interface StoreData {
    [key: string]: string;
}

type HeaderType = Record<string, string>;
type JsonType = Record<string, unknown>;

type FileInput = {
    file: string;
    mimeType?: string;
};

class APICommon {
    // Stores the API endpoint URL for making requests.
    private static get endPoint(): string {
        return getScenarioContext().apiCommon.endPoint;
    }
    private static set endPoint(value: string) {
        getScenarioContext().apiCommon.endPoint = value;
    }
    // Stores the response received from the API after making a request.
    private static get response(): ApiResponse | null {
        return getScenarioContext().apiCommon.response;
    }
    private static set response(value: ApiResponse | null) {
        getScenarioContext().apiCommon.response = value;
    }
    // Stores the path parameter to be appended to the endpoint.
    private static get pathParam(): string {
        return getScenarioContext().apiCommon.pathParam;
    }
    private static set pathParam(value: string) {
        getScenarioContext().apiCommon.pathParam = value;
    }
    // Stores query parameters as key-value pairs for GET requests or any API request needing query parameters.
    private static get queryParams(): Record<string, string> {
        return getScenarioContext().apiCommon.queryParams;
    }
    private static set queryParams(value: Record<string, string>) {
        getScenarioContext().apiCommon.queryParams = value;
    }
    // Stores the request body as a key-value object for POST, PUT, PATCH, or DELETE requests.
    private static get requestBody(): Record<string, string> {
        return getScenarioContext().apiCommon.requestBody;
    }
    private static set requestBody(value: Record<string, string>) {
        getScenarioContext().apiCommon.requestBody = value;
    }
    // Stores request headers as key-value pairs to be included in API requests.
    private static get headers(): Record<string, string> {
        return getScenarioContext().apiCommon.headers;
    }
    private static set headers(value: Record<string, string>) {
        getScenarioContext().apiCommon.headers = value;
    }
    // Stores data extracted from API responses for reuse in future API requests.
    private static get storeData(): StoreData {
        return getScenarioContext().apiCommon.storeData;
    }
    private static set storeData(value: StoreData) {
        getScenarioContext().apiCommon.storeData = value;
    }
    private static get rawPayload(): unknown {
        return getScenarioContext().apiCommon.rawPayload;
    }
    private static set rawPayload(value: unknown) {
        getScenarioContext().apiCommon.rawPayload = value;
    }

    // Constructs the file path for API test data based on the project and environment variables.
    private static apiTestdataFolderpath = path.join(
        __dirname,
        `../../testData/${process.env.npm_config_PROJECT || "KYC360"}/API/${process.env.npm_config_ENV || "stg"}/`,
    );

    private constructor() { }

    public static setAPIServie(endPoint: string): void {
        const regex = /<([^>]+)>/g;

        this.endPoint = endPoint.replace(regex, (match, p1) => {
            switch (p1) {
                case "TenantID":
                    return process.env.tenantId || "";
                case "TenantID2":
                    return process.env.TenantID2 || "";
                case "InvalidTenantID":
                    return process.env.invalidTenantId || "";
                case "UserID":
                    return process.env.UserID || "";
                default: {
                    const envVal = process.env[p1] ?? process.env[p1.toLowerCase()] ?? process.env[p1.toUpperCase()];
                    return envVal !== undefined ? envVal : this.storeData[p1] || "";
                }
            }
        });

        apiFixture.logger.info(`Endpoint : ${this.endPoint}`);
    }

    public static setAPIServieForRunTime(endPoint: string): void {
        const regex = /<([^>:]+)(?::([^>]+))?>/g;

        this.endPoint = endPoint.replace(regex, (_, key: string, defaultValue?: string) => {
            const envValue = [process.env[key], process.env[key.toLowerCase()], process.env[key.toUpperCase()]].find(
                value => value !== undefined,
            );

            const storedValue = this.storeData[key];
            const resolvedValue = envValue ?? storedValue ?? defaultValue;
            if (resolvedValue === undefined || resolvedValue === null) {
                throw new Error(`No value found for <${key}> and no default provided`);
            }
            return String(resolvedValue);
        });
        apiFixture.logger.info(`Resolved Endpoint: ${this.endPoint}`);
    }

    public static setHeaders(key: string, value: string): void {
        this.headers = { ...this.headers, [key]: value };
        apiFixture.logger.info(`API Headers : ${JSON.stringify(this.headers)}`);
    }

    public static setHeadersWithStoredKey(key: string, storedKey: string): void {
        if (!(storedKey in this.storeData)) {
            throw new Error(`Stored key "${storedKey}" not found`);
        }
        this.headers = { ...this.headers, [key]: this.storeData[storedKey] };
        apiFixture.logger.info(`API Headers : ${JSON.stringify(this.headers)}`);
    }

    public static setJsonHeaders(headerJson: string): void {
        try {
            const newHeaders: HeaderType = JSON.parse(headerJson) as HeaderType;
            this.headers = { ...this.headers, ...newHeaders };
            apiFixture.logger.info(`API Headers : ${JSON.stringify(this.headers)}`);
        } catch (error) {
            throw new Error(`Invalid JSON format in headers: ${(error as Error).message}`);
        }
    }

    public static setJsonHeadersWithStoredKey(headerJson: string, storedKey: string): void {
        try {
            const newHeaders: JsonType = JSON.parse(headerJson) as JsonType;
            if (newHeaders.search && newHeaders.search === "<value>" && storedKey in this.storeData) {
                newHeaders.search = this.storeData[storedKey];
            }
            this.headers = { ...this.headers, ...(newHeaders as Record<string, string>) };
            apiFixture.logger.info(`API Headers : ${JSON.stringify(this.headers)}`);
        } catch (error) {
            throw new Error(`Invalid JSON format in headers: ${(error as Error).message}`);
        }
    }

    public static setPathParam(value: string): void {
        this.pathParam = value;
        apiFixture.logger.info(`API path param : ${this.pathParam}`);
    }

    public static setPathParamWithStoredKey(storedKey: string): void {
        if (!(storedKey in this.storeData)) {
            throw new Error(`Stored key "${storedKey}" not found`);
        }
        this.pathParam = this.storeData[storedKey];
        apiFixture.logger.info(`API path param : ${this.pathParam}`);
    }

    public static setQueryParams(key: string, value: string): void {
        this.queryParams = { ...this.queryParams, [key]: value };
        apiFixture.logger.info(`Updated Query Params: ${JSON.stringify(this.queryParams, null, 2)}`);
    }

    public static setQueryParamsWithStoredKey(key: string, storedKey: string): void {
        if (!(storedKey in this.storeData)) {
            throw new Error(`Key "${storedKey}" not found in storeData`);
        }
        this.queryParams = { ...this.queryParams, [key]: this.storeData[storedKey] };
        apiFixture.logger.info(`Updated Query Params: ${JSON.stringify(this.queryParams)}`);
    }

    public static setJSONQueryParams(queryJson: string): void {
        try {
            const newQueryParams: HeaderType = JSON.parse(queryJson) as HeaderType;
            this.queryParams = { ...this.queryParams, ...newQueryParams };
            apiFixture.logger.info(`Updated Query Params: ${JSON.stringify(this.queryParams, null, 2)}`);
        } catch (error) {
            throw new Error(`Invalid JSON format in QueryParams: ${(error as Error).message}`);
        }
    }

    public static setJSONQueryParamsWithStoredKey(queryJson: string, storedKey: string): void {
        try {
            const newQueryParams: JsonType = JSON.parse(queryJson) as JsonType;
            if (newQueryParams.search && newQueryParams.search === "<value>" && storedKey in this.storeData) {
                newQueryParams.search = this.storeData[storedKey];
            }
            this.queryParams = { ...this.queryParams, ...(newQueryParams as Record<string, string>) };
            apiFixture.logger.info(`Updated Query Params: ${JSON.stringify(this.queryParams)}`);
        } catch (error) {
            throw new Error(`Invalid JSON format in QueryParams: ${(error as Error).message}`);
        }
    }

    public static setRequestBody(key: string, value: string): void {
        this.requestBody = { ...this.requestBody, [key]: value };
        apiFixture.logger.info(`Payload: ${JSON.stringify(this.requestBody, null, 2)}`);
    }

    public static setRequestBodyWithStoredKey(key: string, storedKey: string): void {
        if (!(storedKey in this.storeData)) {
            throw new Error(`Stored key "${storedKey}" not found`);
        }
        this.requestBody = { ...this.requestBody, [key]: this.storeData[storedKey] };
        apiFixture.logger.info(`Payload: ${JSON.stringify(this.requestBody, null, 2)}`);
    }

    public static setRawRequestBodyWithStoredKey(key: string, storedKey: string): void {
        if (!(storedKey in this.storeData)) {
            throw new Error(`Stored key "${storedKey}" not found`);
        }
        this.rawPayload = { ...(this.rawPayload as Record<string, unknown>), [key]: this.storeData[storedKey] };
        apiFixture.logger.info(`Payload: ${JSON.stringify(this.rawPayload, null, 2)}`);
    }

    public static setJsonRequestBody(requestBody: string): void {
        try {
            const newRequestBody: HeaderType = JSON.parse(requestBody) as HeaderType;
            this.requestBody = { ...this.requestBody, ...newRequestBody };
            apiFixture.logger.info(`Payload: ${JSON.stringify(this.requestBody, null, 2)}`);
        } catch (error) {
            throw new Error(`Invalid JSON format in requestBody: ${(error as Error).message}`);
        }
    }

    private static resolveEnvPlaceholders(value: string): string {
        return value.replace(/<([^>]+)>/g, (match, key) => {
            const envValue = process.env[key] ?? process.env[key.toLowerCase()] ?? process.env[key.toUpperCase()];
            if (envValue !== undefined) return envValue;
            const storedValue = this.storeData[key];
            return storedValue !== undefined ? storedValue : match;
        });
    }

    public static setJsonRawBody(rawBody: string): void {
        try {
            rawBody = this.resolveEnvPlaceholders(rawBody);
            const newRequestBody: unknown = JSON.parse(rawBody);
            if (Array.isArray(newRequestBody)) {
                if (Array.isArray(newRequestBody)) {
                    this.rawPayload = [...((this.rawPayload as unknown[]) || []), ...(newRequestBody as unknown[])];
                } else {
                    throw new Error("Invalid type: newRequestBody must be an array");
                }
            } else if (typeof newRequestBody === "object" && newRequestBody !== null) {
                this.rawPayload = { ...(this.rawPayload as Record<string, unknown>), ...newRequestBody };
            }
            apiFixture.logger.info(`Payload: ${JSON.stringify(this.rawPayload, null, 2)}`);
        } catch (error) {
            throw new Error(`Invalid JSON format in requestBody: ${(error as Error).message}`);
        }
    }

    public static setJsonRequestBodyWithStoredKey(requestBody: string, storedKey: string): void {
        try {
            const newRequestBody: JsonType = JSON.parse(requestBody) as JsonType;
            if (newRequestBody.search && newRequestBody.search === "<value>" && storedKey in this.storeData) {
                newRequestBody.search = this.storeData[storedKey];
            }
            this.requestBody = newRequestBody as Record<string, string>;
            apiFixture.logger.info(`Payload: ${JSON.stringify(this.requestBody)}`);
        } catch (error) {
            throw new Error(`Invalid JSON format in requestBody: ${(error as Error).message}`);
        }
    }

    public static async getFilePayload<T>(filename: string): Promise<T> {
        const filePath = this.apiTestdataFolderpath + `${filename}.json`;
        try {
            const raw = await fs.readFile(filePath, "utf8");
            const data = this.resolveEnvPlaceholders(raw);
            return JSON.parse(data).payload as T;
        } catch (error) {
            throw new Error(`Error reading file: ${filePath} - ${(error as Error).message}`);
        }
    }

    public static async getFileSelectedPayload<T extends Record<string, unknown>>(
        filename: string,
        keys: string,
    ): Promise<string> {
        const payload = await this.getFilePayload<T>(filename);
        const selectedKeys = keys.split(",").map(key => key.trim());
        const filteredPayload: Partial<T> = {};

        for (const key of selectedKeys) {
            if (key in payload) {
                (filteredPayload as Record<string, unknown>)[key] = payload[key];
            } else {
                apiFixture.logger.warn(`Key "${key}" not found in payload`);
            }
        }

        return JSON.stringify(filteredPayload);
    }

    public static async getResponseValueFromFile<T>(filename: string, key: string): Promise<unknown> {
        const keys = key.split(".");
        const actualValue: unknown = await this.getFilePayload<T>(filename); // Pass filename, not filePath
        let foundValue;

        for (const k of keys) {
            if (actualValue && Object.prototype.hasOwnProperty.call(actualValue, k)) {
                foundValue = (await actualValue[k]) as unknown;
                return await foundValue;
            }
        }
        if (foundValue !== undefined) {
            return foundValue;
        } else {
            apiFixture.logger.info(`Key not found in payload`);
        }
    }

    public static async getResponseValueFromFileByIndex<T extends Record<string, unknown>>(
        filename: string,
        index: number,
        key: string,
    ): Promise<unknown> {
        try {
            const filePayload = await this.getFilePayload<T[]>(filename);
            if (index < 1 || index > filePayload.length) {
                throw new Error(`Index ${index} is out of bounds for payload array (length: ${filePayload.length})`);
            }
            const item = filePayload[index - 1];
            if (!item) {
                throw new Error(`Item at index ${index - 1} is undefined`);
            }
            const keys = key.split(".");
            let currentValue: unknown = item;
            for (const k of keys) {
                if (currentValue === null || typeof currentValue !== "object") {
                    throw new Error(`Cannot access property '${k}' on non-object value`);
                }

                if (!(k in currentValue)) {
                    throw new Error(`Key '${k}' not found in payload structure`);
                }

                currentValue = (currentValue as Record<string, unknown>)[k];
            }
            return currentValue;
        } catch (error) {
            apiFixture.logger.error(
                `Failed to get value from file '${filename}' at index ${index} for key '${key}': ${error instanceof Error ? error.message : String(error)
                }`,
            );
            throw error;
        }
    }

    public static async getFileSchema<T>(filename: string): Promise<T> {
        const filePath = this.apiTestdataFolderpath + `${filename}.json`;
        try {
            const raw = await fs.readFile(filePath, "utf8");
            const data = this.resolveEnvPlaceholders(raw);
            return JSON.parse(data).schema as T;
        } catch (error) {
            throw new Error(`Error reading file: ${filePath} - ${(error as Error).message}`);
        }
    }

    public static async getExpectedJson<T>(filename: string): Promise<T> {
        const filePath = this.apiTestdataFolderpath + `${filename}.json`;
        try {
            const raw = await fs.readFile(filePath, "utf8");
            const data = this.resolveEnvPlaceholders(raw);
            return JSON.parse(data).expectedData as T;
        } catch (error) {
            throw new Error(`Error reading file: ${filePath} - ${(error as Error).message}`);
        }
    }

    public static async updatePayload(filename: string, key: string, value: string): Promise<void> {
        const jsonPayload = await this.getFilePayload<Record<string, string>>(filename);
        jsonPayload[key] = value;
        this.requestBody = { ...this.requestBody, ...jsonPayload };
        apiFixture.logger.info(`Payload: ${JSON.stringify(this.requestBody, null, 2)}`);
    }

    public static async setFilePayload(filename: string): Promise<void> {
        const jsonPayload = await this.getFilePayload<Record<string, string>>(filename);
        this.requestBody = { ...this.requestBody, ...jsonPayload };
        apiFixture.logger.info(`Payload: ${JSON.stringify(this.requestBody, null, 2)}`);
    }

    public static async setRawFilePayload(filename: string, updates?: Record<string, string>): Promise<void> {
        const jsonPayload = await this.getFilePayload<Record<string, string>>(filename);

        if (Array.isArray(jsonPayload)) {
            this.rawPayload = [...((this.rawPayload as unknown[]) || []), ...jsonPayload];
        } else if (typeof jsonPayload === "object" && jsonPayload !== null) {
            this.rawPayload = { ...(this.rawPayload as Record<string, unknown>), ...jsonPayload };
        }

        if (updates) {
            const resolvedUpdates: Record<string, unknown> = {};
            for (const key in updates) {
                let value = updates[key].replace("<currentDateStamp>", DateTime.now().toFormat("yyyy-MM-dd"));
                if (value.startsWith("stored:")) {
                    const storedKey = value.replace("stored:", "").trim();
                    value = this.getStoredData(storedKey);
                }
                resolvedUpdates[key] = value;
            }
            this.rawPayload = this.updateRawPayload(this.rawPayload, resolvedUpdates);
        }
        apiFixture.logger.info(`Updated Payload: ${JSON.stringify(this.rawPayload, null, 2)}`);
    }

    public static async setRawFilePayloadByKey(filename: string, payloadKey: string): Promise<void> {
        const payloads = await this.getFilePayload<Record<string, unknown>>(filename);
        if (!Object.prototype.hasOwnProperty.call(payloads, payloadKey)) {
            throw new Error(`Payload key "${payloadKey}" not found in file "${filename}".`);
        }

        const payload = payloads[payloadKey];
        if (typeof payload !== "object" || payload === null || Array.isArray(payload)) {
            throw new Error(`Payload key "${payloadKey}" in file "${filename}" must contain a JSON object.`);
        }

        this.setJsonRawBody(JSON.stringify(payload));
    }

    public static async updatePayloadWithStoredKey(filename: string, key: string, storedKey: string): Promise<void> {
        const jsonPayload = await this.getFilePayload<Record<string, string>>(filename);
        if (!(storedKey in this.storeData)) {
            throw new Error(`Stored key "${storedKey}" not found`);
        }
        jsonPayload[key] = this.storeData[storedKey];
        this.requestBody = jsonPayload;
        apiFixture.logger.info(`Payload: ${JSON.stringify(this.requestBody, null, 2)}`);
    }

    public static async sendRequest(requestType: string): Promise<void> {
        this.response = null;
        const pathParam = this.pathParam ?? "";
        const queryParams = this.replaceDateStampAndConvertToJson(this.queryParams) as {
            [key: string]: string | number | boolean;
        };
        const headers = this.replaceDateStampAndConvertToJson(this.headers) ?? {};
        const requestBody = this.replaceDateStampAndConvertToJson(this.requestBody) ?? {};
        const rawPayload = this.replaceDateStampAndConvertToJson(this.rawPayload as Record<string, string>) ?? {};
        const url = this.endPoint + pathParam;
        const isExplicitEmptyJson =
            this.rawPayload !== null &&
            typeof this.rawPayload === "object" &&
            !Array.isArray(this.rawPayload) &&
            Object.keys(this.rawPayload).length === 0;

        if (
            (!this.rawPayload ||
                (typeof this.rawPayload === "object" && Object.keys(this.rawPayload).length === 0)) &&
            !isExplicitEmptyJson
        ) {
            switch (requestType.toUpperCase()) {
                case "GET":
                    this.response = await apiFixture.request.get(url, { params: queryParams, headers });
                    break;
                case "POST":
                    this.response = await apiFixture.request.post(url, {
                        params: queryParams,
                        headers,
                        form: requestBody,
                    });
                    break;
                case "PUT":
                    this.response = await apiFixture.request.put(url, {
                        params: queryParams,
                        headers,
                        form: requestBody,
                    });
                    break;
                case "DELETE":
                    this.response = await apiFixture.request.delete(url, {
                        params: queryParams,
                        headers,
                        form: requestBody,
                    });
                    break;
                case "PATCH":
                    this.response = await apiFixture.request.patch(url, {
                        params: queryParams,
                        headers,
                        form: requestBody,
                    });
                    break;
                default:
                    throw new Error(`Invalid HTTP method: ${requestType}`);
            }
        } else {
            switch (requestType.toUpperCase()) {
                case "GET":
                    this.response = await apiFixture.request.get(url, { params: queryParams, headers });
                    break;
                case "POST":
                    this.response = await apiFixture.request.post(url, {
                        params: queryParams,
                        headers,
                        data: JSON.stringify(rawPayload),
                    });
                    break;
                case "PUT":
                    this.response = await apiFixture.request.put(url, {
                        params: queryParams,
                        headers,
                        data: JSON.stringify(rawPayload),
                    });
                    break;
                case "DELETE":
                    this.response = await apiFixture.request.delete(url, {
                        params: queryParams,
                        headers,
                        data: JSON.stringify(rawPayload),
                    });
                    break;
                case "PATCH":
                    this.response = await apiFixture.request.patch(url, {
                        params: queryParams,
                        headers,
                        data: JSON.stringify(rawPayload),
                    });
                    break;
                default:
                    throw new Error(`Invalid HTTP method: ${requestType}`);
            }
        }
    }

    public static async checkResponseStatusCode(statusCode: number): Promise<void> {
        let responseContent: string = "[No response]";
        let requestDetails = "";
        if (!this.response) {
            apiFixture.logger.error(`No response received. Expected status code: ${statusCode}`);
            throw new Error(`No response received from API. Expected status code: ${statusCode}`);
        }
        try {
            const json = await this.response.json();
            responseContent = JSON.stringify(json, null, 2);
        } catch {
            try {
                responseContent = await this.response.text();
            } catch {
                responseContent = "[Unable to read response / No response]";
            }
        }
        // Log request details if available
        requestDetails = `Request Details:\nEndpoint: ${this.endPoint}${this.pathParam}\nQueryParams: ${JSON.stringify(this.queryParams)}\nRequestBody: ${JSON.stringify(this.requestBody)}\nRawPayload: ${JSON.stringify(this.rawPayload)}`;
        apiFixture.logger.info(`Response: ${responseContent}`);
        const actualStatus = this.response.status();
        if (actualStatus !== statusCode) {
            apiFixture.logger.error(`Status code mismatch. Expected: ${statusCode}, Received: ${actualStatus}`);
            throw new Error(
                `Status code mismatch. Expected: ${statusCode}, Received: ${actualStatus}\n${requestDetails}\nResponse: ${responseContent}`,
            );
        }
        apiFixture.expect(actualStatus).toBe(statusCode);
    }

    public static checkResponseHeader(key: string, value: string): void {
        if (!this.response) {
            apiFixture.logger.error(`No response available when checking header '${key}'.`);
            throw new Error(`No response available when checking header '${key}'.`);
        }
        const headers = this.response.headers();
        const expectedValue = value.replace("<currentDateStamp>", DateTime.now().toFormat("yyyy-MM-dd"));
        const actualValue = headers[key];
        // Log request and response headers
        if (actualValue !== expectedValue) {
            apiFixture.logger.error(
                `Header mismatch for '${key}'. Expected: ${expectedValue}, Received: ${actualValue}`,
            );
            throw new Error(
                `Header mismatch for '${key}'. Expected: ${expectedValue}, Received: ${actualValue}\nRequest Headers: ${JSON.stringify(this.headers)}\nResponse Headers: ${JSON.stringify(headers)}`,
            );
        }
        apiFixture.expect(actualValue).toBe(expectedValue);
    }

    private static async validateResponseAndSchema<T>(schema: JSONSchemaType<T>): Promise<boolean> {
        if (!this.response) throw new Error("No response available");
        const ajv = new Ajv();
        const validate = ajv.compile(schema);
        const responseData = await this.response.json();
        const valid = validate(responseData);
        if (!valid) {
            apiFixture.logger.error("Schema validation errors:", validate.errors);
        }
        return valid;
    }

    private static async validateResponseWithExpectedJson<T>(expectedJsonFilename: string): Promise<boolean> {
        if (!this.response) throw new Error("No response available");
        const actualData: T = (await this.response.json()) as T;
        const expectedData: T = await this.getExpectedJson<T>(expectedJsonFilename);
        const isMatch = isEqual(actualData, expectedData);
        if (!isMatch) {
            const difference = diff(expectedData, actualData);
            apiFixture.logger.info("Actual response does not match expected JSON.\n Diff:\n", difference);
        }
        return isMatch;
    }

    public static async validateResponseSchema(fileName: string): Promise<void> {
        apiFixture.expect(await this.validateResponseAndSchema(await this.getFileSchema(fileName))).toBeTruthy();
    }

    public static async validateResponseData<T>(fileName: string): Promise<void> {
        apiFixture.expect(await this.validateResponseWithExpectedJson<T>(fileName)).toBeTruthy();
    }

    public static async validateResponseBodyContains(containsText: string): Promise<void> {
        if (!this.response) throw new Error("No response available");
        const responseBody = await this.response.json();
        const responseText = JSON.stringify(responseBody);
        const expectedStr = containsText.replace("<currentDateStamp>", DateTime.now().toFormat("yyyy-MM-dd"));
        if (!responseText.includes(expectedStr)) {
            apiFixture.logger.error(`Expected: '${expectedStr}' is not in Response: '${responseText}'`);
            throw new Error(`Expected: '${expectedStr}' is not in Response: '${responseText}'`);
        }
        apiFixture.expect(responseText).toContain(expectedStr);
    }

    public static async validateResponseBodyTextContains(containsText: string): Promise<void> {
        if (!this.response) throw new Error("No response available");
        const responseText = await this.response.text();
        const expectedStr = containsText.replace("<currentDateStamp>", DateTime.now().toFormat("yyyy-MM-dd"));
        if (!responseText.includes(expectedStr)) {
            apiFixture.logger.error(`Expected: '${expectedStr}' is not in Response: '${responseText}'`);
            throw new Error(`Expected: '${expectedStr}' is not in Response: '${responseText}'`);
        }
        apiFixture.expect(responseText).toContain(expectedStr);
    }

    public static async validateResponseBodyKeyValue(key: string, value: unknown): Promise<void> {
        if (!this.response) throw new Error("No response available");
        const responseBody = (await this.response.json()) as Record<string, unknown>;

        // Replace placeholder with current date and env vars
        // Replace placeholder with current date and env vars
        if (typeof value === "string") {
            value = (value as string).replace("<currentDateStamp>", DateTime.now().toFormat("yyyy-MM-dd"));
            value = this.resolveEnvPlaceholders(value as string);
            value = (value as string).replace("<currentDateStamp>", DateTime.now().toFormat("yyyy-MM-dd"));
            value = this.resolveEnvPlaceholders(value as string);
        }
        const keys = key.split(".");
        let actualValue: unknown = responseBody;

        for (const k of keys) {
            if (typeof actualValue !== "object" || actualValue === null) {
                actualValue = undefined;
                break;
            }
            actualValue = (actualValue as Record<string, unknown>)[k];
        }
        const actualStr = this.convertToString(actualValue);
        const expectedStr = this.convertToString(value);
        if (actualStr !== expectedStr) {
            apiFixture.logger.error(
                `Key value mismatch for '${key}'. Expected: '${expectedStr}', Actual: '${actualStr}'`,
            );
            throw new Error(`Key value mismatch for '${key}'.\nExpected: '${expectedStr}'\nActual: '${actualStr}`);
        }
        apiFixture.expect(actualStr).toBe(expectedStr);
    }

    private static convertToString(value: unknown): string {
        if (value === undefined) return "undefined";
        if (value === null) return "null";

        switch (typeof value) {
            case "string":
                return value;
            case "number":
            case "boolean":
            case "bigint":
            case "symbol":
                return String(value);
            case "object":
                if (Array.isArray(value)) {
                    return JSON.stringify(value);
                }
                if (value instanceof Date) {
                    return value.toISOString();
                }
                return JSON.stringify(value);
            case "function":
                return "[function]";
            default:
                return "[unknown type]";
        }
    }

    public static async validateSecondResponseBodyKeyValue(index: number, key: string, value: unknown): Promise<void> {
        if (!this.response) throw new Error("No response available");
        const responseBody = (await this.response.json()) as Array<Record<string, unknown>>;
        const actualStr = this.convertToString(responseBody[index - 1][key]);
        const expectedStr = this.convertToString(value).replace(
            "<currentDateStamp>",
            DateTime.now().toFormat("yyyy-MM-dd"),
        );
        if (actualStr !== expectedStr) {
            apiFixture.logger.error(
                `Validation failed for index "${index}" with key "${key}".\nExpected: '${expectedStr}'\nActual: '${actualStr}`,
            );
            throw new Error(
                `Validation failed for index "${index}" with key "${key}".\nExpected: '${expectedStr}'\nActual: '${actualStr}`,
            );
        }
        apiFixture.expect(actualStr).toBe(expectedStr);
    }

    public static async validateDescendingOrderResponseBodyContainsKeyValue(
        descendingOrder: number,
        key: string,
        value: string,
    ): Promise<void> {
        const actualStr = this.convertToString(await this.getKey(key, descendingOrder));
        const expectedStr = this.convertToString(value);
        if (actualStr !== expectedStr) {
            apiFixture.logger.error(
                `Key value mismatch for '${key}'. Expected: '${expectedStr}', Actual: '${actualStr}'`,
            );
            throw new Error(`Key value mismatch for '${key}'.\nExpected: '${expectedStr}'\nActual: '${actualStr}`);
        }
        apiFixture.expect(actualStr).toBe(expectedStr);
    }

    public static async validateResponseBodyKeyWithStoredValue(key: string, storedKey: string): Promise<void> {
        if (!this.response) throw new Error("No response available");
        const responseBody = (await this.response.json()) as Record<string, unknown>;
        const keys = key.split(".");
        let actualValue: unknown = responseBody;

        for (const k of keys) {
            if (typeof actualValue !== "object" || actualValue === null) {
                actualValue = undefined;
                break;
            }
            actualValue = (actualValue as Record<string, unknown>)[k];
        }
        const actualStr = this.convertToString(actualValue);
        const expectedStr = this.getStoredData(storedKey);
        if (actualStr !== expectedStr) {
            apiFixture.logger.error(
                `Key value mismatch for '${key}'. Expected: '${expectedStr}', Actual: '${actualStr}'`,
            );
            throw new Error(`Key value mismatch for '${key}'.\nExpected: '${expectedStr}'\nActual: '${actualStr}`);
        }
        apiFixture.expect(actualStr).toBe(expectedStr);
    }

    public static async validateResponseBodyKeyWithMessage(key: string, message: string): Promise<void> {
        if (!this.response) throw new Error("No response available");
        const responseBody = (await this.response.json()) as Record<string, unknown>;
        const keys = key.split(".");
        let actualValue: unknown = responseBody;

        for (const k of keys) {
            if (typeof actualValue !== "object" || actualValue === null) {
                actualValue = undefined;
                break;
            }
            actualValue = (actualValue as Record<string, unknown>)[k];
        }
        const actualStr = this.convertToString(actualValue);
        if (actualStr !== message) {
            apiFixture.logger.error(`Key value mismatch for '${key}'. Expected: '${message}', Actual: '${actualStr}'`);
            throw new Error(`Key value mismatch for '${key}'.\nExpected: '${message}'\nActual: '${actualStr}`);
        }
        apiFixture.expect(actualStr).toBe(message);
    }

    public static async getKey(key: string, descendingOrder: number): Promise<unknown> {
        if (!this.response) throw new Error("No response available");
        const responseBody = (await this.response.json()) as Record<string, unknown>;
        const keys = key.split(".");
        let actualValue: unknown = responseBody;

        for (const k of keys) {
            if (keys[keys.length - 1] === k) {
                if (Array.isArray(actualValue)) {
                    actualValue = actualValue[actualValue.length - descendingOrder];
                    if (typeof actualValue === "object" && actualValue !== null) {
                        actualValue = (actualValue as Record<string, unknown>)[k];
                    }
                } else if (typeof actualValue === "object" && actualValue !== null) {
                    actualValue = (actualValue as Record<string, unknown>)[k];
                }
            } else if (typeof actualValue === "object" && actualValue !== null) {
                actualValue = (actualValue as Record<string, unknown>)[k];
            }
        }
        return actualValue;
    }

    public static async validateDescendingOrderResponseBodyContainsStoredKeyValue(
        descendingOrder: number,
        key: string,
        storedKey: string,
    ): Promise<void> {
        const actualStr = this.convertToString(await this.getKey(key, descendingOrder));
        const expectedStr = this.getStoredData(storedKey);
        if (actualStr !== expectedStr) {
            apiFixture.logger.error(
                `Key value mismatch for '${key}'. Expected: '${expectedStr}', Actual: '${actualStr}'`,
            );
            throw new Error(`Key value mismatch for '${key}'.\nExpected: '${expectedStr}'\nActual: '${actualStr}`);
        }
        apiFixture.expect(actualStr).toBe(expectedStr);
    }

    public static async validateSecondResponseBodyKeyWithStoredValue(
        index: number,
        key: string,
        storedKey: string,
    ): Promise<void> {
        if (!this.response) throw new Error("No response available");
        const responseBody = (await this.response.json()) as Array<Record<string, unknown>>;
        const actualStr = this.convertToString(responseBody[index - 1][key]);
        const expectedStr = this.getStoredData(storedKey);
        if (actualStr !== expectedStr) {
            apiFixture.logger.error(
                `Value mismatch for Index:'${index}' Key:'${key}'. Expected: '${expectedStr}', Actual: '${actualStr}'`,
            );
            throw new Error(
                `Value mismatch for Index:'${index}' Key:'${key}'.\nExpected: '${expectedStr}'\nActual: '${actualStr}`,
            );
        }
        apiFixture.expect(actualStr).toBe(expectedStr);
    }

    public static async storeResponseDataForNextAPI(responseBodykey: string, storeKey: string): Promise<void> {
        if (!this.response) throw new Error("No response available");
        const responseBody = (await this.response.json()) as Record<string, unknown>;
        this.storeData[storeKey] = (responseBody[responseBodykey] as string).toString();
    }

    public static async storeMultipleResponseDataForNextAPI(key: string, storeKey: string): Promise<void> {
        const keyValue = await this.getKey(key, 1);
        if (keyValue !== undefined && keyValue !== null) {
            this.storeData[storeKey] = this.convertToString(keyValue);
        }
    }

    public static async validateAndStoreAuditRows(
        arrayPath: string,
        rows: Array<{
            idStoredKey: string;
            auditTypeID: string;
            idType: string;
            idTypeName: string;
            idValue: string;
            dateStoreKey: string;
            auditTypeStoreKey: string;
        }>,
    ): Promise<void> {
        if (!this.response) throw new Error("No response available");
        const responseBody = (await this.response.json()) as Record<string, unknown> | Array<Record<string, unknown>>;
        const auditRows = (
            arrayPath ? (responseBody as Record<string, unknown>)[arrayPath] : responseBody
        ) as Array<Record<string, unknown>>;

        if (!Array.isArray(auditRows)) {
            throw new Error(`Audit response path "${arrayPath || "root"}" is not an array`);
        }

        for (const expected of rows) {
            const expectedId = expected.idStoredKey ? this.getStoredData(expected.idStoredKey) : undefined;
            const matches = auditRows.filter((row) => {
                const sameEntity = this.convertToString(row.EntityId) === this.getStoredData("ClientEntityID");
                const sameAuditType = this.convertToString(row.AuditTypeID) === expected.auditTypeID;
                const sameIdType = this.convertToString(row.IdType) === expected.idType;
                const sameIdValue = this.convertToString(row.IdValue) === expected.idValue;
                const sameId = expectedId === undefined || this.convertToString(row.Id) === expectedId;
                return sameEntity && sameAuditType && sameIdType && sameIdValue && sameId;
            });

            if (matches.length !== 1) {
                const message =
                    `Expected one audit row for entity ${this.getStoredData("ClientEntityID")}, ` +
                    `id ${expectedId ?? "any"}, type ${expected.auditTypeID}, value ${expected.idValue}. ` +
                    `Found ${matches.length}.`;
                apiFixture.logger.error(message);
                throw new Error(message);
            }

            const actualName = this.convertToString(matches[0].IdTypeName);
            if (actualName !== expected.idTypeName) {
                apiFixture.logger.error(
                    `Audit value mismatch for IdTypeName. Expected: '${expected.idTypeName}', Actual: '${actualName}'`,
                );
                throw new Error(
                    `Audit value mismatch for IdTypeName.\nExpected: '${expected.idTypeName}'\nActual: '${actualName}'`,
                );
            }

            if (expected.dateStoreKey) {
                this.storeData[expected.dateStoreKey] = this.convertToString(matches[0].AuditDate);
            }
            if (expected.auditTypeStoreKey) {
                this.storeData[expected.auditTypeStoreKey] = this.convertToString(matches[0].AuditTypeID);
            }
        }
    }

    public static getStoredData(storedKey: string): string {
        if (!(storedKey in this.storeData)) {
            throw new Error(`Stored key "${storedKey}" not found`);
        }
        return this.storeData[storedKey];
    }

    public static clearStoreData(): void {
        this.endPoint = "";
        this.response = null;
        this.pathParam = "";
        this.queryParams = {};
        this.requestBody = {};
        this.headers = {};
        this.storeData = {};
        this.rawPayload = null;
        apiFixture.logger.info("Data cleared");
    }

    private static replaceDateStampAndConvertToJson(json: Record<string, string>): Record<string, string> {
        const jsonString = JSON.stringify(json).replace(/<currentDateStamp>/g, DateTime.now().toFormat("yyyy-MM-dd"));
        return JSON.parse(jsonString) as Record<string, string>;
    }

    private static updateRawPayload(payload: unknown, updates: Record<string, unknown>): unknown {
        if (typeof payload !== "object" || payload === null) return payload;

        for (const key in updates) {
            const value = updates[key];
            const keys = key.split(".");
            let temp = payload as Record<string, unknown>;

            for (let i = 0; i < keys.length - 1; i++) {
                if (!temp[keys[i]]) temp[keys[i]] = {};
                temp = temp[keys[i]] as Record<string, unknown>;
            }
            temp[keys[keys.length - 1]] = value;
        }
        return payload;
    }

    public static storeUniqueData(storeKey: string): void {
        this.storeData[storeKey] = `AutoTest-${Math.random().toString(36).substring(2, 8)}`;
    }

    public static getMessageBodyWithStoreKey(messageBody: string): Promise<string> {
        const regex = /<([^>]+)>/g;
        const processedBody = messageBody.replace(regex, (match, p1) => this.storeData[p1] || "");
        return Promise.resolve(processedBody);
    }

    public static verifyEmailMessageBodyContains(emailMessageBody: string, actualMessage: string): void {
        if (!emailMessageBody.includes(actualMessage)) {
            apiFixture.logger.error(`Expected: '${actualMessage}' is not present in Actual: '${emailMessageBody}'`);
            throw new Error(`Expected: '${actualMessage}' is not present in Actual: '${emailMessageBody}'`);
        }
        apiFixture.expect(emailMessageBody).toContain(actualMessage);
    }

    public static storedataWithKeyAndValue(storeKey: string, value: string): void {
        this.storeData[storeKey] = value;
    }

    public static async storeResponseDataWithIndexKeyForNextAPI(
        index: number,
        key: string,
        storeKey: string,
    ): Promise<void> {
        const value = await this.getKeyAscendingOrder(key, index);
        if (value !== undefined && value !== null) {
            this.storeData[storeKey] = this.convertToString(value);
        }
    }

    public static async storeResponseDataWithKeyForNextAPI(key: string, storeKey: string): Promise<void> {
        const value = await this.getKeyOrder(key);
        if (value !== undefined && value !== null) {
            this.storeData[storeKey] = this.convertToString(value);
        }
    }

    public static async validateSecondResponseBodyKeyWithStoredContainsValue(
        index: number,
        key: string,
        storedKey: string,
    ): Promise<void> {
        if (!this.response) throw new Error("No response available");
        const responseBody = (await this.response.json()) as Array<Record<string, unknown>>;
        const actualStr = this.convertToString(responseBody[index - 1][key]);
        const expectedStr = this.getStoredData(storedKey);
        if (!actualStr.includes(expectedStr)) {
            apiFixture.logger.error(
                `Value mismatch for Index:'${index}' Key:'${key}'. Expected: '${expectedStr}' is not in Actual: '${actualStr}'`,
            );
            throw new Error(
                `Value mismatch for Index:'${index}' Key:'${key}'.\nExpected: '${expectedStr}'\n Is not in Actual: '${actualStr}`,
            );
        }
        apiFixture.expect(actualStr).toContain(expectedStr);
    }

    public static async getKeyAscendingOrder(key: string, order: number): Promise<unknown> {
        if (!this.response) throw new Error("No response available");
        const responseBody = (await this.response.json()) as Record<string, unknown>;
        const keys = key.split(".");
        let actualValue: unknown = responseBody;

        for (let k of keys) {
            k = k.replace("#", ".");
            if (keys[keys.length - 1] === k) {
                if (Array.isArray(actualValue)) {
                    actualValue = actualValue[order - 1];
                    if (typeof actualValue === "object" && actualValue !== null) {
                        actualValue = (actualValue as Record<string, unknown>)[k];
                    }
                } else if (typeof actualValue === "object" && actualValue !== null) {
                    actualValue = (actualValue as Record<string, unknown>)[k];
                }
            } else if (typeof actualValue === "object" && actualValue !== null) {
                actualValue = (actualValue as Record<string, unknown>)[k];
            }
        }
        return actualValue;
    }

    public static async getKeyOrder(key: string): Promise<unknown> {
        if (!this.response) throw new Error("No response available");
        const responseBody = (await this.response.json()) as any;
        const normalizedKey = key.replace(/\[(\d+)\]/g, ".$1");
        const keys = normalizedKey.split(".");
        let actualValue: any = responseBody;
        for (const k of keys) {
            if (actualValue === null || actualValue === undefined) {
                return undefined;
            }
            actualValue = actualValue[k];
        }
        return actualValue;
    }

    public static async validateAscendingOrderResponseBodyKeyValue(
        ascendingOrder: number,
        key: string,
        value: string,
    ): Promise<void> {
        value = this.resolveEnvPlaceholders(value);
        const actualStr = this.convertToString(await this.getKeyAscendingOrder(key, ascendingOrder));
        if (actualStr !== value) {
            apiFixture.logger.error(`Value mismatch for Key:'${key}'. Expected: '${value}', Actual: '${actualStr}'`);
            throw new Error(`Value mismatch for Key:'${key}'.\nExpected: '${value}'\nActual: '${actualStr}`);
        }
        apiFixture.expect(actualStr).toBe(value);
    }

    public static async validateAscendingOrderResponseBodyContainsKeyValue(
        ascendingOrder: number,
        key: string,
        value: string,
    ): Promise<void> {
        value = this.resolveEnvPlaceholders(value);
        const actualStr = this.convertToString(await this.getKeyAscendingOrder(key, ascendingOrder));
        if (!actualStr.includes(value)) {
            apiFixture.logger.error(`Expected: '${value}' is not present in Actual: '${actualStr}'`);
            throw new Error(`Expected: '${value}' is not present in Actual: '${actualStr}'`);
        }
        apiFixture.expect(actualStr).toContain(value);
    }

    public static async validateAscendingOrderResponseBodyContainsStoredKeyValue(
        ascendingOrder: number,
        key: string,
        storedKey: string,
    ): Promise<void> {
        const actualStr = this.convertToString(await this.getKeyAscendingOrder(key, ascendingOrder));
        const expectedStr = this.getStoredData(storedKey);
        if (!actualStr.includes(expectedStr)) {
            apiFixture.logger.error(
                `Value mismatch for Key:'${key}'. Expected: '${expectedStr}' is not in Actual: '${actualStr}'`,
            );
            throw new Error(
                `Value mismatch for Key:'${key}'.\nExpected: '${expectedStr}'\nIs not in Actual: '${actualStr}`,
            );
        }
        apiFixture.expect(actualStr).toContain(expectedStr);
    }

    public static async validateAscendingOrderResponseBodyContainsStoreKeyValue(
        ascendingOrder: number,
        key: string,
        storeKey: string,
    ): Promise<void> {
        const actualStr = this.convertToString(await this.getKeyAscendingOrder(key, ascendingOrder));
        const expectedStr = this.getStoredData(storeKey);
        if (actualStr !== expectedStr) {
            apiFixture.logger.error(
                `Value mismatch for Key:'${key}'. Expected: '${expectedStr}', Actual: '${actualStr}'`,
            );
            throw new Error(`Value mismatch for Key:'${key}'.\nExpected: '${expectedStr}'\nActual: '${actualStr}`);
        }
        apiFixture.expect(actualStr).toBe(expectedStr);
    }

    public static storeValueForKey(value: string, storeKey: string): void {
        this.storeData[storeKey] = value;
    }

    public static async deleteOnboarding(): Promise<void> {
        try {
            this.setAPIServie("/api/v1/client/onboarding/delete");

            const parameters = await this.getFileSelectedPayload(
                "onboarding",
                "BusinessUnitID,ActionUserID,ReturnFormat",
            );
            this.setJSONQueryParams(parameters);

            this.setQueryParamsWithStoredKey("ClientProspectID", "prospectID");
            this.setQueryParamsWithStoredKey("ClientOnboardingID", "onboardingID");

            await this.sendRequest("Delete");
            await this.checkResponseStatusCode(200);
        } catch (error) {
            apiFixture.logger.error(`Failed to delete onboarding : ${(error as Error).message}`);
        }
    }

    public static async deleteProspect(): Promise<void> {
        try {
            this.setAPIServie("/api/v1/client/prospect/delete");

            const parameters = await this.getFileSelectedPayload(
                "prospect",
                "BusinessUnitID,ActionUserID,ReturnFormat",
            );
            this.setJsonRequestBody(parameters);

            this.setRequestBodyWithStoredKey("ClientProspectID", "prospectID");

            await this.sendRequest("Delete");
            await this.checkResponseStatusCode(200);
        } catch (error) {
            apiFixture.logger.error(`Failed to delete prospect : ${(error as Error).message}`);
        }
    }

    public static async deleteAutocreatedProspect(): Promise<void> {
        try {
            // Delete prospect
            this.setAPIServie("/api/v1/client/prospect/delete");

            const prospectParameters = await this.getFileSelectedPayload(
                "prospect",
                "BusinessUnitID,ActionUserID,ReturnFormat",
            );

            this.setJsonRequestBody(prospectParameters);

            this.setRequestBodyWithStoredKey(
                "ClientProspectID",
                "autoProspectID"
            );

            await this.sendRequest("Delete");
            await this.checkResponseStatusCode(200);

            apiFixture.logger.info(
                "Successfully deleted prospect"
            );

        } catch (error) {
            const errorMessage = (error as Error).message;

            apiFixture.logger.error(
                `Failed to delete autocreated prospect. Error: ${errorMessage}`
            );

            throw new Error(
                `Failed to delete autocreated prospect. Error: ${errorMessage}`
            );
        }
    }

    public static async deleteAutocreatedOnboarding(): Promise<void> {
        try {
            // Delete onboarding
            this.setAPIServie("/api/v1/client/onboarding/delete");

            const onboardingParameters = await this.getFileSelectedPayload(
                "onboarding",
                "BusinessUnitID,ActionUserID,ReturnFormat",
            );

            this.setJSONQueryParams(onboardingParameters);

            this.setQueryParamsWithStoredKey(
                "ClientProspectID",
                "autoProspectID"
            );

            this.setQueryParamsWithStoredKey(
                "ClientOnboardingID",
                "autoOnboardingID"
            );

            await this.sendRequest("Delete");
            await this.checkResponseStatusCode(200);

            apiFixture.logger.info(
                "Successfully deleted onboarding"
            );
        } catch (error) {
            const errorMessage = (error as Error).message;
            apiFixture.logger.error(
                `Failed to delete autocreated onboarding. Error: ${errorMessage}`
            );
            throw new Error(
                `Failed to delete autocreated onboarding. Error: ${errorMessage}`
            );
        }
    }

    public static async deleteDataRequest(): Promise<void> {
        try {
            this.setAPIServie("/api/v1/client/onboardingdatarequest/delete")
            const onboardingParameters = await this.getFileSelectedPayload(
                "dataRequest",
                "BusinessUnitID,ActionUserID,ReturnFormat",
            );
            this.setJSONQueryParams(onboardingParameters);

            this.setQueryParamsWithStoredKey(
                "ClientProspectID",
                "prospectID"
            );

            this.setQueryParamsWithStoredKey(
                "ClientOnboardingID",
                "onboardingID"
            );

            this.setQueryParamsWithStoredKey(
                "DataRequestID",
                "dataRequestID"
            );

            await this.sendRequest("Delete");
            await this.checkResponseStatusCode(200);

            apiFixture.logger.info(
                "Successfully deleted data request"
            );
        } catch (error) {
            const errorMessage = (error as Error).message;
            apiFixture.logger.error(
                `Failed to delete data request. Error: ${errorMessage}`
            );
            throw new Error(
                `Failed to delete data request. Error: ${errorMessage}`
            );
        }
    }

    public static async validateResponseBodyIsEmptyArray() {
        if (!this.response) throw new Error("No response available");
        const responseBody = await this.response.json();
        if (!Array.isArray(responseBody) || responseBody.length !== 0) {
            throw new Error("Response body is not an empty array.");
        }
    }
    public static async validateResponseArrayCount(expectedCount: number, pathKey?: string): Promise<void> {
        if (!this.response) {
            throw new Error("No response available");
        }

        const responseText = await this.response.text();
        let responseBody: unknown;
        try {
            responseBody = JSON.parse(responseText);
        } catch (error) {
            throw new Error(`Response is not valid JSON.\n${responseText}\nError: ${(error as Error).message}`);
        }

        const target = pathKey ? APICommon.getValueFromPath(responseBody, pathKey) : responseBody;

        if (!Array.isArray(target)) {
            throw new Error(
                `Expected an array ${pathKey ? `at path "${pathKey}"` : "in response body"}, but got: ${target === null ? "null" : typeof target
                }`,
            );
        }

        const actualCount = target.length;

        if (actualCount !== expectedCount) {
            throw new Error(`Response count mismatch. Expected: ${expectedCount}, Actual: ${actualCount}`);
        }

        apiFixture.expect(actualCount).toBe(expectedCount);
    }

    /**
     * Supports:
     *  - data.items
     *  - items[0].children
     */
    private static getValueFromPath(obj: unknown, path: string): unknown {
        const parts = path
            .replace(/\[(\d+)\]/g, ".$1")
            .split(".")
            .filter(Boolean);

        let current: unknown = obj;

        for (const part of parts) {
            if (current === null || current === undefined) return undefined;

            if (Array.isArray(current)) {
                current = current[Number(part)];
            } else if (typeof current === "object") {
                current = (current as Record<string, unknown>)[part];
            } else {
                return undefined;
            }
        }
        return current;
    }

    public static async validateResponseArrayItemKeyValue(
        arrayName: string,
        index: number,
        key: string,
        value: unknown,
    ): Promise<void> {
        if (!this.response) throw new Error("No response available");

        // Parse JSON
        const responseBody = (await this.response.json()) as Record<string, unknown>;

        const array = responseBody[arrayName];
        if (!array || !Array.isArray(array)) {
            throw new Error(`Response does not contain an array named "${arrayName}"`);
        }

        const itemIndex = index - 1; // Convert 1-based to 0-based index
        if (itemIndex < 0 || itemIndex >= array.length) {
            throw new Error(`Invalid index ${index}. Array "${arrayName}" length: ${array.length}`);
        }

        const actualValue = (array[itemIndex] as Record<string, unknown>)[key];
        const actualStr = this.convertToString(actualValue);
        const expectedStr = this.convertToString(value).replace(
            "<currentDateStamp>",
            DateTime.now().toFormat("yyyy-MM-dd"),
        );

        if (actualStr !== expectedStr) {
            throw new Error(
                `Validation failed for array "${arrayName}" at index "${index}" with key "${key}".\nExpected: '${expectedStr}'\nActual: '${actualStr}'`,
            );
        }

        apiFixture.logger.info(`Validated array "${arrayName}" index ${index} key "${key}" = "${expectedStr}"`);
        apiFixture.expect(actualStr).toBe(expectedStr);
    }

    public static async getKeyAscendingOrderForRiskScore(key: string, ascendingOrder: number): Promise<any> {
        if (!this.response) throw new Error("No response available");

        const response = await this.response.json();

        // Convert bracket syntax: riskOutcomes[0] → riskOutcomes.0
        const normalizedKey = key.replace(/\[(\d+)\]/g, ".$1");

        const parts = normalizedKey.split(".");

        // first part must be the array name: riskOutcomes
        const arrayName = parts[0];

        const restPath = parts.slice(1).join(".");

        const arr = response[arrayName];

        if (!Array.isArray(arr)) {
            throw new Error(`${arrayName} is not an array in response`);
        }

        // sort ascending by calculatedRiskValue
        const sorted = [...arr].sort((a, b) => a.score.calculatedRiskValue - b.score.calculatedRiskValue);

        // ascendingOrder is 1-based (1 = first row)
        const item = sorted[ascendingOrder - 1];

        if (!item) {
            throw new Error(`No element found at ascending index ${ascendingOrder}`);
        }

        return restPath.split(".").reduce((obj, prop) => obj?.[prop], item);
    }

    public static async validateAscendingOrderResponseBodyKeyValueForRiskScoreOutcome(
        ascendingOrder: number,
        key: string,
        value: string,
    ): Promise<void> {
        const actualStr = this.convertToString(await this.getKeyAscendingOrderForRiskScore(key, ascendingOrder));
        if (actualStr !== value) {
            apiFixture.logger.error(`Value mismatch for Key:'${key}'. Expected: '${value}', Actual: '${actualStr}'`);
            throw new Error(`Value mismatch for Key:'${key}'.\nExpected: '${value}'\nActual: '${actualStr}'`);
        }
        apiFixture.expect(actualStr).toBe(value);
    }
    public static async validateResponseBodyKeyValueArrayCompatible(
        key: string,
        expectedValue: unknown,
    ): Promise<void> {
        if (!this.response) throw new Error("No response available");
        const responseBody = (await this.response.json()) as Record<string, unknown>;
        // Handle cucumber "null" string
        if (expectedValue === "null") {
            expectedValue = null;
        }
        // Convert numeric strings to numbers
        if (typeof expectedValue === "string" && expectedValue.trim() !== "" && !isNaN(Number(expectedValue))) {
            expectedValue = Number(expectedValue);
        }
        const keys = key.split(".");
        let actualValue: any = responseBody;

        for (const k of keys) {
            if (actualValue === undefined || actualValue === null) break;

            //  If current value is array, automatically take first element
            if (Array.isArray(actualValue)) {
                if (actualValue.length === 0) {
                    actualValue = undefined;
                    break;
                }
                actualValue = actualValue[0];
            }
            actualValue = actualValue[k];
        }
        const actualStr = this.convertToString(actualValue);
        const expectedStr = this.convertToString(expectedValue);
        if (actualStr !== expectedStr) {
            apiFixture.logger.error(
                `Key value mismatch for '${key}'. Expected: '${expectedStr}', Actual: '${actualStr}'`,
            );
            throw new Error(`Key value mismatch for '${key}'.\nExpected: '${expectedStr}'\nActual: '${actualStr}'`);
        }
        apiFixture.expect(actualStr).toBe(expectedStr);
    }
    public static async validateTenantsArrayFlexible(expectedTenants: Array<Record<string, any>>): Promise<void> {
        if (!this.response) throw new Error("No response available");

        const { tenants } = (await this.response.json()) as { tenants: Record<string, any>[] };

        if (!Array.isArray(tenants)) {
            throw new Error("Response does not contain 'tenants' array");
        }

        const valueMap: Record<string, any> = {
            null: null,
            true: true,
            false: false,
        };

        for (let i = 0; i < expectedTenants.length; i++) {
            if (i >= tenants.length) {
                throw new Error(`Tenant at index ${i} not found. Total tenants: ${tenants.length}`);
            }

            const expectedTenant = expectedTenants[i];
            const actualTenant = tenants[i];

            for (const key in expectedTenant) {
                let expectedValue: any = expectedTenant[key];
                let actualValue: any = actualTenant;

                // Handle nested keys
                if (key.includes(".")) {
                    const parts = key.split(".");
                    for (let j = 0; j < parts.length; j++) {
                        if (actualValue == null) break;
                        actualValue = actualValue[parts[j]];
                    }
                } else {
                    actualValue = actualTenant[key];
                }

                // Normalize expected value
                if (typeof expectedValue === "string") {
                    const mapped = valueMap[expectedValue];
                    if (mapped !== undefined || expectedValue === "null") {
                        expectedValue = mapped;
                    } else {
                        const num = +expectedValue;
                        if (!Number.isNaN(num) && expectedValue.trim() !== "") {
                            expectedValue = num;
                        }
                    }
                }

                const actualStr = this.convertToString(actualValue);
                const expectedStr = this.convertToString(expectedValue);

                if (actualStr !== expectedStr) {
                    const message =
                        `Tenant[${i}] key '${key}' mismatch.\n` + `Expected: '${expectedStr}'\nActual: '${actualStr}'`;

                    apiFixture.logger.error(message);
                    throw new Error(message);
                }

                apiFixture.expect(actualStr).toBe(expectedStr);
            }
        }
    }
    public static async getKeyAscendingOrderWhenFirstKeyIsArray(key: string, order: number): Promise<unknown> {
        if (!this.response) throw new Error("No response available");
        const responseBody = (await this.response.json()) as Record<string, unknown>;

        const keys = key.split(".");
        let actualValue: any = responseBody;

        for (let i = 0; i < keys.length; i++) {
            const k = keys[i];

            if (i === 0 && Array.isArray(actualValue[k])) {
                // first key is an array, apply index
                actualValue = actualValue[k][order - 1];
            } else if (typeof actualValue === "object" && actualValue !== null) {
                actualValue = actualValue[k];
            } else {
                actualValue = undefined;
            }
        }

        return actualValue;
    }
    public static async validateAscendingOrderResponseBodyKeyIsArrayValue(
        ascendingOrder: number,
        key: string,
        value: string,
    ): Promise<void> {
        value = this.resolveEnvPlaceholders(value);
        const actualStr = this.convertToString(await this.getKeyAscendingOrderWhenFirstKeyIsArray(key, ascendingOrder));
        if (actualStr !== value) {
            apiFixture.logger.error(`Value mismatch for Key:'${key}'. Expected: '${value}', Actual: '${actualStr}'`);
            throw new Error(`Value mismatch for Key:'${key}'.\nExpected: '${value}'\nActual: '${actualStr}`);
        }
        apiFixture.expect(actualStr).toBe(value);
    }
    public static setJsonRawBodyDynamicValue(rawBody: string): void {
        try {
            // replace env placeholders first
            rawBody = this.resolveEnvPlaceholders(rawBody);
            // replace stored variables
            rawBody = rawBody.replace(/{{(.*?)}}/g, (_, key) => {
                const value = this.storeData[key.trim()];
                if (value === undefined) {
                    throw new Error(`No stored value found for key: ${key}`);
                }
                return value;
            });
            const newRequestBody: unknown = JSON.parse(rawBody);

            if (typeof newRequestBody === "object" && newRequestBody !== null) {
                this.rawPayload = { ...(this.rawPayload as Record<string, unknown>), ...newRequestBody };
            }

            apiFixture.logger.info(`Payload: ${JSON.stringify(this.rawPayload, null, 2)}`);
        } catch (error) {
            throw new Error(`Invalid JSON format in requestBody: ${(error as Error).message}`);
        }
    }

    public static addBase64ToFormPayload(base64String: string): void {
        try {
            // 1. Get the existing request body (metadata like ClientProspectID)
            // If it was stored as a string, parse it. If it's an object, use it.
            let currentPayload = this.requestBody;
            if (typeof currentPayload === "string") {
                currentPayload = JSON.parse(currentPayload);
            }

            // 2. Merge the Base64 data into the Object
            const finalObject = {
                ...currentPayload,
                DocumentData: base64String,
            };

            // 3. STORE AS RAW OBJECT
            // We set this to a variable that the POST step will use.
            // DO NOT JSON.stringify here!
            this.requestBody = finalObject;

            apiFixture.logger.info("Base64 successfully merged into Form payload.");
        } catch (error) {
            throw new Error(`Failed to append Base64: ${(error as Error).message}`);
        }
    }
    public static async validateResponseBodyKeyValueForNestedObject(key: string, value: unknown): Promise<void> {
        if (!this.response) throw new Error("No response available");
        let expectedValue: unknown = value;

        // 1. Handle dynamic placeholders in the expected value
        if (typeof value === "string") {
            const resolvedExpectedValue = this.resolveEnvPlaceholders(
                value.replace("<currentDateStamp>", DateTime.now().toFormat("yyyy-MM-dd")),
            );
            expectedValue = resolvedExpectedValue;
        }

        // 2. Use your improved path parsing logic to get the actual value
        // This now correctly handles keys like 'fields.value[0].fileName'
        const actualValue = await this.getKeyOrder(key);

        const actualStr = this.convertToString(actualValue);
        const expectedStr = this.convertToString(expectedValue);

        // 3. Perform the assertion
        if (actualStr !== expectedStr) {
            apiFixture.logger.error(
                `Key value mismatch for '${key}'. Expected: '${expectedStr}', Actual: '${actualStr}'`,
            );
            throw new Error(`Key value mismatch for '${key}'.\nExpected: '${expectedStr}'\nActual: '${actualStr}'`);
        }

        apiFixture.logger.info(`Successfully validated '${key}' equals '${expectedStr}'`);
        apiFixture.expect(actualStr).toBe(expectedStr);
    }

    public static async uploadFileToStoredUrl(storedUrlKey: string, file: FileInput): Promise<void> {
        this.response = null;

        const url = this.getStoredData(storedUrlKey);
        const filePath = path.resolve(process.cwd(), "src/testData", file.file);
        let buffer: Buffer;

        try {
            buffer = await fs.readFile(filePath);
        } catch (error) {
            throw new Error(`Failed to read upload file at "${filePath}": ${(error as Error).message}`);
        }

        const dynamicHeaders = this.replaceDateStampAndConvertToJson(this.headers) ?? {};

        // 2. IMPORTANT: Remove Content-Type to prevent conflicts with the multipart boundary
        delete dynamicHeaders["Content-Type"];
        delete dynamicHeaders["content-type"]; // Case-sensitive safety check

        // 3. Create the form
        const form = new FormData();
        form.append("fileName", buffer, {
            filename: path.basename(filePath),
            contentType: file.mimeType || "application/pdf",
        });

        try {
            this.response = await apiFixture.request.post(url, {
                headers: {
                    ...dynamicHeaders,
                    ...form.getHeaders(), // Add the correct Content-Type + Boundary
                },
                data: form.getBuffer(),
            });

            const status = this.response.status();
            const text = await this.response.text();

            apiFixture.logger.info(`[Manual Form-Data] Status: ${status} Body: ${text}`);

            if (status >= 400) {
                apiFixture.logger.error(
                    `[Manual Form-Data] Upload rejected by server. URL: ${url} Status: ${status} Body: ${text}`,
                );
            }
        } catch (err) {
            apiFixture.logger.error(`Upload Error: ${(err as Error).message}`);
            throw err;
        }
    }
    public static setRequestBodyWithStoredKeyTable(key: string, storedKey: string): void {
        if (!(storedKey in this.storeData)) {
            throw new Error(`Stored key "${storedKey}" not found`);
        }

        this.requestBody = {
            ...this.requestBody,
            [key]: this.storeData[storedKey],
        };

        apiFixture.logger.info(`Payload: ${JSON.stringify(this.requestBody, null, 2)}`);
    }
    public static async deleteCreatedProspect(): Promise<void> {
        try {
            this.setAPIServie("/api/v1/client/onboarding/delete");

            const parameters = await this.getFileSelectedPayload(
                "onboarding",
                "BusinessUnitID,ActionUserID,ReturnFormat",
            );
            this.setJSONQueryParams(parameters);

            this.setQueryParamsWithStoredKey("ClientProspectID", "ProspectID");
            this.setQueryParamsWithStoredKey("ClientOnboardingID", "OnBoardingID");

            await this.sendRequest("Delete");
            await this.checkResponseStatusCode(200);

        } catch (error) {
            apiFixture.logger.error(`Failed to delete onboarding : ${(error as Error).message}`);
        }
        try {
            // Delete prospect
            this.setAPIServie("/api/v1/client/prospect/delete");

            const prospectParameters = await this.getFileSelectedPayload(
                "prospect",
                "BusinessUnitID,ActionUserID,ReturnFormat",
            );

            this.setJsonRequestBody(prospectParameters);

            this.setRequestBodyWithStoredKey(
                "ClientProspectID",
                "ProspectID"
            );

            await this.sendRequest("Delete");
            await this.checkResponseStatusCode(200);

            apiFixture.logger.info(
                "Successfully deleted prospect"
            );

        } catch (error) {
            const errorMessage = (error as Error).message;

            apiFixture.logger.error(
                `Failed to delete created prospect. Error: ${errorMessage}`
            );

            throw new Error(
                `Failed to delete created prospect. Error: ${errorMessage}`
            );
        }
    }

    /** Clears request payload state without wiping auth headers or stored keys. */
    private static resetRequestPayload(): void {
        this.requestBody = {};
        this.rawPayload = null;
        this.pathParam = "";
        this.queryParams = {};
    }

    /**
     * Creates an onboarding for the given prospect via POST /api/v1/client/onboarding/add.
     * @param prospectId ClientProspectID
     * @param riskModelType Optional RiskModelType override (defaults to onboarding.json value when omitted)
     * @returns ClientOnboardingID
     */
    public static async createOnboardingForProspect(prospectId: string, riskModelType?: string): Promise<string> {
        this.resetRequestPayload();
        this.setAPIServie("/api/v1/client/onboarding/add");
        const featureName = pageFixture.currentFeature?.toLowerCase() ?? "";
        featureName.startsWith("pkyc")
            ? await this.setFilePayload("pkyconboarding")
            : await this.setFilePayload("onboarding");
        if (riskModelType) {
            this.setRequestBody("RiskModelType", riskModelType);
        }
        this.setRequestBody("ClientProspectID", prospectId);
        await this.sendRequest("POST");
        await this.checkResponseStatusCode(201);

        if (!this.response) {
            throw new Error("No response available after onboarding/add");
        }
        const body = (await this.response.json()) as Record<string, unknown>;
        if (body.ClientOnboardingID === undefined || body.ClientOnboardingID === null) {
            throw new Error(`ClientOnboardingID missing in onboarding/add response: ${JSON.stringify(body)}`);
        }
        const onboardingId = String(body.ClientOnboardingID);
        apiFixture.logger.info(`Created onboarding '${onboardingId}' for prospect '${prospectId}'`);
        return onboardingId;
    }

    /**
     * Creates a data request and generates a data collection link.
     * @param prospectId ClientProspectID
     * @param onboardingId ClientOnboardingID
     * @returns DataRequestLink
     */
    public static async createDataRequestAndCollectionLink(prospectId: string, onboardingId: string): Promise<string> {
        this.resetRequestPayload();
        this.setAPIServie("/api/v1/client/onboardingdatarequest/add");
        const featureName = pageFixture.currentFeature?.toLowerCase() ?? "";
        featureName.startsWith("pkyc")
            ? await this.setFilePayload("pkycdataRequest")
            : await this.setFilePayload("dataRequest");
        const expiryDate = DateTime.now().plus({ days: 1 }).toFormat("yyyy-MM-dd");
        this.setRequestBody("ExpiryDate", expiryDate);
        this.setRequestBody("ClientProspectID", prospectId);
        this.setRequestBody("ClientOnboardingID", onboardingId);
        await this.sendRequest("POST");
        await this.checkResponseStatusCode(201);

        if (!this.response) {
            throw new Error("No response available after onboardingdatarequest/add");
        }
        const addBody = (await this.response.json()) as Record<string, unknown>;
        if (addBody.DataRequestID === undefined || addBody.DataRequestID === null) {
            throw new Error(`DataRequestID missing in datarequest/add response: ${JSON.stringify(addBody)}`);
        }
        const dataRequestId = String(addBody.DataRequestID);
        this.storeValueForKey(dataRequestId, "dataRequestID");

        this.resetRequestPayload();
        this.setAPIServie("/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink");
        featureName.startsWith("pkyc")
            ? await this.setFilePayload("pkycdataRequest")
            : await this.setFilePayload("dataRequest");
        this.setRequestBody("ClientProspectID", prospectId);
        this.setRequestBody("ClientOnboardingID", onboardingId);
        this.setRequestBody("DataRequestID", dataRequestId);
        this.setRequestBody("UpdateDataRequestedOn", "True");
        await this.sendRequest("POST");
        await this.checkResponseStatusCode(200);

        if (!this.response) {
            throw new Error("No response available after GenerateDataCollectionLink");
        }
        const linkBody = (await this.response.json()) as Record<string, unknown>;
        if (linkBody.DataRequestLink === undefined || linkBody.DataRequestLink === null) {
            throw new Error(
                `DataRequestLink missing in GenerateDataCollectionLink response: ${JSON.stringify(linkBody)}`,
            );
        }
        const dataRequestLink = String(linkBody.DataRequestLink);
        apiFixture.logger.info(
            `Generated data collection link for prospect '${prospectId}', onboarding '${onboardingId}'`,
        );
        return dataRequestLink;
    }

    public static async deletePkycOnboarding(): Promise<void> {
        try {
            this.resetRequestPayload();
            this.setAPIServie("/api/v1/client/onboarding/delete");

            const parameters = await this.getFileSelectedPayload(
                "pkyconboarding",
                "BusinessUnitID,ActionUserID,ReturnFormat",
            );
            this.setJSONQueryParams(parameters);

            this.setQueryParamsWithStoredKey("ClientProspectID", "prospectID");
            this.setQueryParamsWithStoredKey("ClientOnboardingID", "onboardingID");

            await this.sendRequest("Delete");
            await this.checkResponseStatusCode(200);
        } catch (error) {
            apiFixture.logger.error(`Failed to delete pKYC onboarding: ${(error as Error).message}`);
        }
    }

    public static async deletePkycAutocreatedProspect(): Promise<void> {
        try {
            this.resetRequestPayload();
            // Delete prospect
            this.setAPIServie("/api/v1/client/prospect/delete");

            const prospectParameters = await this.getFileSelectedPayload(
                "pkycprospect",
                "BusinessUnitID,ActionUserID,ReturnFormat",
            );

            this.setJsonRequestBody(prospectParameters);

            this.setRequestBodyWithStoredKey(
                "ClientProspectID",
                "autoProspectID"
            );

            await this.sendRequest("Delete");
            await this.checkResponseStatusCode(200);

            apiFixture.logger.info(
                "Successfully deleted prospect"
            );

        } catch (error) {
            const errorMessage = (error as Error).message;

            apiFixture.logger.error(
                `Failed to delete autocreated prospect. Error: ${errorMessage}`
            );

            throw new Error(
                `Failed to delete autocreated prospect. Error: ${errorMessage}`
            );
        }
    }
}

export { APICommon };
