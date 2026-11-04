import { When, Then } from "@cucumber/cucumber";
import { Common } from "../../../Helper/utilities/ui.utils";
import { sprintf } from "sprintf-js";
import { emailService } from "../../../hooks/uihooks";
import { pageFixture } from "../../../hooks/pagefixtures";

Then(
    "user should see {string} on {string} on {string} page",
    async function (welcomeMessage: string, elementName: string, pageName: string) {
        await pageFixture.page.waitForLoadState("networkidle")
        await pageFixture.page.waitForLoadState("load");
        await Common.containsText(elementName, welcomeMessage, pageName);
    },
);

Then("user should not see {string} on {string} page", async function (elementName: string, pageName: string) {
    await Common.isHidden(elementName, pageName);
});

When("user navigate to Onboarding type {string}", async function (onboardingTypeName: string) {
    await Common.navigateTo("EndPoint", "OnboardingType");
    await Common.clickByElementText(
        String(sprintf(Common.getTheElement("OnboardingTypeName", "OnboardingType"), onboardingTypeName)),
    );
});

Then("user should wait until email template gets updated in message box", async function () {
    await Common.waitUntilTextIsNotVisible("MessageBox", "AutocreationSetting", "Loading");
});

Then(
    "user should receive email from:{string} and to:{string} and body should contains {string}",
    async function (fromEmailId: string, toEmailId: string, messageBody: string) {
        const msgBody = await emailService.verifyEmailBody(fromEmailId, toEmailId);
        await Common.contains(msgBody, messageBody);
    },
);

When("user delete Prospect Autocreation Status for prospect {string}", async function (prospectName: string) {
    if (process.env.TabularizationFlag === "true") {
        await Common.tabClick("Auto Prospect Status");
    }
    await Common.clickByElementText(
        String(sprintf(Common.getTheElement("AutocreationStatusDelete", "Onboarding"), prospectName)),
    );
    await Common.clickElement("ConfirmDelete", "Onboarding");
    await Common.containsText("BannerSuccessMessage", "Onboarding Auto Prospect deleted successfully.", "Component");
});

Then("user should see {string} options to be checked for Email Alerts Configuration", async function (options: string) {
    const optionStrings = options
        .split(",")
        .map(option => option.trim())
        .filter(Boolean);

    for (const optionName of optionStrings) {
        const isChecked = await Common.isRadioButtonChecked(optionName, "OnboardingType");
        pageFixture.expect(isChecked).toBeTruthy();
    }
});
When('user update and publish onboarding type', async function () {
    await Common.clickElement("UpdateOBTypeButton", "OnboardingType");
    await pageFixture.page.waitForLoadState("load");
    await Common.containsText("BannerSuccessMessage", "Onboarding type updated successfully.", "Component");
    await Common.clickElement("PublishChangesButton", "OnboardingType");
    await pageFixture.page.waitForLoadState("load");
    await Common.containsText("BannerSuccessMessage", "Changes have been successfully updated", "Component");
})
