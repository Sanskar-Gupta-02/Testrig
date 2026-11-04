import { When } from "@cucumber/cucumber";
import { APICommon } from "../../../Helper/utilities/api.utils";
import { Common } from "../../../Helper/utilities/ui.utils";
import { pageFixture } from "../../../hooks/pagefixtures";
import { ScenarioContext } from "../../../Helper/utilities/ScenarioContext";

When("user navigate to {string} List Group", async function (listGroupName: string) {
    await Common.navigateTo("EndPoint", "ListGroups");
    await Common.clickWithText("ListGroup", listGroupName, "ListGroups");
});

When("user store List Data Ids", async function () {
    const listDataIds = (await Common.getAllTexts("ListDataID", "ListGroups"))
        .map((value: string) => value.trim())
        .filter((value: string) => value.length > 0);

    ScenarioContext.set<string[]>("listDataIds", listDataIds);
    pageFixture.logger.info(`Stored List Data IDs: ${listDataIds.join(", ")}`);
});

When("user delete onboarding with stored key value {string}", async function (storedKey: string) {
    if (!storedKey) {
        throw new Error("Stored key name is required for onboarding deletion.");
    }

    APICommon.setAPIServie("/api/v1/client/onboarding/delete");

    const parameters = await APICommon.getFileSelectedPayload("onboarding", "BusinessUnitID,ActionUserID,ReturnFormat");
    APICommon.setJSONQueryParams(parameters);

    APICommon.setQueryParamsWithStoredKey("ClientProspectID", "prospectID");
    APICommon.setQueryParamsWithStoredKey("ClientOnboardingID", storedKey);

    await APICommon.sendRequest("Delete");
    await APICommon.checkResponseStatusCode(200);
    pageFixture.logger.info(`Deleted onboarding using stored key: ${storedKey}`);
});

When("user delete List Data of {string} List Group with stored IDs", async function (listGroupId: string) {
    const listDataIds = ScenarioContext.get<string[]>("listDataIds");
    if (!listDataIds || listDataIds.length === 0) {
        throw new Error("No list data IDs were found in scenario context.");
    }

    const parameters = await APICommon.getFileSelectedPayload("listData", "ReturnFormat,ActionUserID");
    APICommon.setJSONQueryParams(parameters);
    APICommon.setQueryParams("ListGroupID", listGroupId);

    const deleteWaitTimeSeconds = 180;

    for (const listDataId of listDataIds) {
        if (!listDataId) continue;

        APICommon.setAPIServie("/api/v1/static/listdata/delete");
        APICommon.setQueryParams("ListDataID", listDataId);
        await APICommon.sendRequest("Delete");

        await Common.waitForSeconds(deleteWaitTimeSeconds);

        try {
            await APICommon.checkResponseStatusCode(200);
            pageFixture.logger.info(`Deleted list data ID ${listDataId} for list group ${listGroupId}`);
        } catch (error) {
            const errorMessage = error instanceof Error ? error.message : String(error);
            throw new Error(
                `Timed out waiting for delete response for list data ID ${listDataId} for list group ${listGroupId} after ${deleteWaitTimeSeconds} seconds. ${errorMessage}`,
            );
        }
    }
});

When(
    "user delete List Data of {string} List Group with stored IDs on pkyc Client",
    async function (listGroupID: string) {
        const listDataIds = ScenarioContext.get<string[]>("listDataIds");
        if (!listDataIds || listDataIds.length === 0) {
            throw new Error("No list data IDs were found in scenario context.");
        }

        const parameters = await APICommon.getFileSelectedPayload("pkyclistData", "ReturnFormat,ActionUserID");
        APICommon.setJSONQueryParams(parameters);
        APICommon.setQueryParamsWithStoredKey("ListGroupID", listGroupID);

        const deleteWaitTimeSeconds = 180;

        for (const listDataId of listDataIds) {
            if (!listDataId) continue;

            APICommon.setAPIServie("/api/v1/static/listdata/delete");
            APICommon.setQueryParams("ListDataID", listDataId);
            await APICommon.sendRequest("Delete");

            await Common.waitForSeconds(deleteWaitTimeSeconds);

            try {
                await APICommon.checkResponseStatusCode(200);
                pageFixture.logger.info(`Deleted list data ID ${listDataId} for list group ${listGroupID}`);
            } catch (error) {
                const errorMessage = error instanceof Error ? error.message : String(error);
                throw new Error(
                    `Timed out waiting for delete response for list data ID ${listDataId} for list group ${listGroupID} after ${deleteWaitTimeSeconds} seconds. ${errorMessage}`,
                );
            }
        }
    },
);
