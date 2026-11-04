import { Given, When, Then } from "@cucumber/cucumber";
import { Common } from "../../../Helper/utilities/ui.utils";
import { pageFixture } from "../../../hooks/pagefixtures";

Given("user navigates to clm", async function () {
    await pageFixture.page.goto(process.env.BASEURL);
});

Given("user enter the username:{string}", async function (username) {
    await Common.typeText("UserName", "Login", username);
    await Common.clickElement("Submit", "Login");
});

Given("user enter the password:{string}", async function (password) {
    await Common.typeText("Password", "Login", password);
    await Common.clickElement("Submit", "Login");
});

When("user clicks on login page", async function () {
    await Common.clickElement("Submit", "Login");
});

Then("user should see the home page", async function () {
    pageFixture.expect(await Common.isVisible("UserProfile", "Home")).toBeTruthy();
});
