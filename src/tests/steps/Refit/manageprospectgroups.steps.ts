import { When } from "@cucumber/cucumber";
import { Common } from "../../../Helper/utilities/ui.utils";
import { sprintf } from "sprintf-js";

When(
    "user enters SearchName:{string}, selects SearchOn:{string} and selects the prospect group from the list",
    async function (prospectGroupName: string, searchOn: string) {
        await Common.typeText("SearchName", "ManageProspectGroup", prospectGroupName);
        await Common.selectDropdown("SearchOn", "ManageProspectGroup", searchOn);
        await Common.clickElement("SearchProspectGroupsButton", "ManageProspectGroup");
        await Common.clickElement("FirstProspectGroup", "ManageProspectGroup");
    },
);

When("user deletes prospect relationship of the {string} prospect", async function (prospectName: string) {
    const element: string = sprintf(
        Common.getTheElement("ProspectNameInHierarchy", "ManageProspectGroup"),
        prospectName,
    );
    await Common.doubleClickElement(element);
    await Common.clickElement("DeleteProspectRelationship", "ManageProspectGroup");
    await Common.clickElement("ConfirmDeleteButton", "ManageProspectGroup");
    await Common.containsText("BannerSuccessMessage", "Prospect relationship deleted successfully.", "Component");
});

When('user clicks edit button of {string} prospect on refit page', async function (prospectName: string) {
    const selector = String(sprintf(Common.getTheElement("EditProspect", "Refit"), prospectName));
    return Common.clickByElementText(selector);
})
