@DataCollection @Regression
Feature: Data Collection

  Background:
    Given user login to kyc360 with 'HandlerUserName' user
    And user is authorized using an 'APIKEY'

  @DataCollection1 @deleteOnboarding
  Scenario: 001 Verify that the primary prospect of DCF should be able to EDIT all the information filled by other prospect in the same DCF before the form is submitted by the prospect himself #ENG-T372,T3703,T6027,T9833,T9835
    When user creates an onboarding for prospect "616206" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616206" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+EditNomineeDetails@riskscreen.com" email
    And user shares form with email "testautomations+EditNomineeDetailsN1@riskscreen.com" and saves nominee on 'Refit' page
    And user clicks on "ShareWholeFormButton" on "Refit" page
    And user selects checkboxes "AllowManageNomineesCheckbox" on share form using send button "NomineePlacardSendRequestButton" and stores link as "NomineeDCFLink" on 'Refit' page
    And user navigates to URL with the stored key value "NomineeDCFLink" and enter OTP received on "testautomations+EditNomineeDetailsN1@riskscreen.com" email
    And user enter "NomineeName" text in "Property1" field on "Refit" page
    And user enter "22" text in "Property2" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user clicks on 'FormSubmissionCheckbox' on 'Refit' page
    And user clicks on 'SubmitButtons' on 'Refit' page
    And user waits until submission process is completed
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+EditNomineeDetails@riskscreen.com" email
    Then user should see "NomineeName" value in "Property1" field on "Refit" page
    Then user should see "22" value in "Property2" field on "Refit" page

  @DataCollection2 @deleteOnboarding
  Scenario: 002 Onboarding document which are hidden externally should not be displayed to the prospect / nominee in external form #ENG-T518
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'DocumentHiddenExternally' OB type on 'OnboardingType' page
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'ManageDocumentType' on 'OnboardingType' page
    Then user should see "Document Hidden Externally" on "DocTypeName1" on "OnboardingType" page
    And user should see "Yes" on "Doc1HiddenExternalStatus" on "OnboardingType" page
    When user creates an onboarding for prospect "616690" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616690" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+DocumentHiddenExternally@riskscreen.com" email
    Then user should not see "SidemenuDocument" on "Refit" page
    And user shares form with email "testautomations+EditNomineeDetailsN1@riskscreen.com" and saves nominee on 'Refit' page
    And user clicks on "ShareWholeFormButton" on "Refit" page
    And user selects checkboxes "AllowManageNomineesCheckbox" on share form using send button "NomineePlacardSendRequestButton" and stores link as "NomineeDCFLink" on 'Refit' page
    And user navigates to URL with the stored key value "NomineeDCFLink" and enter OTP received on "testautomations+EditNomineeDetailsN1@riskscreen.com" email
    Then user should not see "SidemenuDocument" on "Refit" page

  @DataCollection3 @deleteOnboarding
  Scenario: 003 Verify that the mandatory text field should not be skipped using a single space while submitting data collection form. #ENG-T3478
    When user creates an onboarding for prospect "616690" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616690" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+DocumentHiddenExternally@riskscreen.com" email
    And user enter " " text in "Property1" field on "Refit" page
    And user enter "qwerty" text in "Property2" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user clicks on 'SummaryTab' on 'Refit' page
    Then user should see 'There are changes required in 1 of the sections. Please update these sections before submitting.' on 'TitleErrorBox' on 'Refit' page
    And user should able see "SummaryErrorBox" on "Refit" page
    And user should see 'Please make the necessary changes before submitting.' on 'ErrorBoxBeforeSubmit' on 'Refit' page

  @DataCollection4 @deleteOnboarding
  Scenario: 004 RiskScore - Hidden risk enabled field should not be display in the external data collection form but should be accessible by HBU in the Internal RS Onboard in DA stage #ENG-T5247
    When user creates an onboarding for prospect "616709" with risk model type "1" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616709" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+HiddenRiskProspect@riskscreen.com" email
    Then user should not be able to see "Integer" text in "FormContainer" field on "Refit" page
    And user enter "qwerty" text in "Property1" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user clicks on 'FormSubmissionCheckbox' on 'Refit' page
    And user clicks on 'SubmitButtons' on 'Refit' page
    And user waits until submission process is completed
    When user navigates to "Onboarding" page with URL: "/onboarding/edit/<onboardingID>?prospectid=<prospectID>&__BusinessUnit=<BUSINESSUNIT>" with the page title 'Onboarding'
    And user clicks on Onboarding Stage Tab with text "Risk Assessment" on Onboarding page
    Then user should see the following values in Risk assessment table:
      | Field                    | Value   |
      | FirstPropertyName        | Integer |
      | Grp1Pro1WeightedOutput   |      25 |
      | TotalRiskScoreD          |      50 |
      | TotalPossibleRiskScoreD  |     200 |
      | NormalisedRiskScoreD     |     25% |
      | NormalisedRiskScoreBandD | Low     |
    And user should see "25" text in "Property1RS" field on "Onboarding" page
    And user should see "default risk score" text in "Property1RiskScoreAttribute" field on "Onboarding" page
    And user clicks on Onboarding Stage Tab with text "Data Approval" on Onboarding page
    And user clicks on "RejectOnboardingData" on "Onboarding" page

  @DataCollection5 @deleteOnboarding
  Scenario: 005 RiskScore - Entering the value for the risk enabled externally hidden properties in Data collection along with externally visible should be generating only 1 risk score (Data should be filled in Internal RS Onboard) #ENG-T5252
    When user creates an onboarding for prospect "616709" with risk model type "1" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616709" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+HiddenRiskProspect@riskscreen.com" email
    Then user should not be able to see "Integer" text in "FormContainer" field on "Refit" page
    And user enter "qwerty" text in "Property1" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user clicks on 'FormSubmissionCheckbox' on 'Refit' page
    And user clicks on 'SubmitButtons' on 'Refit' page
    And user waits until submission process is completed
    When user navigates to "Onboarding" page with URL: "/onboarding/edit/<onboardingID>?prospectid=<prospectID>&__BusinessUnit=<BUSINESSUNIT>" with the page title 'Onboarding'
    And user clicks on Onboarding Stage Tab with text "Risk Assessment" on Onboarding page
    Then user should see the following values in Risk assessment table:
      | Field                    | Value   |
      | FirstPropertyName        | Integer |
      | Grp1Pro1WeightedOutput   |      25 |
      | TotalRiskScoreD          |      50 |
      | TotalPossibleRiskScoreD  |     200 |
      | NormalisedRiskScoreD     |     25% |
      | NormalisedRiskScoreBandD | Low     |
    And user should see "25" text in "Property1RS" field on "Onboarding" page
    And user should see "default risk score" text in "Property1RiskScoreAttribute" field on "Onboarding" page
    And user clicks on Onboarding Stage Tab with text "Data Approval" on Onboarding page
    And user enter "75" text in "AgePropertyField" field on "ManageProspect" page
    And user clicks on 'SaveOnBoardingDataButton' on 'Onboarding' page
    Then user should see 'Onboarding data saved successfully.' text in 'SuccessMessage' field on 'Onboarding' page
    And user clicks on Onboarding Stage Tab with text "Risk Assessment" on Onboarding page
    Then user should see the following values in Risk assessment table:
      | Field                    | Value  |
      | FirstPropertyName        | Integer|
      | Grp1Pro1WeightedOutput   |     75 |
      | TotalRiskScoreD          |    100 |
      | TotalPossibleRiskScoreD  |    200 |
      | NormalisedRiskScoreD     |    50% |
      | NormalisedRiskScoreBandD | Standard |
    And user should see "75" text in "Property1RS" field on "Onboarding" page
    And user clicks on Onboarding Stage Tab with text "Data Approval" on Onboarding page
    And user clicks on "RejectOnboardingData" on "Onboarding" page

  @DataCollection6 @deleteOnboarding
  Scenario: 006 The subject of the notification email received by Prospect should read 'Notification - Nominee has submitted data collection for your review.' #ENG-T2308
    When user creates an onboarding for prospect "616715" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616715" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutoEmailNotifi@riskscreen.com" email
    And user shares form with email "testautomations+AutoEmailNotifiN1@riskscreen.com" and saves nominee on 'Refit' page
    And user clicks on "ShareWholeFormButton" on "Refit" page
    And user selects checkboxes "NotifyProspect, AllowManageNomineesCheckbox" on share form using send button "NomineePlacardSendRequestButton" and stores link as "NomineeDCFLink" on 'Refit' page
    And user navigates to URL with the stored key value "NomineeDCFLink" and enter OTP received on "testautomations+AutoEmailNotifiN1@riskscreen.com" email
    And user enter "GroupOne" text in "Property1" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user clicks on 'FormSubmissionCheckbox' on 'Refit' page
    And user clicks on 'SubmitButtons' on 'Refit' page
    And user waits until submission process is completed
    Then user should receive an email from: 'noreply@riskscreen.com' and to: 'testautomations+AutoEmailNotifi@riskscreen.com' with subject: 'Notification - Nominee has submitted data collection for your review' and body containing text: 'a nominee has completed a section of the data collection form'

  @DataCollection7 @deleteOnboarding @deleteAutocreatedOnboarding @deleteAutocreatedProspect
  Scenario: 007 'Create prospect, onboarding, push to screening from external form' action should work from External DCF only #ENG-T2610
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'PushToScreeningOB(DoNotTouch)' OB type on 'OnboardingType' page
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'OBManageProspectGroup' on 'OnboardingType' page
    And user clicks on 'ManagePropertyGroupsName' on 'OnboardingType' page
    Then user should see "Name" on "FirstProperty" on "OnboardingType" page
    When user clicks on 'AutocreationSettings' on 'OnboardingType' page
    Then user should see 'Create prospect, onboarding and push to screening from external form' option selected on 'ActionDropdown' on 'OnboardingType' page
    When user creates an onboarding for prospect "616728" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    When user navigates to "Onboarding" page with URL: "/onboarding/edit/<onboardingID>?prospectid=<prospectID>&__BusinessUnit=<BUSINESSUNIT>" with the page title 'Onboarding'
    And user clicks on Onboarding Stage Tab with text "Onboarding Data" on Onboarding page
    And user enter "First123" text in "Group1TextField" field on "Onboarding" page
    And user enter "Last123" text in "Group1TextField2" field on "Onboarding" page
    And user enter "25" text in "Group1IntegerField3" field on "Onboarding" page
    And user enter "Auto-CustomId" text in "Group1TextField4" field on "Onboarding" page
    And user clicks on 'SaveOnBoardingDataButton' on 'Onboarding' page
    And user clicks on Onboarding Stage Tab with text 'Auto Prospect Status' on Onboarding page
    And user should not see any prospect created
    And user creates a data request and collection link for prospect "616728" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+PushToScrenningREFIT@riskscreen.com" email
    And user enter "First123" text in "Group1TextField" field on "Refit" page
    And user enter "Last123" text in "Group1TextField2" field on "Refit" page
    And user enter "25" text in "Group1TextField3" field on "Refit" page
    And user enter "Auto-CustomId" text in "Group1TextField4" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user wait until autocreation process is complete
    When user navigates to "Onboarding" page with URL: "/onboarding/edit/<onboardingID>?prospectid=<prospectID>&__BusinessUnit=<BUSINESSUNIT>" with the page title 'Onboarding'
    And user clicks on Onboarding Stage Tab with text 'Auto Prospect Status' on Onboarding page
    Then user should see Autocreated prospect with name "Last123"
    And user should see "Created" on "AutocreationProspectStatus" on "Onboarding" page
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'Last123',selects SearchOn:'Last name' and select prospect from list
    And user store 'ProspectId' with keyName:'autoProspectID' from 'Prospect' page
    And user clicks on 'ScreeningLink' on 'ManageProspect' page
    And user store 'OnboardingId' with keyName:'autoOnboardingID' from 'Onboarding' page

  @DataCollection8 @deleteOnboarding
  Scenario: 008 Verify that PR,HBU,SR with Manage Nominee permissions can reallocate the PG to any other Nominee when first assigned nominee has not submitted the data successfully instead just saved the data #ENG-T306
    When user creates an onboarding for prospect "616750" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616750" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+SubmitPropertyDetailProspect@riskscreen.com" email
    And user shares form with email "testautomations+SubmitPropertyDetailProspectN1@riskscreen.com" and saves nominee on 'Refit' page
    And user clicks on "Group1CheckBox" on "Refit" page
    And user selects checkboxes "AllowManageNomineesCheckbox" on share form using send button "NomineePlacardSendRequestButton" and stores link as "Nominee1Link" on 'Refit' page
    And user navigates to URL with the stored key value "Nominee1Link" and enter OTP received on "testautomations+SubmitPropertyDetailProspectN1@riskscreen.com" email
    And user enter "NomineeDataN1" text in "Property1" field on "Refit" page
    And user enter "22" text in "Property2" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+SubmitPropertyDetailProspect@riskscreen.com" email
    And user shares form with email "testautomations+SubmitPropertyDetailProspectN2@riskscreen.com" and saves nominee on 'Refit' page
    And user selects checkboxes "AllowManageNomineesCheckbox" on share form using send button "NomineePlacardSendRequestButton2" and stores link as "Nominee2Link" on 'Refit' page
    And user navigates to URL with the stored key value "Nominee2Link" and enter OTP received on "testautomations+SubmitPropertyDetailProspectN2@riskscreen.com" email
    Then user should not see 'Personal Details' section on refit DCF
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+SubmitPropertyDetailProspect@riskscreen.com" email
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    And user clicks on 'NomineePlacardEditButton' on 'Refit' page
    And user clicks on "Group1CheckBox" on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    And user clicks on 'NomineePlacardEditButton2' on 'Refit' page
    And user clicks on "Group1CheckBox" on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    And user clicks on send request button of 'testautomations+SubmitPropertyDetailProspectN1@riskscreen.com' nominee on Refit page
    And user clicks on "CopyLinkToFormButton" button and navigates to the link in "DataCollectionLinkContainer" on "Refit" page waiting until "Loading..." is gone
    And user enter OTP received on "testautomations+SubmitPropertyDetailProspectN1@riskscreen.com"
    Then user should not see 'Personal Details' section on refit DCF
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+SubmitPropertyDetailProspect@riskscreen.com" email
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    And user clicks on send request button of 'testautomations+SubmitPropertyDetailProspectN2@riskscreen.com' nominee on Refit page
    And user clicks on "CopyLinkToFormButton" button and navigates to the link in "DataCollectionLinkContainer" on "Refit" page waiting until "Loading..." is gone
    And user enter OTP received on "testautomations+SubmitPropertyDetailProspectN2@riskscreen.com"
    Then user should see "NomineeDataN1" value in "Property1" field on "Refit" page
    And user should see "22" value in "Property2" field on "Refit" page
    And user enter "NomineeDataN2" text in "Property1" field on "Refit" page
    And user enter "23" text in "Property2" field on "Refit" page
    And user select "India_OLD" option in "Group1Property3" dropdown on "Refit" page
    And user select "Salary" option in "Group1Property4" dropdown on "Refit" page
    And user enter "PKYC" text in "Group1TextField5" field on "Refit" page
    And user enter "361" text in "Group1TextField6" field on "Refit" page
    And user enter "testautomations+SubmitPropertyDetailProspectN2@riskscreen.com" text in "Group1TextField7" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user clicks on 'FormSubmissionCheckbox' on 'Refit' page
    And user clicks on 'SubmitButtons' on 'Refit' page
    And user waits until submission process is completed
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+SubmitPropertyDetailProspect@riskscreen.com" email
    Then user should see "NomineeDataN2" value in "Property1" field on "Refit" page
    And user should see "23" value in "Property2" field on "Refit" page

  @DataCollection9 @deleteOnboarding
  Scenario: 009 Internal_DCF- Submit all required data and validate generated report #ENG-T9884
    When user creates an onboarding for prospect "616773" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616773" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+ProspectReportDoNottouch@riskscreen.com" email
    Then user should see "AutomationGroup" on "PageTitle" on "Refit" page
    And user enter "GroupOne" text in "Group1TextField" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    Then user should see "AutomationGroupTwo" on "PageTitle" on "Refit" page
    And user enter "GroupTwo" text in "Group2TextField1" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on 'ContinueButton' on 'Refit' page
    And user clicks on 'FormSubmissionCheckbox' on 'Refit' page
    And user clicks on 'SubmitButtons' on 'Refit' page
    And user waits until submission process is completed
    When user navigates to "Onboarding" page with URL: "/onboarding/edit/<onboardingID>?prospectid=<prospectID>&__BusinessUnit=<BUSINESSUNIT>" with the page title 'Onboarding'
    And user clicks on Onboarding Stage Tab with text 'Data Approval' on Onboarding page
    And user clicks on 'ApproveOnboardingDataButton' on 'Onboarding' page
    Then user should see success banner with message 'Onboarding data approved successfully.'
    And user clicks on Onboarding Stage Tab with text 'Identity Verification' on Onboarding page
    And user clicks on "SubmitIdentityApprovalButton" on 'Onboarding' page
    And user clicks on Onboarding Stage Tab with text 'Identity Approval' on Onboarding page
    And user clicks on "IdentityApprovalButton" on 'Onboarding' page
    Then user should see success banner with message 'Onboarding identity verification approved successfully.'
    And user clicks on 'ViewOnboardingReportButton' on 'Prospect' page
    And user should see "GroupOne" text in "OnboardingReportAutomationGroupDataOne" field on "ManageProspect" page
    And user should see "GroupTwo" text in "OnboardingReportAutomationGroupDataTwo" field on "ManageProspect" page
    When user clicks on "GoBackLink" on "Onboarding" page
    And user clicks on Onboarding Stage Tab with text 'Compliance Approval' on Onboarding page
    And user clicks on 'RevertToDataCollectionButton' on 'Onboarding' page
    Then user should see success banner with message 'Onboarding stage reverted successfully.'
    And user clicks on "GoBackLink" on "Onboarding" page
    And user delete onboarding

  @DataCollection10 @deleteOnboarding
  Scenario: 010 Internal_DCF- External DCF link opens correct content for Non-Default BU #ENG-T9880
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user selects "11" Business Unit
    And user enter SearchName:'NonDefaultDCF',selects SearchOn:'Last name' and select prospect from list
    And user creates an onboarding with note "Automation Test" and enter data collection stage
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user creates a data request
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'Send' on 'Prospect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+NonDefaultDCF@riskscreen.com"
    Then user should see "AutomationGroup" on "PageTitle" on "Refit" page

  @DataCollection11
  Scenario: 011 External DCF - Dynamic refresh does not scroll DCF to top on save #ENG-T6423
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ScrollDymaicRefresh',selects SearchOn:'Last name' and select prospect from list
    And user creates an onboarding with note "Automation Test" and enter data collection stage
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user creates a data request
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'Send' on 'Prospect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ScrollDymaicRefresh@riskscreen.com"
    And user enter "Text1" text in "Group1TextField" field on "Refit" page
    And user enter "Text2" text in "Group2Property1" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should be scrolled back to the "Group2Property1" field on "Refit" page
