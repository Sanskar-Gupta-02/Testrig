@pkycAutocreation @Regression
Feature: pKYC Autocreation

  Background:
    Given user login into 'REFIT' application with 'PkycHandlerUserName' user
    And user is authorized using an 'PKYCAPIKEY'

  @pkycAutocreation01 @deletePkycOnboarding
  Scenario: 001 Verify that prospect should not be created from RS Onboard if 'Create Prospect from External Form' is chosen as the action in the ANP setting. #ENG-T711,T788
    When user creates an onboarding for prospect "616716" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616716" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutocreationS01@riskscreen.com" email
    And user enter data in following fields in Refit DCF:
      | Field            | Value                          |
      | Group1TextField  | AutocreatedProspectS01         |
      | Group1TextField2 | KYC                            |
      | Group1TextField3 |                            360 |
      | Group1TextField4 | testautomations@riskscreen.com |
    And user clicks on 'SaveButton' on 'Refit' page
    And user navigates to Prospect: "AutocreationS01" with Search On: 'Last name' and click on 'DataCollectionLink'
    Then user should see Autocreated prospect with name "KYC 360 AutocreatedProspectS01"
    When user open Autocreated prospect with name "KYC 360 AutocreatedProspectS01"
    And user delete prospect
    And user navigates to Prospect: 'AutocreationS01' with Search On: 'Last name' and click on 'DataCollectionLink'
    And user delete Prospect Autocreation Status for prospect '<prospect deleted>'
    And user enter data in following fields in internal form:
      | Field            | Value                          |
      | Group1TextField  | AutocreatedProspectS01         |
      | Group1TextField2 | KYC                            |
      | Group1TextField3 |                            360 |
      | Group1TextField4 | testautomations@riskscreen.com |
    And user clicks on 'SaveOnBoardingDataButton' on 'Onboarding' page
    Then user should not see Autocreated prospect with name "KYC 360 AutocreatedProspectS01"
    # Defect Raised: ENG-T9131