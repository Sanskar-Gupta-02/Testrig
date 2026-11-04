import { Then, When } from "@cucumber/cucumber";
import { pageFixture } from "../../../hooks/pagefixtures";
import { Common } from "../../../Helper/utilities/ui.utils";
import { sprintf } from "sprintf-js";

When(
    "user navigate to {string} entity type with {string} selected business unit",
    async function (entityTypeName: string, BUName: string) {
        const entityPage = await Common.getElementLocatorFromRaw(sprintf(Common.getTheElement("SideBarMenu", "Home"),"Entity Types"));
        await entityPage.click();

        await Common.typeText("EntityTypeSearchBox", "EntityType", entityTypeName);

        await pageFixture.page.keyboard.press("Enter");
        await pageFixture.page.waitForLoadState("networkidle");
        await pageFixture.page.waitForLoadState("load");

        const entityTypeViewButton = await Common.getElementLocatorFromRaw(sprintf(Common.getTheElement("DSCardViewButton","EntityType"),entityTypeName));
        await entityTypeViewButton.waitFor({ state: "visible" });
        await entityTypeViewButton.click();

        const entityTypeBUButton = await Common.getElementLocatorFromRaw(sprintf(Common.getTheElement("AddedBUViewButton", "EntityType"),BUName));
        await entityTypeBUButton.waitFor({ state: "visible" });
        await entityTypeBUButton.click();
    },
);

Then(
    "user should able to see following Business Units in {string} Entity Type card:",
    async function (entityTypeName: string, dataTable) {
        await Common.typeText(
            "EntityTypeSearchBox",
            "EntityType",
            entityTypeName,
        );

        await Promise.all([
            pageFixture.page.waitForLoadState("networkidle"),
            pageFixture.page.keyboard.press("Enter"),
        ]);

        const locatorString = sprintf(
            Common.getTheElement(
                "EntityTypeCardBusinessUnits",
                "EntityType",
            ),
            entityTypeName,
        );

        const cardItems = pageFixture.page.locator(locatorString);

        interface DataTable {
            raw(): string[][];
        }

        const normalizeText = (value: string): string =>
            value.replace(/\s+/g, " ").trim();

        const expectedValues: string[] = (dataTable as DataTable)
            .raw()
            .flat()
            .map(normalizeText)
            .filter(value => value !== "");

        // Wait for the first matched Business Unit to become visible.
        // Do not call waitFor() directly on cardItems because it matches
        // multiple elements and causes a strict mode violation.
        await cardItems.first().waitFor({ state: "visible" });

        const itemCount = await cardItems.count();

        if (itemCount === 0) {
            throw new Error(
                `No Business Units found for Entity Type card "${entityTypeName}".`,
            );
        }

        const cardBuList: string[] = (
            await cardItems.allInnerTexts()
        )
            .map(normalizeText)
            .filter(value => value !== "");

        pageFixture.logger.info(
            `Available Business Units: [${cardBuList.join(", ")}]`,
        );

        const missingValues = expectedValues.filter(
            expectedValue =>
                !cardBuList.some(
                    actualValue => actualValue === expectedValue,
                ),
        );

        if (missingValues.length > 0) {
            throw new Error(
                `Expected Business Units not found in card: ` +
                `[${missingValues.join(", ")}]. ` +
                `Available: [${cardBuList.join(", ")}].`,
            );
        }

        pageFixture.logger.info(
            `All expected Business Units ` +
            `[${expectedValues.join(", ")}] are present in ` +
            `Entity Type card "${entityTypeName}".`,
        );
    },
);

Then(
    "user Should be able to see following Business Units in {string} Entity Type card:",
    async function (entityTypeName: string, dataTable) {
        await Common.typeText("EntityTypeSearchBox", "EntityType", entityTypeName);

        await Promise.all([pageFixture.page.waitForLoadState("networkidle"), pageFixture.page.keyboard.press("Enter")]);

        const cardItems = await Common.getElementLocatorFromRaw(
            sprintf(Common.getTheElement("EntityTypeBusinessUnits", "EntityType"), entityTypeName),
        );

        // Wait until at least one item is present
        await cardItems.waitFor({ state: "attached", timeout: 5000 });
        const itemCount = await cardItems.count();
        if (itemCount === 0) {
            throw new Error(`No elements found for locator: ${entityTypeName}`);
        }

        interface DataTable {
            raw(): string[][];
        }

        const expectedValues: string[] = (dataTable as DataTable)
            .raw()
            .flat()
            .map((v: string) => v.trim())
            .filter((v: string) => v !== "");

        const cardBuList: string[] = [];
        for (let i = 0; i < itemCount; i++) {
            const item = cardItems.nth(i);
            if (await item.isVisible()) {
                const text = ((await item.textContent()) ?? "")
                    .replace(/\s+/g, " ")
                    .trim()
                    .replace(/\s*\+\d+$/, "");

                if (text !== "") {
                    cardBuList.push(text);
                }
                pageFixture.logger.info(`Card BU row ${i + 1}: "${text}"`);
            }
        }

        if (cardBuList.length === 0) {
            throw new Error(`No visible Business Unit entries found for locator: ${entityTypeName}`);
        }

        const missingValues = expectedValues.filter(
            expected =>
                !cardBuList.some(actual => actual.replace(/\s+/g, " ").trim() === expected.replace(/\s+/g, " ").trim()),
        );
        if (missingValues.length > 0) {
            throw new Error(
                `Expected Business Units not found in card [${missingValues.join(", ")}]. Available: [${cardBuList.join(", ")}].`,
            );
        }

        pageFixture.logger.info(`All expected Business Units [${expectedValues.join(", ")}] are present in the card.`);
    },
);

Then(
    "user should able to see {string} circle around {string} business unit in {string} Entity Type card",
    async function (color: string, buName: string, entityTypeName: string) {
        const locatorString = String(
            await sprintf(Common.getTheElement("EntityTypeCardBusinessUnitIcon", "EntityType"), entityTypeName, buName),
        );

        const element = pageFixture.page.locator(locatorString);
        await element.waitFor({ state: "visible", timeout: 5000 });

        const classAttribute = await element.getAttribute("class");
        if (classAttribute === null) {
            throw new Error(`Element for ${buName} has no class attribute: ${locatorString}`);
        }

        let expectedClassPart: string;
        switch (color.toLowerCase()) {
            case "red":
                expectedClassPart = "red";
                break;
            case "green":
                expectedClassPart = "green";
                break;
            default:
                throw new Error(`Unsupported circle color '${color}'. Use only 'red' or 'green'.`);
        }

        if (!classAttribute.toLowerCase().includes(expectedClassPart)) {
            throw new Error(
                `Expected circle around '${buName}' to contain class '${expectedClassPart}', but actual class was '${classAttribute}'.`,
            );
        }

        pageFixture.logger.info(
            `Verified ${color} circle around business unit '${buName}' in '${entityTypeName}' Entity Type card.`,
        );
    },
);

Then(
    "user should able to see {string} circle around {string} business unit with title {string} in {string} Entity Type card",
    async function (color: string, buName: string, title: string, entityTypeName: string) {
        const locatorString = sprintf(Common.getTheElement("EntityTypeCardBusinessUnitIcon", "EntityType"),
            entityTypeName,
            title,
            buName,
        );

        const element = pageFixture.page.locator(locatorString).first();

        await element.waitFor({
            state: "visible",
            timeout: 5000,
        });

        const classAttribute = await element.getAttribute("class");

        if (!classAttribute) {
            throw new Error(`Element for '${buName}' has no class attribute.`);
        }

        let expectedClassPart: string;

        switch (color.toLowerCase()) {
            case "blue":
                expectedClassPart = "bg-brand-500";
                break;

            case "orange":
                expectedClassPart = "bg-kyc360-unpublished-badge";
                break;

            default:
                throw new Error(`Unsupported color '${color}'. Use only 'blue' or 'orange'.`);
        }

        if (!classAttribute.toLowerCase().includes(expectedClassPart)) {
            throw new Error(
                `Expected '${buName}' to have '${expectedClassPart}' circle, but actual class was '${classAttribute}'.`,
            );
        }

        pageFixture.logger.info(`Verified ${color} circle around '${buName}' in '${entityTypeName}' Entity Type card.`);
    },
);

Then(
    "user should NOT see following Business Units in {string} Entity Type card:",
    async function (entityTypeName: string, dataTable) {
        await Common.typeText("EntityTypeSearchBox", "EntityType", entityTypeName);

        const locatorString = String(
            await sprintf(Common.getTheElement("EntityTypeCardBusinessUnits", "EntityType"), entityTypeName),
        );

        const entityTypeCard = String(
            await sprintf(Common.getTheElement("EntityTypeCardViewBTN", "EntityType"), entityTypeName),
        );

        await pageFixture.page.waitForSelector(entityTypeCard, { state: "visible", timeout: 5000 });

        const cardItems = pageFixture.page.locator(locatorString);

        interface DataTable {
            raw(): string[][];
        }

        const expectedValues: string[] = (dataTable as DataTable)
            .raw()
            .flat()
            .map((v: string) => v.trim())
            .filter((v: string) => v !== "");

        const cardBuList: string[] = [];

        const itemCount = await cardItems.count();

        for (let i = 0; i < itemCount; i++) {
            const item = cardItems.nth(i);
            if (await item.isVisible()) {
                const text = (await item.textContent())?.trim() || "";
                if (text !== "") {
                    cardBuList.push(text);
                }
                pageFixture.logger.info(`Card BU row ${i + 1}: "${text}"`);
            }
        }

        const foundValues = expectedValues.filter(value => cardBuList.includes(value));

        if (foundValues.length > 0) {
            throw new Error(
                `Unexpected Business Units found in card: [${foundValues.join(", ")}]. Available: [${cardBuList.join(", ")}].`,
            );
        }

        pageFixture.logger.info(`Verified Business Units [${expectedValues.join(", ")}] are NOT present in the card.`);
    },
);

Then(
    "user Should Not See following Business Units in {string} Entity Type card:",
    async function (entityTypeName: string, dataTable) {
        await Common.typeText("EntityTypeSearchBox", "EntityType", entityTypeName);

        await Promise.all([pageFixture.page.waitForLoadState("networkidle"), pageFixture.page.keyboard.press("Enter")]);

        try {
            const cardItem = await Common.getElementLocatorFromRaw(
                sprintf(Common.getTheElement("EntityTypeCardNoBusinessUnits", "EntityType"), entityTypeName),
                500,
            );

            // If locator is found and visible, fail the test
            if (await cardItem.isVisible()) {
                throw new Error(`Unexpected Business Unit found in card: "${entityTypeName}".`);
            }
        } catch (error) {
            // Expected scenario: Business Unit is not found
            if ((error as Error).message.includes("Element did not appear within timeout")) {
                pageFixture.logger.info(`Verified Business Unit "${entityTypeName}" is NOT present in the card.`);
                return;
            }

            throw error;
        }

        throw new Error(`Unexpected Business Unit found in card: "${entityTypeName}".`);
    },
);
