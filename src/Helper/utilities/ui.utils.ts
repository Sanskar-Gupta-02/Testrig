import * as fs from "fs";
import * as path from "path";
import { Locator, Page } from "playwright";
import { pageFixture } from "../../hooks/pagefixtures";
import { sprintf } from "sprintf-js";
import { expect } from "@playwright/test";
import { Dialog } from "@playwright/test";
import { CustomWorld } from "../../tests/steps/common/common.step";
import { APICommon } from "./api.utils";
import { ScenarioContext } from "./ScenarioContext";
import { FrameworkConstant } from "../../env/frameworkConstant";

interface CultureInfo {
    locale: string;
    shortDatePattern: string;
}

class Common {
    private static filePath: string = path.join(
        __dirname,
        `../../resources/${process.env.npm_config_PROJECT || "KYC360"}/appSetting.json`,
    ); // File path for JSON configuration

    private static readonly UniqueNameToken: string = "UKDateTimeStamp"; // Token to be replaced with random numbers

    /**
     * Generates random numbers of specified length
     * @param length - The length of the random number string to generate
     * @returns A string of random digits
     */
    private static generateRandomNumbers(length: number): string {
        let result = "";
        for (let i = 0; i < length; i++) {
            result += Math.floor(Math.random() * 10);
        }
        return result;
    }

    /**
     * Resolves a unique name by replacing the UniqueNameToken with random numbers.
     * Stores the resolved name in ScenarioContext to ensure consistency across the scenario.
     * @param name - The name containing UniqueNameToken to be resolved
     * @returns The resolved name with unique token replaced by random numbers
     */
    public static resolveUniqueName(name: string): string {
        if (!name || !name.includes(this.UniqueNameToken)) {
            return name;
        }

        const contextKey = "TestAutomation" + name;
        if (!ScenarioContext.containsKey(contextKey)) {
            const uniqueName = name.replace(this.UniqueNameToken, this.generateRandomNumbers(6));
            ScenarioContext.set(contextKey, uniqueName);
        }

        return ScenarioContext.get<string>(contextKey) || name;
    }

    /**
     * Reads the JSON file and returns the data for a specific element in the selected page.
     * @param elementName - The name of the element to retrieve from the selected page.
     * @returns The value of the specified element in the selected page.
     */
    public static getTheElement(elementName: string, webPage: string): string {
        if (!this.filePath) {
            throw new Error("File path is not set. Call 'setPage()' first.");
        }

        try {
            const absolutePath = path.resolve(this.filePath);
            const fileContent = fs.readFileSync(absolutePath, "utf8");
            const jsonData = JSON.parse(fileContent) as Record<string, Record<string, string>>;

            if (!webPage || !(webPage in jsonData)) {
                throw new Error(`Page "${webPage}" does not exist in the JSON.`);
            }

            const pageData = jsonData[webPage];

            if (!(elementName in pageData)) {
                throw new Error(`Element "${elementName}" does not exist on page "${webPage}".`);
            }

            return pageData[elementName];
        } catch (error) {
            throw new Error(`Error reading JSON file at ${this.filePath}: ${error.message}`);
        }
    }

    /**
     * Resolves a raw selector string into a Playwright Locator and waits for it
     * to become visible before returning. This is the single source of truth
     * for all selector-format parsing (chain=, role=, text=, XPath, ID, class,
     * CSS, and plain tag/CSS selectors) as well as the readiness check
     * @param selectorString - The raw selector string to resolve.
     * @param elementName - Name used for logging/error messages while waiting.
     * @param timeout - Max time (ms) to wait for the element to appear.
     * @returns A Playwright Locator for the specified selector, already waited on.
     */
    private static async resolveLocator(
        selectorString: string,
        elementName: string,
        timeout: number = 30000,
    ): Promise<Locator> {
        let element: Locator;
        // CHAIN LOCATOR SUPPORT
        // Format: chain=parentTag|text>>childLocator (e.g. chain=tr|Prabhu>>#add)
        if (selectorString.startsWith("chain=")) {
            pageFixture.logger.info("Chain locator detected");
            const chainValue = selectorString.replace("chain=", "");
            // Existing format: chain=tr|text>>#add
            if (chainValue.includes(">>")) {
                const chainParts = chainValue.split(">>");
                if (chainParts.length !== 2) {
                    throw new Error(`Invalid chain selector format: ${selectorString}`);
                }
                const [parentPart, childPart] = chainParts;
                const [parentTag, text] = parentPart.split("|");
                if (!parentTag || !text || !childPart) {
                    throw new Error(`Invalid chain selector format: ${selectorString}`);
                }
                pageFixture.logger.info(`ParentTag=${parentTag}, Text=${text}, Child=${childPart}`);
                const parentLocator = pageFixture.page.locator(parentTag).filter({ hasText: text.trim() });
                element = parentLocator.locator(childPart.trim()).first();
            }
            // Other format: chain=div|Review Date|nth=5
            else {
                const parts = chainValue.split("|");
                const parentTag = parts[0];
                const text = parts[1];
                const nthPart = parts.find(p => p.startsWith("nth="));
                const nthIndex = nthPart ? Number(nthPart.replace("nth=", "").trim()) : null;
                if (!parentTag || !text) {
                    throw new Error(`Invalid chain selector format: ${selectorString}`);
                }
                let locator = pageFixture.page.locator(parentTag).filter({ hasText: text.trim() });
                element = nthIndex !== null && !isNaN(nthIndex) ? locator.nth(nthIndex) : locator.first();
            }
        }
        // ROLE-BASED LOCATOR - Example: role=button|Add
        else if (selectorString.startsWith("role=")) {
            const parts = selectorString.split("|");
            const role = parts[0].replace("role=", "");
            const name = parts[1];
            if (!role || !name) {
                throw new Error(`Invalid role selector format: ${selectorString}`);
            }
            // optional exclusion
            const excludePart = parts.find(p => p.startsWith("exclude="));
            const excludeText = excludePart ? excludePart.replace("exclude=", "") : null;
            // optional nth
            const nthPart = parts.find(p => p.startsWith("nth="));
            const nthIndex = nthPart ? Number(nthPart.replace("nth=", "").trim()) : null;
            // optional exact
            const exactPart = parts.find(p => p.startsWith("exact="));
            const exact = exactPart?.replace("exact=", "").trim().toLowerCase() === "true";
            let locator = pageFixture.page.getByRole(role as any, { name, exact });
            // APPLY NEGATIVE FILTER
            if (excludeText) {
                locator = locator.filter({ hasNotText: excludeText });
            }
            element =
                nthIndex !== null && Number.isInteger(nthIndex) && nthIndex >= 0
                    ? locator.nth(nthIndex)
                    : locator.first();
        }
        // TEXT-BASED LOCATOR
        else if (selectorString.startsWith("text=")) {
            const parts = selectorString.split("|");
            const text = parts[0].replace("text=", "").trim();
            if (!text) {
                throw new Error(`Invalid text selector format: ${selectorString}`);
            }
            const exactPart = parts.find(p => p.startsWith("exact="));
            const exact = exactPart ? exactPart.replace("exact=", "").trim().toLowerCase() === "true" : false;
            element = pageFixture.page.getByText(text, { exact }).first();
        }
        // Playwright label-based locator
        // label + text
        else if (selectorString.startsWith("label=") && selectorString.includes("|text=")) {
            const [labelPart, textPart] = selectorString.split("|text=");
            const label = labelPart.replace("label=", "").trim();
            const text = textPart.trim();
            element = pageFixture.page.getByLabel(label).getByText(text).first();
        }
        // label only
        else if (selectorString.startsWith("label=")) {
            element = pageFixture.page.getByLabel(selectorString.replace("label=", "").trim()).first();
        }
        // id value + text
        // text=Flagged for Archiving|scope=#field-thirddtf|exact=true
        else if (selectorString.startsWith("text=") && selectorString.includes("|scope=")) {
            const parts = selectorString.split("|");
            const text = parts[0].replace("text=", "").trim();
            if (!text) {
                throw new Error(`Invalid text selector format: ${selectorString}`);
            }
            const exactPart = parts.find(part => part.startsWith("exact="));
            const exact = exactPart?.replace("exact=", "").trim().toLowerCase() === "true";
            const scopePart = parts.find(part => part.startsWith("scope="));
            const scope = scopePart?.replace("scope=", "").trim();
            element = pageFixture.page.locator(scope!).getByText(text, { exact }).first()
        }
        // XPATH
        else if (selectorString.startsWith("//") || selectorString.startsWith("(")) {
            element = pageFixture.page.locator(`xpath=${selectorString}`).locator("visible=true").first();
        }
        // ID
        else if (selectorString.startsWith("#")) {
            element = pageFixture.page.locator(`#${selectorString.substring(1)}`).first(); // Remove "#" prefix
        }
        // CLASS
        else if (selectorString.startsWith(".")) {
            element = pageFixture.page.locator(`.${selectorString.substring(1)}`); // Remove "." prefix
        }
        // CSS ATTRIBUTE SELECTOR
        else if (selectorString.includes("[") && selectorString.includes("]")) {
            element = pageFixture.page.locator(selectorString); // CSS selector
        }
        // PERMISSION ROW LOCATOR - scopes getByRole to a permission row's config buttons
        // Format: permissionrow=Risk Models>>role=button|Deny selected. Click to change Read permission
        else if (selectorString.startsWith("permissionrow=")) {
            const rest = selectorString.replace("permissionrow=", "");
            const splitIndex = rest.indexOf(">>");
            if (splitIndex === -1) {
                throw new Error(`Invalid permissionrow selector format: ${selectorString}`);
            }
            const rowName = rest.slice(0, splitIndex).trim();
            const roleSelector = rest.slice(splitIndex + 2).trim();
            if (!rowName || !roleSelector.startsWith("role=")) {
                throw new Error(`Invalid permissionrow selector format: ${selectorString}`);
            }
            const rowHeader = pageFixture.page.locator("[role='rowheader']").filter({ hasText: rowName });
            const permissionArea = rowHeader.locator("xpath=following-sibling::div");
            const parts = roleSelector.split("|");
            const role = parts[0].replace("role=", "");
            const name = parts[1];
            if (!role || !name) {
                throw new Error(`Invalid role selector in permissionrow: ${selectorString}`);
            }
            const nthPart = parts.find(p => p.startsWith("nth="));
            const nthIndex = nthPart ? Number(nthPart.replace("nth=", "").trim()) : null;
            let locator = permissionArea.getByRole(role as any, { name });
            element =
                nthIndex !== null && Number.isInteger(nthIndex) && nthIndex >= 0
                    ? locator.nth(nthIndex)
                    : locator.first();
        }
        // SIDEBAR ROLE LOCATOR - getByRole scoped to sidebar (supports collapsed/hidden labels)
        // Format: sidebarrole=link|Risk Models
        else if (selectorString.startsWith("sidebarrole=")) {
            const rest = selectorString.replace("sidebarrole=", "");
            const parts = rest.split("|");
            const role = parts[0];
            const name = parts[1];
            if (!role || !name) {
                throw new Error(`Invalid sidebarrole selector format: ${selectorString}`);
            }
            const includeHiddenPart = parts.find(p => p.startsWith("includeHidden="));
            const includeHidden = includeHiddenPart
                ? includeHiddenPart.replace("includeHidden=", "").trim() === "true"
                : true;
            const nthPart = parts.find(p => p.startsWith("nth="));
            const nthIndex = nthPart ? Number(nthPart.replace("nth=", "").trim()) : null;
            let locator = pageFixture.page
                .locator("nav.wl-clm-sidebar")
                .getByRole(role as any, { name, includeHidden });
            element =
                nthIndex !== null && Number.isInteger(nthIndex) && nthIndex >= 0
                    ? locator.nth(nthIndex)
                    : locator.first();
        }
        // MAIN CONTENT ROLE LOCATOR - getByRole or href scoped to main content
        // Format: mainrole=link|Add|href=/clm/RiskModel/Add
        else if (selectorString.startsWith("mainrole=")) {
            const rest = selectorString.replace("mainrole=", "");
            const parts = rest.split("|");
            const role = parts[0];
            const name = parts[1];
            if (!role) {
                throw new Error(`Invalid mainrole selector format: ${selectorString}`);
            }
            const hrefPart = parts.find(p => p.startsWith("href="));
            const hrefFragment = hrefPart ? hrefPart.replace("href=", "").trim() : null;
            const nthPart = parts.find(p => p.startsWith("nth="));
            const nthIndex = nthPart ? Number(nthPart.replace("nth=", "").trim()) : null;
            const main = pageFixture.page.locator("main#main-content");
            let locator = hrefFragment
                ? main.locator(`a[href*="${hrefFragment}"]`)
                : main.getByRole(role as any, { name });
            element =
                nthIndex !== null && Number.isInteger(nthIndex) && nthIndex >= 0
                    ? locator.nth(nthIndex)
                    : locator.first();
        }
        // DEFAULT: HTML tag or plain CSS selector
        else {
            element = pageFixture.page.locator(selectorString).first();
        }
        await Common.waitForElement(element, elementName, timeout);
        return element;
    }

    /**
     * Finds a Locator dynamically based on the provided selector string.
     * @param selector - The selector string (XPath, CSS, ID, Class, Tag).
     * @returns A Playwright Locator for the specified selector.
     */
    public static async getElementLocator(
        selector: string,
        pageName: string,
        timeout: number = 30000,
    ): Promise<Locator> {
        // Get the element selector string from the appSetting.json file
        const selectorString = this.getTheElement(selector, pageName);
        pageFixture.logger.info(`selectorString ${selectorString}`);
        const element = await this.resolveLocator(selectorString, selector, timeout);
        return element;
    }

    public static async getElementLocatorFromRaw(selectorString: string, timeout: number = 30000): Promise<Locator> {
        pageFixture.logger.info(`selectorString ${selectorString}`);
        const element = await this.resolveLocator(selectorString, selectorString, timeout);
        return element;
    }

    public static async clickElement(selector: string, pageName: string): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            await element.waitFor({ state: "visible", timeout: 5000 });
            await element.click();
            pageFixture.logger.info(`Successfully clicked element: ${selector}`);
        } catch (error) {
            throw new Error(`Failed to click element: ${selector}. Error: ${(error as Error).message}`);
        }
    }

    public static async expandSideBarIfCollapsed(): Promise<void> {
        const expandButton = pageFixture.page.getByRole("button", { name: "Expand menu" });
        if (await expandButton.isVisible().catch(() => false)) {
            await expandButton.click();
            pageFixture.logger.info("Sidebar expanded via Expand menu button");
        } else {
            pageFixture.logger.info("Sidebar already expanded");
        }
        await pageFixture.page
            .locator("nav.wl-clm-sidebar[data-expanded]")
            .waitFor({ state: "attached", timeout: 5000 })
            .catch(() => undefined);
    }

    public static async refreshPage(): Promise<void> {
        try {
            await pageFixture.page.reload(); // Reloads the current page
            pageFixture.logger.info(`Page successfully refreshed.`);
        } catch (error) {
            throw new Error(`Failed to refresh the page. Error: ${(error as Error).message}`);
        }
    }

    public static async typeText(selector: string, pageName: string, text: string): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            await element.fill(text);
            pageFixture.logger.info(`Successfully typed text into element: ${selector}`);
        } catch (error) {
            throw new Error(`Failed to type text into element: ${selector}. Error: ${(error as Error).message}`);
        }
    }

    public static async navigateTo(selector: string, pageName: string): Promise<void> {
        try {
            const element = this.getTheElement(selector, pageName);
            let elementUrl: string = process.env.BASEURL + String(element);
            if (process.env.npm_config_PROJECT === "REFIT" || process.env.npm_config_PROJECT === "KYC360") {
                const featureName = pageFixture.currentFeature?.toLowerCase() ?? "";
                const businessUnit = featureName.startsWith("pkyc")
                    ? process.env.PKYCBUSINESSUNIT
                    : process.env.BUSINESSUNIT;
                elementUrl += "?__BusinessUnit=" + (businessUnit || "10");
            }
            pageFixture.logger.info(`Successfully typed text into element: ${elementUrl}`);
            await pageFixture.page.goto(elementUrl);
            pageFixture.logger.info(`Successfully typed text into element: ${selector}`);
        } catch (error) {
            throw new Error(`Failed to type text into element: ${selector}. Error: ${(error as Error).message}`);
        }
    }

    public static async navigateToURL(pageUrl: string): Promise<void> {
        try {
            const legacyHost = "app-rs-sh-qa-dcf-frc1-001.ase-rs-app-dev-ase-frc1-001.appserviceenvironment.net/login";
            if (pageUrl.includes(legacyHost)) {
                const parsedUrl = new URL(pageUrl);
                const token = parsedUrl.searchParams.get("token");
                if (token) {
                    const dcfBaseUrl = process.env.DCFBASEURL || "https://qa-dcf.kyc360.com";
                    pageUrl = `${dcfBaseUrl}/login?token=${token}`;
                    pageFixture.logger.info(`Legacy DCF host redirect applied. Navigating to: ${pageUrl}`);
                }
            }
            await pageFixture.page.goto(pageUrl);
            pageFixture.logger.info(`Successfully navigated to: ${pageUrl}`);
        } catch (error) {
            throw new Error(`Failed to navigate to: ${pageUrl}. Error: ${(error as Error).message}`);
        }
    }

    public static async getText(selector: string, pageName: string): Promise<string> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            const text = await element.textContent();
            if (text === null) {
                throw new Error(`Text content is null for element: ${selector}`);
            }
            pageFixture.logger.info(`Successfully retrieved text from element: ${selector}`);
            return text.trim();
        } catch (error) {
            throw new Error(`Failed to get text from element: ${selector}. Error: ${(error as Error).message}`);
        }
    }

    public static async isVisible(selector: string, pageName: string): Promise<boolean> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            const visible = await element.isVisible();
            await element.waitFor({ state: "visible", timeout: 5000 });
            pageFixture.logger.info(`Element visibility for ${selector}: ${visible}`);
            return visible;
        } catch (error) {
            throw new Error(`Failed to check visibility of element: ${selector}. Error: ${(error as Error).message}`);
        }
    }

    public static async isNotVisible(selector: string, pageName: string, replaceText?: string): Promise<void> {
        try {
            let selectorString = this.getTheElement(selector, pageName);
            if (replaceText !== undefined) {
                selectorString = String(sprintf(selectorString, replaceText));
            }
            let locator: Locator;
            if (selectorString.startsWith("//") || selectorString.startsWith("(")) {
                locator = pageFixture.page.locator(`xpath=${selectorString}`);
            } else {
                locator = pageFixture.page.locator(selectorString);
            }
            await expect(locator.first()).not.toBeVisible();
            pageFixture.logger.info(`Element is not visible: ${selector}`);
        } catch (error) {
            const errorMessage = String(error);
            if (errorMessage.includes("Element did not appear within timeout")) {
                pageFixture.logger.info(`Element not found: ${selector} (considered not visible)`);
                return;
            }
            throw new Error(`Failed to check visibility of element: ${selector}. Error: ${(error as Error).message}`);
        }
    }

    public static async isHidden(selector: string, pageName: string): Promise<void> {
        const element = pageFixture.page.locator(this.getTheElement(selector, pageName));
        await element.waitFor({ state: "hidden", timeout: 10000 });
        const visible = await element.isVisible();
        pageFixture.logger.info(`Element visibility for ${selector}: ${visible}`);
        pageFixture.expect(visible).toBe(false);
    }

    public static async isTextEqual(selector: string, text: string, pageName: string) {
        const element = await this.getElementLocator(selector, pageName);
        const elementText = (await element.textContent()).trim();
        try {
            await pageFixture.expect(element).toHaveText(text);
            pageFixture.logger.info(`Element text is Equal to '${text}' text`);
        } catch (error) {
            throw new Error(
                `Actual text: ${elementText?.trim() || "null"}, Expected text: ${text}. Error: ${(error as Error).message}`,
            );
        }
    }

    public static async containsText(selector: string, text: string, pageName: string) {
        const element = await this.getElementLocator(selector, pageName);
        await element.isVisible();
        const elementText = await element.textContent();
        await element.isVisible();
        pageFixture.logger.info(`Element text contains '${JSON.stringify(elementText)}' text and '${text}'`);
        try {
            await pageFixture.expect(element).toContainText(text);
            pageFixture.logger.info(`Element text contains '${text}' text`);
        } catch (error) {
            throw new Error(
                `Actual text: ${elementText?.trim() || "null"}, Expected text: ${text}. Error: ${(error as Error).message}`,
            );
        }
    }

    public static async waitForElement(element: Locator, elementName: string, timeout: number = 30000): Promise<void> {
        try {
            await element.waitFor({ state: "visible", timeout });
            pageFixture.logger.info(`Element appeared within timeout: ${elementName}`);
        } catch {
            pageFixture.logger.info(`Element did not appear within timeout: ${elementName}.`);
            throw new Error(`Element did not appear within timeout: ${elementName}.`);
        }
    }

    public static async getAttribute(selector: string, pageName: string, attribute: string): Promise<string | null> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            const value = await element.getAttribute(attribute);
            pageFixture.logger.info(`Successfully retrieved attribute "${attribute}" from element: ${selector}`);
            return value;
        } catch (error) {
            throw new Error(
                `Failed to get attribute "${attribute}" from element: ${selector}. Error: ${(error as Error).message}`,
            );
        }
    }

    /**
     * Gets the CSS value of an element by mapping user-friendly CSS value names to actual CSS properties
     * @param selector - The element name to retrieve from the page
     * @param pageName - The page name where the element is located
     * @param cssValue - User-friendly CSS value name ("font", "background color", "font size", "font color", "bold", "italic")
     * @returns The computed CSS property value
     */
    public static async getCSSValueOfElement(selector: string, pageName: string, cssValue: string): Promise<string> {
        const cssValueLower = cssValue.toLowerCase().trim();

        let cssPropertyName: string;

        switch (cssValueLower) {
            case "font":
                cssPropertyName = "font-family";
                break;
            case "background color":
                cssPropertyName = "background-color";
                break;
            case "font size":
                cssPropertyName = "font-size";
                break;
            case "font color":
                cssPropertyName = "color";
                break;
            case "bold":
                cssPropertyName = "font-weight";
                break;
            case "italic":
                cssPropertyName = "font-style";
                break;
            default:
                throw new Error(`Invalid css value name: ${cssValue}`);
        }

        return this.getCSSValueOfAttribute(selector, pageName, cssPropertyName);
    }

    /**
     * Gets the computed CSS property value of an element
     * @param selector - The element name to retrieve from the page
     * @param pageName - The page name where the element is located
     * @param cssAttributeName - The actual CSS property name (e.g., "color", "font-size", "font-family")
     * @returns The computed CSS property value
     */
    public static async getCSSValueOfAttribute(selector: string, pageName: string, cssAttributeName: string): Promise<string> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            const value = await element.evaluate((el: HTMLElement, prop: string) => {
                return window.getComputedStyle(el).getPropertyValue(prop);
            }, cssAttributeName);
            pageFixture.logger.info(`Successfully retrieved CSS property "${cssAttributeName}" from element: ${selector} = ${value}`);
            return value.trim();
        } catch (error) {
            throw new Error(
                `Failed to get CSS property "${cssAttributeName}" from element: ${selector}. Error: ${(error as Error).message}`,
            );
        }
    }

    public static async selectDropdown(selector: string, pageName: string, value: string): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            const trimmedValue = value.trim();
            // Try value/label/index independently — Playwright validates every entry in an
            // array selectOption() call
            let result: string[] = [];
            const attempts: Array<{ value?: string; label?: string; index?: number }> = [
                { value },
                { label: value },
                { value: trimmedValue },
                { label: trimmedValue },
            ];
            const parsedIndex = Number(trimmedValue);
            if (Number.isInteger(parsedIndex)) {
                attempts.push({ index: parsedIndex });
            }

            for (const attempt of attempts) {
                try {
                    result = await element.selectOption(attempt, { timeout: 5000 });
                    if (result && result.length > 0) break;
                } catch {
                    // Try the next candidate selector.
                }
            }

            if (!result || result.length === 0) {
                // Fallback: manually find option by textContent (ignoring spaces)
                const options = await element.locator("option").all();
                let found = false;
                for (const option of options) {
                    const optionText = (await option.textContent())?.trim();
                    if (optionText && optionText.replace(/\s+/g, " ").trim() === trimmedValue.replace(/\s+/g, " ")) {
                        const optionValue = await option.getAttribute("value");
                        if (optionValue) {
                            result = await element.selectOption({ value: optionValue });
                            if (result && result.length > 0) {
                                found = true;
                                pageFixture.logger.info(
                                    `Successfully selected fallback option '${optionText}' in dropdown: ${selector}`,
                                );
                                break;
                            }
                        }
                    }
                }
                if (!found) {
                    throw new Error(`Option '${value}' not found in dropdown '${selector}' on page '${pageName}'.`);
                }
            } else {
                pageFixture.logger.info(`Successfully selected option '${value}' in dropdown: ${selector}`);
            }
        } catch (error) {
            throw new Error(
                `Failed to select option '${value}' in dropdown: ${selector} on page '${pageName}'. Error: ${(error as Error).message}`,
            );
        }
    }

    public static async hoverElement(selector: string, pageName: string): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            await element.hover();
            pageFixture.logger.info(`Successfully hovered over element: ${selector}`);
        } catch (error) {
            throw new Error(`Failed to hover over element: ${selector}. Error: ${(error as Error).message}`);
        }
    }

    public static async scrollIntoView(selector: string, pageName: string): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            await element.scrollIntoViewIfNeeded();
            pageFixture.logger.info(`Successfully scrolled into view: ${selector}`);
        } catch (error) {
            throw new Error(`Failed to scroll into view: ${selector}. Error: ${(error as Error).message}`);
        }
    }

    public static async uploadFile(selector: string, pageName: string, filePath: string): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            await element.setInputFiles(filePath);
            pageFixture.logger.info(`Successfully uploaded file to element: ${selector}`);
        } catch (error) {
            throw new Error(`Failed to upload file to element: ${selector}. Error: ${(error as Error).message}`);
        }
    }

    public static async checkCheckbox(selector: string, pageName: string): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            const isChecked = await element.isChecked();
            if (!isChecked) {
                await element.check();
            }
            pageFixture.logger.info(`Successfully checked checkbox: ${selector}`);
        } catch (error) {
            throw new Error(`Failed to check checkbox: ${selector}. Error: ${(error as Error).message}`);
        }
    }

    public static async uncheckCheckbox(selector: string, pageName: string): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            const isChecked = await element.isChecked();
            if (isChecked) {
                await element.uncheck();
            }
            pageFixture.logger.info(`Successfully unchecked checkbox: ${selector}`);
        } catch (error) {
            throw new Error(`Failed to uncheck checkbox: ${selector}. Error: ${(error as Error).message}`);
        }
    }

    public static async pressKey(selector: string, pageName: string, key: string): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            await element.press(key);
            pageFixture.logger.info(`Successfully pressed key "${key}" on element: ${selector}`);
        } catch (error) {
            throw new Error(`Failed to press key "${key}" on element: ${selector}. Error: ${(error as Error).message}`);
        }
    }

    public static async clearInput(selector: string, pageName: string): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            await element.fill(""); // Clear the input
            pageFixture.logger.info(`Successfully cleared input field: ${selector}`);
        } catch (error) {
            throw new Error(`Failed to clear input field: ${selector}. Error: ${(error as Error).message}`);
        }
    }

    public static async waitForSeconds(seconds: number): Promise<void> {
        await pageFixture.page.waitForTimeout(seconds * 1000);
    }

    public static async isValueEqual(field: string, pageName: string, expectedText: string) {
        try {
            // Retrieve the current value of the field (attribute "value")
            const elementValue = await this.getAttribute(field, pageName, "value");

            if (elementValue === expectedText) {
                pageFixture.logger.info(`Field "${field}" has the expected value: '${expectedText}'`);
            } else {
                pageFixture.logger.error(
                    `Mismatch for field "${field}": Expected '${expectedText}', but got '${elementValue}'`,
                );
                throw new Error(`Field "${field}" mismatch: Expected '${expectedText}', but got '${elementValue}'`);
            }
        } catch (error) {
            // Catch any errors and rethrow them with a more descriptive message
            throw new Error(`Error checking value for field "${field}": ${(error as Error).message}`);
        }
    }

    /**
     * Finds a Locator dynamically based on the provided selector string.
     * @param selector - The selector string (XPath, CSS, ID, Class, Tag).
     * @returns A Playwright Locator for the specified selector.
     */
    public static async getElementBySelectorText(selectorText: string) {
        let element: Locator;
        // Determine selector type and return the corresponding Locator
        if (selectorText.startsWith("//") || selectorText.startsWith("(")) {
            element = pageFixture.page.locator(`xpath=${selectorText}`);
        } else if (selectorText.startsWith("#")) {
            element = pageFixture.page.locator(`#${selectorText.substring(1)}`); // Remove "#" prefix
        } else if (selectorText.startsWith(".")) {
            element = pageFixture.page.locator(`.${selectorText.substring(1)}`); // Remove "." prefix
        } else if (selectorText.includes("[") && selectorText.includes("]")) {
            element = pageFixture.page.locator(selectorText); // CSS selector
        } else {
            element = pageFixture.page.locator(selectorText); // Assume it's an HTML tag or CSS selector
        }
        await Common.waitForElement(element, selectorText);
        return element;
    }

    public static async clickByElementText(selectorText: string): Promise<void> {
        try {
            const element = await this.getElementBySelectorText(selectorText);
            await element.click();
            pageFixture.logger.info(`Successfully clicked element: ${selectorText}`);
        } catch (error) {
            throw new Error(`Failed to click element: ${selectorText}. Error: ${(error as Error).message}`);
        }
    }

    public static async isVisibleByText(selectorText: string): Promise<boolean> {
        try {
            const element = await this.getElementBySelectorText(selectorText);
            const visible = await element.isVisible();
            pageFixture.logger.info(`Element visibility for ${selectorText}: ${visible}`);
            return visible;
        } catch (error) {
            throw new Error(
                `Failed to check visibility of element: ${selectorText}. Error: ${(error as Error).message}`,
            );
        }
    }

    public static async clickWithText(selector: string, ReplaceText: string, pageName: string): Promise<void> {
        const button: string = String(await sprintf(Common.getTheElement(selector, pageName), ReplaceText));
        await pageFixture.page.click(button);
    }

    public static convertDate(dateString: string): string {
        try {
            // Read and parse the JSON file synchronously
            const data = fs.readFileSync("src/testData/CultureInfo.json", "utf8");
            const json: CultureInfo = JSON.parse(data) as CultureInfo;

            // Create a Date object from the input string
            const date = new Date(dateString);

            // Format day, month, and year
            const day = String(date.getDate()).padStart(2, "0");
            const month = String(date.getMonth() + 1).padStart(2, "0");
            const year = date.getFullYear();

            // Replace placeholders in the pattern
            return String(json.shortDatePattern.replace("dd", day).replace("MM", month).replace("yyyy", String(year)));
        } catch (error) {
            throw new Error(`Failed to convert date: ${(error as Error).message}`);
        }
    }

    public static getDateInYYYYMMDD(daysBeforeToday: number): string {
        const date = new Date();
        date.setHours(12, 0, 0, 0);
        date.setDate(date.getDate() - daysBeforeToday);

        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, "0");
        const day = String(date.getDate()).padStart(2, "0");

        return `${year}-${month}-${day}`;
    }

    public static async setAttribute(
        selector: string,
        pageName: string,
        attributeName: string,
        attributeValue: string,
    ): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName);

            // Set the attribute using browser context
            await element.evaluate(
                (el, { attr, value }) => {
                    el.setAttribute(attr, value);
                },
                { attr: attributeName, value: attributeValue },
            );

            pageFixture.logger.info(
                `Successfully set attribute "${attributeName}" with value "${attributeValue}" on element: ${selector}`,
            );
        } catch (error) {
            throw new Error(
                `Failed to set attribute "${attributeName}" on element: ${selector}. Error: ${(error as Error).message}`,
            );
        }
    }

    public static isEqual(actualText: string, expectedText: string) {
        try {
            pageFixture.expect(actualText).toBe(expectedText);
            pageFixture.logger.info(`'${actualText}' is Equal to '${expectedText}' text`);
        } catch (error) {
            throw new Error(
                `Actual text: ${actualText?.trim() || "null"}, Expected text: ${expectedText}. Error: ${(error as Error).message}`,
            );
        }
    }
    public static async fileUpload(fileName: string, elementName: string, pageName: string, world: CustomWorld) {
        const page = pageFixture.page;
        await page.evaluate(() => {
            window.onbeforeunload = null;
        });

        const filePath = `${process.cwd()}/src/testData/${process.env.npm_config_PROJECT}/${process.env.npm_config_TEST}/${fileName}`;
        pageFixture.logger.info(`Uploading '${fileName}'`);

        const element = await this.getElementLocator(elementName, pageName);

        if (process.env.npm_config_PROJECT === "REFIT") {
            world.dialogMessage = null;
            let alertOccurred = false;

            // Setup single dialog handler
            const dialogHandler = async (dialog: Dialog) => {
                alertOccurred = true;
                world.dialog = dialog;
                world.dialogMessage = dialog.message();
                pageFixture.logger.info(`Alert: "${world.dialogMessage}"`);
                await dialog.accept().catch(e => pageFixture.logger.warn(`Dialog already handled: ${e.message}`));
            };
            try {
                page.on("dialog", dialogHandler);

                const [fileChooser] = await Promise.all([
                    page.waitForEvent("filechooser", { timeout: 5000 }),
                    element.click(),
                ]);

                await fileChooser.setFiles(filePath, { timeout: 60000 });

                // Small delay to ensure dialog handler had chance to execute
                await page.waitForTimeout(500);

                if (alertOccurred) {
                    pageFixture.logger.info("File upload interrupted by alert");
                    return;
                }
                pageFixture.logger.info(`'${fileName}' uploaded successfully`);
            } catch (error) {
                if (alertOccurred) {
                    pageFixture.logger.info("File upload interrupted by alert");
                    return;
                }
                throw new Error(`File upload failed: ${error instanceof Error ? error.message : String(error)}`);
            } finally {
                page.off("dialog", dialogHandler);
                pageFixture.logger.info(`Dialog handler cleaned up`);
            }
        } else {
            // Simple file upload for non-REFIT projects
            try {
                // Try to set files directly (works for <input type="file">)
                await element.setInputFiles(filePath, { timeout: 10000 });
                pageFixture.logger.info(`'${fileName}' uploaded successfully (simple input upload)`);
            } catch (error) {
                // If direct upload fails, try to use drag-and-drop (for drop zones)
                try {
                    pageFixture.logger.warn(
                        `Direct input upload failed, trying drag-and-drop. Error: ${(error as Error).message}`,
                    );
                    const dataTransfer = await pageFixture.page.evaluateHandle(filePath => {
                        const dt = new DataTransfer();
                        // @ts-ignore
                        dt.items.add(new File([filePath], filePath.split("/").pop()));
                        return dt;
                    }, filePath);

                    await element.dispatchEvent("drop", { dataTransfer });
                    pageFixture.logger.info(`'${fileName}' uploaded successfully via drag-and-drop fallback.`);
                } catch (dragError) {
                    throw new Error(
                        `File upload failed: ${dragError instanceof Error ? dragError.message : String(dragError)}`,
                    );
                }
            }
        }
    }

    public static async isSelected(optionName: string, elementName: string, pageName: string) {
        try {
            const element = await this.getElementLocator(elementName, pageName);
            await element.selectOption(optionName);
        } catch (error) {
            throw new Error(
                `Selected '${optionName}' not present in '${elementName} dropdown'. Error: ${(error as Error).message}`,
            );
        }
    }
    public static async verifyOptionsInDropdown(
        optionsCSV: string,
        dropdownSelector: string,
        pageName: string,
    ): Promise<void> {
        const expectedOptions = optionsCSV.split(",").map(opt => opt.trim());
        const dropdown = await this.getElementLocator(dropdownSelector, pageName);
        const actualOptions = await dropdown.locator("option").allTextContents();

        for (let expectedOption of expectedOptions) {
            expectedOption = this.resolveUniqueName(expectedOption);
            let found = false;
            for (const actualOption of actualOptions) {
                if (actualOption.trim() === expectedOption.trim()) {
                    found = true;
                    break;
                }
            }
            if (!found) {
                throw new Error(
                    `Option "${expectedOption}" not found in dropdown "${dropdownSelector}" on page "${pageName}" Available option(s): "${actualOptions.join(", ")}".`,
                );
            }
        }

        pageFixture.logger.info(
            `Verified all options "${expectedOptions.join(", ")}" exist in dropdown "${dropdownSelector}" on page "${pageName}".`,
        );
    }

    public static async verifyOptionsInDropdownInOrder(
        optionsCSV: string,
        dropdownSelector: string,
        pageName: string,
    ): Promise<void> {
        const expectedOptions = optionsCSV.split(",").map(opt => opt.trim());
        const dropdown = await this.getElementLocator(dropdownSelector, pageName);
        const actualOptions = (await dropdown.locator("option").allTextContents()).map(opt => opt.trim());

        if (actualOptions.length < expectedOptions.length) {
            throw new Error(
                `Dropdown "${dropdownSelector}" on page "${pageName}" has ${actualOptions.length} options, but expected at least ${expectedOptions.length}.`,
            );
        }

        for (let index = 0; index < expectedOptions.length; index++) {
            const expectedOption = expectedOptions[index];
            const actualOption = actualOptions[index];

            if (actualOption !== expectedOption) {
                throw new Error(
                    `Option at position ${index + 1} expected "${expectedOption}", but found "${actualOption ?? "<missing>"}" in dropdown "${dropdownSelector}" on page "${pageName}".`,
                );
            }
        }

        pageFixture.logger.info(
            `Verified all options "${expectedOptions.join(", ")}" are in order in dropdown "${dropdownSelector}" on page "${pageName}".`,
        );
    }

    public static async isElementClickable(elementName: string, pageName: string): Promise<boolean> {
        try {
            const locator = await this.getElementLocator(elementName, pageName);

            // Ensure the element exists and basic readiness
            await locator.waitFor({ state: "attached", timeout: 1000 });
            const isEnabled = await locator.isEnabled();

            return isEnabled;
        } catch (error: unknown) {
            console.error(`Error checking clickability of element: ${elementName} on page: ${pageName}`, error);
            return false;
        }
    }

    public static async areElementsChecked(locators: Locator): Promise<void> {
        const count = await locators.count();

        for (let i = 0; i < count; i++) {
            const checkbox = locators.nth(i);
            const isChecked = checkbox;

            await expect(isChecked).toHaveAttribute("checked", "checked"); // or not.toBe for unchecked
        }
    }

    public static async getElementLocators(
        selector: string,
        pageName: string,
        waitForElement: boolean = true,
        expectMultiple: boolean = false,
    ): Promise<Locator> {
        const selectorString = this.getTheElement(selector, pageName);
        pageFixture.logger.info(`Selector string for "${selector}" on "${pageName}": "${selectorString}"`);

        if (!selectorString || selectorString.trim() === "") {
            throw new Error(`Selector not found for element "${selector}" on page "${pageName}"`);
        }

        let locator: Locator;

        // Determine selector type
        if (selectorString.startsWith("//") || selectorString.startsWith("(")) {
            locator = pageFixture.page.locator(`xpath=${selectorString}`);
        } else {
            locator = pageFixture.page.locator(selectorString);
        }

        // Optional wait logic
        if (waitForElement) {
            try {
                if (expectMultiple) {
                    const count = await locator.count();
                    if (count === 0) {
                        throw new Error(`No elements found for selector "${selector}" on page "${pageName}"`);
                    }
                    pageFixture.logger.info(`Found ${count} elements for selector "${selector}"`);
                } else {
                    await locator.first().waitFor({ state: "visible", timeout: 5000 });
                    pageFixture.logger.info(`Element "${selector}" is visible on page "${pageName}"`);
                }
            } catch (error) {
                pageFixture.logger.error(`Failed to locate element(s) for "${selector}" on page "${pageName}"`, error);
                throw error;
            }
        }

        return locator;
    }

    public static async selectDropdownByVlaue(selector: string, pageName: string, optionValue: string): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            await element.selectOption({ value: optionValue });
            pageFixture.logger.info(`Successfully selected option "${optionValue}" in dropdown: ${selector}`);
        } catch (error) {
            throw new Error(
                `Failed to select option "${optionValue}" in dropdown: ${selector}. Error: ${(error as Error).message}`,
            );
        }
    }

    public static async handleTabAndClick(selector: string, replaceText: string, pageName: string) {
        const buttonSelector: string = String(await sprintf(Common.getTheElement(selector, pageName), replaceText));
        pageFixture.logger.info(buttonSelector);
        // Wait for new tab to open when clicking the button
        const [newPage] = await Promise.all([
            pageFixture.page.context().waitForEvent("page"), // Wait for new tab
            pageFixture.page.click(buttonSelector), // Trigger the click
        ]);

        // Wait for the new page to load
        await newPage.waitForLoadState("load");
        await Common.waitForSeconds(5);
        // Validate that an image is visible
        const isImageVisible = await newPage.locator("//img").isVisible();
        pageFixture.expect(isImageVisible).toBe(true);

        // Close the new tab
        await newPage.close();

        // Optionally bring original page to front
        await pageFixture.page.bringToFront();
    }

    public static async refresh(): Promise<void> {
        await pageFixture.page.reload();
        pageFixture.logger.info("Page refreshed successfully");
    }

    public static async doubleClickElement(selector: string): Promise<void> {
        try {
            const element = pageFixture.page.locator(selector);
            await element.dblclick();
            pageFixture.logger.info(`Successfully double-clicked element: ${selector}`);
        } catch (error) {
            throw new Error(`Failed to double-click element: ${selector}. Error: ${(error as Error).message}`);
        }
    }

    public static async doesNotContainText(selector: string, text: string, pageName: string) {
        const element = await this.getElementLocator(selector, pageName);
        const elementText = element.textContent();

        try {
            await pageFixture.expect(element).not.toContainText(text);
            pageFixture.logger.info(`Confirmed that element does NOT contain text '${text}'`);
        } catch (error) {
            throw new Error(
                `Expected NOT to find text: '${text}', but found: '${(await elementText)?.trim() || "null"}'. Error: ${(error as Error).message}`,
            );
        }
    }
    public static async fillDateInput(selector: string, pageName: string, value: string): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName);

            await element.evaluate((el, val) => {
                (el as HTMLInputElement).value = val;

                el.dispatchEvent(new Event("input", { bubbles: true }));
                el.dispatchEvent(new Event("change", { bubbles: true }));
                el.dispatchEvent(new Event("blur", { bubbles: true }));
            }, value);

            pageFixture.logger.info(`Successfully set date value "${value}" on "${selector}"`);
        } catch (error) {
            throw new Error(`Failed to set date value "${value}" on "${selector}". Error: ${(error as Error).message}`);
        }
    }
    public static getTheElements(elementName: string, webPage: string, page: Page): Locator[] {
        if (!this.filePath) {
            throw new Error("File path is not set. Call 'setPage()' first.");
        }

        try {
            const absolutePath = path.resolve(this.filePath);
            const fileContent = fs.readFileSync(absolutePath, "utf8");
            const jsonData = JSON.parse(fileContent) as Record<string, Record<string, string | string[]>>;

            if (!webPage || !(webPage in jsonData)) {
                throw new Error(`Page "${webPage}" does not exist in the JSON.`);
            }

            const pageData = jsonData[webPage];

            if (!(elementName in pageData)) {
                throw new Error(`Element "${elementName}" does not exist on page "${webPage}".`);
            }

            const selectors = pageData[elementName];

            if (!Array.isArray(selectors)) {
                throw new Error(`Element "${elementName}" on page "${webPage}" is not an array.`);
            }

            // Map each selector string to a Locator instance
            return selectors.map(selector => page.locator(selector));
        } catch (error) {
            throw new Error(`Error reading JSON file at ${this.filePath}: ${error.message}`);
        }
    }

    public static async verifyPermissionHeaderAndDescription(
        name: string,
        description: string,
        pageName: string,
    ): Promise<void> {
        try {
            const headerSelector = String(await sprintf(this.getTheElement("PermissionHeader", pageName), name));
            const headerElement = await this.getElementBySelectorText(headerSelector);
            await pageFixture.expect(headerElement).toBeVisible();
            pageFixture.logger.info(`Permission header "${name}" is visible on page "${pageName}"`);

            const descSelector = String(
                await sprintf(this.getTheElement("PermissionDescription", pageName), name, description),
            );
            const descElement = await this.getElementBySelectorText(descSelector);
            await pageFixture.expect(descElement).toBeVisible();
            pageFixture.logger.info(
                `Permission description "${description}" for header "${name}" is visible on page "${pageName}"`,
            );
        } catch (error) {
            const wrappedError = new Error(
                `Failed to verify permission header "${name}" with description "${description}" on page "${pageName}". Error: ${error instanceof Error ? error.message : String(error)}`,
            ) as Error & { cause?: unknown };
            wrappedError.cause = error;
            throw wrappedError;
        }
    }

    public static async tabClick(tabName: string): Promise<void> {
        try {
            const tabSelector = String(await sprintf(this.getTheElement("Tab", "Component"), tabName));
            await this.clickByElementText(tabSelector);
            pageFixture.logger.info(`Successfully clicked on tab: ${tabName}`);
        } catch (error) {
            throw new Error(`Failed to click on tab: ${tabName}. Error: ${(error as Error).message}`);
        }
    }

    public static async containsTextByLocator(selectorText: string, text: string) {
        const element = await this.getElementBySelectorText(selectorText);
        await element.isVisible();
        const elementText = await element.textContent();
        try {
            await pageFixture.expect(element).toContainText(text);
            pageFixture.logger.info(`Element text contains '${text}' text`);
        } catch (error) {
            throw new Error(
                `Actual text: ${elementText?.trim() || "null"}, Expected text: ${text}. Error: ${(error as Error).message}`,
            );
        }
    }

    public static async verifyBreadcrumbTrail(expectedItems: string[], pageName: string): Promise<void> {
        const containerXpath = Common.getTheElement("Breadcrumb", pageName);
        const container = pageFixture.page.locator(`xpath=${containerXpath}`);
        await container.waitFor({ state: "visible", timeout: 5000 });

        const actualItems = await container.evaluate(breadcrumb => {
            const normalize = (value: string | null | undefined) => value?.replace(/\s+/g, " ").trim() ?? "";
            const items = Array.from(breadcrumb.querySelectorAll("a"))
                .map(anchor => normalize(anchor.textContent))
                .filter(Boolean);

            const clone = breadcrumb.cloneNode(true) as HTMLElement;
            clone.querySelectorAll("a, svg, img, i").forEach(node => node.remove());
            const currentPage = normalize(clone.textContent)
                .split(/\s*>\s*/)
                .map(normalize)
                .filter(Boolean)
                .pop();

            if (currentPage && !items.includes(currentPage)) {
                items.push(currentPage);
            }

            return items;
        });

        pageFixture.logger.info(
            `Expected breadcrumb: ${JSON.stringify(expectedItems)}, Actual: ${JSON.stringify(actualItems)}`,
        );
        if (JSON.stringify(actualItems) !== JSON.stringify(expectedItems)) {
            throw new Error(
                `Breadcrumb mismatch on "${pageName}" page. Expected: ${JSON.stringify(expectedItems)}, Actual: ${JSON.stringify(actualItems)}`,
            );
        }
    }

    static async verifyTableColumnValues(
        pageName: string,
        tableKey: string,
        rows: Array<{ fieldName: string; value: string }>,
    ): Promise<void> {
        const table = pageFixture.page.locator(Common.getTheElement(tableKey, pageName));
        await table.waitFor({ state: "visible", timeout: 5000 });
        await table.scrollIntoViewIfNeeded();

        const normalizeHeader = (text: string) => text.replace(/\s+/g, " ").trim().toUpperCase();
        const headerTexts = await table.locator("thead th").allTextContents();

        for (const { fieldName, value } of rows) {
            const fieldLabel = fieldName.trim();
            const expectedValue = value.trim();
            const columnIndex = headerTexts.findIndex(header =>
                normalizeHeader(header).includes(normalizeHeader(fieldLabel)),
            );

            if (columnIndex === -1) {
                throw new Error(
                    `Field "${fieldLabel}" not found on "${pageName}" page. Visible headers: [${headerTexts
                        .map(h => h.trim())
                        .filter(Boolean)
                        .join(", ")}]`,
                );
            }

            const cells = table.locator(`tbody tr td:nth-child(${columnIndex + 1})`);
            await cells.first().waitFor({ state: "attached", timeout: 5000 });

            const actualValues = await cells.evaluateAll(elements =>
                elements.map(cell => {
                    const styled = cell.querySelector("[class*='font-medium']");
                    const text = styled?.textContent ?? cell.textContent ?? "";
                    return text.replace(/\s+/g, " ").trim();
                }),
            );

            if (!actualValues.includes(expectedValue)) {
                throw new Error(
                    `Expected "${expectedValue}" for field "${fieldLabel}" on "${pageName}" page. Actual values: [${actualValues.join(", ")}]`,
                );
            }

            pageFixture.logger.info(`Field "${fieldLabel}" has expected value "${expectedValue}".`);
        }
    }

    static async verifyViewFieldIsReadOnly(elementName: string, pageName: string): Promise<void> {
        const field = pageFixture.page.locator(Common.getTheElement(elementName, pageName));
        await field.first().waitFor({ state: "visible", timeout: 5000 });
        await field.first().scrollIntoViewIfNeeded();

        const isReadOnly = await field.first().evaluate(element => {
            const container = element.closest("[x-data]") ?? element;
            const editables = container.querySelectorAll(
                "input:not([readonly]):not([type='hidden']), textarea:not([readonly]), select:not([disabled])",
            );
            return editables.length === 0;
        });

        if (!isReadOnly) {
            throw new Error(`View field "${elementName}" on "${pageName}" page is not read-only.`);
        }

        pageFixture.logger.info(`View field "${elementName}" on "${pageName}" page is read-only as expected.`);
    }

    private static storedText = "";

    public static createAndStoreText(): string {
        return (Common.storedText = `Automation_${Math.random().toString(36).substring(2, 10)}`);
    }

    public static getStoredValue(): string {
        if (!Common.storedText) {
            throw new Error('Run "user enter text in ... field on ... page" first.');
        }
        return Common.storedText;
    }

    public static async selectFirstDropdownOption(selector: string, pageName: string): Promise<void> {
        const timeout = FrameworkConstant.actionTimeout() * 1000;
        const dropdown = pageFixture.page.locator(`xpath=${this.getTheElement(selector, pageName)}`);
        await dropdown.waitFor({ state: "visible", timeout });

        const findFirstOptionIndex = () =>
            dropdown.evaluate((select: HTMLSelectElement) => {
                for (let i = 0; i < select.options.length; i++) {
                    const o = select.options[i];
                    if (o.value && o.text.trim() && !o.disabled) return i;
                }
                return -1;
            });

        let index = -1;
        const deadline = Date.now() + timeout;
        while (Date.now() < deadline) {
            index = await findFirstOptionIndex();
            if (index >= 0) break;
            await pageFixture.page.waitForTimeout(500);
        }

        if (index < 0) throw new Error(`No selectable option in "${selector}" on "${pageName}".`);
        await dropdown.selectOption({ index });
    }

    private static async getReviewDataTemplateTitleLocator(): Promise<Locator> {
        const stored = Common.storedText;
        const candidates = [
            ...(stored ? [`//*[contains(@class,'wl-panel')]//*[self::h1 or self::h2][contains(normalize-space(.),'${stored}')]`,] : []),
            this.getTheElement("ReviewDataTemplateTitle", "StructuredReview"),
        ];
        for (const xpath of candidates) {
            const locator = pageFixture.page.locator(`xpath=${xpath}`).locator("visible=true").first();
            try {
                await locator.waitFor({ state: "visible", timeout: 5000 });
                return locator;
            } catch {
                pageFixture.logger.info(`Template title not found with xpath: ${xpath}`);
            }
        }
        throw new Error("Review Data template title is not visible on the page.");
    }

    public static async verifyStoredValueAgainstSavedField(
        fieldLabel: string,
        savedDataKey: string,
        pageName: string,
        shouldMatch: boolean,
    ): Promise<void> {
        const stored = this.getStoredValue();
        const elementXpath = this.getTheElement(savedDataKey, pageName);
        const field =
            savedDataKey === "ReviewDataTemplateTitle"
                ? await this.getReviewDataTemplateTitleLocator()
                : elementXpath.includes("%s")
                    ? pageFixture.page.locator(`xpath=${sprintf(elementXpath, fieldLabel)}`)
                    : pageFixture.page.locator(`xpath=${elementXpath}`).locator("visible=true").first();
        await field.waitFor({ state: "visible", timeout: 5000 });
        const displayed = await field.evaluate(element => {
            const clone = element.cloneNode(true) as HTMLElement;
            clone.querySelectorAll("span, svg, i").forEach(node => node.remove());
            return (clone.textContent ?? "").replace(/\s+/g, " ").trim();
        });
        const valuesMatch = stored === displayed;
        if (shouldMatch !== valuesMatch) {
            throw new Error(
                shouldMatch
                    ? `Expected "${fieldLabel}" to match stored "${stored}" but was "${displayed}".`
                    : `"${fieldLabel}" must not equal stored "${stored}" but was "${displayed}".`,
            );
        }
    }

    public static async typeTextByLocator(selectorText: string, text: string): Promise<void> {
        try {
            const element = await this.getElementBySelectorText(selectorText);
            await element.fill(text);
            pageFixture.logger.info(`Successfully typed text into element: ${selectorText}`);
        } catch (error) {
            throw new Error(`Failed to type text into element: ${selectorText}. Error: ${(error as Error).message}`);
        }
    }

    public static async waitUntilTextIsNotVisible(
        selector: string,
        pageName: string,
        text: string,
        timeout = 30000,
    ): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName);

            await expect(element).not.toContainText(text, { timeout });

            pageFixture.logger.info(`Text "${text}" is no longer visible in element: ${selector}`);
        } catch (error) {
            throw new Error(
                `Failed waiting for text "${text}" to disappear from element: ${selector}. Error: ${(error as Error).message}`,
            );
        }
    }

    private static async confirmPeriodicReviewDeletion(confirmDate: string, pageName: string): Promise<void> {
        const confirmCandidates = [
            this.getTheElement("ConfirmDeletionInputBox", pageName),
            "//input[@id='ReviewDate'][contains(@placeholder,'/')]",
            "//div[@role='dialog']//input[@id='ReviewDate']",
        ];

        for (const xpath of confirmCandidates) {
            const confirmInput = pageFixture.page.locator(`xpath=${xpath}`).locator("visible=true").first();
            try {
                await confirmInput.waitFor({ state: "visible", timeout: 5000 });
                await confirmInput.fill(confirmDate);
                const okInForm = confirmInput.locator(
                    `xpath=ancestor::form[1]//button[.//span[normalize-space()='Ok']]`,
                );
                if ((await okInForm.count()) > 0) {
                    await okInForm.first().click();
                } else {
                    await pageFixture.page
                        .locator(`xpath=//button[.//span[normalize-space()='Ok']]`)
                        .locator("visible=true")
                        .first()
                        .click();
                }
                return;
            } catch {
                pageFixture.logger.info(`Delete confirm input not found: ${xpath}`);
            }
        }

        throw new Error(`Delete confirmation for date "${confirmDate}" was not found.`);
    }

    public static async deleteAllPeriodicReviews(confirmDate: string, pageName: string): Promise<void> {
        const deleteXpath = this.getTheElement("ReviewDeleteAllBtn", pageName);
        const maxAttempts = 20;

        await pageFixture.page
            .locator(`xpath=//tr[starts-with(@id,'periodic-review-')]`)
            .first()
            .waitFor({ state: "visible", timeout: 5000 })
            .catch(() => pageFixture.logger.info("Periodic review table rows not found before delete."));

        for (let attempt = 0; attempt < maxAttempts; attempt++) {
            const deleteButtons = pageFixture.page.locator(`xpath=${deleteXpath}`);
            const count = await deleteButtons.count();
            if (count === 0) {
                pageFixture.logger.info("All periodic reviews deleted.");
                return;
            }

            const deleteBtn = deleteButtons.first();
            await deleteBtn.scrollIntoViewIfNeeded();
            await deleteBtn.waitFor({ state: "visible", timeout: 5000 });
            await deleteBtn.click();
            await this.confirmPeriodicReviewDeletion(confirmDate, pageName);

            await expect(deleteButtons).toHaveCount(count - 1, { timeout: 5000 });
            pageFixture.logger.info(`Deleted periodic review. Remaining: ${count - 1}`);
        }

        const remaining = await pageFixture.page.locator(`xpath=${deleteXpath}`).count();
        throw new Error(`Could not delete all periodic reviews. ${remaining} delete button(s) still on the page.`);
    }

    public static async switchToAnotherTabByTitle(pageTitle: string): Promise<void> {
        const context = pageFixture.page.context();
        const currentPage = pageFixture.page;
        const mainContentXpath = this.getTheElement("MainContent", "StructuredReview");

        for (let i = 0; i < 10; i++) {
            const matchingPages = [];

            for (const pg of context.pages()) {
                if (pg.isClosed()) {
                    continue;
                }
                const title = await pg.title();
                if (title === pageTitle) {
                    matchingPages.push(pg);
                }
            }

            const targetPage =
                matchingPages.length >= 2
                    ? matchingPages[matchingPages.length - 1]
                    : matchingPages.length === 1 && matchingPages[0] !== currentPage
                        ? matchingPages[0]
                        : null;

            if (targetPage) {
                if (targetPage !== currentPage) {
                    await targetPage.bringToFront();
                    pageFixture.page = targetPage;
                }

                await pageFixture.page
                    .locator(`xpath=${mainContentXpath}`)
                    .waitFor({ state: "visible", timeout: 5000 });
                pageFixture.logger.info(`Switched to tab titled: ${pageTitle}`);
                return;
            }

            await new Promise(res => setTimeout(res, 500));
        }

        throw new Error(`Another tab with title '${pageTitle}' was not found.`);
    }

    public static async contains(actualText: string, expectedText: string) {
        try {
            pageFixture.expect(actualText).toContain(expectedText);

            pageFixture.logger.info(`'${actualText}' contains '${expectedText}' text`);
        } catch (error) {
            throw new Error(
                `Actual text: ${actualText?.trim() || "null"} does not contain Expected text: ${expectedText}. Error: ${(error as Error).message}`,
            );
        }
    }

    public static async waitUntilElementIsEnabled(selector: string, pageName: string, timeout = 300000): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName);

            await expect(element).toBeEnabled({ timeout });

            pageFixture.logger.info(`Element is enabled: ${selector}`);
        } catch (error) {
            throw new Error(
                `Failed waiting for element to become enabled: ${selector}. Error: ${(error as Error).message}`,
            );
        }
    }

    public static async isEnabled(locator: Locator, elementName: string) {
        try {
            await pageFixture.expect(locator).toBeEnabled();
            pageFixture.logger.info(`${elementName} is enabled`);
        } catch (error) {
            throw new Error(`${elementName} is NOT enabled. Error: ${(error as Error).message}`);
        }
    }

    public static async waitUntilTextIsVisible(
        selector: string,
        pageName: string,
        text: string,
        timeout = 30000,
    ): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            await expect(element).toContainText(text, { timeout });

            pageFixture.logger.info(`Text "${text}" is visible in element: ${selector}`);
        } catch (error) {
            throw new Error(
                `Failed waiting for text "${text}" to appear in element: ${selector}. Error: ${(error as Error).message}`,
            );
        }
    }

    public static async assertNotVisibleByText(selectorText: string): Promise<void> {
        try {
            const locator = await this.getElementBySelectorText(selectorText);
            await expect(locator.first()).not.toBeVisible();

            pageFixture.logger.info(`Element exists and is not visible: ${selectorText}`);
        } catch (error) {
            const errorMessage = String(error);

            if (errorMessage.includes("Element did not appear within timeout")) {
                pageFixture.logger.info(`Element not found: ${selectorText} (considered not visible)`);
                return;
            }

            throw error;
        }
    }

    public static async getAllTexts(elementName: string, webPage: string): Promise<string[]> {
        const elements = await this.getElementLocators(elementName, webPage, true, true);
        return await elements.allTextContents();
    }

    public static async waitUntilElementIsVisible(selector: string, pageName: string, timeout = 30000): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName, timeout);
            // Wait for attached first
            await element.waitFor({
                state: "attached",
                timeout,
            });
            // Then verify visible
            await expect(element).toBeVisible({ timeout });
            pageFixture.logger.info(`Element is visible: ${selector}`);
        } catch (error) {
            pageFixture.logger.error(`Element visibility failed: ${selector}`);
            throw new Error(`Element did not appear within timeout: ${selector}.`);
        }
    }

    public static async validateVersionsListedInDescendingOrderByCreatedDate(
        createdDateLocatorName: string,
        pageName: string,
    ): Promise<void> {
        const datePattern = /^(\d{2})\/(\d{2})\/(\d{4})\s+(\d{2}):(\d{2}):(\d{2})$/;
        const selector = this.getTheElement(createdDateLocatorName, pageName);
        const dateCells = pageFixture.page.locator(selector);
        const count = await dateCells.count();

        if (count === 0) {
            pageFixture.logger.info(
                `No version rows found for locator "${createdDateLocatorName}" on page "${pageName}". Skipping descending-order check.`,
            );
            return;
        }

        const parsedDates: Date[] = [];
        const rawDates: string[] = [];

        for (let i = 0; i < count; i++) {
            const rawText = (await dateCells.nth(i).textContent())?.trim() || "";
            rawDates.push(rawText);

            const match = rawText.match(datePattern);
            if (!match) {
                throw new Error(
                    `Invalid date format at row ${i + 1}: "${rawText}". Expected format: dd/MM/yyyy HH:mm:ss (e.g., 08/06/2026 05:49:58).`,
                );
            }

            const day = Number(match[1]);
            const month = Number(match[2]);
            const year = Number(match[3]);
            const hour = Number(match[4]);
            const minute = Number(match[5]);
            const second = Number(match[6]);

            const parsed = new Date(year, month - 1, day, hour, minute, second);

            const isValid =
                parsed.getFullYear() === year &&
                parsed.getMonth() === month - 1 &&
                parsed.getDate() === day &&
                parsed.getHours() === hour &&
                parsed.getMinutes() === minute &&
                parsed.getSeconds() === second;

            if (!isValid) {
                throw new Error(`Invalid calendar date at row ${i + 1}: "${rawText}".`);
            }

            parsedDates.push(parsed);
        }

        for (let i = 1; i < parsedDates.length; i++) {
            const previousTime = parsedDates[i - 1].getTime();
            const currentTime = parsedDates[i].getTime();

            if (currentTime > previousTime) {
                throw new Error(
                    `Version created dates are not in descending order between row ${i} and row ${i + 1}. ` +
                    `Row ${i}: "${rawDates[i - 1]}", Row ${i + 1}: "${rawDates[i]}".`,
                );
            }
        }

        pageFixture.logger.info(
            `Verified ${parsedDates.length} version created date entries are in descending order for "${createdDateLocatorName}" on "${pageName}" page.`,
        );
    }

    public static async checkCheckboxByLabel(labelText: string, pageName: string): Promise<void> {
        try {
            const locatorString = String(
                sprintf(this.getTheElement("CheckboxByLabel", pageName), labelText, labelText),
            );
            const el = pageFixture.page.locator(`xpath=${locatorString}`).first();
            await el.waitFor({ state: "attached", timeout: 10000 });

            const tagName = await el.evaluate(node => node.tagName.toLowerCase());
            if (tagName === "label") {
                await el.waitFor({ state: "visible", timeout: 10000 });
                const forId = await el.getAttribute("for");
                if (!forId) {
                    throw new Error(`Checkbox label "${labelText}" on "${pageName}" page has no "for" attribute.`);
                }
                const checkbox = pageFixture.page.locator(`#${forId}`);
                if (!(await checkbox.isChecked())) {
                    await el.click();
                    await expect(checkbox).toBeChecked({ timeout: 10000 });
                    pageFixture.logger.info(`Checkbox "${labelText}" checked via label on "${pageName}" page.`);
                } else {
                    pageFixture.logger.info(`Checkbox "${labelText}" was already checked on "${pageName}" page.`);
                }
                return;
            }

            const isChecked = await el.isChecked();
            if (!isChecked) {
                await el.check({ force: true });
                pageFixture.logger.info(`Checkbox "${labelText}" checked on "${pageName}" page.`);
            } else {
                pageFixture.logger.info(`Checkbox "${labelText}" was already checked on "${pageName}" page.`);
            }
        } catch (error) {
            throw new Error(
                `Failed to check checkbox with label "${labelText}" on "${pageName}" page. Error: ${(error as Error).message}`,
            );
        }
    }

    public static async addProspectWithDetails(
        lastName: string,
        email: string,
        onboardingType: string,
        status: string,
        handledByUserGroup: string,
        handledByUser: string,
        allowManageProspect: string,
    ): Promise<void> {
        const url = process.env.BASEURL + Common.getTheElement("EndPoint", "Prospect");
        const urlwithBU = url + "?__BusinessUnit=" + (process.env.BUSINESSUNIT || "10");
        await Common.navigateToURL(urlwithBU);
        await Common.typeText("LastName", "Onboarding", lastName);
        await Common.typeText("EmailAdd", "Onboarding", email);
        await Common.selectDropdown("ProspectOnboardingTypeID", "Onboarding", onboardingType);
        await Common.selectDropdown("Status", "Onboarding", status);
        await Common.selectDropdown("HandledByUserGroup", "Onboarding", handledByUserGroup);
        await Common.selectDropdown("HandledByUser", "Onboarding", handledByUser);
        await Common.selectDropdown("AllowManageProspect", "Onboarding", allowManageProspect);
        await Common.scrollIntoView("CreateProspect", "Onboarding");
        await Common.clickElement("CreateProspect", "Onboarding");
        await Common.containsText("BannerSuccessMessage", "Prospect has been added.", "Component");
    }

    public static async elementIsVisible(elementName: string, pageName: string, action: string): Promise<void> {
        switch (action.toLowerCase()) {
            case "true":
                pageFixture.expect(await this.isVisible(elementName, pageName)).toBeTruthy();
                break;

            case "false":
                await this.isNotVisible(elementName, pageName);
                break;

            default:
                throw new Error(`Invalid action "${action}". Use "true" or "false".`);
        }
    }
    public static async isRadioButtonChecked(selector: string, pageName: string): Promise<boolean> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            return await element.isChecked();
        } catch (error) {
            pageFixture.logger.warn(
                `Radio button not found or inaccessible for selector: ${selector} on page: ${pageName}. Returning false. Error: ${(error as Error).message}`,
            );
            return false;
        }
    }

    public static async resolveCharacterCount(countToken: string): Promise<number> {
        const directNumber = Number(countToken);
        if (Number.isInteger(directNumber) && directNumber > 0) {
            return directNumber;
        }

        let resolvedValue: string | undefined;
        try {
            resolvedValue = await APICommon.getStoredData(countToken);
        } catch {
            resolvedValue = process.env[countToken];
        }

        const resolvedNumber = Number(resolvedValue);
        if (!Number.isInteger(resolvedNumber) || resolvedNumber <= 0) {
            throw new Error(
                `Invalid character count '${countToken}'. Provide a positive integer or a key/env value that resolves to one.`,
            );
        }

        return resolvedNumber;
    }
    public static async selectDropdownOptionByTextOrValue(
        selector: string,
        pageName: string,
        value: string,
    ): Promise<void> {
        try {
            const element = await this.getElementLocator(selector, pageName);
            const trimmedValue = value.trim();
            const candidates: Array<{ value?: string; label?: string; index?: number }> = [
                { value },
                { label: value },
                { value: trimmedValue },
                { label: trimmedValue },
            ];
            // Only add an index candidate when value is a valid number, otherwise Playwright rejects the whole array (NaN)
            const numericIndex = Number(value);
            if (!Number.isNaN(numericIndex)) {
                candidates.push({ index: numericIndex });
            }
            let result = await element.selectOption(candidates);
            if (!result || result.length === 0) {
                // Fallback: manually find option by textContent (ignoring spaces)
                const options = await element.locator("option").all();
                let found = false;
                for (const option of options) {
                    const optionText = (await option.textContent())?.trim();
                    if (optionText && optionText.replace(/\s+/g, " ").trim() === trimmedValue.replace(/\s+/g, " ")) {
                        const optionValue = await option.getAttribute("value");
                        if (optionValue) {
                            result = await element.selectOption({ value: optionValue });
                            if (result && result.length > 0) {
                                found = true;
                                pageFixture.logger.info(
                                    `Successfully selected fallback option '${optionText}' in dropdown: ${selector}`,
                                );
                                break;
                            }
                        }
                    }
                }
                if (!found) {
                    throw new Error(`Option '${value}' not found in dropdown '${selector}' on page '${pageName}'.`);
                }
            } else {
                pageFixture.logger.info(`Successfully selected option '${value}' in dropdown: ${selector}`);
            }
        } catch (error) {
            throw new Error(
                `Failed to select option '${value}' in dropdown: ${selector} on page '${pageName}'. Error: ${(error as Error).message}`,
            );
        }
    }

    public static async isSelectedByLocator(selectorText: string, optionText: string): Promise<void> {
        try {
            const element = await this.getElementBySelectorText(selectorText);
            
            // Find the option with matching text
            const option = element.locator(`option`, { hasText: optionText }).first();
            
            // Check if the option exists
            await option.waitFor({ state: "attached", timeout: 5000 });
            
            // Get the selected attribute
            const isSelectedAttr = await option.getAttribute("selected");
            
            // Check if option has selected attribute or if it's the currently selected option
            const selectedText = await element.evaluate((select: HTMLSelectElement) => {
                return select.options[select.selectedIndex]?.textContent?.trim() || "";
            });
            
            if (isSelectedAttr === "selected" || selectedText === optionText) {
                pageFixture.logger.info(`Option '${optionText}' is selected in '${selectorText}' dropdown`);
            } else {
                throw new Error(
                    `Option '${optionText}' is not currently selected in '${selectorText}' dropdown. Currently selected: '${selectedText}'`,
                );
            }
        } catch (error) {
            throw new Error(
                `Failed to verify that option '${optionText}' is selected in '${selectorText}' dropdown. Error: ${(error as Error).message}`,
            );
        }
    }

    public static async setAttributeByLocator(
        selectorText: string,
        attributeName: string,
        attributeValue: string,
    ): Promise<void> {
        try {
            const element = await this.getElementBySelectorText(selectorText);

            // Set the attribute using browser context
            await element.evaluate(
                (el, { attr, value }) => {
                    el.setAttribute(attr, value);
                },
                { attr: attributeName, value: attributeValue },
            );

            pageFixture.logger.info(
                `Successfully set attribute "${attributeName}" with value "${attributeValue}" on element: ${selectorText}`,
            );
        } catch (error) {
            throw new Error(
                `Failed to set attribute "${attributeName}" on element: ${selectorText}. Error: ${(error as Error).message}`,
            );
        }
    }
}

export { Common };
