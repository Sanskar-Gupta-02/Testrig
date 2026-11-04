import { When, Then } from "@cucumber/cucumber";
import { Common } from "../../../Helper/utilities/ui.utils";
import { Enums } from "../../../Helper/utilities/enums";
import { pageFixture } from "../../../hooks/pagefixtures";
import { emailService } from "../../../hooks/uihooks";
import { sprintf } from "sprintf-js";
import { APICommon } from "../../../Helper/utilities/api.utils";
import { ScenarioContext } from "../../../Helper/utilities/ScenarioContext";
import { getOutlookEmailService } from "../../../Helper/utilities/emailServiceFactory";

When(
    "user adds a prospect with Last Name:{string}, Email:{string}, Onboarding Type:{string}, Status:{string}, Handled by User Group:{string}, Handled by User:{string}, Allow Manage Prospect:{string}",
    async function (
        lastName: string,
        email: string,
        onboardingType: string,
        status: string,
        handledByUserGroup: string,
        handledByUser: string,
        allowManageProspect: string,
    ) {
        await Common.addProspectWithDetails(
            lastName,
            email,
            onboardingType,
            status,
            handledByUserGroup,
            handledByUser,
            allowManageProspect,
        );
    },
);

When(
    "user enter SearchName:{string},selects SearchOn:{string} and select prospect from list",
    async function (SearchName: string, SearchOn: string) {
        await Common.typeText("SearchName", "ManageProspect", SearchName);
        await Common.selectDropdown("SearchOn", "ManageProspect", SearchOn);
        await Common.clickElement("SearchProspects", "ManageProspect");
        await Common.clickElement("EditProspect", "ManageProspect");
    },
);

When("user get the data link and open", async function () {
    const link: string = await Common.getText("DataLink", "ManageProspect");
    await Common.navigateToURL(link);
});

When(
    "user send data collection link to nominee with email: {string} and open data collection link in new tab",
    async function (email: string) {
        await Common.clickByElementText(
            String(sprintf(Common.getTheElement("SendEmailToNomineeButton", "Onboarding"), email)),
        );
        await Common.selectDropdown("SendLinkTo", "Onboarding", "Nominee: " + email);
        await Common.clickElement("SendDataRequestEmail", "Onboarding");
        const link = await emailService.getLink("noreply@riskscreen.com", email);
        await Common.navigateToURL(link);
        await Common.clickElement("SendVerificationCodeButton", "Refit");
        const otp = await emailService.getOtp("noreply@riskscreen.com", email);
        await Common.typeText("VerificationCode", "Onboarding", otp);
        await Common.clickElement("EnterButton", "Refit");
        await Common.clickElement("StartButton", "Refit");
    },
);

When("user enter data in following fields in Refit DCF:", async function (dataTable) {
    const rows = dataTable.rows() as string[][];
    const today = new Date().toISOString().slice(0, 10);
    for (const [field, value] of rows) {
        const finalValue = value.includes("<Date>") ? value.replace(/<Date>/g, today) : value;
        await Common.waitForSeconds(2);
        await Common.typeText(field, "Refit", finalValue);
        await Common.clickElement("KYCLogo", "Refit");
        await Common.waitForSeconds(2);
    }
});

When(
    "user create a nominee with email {string} with message {string}",
    async function (email: string, message: string) {
        if (process.env.TabularizationFlag === "true") {
            await Common.tabClick("Data Collection Requests");
        }
        await Common.clickElement("Nominees", "ManageProspect");
        await Common.clickElement("CreateANominee", "ManageProspect");
        await Common.typeText("NomineeEmailField", "ManageProspect", email);
        await Common.typeText("MessageBox", "ManageProspect", message);
        await Common.clickElement("CreateDataRequestNominee", "ManageProspect");
        await Common.containsText("BannerSuccessMessage", "Nominee added successfully.", "Component");
    },
);

When("user checks Property Group or Data Document Type permission checkboxes", async function (dataTable) {
    const values = (dataTable.raw() as string[][]).flat();
    for (const value of values) {
        const selector: string = String(
            await sprintf(Common.getTheElement("PGDDTPermissionCheckbox", "Onboarding"), value),
        );
        const element = pageFixture.page.locator(selector);
        await element.click();
    }
    await Common.clickElement("UpdateNomineePermission", "Onboarding");
});

When("user open Autocreated prospect with name {string}", async function (prospectName: string) {
    if (process.env.TabularizationFlag === "true") {
        await Common.tabClick("Auto Prospect Status");
    }
    await Common.clickByElementText(
        String(await sprintf(Common.getTheElement("AutocreatedProspect", "Onboarding"), prospectName)),
    );
});

Then("user should see Autocreated prospect with name {string}", async function (prospectName: string) {
    if (process.env.TabularizationFlag === "true") {
        await Common.tabClick("Auto Prospect Status");
    }
    await Common.isVisibleByText(
        String(await sprintf(Common.getTheElement("AutocreatedProspectName", "Onboarding"), prospectName)),
    );
});

Then("user should see prospect details as", async function (dataTable) {
    const rows = dataTable.rows() as string[][];
    for (const [field, value] of rows) {
        await Common.containsTextByLocator(
            String(await sprintf(Common.getTheElement("ProspectDetails", "Prospect"), field)),
            value,
        );
    }
});

When("user update the following details and save", async function (dataTable) {
    const rows = dataTable.rows() as string[][];
    for (const [field, value] of rows) {
        await Common.typeTextByLocator(
            String(await sprintf(Common.getTheElement("EditProspectFields", "Prospect"), field)),
            value,
        );
    }
    await Common.clickElement("UpdateButton", "Prospect");
    await Common.containsText("BannerSuccessMessage", "Prospect has been updated.", "Component");
});

When("user delete onboarding and prospect", async function () {
    await Common.clickElement("DeleteOnboarding", "Prospect");
    await Common.clickElement("ConfirmDeleteButton", "Prospect");
    await Common.containsText("BannerSuccessMessage", "Onboarding deleted successfully.", "Component");
    await Common.clickElement("DeleteProspect", "Prospect");
    await Common.clickElement("ConfirmDeleteButton", "Prospect");
    await Common.containsText("BannerSuccessMessage", "Prospect has been deleted.", "Component");
});

When(
    "user navigates to URL with the stored key value {string} and enter OTP received on {string} email",
    async function (storedKey: string, email: string) {
        const url = APICommon.getStoredData(storedKey);
        await Common.navigateToURL(url);
        await Common.clickElement("SendVerificationCodeButton", "Refit");
        const otp = await emailService.getOtp("noreply@riskscreen.com", email);
        await Common.typeText("VerificationCode", "Onboarding", otp);
        await Common.clickElement("EnterButton", "Refit");
        await Common.clickElement("StartButton", "Refit");
    },
);

When("user delete prospect", async function () {
    await Common.clickElement("DeleteProspect", "Prospect");
    await Common.clickElement("ConfirmDeleteButton", "Prospect");
    await Common.containsText("BannerSuccessMessage", "Prospect has been deleted.", "Component");
});

When("user enter data in following fields in internal form:", async function (dataTable) {
    if (process.env.TabularizationFlag === "true") {
        await Common.tabClick("Onboarding Data");
    }
    const rows = dataTable.rows() as string[][];
    for (const [field, value] of rows) {
        await Common.typeText(field, "Onboarding", value);
    }
});

Then("user should not see Autocreated prospect with name {string}", async function (prospectName: string) {
    if (process.env.TabularizationFlag === "true") {
        await Common.tabClick("Auto Prospect Status");
    }
    await Common.assertNotVisibleByText(
        String(sprintf(Common.getTheElement("AutocreatedProspectName", "Onboarding"), prospectName)),
    );
});

Then("user should see the Risk score:{string}", async function (risk: string) {
    if (process.env.TabularizationFlag === "true") {
        await Common.tabClick("Screening");
    }
    await Common.containsText("RiskScore", risk, "Onboarding");
});

Then("user should see success banner with message {string}", async function (message: string) {
    await Common.containsText("BannerSuccessMessage", message, "Component");
});

When(
    "user store {string} with keyName:{string} from {string} page",
    async function (elementName: string, keyName: string, pageName: string) {
        const value = await Common.getText(elementName, pageName);
        const match = value.match(/\d+/);
        if (match) {
            APICommon.storeValueForKey(match[0].trim(), keyName);
        } else {
            throw new Error(`No numeric value found in the text: ${value}`);
        }
    },
);

When("user wait until autocreation process is complete", { timeout: 360000 }, async function () {
    await Common.waitUntilElementIsEnabled("SaveButton", "Refit");
});

When("user clicks on {string} stage", async function (Onboardingstage: string) {
    await Common.clickElement(Onboardingstage, "ManageProspect");
    await pageFixture.page.waitForLoadState("load");
});

Then("user should see Data Collection request", async function () {
    if (process.env.TabularizationFlag === "true") {
        await Common.tabClick("Data Collection Requests");
    }
    await Common.isVisible("DataRequestTable", "Onboarding");
});

Then("user should see the following values in the internal DCF form:", async function (dataTable) {
    if (process.env.TabularizationFlag === "true") {
        await Common.tabClick("Onboarding Data");
    }
    const rows = dataTable.rows() as string[][];
    for (const [field, value] of rows) {
        await Common.isValueEqual(field, "Onboarding", value);
    }
});

Then("user should see the following values in the Refit form:", async function (dataTable) {
    const rows = dataTable.rows() as string[][];
    for (const [field, value] of rows) {
        await Common.isValueEqual(field, "Refit", value);
    }
});

When("user selects data in following fields in Refit DCF:", async function (dataTable) {
    const rows = dataTable.rows() as string[][];
    for (const [field, value] of rows) {
        await Common.selectDropdown(field, "Refit", value);
        await Common.waitForSeconds(2);
    }
});

Then("user should see the following values in the Refit Prospect form:", async function (dataTable) {
    const rows = dataTable.rows() as string[][];
    for (const [field, value] of rows) {
        await Common.containsTextByLocator(
            String(sprintf(Common.getTheElement("ProspectFieldValue", "Refit"), field)),
            value,
        );
    }
});

When(
    "user wait until {string} process on {string} page is complete",
    async function (elementName: string, pageName: string) {
        await Common.waitUntilElementIsVisible(elementName, pageName);
    },
);

When(
    "user search Name : {string}, SearchOn : {string}, MatchType : {string} and ProspectStatus : {string} on {string} page",
    async function (SearchName: string, SearchOn: string, MatchType: string, ProspectStatus: string, pageName: string) {
        await Common.typeText("SearchInput", pageName, SearchName);
        await Common.selectDropdown("SearchOn", pageName, SearchOn);
        await Common.selectDropdown("MatchType", pageName, MatchType);
        await Common.selectDropdown("ProspectStatus", pageName, ProspectStatus);
        await Common.clickElement("SearchButton", pageName);
    },
);

When(
    "user selects Relationship : {string} and Parent Prospect : {string} on Refit page",
    async function (relationship: string, parentProspect: string) {
        await Common.selectDropdown("ProspectRelationship", "Refit", relationship);
        await Common.selectDropdown("ParentProspect", "Refit", parentProspect);
    },
);

Then("user clicks add button of {string} Prospect on Refit page", async function (prospectName: string) {
    const selector = String(sprintf(Common.getTheElement("AddProspectToGroupButton", "Refit"), prospectName));
    await Common.clickByElementText(selector);
});

Then(
    "user should see the following values in the Refit Prospect form before adding to group:",
    async function (dataTable) {
        const rows = dataTable.rows() as string[][];
        for (const [field, value] of rows) {
            await Common.containsTextByLocator(
                String(sprintf(Common.getTheElement("ProspectDetails", "Refit"), field)),
                value,
            );
        }
    },
);

When("user clicks on edit button of {string} nominee on Refit page", (email: string) => {
    const selector = String(sprintf(Common.getTheElement("EditNomineeButton", "Refit"), email));
    return Common.clickByElementText(selector);
});

When("user clicks on send request button of {string} nominee on Refit page", (email: string) => {
    const selector = String(sprintf(Common.getTheElement("SendRequestButton", "Refit"), email));
    return Common.clickByElementText(selector);
});
When("user Link the prospect with following options:", async function (dataTable) {
    const rows = dataTable.rows() as string[][];
    for (const [option, value] of rows) {
        await Common.selectDropdown(option, "Onboarding", value);
    }
    await Common.clickElement("AddProspectToGroup", "Onboarding");
    await Common.containsText(
        "BannerSuccessMessage",
        "Matched prospect linked and prospect relationship added successfully.",
        "Component",
    );
});

When("user navigate to {string} section on refit DCF", async function (sectionName: string) {
    const formattedSectionName = sectionName.toLowerCase().replace(/\s+/g, "_");
    await Common.clickByElementText(
        String(sprintf(Common.getTheElement("SideMenuSection", "Refit"), formattedSectionName)),
    );
    await Common.waitUntilTextIsVisible("SectionHeader", "Refit", sectionName);
});

Then("user should not see {string} section on refit DCF", async function (sectionName: string) {
    const formattedSectionName = sectionName.toLowerCase().replace(/\s+/g, "_");
    await Common.assertNotVisibleByText(
        String(sprintf(Common.getTheElement("SideMenuSection", "Refit"), formattedSectionName)),
    );
});

When("user waits until the saving process is completed", async function () {
    await Common.waitUntilElementIsEnabled("SaveButton", "Refit");
});

Then("user should see following Property Groups:", async function (dataTable) {
    const propertyGroups = dataTable.hashes() as Array<{
        "Property Groups": string;
    }>;
    for (const row of propertyGroups) {
        await Common.isVisibleByText(
            String(sprintf(Common.getTheElement("PropertyGroupNames", "Refit"), row["Property Groups"])),
        );
    }
});

Then("user should not see following Property Groups:", async function (dataTable) {
    const propertyGroups = dataTable.hashes() as Array<{
        "Property Groups": string;
    }>;

    for (const row of propertyGroups) {
        await Common.isNotVisible("PropertyGroupNames", "Refit", row["Property Groups"]);
    }
});

When(
    "user selects checkboxes {string} on share form using send button {string} and stores link as {string} on 'Refit' page",
    async function (checkboxesCSV: string, sendButtonName: string, storageKey: string) {
        const checkboxes = checkboxesCSV.split(",").map(cb => cb.trim());
        for (const checkbox of checkboxes) {
            await Common.clickElement(checkbox, "Refit");
        }
        await Common.typeText("EmailMessageBox", "Refit", "Hello Automation");
        await Common.clickElement("SaveChanges", "Refit");
        await Common.clickElement(sendButtonName, "Refit");
        await Common.clickElement("NomineeCopyFormLinkButton", "Refit");
        await Common.waitUntilTextIsNotVisible("NomineeCopyFormLink", "Refit", "Loading");
        const linkValue = await Common.getText("NomineeCopyFormLink", "Refit");
        APICommon.storeValueForKey(linkValue.trim(), storageKey);
    },
);

When("user enter OTP received on {string}", { timeout: 120000 }, async function (email: string) {
    await Common.clickElement("SendVerificationCodeButton", "Refit");
    const otp = await emailService.getOtp("noreply@riskscreen.com", email);
    await Common.typeText("VerificationCode", "Onboarding", otp);
    await Common.clickElement("EnterButton", "Refit");
    await Common.clickElement("StartButton", "Refit");
});

When("user shares form with email {string} and saves nominee on 'Refit' page", async function (email: string) {
    await Common.clickElement("ShareThisFormButton", "Refit");
    await Common.clickElement("AddPeopleButton", "Refit");
    await Common.typeText("EmailTextField", "Refit", email);
    await Common.clickElement("NewNomineeSaveButton", "Refit");
});

When("user search and open prospect with name:{string}", async function (prospectName: string) {
    await Common.navigateTo("EndPoint", "ManageProspect");
    await Common.typeText("SearchName", "ManageProspect", prospectName);
    await Common.selectDropdown("SearchOn", "ManageProspect", "Last name");
    await Common.clickElement("SearchProspects", "ManageProspect");
    await Common.clickElement("EditProspect", "ManageProspect");
});

When(
    "user create a nominee with Nominee Email: {string}, Email Template: {string}, Allow Manage Nominee: {string}, Allow Manage Prospect: {string}, Notify Prospect:{string}",
    async function (
        nomineeEmail: string,
        emailTemplate: string,
        allowManageNominee: string,
        allowManageProspect: string,
        notifyProspect: string,
    ) {
        await Common.clickElement("CreateANominee", "ManageProspect");
        await Common.typeText("NomineeEmailField", "ManageProspect", nomineeEmail);
        await Common.selectDropdown("NomineeEmailTemplates", "ManageProspect", emailTemplate);
        await Common.selectDropdown("AllowManageNominee", "ManageProspect", allowManageNominee);
        await Common.selectDropdown("AllowManageProspect", "ManageProspect", allowManageProspect);
        await Common.selectDropdown("NotifyProspect", "ManageProspect", notifyProspect);
        await Common.waitUntilTextIsNotVisible("MessageBox", "AutocreationSetting", "Loading");
        await Common.clickElement("CreateDataRequestNominee", "ManageProspect");
        await Common.containsText("BannerSuccessMessage", "Nominee added successfully.", "Component");
    },
);

When("user send data collection link to nominee with email: {string}", async function (email: string) {
    await Common.clickByElementText(
        String(sprintf(Common.getTheElement("SendEmailToNomineeButton", "Onboarding"), email)),
    );
    await Common.selectDropdown("SendLinkTo", "Onboarding", "Nominee: " + email);
    await Common.clickElement("SendDataRequestEmail", "Onboarding");
});

Then(
    "user should receive an email from: {string} and to: {string} with subject: {string} and body containing text: {string}",
    async function (sender: string, recipient: string, subject: string, body: string) {
        const subjectInMail = await emailService.getEmailSubjectWithoutDeletingTheMail(sender, recipient);
        const emailBody = await emailService.verifyEmailBody(sender, recipient);
        ScenarioContext.set("emailBody", emailBody);
        await Common.contains(subjectInMail, subject);
        await Common.contains(emailBody, body);
    },
);

Then("user should not receive email on {string} email", async function (email: string) {
    for (let attempt = 0; attempt < 10; attempt++) {
        const messageIds = await emailService.getAllMessageIdForMailContent(email);
        if (messageIds.length > 0) {
            throw new Error(`Email received unexpectedly for ${email}`);
        }
        await new Promise(resolve => setTimeout(resolve, 1000));
    }
});

When("user open the data collection link in new tab", async function () {
    const emailBody = ScenarioContext.get<string>("emailBody");
    if (!emailBody) {
        throw new Error("Email body not found.");
    }
    const urlRegex = /(https?:\/\/[^\s"<>]+)/g;
    const match = emailBody.match(urlRegex);
    if (!match) {
        throw new Error("No URL found in email body.");
    }
    const link = match[0];
    pageFixture.logger.info(`Link: ${link}`);
    const newPage = await pageFixture.page.context().newPage();
    await newPage.goto(link);
    // If you want to use this new tab later:
    pageFixture.page = newPage;
    ScenarioContext.clear();
});

When("user delete nominee with email: {string}", async function (nomineeEmail: string) {
    await Common.clickByElementText(
        String(sprintf(Common.getTheElement("DeleteNomineeWithEmail", "ManageProspect"), nomineeEmail)),
    );
    await Common.clickElement("ConfirmDelete", "ManageProspect");
    await Common.containsText("BannerSuccessMessage", "Nominee deleted successfully.", "Component");
});

When(
    "user navigates to URL in new tab with the stored key value {string} and enter OTP received on {string} email",
    async function (storedKey: string, email: string) {
        const url = APICommon.getStoredData(storedKey);
        const newPage = await pageFixture.page.context().newPage();
        await newPage.goto(url);
        // If you want to use this new tab later:
        pageFixture.page = newPage;
        await Common.clickElement("SendVerificationCodeButton", "Refit");
        const otp = await emailService.getOtp("noreply@riskscreen.com", email);
        await Common.typeText("VerificationCode", "Onboarding", otp);
        await Common.clickElement("EnterButton", "Refit");
        await Common.clickElement("StartButton", "Refit");
    },
);

Then(
    "user should receive an email on outlook from: {string} and to: {string} with subject: {string} and body containing text: {string}",
    async function (fromEmail: string, toEmail: string, subject: string, body: string) {
        const svc = getOutlookEmailService();
        const subjectInMail = await svc.getEmailSubjectWithoutDeletingTheMail(fromEmail, toEmail);
        const emailBody = await svc.verifyEmailBody(fromEmail, toEmail);
        await Common.contains(subjectInMail, subject);
        await Common.contains(emailBody, body);
    },
);

When("user send data collection link to {string} with email: {string}", async function (user: string, email: string) {
    if (process.env.TabularizationFlag === "true") {
        await Common.tabClick("Data Collection Requests");
    }
    await Common.clickElement("SendLink", "ManageProspect");
    await Common.selectDropdown("SendLinkTo", "Onboarding", user + ": " + email);
    await Common.clickElement("SendDataRequestEmail", "Onboarding");
    await Common.containsText("BannerSuccessMessage", "Onboarding data request sent successfully.", "Component");
});

Then("user should see the following values in Risk assessment table:", async function (dataTable) {
    const rows = dataTable.rows() as string[][];
    for (const [field, value] of rows) {
        await Common.isTextEqual(field, value, "Onboarding");
    }
});

Then('user should see {string} prospect below {string} prospect', async function (childProspect: string, parentProspect: string) {
    pageFixture.expect(
        await Common.isVisibleByText(
            sprintf(Common.getTheElement("StructureHierarchy", "Refit"), childProspect, parentProspect),
        ),
    ).toBeTruthy();
});

Then('user should not see {string} prospect below {string} prospect', async function (childProspect: string, parentProspect: string) {
    await Common.assertNotVisibleByText(sprintf(Common.getTheElement("StructureHierarchy", "Refit"), childProspect, parentProspect));
});

When("user creates an onboarding with note {string} and enter data collection stage", async function (note: string) {
    await Common.clickElement("CreateOnboardingLink", "ManageProspect");
    await Common.typeText("OnboardingNotes", "Prospect", note);
    await Common.clickElement("CreateOnboardingButton", "Prospect");
    await Common.clickElement("DataCollectionLink", "Prospect");
    await pageFixture.page.waitForLoadState("load");
});

When("user creates a data request", async function () {
    if (process.env.TabularizationFlag === "true") {
        await Common.tabClick("Data Collection Requests");
    }
    await Common.waitForSeconds(5);
    await Common.clickElement("CreateDataRequestLink", "ManageProspect");
    await Common.typeText("textCreateDataRequest", "CreateDataRequest", "Automation Test");
    await Common.clickElement("CreateDataRequestButton", "CreateDataRequest");
});

When("user should not see any prospect created", async function () {
    if (process.env.TabularizationFlag === "true") {
        await Common.tabClick("Auto Prospect Status");
    }
    await Common.elementIsVisible("AutoCreationStatusTable", "Onboarding", "false");
});

When("user delete onboarding", async function () {
    await Common.clickElement("DeleteOnboarding", "Prospect");
    await Common.clickElement("ConfirmDeleteButton", "Prospect");
    await Common.containsText("BannerSuccessMessage", "Onboarding deleted successfully.", "Component");
});

When("user creates Prospect:", async function (dataTable) {
    await Common.navigateTo("EndPoint", "Prospect");
    for (const { field, value, text } of dataTable.hashes()) {
        if (text == "DropDown") {
            await Common.selectDropdown(field, "Prospect", value);
        }
        else if (text == "TextBox") {
            await Common.typeText(field, "Prospect", value);
        }
    }
    await Common.scrollIntoView("CreateProspect", "Onboarding");
    await Common.clickElement("CreateProspect", "Onboarding");
    await Common.containsText("BannerSuccessMessage", "Prospect has been added.", "Component");
});

When("user generates data collection link and open", async function () {
    const buttonLocator = String(sprintf(Common.getTheElement("Send", "Prospect")));
    const button = pageFixture.page.locator(buttonLocator).first();
    await button.waitFor({ state: "visible" });
    await Common.clickElement("Send", "Prospect");
    await pageFixture.page.waitForLoadState("load");
    const buttonLocator2 = String(sprintf(Common.getTheElement("GenerateDataCollectionLink", "ManageProspect")));
    const button2 = pageFixture.page.locator(buttonLocator2).first();
    await button2.waitFor({ state: "visible" });
    await Common.clickElement("GenerateDataCollectionLink", "ManageProspect");
    await pageFixture.page.waitForLoadState("load");
    const link: string = await Common.getText("DataLink", "ManageProspect");
    await Common.navigateToURL(link);
});

Then("user should see progress bar percentage: {string}", async function (percentage: string) {
    await Common.containsText("FormProgressPercentage", percentage, "Refit");
});

Then("user should see PropertyGroup Name:{string}", async function (groupName: string) {
    await Common.isTextEqual("PropertyGroupName", groupName, "Refit");
});

Then("user should see property group name one :{string} and property group name two :{string}", async function (groupNameOne: string, groupNameTwo: string) {
    await Common.isValueEqual("PropertyGroupNameOne", "Prospect", groupNameOne);
    await Common.isValueEqual("PropertyGroupNameTwo", "Prospect", groupNameTwo);
});

When("user clears field on :{string} on {string} page", async function (fieldName: string, pageName: string) {
    await Common.clearInput(fieldName, pageName);
});

Then("user should see progress bar percentage: {string}", async function (percentage: string) {
    await Common.containsText("FormProgressPercentage", percentage, "Refit");
});

Then("user should see PropertyGroup Name:{string}", async function (groupName: string) {
    await Common.isTextEqual("PropertyGroupName", groupName, "Refit");
});

Then("user should see property group name one :{string} and property group name two :{string}", async function (groupNameOne: string, groupNameTwo: string) {
    await Common.isValueEqual("PropertyGroupNameOne", "Prospect", groupNameOne);
    await Common.isValueEqual("PropertyGroupNameTwo", "Prospect", groupNameTwo);
});

When("user clears field on :{string} on {string} page", async function (fieldName: string, pageName: string) {
    await Common.clearInput(fieldName, pageName);
});

Then('user should see {string} button for {string} prospect', async function (buttonName: string, prospectName: string) {
    pageFixture.expect(
        await Common.isVisibleByText(
            sprintf(Common.getTheElement(buttonName, "Refit"), prospectName),
        ),
    ).toBeTruthy();
});

When('user clicks on {string} button for {string} prospect', async function (buttonName: string, prospectName: string) {
    await Common.clickByElementText(
        String(sprintf(Common.getTheElement(buttonName, "Refit"), prospectName)),
    );
    await pageFixture.page.waitForLoadState("load");
});

When("user deletes a data request", async function () {
    if (process.env.TabularizationFlag === "true") {
        await Common.tabClick("Data Collection Requests");
    }
    await Common.clickElement("DeleteDataRequestButton", "ManageProspect");
    await Common.clickElement("ConfirmationDelete", "ManageProspect");
});
Then(
    "user should not see {string} button for {string} prospect",
    async function (buttonName: string, prospectName: string) {
        await Common.assertNotVisibleByText(
            String(sprintf(Common.getTheElement(buttonName, "Refit"), prospectName)),
        );
    },
);

Then(
    "user should be scrolled back to the {string} field on {string} page",
    async function (fieldName: string, pageName: string) {
        const element = await Common.getElementLocator(fieldName, pageName);
        await pageFixture.expect(element).toBeVisible({ timeout: 30000 });
        await pageFixture.expect(element).toBeInViewport({ timeout: 30000 });
    },
);
Then('user should see following properties mandatory:', async function (dataTable) {
    const rows = dataTable.rows() as string[][];
    for (const [property] of rows) {
        await Common.isVisibleByText(String(sprintf(Common.getTheElement("MandatoryField", "Refit"), property)));
    }
});

When('user clicks {string} enter OTP received on {string} email', async function (button: string, email: string) {
    await Common.clickElement(button, "Refit");
    const otp = await emailService.getOtp("noreply@riskscreen.com", email);
    await Common.typeText("VerificationCode", "Onboarding", otp);
    await Common.clickElement("EnterButton", "Refit");
});

Then('user should see the following CSS values in the elements:', async function (dataTable) {
    const rows = dataTable.hashes() as Array<{
        field: string;
        cssValue: string;
        expectedValue: string;
        page: string;
    }>;

    for (const row of rows) {
        try {
            const actualCSSValue = await Common.getCSSValueOfElement(row.field, row.page, row.cssValue);

            // For font-related properties, check if expected value is contained in actual value
            const cssValueLower = row.cssValue.toLowerCase();
            if (cssValueLower === "font" || cssValueLower === "font size" || cssValueLower === "italic" || cssValueLower === "bold") {
                if (!actualCSSValue.toLowerCase().includes(row.expectedValue.toLowerCase())) {
                    throw new Error(
                        `CSS value "${row.cssValue}" does not contain "${row.expectedValue}". Actual value: "${actualCSSValue}"`,
                    );
                }
                pageFixture.logger.info(
                    `✓ Field "${row.field}" CSS value "${row.cssValue}" contains "${row.expectedValue}"`,
                );
            } else {
                // For color and other properties, convert and compare
                const expectedCSSValue = Enums.getColorRGBA(row.expectedValue);
                if (actualCSSValue !== expectedCSSValue) {
                    throw new Error(
                        `CSS value "${row.cssValue}" mismatch. Expected: "${expectedCSSValue}", Actual: "${actualCSSValue}"`,
                    );
                }
                pageFixture.logger.info(`✓ Field "${row.field}" CSS value "${row.cssValue}" matches "${row.expectedValue}"`);
            }
        } catch (error) {
            const enhancedError = new Error(
                `CSS value validation failed for field "${row.field}" on page "${row.page}": ${error instanceof Error ? error.message : String(error)
                }`,
            );
            this.attach(JSON.stringify(row, null, 2), "application/json");
            throw enhancedError;
        }
    }
});

When('user click on View Onboarding button of {string} prospect', async function (prospectName: string) {
    await Common.clickByElementText(
        String(sprintf(Common.getTheElement("ViewOnboarding", "Refit"), prospectName)),
    );
})
