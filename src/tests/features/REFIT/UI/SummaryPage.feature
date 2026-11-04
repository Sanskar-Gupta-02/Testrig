@Regression @SummaryPage
Feature: Summary Page Automation

  Background:
    Given user login into 'REFIT' application with 'HandlerUserName' user
    And user is authorized using an 'APIKEY'

  @deleteOnboarding @SummaryPage1
  Scenario: 001 Summary page should Show Terms & Condition message and Confirmation Message as configured and buttons should navigate to corresponding page
    # Create onboarding and data request, generate data collection link using API
    When user creates an onboarding for prospect "608853" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "608853" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "AutomationTest+SummaryAutomationProspect@riskscreen.com" email
    And user clicks on 'SummaryTab' on 'Refit' page
    Then user should see 'Terms And Conditions Verification' on 'TermAndConditionMessage' on 'Refit' page
    And user should see 'There are changes required in 2 of the sections. Please update these sections before submitting.' on 'TitleErrorBox' on 'Refit' page
    And user should able see "SummaryErrorBox" on "Refit" page
    And user should see 'Group 1' on 'SummaryGroup1' on 'Refit' page
    And user should see 'Group 2' on 'SummaryGroup2' on 'Refit' page
    And user should see 'Group 3' on 'SummaryGroup3' on 'Refit' page
    Then user should see 'disabled' attribute on 'Submitbutton' on 'Refit' page
    And user should see 'Please make the necessary changes before submitting.' on 'ErrorBoxBeforeSubmit' on 'Refit' page
    And user should see 'Edit' on 'FirstEditButton' on 'Refit' page
    And user should see 'Edit' on 'SecondEditButton' on 'Refit' page
    When user clicks on 'FirstEditButton' on 'Refit' page
    And user enter "AEIOU" text in "Group1TextField" field on "Refit" page
    And user enter "25" text in "Group1IntegerField" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user enter "Auto-Address" text in "Group2TextField1" field on "Refit" page
    And user enter "Auto-Pune" text in "Group2TextField2" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user enter "411058" text in "Group3IntegerField1" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    Then user should not see 'SummaryErrorBox' on 'Refit' page
    And user should not see 'ErrorBoxBeforeSubmit' on 'Refit' page
    And user should see 'Completed' on 'SummaryGroup1Status' on 'Refit' page
    And user should see 'Completed' on 'SummaryGroup2Status' on 'Refit' page
    And user should see 'Completed' on 'SummaryGroup3Status' on 'Refit' page
    When user clicks on 'CheckButton' on 'Refit' page
    Then user should see 'Group 1' on 'PageTitle' on 'Refit' page
    When user clicks on 'ContinueButton' on 'Refit' page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user clicks on 'ContinueButton' on 'Refit' page
    Then user should see 'Confirmation Verification1. Bullet point2. Bullet point 2This is a Paragraph Verification.LinkText' on 'ConfirmationMessage' on 'Refit' page

  @deleteOnboarding @SummaryPage2
  Scenario: 002 Summary page should not show Terms and Conditions when disabled and show Default Confirmation message And should see Uploaded Document names
    # Create onboarding and data request, generate data collection link using API
    When user creates an onboarding for prospect "608854" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "608854" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "AutomationTest+SummaryDocumentProspect@riskscreen.com" email
    And user clicks on 'SummaryTab' on 'Refit' page
    Then user should not see 'TermAndConditionMessage' on 'Refit' page
    And user should see 'This will complete your submission to STGLOADTEST' on 'ConfirmationMessage' on 'Refit' page
    When user clicks on 'SidemenuDocument' on 'Refit' page
    And user upload 'AutomationDocument.jpg' file on 'Test-Document' on 'Refit' page
    And user clicks on 'DocumentExpandButton' on 'Refit' page
    And user enter "Auto-Document1" text in "DocumentRenameTextField" field on "Refit" page
    And user wait from 2 seconds
    And user clicks on 'DocumentSaveButton' on 'Refit' page
    And user upload 'AutomationDocument2.png' file on 'Test-Document' on 'Refit' page
    And user upload 'AutomationDocument3.pdf' file on 'Test-Document' on 'Refit' page
    And user wait from 2 seconds
    And user clicks on 'SummaryTab' on 'Refit' page
    And user clicks on 'DocumentExpandButton' on 'Refit' page
    Then user should see 'Auto-Document1.jpg' on 'DocumentList1' on 'Refit' page
    And user should see 'AutomationDocument2.png' on 'DocumentList2' on 'Refit' page
    And user should see 'AutomationDocument3.pdf' on 'DocumentList3' on 'Refit' page

  @SummaryPage3
  Scenario: 003 Nominee should see only assigned Property groups on summary page and should not show Terms and Conditions when disabled and show Default Confirmation message
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'SummaryAutomation3' OB type on 'OnboardingType' page
    Then user should see 'No' option selected on 'TermsAndConditionDropdown' on 'OnboardingType' page
    And user should see 'Hello From Terms And Conditions Message' on 'TermsAndConditionMessage' on 'OnboardingType' page
    And user should see 'No' on 'ConfirmationDropdown' on 'OnboardingType' page
    And user should see 'Hello From Confirmation Message' on 'ConfirmationMessage' on 'OnboardingType' page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'SummaryNomineeProspect',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text "Data Collection Requests" on Onboarding page
    And user clicks on 'NomineesLink' on 'ManageProspect' page
    Then user should see 'testautomations+SummaryNomineeProspectN1@riskscreen.com' on 'Group2AssignedEmail' on 'ManageProspect' page
    And user should see 'testautomations+SummaryNomineeProspectN1@riskscreen.com' on 'Group3AssignedEmail' on 'ManageProspect' page
    And user should see 'testautomations+SummaryNomineeProspectN1@riskscreen.com' on 'Group4AssignedEmail' on 'ManageProspect' page
    When user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+SummaryNomineeProspectN1@riskscreen.com"
    And user enter "Auto-Address" text in "Group2TextField2" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user enter "Auto-State" text in "Group3TextField1" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user enter "Auto-Country" text in "Group4TextField1" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    Then user should not see 'Group1Summary' on 'Refit' page
    And user should see 'Group 2' on 'SummaryGroup1' on 'Refit' page
    And user should see 'Group 3' on 'SummaryGroup2' on 'Refit' page
    And user should see 'Group 4' on 'SummaryGroup3' on 'Refit' page
    And user should not see 'TermsAndConditionMessage' on 'Refit' page
    And user should see 'This will complete your submission to STGLOADTEST-REFIT-TEST-CLIENT-QA-RiskScreen.  Are you sure?' on 'ConfirmationMessage' on 'Refit' page
