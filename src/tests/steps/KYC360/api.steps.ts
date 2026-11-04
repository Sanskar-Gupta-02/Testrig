import { Given, When, Then } from "@cucumber/cucumber";
import { APICommon } from "../../../Helper/utilities/api.utils";
import { apiFixture } from "../../../hooks/apifixtures";
import { Common } from "../../../Helper/utilities/ui.utils";
import { getRandomInt } from "../../../Helper/utilities/Common.utils";
import { sprintf } from "sprintf-js";
import { pageFixture } from "../../../hooks/pagefixtures";
import * as fs from "fs";
import path from "path";

Given("user has a service named {string}", function (endPoint) {
    APICommon.setAPIServie(endPoint);
});

Given("user has a service in runtime named {string}", function (endPoint: string) {
    APICommon.setAPIServieForRunTime(endPoint);
});

Given("user is authorized using an {string}", function (authorizedType) {
    switch (authorizedType.toUpperCase()) {
        case "APIKEY": {
            const apikey = process.env.APIKEY;
            if (!apikey) throw new Error("API key not found in environment variables.");
            APICommon.setHeaders("api-key", apikey);
            break;
        }
        case "BEARER1": {
            const token = process.env.BEARER_TOKEN1;
            if (!token) throw new Error("Bearer token not found in environment variables.");
            APICommon.setHeaders("Authorization", `Bearer ${token}`);
            break;
        }
        case "BEARER2": {
            const token = process.env.BEARER_TOKEN2;
            if (!token) throw new Error("Bearer token not found in environment variables.");
            APICommon.setHeaders("Authorization", `Bearer ${token}`);
            break;
        }
        case "INVALIDBEARER": {
            const token = process.env.INVALID_BEARER_TOKEN;
            if (!token) throw new Error("Bearer token not found in environment variables.");
            APICommon.setHeaders("Authorization", `Bearer ${token}`);
            break;
        }
        case "INVALIDAPIKEY": {
            const apikey = process.env.INVALID_APIKEY;
            if (!apikey) throw new Error("Invalid API key not found in environment variables.");
            APICommon.setHeaders("api-key", apikey);
            break;
        }
        case "ALIASAPIKEY": {
            const apikey = process.env.ALIAS_APIKEY;
            if (!apikey) throw new Error("Alias API key not found in environment variables.");
            APICommon.setHeaders("api-key", apikey);
            break;
        }
        case "APIKEY_FOR_REFIT_ENABLED_CLIENT": {
            const apikey = process.env.APIKEY_FOR_REFIT_ENABLED_CLIENT;
            if (!apikey) throw new Error("Refit Enabled API key not found in environment variables.");
            APICommon.setHeaders("api-key", apikey);
            break;
        }
        case "XAPIKEY": {
            const apikey = process.env.XAPIKEY;
            if (!apikey) throw new Error("XAPI key not found in environment variables.");
            APICommon.setHeaders("X-API-Key", apikey);
            break;
        }
        case "INVALIDXAPIKEY": {
            const apikey = process.env.INVALID_XAPIKEY;
            if (!apikey) throw new Error("Invalid XAPI key not found in environment variables.");
            APICommon.setHeaders("X-API-Key", apikey);
            break;
        }
        case "PKYCAPIKEY": {
            const apikey = process.env.PKYCAPIKEY;
            if (!apikey) throw new Error("PKYC API key not found in environment variables.");
            APICommon.setHeaders("api-key", apikey);
            break;
        }
        default:
            throw new Error(`Invalid authorized method: ${authorizedType}.`);
    }
});

Given("user has header {string}:{string}", function (key, value) {
    APICommon.setHeaders(key, value);
});

Given("user has headers:", function (headerJson) {
    APICommon.setJsonHeaders(headerJson);
});

Given("user has query parameter {string}:{string}", function (key, value) {
    APICommon.setQueryParams(key, value);
});

Given("user has query parameters:", function (queryJson) {
    APICommon.setJSONQueryParams(queryJson);
});

Given("user has payload {string}:{string}", function (key, value) {
    APICommon.setRequestBody(key, value);
});

Given("user has payloads:", function (requestBody) {
    APICommon.setJsonRequestBody(requestBody);
});

Given("user has raw payloads:", function (rawBody) {
    APICommon.setJsonRawBody(rawBody);
});

Given(
    "user has a payload from the file {string} updates the key {string} with the value {string}",
    async function (filename, key, value) {
        await APICommon.updatePayload(filename, key, value);
    },
);

Given("user has a payload from the file {string}", async function (filename) {
    await APICommon.setFilePayload(filename);
});

When("user sends a {string} request", async function (action) {
    await APICommon.sendRequest(action);
});

Then("response status should be {int}", async function (status) {
    await APICommon.checkResponseStatusCode(status);
});

Then("response header should be {string}:{string}", function (key, value) {
    APICommon.checkResponseHeader(key, value);
});

Then("response body should match the schema from the file {string}", async function (fileName) {
    await APICommon.validateResponseSchema(fileName);
});

Then("response body should match the expected data from the file {string}", async function (fileName) {
    await APICommon.validateResponseData(fileName);
});

Then("response body should contains {string}", async function (containsText) {
    await APICommon.validateResponseBodyContains(containsText);
});

Then("response body should text contains {string}", async function (containsText) {
    await APICommon.validateResponseBodyTextContains(containsText);
});

Then("response body should have key {string} with the value {string}", async function (key, value) {
    await APICommon.validateResponseBodyKeyValue(key, value);
});

Then("response body should have {int} key {string} with the value {string}", async function (index, key, value) {
    await APICommon.validateSecondResponseBodyKeyValue(index, key, value);
});

Then(
    "user store the response body keyData:{string} with keyName:{string}",
    async function (responseBodykey, storedKey) {
        await APICommon.storeResponseDataForNextAPI(responseBodykey, storedKey);
    },
);

Then(
    "response body should have key {string} with the stored key value {string}",
    async function (responseBodykey, storedKey) {
        await APICommon.validateResponseBodyKeyWithStoredValue(responseBodykey, storedKey);
    },
);

Then("response body should have key {string} with the message:{string}", async function (responseBodykey, message) {
    const placeholderRegex = /<([^>]+)>/g;
    let processedMessage = message as string;
    let match: RegExpExecArray | null;

    // Replace all placeholders with stored values
    while ((match = placeholderRegex.exec(message)) !== null) {
        const placeholder = match[1];
        const storedValue = APICommon.getStoredData(placeholder);
        processedMessage = processedMessage.replace(`<${placeholder}>`, storedValue);
    }
    await APICommon.validateResponseBodyKeyWithMessage(responseBodykey, processedMessage);
});

Then(
    "response body should have {int} key {string} with the stored key value {string}",
    async function (index, responseBodykey, storedKey) {
        await APICommon.validateSecondResponseBodyKeyWithStoredValue(index, responseBodykey, storedKey);
    },
);

When("user add header {string} with the stored key value {string}", function (headerKey, storedKey) {
    APICommon.setHeadersWithStoredKey(headerKey, storedKey);
});

When("user has headers with the stored key value {string}:", function (storedKey, headerJson) {
    APICommon.setJsonHeadersWithStoredKey(headerJson, storedKey);
});

When("user add query parameter {string} with the stored key value {string}", function (key, storedKey) {
    APICommon.setQueryParamsWithStoredKey(key, storedKey);
});

When("user has query parameters with the stored key value {string}:", function (storedKey, headerJson) {
    APICommon.setJSONQueryParamsWithStoredKey(storedKey, headerJson);
});

When("user add payload {string} with the stored key value {string}", function (key, storedKey) {
    APICommon.setRequestBodyWithStoredKey(key, storedKey);
});

When("user add raw payload {string} with the stored key value {string}", function (key, storedKey) {
    APICommon.setRawRequestBodyWithStoredKey(key, storedKey);
});

When("user has payloads with the stored key value {string}:", function (storedKey, JsonRequestBody) {
    APICommon.setJsonRequestBodyWithStoredKey(JsonRequestBody, storedKey);
});

When(
    "user has a payload from the file {string} updates the key {string} with the stored key value {string}",
    async function (filename, key, storedKey) {
        await APICommon.updatePayloadWithStoredKey(filename, key, storedKey);
    },
);

When("user has path parameter {string}", function (pathParam) {
    APICommon.setPathParam(pathParam);
});

When("user has path parameter with the stored key value {string}", function (storedKey) {
    APICommon.setPathParamWithStoredKey(storedKey);
});

Given("user has a payload from the file {string} with selected keys {string}", async function (filename, keys) {
    const payloads = await APICommon.getFileSelectedPayload(filename, keys);
    APICommon.setJsonRequestBody(payloads);
});

Given("user has a query params from the file {string} with selected keys {string}", async function (filename, keys) {
    const parameters = await APICommon.getFileSelectedPayload(filename, keys);
    APICommon.setJSONQueryParams(parameters);
});

Then("response body should have key with the value:", async function (dataTable) {
    const rows: Array<{ key: string; value: string }> = dataTable.hashes() as Array<{ key: string; value: string }>;
    for (const row of rows) {
        try {
            await APICommon.validateResponseBodyKeyValue(row.key, row.value);
        } catch (error) {
            const enhancedError = new Error(
                `Validation failed for key "${row.key}" with value "${row.value}": 
                ${error instanceof Error ? error.message : String(error)}`,
            );
            // Mark the step as failed in Cucumber's reporting
            this.attach(JSON.stringify(row, null, 2), "application/json");
            throw enhancedError;
        }
    }
});

Then("response body should have key with the value within array :", async function (dataTable) {
    const rows: Array<{ key: string; value: string }> = dataTable.hashes() as Array<{ key: string; value: string }>;

    for (const row of rows) {
        try {
            await APICommon.validateResponseBodyKeyValueArrayCompatible(row.key, row.value);
        } catch (error) {
            const enhancedError = new Error(
                `Validation failed for key "${row.key}" with value "${row.value}":${error instanceof Error ? error.message : String(error)}`,
            );
            // Mark the step as failed in Cucumber's reporting
            this.attach(JSON.stringify(row, null, 2), "application/json");
            throw enhancedError;
        }
    }
});

Then("response body should have key with the values from {string} file", async function (fileName: string, dataTable) {
    const rows: Array<{ [key: string]: string }> = dataTable.hashes() as Array<{ [key: string]: string }>;
    for (const { key } of rows) {
        const value = await APICommon.getResponseValueFromFile(fileName, key);
        await APICommon.validateResponseBodyKeyValue(key, value);
    }
});

Then("response body should have key with the stored value:", async function (dataTable) {
    const rows: Array<{ key: string; storedKey: string }> = dataTable.hashes() as Array<{
        key: string;
        storedKey: string;
    }>;
    for (const row of rows) {
        try {
            await APICommon.validateResponseBodyKeyWithStoredValue(row.key, row.storedKey);
        } catch (error) {
            const enhancedError = new Error(
                `Validation failed for key "${row.key}" with value "${row.storedKey}": 
                ${error instanceof Error ? error.message : String(error)}`,
            );
            // Mark the step as failed in Cucumber's reporting
            this.attach(JSON.stringify(row, null, 2), "application/json");
            throw enhancedError;
        }
    }
});

Then("response body should have index key with the value:", async function (dataTable) {
    const rows: Array<{ index: number; key: string; value: string }> = dataTable.hashes() as Array<{
        index: number;
        key: string;
        value: string;
    }>;
    for (const row of rows) {
        try {
            await APICommon.validateSecondResponseBodyKeyValue(row.index, row.key, row.value);
        } catch (error) {
            const enhancedError = new Error(
                `Validation failed for index "${row.index}" with key "${row.key}" with value "${row.value}": 
                ${error instanceof Error ? error.message : String(error)}`,
            );
            // Mark the step as failed in Cucumber's reporting
            this.attach(JSON.stringify(row, null, 2), "application/json");
            throw enhancedError;
        }
    }
});

Then("response body should have index key with the stored key value:", async function (dataTable) {
    const rows: Array<{ index: number; key: string; storedKey: string }> = dataTable.hashes() as Array<{
        index: number;
        key: string;
        storedKey: string;
    }>;
    for (const row of rows) {
        try {
            await APICommon.validateSecondResponseBodyKeyWithStoredValue(row.index, row.key, row.storedKey);
        } catch (error) {
            const enhancedError = new Error(
                `Validation failed for index "${row.index}" with key "${row.key}" with storedKey "${row.storedKey}": 
                ${error instanceof Error ? error.message : String(error)}`,
            );
            // Mark the step as failed in Cucumber's reporting
            this.attach(JSON.stringify(row, null, 2), "application/json");
            throw enhancedError;
        }
    }
});

Then("email response body in descending order should have index key with the value:", async function (dataTable) {
    const rows: Array<{ index: number; key: string; value: string }> = dataTable.hashes() as Array<{
        index: number;
        key: string;
        value: string;
    }>;
    for (const row of rows) {
        try {
            await APICommon.validateDescendingOrderResponseBodyContainsKeyValue(row.index, row.key, row.value);
        } catch (error) {
            const enhancedError = new Error(
                `Validation failed for index "${row.index}" with key "${row.key}" with value "${row.value}": 
                ${error instanceof Error ? error.message : String(error)}`,
            );
            // Mark the step as failed in Cucumber's reporting
            this.attach(JSON.stringify(row, null, 2), "application/json");
            throw enhancedError;
        }
    }
});

Given("user has a raw payload from the file {string}", async function (filename: string) {
    await APICommon.setRawFilePayload(filename);
});

Given(
    "user has a raw payload from the file {string} with payload key {string}",
    async function (filename: string, payloadKey: string) {
        await APICommon.setRawFilePayloadByKey(filename, payloadKey);
    },
);

Then(
    "user store the email response body keyData:{string} with keyName:{string}",
    async function (responseBodykey, storedKey) {
        await APICommon.storeMultipleResponseDataForNextAPI(responseBodykey, storedKey);
    },
);
Then(
    "email response body in descending order should have index key with the stored key value:",
    async function (dataTable) {
        const rows: Array<{ index: number; key: string; storedKey: string }> = dataTable.hashes() as Array<{
            index: number;
            key: string;
            storedKey: string;
        }>;
        for (const row of rows) {
            try {
                await APICommon.validateDescendingOrderResponseBodyContainsKeyValue(row.index, row.key, row.storedKey);
            } catch (error) {
                const enhancedError = new Error(
                    `Validation failed for index "${row.index}" with key "${row.key}" with value "${row.storedKey}":
                    ${error instanceof Error ? error.message : String(error)}
                    `,
                );
                // Mark the step as failed in Cucumber's reporting
                this.attach(JSON.stringify(row, null, 2), "application/json");
                throw enhancedError;
            }
        }
    },
);

Given("user has a raw payload from the file {string} with updates:", async function (filename: string, table) {
    const updates: Record<string, string> = table.rowsHash() as Record<string, string>;
    await APICommon.setRawFilePayload(filename, updates);
});
When("user add {string} with tomorrow date", function (key: string) {
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    APICommon.setRequestBody(key, tomorrow.toISOString().split("T")[0]);
});

Given("user add {string} with today date", function (key: string) {
    const today = new Date();
    today.setDate(today.getDate());
    APICommon.setRequestBody(key, today.toISOString().split("T")[0]);
});

Then("response body should have key {string} with tomorrow date", async function (key: string) {
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    await APICommon.validateResponseBodyKeyValue(key, tomorrow.toISOString().split("T")[0] + " 00:00:00");
});

Then("response body should have key {string} with today date", async function (key: string) {
    const today = new Date();
    today.setDate(today.getDate());
    await APICommon.validateResponseBodyKeyValue(key, today.toISOString().split("T")[0] + " 00:00:00");
});
Then(
    "response body should have index key with values from file {string}",
    async function (fileName: string, dataTable) {
        const rows = dataTable.hashes() as Array<{ index: number; key: string; value: string }>;

        for (const { index, key } of rows) {
            const value = await APICommon.getResponseValueFromFileByIndex(fileName, index, key);
            apiFixture.logger.info(`value: ${JSON.stringify(value, null, 2)} `);

            await APICommon.validateSecondResponseBodyKeyValue(index, key, value);
        }
    },
);

When("user store the unique value for key:", function (table) {
    const data = table.hashes() as Array<{ key: string }>;
    for (const row of data) {
        APICommon.storeUniqueData(row.key);
    }
});

When("user add payload key with stored key value:", function (table) {
    const data = table.hashes() as Array<{ payloadKey: string; storedkey: string }>;
    for (const row of data) {
        APICommon.setRequestBodyWithStoredKey(row.payloadKey, row.storedkey);
    }
});

When(
    "user login into the {string} application with {string} user on {string} page",
    async function (app: string, userName: string, pageName: string) {
        switch (app.toLowerCase()) {
            case "clm": {
                await pageFixture.page.goto(process.env.BASEURL);
                await pageFixture.page.fill(Common.getTheElement("UserName", pageName), process.env[userName]);
                await pageFixture.page.click(Common.getTheElement("Submit", pageName));
                await pageFixture.page.fill(
                    Common.getTheElement("Password", pageName),
                    process.env[`${userName + "Password"} `],
                );
                await pageFixture.page.click(Common.getTheElement("Submit", pageName));
                await pageFixture.page.click(Common.getTheElement("Submit", pageName));
                break;
            }
        }
    },
);

When("user login into the {string} application with {string} user", async function (app: string, userName: string) {
    await pageFixture.page.goto(process.env.BASEURL);
    switch (app.toLowerCase()) {
        case "clm":
            pageFixture.logger.info(`Logging in with username: ${process.env[userName]}`);
            await pageFixture.page.fill(Common.getTheElement("UserName", "Login"), process.env[userName]);
            await pageFixture.page.click(Common.getTheElement("Submit", "Login"));
            await pageFixture.page.fill(
                Common.getTheElement("Password", "Login"),
                process.env[`${userName + "Password"}`],
            );
            await pageFixture.page.click(Common.getTheElement("Submit", "Login"));
            await pageFixture.page.click(Common.getTheElement("StaySignedSInNoButton", "Login"));
            break;
    }
});

Then(
    "user clicks on {string} button associate with text {string} on {string}",
    async function (buttonName, text, pageName) {
        // Step 1: Get selector template from JSON
        const selectorTemplate = Common.getTheElement(buttonName, pageName);
        // Step 2: Inject dynamic text
        const formattedSelector = sprintf(selectorTemplate, text);
        // Step 3: Use central locator engine
        const element = await Common.getElementLocatorFromRaw(formattedSelector);

        await element.click();
        await pageFixture.page.waitForLoadState("load");
    },
);

When("user strict clicks on {string} button on {string}", async function (buttonName, pageName) {
    const buttonSelector = Common.getTheElement(buttonName, pageName);
    await pageFixture.page.locator(buttonSelector).click({
        // eslint-disable-next-line playwright/no-force-option
        force: true,
        timeout: 0,
    });
});

Then(
    "user add user by navigates User page and FirstName:{string},LastName:{string} and email:{string} with unique suffix",
    async function (FirstName, LastName, email) {
        await pageFixture.page.click(Common.getTheElement("UserButton", "Home"));
        await pageFixture.page.click(Common.getTheElement("AddUser", "Users"));
        await pageFixture.page.fill(Common.getTheElement("FirstName", "Users"), FirstName);
        await pageFixture.page.fill(Common.getTheElement("LastName", "Users"), LastName);
        const emailId = email.replace("@", getRandomInt(5) + "@") as string;
        APICommon.storedataWithKeyAndValue("EmailID", emailId);
        await pageFixture.page.fill(Common.getTheElement("Email", "Users"), emailId);
        await pageFixture.page.click(Common.getTheElement("NextButton", "Users"));
        await pageFixture.page.click(Common.getTheElement("AddUserToSystemGroup", "Users"));
        await pageFixture.page.click(Common.getTheElement("ContinueButton", "Users"));
    },
);

Then("user should able see {string} with text {string} on {string} page", async function (elementName, pageName, text) {
    const elementLocator = await Common.getElementLocatorFromRaw(sprintf(Common.getTheElement(elementName, pageName), text,));
    try {
        await elementLocator.waitFor({ state: "visible" });
        this.attach(`Element "${elementName}" with text "${text}" is visible`);
    } catch (error) {
        throw new Error(`Element "${elementName}" with text "${text}" was not visible: ${error} `);
    }
});

Then(
    "user should able to see next to fields on {string} on {string} page:",
    async function (elementName: string, pageName: string, dataTable) {
        const rows = dataTable.hashes() as Array<{ text: string; fieldName: string }>;

        for (const { text, fieldName } of rows) {
            const locatorString: string = (await sprintf(
                Common.getTheElement(elementName, pageName),
                fieldName,
            )) as string;

            try {
                // Routes through resolveLocator so xpath, role=, chain=, text=, label=, etc. all work here
                const elementLocator = await Common.getElementLocatorFromRaw(locatorString);
                await elementLocator.waitFor({ state: "visible" });
                const data = (await elementLocator.textContent()).trim();
                if (data !== text) {
                    throw new Error(
                        `Element "${elementName}" text "${data}" does not match expected text "${text}" for field "${fieldName}".`,
                    );
                }
            } catch (error) {
                throw new Error(`Assertion failed for field "${fieldName}": ${error}`);
            }
        }
    },
);

Then("user close browser", async function () {
    await pageFixture.page.close();
});

Then("user store the response body have index keyData with keyName", async function (table) {
    const data = table.hashes() as Array<{ index: number; key: string; storeKey: string }>;
    for (const row of data) {
        await APICommon.storeResponseDataWithIndexKeyForNextAPI(row.index, row.key, row.storeKey);
    }
});

Then("response body should have key with keys from {string} file", async function (fileName: string, dataTable) {
    const rows: Array<{ keyFromResponse: string; keyFromFile: string }> = dataTable.hashes() as Array<{
        keyFromResponse: string;
        keyFromFile: string;
    }>;
    for (const { keyFromResponse, keyFromFile } of rows) {
        const value = await APICommon.getResponseValueFromFile(fileName, keyFromFile);
        await APICommon.validateResponseBodyKeyValue(keyFromResponse, value);
    }
});

Then("user store the response body have keyData with keyName", async function (table) {
    const data = table.hashes() as Array<{ key: string; storeKey: string }>;
    for (const row of data) {
        await APICommon.storeResponseDataWithKeyForNextAPI(row.key, row.storeKey);
    }
});

Then("response audit rows at {string} should match:", async function (arrayPath: string, table) {
    const rows = table.hashes() as Array<{
        idStoredKey: string;
        auditTypeID: string;
        idType: string;
        idTypeName: string;
        idValue: string;
        dateStoreKey: string;
        auditTypeStoreKey: string;
    }>;
    await APICommon.validateAndStoreAuditRows(arrayPath, rows);
});

Then("response body in ascending order should have index key with the value:", async function (dataTable) {
    const rows: Array<{ index: number; key: string; value: string }> = dataTable.hashes() as Array<{
        index: number;
        key: string;
        value: string;
    }>;
    for (const row of rows) {
        try {
            await APICommon.validateAscendingOrderResponseBodyKeyValue(row.index, row.key, row.value);
        } catch (error) {
            const enhancedError = new Error(
                `Validation failed for index "${row.index}"   key "${row.key}" with value "${row.value}":
                ${error instanceof Error ? error.message : String(error)}`,
            );
            // Mark the step as failed in Cucumber's reporting
            this.attach(JSON.stringify(row, null, 2), "application/json");
            throw enhancedError;
        }
    }
});

Then("response body in ascending order should have index key with the contains value:", async function (dataTable) {
    const rows: Array<{ index: number; key: string; value: string }> = dataTable.hashes() as Array<{
        index: number;
        key: string;
        value: string;
    }>;
    for (const row of rows) {
        try {
            await APICommon.validateAscendingOrderResponseBodyContainsKeyValue(row.index, row.key, row.value);
        } catch (error) {
            const enhancedError = new Error(
                `Validation failed for index "${row.index}"   key "${row.key}" with value "${row.value}":
                ${error instanceof Error ? error.message : String(error)}`,
            );
            // Mark the step as failed in Cucumber's reporting
            this.attach(JSON.stringify(row, null, 2), "application/json");
            throw enhancedError;
        }
    }
});

Then(
    "response body in ascending order should have index storedkey with the contains value:",
    async function (dataTable) {
        const rows: Array<{ index: number; key: string; storedKey: string }> = dataTable.hashes() as Array<{
            index: number;
            key: string;
            storedKey: string;
        }>;
        for (const row of rows) {
            try {
                await APICommon.validateAscendingOrderResponseBodyContainsStoredKeyValue(
                    row.index,
                    row.key,
                    row.storedKey,
                );
            } catch (error) {
                const enhancedError = new Error(
                    `Validation failed for index "${row.index}" with row.key "${row.key}" with value "${row.storedKey}": ${error instanceof Error ? error.message : error?.toString()}
                        `,
                );
                // Mark the step as failed in Cucumber's reporting
                this.attach(JSON.stringify(row, null, 2), "application/json");
                throw enhancedError;
            }
        }
    },
);

Then("response body in ascending order should have index storekey with the value:", async function (dataTable) {
    const rows: Array<{ index: number; key: string; storekey: string }> = dataTable.hashes() as Array<{
        index: number;
        key: string;
        storekey: string;
    }>;
    for (const row of rows) {
        try {
            await APICommon.validateAscendingOrderResponseBodyContainsStoreKeyValue(row.index, row.key, row.storekey);
        } catch (error) {
            const enhancedError = new Error(
                `Validation failed for index "${row.index}" wity  "${row.key}" with value "${row.storekey}": 
                ${error instanceof Error ? error.message : String(error)} `,
            );
            // Mark the step as failed in Cucumber's reporting
            this.attach(JSON.stringify(row, null, 2), "application/json");
            throw enhancedError;
        }
    }
});

Then(
    "response body should have {int} key {string} with the contains stored key value {string}",
    async function (index, responseBodykey, storedKey) {
        await APICommon.validateSecondResponseBodyKeyWithStoredContainsValue(index, responseBodykey, storedKey);
    },
);

When("user store value:{string} with keyName:{string}", function (value, storedKey) {
    APICommon.storeValueForKey(value, storedKey);
});

Then("response body should be an empty array", async () => {
    await APICommon.validateResponseBodyIsEmptyArray();
});

Then("response should have {int} records", async function (expectedCount: number) {
    await APICommon.validateResponseArrayCount(expectedCount);
});

Then("response should have {int} records at path {string}", async function (expectedCount: number, pathKey: string) {
    await APICommon.validateResponseArrayCount(expectedCount, pathKey);
});

Then("response body should have array index key with the value:", async function (dataTable) {
    const rows = dataTable.hashes() as Array<{ arrayName: string; index: number; key: string; value: string }>;

    for (const row of rows) {
        try {
            await APICommon.validateResponseArrayItemKeyValue(row.arrayName, Number(row.index), row.key, row.value);
        } catch (error) {
            const enhancedError = new Error(
                `Validation failed for array "${row.arrayName}" at index "${row.index}" with key "${row.key}" and value "${row.value}":\n${error instanceof Error ? error.message : String(error)
                }`,
            );
            this.attach(JSON.stringify(row, null, 2), "application/json");
            throw enhancedError;
        }
    }
});

Then("response body should contain tenants with expected values:", async function (dataTable) {
    const rawRows = dataTable.hashes() as Array<{
        index: string;
        key: string;
        value: string;
    }>;

    const grouped = rawRows.reduce<Record<number, Record<string, any>>>((acc, { index, key, value }) => {
        const idx = Number(index);
        acc[idx] ??= {};
        acc[idx][key] = value;
        return acc;
    }, {});

    const expectedTenants: Array<Record<string, any>> = [];

    const sortedIndexes = Object.keys(grouped)
        .map(Number)
        .sort((a, b) => a - b);

    for (const idx of sortedIndexes) {
        expectedTenants.push(grouped[idx]);
    }

    await APICommon.validateTenantsArrayFlexible(expectedTenants);
});

Then(
    "response body for Risk Outcome in ascending order should have index key with the value:",
    async function (dataTable) {
        const rows: Array<{ index: number; key: string; value: string }> = dataTable.hashes() as Array<{
            index: number;
            key: string;
            value: string;
        }>;
        for (const row of rows) {
            try {
                await APICommon.validateAscendingOrderResponseBodyKeyValueForRiskScoreOutcome(
                    row.index,
                    row.key,
                    row.value,
                );
            } catch (error) {
                const enhancedError = new Error(
                    `Validation failed for index "${row.index}"   key "${row.key}" with value "${row.value}":
                ${error instanceof Error ? error.message : String(error)}`,
                );
                // Mark the step as failed in Cucumber's reporting
                this.attach(JSON.stringify(row, null, 2), "application/json");
                throw enhancedError;
            }
        }
    },
);

Then(
    "response body in ascending order should have index based on array key with the value:",
    async function (dataTable) {
        const rows: Array<{ index: number; key: string; value: string }> = dataTable.hashes() as Array<{
            index: number;
            key: string;
            value: string;
        }>;
        for (const row of rows) {
            try {
                await APICommon.validateAscendingOrderResponseBodyKeyIsArrayValue(row.index, row.key, row.value);
            } catch (error) {
                const enhancedError = new Error(
                    `Validation failed for index "${row.index}"   key "${row.key}" with value "${row.value}":
                ${error instanceof Error ? error.message : String(error)}`,
                );
                // Mark the step as failed in Cucumber's reporting
                this.attach(JSON.stringify(row, null, 2), "application/json");
                throw enhancedError;
            }
        }
    },
);

Given("user has raw payloads with dynamic values:", function (rawBody) {
    APICommon.setJsonRawBodyDynamicValue(rawBody);
});

Then(
    "user should be able to see {string} with text {string} on {string} page",
    async function (elementName, text, pageName) {
        const elementLocator = await Common.getElementLocatorFromRaw(
            sprintf(Common.getTheElement(elementName, pageName), text),
        );
        try {
            await elementLocator.waitFor({ state: "visible" });
            this.attach(`Element "${elementName}" with text "${text}" is visible`);
        } catch (error) {
            throw new Error(
                `Element "${elementName}" with text "${text}" was not visible: ${error instanceof Error ? error.message : String(error)
                }`,
            );
        }
    },
);

Given("user adds {string} image to the payload", async function (imageName) {
    // Construct the full path
    const imagePath = path.resolve(process.cwd(), "src/testData", imageName);

    // 1. Check if the file exists using the namespaced fs
    if (!fs.existsSync(imagePath)) {
        throw new Error(`[File Not Found] No image found at: ${imagePath}.`);
    }

    try {
        // 2. Read file using the promises API from the fs namespace
        const imageBuffer = await fs.promises.readFile(imagePath);
        const base64String = imageBuffer.toString("base64");

        // 3. Append to your form payload
        APICommon.addBase64ToFormPayload(base64String);

        console.log(`Successfully attached ${imageName} to payload.`);
    } catch (error) {
        if ((error as NodeJS.ErrnoException).code === "ENOENT") {
            throw new Error(`[File Not Found] No image found at: ${imagePath}`);
        }
        throw new Error(
            `[Base64 Error] Failed to process image "${imageName}": ${error instanceof Error ? error.message : String(error)
            }`,
        );
    }
});

When("user logs out and logs in with {string} username", async function (userName: string) {
    // Click profile button to open menu
    await pageFixture.page.click(Common.getTheElement("ProfileBtn", "Common"));
    // Click logout button
    await pageFixture.page.click(Common.getTheElement("LogOutBtn", "Common"));
    // Wait for user card on sign out page to be visible
    await pageFixture.page.waitForLoadState("load");
    await pageFixture.page.click(Common.getTheElement("UserCardOnSignOut", "Common"));
    await pageFixture.page.click(Common.getTheElement("LoginButton", "Common"));
    await pageFixture.page.click(Common.getTheElement("UseAnotherAccountBtn", "Common"));
    // Login again
    await pageFixture.page.fill(Common.getTheElement("UserName", "Login"), process.env[userName]);
    await pageFixture.page.click(Common.getTheElement("Submit", "Login"));
    await pageFixture.page.fill(Common.getTheElement("Password", "Login"), process.env[`${userName + "Password"}`]);
    await pageFixture.page.click(Common.getTheElement("Submit", "Login"));
});

Then("response body have key with the value for nested object:", async function (dataTable) {
    const rows: Array<{ key: string; value: string }> = dataTable.hashes() as Array<{
        key: string;
        value: string;
    }>;
    for (const row of rows) {
        try {
            await APICommon.validateResponseBodyKeyValueForNestedObject(row.key, row.value);
        } catch (error) {
            const enhancedError = new Error(
                `Validation failed for  key "${row.key}" with value "${row.value}":
                ${error instanceof Error ? error.message : String(error)}`,
            );
            // Mark the step as failed in Cucumber's reporting
            this.attach(JSON.stringify(row, null, 2), "application/json");
            throw enhancedError;
        }
    }
});

When("user uploads file with stored url {string}:", async function (storedUrlKey: string, dataTable) {
    const row = dataTable.hashes()[0] as { file: string; mimeType?: string };

    const file = {
        file: row.file,
        mimeType: row.mimeType,
    };

    apiFixture.logger.info(`Uploading file to stored URL with key "${storedUrlKey}": ${JSON.stringify(file, null, 2)}`);

    await APICommon.uploadFileToStoredUrl(storedUrlKey, file);
});

Given("user has a service named {string} and has a payload from the file {string}", async function (endPoint, filename) {
    APICommon.setAPIServie(endPoint);
    await APICommon.setFilePayload(filename);
});

When("user sends a {string} request and checks response status {int}", async function (action, status) {
    await APICommon.sendRequest(action);
    await APICommon.checkResponseStatusCode(status);
});

When(
    "user adds payloads with stored keys:",
    function (dataTable) {

        dataTable.hashes().forEach((row: any) => {
            APICommon.setRequestBodyWithStoredKeyTable(
                row.Key,
                row.StoredKey
            );
        });
    }
);

When(
    "user creates an onboarding for prospect {string} and store the response body keyData:{string} with keyName:{string}",
    async function (prospectId: string, keyData: string, keyName: string) {
        APICommon.storeValueForKey(prospectId, "prospectID");
        const onboardingId = await APICommon.createOnboardingForProspect(prospectId);
        if (keyData !== "ClientOnboardingID") {
            throw new Error(`Unsupported keyData '${keyData}'. Expected 'ClientOnboardingID'.`);
        }
        APICommon.storeValueForKey(onboardingId, keyName);
        if (keyName !== "onboardingID") {
            APICommon.storeValueForKey(onboardingId, "onboardingID");
        }
    },
);

When(
    "user creates an onboarding for prospect {string} with risk model type {string} and store the response body keyData:{string} with keyName:{string}",
    async function (prospectId: string, riskModelType: string, keyData: string, keyName: string) {
        APICommon.storeValueForKey(prospectId, "prospectID");
        const onboardingId = await APICommon.createOnboardingForProspect(prospectId, riskModelType);
        if (keyData !== "ClientOnboardingID") {
            throw new Error(`Unsupported keyData '${keyData}'. Expected 'ClientOnboardingID'.`);
        }
        APICommon.storeValueForKey(onboardingId, keyName);
        if (keyName !== "onboardingID") {
            APICommon.storeValueForKey(onboardingId, "onboardingID");
        }
    },
);

When(
    "user creates a data request and collection link for prospect {string} and stored onboarding {string} and store the response body keyData:{string} with keyName:{string}",
    async function (prospectId: string, onboardingStoredKey: string, keyData: string, keyName: string) {
        const onboardingId = APICommon.getStoredData(onboardingStoredKey);
        const dataRequestLink = await APICommon.createDataRequestAndCollectionLink(prospectId, onboardingId);
        if (keyData !== "DataRequestLink") {
            throw new Error(`Unsupported keyData '${keyData}'. Expected 'DataRequestLink'.`);
        }
        APICommon.storeValueForKey(dataRequestLink, keyName);
    },
);