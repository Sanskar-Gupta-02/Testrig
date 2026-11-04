@Regression @DataApproval
Feature: Data Approval Automation

  Background:
    Given user login into 'REFIT' application with 'HandlerUserName' user

  @DataApproval1
  Scenario: 029 User should be able to receive mail when Email alert is configured for Handler when form filled Externally.
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on "EmailAlertCheck" OB type on "OnboardingType" page
    And user clicks on "DataCollectionLink" on "OnboardingType" page
    Then user should see "EmailAlertConfigHandlerAssigned,EmailAlertConfigSupervisorAssigned" options to be checked for Email Alerts Configuration
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user selects "12" Business Unit
    And user enter SearchName:'EmailAlertCheck',selects SearchOn:'Last name' and select prospect from list
    And user creates an onboarding with note "Automation note" and enter data collection stage
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user creates a data request
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'Send' on 'Prospect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+EmailAlertCheck@riskscreen.com"
    And user enter "Test" text in "Group1TextField" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user clicks on 'FormSubmissionCheckbox' on 'Refit' page
    And user clicks on 'SubmitButtons' on 'Refit' page
    And user waits until submission process is completed
    Then user should receive an email from: "noreply@riskscreen.com" and to: "testautomations+refit@riskscreen.com" with subject: "prospect  EmailAlertCheck" and body containing text: "Hello Refit Automation (testautomations+refit@riskscreen.com)"
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user selects "12" Business Unit
    And user enter SearchName:'EmailAlertCheck',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataApprovalLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Approval' on Onboarding page
    And user clicks on 'RejectOnboardingButton' on 'ManageProspect' page
    Then user should receive an email from: "noreply@riskscreen.com" and to: "testautomations+refit@riskscreen.com" with subject: "prospect EmailAlertCheck" and body containing text: "Hello Refit Automation (testautomations+refit@riskscreen.com)"
    When user clicks on 'Back' on 'ManageProspect' page
    And user delete onboarding