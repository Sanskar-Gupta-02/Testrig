import { Then, When } from "@cucumber/cucumber";
import { Locator } from "playwright";
import { sprintf } from "sprintf-js";
import { pageFixture } from "../../../hooks/pagefixtures";
import { Common } from "../../../Helper/utilities/ui.utils";

const KYC_MODELS_PAGE = "KYCModel";
const COMMON_PAGE = "Common";
const HOME_PAGE = "Home";
const CHART_WAIT_MS = 30000;
const POLL_TIMEOUT_MS = 10000;
const POLL_INTERVAL_MS = 300;
const SEARCH_SETTLE_MS = 1000;
const DROPDOWN_SELECTED_VERIFY_TIMEOUT_MS = 10000;
const DROPDOWN_SELECTED_VERIFY_INTERVAL_MS = 200;

// --- KYC Models list helpers (used by archive-if-exists before create) ---

async function verifyDropdownOptionSelected(
    optionName: string,
    elementName: string,
    pageName: string,
): Promise<void> {
    const element = await Common.getElementLocator(elementName, pageName);
    await element.waitFor({ state: "visible", timeout: 5000 });

    const trimmedExpected = optionName.trim();
    const start = Date.now();

    while (Date.now() - start < DROPDOWN_SELECTED_VERIFY_TIMEOUT_MS) {
        const selectedText = (await element.locator("option:checked").textContent())?.trim() || "";
        const isMatch =
            selectedText === trimmedExpected || (trimmedExpected === "Please select" && selectedText === "");
        if (isMatch) {
            pageFixture.logger.info(
                `Option '${trimmedExpected}' is selected in '${elementName}' on '${pageName}'.`,
            );
            return;
        }
        await pageFixture.page.waitForTimeout(DROPDOWN_SELECTED_VERIFY_INTERVAL_MS);
    }

    const selectedText = (await element.locator("option:checked").textContent())?.trim() || "";
    throw new Error(
        `Expected '${trimmedExpected}' to be selected in '${elementName}' on '${pageName}', but got '${selectedText}'.`,
    );
}

async function clickButtonWithText(buttonName: string, text: string, pageName: string): Promise<void> {
    const selector = String(sprintf(Common.getTheElement(buttonName, pageName), text));
    const element = await Common.getElementLocatorFromRaw(selector);
    await element.click();
    pageFixture.logger.info(`Clicked "${text}" on "${buttonName}" (${pageName}).`);
}

/** Wait until a wizard step is ready (title visible). Retries the title validation once if the step is not yet visible. */
async function waitForWizardStepTitle(
    titleElement: string,
    expectedText: string,
    options?: { retryNext?: boolean },
): Promise<void> {
    try {
        await Common.containsText(titleElement, expectedText, KYC_MODELS_PAGE);
        return;
    } catch (firstError) {
        if (!options?.retryNext) {
            throw firstError;
        }

        pageFixture.logger.info(
            `Wizard step "${expectedText}" not visible yet; retrying validation once.`,
        );

        await Common.containsText(titleElement, expectedText, KYC_MODELS_PAGE);
    }
}

function kycModelsTableRows(): Locator {
    return pageFixture.page.locator(Common.getTheElement("KYCModelsTableRow", KYC_MODELS_PAGE));
}

async function getTextFromRowLocator(row: Locator, selector: string): Promise<string> {
    const candidate = row.locator(selector).first();
    if (!(await candidate.isVisible().catch(() => false))) {
        return "";
    }
    return ((await candidate.textContent()) ?? "").trim();
}

async function getKycModelRowName(row: Locator): Promise<string> {
    const nameSelectors = Common.getTheElement("KYCModelsTableRowName", KYC_MODELS_PAGE)
        .split(",")
        .map((part) => part.trim());

    for (const selector of nameSelectors) {
        const text = await getTextFromRowLocator(row, selector);
        if (text && text.toLowerCase() !== "view") {
            return text;
        }
    }

    return "";
}

async function getKycModelRowDescription(row: Locator): Promise<string> {
    const name = await getKycModelRowName(row);
    const descSelectors = Common.getTheElement("KYCModelsTableRowDescription", KYC_MODELS_PAGE)
        .split(",")
        .map((part) => part.trim());

    for (const selector of descSelectors) {
        const text = await getTextFromRowLocator(row, selector);
        if (text && text !== name) {
            return text;
        }
    }

    return "";
}

async function findVisibleKycModelRowByName(
    modelName: string,
    timeoutMs = POLL_TIMEOUT_MS,
): Promise<Locator | null> {
    const rows = kycModelsTableRows();
    const start = Date.now();

    while (Date.now() - start < timeoutMs) {
        const count = await rows.count();

        for (let index = 0; index < count; index++) {
            const row = rows.nth(index);
            if (!(await row.isVisible().catch(() => false))) {
                continue;
            }

            const name = await getKycModelRowName(row);
            const desc = await getKycModelRowDescription(row);
            pageFixture.logger.info(`KYC list row ${index + 1} name: "${name}", description: "${desc}"`);

            if (name === modelName) {
                return row;
            }
        }

        await pageFixture.page.waitForTimeout(POLL_INTERVAL_MS);
    }

    return null;
}

async function openKycModelDetailFromList(modelName: string): Promise<void> {
    await clickButtonWithText("CommonTableViewBtn", modelName, "Common");
    await pageFixture.page.waitForLoadState("load");
    pageFixture.logger.info(`Opened KYC model detail for "${modelName}".`);
}

function getKycModelsSearchField(): Locator {
    return pageFixture.page.locator(Common.getTheElement("KYCModelsSearchBox", KYC_MODELS_PAGE));
}

function getRiskLevelCheckboxLabel(riskLevel: string): Locator {
    const selector = String(sprintf(Common.getTheElement("CheckboxByLabel", KYC_MODELS_PAGE), riskLevel));
    return pageFixture.page.locator(`xpath=${selector}`).first();
}

async function waitForRiskLevelCheckbox(riskLevel: string): Promise<void> {
    const checkboxLabel = getRiskLevelCheckboxLabel(riskLevel);
    const isVisible = await waitUntilVisible(checkboxLabel);
    if (!isVisible) {
        throw new Error(
            `Risk level checkbox "${riskLevel}" did not appear within ${POLL_TIMEOUT_MS}ms after selecting risk model.`,
        );
    }
    pageFixture.logger.info(`Risk level checkbox "${riskLevel}" is visible; proceeding to check.`);
}

async function searchKycModels(searchTerm: string): Promise<void> {
    const searchField = getKycModelsSearchField();
    await searchField.waitFor({ state: "visible", timeout: 5000 });
    await searchField.fill(searchTerm);
    await pageFixture.page.keyboard.press("Enter");
    await pageFixture.page.waitForTimeout(SEARCH_SETTLE_MS);
}

async function clearKycModelsSearch(): Promise<void> {
    await searchKycModels("");
}

async function waitUntilVisible(locator: Locator, timeoutMs = POLL_TIMEOUT_MS): Promise<boolean> {
    const start = Date.now();
    while (Date.now() - start < timeoutMs) {
        if (await locator.isVisible()) {
            return true;
        }
        await pageFixture.page.waitForTimeout(POLL_INTERVAL_MS);
    }
    return false;
}

async function ensureShowArchivedOff(): Promise<void> {
    const toggle = pageFixture.page.locator(Common.getTheElement("KYCModelsShowArchivedToggle", KYC_MODELS_PAGE));
    await toggle.waitFor({ state: "visible", timeout: 5000 });
    if (await toggle.isChecked()) {
        await toggle.uncheck();
        await pageFixture.page.waitForTimeout(500);
        pageFixture.logger.info("Show Archived toggle turned off before KYC model search.");
    }
}

async function expandArchiveSectionIfCollapsed(): Promise<void> {
    const element = await Common.getElementLocator("ArchiveSectionBtn", "Common");
    if ((await element.getAttribute("aria-expanded")) === "false") {
        await element.click();
        await pageFixture.page.waitForLoadState("load");
        pageFixture.logger.info("Archive section expanded.");
    }
}

async function returnToKycModelsList(): Promise<void> {
    const breadcrumbSelector = String(sprintf(Common.getTheElement("BreadcrumbLink", COMMON_PAGE), "KYC Models"));
    const breadcrumb = pageFixture.page.locator(`xpath=${breadcrumbSelector}`);

    if (await breadcrumb.first().isVisible().catch(() => false)) {
        await breadcrumb.first().click();
    } else {
        const sidebarSelector = String(sprintf(Common.getTheElement("SideBarMenu", HOME_PAGE), "KYC Models"));
        await pageFixture.page.locator(`xpath=${sidebarSelector}`).first().click();
    }

    await pageFixture.page.waitForLoadState("load");
}

async function archiveActiveKycModel(modelName: string): Promise<void> {
    pageFixture.logger.info(`Archiving KYC model "${modelName}".`);
    await openKycModelDetailFromList(modelName);
    //await expandArchiveSectionIfCollapsed();
    await Common.clickElement("ArchiveButton", "Common");
    await Common.typeText("ArchiveModalInputBox", KYC_MODELS_PAGE, modelName);
    await Common.clickElement("ArchiveModalSubmitBtn", KYC_MODELS_PAGE);
    await pageFixture.page.waitForLoadState("load");
    await returnToKycModelsList();
    await clearKycModelsSearch();
    pageFixture.logger.info(`KYC model "${modelName}" archived; returned to KYC Models list.`);
}

/** Search list by name, archive only the exact-named active row, then return to list. */
async function archiveKycModelIfExists(modelName: string): Promise<void> {
    await ensureShowArchivedOff();
    await searchKycModels(modelName);

    const row = await findVisibleKycModelRowByName(modelName, 5000);
    if (!row) {
        pageFixture.logger.info(`KYC model "${modelName}" not found on list; proceeding to create.`);
        await clearKycModelsSearch();
        return;
    }

    pageFixture.logger.info(`KYC model "${modelName}" exists; archiving before create.`);
    await archiveActiveKycModel(modelName);
}

/** Full Add wizard: Entity Type → Business Unit → Risk Model/Level → Name & Description. */
async function createKycModelViaWizard(
    modelName: string,
    description: string,
    entityType: string,
    businessUnit: string,
    riskModel: string,
    riskLevel: string,
): Promise<void> {
    await Common.clickElement("KYCModelsAddBtn", KYC_MODELS_PAGE);
    await clickButtonWithText("SelectItem", entityType, KYC_MODELS_PAGE);
    await clickButtonWithText("CommonBTN", "Next", "Common");
    await waitForWizardStepTitle("WizardBusinessUnitTitle", "Business Unit", { retryNext: true });
    await clickButtonWithText("SelectItem", businessUnit, KYC_MODELS_PAGE);
    await clickButtonWithText("CommonBTN", "Next", "Common");
    await waitForWizardStepTitle("WizardRiskLevelTargetingTitle", "Risk Level Targeting", {retryNext: true,});
    await Common.waitUntilElementIsVisible("RiskModelDropDown", KYC_MODELS_PAGE);
    await Common.selectDropdownOptionByTextOrValue("RiskModelDropDown", KYC_MODELS_PAGE, riskModel);
    await waitForRiskLevelCheckbox(riskLevel);
    await Common.checkCheckboxByLabel(riskLevel, KYC_MODELS_PAGE);
    await clickButtonWithText("CommonBTN", "Next", "Common");
    await waitForWizardStepTitle("WizardDetailsTitle", "Details", { retryNext: true });
    await Common.typeText("NameFieldBox", "Common", modelName);
    await Common.typeText("DescriptionFieldBox", "Common", description);
    await Common.clickElement("AddIconButton", "Common");
    await Common.clickElement("MedalIconButton", "Common");
    await Common.clickElement("AddBtn", KYC_MODELS_PAGE);
    await Common.clickElement("ContinueBtn", KYC_MODELS_PAGE);
}

Then(
    "user should verify {string} is selected in dropdown {string} on {string} page",
    async function (optionName: string, elementName: string, pageName: string) {
        await verifyDropdownOptionSelected(optionName, elementName, pageName);
    },
);

When(
    "user archives KYC model {string} if it exists on the list",
    async function (modelName: string) {
        await archiveKycModelIfExists(modelName);
    },
);

When(
    "user creates KYC model with name {string}, description {string}, entity type {string}, business unit {string}, risk model {string} and risk level {string}",
    async function (
        modelName: string,
        description: string,
        entityType: string,
        businessUnit: string,
        riskModel: string,
        riskLevel: string,
    ) {
        await createKycModelViaWizard(modelName, description, entityType, businessUnit, riskModel, riskLevel);
    },
);

function kycChartLocator(elementName: string): Locator {
    const selector = Common.getTheElement(elementName, KYC_MODELS_PAGE);
    return pageFixture.page.locator(`xpath=${selector}`);
}

async function assertMinimumChartElementCount(
    elementName: string,
    minimumCount: number,
    label: string,
): Promise<number> {
    const elements = kycChartLocator(elementName);
    await elements.first().waitFor({ state: "visible", timeout: CHART_WAIT_MS });
    const count = await elements.count();
    if (count < minimumCount) {
        throw new Error(`Expected at least ${minimumCount} ${label} on KYCModel page, found ${count}.`);
    }
    return count;
}

Then(
    "KYC checks over time chart should have at least {int} bars on KYCModel page",
    async function (minimumBars: number) {
        await assertMinimumChartElementCount("KycChecksOverTimeChartBars", minimumBars, "chart bars");
    },
);

Then(
    "KYC checks over time chart X-axis should have at least {int} day labels on KYCModel page",
    async function (minimumLabels: number) {
        await assertMinimumChartElementCount(
            "KycChecksOverTimeChartXAxisLabels",
            minimumLabels,
            "X-axis day labels",
        );
    },
);

Then(
    "KYC checks over time chart Y-axis should have at least {int} numeric result count labels on KYCModel page",
    async function (minimumLabels: number) {
        const count = await assertMinimumChartElementCount(
            "KycChecksOverTimeChartYAxisLabels",
            minimumLabels,
            "Y-axis numeric result count labels",
        );
        const labels = kycChartLocator("KycChecksOverTimeChartYAxisLabels");
        const numericPattern = /^\d+(\.\d+)?$/;

        for (let index = 0; index < count; index++) {
            const text = ((await labels.nth(index).textContent()) || "").trim();
            if (!numericPattern.test(text)) {
                throw new Error(
                    `Y-axis label "${text}" is not a numeric result count on KYC checks over time chart.`,
                );
            }
        }
    },
);

Then(
    "KYC checks over time chart models list should have at least {int} models on KYCModel page",
    async function (minimumModels: number) {
        await kycChartLocator("KycChecksOverTimeChart").waitFor({ state: "visible", timeout: CHART_WAIT_MS });
        await assertMinimumChartElementCount(
            "KycChecksOverTimeChartModelsListItems",
            minimumModels,
            "models in chart models list",
        );
    },
);

async function getLargestKycChartBar(): Promise<Locator> {
    const bars = kycChartLocator("KycChecksOverTimeChartBars");
    await bars.first().waitFor({ state: "visible", timeout: CHART_WAIT_MS });

    const count = await bars.count();
    let largestBar = bars.first();
    let largestHeight = 0;

    for (let index = 0; index < count; index++) {
        const bar = bars.nth(index);
        const svgHeight = Number.parseFloat((await bar.getAttribute("height")) || "0");
        const box = await bar.boundingBox();
        const visualHeight = Math.max(svgHeight, box?.height ?? 0);

        if (visualHeight > largestHeight) {
            largestHeight = visualHeight;
            largestBar = bar;
        }
    }

    if (largestHeight <= 0) {
        throw new Error("No KYC chart bar with visible height found for clicking.");
    }

    return largestBar;
}

When("user force clicks largest visible bar on KYC checks over time chart on KYCModel page", async function () {
    const bar = await getLargestKycChartBar();
    await bar.scrollIntoViewIfNeeded();

    await bar.click({
        // eslint-disable-next-line playwright/no-force-option
        force: true,
        timeout: CHART_WAIT_MS,
    });

    pageFixture.logger.info("Clicked largest visible bar on KYC checks over time chart.");
});

async function getKycChartBarTooltipText(): Promise<string> {
    const tooltip = kycChartLocator("KycChecksOverTimeChartBarTooltip");
    await tooltip.first().waitFor({ state: "visible", timeout: CHART_WAIT_MS });
    return ((await tooltip.first().textContent()) || "").replace(/\s+/g, " ").trim();
}

Then("KYC checks over time chart bar tooltip should include a date on KYCModel page", async function () {
    const tooltipText = await getKycChartBarTooltipText();
    const datePattern = /(?:\d{1,2}[/-]\d{1,2}[/-]\d{2,4}|\d{1,2}\s+[A-Za-z]{3}(?:\s+\d{4})?)/;

    if (!datePattern.test(tooltipText)) {
        throw new Error(`Expected bar tooltip to include a date. Tooltip text: ${tooltipText || "empty"}.`);
    }
});

Then(
    "KYC checks over time chart bar tooltip should include {string} count of at least {int} on KYCModel page",
    async function (countType: string, minimumCount: number) {
        const tooltipText = await getKycChartBarTooltipText();
        const match = tooltipText.match(new RegExp(`${countType}\\s*:?\\s*(\\d+)`, "i"));
        const actualCount = match ? Number.parseInt(match[1], 10) : 0;

        if (actualCount < minimumCount) {
            throw new Error(
                `Expected ${countType} count of at least ${minimumCount} in bar tooltip, found ${actualCount}. Tooltip text: ${tooltipText || "empty"}.`,
            );
        }
    },
);

const CHART_COLOR_NAME_TO_HEXES: Record<string, string[]> = {
    //Updated chart color mappings to support the current chart palette used by the KYC Checks Over Time widget. 
    // Added support for #00948c (pass/green) and #cc6b0a (fail/red category used by chart rendering) to ensure chart color validations continue to work after UI color updates.
    green: ["0ba337", "00a137","00948c"],
    pass: ["0ba337", "00a137","00948c"],
    red: ["a13b16", "e13b16", "a13016", "cc6b0a"],
    fail: ["a13b16", "e13b16", "a13016", "cc6b0a"],
};

function colorArgumentToHexes(colorArgument: string): string[] {
    function toHex(color: string): string | null {
        const normalized = color.trim().toLowerCase();
        if (!normalized || normalized === "none" || normalized === "transparent") {
            return null;
        }

        const hexMatch = normalized.match(/^#?([0-9a-f]{3,8})$/);
        if (hexMatch) {
            let hex = hexMatch[1];
            if (hex.length === 3) {
                hex = hex
                    .split("")
                    .map((ch) => ch + ch)
                    .join("");
            }
            return hex.length === 6 ? hex : null;
        }

        const rgbMatch = normalized.match(/rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)/);
        if (rgbMatch) {
            return [rgbMatch[1], rgbMatch[2], rgbMatch[3]]
                .map((value) => Number(value).toString(16).padStart(2, "0"))
                .join("");
        }

        return null;
    }

    function resolveColorToken(token: string): string[] {
        const normalized = token.trim().toLowerCase();
        const namedHexes = CHART_COLOR_NAME_TO_HEXES[normalized];
        if (namedHexes) {
            return namedHexes;
        }

        const hex = toHex(token);
        return hex ? [hex] : [];
    }

    const hexes: string[] = [];
    const parts = colorArgument.split(/[,|]/);
    for (let index = 0; index < parts.length; index++) {
        const resolvedHexes = resolveColorToken(parts[index]);
        for (let hexIndex = 0; hexIndex < resolvedHexes.length; hexIndex++) {
            const hex = resolvedHexes[hexIndex];
            if (hexes.indexOf(hex) === -1) {
                hexes.push(hex);
            }
        }
    }

    if (hexes.length === 0) {
        throw new Error(
            `Invalid color argument "${colorArgument}". Use a color name (green, red, pass, fail), hex (#0BA337), rgb(...), or comma-separated values.`,
        );
    }

    return hexes;
}

async function countKycChartBarsInColor(expectedHexes: string[]): Promise<{ count: number; fills: string[] }> {
    const bars = kycChartLocator("KycChecksOverTimeChartBars");
    await bars.first().waitFor({ state: "visible", timeout: CHART_WAIT_MS });
    const barsXPath = Common.getTheElement("KycChecksOverTimeChartBars", KYC_MODELS_PAGE);

    return pageFixture.page.evaluate(
        ({ colorHexes, chartBarsXPath }) => {
            function selectElements(xpath: string): Element[] {
                const elements: Element[] = [];
                const result = document.evaluate(
                    xpath,
                    document,
                    null,
                    XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,
                    null,
                );

                for (let index = 0; index < result.snapshotLength; index++) {
                    const node = result.snapshotItem(index);
                    if (node && node.nodeType === Node.ELEMENT_NODE) {
                        elements.push(node as Element);
                    }
                }

                return elements;
            }

            function toHex(color: string): string | null {
                const normalized = color.trim().toLowerCase();
                if (!normalized || normalized === "none" || normalized === "transparent") {
                    return null;
                }

                const hexMatch = normalized.match(/#([0-9a-f]{3,8})/);
                if (hexMatch) {
                    let hex = hexMatch[1];
                    if (hex.length === 3) {
                        hex = hex
                            .split("")
                            .map((ch) => ch + ch)
                            .join("");
                    }
                    return hex.length === 6 ? hex : null;
                }

                const rgbMatch = normalized.match(/rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)/);
                if (rgbMatch) {
                    return [rgbMatch[1], rgbMatch[2], rgbMatch[3]]
                        .map((value) => Number(value).toString(16).padStart(2, "0"))
                        .join("");
                }

                return null;
            }

            function uniqueValues(values: string[]): string[] {
                const unique: string[] = [];
                for (let index = 0; index < values.length; index++) {
                    const value = values[index];
                    if (unique.indexOf(value) === -1) {
                        unique.push(value);
                    }
                }
                return unique;
            }

            function resolveFill(element: Element): string {
                const computedFill = window.getComputedStyle(element).fill || "";
                if (toHex(computedFill)) {
                    return computedFill;
                }

                const attributeFill = element.getAttribute("fill");
                if (attributeFill && attributeFill !== "none" && attributeFill !== "transparent") {
                    return attributeFill;
                }

                const styleFill = element instanceof SVGElement && element.style ? element.style.fill : "";
                if (styleFill && styleFill !== "none" && styleFill !== "transparent") {
                    return styleFill;
                }

                return "";
            }

            const fills: string[] = [];
            let count = 0;
            const chartBars = selectElements(chartBarsXPath);
            for (let index = 0; index < chartBars.length; index++) {
                const bar = chartBars[index];
                const height = Number.parseFloat(bar.getAttribute("height") || "0");
                if (height <= 0) {
                    continue;
                }

                const fill = resolveFill(bar);
                const hex = toHex(fill);
                if (!hex || hex === "000000") {
                    continue;
                }

                fills.push(fill);
                if (colorHexes.indexOf(hex) !== -1) {
                    count++;
                }
            }

            return { count, fills: uniqueValues(fills) };
        },
        {
            colorHexes: expectedHexes,
            chartBarsXPath: barsXPath,
        },
    );
}

Then(
    "KYC checks over time chart should have at least {int} bar in color {string} on KYCModel page",
    async function (minimumBars: number, expectedColor: string) {
        const expectedHexes = colorArgumentToHexes(expectedColor);
        const { count, fills } = await countKycChartBarsInColor(expectedHexes);
        const resolvedFills = fills.join(", ") || "none";

        if (count < minimumBars) {
            throw new Error(
                `Expected at least ${minimumBars} bar(s) in color "${expectedColor}" on KYC checks over time chart, found ${count}. Resolved bar fills: ${resolvedFills}.`,
            );
        }
    },
);

When(
    "User searches for {string} on {string} and sees only matching results by Name or Description using {string} and {string} inside {string} on {string} Page",
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
        // Apply search
        await pageFixture.page.keyboard.press("Enter");
        // Wait for table rows to exist
        await pageFixture.page.locator(containerSelector).first().waitFor({state: "visible",timeout:10000,});
        const allItems = pageFixture.page.locator(containerSelector);
        const searchLower = searchText.toLowerCase();
        const settleTimeoutMs = 10000;
        const settleStart = Date.now();
        let lastMismatch: {
            index: number;
            name: string;
            desc: string;
        } | null = null;
        while (Date.now() - settleStart < settleTimeoutMs) {
            lastMismatch = null;

            const itemCount = await allItems.count();
            pageFixture.logger.info(
                `Validating ${itemCount} search result row(s)`
            );
            for (let i = 0; i < itemCount; i++) {
                const item = allItems.nth(i);

                if (!(await item.isVisible())) {
                    continue;
                }
                try {
                    const name =
                        (
                            await item
                                .locator(nameSelector)
                                .first()
                                .textContent({ timeout: 3000 })
                        )?.trim() || "";
                    const desc =
                        (
                            await item
                                .locator(descSelector)
                                .first()
                                .textContent({ timeout: 3000 })
                        )?.trim() || "";

                    pageFixture.logger.info(
                        `Row ${i + 1} | Name="${name}" | Description="${desc}"`
                    );
                    const matches =
                        name.toLowerCase().includes(searchLower) ||
                        desc.toLowerCase().includes(searchLower);

                    if (!matches) {
                        lastMismatch = {
                            index: i,
                            name,
                            desc,
                        };
                        break;
                    }
                } catch {
                    // Table likely refreshed while validating.
                    lastMismatch = {
                        index: i,
                        name: "",
                        desc: "",
                    };
                    break;
                }
            }
            if (!lastMismatch) {
                pageFixture.logger.info(
                    `Search validation successful for "${searchText}"`
                );
                return;
            }
            // Give UI time to finish re-rendering
            await pageFixture.page.waitForTimeout(1000);
        }
        throw new Error(
            `Item ${lastMismatch!.index + 1} does not contain "${searchText}" in Name or Description.\n` +
            `Name: "${lastMismatch!.name}"\n` +
            `Description: "${lastMismatch!.desc}"`
        );
    },
);