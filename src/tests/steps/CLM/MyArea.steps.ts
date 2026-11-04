import { When } from "@cucumber/cucumber";
import { sprintf } from "sprintf-js";
import { Common } from "../../../Helper/utilities/ui.utils";
import { pageFixture } from "../../../hooks/pagefixtures";

const MY_AREA_PAGE = "MyArea";
const COMMON_PAGE = "Common";

async function clickBusinessUnitViewCard(businessUnitName: string): Promise<void> {
    const selector = String(await sprintf(Common.getTheElement("ViewBtnOnCard", COMMON_PAGE), businessUnitName));
    const viewButton = await Common.getElementLocatorFromRaw(selector);
    await viewButton.click();
}

When("user clicks View on business unit card {string} for My Area", async function (businessUnitName: string) {
    await clickBusinessUnitViewCard(businessUnitName);
    await pageFixture.page.waitForLoadState("load");
    pageFixture.logger.info(`Clicked View on business unit card "${businessUnitName}" for My Area`);
});

When(
    "user edits business unit {string} and increments {string} for My Area on {string} page",
    async function (businessUnitName: string, elementName: string, pageName: string) {
        await Common.clickElement("BUTab", "Entities");
        await pageFixture.page.waitForLoadState("load");

        await clickBusinessUnitViewCard(businessUnitName);
        await pageFixture.page.waitForLoadState("load");

        await Common.clickElement("EditBTN", COMMON_PAGE);

        const currentValueStr = await Common.getAttribute(elementName, pageName, "value");
        const currentValue = parseInt(currentValueStr, 10);

        if (isNaN(currentValue)) {
            throw new Error(`Current value in "${elementName}" is not a number: "${currentValueStr}"`);
        }

        const newValue = currentValue + 1;
        await Common.setAttribute(elementName, pageName, "value", newValue.toString());
        pageFixture.logger.info(
            `Edited business unit "${businessUnitName}" and incremented "${elementName}" for My Area`,
        );
    },
);

When(
    "user searches {string} in {string} field on My Area page",
    async function (text: string, fieldName: string) {
        if (fieldName !== "RequiresReviewSearchBox" && fieldName !== "RequiresAmendmentSearchBox") {
            throw new Error(
                `Unsupported My Area search field "${fieldName}". ` +
                    `Use RequiresReviewSearchBox or RequiresAmendmentSearchBox.`,
            );
        }
        const searchField = await Common.getElementLocator(fieldName, MY_AREA_PAGE);
        await searchField.click();
        await searchField.clear();
        await searchField.pressSequentially(text, { delay: 100 });
        await searchField.press("Tab");
        pageFixture.logger.info(`Searched "${text}" in "${fieldName}" on My Area page`);
    },
);

When(
    "user opens a new My Area browser context, logs in as {string}, searches for entity {string} in Requires Review and performs {string} action",
    async function (username: string, entityName: string, action: string) {
        const context = await pageFixture.page.context().browser()!.newContext();
        const newPage = await context.newPage();

        const baseUrl = process.env.BASEURL;
        const userEnvVar = username;
        const passwordEnvVar = `${username}Password`;
        const userEnvValue = process.env[userEnvVar];
        const passwordEnvValue = process.env[passwordEnvVar];

        if (!baseUrl) {
            throw new Error(
                `Missing required environment variable 'BASEURL' for login step. ` +
                    `Ensure BASEURL is set in the environment before running this test.`,
            );
        }
        if (userEnvValue === undefined) {
            throw new Error(
                `Missing required environment variable for username '${username}'. ` +
                    `Expected environment variable: '${userEnvVar}'.`,
            );
        }
        if (passwordEnvValue === undefined) {
            throw new Error(
                `Missing required environment variable for password of username '${username}'. ` +
                    `Expected environment variable: '${passwordEnvVar}'.`,
            );
        }

        await newPage.goto(baseUrl);
        await newPage.fill(Common.getTheElement("UserName", "Login"), userEnvValue);
        await newPage.click(Common.getTheElement("Submit", "Login"));
        await newPage.fill(Common.getTheElement("Password", "Login"), passwordEnvValue);
        await newPage.click(Common.getTheElement("Submit", "Login"));
        await newPage.click(Common.getTheElement("StaySignedSInNoButton", "Login"));
        await newPage.waitForLoadState("load");

        const tenantButton = String(
            await sprintf(
                Common.getTheElement("TenantButton", "Home"),
                "TEST AUTOMATION TENANT - DO NOT TOUCH",
            ),
        );
        await newPage.click(tenantButton);

        const myAreaSidebar = await sprintf(Common.getTheElement("SideBarMenu", "Home"), "My Area");
        await newPage.click(myAreaSidebar);
        await newPage.click(Common.getTheElement("RequiresReviewTab", MY_AREA_PAGE));

        const searchField = newPage.locator(Common.getTheElement("RequiresReviewSearchBox", MY_AREA_PAGE));
        await searchField.click();
        await searchField.clear();
        await searchField.pressSequentially(entityName, { delay: 100 });
        await searchField.press("Tab");

        const entityViewButton = await sprintf(
            Common.getTheElement("RequiresReviewEntityViewBtn", MY_AREA_PAGE),
            entityName,
        );
        await newPage.locator(entityViewButton).click();

        await newPage.isVisible(Common.getTheElement("DataStructureApprovalHeader", MY_AREA_PAGE));
        await pageFixture.page.waitForTimeout(5000);
        await newPage.isVisible(Common.getTheElement("DataStructureApprovalHeader", MY_AREA_PAGE));
        await newPage.isVisible(Common.getTheElement("ShowWorkFlowPaneToggle", "Entities"));
        await newPage.isVisible(Common.getTheElement("DataChangeToggle", "Entities"));

        switch (action.toLowerCase()) {
            case "approve":
                await newPage.click(Common.getTheElement("ApproveBtn", "Entities"));
                await pageFixture.page.waitForTimeout(3000);
                await newPage.isVisible(Common.getTheElement("ApproveWorkFlowModal", "Entities"));
                await newPage.isVisible(Common.getTheElement("ApproveWorkFlowModalDescription", "Entities"));
                await newPage.fill(Common.getTheElement("ApproveWorkFlowModalInputBox", "Entities"), "Approved");
                await pageFixture.page.waitForTimeout(2000);
                await newPage.click(Common.getTheElement("ApproveWorkFlowModalSubmitButton", "Entities"));
                await newPage.isVisible(Common.getTheElement("ApprovedToastMessage", "Entities"));
                await pageFixture.page.waitForTimeout(4000);
                break;
            case "reject":
                await newPage.click(Common.getTheElement("RejectBtn", "Entities"));
                await newPage.isVisible(Common.getTheElement("RejectWorkFlowModal", "Entities"));
                await newPage.isVisible(Common.getTheElement("RejectWorkFlowModalDescription", "Entities"));
                await newPage.fill(Common.getTheElement("RejectWorkFlowModalInputBox", "Entities"), "Rejected");
                await newPage.click(Common.getTheElement("RejectWorkFlowModalSubmitButton", "Entities"));
                await newPage.isVisible(Common.getTheElement("RejectedToastMessage", "Entities"));
                await pageFixture.page.waitForTimeout(4000);
                break;
            case "request changes":
            case "requestchanges":
                await newPage.click(Common.getTheElement("RequestChangesBtn", "Entities"));
                await newPage.isVisible(Common.getTheElement("RequestChangesWorkFlowModal", "Entities"));
                await newPage.isVisible(Common.getTheElement("RequestChangesWorkFlowModalDescription", "Entities"));
                await newPage.fill(
                    Common.getTheElement("RequestChangesWorkFlowModalInputBox", "Entities"),
                    "Requesting changes",
                );
                await newPage.click(Common.getTheElement("RequestChangesWorkFlowModalSubmitButton", "Entities"));
                await newPage.isVisible(
                    String(
                        await sprintf(
                            Common.getTheElement("RequestChangesToastMessage", "Entities"),
                            "Changes requested",
                        ),
                    ),
                );
                await pageFixture.page.waitForTimeout(4000);
                break;
            default:
                throw new Error(`Unknown action: ${action}`);
        }

        await newPage.close();
        await context.close();
        await pageFixture.page.reload();
    },
);
