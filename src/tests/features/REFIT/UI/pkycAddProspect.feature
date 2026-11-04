@Regression @PkycAddProspect
Feature: Pkyc Add Prospect Automation

  Background:
    Given user login into 'REFIT' application with 'PkycHandlerUserName' user

  @pkycAddProspect1
  Scenario: 001 External DCF should show/hide 'Manage Prospect' section according to the 'Allow Manage Prospect' value #ENG-T30
    When user creates Prospect:
      | field              | value                                           | text     |
      | LastName           | NoGroupAttatched                                | TextBox  |
      | Email              | testautomations+NoGroupAttatched@riskscreen.com | TextBox  |
      | OnboardingType     | Automation(DoNotTouch)                          | DropDown |
      | HandledByUserGroup | Handler Group                                   | DropDown |
      | HandledByUser      | akshaypardeshi+automation...                    | DropDown |
      | AllowKYBLookup     | Yes                                             | DropDown |
    And user creates an onboarding with note "Automation note" and enter data collection stage
    And user creates a data request
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user generates data collection link and open
    And user enter OTP received on "testautomations+NoGroupAttatched@riskscreen.com"
    Then user should able see "ShareThisFormButton" on "Refit" page
    And user should not able see "ManageProspectButton" on "Refit" page
    When user navigates to Prospect: "NoGroupAttatched" with Search On: "Last name"
    And user delete onboarding and prospect
    # Defect Raised: ENG-T9131