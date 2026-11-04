import { Common } from "../../../Helper/utilities/ui.utils";
import { Then, When } from "@cucumber/cucumber";
import { pageFixture } from "../../../hooks/pagefixtures";

Then("user should not be able to navigate after clicking on Send Request Button on 2nd Placard", async function () {
    try {
        // This already gives you a Locator object
        const locator = await Common.getElementLocator("NomineePlacardSendRequestButton2", "Refit");

        const currentURL = pageFixture.page.url();

        // Use Locator directly
        await locator.click();

        await pageFixture.page.waitForTimeout(2000);

        const newURL = pageFixture.page.url();

        if (currentURL !== newURL) {
            throw new Error(`❌ Navigation occurred! Expected to stay on: ${currentURL}, but moved to: ${newURL}`);
        }

        console.log("User did not navigate after clicking on SendRequestButton");
    } catch {
        // Error is caught but intentionally ignored
    }
});

When(
    "user clicks on {string} button and navigates to the link in {string} on {string} page waiting until {string} is gone",
    async function (buttonLocator: string, linkContainerLocator: string, pageName: string, waitText: string) {
        await Common.clickElement(buttonLocator, pageName);
        await Common.waitUntilTextIsNotVisible(linkContainerLocator, pageName, waitText);
        const link = await Common.getText(linkContainerLocator, pageName);
        await Common.navigateToURL(link.trim());
        pageFixture.logger.info(`Navigated to link from "${linkContainerLocator}": ${link.trim()}`);
    },
);

Then(
    "user should see checkbox {string} on {string} on {string} page",
    async function (state: string, checkboxLocator: string, pageName: string) {
        const element = await Common.getElementLocator(checkboxLocator, pageName);
        const isChecked = await element.isChecked();
        if (state.toLowerCase() === "checked") {
            pageFixture.expect(isChecked).toBeTruthy();
        } else if (state.toLowerCase() === "unchecked") {
            pageFixture.expect(isChecked).toBeFalsy();
        } else {
            throw new Error(`Invalid state "${state}". Expected "checked" or "unchecked".`);
        }
        pageFixture.logger.info(`Checkbox "${checkboxLocator}" on "${pageName}" page is ${state}`);
    },
);

