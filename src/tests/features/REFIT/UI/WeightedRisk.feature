@Regression @WeightedRisk
Feature: Weighted Risk

  Background:
    Given user login into 'REFIT' application with 'HandlerUserName' user
    And user is authorized using an "APIKEY"

  @WeightedRisk01 @deleteOnboarding
  Scenario: 020 Weighted risk Override Behaviour Type is underride only by external DCF #ENG-T12326
    When user store value:'616218' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+WeightedRiskAutomationS20@riskscreen.com" email
    When user enter "30" text in "Group1TextField" field on "Refit" page
    And user enter "140.01" text in "Group1TextField2" field on "Refit" page
    And user select "India" option in "Group1Property3" dropdown on "Refit" page
    And user enters today date in "Group1DateField" field on "Refit" page
    And user enters date:"2025-11-11" in "Group1DateField" field on Refit page
    And user enter "22" text in "Group1TextField5" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on "ContinueButton" on "Refit" page
    And user clicks on "FormSubmissionCheckbox" on "Refit" page
    And user clicks on "FormSubmitButton" on "Refit" page
    And user waits until submission process is completed
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'WeightedRiskAutomationS20',selects SearchOn:'Last name' and select prospect from list
    And user clicks on "DataApprovalLink" on "ManageProspect" page
    And user clicks on Onboarding Stage Tab with text "Notes" on Onboarding page
    And user select "Weighted Risk Score" option in "RiskModelType" dropdown on "Onboarding" page
    And user clicks on "SaveRiskModelButton" on "Onboarding" page
    And user clicks on Onboarding Stage Tab with text "Risk Assessment" on Onboarding page
    Then user should see the following values in Risk assessment table:
      | Field                             | Value                           |
      | AutomatedWeightedRiskScore        | Low (Override - Underride Only) |
      | Grp1Pro1WeightedOutput            |                              18 |
      | Grp1Pro2PropertyRiskOverride      | YES                             |
      | Grp1Pro2PropertyRiskOverrideValue | High                            |
      | Grp1Pro2WeightedOutput            |                              56 |
      | Grp1Pro3WeightedOutput            |                              20 |
      | Grp1Pro4PropertyRiskOverride      | YES  (Underride Only)           |
      | Grp1Pro4PropertyRiskOverrideValue | Low                             |
      | Grp1Pro4WeightedOutput            |                              28 |
      | Grp1Pro5WeightedOutput            |                              30 |
      | TotalRiskScore                    |                             152 |
      | TotalPossibleRiskScore            |                             410 |
      | NormalisedRiskScoreD              |                             37% |
      | NormalisedRiskScoreBandD          | Standard                        |

  @WeightedRisk02
  Scenario: 006 User should be able to see same Weighted Risk with Copied OBType and should be able to get correct calculations from External DCF. #ENG-T10631,T10536
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on "CopyButton" button associate with text "WeightedRiskAutomationS6" on "Onboarding"
    Then user should see "WeightedRiskAutomationS6-Copy" text in "CopyOnboardingTypeName" field by value on "Onboarding" page
    And user should see "Do Not Touch-Copy" text in "CopyOnboardingTypeDescription" field by value on "Onboarding" page
    When user clicks on "ConfirmCopyButton" on "Onboarding" page
    And user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'WeightedRiskAutomationS6-Copy' OB type on 'OnboardingType' page
    Then user should see 'Calculated Maximum' option selected on 'TotalPossibleRiskScore' on 'OnboardingType' page
    And user adds a prospect with Last Name:"WeightedRiskAutomationS6ExternalDCF", Email:"testautomations+WeightedRiskAutomationS6@riskscreen.com", Onboarding Type:"WeightedRiskAutomationS6-Copy", Status:"Active", Handled by User Group:"Handler Group", Handled by User:"Refit Automation (testaut...", Allow Manage Prospect:"Yes"
    And user creates an onboarding with note "Automation note" and enter data collection stage
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user creates a data request
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'Send' on 'Prospect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+WeightedRiskAutomationS6@riskscreen.com"
    And user selects data in following fields in Refit DCF:
      | Field           | Value    |
      | Group1Property1 | India    |
      | Group1Property2 | Malaysia |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on 'ContinueButton' on 'Refit' page
    And user clicks on 'FormSubmissionCheckbox' on 'Refit' page
    And user clicks on 'SubmitButtons' on 'Refit' page
    And user waits until submission process is completed
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user selects "12" Business Unit
    And user enter SearchName:'WeightedRiskAutomationS6ExternalDCF',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataApprovalLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Risk Assessment' on Onboarding page
    Then user should see the following values in Risk assessment table:
      | Field                      | Value |
      | AutomatedWeightedRiskScore | High  |
      | Grp1Pro1WeightedOutput     |    50 |
      | Grp1Pro2WeightedOutput     |    20 |
      | TotalRiskScoreSHV          |    70 |
      | TotalPossibleRiskScoreSHV  |   120 |
      | NormalisedRiskScoreD       |   58% |
      | NormalisedRiskScoreBandD   | High  |
    And user clicks on 'ViewOnboardingReportButton' on 'Prospect' page
    Then user should see the following values in Risk assessment table:
      | Field                      | Value |
      | AutomatedWeightedRiskScore | High  |
      | Grp1Pro1WeightedOutput     |    50 |
      | Grp1Pro2WeightedOutput     |    20 |
      | TotalRiskScoreSHV          |    70 |
      | TotalPossibleRiskScoreSHV  |   120 |
      | NormalisedRiskScoreD       |   58% |
      | NormalisedRiskScoreBandD   | High  |
    And user clicks on 'Back' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Approval' on Onboarding page
    And user clicks on 'RejectOnboardingButton' on 'ManageProspect' page
    And user clicks on 'Back' on 'ManageProspect' page
    And user delete onboarding and prospect
    And user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on "DeleteButton" button associate with text "WeightedRiskAutomationS6-Copy" on "OnboardingType"
    And user clicks on "ConfirmDeleteButton" on "OnboardingType" page

  @WeightedRisk03
  Scenario: 013 User validate calculations when external DCF submission and Auto creations- 'Create Prospect from External Form' are triggered simultaneously with tabularization enabled.#ENG-T11044,T11038,T11039
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user selects "12" Business Unit
    And user enter SearchName:'WeightedRiskAutomationS13',selects SearchOn:'Last name' and select prospect from list
    And user creates an onboarding with note "Automation note" and enter data collection stage
    And user should not see any prospect created
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user creates a data request
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'Send' on 'Prospect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+WeightedRiskAutomationS13@riskscreen.com"
    And user enter "AutoProspect" text in "Group1TextField" field on "Refit" page
    And user selects data in following fields in Refit DCF:
      | Field           | Value     |
      | Group1Property2 | Yes - Yes |
    And user enter "15" text in "Group1TextField3" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on 'ContinueButton' on 'Refit' page
    And user clicks on 'FormSubmissionCheckbox' on 'Refit' page
    And user clicks on 'SubmitButtons' on 'Refit' page
    And user waits until submission process is completed
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user selects "12" Business Unit
    And user enter SearchName:'WeightedRiskAutomationS13',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataApprovalLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Risk Assessment' on Onboarding page
    Then user should see the following values in Risk assessment table:
      | Field                      | Value              |
      | AutomatedWeightedRiskScore | Low                |
      | FirstPropertyName          | Property 2         |
      | Property1RS                |                 10 |
      | Grp1Pro1WeightedOutput     |                 10 |
      | SecondPropertyName         | Property 3         |
      | Property2RS                | 20  underride to 5 |
      | Grp1Pro2WeightedOutput     |                  5 |
      | TotalRiskScoreD            |                 15 |
      | TotalPossibleRiskScoreD    |                200 |
      | NormalisedRiskScoreD       |                 7% |
    When user open Autocreated prospect with name "AutoProspect"
    And user delete prospect
    And user enter SearchName:'WeightedRiskAutomationS13',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataApprovalLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Approval' on Onboarding page
    And user clicks on 'RejectOnboardingButton' on 'ManageProspect' page
    And user clicks on 'Back' on 'ManageProspect' page
    And user delete onboarding
