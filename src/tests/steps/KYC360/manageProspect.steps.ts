import { Common } from "../../../Helper/utilities/ui.utils";
import { When } from "@cucumber/cucumber";
import { pageFixture } from "../../../hooks/pagefixtures";

When("user get the data link and open in new tab", async function () {
    const element = Common.getElementLocator("DataLink", "ManageProspect");
    const elementText = (await element).textContent();
    await Common.clickElement("Cancel", "ManageProspect");
    await Common.clickElement("LogOutButton", "ManageProspect");
    await pageFixture.page.goto((await elementText).toString());
});
