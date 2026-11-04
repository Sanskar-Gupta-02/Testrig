@Regression @sidePanelRefit
Feature: External DCF Refit

  Background:
    Given user login into 'REFIT' application with 'HandlerUserName' user
    And user is authorized using an 'APIKEY'

  @deleteOnboarding
  Scenario: 001 Refit Side bar and Form validation
    # Create onboarding and data request, generate data collection link using API
    When user creates an onboarding for prospect "608868" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "608868" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "automation+RefitTrailAutomation@riskscreen.com" email
    Then user should see 'Group 1' on 'PropertyGropuName1' on 'Refit' page
    And user should see 'Group 4' on 'PropertyGropuName2' on 'Refit' page
    And user should see 'automation+RefitTrailAutomation@riskscreen.com' on 'ProspectEmail' on 'Refit' page
    And user should see "Note for testing" on "PropertyGropuName1Note" on "Refit" page
    And user should see "user name" on "Group1FieldNote" on "Refit" page
    And user should see "(Optional)" on "Group1CityptionalField" on "Refit" page
    And user should see "(Optional)" on "Group1DOBOptionalField" on "Refit" page
    When user enter date "2025-04-02" text in "Group1DateField" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    Then user should see 'DOB must not be earlier than 09/05/2025' on 'Group1DateErrorField' on 'Refit' page
    When user enter date "2025-06-02" text in "Group1DateField" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    Then user should see 'DOB must not be later than 31/05/2025' on 'Group1DateErrorField' on 'Refit' page
    When user enter date "2025-05-13" text in "Group1DateField" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    Then user should able see "ErrorBox" on "Refit" page
    When user enter "ABC" text in "Group1TextField" field on "Refit" page
    And user enter "10" text in "Group1IntegerField" field on "Refit" page
    Then user should see 'Age must be at least 18' on 'Group1IntegerErrorField' on 'Refit' page
    When user enter "100" text in "Group1IntegerField" field on "Refit" page
    Then user should see 'Age must not be greater than 60' on 'Group1IntegerErrorField' on 'Refit' page
    When user enter "10ab0" text in "Group1IntegerField" field on "Refit" page
    Then user should see 'Age must be a whole number' on 'Group1IntegerErrorField' on 'Refit' page
    When user enter "0.99" text in "Group1DecimalrField" field on "Refit" page
    Then user should see 'Income must be at least 1.00' on 'Group1DecimalErrorField' on 'Refit' page
    When user enter "10000000.99" text in "Group1DecimalrField" field on "Refit" page
    Then user should see 'Income must not be greater than 100000.00' on 'Group1DecimalErrorField' on 'Refit' page
    When user enter "10000000.99abs" text in "Group1DecimalrField" field on "Refit" page
    Then user should see 'Income must be a number' on 'Group1DecimalErrorField' on 'Refit' page
    And user should see '1 - 1' on 'Group1ListField' on 'Refit' page
    When user enter "ABC" text in "Group1TextField" field on "Refit" page
    And user enter "25" text in "Group1IntegerField" field on "Refit" page
    And user enter "10000.99" text in "Group1DecimalrField" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user wait from 5 seconds
    And user clicks on 'ContinueButton' on 'Refit' page
    And user wait from 5 seconds
    Then user should see 'Group 1' on 'SideMenuGroup1' on 'Refit' page
    And user should not see 'SideMenuGroup3' on 'Refit' page
    And user should see 'Group 6' on 'PropertyGroupAfterTC' on 'Refit' page
    When user navigates to "Onboarding" page with URL: "/onboarding/edit/<onboardingID>?prospectid=<prospectID>&__BusinessUnit=<BUSINESSUNIT>" with the page title 'Onboarding'
    Then user should see "ABC" value in "NamePropertyField" field on "ManageProspect" page
    And user should see "25" value in "AgePropertyField" field on "ManageProspect" page
    And user should see "10000.9900000000" value in "IncomePropertyField" field on "ManageProspect" page
