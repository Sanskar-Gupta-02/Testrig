import { When, Then } from "@cucumber/cucumber";
import { Common } from "../../../Helper/utilities/ui.utils";
import { sprintf } from "sprintf-js";
import { pageFixture } from "../../../hooks/pagefixtures";
import { Enums } from "../../../Helper/utilities/enums";

Then('user should see {string} selected in following font dropdowns:', async function (option: string, dataTable) {
    const rows = dataTable.rows() as string[][];
    for (const [dropdown] of rows) {
        await Common.isSelectedByLocator(String(sprintf(Common.getTheElement("FontDropdown", "WebBranding"), dropdown)), option);
    }
});

When('user clicks on edit button of {string} Web Branding', async function (webBranding: string) {
    webBranding = Common.resolveUniqueName(webBranding);
    await Common.clickByElementText(String(sprintf(Common.getTheElement("WebBrandingEditButton", "WebBranding"), webBranding)))
});;

When('user deletes {string} Web Branding', async function (webBranding: string) {
    webBranding = Common.resolveUniqueName(webBranding);
    await Common.clickByElementText(String(sprintf(Common.getTheElement("DeleteWebBranding", "WebBranding"), webBranding)));
    await Common.clickElement("ConfirmDeleteButton", "WebBranding");
    await Common.containsText("BannerSuccessMessage", "Web Branding deleted successfully.", "Component");
});

When('user enters {string} color on {string} field on {string} page', async function (colorName: string, field: string, pageName: string) {
    await Common.setAttributeByLocator(String(sprintf(Common.getTheElement("ColorInputField", pageName), field)), "value", Enums.getColorHEXCode(colorName));
});

When('user enters colors on following fields on {string} page', async function (pageName: string, dataTable) {
    const rows = dataTable.rows() as string[][];
    for (const [color, field] of rows) {
        await Common.setAttributeByLocator(String(sprintf(Common.getTheElement("ColorInputField", pageName), field)), "value", Enums.getColorHEXCode(color));
    }
});
