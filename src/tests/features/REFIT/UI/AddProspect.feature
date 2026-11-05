@Regression @AddProspect
Feature: Add Prospect Automation

  Background:
    Given user login into 'REFIT' application with 'HandlerUserName' user

  @AddProspect1 @Smoke
  Scenario: 001 External DCF should show/hide 'Manage Prospect' section according to the 'Allow Manage Prospect' value #ENG-T30
    When user creates Prospect:
      | field              | value                                      | text     |
      | LastName           | AllowProKYB                                | TextBox  |
      | Email              | testautomations+AllowProKYB@riskscreen.com | TextBox  |
      | OnboardingType     | Automation(DoNotTouch)                     | DropDown |
      | HandledByUserGroup | Handler Group                              | DropDown |
      | HandledByUser      | Refit Automation (testaut...               | DropDown |
      | AllowKYBLookup     | Yes                                        | DropDown |
    And user creates an onboarding with note "Automation note" and enter data collection stage
    And user creates a data request
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user generates data collection link and open
    And user enter OTP received on "testautomations+AllowProKYB@riskscreen.com"
    Then user should able see "ShareThisFormButton" on "Refit" page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user selects "12" Business Unit
    And user enter SearchName:'AllowProKYB',selects SearchOn:'Last name' and select prospect from list
    And user delete onboarding and prospect