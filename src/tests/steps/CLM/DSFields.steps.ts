import { Then, When } from "@cucumber/cucumber";
import { pageFixture } from "../../../hooks/pagefixtures";
import { Common } from "../../../Helper/utilities/ui.utils";
import { sprintf } from "sprintf-js";
import { FrameworkConstant } from "../../../env/frameworkConstant";

Then(
    "user should see the following table columns in {string} on {string} page:",
    async function (tableHeaderLocatorName: string, pageName: string, dataTable: { raw: () => string[][] }) {
        const expectedColumns: string[] = dataTable.raw().flat();

        for (const columnName of expectedColumns) {
            const headerLocator = String(sprintf(Common.getTheElement(tableHeaderLocatorName, pageName), columnName));
            await pageFixture.page.waitForSelector(headerLocator, { state: "visible", timeout: 5000 });
            const isVisible = await pageFixture.page.isVisible(headerLocator, { timeout: 5000 });
            if (!isVisible) {
                throw new Error(`Table column "${columnName}" is not visible using locator: ${headerLocator}`);
            }
            pageFixture.logger.info(`Table column "${columnName}" is visible.`);
        }
    },
);

Then(
    "user should see the following validation errors for field {string} on {string} page:",
    async function (fieldName: string, pageName: string, dataTable: { raw: () => string[][] }) {
        const expectedErrors: string[] = dataTable.raw().flat();
        const selector = Common.getTheElement(fieldName, pageName);
        const listItems = pageFixture.page.locator(selector);
        // The error container can stay visible across an AJAX re-render, so checking
        // a one-time snapshot can race ahead of the updated messages. Each assertion
        // below auto-retries via Playwright's built-in polling until it appears or times out.
        for (const expected of expectedErrors) {
            const matchingItem = listItems.filter({ hasText: expected }).first();
            try {
                await pageFixture.expect(matchingItem).toBeVisible({ timeout: FrameworkConstant.actionTimeout() * 1000 });
                pageFixture.logger.info(`Found validation message: "${expected}"`);
            } catch {
                const actualErrors = (await listItems.allTextContents()).map(text => text.trim());
                throw new Error(
                    `Expected validation message "${expected}" not found. Found: [${actualErrors.join(", ")}]`,
                );
            }
        }
    },
);

Then(
    "user waits for {string} field on {string} page to be visible",
    async function (elementName: string, pageName: string) {
        const element = await Common.getElementLocator(elementName, pageName);

        await Common.waitForElement(element, elementName);

        pageFixture.logger.info(`${elementName} is visible on ${pageName} page.`);
    },
);

When(
    "user selects value {string} from dropdown {string} on page {string}",
    async function clickSelectOptionByValue(optionValue: string, selectXPath: string, page: string): Promise<void> {
        const select = await Common.getElementLocator(selectXPath, page);
        await select.waitFor({ state: "visible", timeout: 5000 });
        await select.click();
        await pageFixture.page.waitForTimeout(1000); // Wait for dropdown to open
        const options = select.locator("option");
        const count = await options.count();

        let targetIndex = -1;
        for (let i = 0; i < count; i++) {
            const option = options.nth(i);
            const value = await option.getAttribute("value");
            const text = (await option.textContent())?.trim();
            if (value === optionValue || text === optionValue) {
                targetIndex = i;
                break;
            }
        }
        pageFixture.logger.info(`Target index for option "${optionValue}": ${targetIndex}`);

        if (targetIndex === -1) {
            throw new Error(`Option with value/text "${optionValue}" not found`);
        }
        await select.focus();
        // Go to first option
        await pageFixture.page.keyboard.press("Home");
        for (let i = 0; i < targetIndex; i++) {
            await pageFixture.page.keyboard.press("ArrowDown");
        }
        await pageFixture.page.keyboard.press("Enter");
    },
);

When(
    "user selects risk rule condition value {string} from dropdown {string} on page {string}",
    async function (optionValue: string, dropdownName: string, pageName: string): Promise<void> {
        const dropdown = await Common.getElementLocator(dropdownName, pageName);

        await dropdown.selectOption({ label: optionValue });

        const selectedValue = await dropdown.locator("option:checked").textContent();
        if (selectedValue?.trim() !== optionValue) {
            throw new Error(
                `Expected "${optionValue}" in "${dropdownName}", but selected "${selectedValue?.trim() ?? ""}".`,
            );
        }

        pageFixture.logger.info(
            `Selected risk-rule condition option "${optionValue}" in "${dropdownName}".`,
        );
    },
);

Then(
    "the length of text entered in field {string} on page {string} should be {int}",
    async function (fieldSelector: string, pageName: string, expectedLength: number) {
        const selector = Common.getTheElement(fieldSelector, pageName);
        const field = pageFixture.page.locator(selector);
        await field.waitFor({ state: "visible", timeout: 5000 });

        const value = await field.inputValue();
        const length = value.length;

        pageFixture.logger.info(`Text in field "${fieldSelector}" has length: ${length}`);

        if (length !== expectedLength) {
            throw new Error(`Expected length ${expectedLength} but got ${length} for field "${fieldSelector}"`);
        }
    },
);

When(
    "user searches for {string} and sees only matching rows by Name or Description on {string} page",
    async function (searchText: string, pageName: string) {
        const searchFieldSelector = Common.getTheElement("SearchField", pageName);
        const rowSelector = Common.getTheElement("DSTableRow", pageName);

        const searchField = pageFixture.page.locator(searchFieldSelector);
        await searchField.fill(searchText);
        await pageFixture.page.keyboard.press("Enter"); // Trigger search if needed

        await pageFixture.page.waitForTimeout(1000);

        const allRows = pageFixture.page.locator(rowSelector);
        const rowCount = await allRows.count();

        for (let i = 0; i < rowCount; i++) {
            const row = allRows.nth(i);
            if (await row.isVisible()) {
                const nameCell = row.locator("td").nth(0).locator("div");
                const descCell = row.locator("td").nth(1).locator("div");
                const nameText = (await nameCell.textContent())?.trim() || "";
                const descText = (await descCell.textContent())?.trim() || "";

                if (
                    !nameText.toLowerCase().includes(searchText.toLowerCase()) &&
                    !descText.toLowerCase().includes(searchText.toLowerCase())
                ) {
                    throw new Error(
                        `Row ${i + 1} does not contain search text "${searchText}" in either Name or Description. Name: "${nameText}", Description: "${descText}"`,
                    );
                }
            }
        }
    },
);

// Search list and assert each visible row matches Name or Description.
When(
    "user searches for {string} on {string} and sees only matching results by Name or Description using {string} and {string} inside {string} on {string} page",
    async function (
        searchText: string,
        searchBox: string,
        nameLocatorKey: string,
        descLocatorKey: string,
        containerKey: string,
        pageName: string,
    ) {
        const searchFieldSelector = Common.getTheElement(searchBox, pageName);
        const containerSelector = Common.getTheElement(containerKey, pageName);
        const nameSelector = Common.getTheElement(nameLocatorKey, pageName);
        const descSelector = Common.getTheElement(descLocatorKey, pageName);

        const searchField = pageFixture.page.locator(searchFieldSelector);
        await searchField.fill(searchText);

        await pageFixture.page.keyboard.press("Enter"); // Trigger search if needed
        await pageFixture.page.waitForTimeout(1000);
        const allItems = pageFixture.page.locator(containerSelector);
        const itemCount = await allItems.count();
        
       for (let i = 0; i < itemCount; i++) {
            const item = allItems.nth(i);
            if (await item.isVisible()) {
                const name = (await item.locator(nameSelector).first().textContent())?.trim() || "";
                const desc = (await item.locator(descSelector).first().textContent())?.trim() || "";

                pageFixture.logger.info(`Item ${i + 1} - Name: "${name}", Description: "${desc}"`);

                if (
                    !name.toLowerCase().includes(searchText.toLowerCase()) &&
                    !desc.toLowerCase().includes(searchText.toLowerCase())
                ) {
                    throw new Error(
                        `Item ${i + 1} does not contain "${searchText}" in Name or Description.\nName: "${name}", Description: "${desc}"`,
                    );
                }
            }
        }
    },
);

When(
    "user Searches for {string} on {string} and sees only matching results by Name or Description using {string} and {string} inside {string} on {string} page",
    async function (
        searchText: string,
        searchBox: string,
        nameLocatorKey: string,
        descLocatorKey: string,
        containerKey: string,
        pageName: string,
    ) {
        const searchField = pageFixture.page.locator(Common.getTheElement(searchBox, pageName));

        await searchField.fill(searchText);
        await searchField.press("Enter");

        const rows = pageFixture.page.locator(Common.getTheElement(containerKey, pageName));

        // Use attached because rows may be present before becoming visibly stable.
        await rows.first().waitFor({ state: "attached" });

        const nameSelector = Common.getTheElement(nameLocatorKey, pageName);
        const descSelector = Common.getTheElement(descLocatorKey, pageName);

        const results = await rows.evaluateAll(
            (elements, selectors) => {
                const getText = (parent: Element, selector: string): string => {
                    const element =
                        selector.startsWith("//") || selector.startsWith(".//")
                            ? (document.evaluate(selector, parent, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null)
                                  .singleNodeValue as Element | null)
                            : parent.querySelector(selector);

                    return element?.textContent?.replace(/\s+/g, " ").trim() || "";
                };

                return elements
                    .filter(element => (element as HTMLElement).offsetParent !== null)
                    .map(element => ({
                        name: getText(element, selectors.name),
                        description: getText(element, selectors.description),
                    }));
            },
            {
                name: nameSelector,
                description: descSelector,
            },
        );

        if (results.length === 0) {
            throw new Error(`No visible results found for "${searchText}".`);
        }

        const searchValue = searchText.toLowerCase();

        const invalidResults = results.filter(
            result =>
                !result.name.toLowerCase().includes(searchValue) &&
                !result.description.toLowerCase().includes(searchValue),
        );

        if (invalidResults.length > 0) {
            throw new Error(
                `Some results do not contain "${searchText}" in Name or Description: ` +
                    `${JSON.stringify(invalidResults)}`,
            );
        }

        pageFixture.logger.info(
            `Verified all ${results.length} visible results contain ` + `"${searchText}" in Name or Description.`,
        );
    },
);

When("user press enter", async function () {
    await Promise.all([
        pageFixture.page.waitForLoadState("networkidle"),
        pageFixture.page.keyboard.press("Enter"),
    ]);
    pageFixture.logger.info("Pressed Enter key");
});

Then(
    "the table column {string} on {string} page should contain the following values:",
    async function (columnLocatorName: string, pageName: string, dataTable) {
        const locatorString = Common.getTheElement(columnLocatorName, pageName);
        const columnCells = pageFixture.page.locator(locatorString);

        // Wait until at least one cell is present
        await pageFixture.page.waitForSelector(locatorString, { state: "attached", timeout: 5000 });
        await columnCells.first().waitFor({ state: "visible" });

        const cellCount = await columnCells.count();
        if (cellCount === 0) {
            throw new Error(`No elements found for locator: ${locatorString}`);
        }

        interface DataTable {
            raw(): string[][];
        }

        const expectedValues: string[] = (dataTable as DataTable)
            .raw()
            .flat()
            .map((v: string) => v.trim());
        const foundValues = new Set<string>();

        for (let i = 0; i < cellCount; i++) {
            const cell = columnCells.nth(i);
            if (await cell.isVisible()) {
                const text = (await cell.textContent())?.trim() || "";
                pageFixture.logger.info(`Row ${i + 1} - Cell Text: "${text}"`);
                if (expectedValues.includes(text)) {
                    foundValues.add(text);
                }
            }
        }

        for (const value of expectedValues) {
            if (!foundValues.has(value)) {
                throw new Error(`Expected value "${value}" not found in the table column.`);
            }
        }

        pageFixture.logger.info(
            `All expected values [${expectedValues.join(", ")}] are present in the table column "${columnLocatorName}".`,
        );
    },
);

Then(
    "the table column {string} on {string} page Should Contain the following values:",
    async function (columnLocatorName: string, pageName: string, dataTable) {
        const columnCells = pageFixture.page.locator(Common.getTheElement(columnLocatorName, pageName));
        await pageFixture.page.waitForLoadState("networkidle")
        await pageFixture.page.waitForLoadState("load");
        await columnCells.first().waitFor({
            state: "attached",
        });

        const cellCount = await columnCells.count();

        if (cellCount === 0) {
            throw new Error(`No elements found for locator: ${columnLocatorName}`);
        }

        interface DataTable {
            raw(): string[][];
        }

        const normalizeText = (value: string): string => value.replace(/\s+/g, " ").trim();

        const expectedValues: string[] = (dataTable as DataTable)
            .raw()
            .flat()
            .map(normalizeText)
            .filter(value => value !== "");
        /*
         * Get text only from visible cells in one browser-side operation.
         * This avoids slow individual isVisible() and textContent() calls.
         */
        const actualValues: string[] = await columnCells.evaluateAll(elements =>
            elements
                .filter(element => {
                    const htmlElement = element as HTMLElement;
                    const style = window.getComputedStyle(htmlElement);

                    return (
                        style.display !== "none" &&
                        style.visibility !== "hidden" &&
                        htmlElement.getClientRects().length > 0
                    );
                })
                .map(element => (element.textContent || "").replace(/\s+/g, " ").trim())
                .filter(text => text.length > 0),
        );

        pageFixture.logger.info(`Visible values: [${actualValues.join(", ")}]`);

        const missingValues = expectedValues.filter(
            expected => !actualValues.some(actual => actual.includes(expected)),
        );

        if (missingValues.length > 0) {
            throw new Error(
                `Expected values [${missingValues.join(", ")}] were not found ` +
                    `in the visible table column cells. ` +
                    `Available visible values: [${actualValues.join(", ")}].`,
            );
        }

        pageFixture.logger.info(
            `All expected values [${expectedValues.join(", ")}] are present ` +
                `in the visible cells of table column "${columnLocatorName}".`,
        );
    },
);

When(
    "user clicks View button for the first {string} data type in element {string} and {string} on {string} page",
    async function (eleName: string, dataTypeColumn: string, viewButtonColumn: string, pageName: string) {
        const dataTypeLocator = Common.getTheElement(dataTypeColumn, pageName);
        const viewButtonLocator = Common.getTheElement(viewButtonColumn, pageName);

        const dataTypeCells = pageFixture.page.locator(dataTypeLocator);
        const viewButtons = pageFixture.page.locator(viewButtonLocator);
        const count = await dataTypeCells.count();

        let found = false;
        for (let i = 0; i < count; i++) {
            const cell = dataTypeCells.nth(i);
            if (await cell.isVisible()) {
                const text = (await cell.textContent())?.trim().toLowerCase() || "";
                if (text.includes(eleName.toLowerCase())) {
                    const viewButton = viewButtons.nth(i);
                    await viewButton.waitFor({ state: "visible" });
                    await viewButton.click();
                    pageFixture.logger.info(`Clicked View button for first ${eleName} data type at row ${i + 1}`);
                    found = true;
                    break;
                }
            }
        }

        if (!found) {
            throw new Error(`No ${eleName} data type found in the table.`);
        }
    },
);

When(
    "user Clicks View Button for the first {string} data type with value {string} in element {string} and {string} on {string} page",
    async function (dataType: string, dataTypeValue: string, dataTypeColumn: string, viewButtonColumn: string, pageName: string,) {
        const dataTypeRow = await Common.getElementLocatorFromRaw(
            sprintf(Common.getTheElement(dataTypeColumn, pageName), dataTypeValue),
        );

        await dataTypeRow.waitFor({
            state: "visible",
        });

        const viewButton = await Common.getElementLocatorFromRaw(
            sprintf(Common.getTheElement(viewButtonColumn, pageName), dataTypeValue),
        );

        await viewButton.waitFor({
            state: "visible",
        });

        await viewButton.click();

        pageFixture.logger.info(
            `Clicked View button for the first "${dataType}" data type ` +
                `with value "${dataTypeValue}" on "${pageName}" page.`,
        );
    },
);

Then(
    "the field {string} on {string} page should be {string}",
    async function (elementName: string, pageName: string, checkType: string) {
        const locatorString = Common.getTheElement(elementName, pageName);
        const element = pageFixture.page.locator(locatorString);

        switch (checkType) {
            case "disabled": {
                await element.waitFor({ state: "visible" });
                const isDisabled = (await element.isDisabled())||(await element.getAttribute("aria-disabled")) === "true";;
                if (!isDisabled) {
                    throw new Error(`Field "${elementName}" on "${pageName}" page is not disabled.`);
                }
                pageFixture.logger.info(`Field "${elementName}" on "${pageName}" page is disabled as expected.`);
                break;
            }

            // Poll until enabled — KYC operator dropdown may render after field selection.
            case "enabled": {
                await element.waitFor({ state: "visible" });
                const timeout = 10000;
                const interval = 200;
                let isEnabled = false;
                const start = Date.now();
                while (Date.now() - start < timeout) {
                    isEnabled = await element.isEnabled();
                    if (isEnabled) {
                        break;
                    }
                    await pageFixture.page.waitForTimeout(interval);
                }
                if (!isEnabled) {
                    throw new Error(`Field "${elementName}" on "${pageName}" page is not enabled.`);
                }
                pageFixture.logger.info(`Field "${elementName}" on "${pageName}" page is enabled as expected.`);
                break;
            }

            case "readonly": {
                await element.waitFor({ state: "visible" });

                // Wait until the element has the readonly attribute
                // Poll for readonly attribute for up to 5 seconds
                const timeout = 5000;
                const interval = 200;
                let isReadOnly = false;
                const start = Date.now();
                while (Date.now() - start < timeout) {
                    isReadOnly = !!(await element.getAttribute("readonly"));
                    if (isReadOnly) break;
                    await pageFixture.page.waitForTimeout(interval);
                }
                if (!isReadOnly) {
                    throw new Error(`Field "${elementName}" on "${pageName}" page is not yet read-only.`);
                }

                pageFixture.logger.info(`Field "${elementName}" on "${pageName}" page became read-only as expected.`);
                break;
            }

            case "not readonly": {
                await element.waitFor({ state: "visible" });
                const isReadOnly = !!(await element.getAttribute("readonly"));
                if (isReadOnly) {
                    throw new Error(`Field "${elementName}" on "${pageName}" page is read-only.`);
                }
                pageFixture.logger.info(`Field "${elementName}" on "${pageName}" page is not read-only as expected.`);
                break;
            }

            case "hidden": {
                const isHidden = await element.isHidden();
                if (!isHidden) {
                    throw new Error(`Field "${elementName}" on "${pageName}" page is not hidden.`);
                }
                pageFixture.logger.info(`Field "${elementName}" on "${pageName}" page is hidden as expected.`);
                break;
            }

            case "Not Hidden": {
                await element.waitFor({ state: "visible", timeout: 5000 });
                const isNotHidden = await element.isHidden();
                if (isNotHidden) {
                    throw new Error(`Field "${elementName}" on "${pageName}" page is hidden.`);
                }
                pageFixture.logger.info(`Field "${elementName}" on "${pageName}" page is not hidden as expected.`);
                break;
            }

            default: {
                throw new Error(
                    `Unknown check type "${checkType}". Use "disabled", "enabled", "readonly", "not readonly", "hidden", or "Not Hidden".`,
                );
            }
        }
    },
);

Then(
    "the search result count should be {string} the total count in element {string} on {string} page",
    async function (comparison: string, elementName: string, pageName: string) {
        const locatorString = Common.getTheElement(elementName, pageName);
        const element = pageFixture.page.locator(locatorString);
        await element.waitFor({ state: "visible", timeout: 5000 });

        const text = (await element.textContent())?.trim() || "";

        const match = text.match(/(\d+)\s*of\s*(\d+)/i);
        if (!match) {
            throw new Error(`Could not extract counts from: "${text}"`);
        }

        const showing = parseInt(match[1], 10);
        const total = parseInt(match[2], 10);

        switch (comparison) {
            case "zero": {
                if (showing !== 0) {
                    throw new Error(`Expected showing count to be zero, but got ${showing}`);
                }
                pageFixture.logger.info(`Showing count is 0 as expected. Total count: ${total}`);
                break;
            }

            case "less": {
                if (showing >= total) {
                    throw new Error(`Expected showing count to be less than total (${total}), but got ${showing}`);
                }
                pageFixture.logger.info(`Showing count (${showing}) is less than total count (${total}) as expected.`);
                break;
            }

            case "equal": {
                if (showing !== total) {
                    throw new Error(`Expected showing count to be equal to total (${total}), but got ${showing}`);
                }
                pageFixture.logger.info(`Showing count (${showing}) is equal to total count (${total}) as expected.`);
                break;
            }

            default: {
                throw new Error(`Unknown comparison type: "${comparison}". Use "zero", "less", or "equal".`);
            }
        }
    },
);

Then(
    "the toggle {string} on {string} page should be {string}",
    async function (elementName: string, pageName: string, expectedState: string) {
        const locatorString = Common.getTheElement(elementName, pageName);
        const toggle = pageFixture.page.locator(locatorString).first();
        await toggle.waitFor({ state: "visible", timeout: 5000 });

        const isChecked = await toggle.isChecked();

        if (expectedState.toLowerCase() === "on") {
            if (!isChecked) {
                throw new Error(`Toggle "${elementName}" on "${pageName}" page is OFF, but expected ON.`);
            }
            pageFixture.logger.info(`Toggle "${elementName}" on "${pageName}" page is ON as expected.`);
        } else if (expectedState.toLowerCase() === "off") {
            if (isChecked) {
                throw new Error(`Toggle "${elementName}" on "${pageName}" page is ON, but expected OFF.`);
            }
            pageFixture.logger.info(`Toggle "${elementName}" on "${pageName}" page is OFF as expected.`);
        } else {
            throw new Error(`Invalid expected state "${expectedState}" provided. Use "on" or "off".`);
        }
    },
);

// Turn toggle ON if needed, then wait for any list reload to finish.
When("user turns on the toggle {string} on {string} page", async function (elementName: string, pageName: string) {
    const locatorString = Common.getTheElement(elementName, pageName);
    const toggle = pageFixture.page.locator(locatorString).first();
    await toggle.waitFor({ state: "visible", timeout: 5000 });

    const isChecked = await toggle.isChecked();
    if (!isChecked) {
        await toggle.click();
        await pageFixture.page.waitForLoadState("networkidle");
        pageFixture.logger.info(`Toggle "${elementName}" on "${pageName}" page turned ON.`);
    } else {
        pageFixture.logger.info(`Toggle "${elementName}" on "${pageName}" page was already ON.`);
    }
});

When(
    "user adds the following list items on {string} page:",
    async function (
        pageName: string,
        dataTable: { hashes: () => Array<{ name: string; key: string; nameLocator: string; keyLocator: string }> },
    ) {
        const rows: Array<{ name: string; key: string; nameLocator: string; keyLocator: string }> = dataTable.hashes();

        const editButtonLocator = Common.getTheElement("ListEditButton", pageName);
        const editBtn = pageFixture.page.locator(editButtonLocator);
        await editBtn.waitFor({ state: "visible", timeout: 5000 });
        await editBtn.click();

        const addButtonLocator = Common.getTheElement("AddListItemButton", pageName);
        const addBtn = pageFixture.page.locator(addButtonLocator);
        for (let index = 0; index < rows.length; index++) {
            const row = rows[index];

            await addBtn.waitFor({ state: "visible", timeout: 5000 });
            await addBtn.click();
            pageFixture.logger.info(`Clicked Add button for row ${index + 1}`);

            const nameFieldLocator = Common.getTheElement(row.nameLocator, pageName);
            const keyFieldLocator = Common.getTheElement(row.keyLocator, pageName);

            const nameField = pageFixture.page.locator(nameFieldLocator);
            await nameField.waitFor({ state: "visible", timeout: 5000 });
            await nameField.fill(row.name);

            const keyField = pageFixture.page.locator(keyFieldLocator);
            await keyField.waitFor({ state: "visible", timeout: 5000 });
            await keyField.fill(row.key);

            pageFixture.logger.info(`Filled name "${row.name}" and key "${row.key}" for row ${index + 1}`);
        }

        const saveButtonLocator = Common.getTheElement("SaveButton", pageName);
        const saveBtn = pageFixture.page.locator(saveButtonLocator);
        await saveBtn.waitFor({ state: "visible", timeout: 5000 });
        await saveBtn.click();
        pageFixture.logger.info("Clicked Save button after adding all list items");
    },
);

Then(
    "the list hash key {string} value {string} in row {string} on {string} page should contain:",
    async function (
        nameCellLocatorName: string,
        keyCellLocatorName: string,
        rowLocatorName: string,
        pageName: string,
        dataTable: { hashes: () => Array<{ Name: string; Key: string }> },
    ) {
        const rowLocator = Common.getTheElement(rowLocatorName, pageName);
        const nameCellLocator = Common.getTheElement(nameCellLocatorName, pageName);
        const keyCellLocator = Common.getTheElement(keyCellLocatorName, pageName);

        const rows = pageFixture.page.locator(rowLocator);
        const rowCount = await rows.count();

        const expectedRows: Array<{ Name: string; Key: string }> = dataTable.hashes();

        if (rowCount < expectedRows.length) {
            throw new Error(`Table has ${rowCount} rows, but expected at least ${expectedRows.length}`);
        }

        for (let i = 0; i < expectedRows.length; i++) {
            const nameCell = pageFixture.page.locator(nameCellLocator).nth(i);
            const keyCell = pageFixture.page.locator(keyCellLocator).nth(i);

            const actualName = (await nameCell.textContent())?.trim() || "";
            const actualKey = (await keyCell.textContent())?.trim() || "";

            if (actualName !== expectedRows[i].Name || actualKey !== expectedRows[i].Key) {
                throw new Error(
                    `Row ${i + 1}: Expected Name="${expectedRows[i].Name}", Key="${expectedRows[i].Key}" but got Name="${actualName}", Key="${actualKey}"`,
                );
            }
            pageFixture.logger.info(`Row ${i + 1} matches: Name="${actualName}", Key="${actualKey}"`);
        }
    },
);

When(
    "user drags element {string} from {string} and drops it on element {string} on {string} on {string} page",
    async function (
        sourceName: string,
        sourceLocatorName: string,
        targetName: string,
        targetLocatorName: string,
        pageName: string,
    ) {
        const sourceLocator = String(sprintf(Common.getTheElement(sourceLocatorName, pageName), sourceName));
        const source = pageFixture.page.locator(sourceLocator).first();
        const targetLocator = String(sprintf(Common.getTheElement(targetLocatorName, pageName), targetName));
        const target = pageFixture.page.locator(targetLocator).first();

        await source.waitFor({ state: "visible", timeout: 5000 });
        await target.waitFor({ state: "visible", timeout: 5000 });

        await source.scrollIntoViewIfNeeded();
        await target.scrollIntoViewIfNeeded();

        const sourceBox = await source.boundingBox();
        const targetBox = await target.boundingBox();

        if (!sourceBox || !targetBox) {
            throw new Error(`Unable to determine bounding box for drag source or drop target.`);
        }
        // drag and drop using dragTo with force and targetPosition options, fallback to pointer-based drag if it fails
        try {
            await source.dragTo(target, {
                force: true,
                targetPosition: { x: Math.max(5, Math.round(targetBox.width / 2)), y: Math.max(5, Math.round(targetBox.height / 2)) },
            });
        } catch (error) {
            pageFixture.logger.warn(`Standard dragTo failed for ${sourceName}; falling back to pointer-based drag.`);

            await pageFixture.page.mouse.move(
                sourceBox.x + sourceBox.width / 2,
                sourceBox.y + sourceBox.height / 2,
                { steps: 5 },
            );
            await pageFixture.page.mouse.down();
            await pageFixture.page.mouse.move(
                targetBox.x + targetBox.width / 2,
                targetBox.y + targetBox.height / 2,
                { steps: 10 },
            );
            await pageFixture.page.mouse.up();
        }

        pageFixture.logger.info(
            `Dragged element "${sourceName}" and dropped on "${targetLocatorName}" on "${pageName}" page.`,
        );
    },
);

Then(
    "the list  {string} on {string} page should have the following values in order:",
    async function (listLocatorName: string, pageName: string, dataTable: { raw: () => string[][] }) {
        const locatorString = Common.getTheElement(listLocatorName, pageName);
        const items = pageFixture.page.locator(locatorString);
        const expectedValues: string[] = dataTable.raw().flat();
        await items.first().waitFor({ state: "visible", timeout: 5000 });
        const count = await items.count();
        if (count < expectedValues.length) {
            throw new Error(`List has ${count} items, but expected at least ${expectedValues.length}`);
        }

        for (let i = 0; i < expectedValues.length; i++) {
            const rawActual = await items.nth(i).textContent();
            const actual = rawActual?.replace(/\s+/g, " ").trim() || ""; // normalize actual text
            const expected = expectedValues[i].replace(/\s+/g, " ").trim(); // normalize expected text

            if (actual !== expected) {
                throw new Error(`At index ${i + 1}: expected "${expected}", but got "${actual}"`);
            }

            pageFixture.logger.info(`Index ${i + 1} matches: "${actual}"`);
        }
    },
);

When(
    "user enters {string} text in {string} field on {string} page and presses enter",
    async function (text: string, elementName: string, page: string) {
        await Common.typeText(elementName, page, text);
        if (page === "Refit") {
            await Common.clickElement("PropertyGropuName1", page);
        }
        await pageFixture.page.keyboard.press("Enter");
        pageFixture.logger.info(`Entered text "${text}" in "${elementName}" on "${page}" page and pressed Enter key`);
    },
);

Then(
    "user should not see the following validation errors for field {string} on {string} page:",
    async function (fieldName: string, pageName: string, dataTable: { raw: () => string[][] }) {
        const unexpectedErrors: string[] = dataTable.raw().flat();
        const selector = Common.getTheElement(fieldName, pageName);
        const listItems = pageFixture.page.locator(selector);
        const count = await listItems.count();
        const actualErrors: string[] = [];

        for (let i = 0; i < count; i++) {
            const text = (await listItems.nth(i).textContent())?.trim();
            if (text) actualErrors.push(text);
        }

        for (const unexpected of unexpectedErrors) {
            if (actualErrors.includes(unexpected)) {
                throw new Error(
                    `Validation message "${unexpected}" was found but should not be present. Found: [${actualErrors.join(", ")}]`,
                );
            } else {
                pageFixture.logger.info(`Validation message not present as expected: "${unexpected}"`);
            }
        }
    },
);

Then(
    "table {string} on {string} page should have at least {int} entries",
    async function (tableRowLocatorName: string, pageName: string, minimumEntries: number) {
        const rowSelector = Common.getTheElement(tableRowLocatorName, pageName);
        const rows = pageFixture.page.locator(rowSelector);

        await rows.first().waitFor({ state: "visible", timeout: 5000 });
        const rowCount = await rows.count();

        if (rowCount < minimumEntries) {
            throw new Error(
                `Table "${tableRowLocatorName}" has ${rowCount} entries on "${pageName}" page, expected at least ${minimumEntries}.`,
            );
        }

        pageFixture.logger.info(
            `Table "${tableRowLocatorName}" has ${rowCount} entries on "${pageName}" page (minimum required: ${minimumEntries}).`,
        );
    },
);

Then(
    "table {string} on {string} page should have {int} entries",
    async function (tableRowLocatorName: string, pageName: string, expectedEntries: number) {
        await pageFixture.page.waitForTimeout(1000);
        const rowSelector = Common.getTheElement(tableRowLocatorName, pageName);
        const rows = pageFixture.page.locator(rowSelector);

        if (expectedEntries > 0) {
            await rows.first().waitFor({ state: "visible", timeout: 5000 });
        }

        const rowCount = await rows.count();

        if (rowCount !== expectedEntries) {
            throw new Error(
                `Table "${tableRowLocatorName}" has ${rowCount} entries on "${pageName}" page, expected ${expectedEntries}.`,
            );
        }

        pageFixture.logger.info(
            `Table "${tableRowLocatorName}" has ${rowCount} entries on "${pageName}" page as expected.`,
        );
    },
);

Then('user should not be able to see {string} text using {string} locator on {string} page', async (text: string, locatorName: string, pageName: string) => {
    const selector = Common.getTheElement(locatorName, pageName);
    const elements = pageFixture.page.locator(selector);
    const count = await elements.count();

    for (let i = 0; i < count; i++) {
        const elementText = (await elements.nth(i).textContent())?.trim();
        if (elementText === text) {
            throw new Error(`Text "${text}" was found using locator "${locatorName}" on "${pageName}" page.`);
        }
    }

    pageFixture.logger.info(`Text "${text}" is not present using locator "${locatorName}" on "${pageName}" page as expected.`);
});

Then(
    "versions should be listed in descending order by created date using {string} on {string} page",
    async function (createdDateLocatorName: string, pageName: string) {
        await Common.validateVersionsListedInDescendingOrderByCreatedDate(createdDateLocatorName, pageName);
    },
);

// Verifies list-table status badges (Published, Draft, Archived) have the expected color class.
Then(
    "status badge {string} on {string} page should have style {string}",
    async function (statusText: string, pageName: string, style: string) {
        const locatorString = String(sprintf(Common.getTheElement("StatusBadge", pageName), statusText));
        const element = pageFixture.page.locator(locatorString);
        await element.first().waitFor({ state: "visible", timeout: 5000 });

        const classAttribute = await element.first().getAttribute("class");
        if (classAttribute === null) {
            throw new Error(`Status badge "${statusText}" has no class attribute: ${locatorString}`);
        }

        let expectedClassPart: string;
        switch (style.toLowerCase()) {
            case "yellow":
                expectedClassPart = "yellow";
                break;
            case "green":
                expectedClassPart = "green";
                break;
            case "gray":
                expectedClassPart = "gray";
                break;
            case "purple":
                expectedClassPart = "purple";
                break;
            default:
                throw new Error(`Unsupported status badge style '${style}'. Use 'yellow', 'green','purple', or 'gray'.`);
        }

        if (!classAttribute.toLowerCase().includes(expectedClassPart)) {
            throw new Error(
                `Expected status badge "${statusText}" to contain class '${expectedClassPart}', but actual class was '${classAttribute}'.`,
            );
        }

        pageFixture.logger.info(`Verified status badge "${statusText}" has ${style} style on "${pageName}" page.`);
    },
);

// Selects a dropdown option by visible text (matches value attribute and calls selectOption).
When(
    "user selects dropdown option by text {string} in {string} on page {string}",
    async function selectDropdownByText(optionText: string, dropdownName: string, pageName: string): Promise<void> {
        try {
            const dropdownSelector = Common.getTheElement(dropdownName, pageName);
            const dropdown = pageFixture.page.locator(dropdownSelector);

            await dropdown.waitFor({ state: "visible", timeout: 5000 });
            pageFixture.logger.info(`Dropdown "${dropdownName}" is visible`);

            const options = await dropdown.locator("option").all();
            const normalizedSearchText = optionText.trim().toLowerCase().replace(/\s+/g, " ");

            let found = false;
            for (const option of options) {
                const text = (await option.textContent())?.trim().toLowerCase().replace(/\s+/g, " ") || "";
                if (text === normalizedSearchText) {
                    const value = await option.getAttribute("value");
                    if (value) {
                        await dropdown.selectOption({ value });
                        pageFixture.logger.info(
                            `Successfully selected option "${optionText}" in dropdown "${dropdownName}"`,
                        );
                        found = true;
                        break;
                    }
                }
            }

            if (!found) {
                const availableOptions = [];
                for (const option of options) {
                    const text = await option.textContent();
                    if (text && text.trim()) {
                        availableOptions.push(text.trim());
                    }
                }
                throw new Error(
                    `Option "${optionText}" not found in dropdown "${dropdownName}". Available options: [${availableOptions.join(", ")}]`,
                );
            }
        } catch (error) {
            pageFixture.logger.error(
                `Error selecting dropdown option "${optionText}" in "${dropdownName}". Error: ${(error as Error).message}`,
            );
            throw new Error(
                `Failed to select option "${optionText}" in dropdown "${dropdownName}". Error: ${(error as Error).message}`,
            );
        }
    },
);

// Turn toggle OFF if needed, then wait for any list reload to finish.
When("user turns off the toggle {string} on {string} page", async function (elementName: string, pageName: string) {
    const locatorString = Common.getTheElement(elementName, pageName);
    const toggle = pageFixture.page.locator(locatorString);
    await toggle.waitFor({ state: "visible", timeout: 5000 });

    const isChecked = await toggle.isChecked();
    if (isChecked) {
        await toggle.click();
        await pageFixture.page.waitForLoadState("networkidle");
        pageFixture.logger.info(`Toggle "${elementName}" on "${pageName}" page turned OFF.`);
    } else {
        pageFixture.logger.info(`Toggle "${elementName}" on "${pageName}" page was already OFF.`);
    }
});

When(
    "user enter Date {string} text in {string} field on {string} page",
    async function (date: string, elementName: string, pageName: string) {
        const dateField = await Common.getElementLocator(elementName, pageName);

        await dateField.waitFor({ state: "visible" });

        await dateField.scrollIntoViewIfNeeded();

        // Remove readonly only when the date-picker input blocks keyboard input.
        const isReadOnly = (await dateField.getAttribute("readonly")) !== null;

        if (isReadOnly) {
            await dateField.evaluate(element => {
                element.removeAttribute("readonly");
            });
        }

        // Playwright fill() updates the live value and dispatches input events.
        await dateField.fill(date);

        // Dispatch change event for date-picker frameworks that rely on it.
        await dateField.dispatchEvent("change");

        const selectedDate = await dateField.inputValue();

        if (selectedDate !== date) {
            throw new Error(
                `Expected date "${date}" in field "${elementName}", ` + `but the field contained "${selectedDate}".`,
            );
        }

        pageFixture.logger.info(`Successfully entered date "${date}" in field ` + `"${elementName}" on "${pageName}" page.`,);
    },
);
