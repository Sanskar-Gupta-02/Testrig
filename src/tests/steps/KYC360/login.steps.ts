import { Given, When } from "@cucumber/cucumber";
import { Common } from "../../../Helper/utilities/ui.utils";
import { pageFixture } from "../../../hooks/pagefixtures";
import { FrameworkConstant } from "../../../env/frameworkConstant";

Given("user login to kyc360 with {string} user", async function (username: string) {
    await pageFixture.page.goto(process.env.BASEURL);
    await Common.typeText("UserName", "Login", process.env[username]);
    await Common.typeText("Password", "Login", process.env[`${username + "Password"}`]);
    await Common.clickElement("LoginButton", "Login");
});

Given("user login back to kyc360 after dcf submission with {string} user", async function (username: string) {
    await pageFixture.page.goto(process.env.BASEURL);
    await Common.waitForSeconds(FrameworkConstant.waitTime());
    await pageFixture.page.goto(process.env.BASEURL);
    await Common.typeText("UserName", "Login", process.env[username]);
    await Common.typeText("Password", "Login", process.env[`${username + "Password"}`]);
    await Common.clickElement("LoginButton", "Login");
});

When(
    "user navigates to the {string} page with the page title {string}",
    async function (pageName: string, title: string) {
        await Common.navigateTo("EndPoint", pageName);
        await Common.containsText("pageTitle", title, pageName);
    },
);

When(
    "user navigates to Prospect: {string} with Search On: {string}",
    async function (SearchName: string, SearchOn: string) {
        await Common.navigateTo("EndPoint", "ManageProspect");
        await Common.containsText("pageTitle", "Manage Prospects", "ManageProspect");
        await Common.typeText("SearchName", "ManageProspect", SearchName);
        await Common.selectDropdown("SearchOn", "ManageProspect", SearchOn);
        await Common.clickElement("SearchProspects", "ManageProspect");
        await Common.clickElement("EditProspect", "ManageProspect");
    },
);

When(
    "user navigates to Prospect: {string} with Search On: {string} and click on {string}",
    async function (SearchName: string, SearchOn: string, Onboardingstage: string) {
        await Common.navigateTo("EndPoint", "ManageProspect");
        await Common.containsText("pageTitle", "Manage Prospects", "ManageProspect");
        await Common.typeText("SearchName", "ManageProspect", SearchName);
        await Common.selectDropdown("SearchOn", "ManageProspect", SearchOn);
        await Common.clickElement("SearchProspects", "ManageProspect");
        await Common.clickElement("EditProspect", "ManageProspect");
        await Common.clickElement(Onboardingstage, "ManageProspect");
        await pageFixture.page.waitForLoadState("load");
    },
);