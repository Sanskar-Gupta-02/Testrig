import { When, Then, Given, IWorld } from "@cucumber/cucumber";
import { getOutlookEmailService } from "../../../Helper/utilities/emailServiceFactory";
import { emailService } from "../../../hooks/emailServiceState";
import { Common } from "../../../Helper/utilities/ui.utils";
import { pageFixture } from "../../../hooks/pagefixtures";
import { APICommon } from "../../../Helper/utilities/api.utils";
import { sprintf } from "sprintf-js";
import { Dialog } from "playwright";
import { getScenarioContext } from "../../../hooks/scenarioContext";

export interface CustomWorld extends IWorld {
    dialog?: Dialog;
    dialogMessage?: string;
}

When(
    "user enter {string} text in {string} field on {string} page",
    async function (text: string, elementName: string, page: string) {
        text = Common.resolveUniqueName(text);
        await Common.typeText(elementName, page, text);
        if (page === "Refit") {
            await Common.clickElement("PropertyGropuName1", page);
        }
        if (
            elementName === "EntitySearchBox" ||
            elementName === "TargetEntitySearchBox" ||
            elementName === "EntityTypeSearchBox" ||
            elementName === "SearchBox" ||
            elementName === "EntityTypeBUAddSearchBox"
        ) {
            // Press Enter on the field itself; global keyboard focus can be lost if the UI re-renders after fill()
            const searchField = await Common.getElementLocator(elementName, page);
            await searchField.press("Enter");
        }
    },
);

When(
    "user send {string} characters to {string} textfield on {string} page",
    async function (countToken: string, elementName: string, pageName: string) {
        const characterCount = await Common.resolveCharacterCount(countToken);
        const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        const generatedText = Array.from({ length: characterCount }, () =>
            chars.charAt(Math.floor(Math.random() * chars.length)),
        ).join("");

        await Common.typeText(elementName, pageName, generatedText);
    },
);

When("user wait from {int} seconds", async function (time: number) {
    await Common.waitForSeconds(time);
});

When("user refresh the page", async function () {
    await Common.refreshPage();
    await pageFixture.page.waitForLoadState("load");
});

Then("user should see the following texts in following fields", async function (dataTable) {
    const rows: Array<{ field: string; page: string; text: string }> = dataTable.hashes() as Array<{
        field: string;
        page: string;
        text: string;
    }>;
    for (const row of rows) {
        try {
            await Common.isTextEqual(row.field, row.text, row.page);
        } catch (error) {
            const enhancedError = new Error(
                `Validation failed for field "${row.field}" with page "${row.page}" with text "${row.text}": ${error instanceof Error ? error.message : String(error)
                }`,
            );
            // Mark the step as failed in Cucumber's reporting
            this.attach(JSON.stringify(row, null, 2), "application/json");
            throw enhancedError;
        }
    }
});

Then("user should see {string} title on {string} page", async function (pageTitle: string, page: string) {
    await Common.isTextEqual("pageTitle", page, pageTitle);
});

When(
    "user get the Verification code from:{string} and to:{string} email",
    async function (fromEmailId: string, toEmailId: string) {
        getScenarioContext().stepData.otp = await emailService.getOtp(fromEmailId, toEmailId);
    },
);

When("user enter the Verification code", async function () {
    const otp = getScenarioContext().stepData.otp;
    if (!otp) {
        throw new Error("Verification code has not been retrieved for this scenario");
    }
    await Common.typeText("VerificationCode", "Onboarding", otp);
});

When(
    "user select {string} option in {string} dropdown on {string} page",
    async function (optionName: string, dropdownName: string, page: string) {
        optionName = Common.resolveUniqueName(optionName);
        await Common.selectDropdown(dropdownName, page, optionName);
    },
);

Then(
    "user should see {string} text in {string} field on {string} page",
    async function (text: string, fieldName: string, page: string) {
        await Common.containsText(fieldName, text, page);
    },
);

Then(
    "user should see {string} {string} on {string} page",
    async function (Component: string, text: string, pageName: string) {
        await Common.containsText(Component, text, pageName);
    },
);

Then("user should see {string} table on {string} page", async function (tableName: string, page: string) {
    pageFixture.expect(await Common.isVisible(tableName, page)).toBeTruthy();
});

Then("user should see link pop up {string} on {string} page", async function (popupName: string, page: string) {
    pageFixture.expect(await Common.isVisible(popupName, page)).toBeTruthy();
});

//This method is used to check element is present on the page
Then("user should able see {string} on {string} page", async function (elementName: string, page: string) {
    await Common.isVisible(elementName, page);
});
Then("user should see the following value in following fields", async function (dataTable) {
    // Iterate over each row of the table data
    for (const { field, page, text } of dataTable.hashes()) {
        await Common.isValueEqual(field, page, text); // field is the locator, text is the expected value
    }
});

Then(
    "user should see {string} value in {string} field on {string} page",
    async function (value: string, element: string, page: string) {
        await Common.isValueEqual(element, page, value);
    },
);

Then(
    "user should receives email from:{string} and to:{string} and body should contains {string} on outlook",
    async function (fromEmailId: string, toEmailId: string, messageBody: string) {
        const svc = getOutlookEmailService();
        const msgBody = await svc.verifyEmailBody(fromEmailId, toEmailId);
        const processedBody = await APICommon.getMessageBodyWithStoreKey(messageBody);
        APICommon.verifyEmailMessageBodyContains(msgBody, processedBody);
    },
);

Given("user login into {string} application with {string} user", async function (app: string, username: string) {
    switch (app.toLowerCase()) {
        case "refit":
            await pageFixture.page.goto(process.env.BASEURL);
            // Common.setPage("Login");
            await Common.typeText("UserName", "Login", process.env[username]);
            await Common.typeText("Password", "Login", process.env[`${username + "Password"}`]);
            await Common.clickElement("LoginButton", "Login");
            break;
    }
});

When("user clicks on {string} OB type on {string} page", async function (onBoardingType: string, pageName: string) {
    await Common.clickWithText("OnboardingTypeName", onBoardingType, pageName);
});

When("user clicks on {string} on {string} page", async function (buttonName: string, pageName: string) {
    await pageFixture.page.waitForLoadState("load");
    if (buttonName === "SideBarMenuBtn") {
        await Common.expandSideBarIfCollapsed();
        await pageFixture.page.waitForLoadState("load");
        return;
    }
    const buttonLocator = String(sprintf(Common.getTheElement(buttonName, pageName)));
    // Use page.locator for Xpath selectors
    if (
        !buttonLocator.startsWith("role=") &&
        !buttonLocator.startsWith("text=") &&
        !buttonLocator.startsWith("label=") &&
        !buttonLocator.startsWith("chain=") &&
        !buttonLocator.startsWith("permissionrow=") &&
        !buttonLocator.startsWith("sidebarrole=") &&
        !buttonLocator.startsWith("mainrole=")
    ) {
        const locatorString =
            buttonLocator.startsWith("//") || buttonLocator.startsWith("(")
                ? `xpath=${buttonLocator}`
                : buttonLocator;
        const button = pageFixture.page.locator(locatorString).first();
        await button.waitFor({ state: "visible" });
    }
    await Common.clickElement(buttonName, pageName);
    await pageFixture.page.waitForLoadState("load");
});

Then("user should to see the {string} on {string} page", async function (element: string, pageName: string) {
    await Common.isVisible(element, pageName);
});

When(
    "user enter date {string} text in {string} field on {string} page",
    async function (date: string, element: string, pageName: string) {
        await Common.setAttribute(element, pageName, "value", date);
        await pageFixture.page.keyboard.press("Enter");
        if (pageName === "Refit") {
            await Common.clickElement("PropertyGropuName1", pageName);
        }
    },
);

When("user navigates to URL with the stored key value {string}", async function (storedKey: string) {
    const url = APICommon.getStoredData(storedKey);
    await Common.navigateToURL(url);
});

When(
    "user navigates to {string} page with URL: {string} with the page title {string}",
    async function (pageName: string, urlTemplate: string, expectedTitle: string) {
        const placeholderRegex = /<([^>]+)>/g;
        let finalUrl = urlTemplate;
        let match: RegExpExecArray | null;

        while ((match = placeholderRegex.exec(urlTemplate)) !== null) {
            const placeholder = match[1];
            let value: string | undefined;

            try {
                value = APICommon.getStoredData(placeholder);
            } catch {
                value = process.env[placeholder];
            }

            if (!value) {
                throw new Error(`Value for <${placeholder}> not found in stored data or environment variables.`);
            }

            finalUrl = finalUrl.replace(`<${placeholder}>`, value);
        }
        const pageUrl: string = process.env.BASEURL + finalUrl;
        await Common.navigateToURL(pageUrl);
        await Common.containsText("pageTitle", expectedTitle, pageName);
    },
);
Then(
    "user should see {string} button clickable:{string} on {string} page",
    async function (elementName: string, stateName: string, pageName: string) {
        const isClickable = await Common.isElementClickable(elementName, pageName);
        Common.isEqual(isClickable.toString(), stateName);
    },
);

When(
    "user upload {string} file on {string} on {string} page",
    async function (this: CustomWorld, fileName: string, elementName: string, pageName: string) {
        await Common.fileUpload(fileName, elementName, pageName, this);
    },
);

Then(
    "user should see {string} option selected on {string} on {string} page",
    async function (optionName: string, elementName: string, pageNmae: string) {
        await Common.isSelected(optionName, elementName, pageNmae);
    },
);
Then(
    "user should see {string} options in dropdown {string} on {string} page",
    async (optionText: string, dropdownSelector: string, pageName: string) => {
        await Common.verifyOptionsInDropdown(optionText, dropdownSelector, pageName);
    },
);

Then(
    "user should see {string} options in dropdown {string} on {string} page in same order",
    async (optionText: string, dropdownSelector: string, pageName: string) => {
        await Common.verifyOptionsInDropdownInOrder(optionText, dropdownSelector, pageName);
    },
);

Then(
    "user should see {string} prospect below {string} prospect in prospect group structure",
    async function (childProspect: string, parentProspect: string) {
        const selector: string = String(
            await sprintf(
                Common.getTheElement("ProspectGroupHierarchy", "ManageProspectGroup"),
                parentProspect,
                childProspect,
            ),
        );
        pageFixture.logger.info(`Checking visibility of selector: ${selector}`);
        const element = pageFixture.page.locator(selector);
        await element.scrollIntoViewIfNeeded();
        await element.waitFor({ state: "visible", timeout: 5000 });
        pageFixture.expect(await element.isVisible()).toBeTruthy();
    },
);
When("user selects {string} Business Unit", async function (BusinessUnit: string) {
    await Common.selectDropdownByVlaue("BusinessUnit", "Home", BusinessUnit);
});

When(
    "user click the {string} view button on the {string} page new tab opens and validate the image and return to the dcf",
    async function (buttonName: string, pageName: string) {
        await Common.handleTabAndClick("DocumentViewButton", buttonName, pageName);
    },
);

Then("user should see alert with message {string}", function (this: CustomWorld, expectedMessage: string) {
    if (!this.dialogMessage || !this.dialog) {
        throw new Error("❌ No alert was captured.");
    }

    if (this.dialogMessage !== expectedMessage) {
        throw new Error(`❌ Expected alert message "${expectedMessage}", but got "${this.dialogMessage}"`);
    }
});

When("user double clicks on {string} prospect in prospect group structure", async function (prospectName: string) {
    const element: string = String(
        await sprintf(Common.getTheElement("ProspectNameInHierarchy", "ManageProspectGroup"), prospectName),
    );
    await Common.doubleClickElement(element);
});

When("user switch to {string} page", async function (pageTitle: string) {
    // Wait for a new page with the given title to appear (timeout 10s)
    const context = pageFixture.page.context();
    for (let i = 0; i < 20; i++) {
        const pages = context.pages();
        for (const pg of pages) {
            const title = await pg.title();
            if (title.includes(pageTitle)) {
                await pg.bringToFront();
                pageFixture.page = pg;
                return;
            }
        }
        await new Promise(res => setTimeout(res, 500));
    }
    throw new Error(`Page with title '${pageTitle}' not found after waiting.`);
});

Then(
    "user should not be able to see {string} text in {string} field on {string} page",
    async function (text: string, fieldName: string, page: string) {
        await Common.doesNotContainText(fieldName, text, page);
    },
);

When(
    "user enters a date {string} text in {string} field on {string} page",
    async function (date: string, element: string, pageName: string) {
        await Common.fillDateInput(element, pageName, date); // Format: "2025-07-31"

        if (pageName === "Refit") {
            await Common.clickElement("PropertyGropuName1", pageName);
        }
    },
);

When(
    "user enters date 2 days before today in {string} field on {string} page",
    async function (element: string, pageName: string) {
        const formattedDate = Common.getDateInYYYYMMDD(2);

        await Common.fillDateInput(element, pageName, formattedDate);

        if (pageName === "Refit") {
            await Common.clickElement("PropertyGropuName1", pageName);
        }
    },
);


When("user enters today date in {string} field on {string} page", async function (element: string, pageName: string) {
    const formattedDate = Common.getDateInYYYYMMDD(0);

    await Common.fillDateInput(element, pageName, formattedDate);

    if (pageName === "Refit") {
        await Common.clickElement("PropertyGropuName1", pageName);
    }
},
);

Then(
    "user should see all see checkbox on {string} checked on {string} page",
    async function (checkboxSelector: string, pageName: string) {
        const checkboxes = await Common.getElementLocators(checkboxSelector, pageName);
        await Common.areElementsChecked(checkboxes);
    },
);

Then(
    "user should see {string} value in {string} field on the {string} page",
    async function (value: string, fieldName: string, page: string) {
        const valueOfElement = await Common.getAttribute(fieldName, page, "value");
        Common.isEqual(valueOfElement, value);
    },
);
When(
    "user click the {string} view button on the {string} page new tab opens and validate the image",
    async function (buttonName: string, pageName: string) {
        await Common.handleTabAndClick("DocumentViewButtonInternal", buttonName, pageName);
    },
);

Then(
    "user should see {string} in all {string} dropdowns on {string} page",
    async function (optionText: string, dropdownSelector: string, pageName: string) {
        pageFixture.logger.info(`element count is: 1`);
        const elements = await Common.getElementLocators(dropdownSelector, pageName);
        pageFixture.logger.info(`element count is:2`);

        const elementCount: number = await elements.count();
        pageFixture.logger.info(`element count is: ${elementCount}`);

        for (let i = 0; i < elementCount; i++) {
            const element = elements.nth(i);
            const selectedOption = await element.locator("option:checked").textContent();
            Common.isEqual(selectedOption?.trim(), optionText);
        }
    },
);

Then(
    "the dropdown {string} on {string} page should have the following options:",
    async function (dropdownLocatorName: string, pageName: string, dataTable) {
        const locatorString = Common.getTheElement(dropdownLocatorName, pageName);
        const dropdown = pageFixture.page.locator(locatorString);
        await dropdown.waitFor({ state: "visible", timeout: 5000 });

        // Get all option texts
        const options = await dropdown.locator("option").allTextContents();
        interface DataTable {
            raw(): string[][];
        }

        const expectedOptions: string[] = (dataTable as DataTable)
            .raw()
            .flat()
            .map((v: string) => v.trim());

        if (options.length < expectedOptions.length) {
            throw new Error(`Dropdown has ${options.length} options, but expected at least ${expectedOptions.length}`);
        }

        for (let i = 0; i < expectedOptions.length; i++) {
            if (options[i] !== expectedOptions[i]) {
                throw new Error(`Option ${i + 1}: expected "${expectedOptions[i]}", but got "${options[i]}"`);
            }
        }

        pageFixture.logger.info(
            `Dropdown "${dropdownLocatorName}" on "${pageName}" page has all expected options in order.`,
        );
    },
);

Then(
    "user should see {string} button {string} on {string} page",
    async function (elementName: string, stateName: string, pageName: string) {
        Common.isEqual(await Common.getAttribute(elementName, pageName, "disabled"), stateName);
    },
);

Then(
    "user should see {string} attribute on {string} on {string} page",
    async function (attributeName: string, elementName: string, pageName: string) {
        const attributeValue = await Common.getAttribute(elementName, pageName, attributeName);
        pageFixture.expect(attributeValue).not.toBeNull();
    },
);

When("user hovers over {string} on {string} page", async function (elementName: string, pageName: string) {
    await Common.hoverElement(elementName, pageName);
});
Then(
    "user should see {string} on all {string} on {string} page",
    async function (expectedText: string, elementSelector: string, pageName: string) {
        // Get all the elements that match the selector
        const elements = await Common.getElementLocators(elementSelector, pageName);
        pageFixture.logger.info(`Found ${await elements.count()} elements`);
        // Iterate through each element
        const elementCount = await elements.count();
        for (let i = 0; i < elementCount; i++) {
            const element = elements.nth(i);
            // Scroll the element into view if it's not already visible
            await element.scrollIntoViewIfNeeded();
            pageFixture.logger.info(`Scrolled element ${i + 1} into view`);
            const elementText = await element.textContent();
            pageFixture.logger.info(`Element ${i + 1} text: ${elementText?.trim()}`);
            Common.isEqual(elementText?.trim(), expectedText);
        }
        pageFixture.logger.info(
            `Successfully verified that '${expectedText}' is present in all '${elementSelector}' elements on ${pageName} page`,
        );
    },
);

When(
    "user increments value in {string} field on {string} page by 1",
    async function (elementName: string, pageName: string) {
        // Fetch the current value from the element
        const currentValueStr = await Common.getAttribute(elementName, pageName, "value");
        const currentValue = parseInt(currentValueStr, 10);
        if (isNaN(currentValue)) {
            throw new Error(`Current value "${currentValueStr}" in element "${elementName}" is not a number.`);
        }
        const newValue = currentValue + 1;
        // Update the value in the element
        await Common.setAttribute(elementName, pageName, "value", newValue.toString());
    },
);

Then(
    "user selects a particular entity {string} on {string} page",
    async function (entityName: string, pageName: string) {
        // Step 1: Click on the "SideBarMenu" button associated with the text "Entities"
        const sidebarButton = String(await sprintf(Common.getTheElement("SideBarMenu", "Home"), "Entities"));
        await pageFixture.page.click(sidebarButton);

        // Step 2: Verify the "Entities" page title
        await Common.containsText("PageTitle", "Entities", "DSPage");

        // Step 3: Enter the entity name in the "EntitySearchBox" field and press Enter
        await Common.typeText("EntitySearchBox", pageName, entityName);
        await Promise.all([
            pageFixture.page.waitForLoadState("networkidle"),
            pageFixture.page.keyboard.press("Enter"),
        ]);

        // Step 4: Click on the "EntityViewBtn" associated with the entity name
        const entityViewButton = String(await sprintf(Common.getTheElement("EntityViewBtn", pageName), entityName));
        await pageFixture.page.click(entityViewButton);
    }
);

Then(
    "user requests changes with comment {string} on {string} page",
    async function (comment: string, pageName: string) {
        // Step 1: Click on the "Request Changes" button
        const requestChangesButton = String(
            await sprintf(Common.getTheElement("CommonEntityBtn", pageName), "Request Changes"),
        );
        await pageFixture.page.click(requestChangesButton);

        // Step 2: Enter the comment in the "RequestChangesWorkFlowModalInputBox"
        await Common.typeText("RequestChangesWorkFlowModalInputBox", pageName, comment);

        // Step 3: Click the "RequestChangesWorkFlowModalSubmitButton"
        const submitButton = String(
            await sprintf(Common.getTheElement("RequestChangesWorkFlowModalSubmitButton", pageName), "Request Changes"),
        );
        await pageFixture.page.click(submitButton);
    }
);

Then(
    "user saves and submits changes with comment {string} on {string} page",
    async function (comment: string, pageName: string) {
        try {
            // Step 1: Click on the "Save and Submit" button
            const saveAndSubmitButton = String(
                await sprintf(Common.getTheElement("Save&SubmitBtn", "MyArea"), "Save and Submit"),
            );
            await pageFixture.page.click(saveAndSubmitButton);

            // Step 2: Enter the comment in the "WorkFlowModalInputBox"
            await Common.typeText("WorkFlowModalInputBox", pageName, comment);

            // Step 3: Click on the "Ok" button in the "WorkflowSubmitModal"
            const workflowSubmitModalOkButton = String(
                await sprintf(Common.getTheElement("OkBtnOnWorkflowSubmitModal", "MyArea"), "Submit"),
            );
            await pageFixture.page.click(workflowSubmitModalOkButton);

            // Step 4: Click on the "Ok" button in the "ConfirmSubmitModal"
            const confirmSubmitModalOkButton = String(
                await sprintf(Common.getTheElement("OkBtnOnConfirmSubmitModal", "MyArea"), "Confirm"),
            );
            await pageFixture.page.click(confirmSubmitModalOkButton);

            pageFixture.logger.info(`User saved and submitted changes with comment "${comment}" on "${pageName}" page`);
        } catch (error) {
            pageFixture.logger.error(`Error in save and submit action: ${(error as Error).message}`);
            throw new Error(`Error in save and submit action: ${(error as Error).message}`);
        }
    }
);

Then(
    "user approves submission with comment {string} on {string} page",
    async function (comment: string, pageName: string) {
        try {
            // Step 1: Click on the "Approve" button
            const approveButton = String(await sprintf(Common.getTheElement("CommonBTN", "Common"), "Approve"));
            await pageFixture.page.click(approveButton);

            // Step 2: Enter the "Approved" comment in the "ApproveWorkFlowModalInputBox"
            await Common.typeText("ApproveWorkFlowModalInputBox", pageName, comment);

            // Step 3: Click on the "Submit" button in the "ApproveWorkFlowModal"
            const approveSubmitButton = String(await sprintf(Common.getTheElement("ApproveWorkFlowModalSubmitButton", "Entities"), "Submit"));
            await pageFixture.page.click(approveSubmitButton);

            pageFixture.logger.info(`User approved submission with comment "${comment}" on "${pageName}" page`);
        } catch (error) {
            // Log the error message for debugging
            pageFixture.logger.error(`Error in approve submission action: ${error.message}`);
            throw new Error(`Error in approve submission action: ${error.message}`);
        }
    }
);

Then(
    "user submits changes with workflow comment {string} on {string} page",
    async function (comment: string, pageName: string) {
        try {
            // Step 1: Click on the "Submit Changes" button
            const submitChangesButton = String(await sprintf(Common.getTheElement("CommonBTN", "Common"), "Submit Changes"));
            await pageFixture.page.click(submitChangesButton);

            // Step 2: Verify the "Submit WorkFlow Modal" is visible on the page
            await Common.isVisible("SubmitWorkFlowModal", "Entities");
            await Common.containsText("SubmitWorkFlowModalTitle", "Submit Data Structure", "Entities");
            await Common.containsText("SubmitWorkFlowModalDescription", "Please enter a workflow comment and confirm submission", "Entities");

            // Step 3: Enter the "Submit" comment into the "SubmitWorkFlowModalInputBox"
            await Common.typeText("SubmitWorkFlowModalInputBox", pageName, comment);

            // Step 4: Click on the "Submit" button in the "SubmitWorkFlowModal"
            const submitButton = String(await sprintf(Common.getTheElement("SubmitWorkFlowModalSubmitButton", "Entities"), "Submit"));
            await pageFixture.page.click(submitButton);

            // Step 6: Click on the "Ok" button in the "Confirm Submit Modal"
            const confirmSubmitModalOkButton = String(await sprintf(Common.getTheElement("OkBtnOnConfirmSubmitModal", "MyArea"), "Confirm"));
            await pageFixture.page.click(confirmSubmitModalOkButton);

            pageFixture.logger.info(`User successfully submitted changes with comment "${comment}" on "${pageName}" page`);
        } catch (error) {
            // Log the error message for debugging
            pageFixture.logger.error(`Error in submit changes action: ${error.message}`);
            throw new Error(`Error in submit changes action: ${error.message}`);
        }
    }
);

Then(
    "user edits a business unit {string} on {string} page",
    async function (businessUnitName: string, pageName: string) {
        try {
            // Step 1: Click on the "BUTab" on the "Entities" page
            await Common.clickElement("BUTab", "Entities");

            // Step 2: Click on the "AddedBUViewBTN" for the specific business unit on the "EntityType" page
            const businessUnitButton = String(await sprintf(Common.getTheElement("AddedBUViewBTN", "EntityType"), businessUnitName));
            await pageFixture.page.click(businessUnitButton);

            // Step 3: Click on the "Edit" button on the "Common" page
            await Common.clickElement("EditBTN", "Common");

            pageFixture.logger.info(`User successfully edited business unit "${businessUnitName}" on "${pageName}" page`);
        } catch (error) {
            // Log the error message for debugging
            pageFixture.logger.error(`Error in edit business unit action: ${error.message}`);
            throw new Error(`Error in edit business unit action: ${error.message}`);
        }
    }
);

Then(
    "user clicks on {string} button with text {string}",
    async function (buttonName: string, text: string) {
        const buttonLocator = String(await sprintf(Common.getTheElement(buttonName, "Common"), text));
        await pageFixture.page.click(buttonLocator);
    }
);

Then(
    "user opens {string} from sidebar and navigates to {string} tab on {string} page",
    async function (sidebarText: string, tabName: string, pageName: string) {
        const sidebarSelector = await sprintf(
            Common.getTheElement("SideBarMenu", "Home"),
            sidebarText
        );
        await pageFixture.page.click(sidebarSelector);
        await pageFixture.page.waitForLoadState("load");
        await Common.clickElement(tabName, pageName);
        await pageFixture.page.waitForLoadState("load");
    }
);

When(
    'user edits business unit {string} and increments {string} on {string} page',
    async function (businessUnitName: string, elementName: string, pageName: string) {
        try {
            await Common.clickElement("BUTab", "Entities");
            await pageFixture.page.waitForLoadState("load");

            const businessUnitButton = String(
                await sprintf(Common.getTheElement("AddedBUViewBTN", "Entities"), businessUnitName),
            );
            await pageFixture.page.locator(`xpath=${businessUnitButton} >> visible=true`).first().click();
            await pageFixture.page.waitForLoadState("load");

            await Common.clickElement("EditBTN", "Common");

            const currentValueStr = await Common.getAttribute(elementName, pageName, "value");
            const currentValue = parseInt(currentValueStr, 10);

            if (isNaN(currentValue)) {
                throw new Error(
                    `Current value in "${elementName}" is not a number: "${currentValueStr}"`,
                );
            }

            const newValue = currentValue + 1;
            await Common.setAttribute(elementName, pageName, "value", newValue.toString());
        } catch (error: unknown) {
            throw error;
        }
    }
);

When(
    'user submits changes with comment {string}, selects {string}, on {string} page',
    async function (
        submitComment: string,
        pendingApprovalText: string,
        pageName: string
    ) {
        try {
            // Submit changes
            const submitChangesButton = await sprintf(
                Common.getTheElement("CommonBTN", "Common"),
                "Submit Changes"
            );
            await pageFixture.page.locator(submitChangesButton).click();

            await Common.isVisible("SubmitWorkFlowModal", "Entities");
            await Common.containsText(
                "SubmitWorkFlowModalTitle",
                "Submit Data Structure",
                "Entities"
            );
            await Common.containsText(
                "SubmitWorkFlowModalDescription",
                "Please enter a workflow comment and confirm submission",
                "Entities"
            );

            await Common.typeText("SubmitWorkFlowModalInputBox", pageName, submitComment);

            const submitButton = await sprintf(
                Common.getTheElement("SubmitWorkFlowModalSubmitButton", "Entities"),
                "Submit"
            );
            await pageFixture.page.locator(submitButton).click();

            const confirmOkButton = await sprintf(
                Common.getTheElement("OkBtnOnConfirmSubmitModal", "MyArea"),
                "Confirm"
            );
            await pageFixture.page.locator(confirmOkButton).click();

            // Click "Pending Approval"
            const pendingApprovalButton = await sprintf(
                Common.getTheElement("CommonBTN", "Common"),
                pendingApprovalText
            );
            await pageFixture.page.locator(pendingApprovalButton).click();

        } catch (error: any) {
            pageFixture.logger.error(
                `Error in 'user submits changes with comment..., selects...' step: ${error.message}`
            );
            throw error;
        }
    }
);

When("user selects and add Icon", async function () {
    await Common.clickElement("AddIconButton", "Common");
    await Common.clickElement("MedalIconButton", "Common");
    await pageFixture.page.waitForLoadState("load");
});

When(
    "user opens a new browser context, logs in as {string}, searches for entity {string} in Requires Review and performs {string} action",
    async function (username: string, entityName: string, action: string) {
        // Create a new browser context and page
        const context = await pageFixture.page.context().browser().newContext();
        getScenarioContext().page.additionalContexts.push(context);
        const newPage = await context.newPage();

        // Resolve and validate environment variables for login
        const baseUrl = process.env.BASEURL;
        const userEnvVar = username;
        const passwordEnvVar = `${username}Password`;
        const userEnvValue = process.env[userEnvVar];
        const passwordEnvValue = process.env[passwordEnvVar];

        if (!baseUrl) {
            throw new Error(
                `Missing required environment variable 'BASEURL' for login step. ` +
                `Ensure BASEURL is set in the environment before running this test.`
            );
        }

        if (userEnvValue === undefined) {
            throw new Error(
                `Missing required environment variable for username '${username}'. ` +
                `Expected environment variable: '${userEnvVar}'.`
            );
        }

        if (passwordEnvValue === undefined) {
            throw new Error(
                `Missing required environment variable for password of username '${username}'. ` +
                `Expected environment variable: '${passwordEnvVar}'.`
            );
        }

        // Login as the specified user
        await newPage.goto(baseUrl);
        await newPage.fill(Common.getTheElement("UserName", "Login"), userEnvValue);
        await newPage.click(Common.getTheElement("Submit", "Login"));
        await newPage.fill(
            Common.getTheElement("Password", "Login"),
            passwordEnvValue,
        );
        await newPage.click(Common.getTheElement("Submit", "Login"));
        await newPage.click(Common.getTheElement("StaySignedSInNoButton", "Login"));
        await newPage.waitForLoadState("load");
        const tenantButton = String(await sprintf(Common.getTheElement("TenantButton", "Home"), "TEST AUTOMATION TENANT - DO NOT TOUCH"));
        await newPage.click(tenantButton);
        // Navigate to "My Area" in the sidebar
        const myAreaSidebar = await sprintf(Common.getTheElement("SideBarMenu", "Home"), "My Area");
        await newPage.click(myAreaSidebar);
        // Click the "Requires Review" tab
        await newPage.click(Common.getTheElement("RequiresReviewTab", "MyArea"));
        // Search for the entity
        await newPage.fill(Common.getTheElement("RequiresReviewSearchBox", "MyArea"), entityName);
        await newPage.keyboard.press("Enter");
        // Click the view button for the entity
        const entityViewButton = await sprintf(Common.getTheElement("RequiresReviewEntityViewBtn", "MyArea"), entityName);
        await newPage.click(entityViewButton);

        // Wait for the approval header and workflow pane
        await newPage.isVisible(Common.getTheElement("DataStructureApprovalHeader", "MyArea"));
        await pageFixture.page.waitForTimeout(5000);
        await newPage.isVisible(Common.getTheElement("DataStructureApprovalHeader", "MyArea"));
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
                await newPage.fill(Common.getTheElement("RequestChangesWorkFlowModalInputBox", "Entities"), "Requesting changes");
                await newPage.click(Common.getTheElement("RequestChangesWorkFlowModalSubmitButton", "Entities"));
                await newPage.isVisible(Common.getTheElement("RequestChangesToastMessage", "Entities"));
                await pageFixture.page.waitForTimeout(4000);
                break;
            default:
                throw new Error(`Unknown action: ${action}`);
        }

        await newPage.close();
        await context.close();
        const additionalContexts = getScenarioContext().page.additionalContexts;
        const contextIndex = additionalContexts.indexOf(context);
        if (contextIndex >= 0) {
            additionalContexts.splice(contextIndex, 1);
        }
        await pageFixture.page.reload();
    }
);

When("user verifies the archive section is collapsed and expands it", async function () {
    const element = await Common.getElementLocator("ArchiveSectionBtn", "Common");
    const ariaExpanded = await element.getAttribute("aria-expanded");
    if (ariaExpanded !== "false") {
        throw new Error(
            `Expected archive section to be collapsed (aria-expanded="false"), but got aria-expanded="${ariaExpanded}"`,
        );
    }
    pageFixture.logger.info(`Archive section is collapsed (aria-expanded="false"), clicking to expand...`);
    await element.click();
    await pageFixture.page.waitForLoadState("load");
    pageFixture.logger.info(`Archive section expanded successfully.`);
});

When("user removes the existing Risk Groups in the Risk Model designer if present", async function () {
    const riskGroup = pageFixture.page.locator(Common.getTheElement("RiskGroupBtn", "RiskModels"));
    const confirmBtn = pageFixture.page.locator(Common.getTheElement("RiskGroupDeleteConfirmBTN", "RiskModels"));

    if ((await riskGroup.count()) === 0) {
        pageFixture.logger.info("No existing Risk Group found in the designer, continuing...");
        return;
    }

    while (await riskGroup.count() > 0) {
        const groupContainer = riskGroup.first().locator("xpath=ancestor::div[contains(@class,'dragContainer')][1]");
        const deleteBtn = groupContainer.locator("xpath=.//span[normalize-space()='Delete']").first();

        await deleteBtn.waitFor({ state: "visible" });
        await deleteBtn.click();

        await confirmBtn.first().waitFor({ state: "visible" });
        await confirmBtn.first().click();
        await riskGroup.first().waitFor({ state: "detached", timeout: 5000 }).catch(() => undefined);
    }

    pageFixture.logger.info("All existing Risk Groups were removed.");

    const remaining = await riskGroup.count();
    if (remaining > 0) {
        throw new Error(`Failed to remove all existing Risk Groups, ${remaining} still present in the designer.`);
    }
    pageFixture.logger.info("Existing Risk Groups removed from the designer.");
});

When(
    "user publishes the Risk Model after saving",
    async function () {
        // Modal locator built without waiting up front, it only exists after the click below
        const publishedModal = pageFixture.page.locator(
            Common.getTheElement("PublishedModal", "Common"),
        );

        const maxAttempts = 3;
        let lastError: unknown;
        for (let attempt = 1; attempt <= maxAttempts; attempt++) {
            try {
                // Re-fetch the button each attempt in case the designer re-renders it after saving
                const publishButton = await Common.getElementLocator("PublishBtn2", "RiskModels", 15000);
                await publishButton.scrollIntoViewIfNeeded();
                await pageFixture.expect(publishButton).toBeEnabled({ timeout: 15000 });
                await publishButton.click({ timeout: 10000 });
                await pageFixture.expect(publishedModal).toBeVisible({ timeout: 10000 });
                pageFixture.logger.info(`Publish button clicked successfully on attempt ${attempt}.`);
                return;
            } catch (error) {
                lastError = error;
                pageFixture.logger.info(
                    `Attempt ${attempt} to click Publish button and open the Publish modal failed: ${(error as Error).message}`,
                );
            }
        }
        throw new Error(
            `Failed to click Publish button and open the Publish modal after ${maxAttempts} attempts. Last error: ${(lastError as Error)?.message}`,
        );
    },
);

Then(
    "user should see the following permission headers and descriptions on {string} page",
    async function (pageName: string, dataTable) {
        const rows: Array<{ name: string; description: string }> = dataTable.hashes() as Array<{
            name: string;
            description: string;
        }>;
        for (const row of rows) {
            try {
                await Common.verifyPermissionHeaderAndDescription(row.name, row.description, pageName);
            } catch (error) {
                const enhancedError = new Error(
                    `Validation failed for permission header "${row.name}" with description "${row.description}" on page "${pageName}": ${error instanceof Error ? error.message : String(error)}`,
                );
                await this.attach(
                    JSON.stringify(
                        {
                            row,
                            error: error instanceof Error ? error.message : String(error),
                        },
                        null,
                        2,
                    ),
                    "application/json",
                );
                throw enhancedError;
            }
        }
    },
);

When("user clicks on the expand button of {string} Prospect on Refit page", async function (prospectName: string) {
    const element: string = String(
        await sprintf(Common.getTheElement("ExpandButton", "Refit"), prospectName),
    );
    await Common.clickByElementText(element);
});

Then(
    "user should see {string} textfield {string} on {string} page",
    async function (elementName: string, stateName: string, pageName: string) {
        Common.isEqual(await Common.getAttribute(elementName, pageName, "disabled"), stateName);
    },
);

Then(
    "user should see {string} textfield enabled on {string} page",
    async function (elementName: string, pageName: string) {
        const element = await Common.getElementLocators(elementName, pageName);

        await Common.isEnabled(element, elementName);
    },
);

Then(
    "user should able to see {string} on {string} on {string} page",
    async function (text: string, elementName: string, page: string) {

        const expectedValues = text.split(",").map(v => v.trim()).filter(Boolean);

        const actualValues = (await Common.getAllTexts(elementName, page)).map(v => v.trim()).filter(Boolean);

        for (const expected of expectedValues) {
            if (!actualValues.includes(expected)) {
                throw new Error(
                    `Expected to find "${expected}" in "${elementName}" on "${page}" page. Actual: [${actualValues.join(", ")}]`,
                );
            }
        }

    }
);

When(
    "user clicks on Onboarding Stage Tab with text {string} on Onboarding page",
    async function (text: string) {
        if (process.env.TabularizationFlag === "true") {
            await Common.tabClick(text);
        }
    }
);
When(
    "user opens new tab",
    async function () {
        getScenarioContext().stepData.firstTab = pageFixture.page;
        const ctx = pageFixture.page.context();
        pageFixture.page = await ctx.newPage();
        await pageFixture.page.bringToFront();
    }
);

When(
    "user switches back to first tab",
    async function () {
        const firstTab = getScenarioContext().stepData.firstTab;
        if (!firstTab) {
            throw new Error("First tab is not set. Call \"user opens new tab\" before switching back.");
        }
        await firstTab.bringToFront();
        pageFixture.page = firstTab;

        await pageFixture.page.reload();
    }
);

Then(
    "user should see the following breadcrumb items on {string} page:",
    async function (pageName: string, dataTable: { raw: () => string[][] }) {
        const expectedItems: string[] = dataTable
            .raw()
            .flat()
            .map((item) => item.trim())
            .filter(Boolean);
        await Common.verifyBreadcrumbTrail(expectedItems, pageName);
    },
);

Then(
    "the following table column values in {string} table on {string} page should be:",
    async function (
        tableKey: string,
        pageName: string,
        dataTable: { hashes: () => Array<{ fieldName: string; value: string }> },
    ) {
        await Common.verifyTableColumnValues(pageName, tableKey, dataTable.hashes());
    },
);

// Asserts view-mode fields have no editable inputs (display-only on review Data tab).
Then(
    "the view field {string} on {string} page should be read only",
    async function (elementName: string, pageName: string) {
        await Common.verifyViewFieldIsReadOnly(elementName, pageName);
    },
);

When(
    "user clears {string} input field on {string} page",
    async function (selector: string, pageName: string) {
        await Common.clearInput(selector, pageName);
    },
);

When(
    "user enter text in {string} field on {string} page",
    async function (this: CustomWorld, fieldName: string, pageName: string) {
        const text = Common.createAndStoreText();
        await Common.typeText(fieldName, pageName, text);
        this.attach(`Stored Automation reason = "${text}"`, "text/plain");
    },
);

When(
    "user enter {string} text in the following fields on {string} page:",
    async function (text: string, pageName: string, dataTable: { hashes: () => Array<{ field: string }> }) {
        for (const { field } of dataTable.hashes()) {
            await Common.typeText(field, pageName, text);
        }
    },
);

When(
    "user selects first option from dropdown {string} on {string} page",
    async function (dropdownName: string, pageName: string) {
        await Common.selectFirstDropdownOption(dropdownName, pageName);
    },
);

Then(/^the value should (not )?match "([^"]*)" on "([^"]*)" on "([^"]*)" page$/, async (not, label, key, page) =>
    Common.verifyStoredValueAgainstSavedField(label, key, page, !not),
);

When(
    "user deletes all reviews with confirm date {string} on {string} page",
    async (confirmDate: string, pageName: string) => {
        await Common.deleteAllPeriodicReviews(confirmDate, pageName);
    },
);

When("user switch to the newly opened {string} page", async function (pageTitle: string) {
    await Common.switchToAnotherTabByTitle(pageTitle);
});

/**
 * Checks a checkbox by its visible label text (e.g. risk level "Medium" on KYC Model wizard).
 * Uses CheckboxByLabel locator from appSetting.json for the given page.
 */
When(
    "user checks checkbox associate with label {string} on {string} page",
    async function (labelText: string, pageName: string) {
        await Common.checkCheckboxByLabel(labelText, pageName);
    },
);

When(
    "user store text of {string} as {string} from {string} page",
    async function (elementName: string, keyName: string, pageName: string) {
        const value = await Common.getText(elementName, pageName);
        APICommon.storeValueForKey(value.trim(), keyName);
    },
);

/** Asserts the element is absent or not visible (e.g. Entity Type label hidden in KYC rule edit mode). */
Then("user should not able see {string} on {string} page", async function (elementName: string, page: string) {
    const selector = Common.getTheElement(elementName, page);
    const locator = pageFixture.page.locator(selector);
    const count = await locator.count();
    if (count === 0) return;
    if (await locator.first().isVisible()) {
        throw new Error(`Element "${elementName}" should not be visible on "${page}" page, but it is.`);
    }
});

/**
 * Asserts a select dropdown does not list any of the given forbidden options.
 * Used in KYC rule cards to verify operators like "Is Empty" are excluded for incompatible field types.
 */
Then(
    "the dropdown {string} on {string} page should not have the following options:",
    async function (dropdownLocatorName: string, pageName: string, dataTable) {
        const locatorString = Common.getTheElement(dropdownLocatorName, pageName);
        const dropdown = pageFixture.page.locator(locatorString);
        await dropdown.waitFor({ state: "visible", timeout: 5000 });

        const options = (await dropdown.locator("option").allTextContents()).map((v) => v.trim());
        interface DataTable {
            raw(): string[][];
        }

        const forbiddenOptions: string[] = (dataTable as DataTable)
            .raw()
            .flat()
            .map((v: string) => v.trim())
            .filter((v) => v.length > 0);

        for (const option of forbiddenOptions) {
            if (options.includes(option)) {
                throw new Error(
                    `Dropdown "${dropdownLocatorName}" on "${pageName}" page should not include "${option}". Actual options: [${options.join(", ")}]`,
                );
            }
        }

        pageFixture.logger.info(
            `Dropdown "${dropdownLocatorName}" on "${pageName}" page does not include forbidden options: [${forbiddenOptions.join(", ")}].`,
        );
    },
);

/**
 * Asserts no select element exists inside the container (operator shown as text only, not a dropdown).
 * Used when KYC rule condition operator cell has no dropdown until a field is chosen.
 */
Then(
    "the select dropdown should not be present in {string} on {string} page",
    async function (elementName: string, pageName: string) {
        const containerSelector = Common.getTheElement(elementName, pageName);
        const container = pageFixture.page.locator(containerSelector);
        await container.waitFor({ state: "visible", timeout: 5000 });

        const selectCount = await container.locator("select").count();
        if (selectCount > 0) {
            throw new Error(`Select dropdown should not be present in "${elementName}" on "${pageName}" page.`);
        }

        pageFixture.logger.info(`Select dropdown is not present in "${elementName}" on "${pageName}" page as expected.`);
    },
);

When('user navigate back', async function () {
    await Common.clickElement("GoBackLink", "Component");
});

When('user waits until submission process is completed', async function () {
    await Common.waitUntilTextIsVisible("ThankYouMessage", "Refit", "Thank you for your submission");
});

When("user enters date:{string} in {string} field on Refit page", async function (date: string, element: string) {

    await Common.fillDateInput(element, "Refit", date);
    await Common.clickElement("PropertyGropuName1", "Refit");
},
);

Then(
    "user should see {string} text in {string} field by value on {string} page",
    async function (text: string, fieldName: string, page: string) {
        await Common.isValueEqual(fieldName, page, text);
    },
);

Then(
    "user should see {int} characters on {string} textfield on {string} page",
    async function (countToken: number, elementName: string, pageName: string) {
        const locator = await Common.getElementLocator(elementName, pageName);
        const actualCount = (await locator.innerText()).length;
        if (actualCount !== countToken) {
            throw new Error(
                `Expected ${countToken} characters in "${elementName}" on "${pageName}" page, but found ${actualCount}.`,
            );
        }
    },
);

When('user select option in following dropdowns on {string} page', async function (pageName: string, dataTable) {
    const rows = dataTable.rows() as string[][];
    for (const [option, dropdown] of rows) {
        await Common.selectDropdown(dropdown, pageName, option);
    }
});
