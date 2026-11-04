@pkycCON10 @Regression
Feature: pKYC CON10

  Background:
    Given user login into 'REFIT' application with 'PkycHandlerUserName' user
    And user is authorized using an 'PKYCAPIKEY'

  @pkycCON101 @deletePkycOnboarding
  Scenario: 001 Allow Manage Prospect permission should work dependent on Manage Nominee Permission #ENG-T1064,T1075,T1061
    When user creates an onboarding for prospect "580786" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "580786" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+PKYCProspectNomineeLead@riskscreen.com" email
    And user shares form with email "testautomations+PKYCProspectNomineeLeadN1@riskscreen.com" and saves nominee on 'Refit' page
    And user selects checkboxes "AllowManageNomineesCheckbox, AllowManageProspectsCheckbox" on share form using send button "NomineePlacardSendRequestButton" and stores link as "NomineeDCFLink" on 'Refit' page
    When user navigates to URL with the stored key value "NomineeDCFLink" and enter OTP received on "testautomations+PKYCProspectNomineeLeadN1@riskscreen.com" email
    Then user should able see 'ShareThisFormButton' on 'Refit' page
    And user should able see 'ManageProspectButton' on 'Refit' page
    And user shares form with email "testautomations+PKYCProspectNomineeLeadN2@riskscreen.com" and saves nominee on 'Refit' page
    And user selects checkboxes "AllowManageProspectsCheckbox" on share form using send button "NomineePlacardSendRequestButton2" and stores link as "Nominee2DCFLink" on 'Refit' page
    When user navigates to URL with the stored key value "Nominee2DCFLink" and enter OTP received on "testautomations+PKYCProspectNomineeLeadN2@riskscreen.com" email
    Then user should not able see 'ShareThisFormButton' on 'Refit' page
    And user should not able see 'ManageProspectButton' on 'Refit' page
    # Defect Raised: ENG-T9131