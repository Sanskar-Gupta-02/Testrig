@Regression @OnboardingTypeConfigure
Feature: Onboarding Type Configure

  Background:
    Given user login into 'REFIT' application with 'HandlerUserName' user
    And user is authorized using an 'APIKEY'

  @deleteOnboarding @OnboardingTypeConfigure1
  Scenario: 001 The text of the confirmation message should be appearing as customized #ENG-T7788
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'ConfirmationMessageOBType' OB type on 'OnboardingType' page
    And user should see 'Yes' on 'ConfirmationDropdown' on 'OnboardingType' page
    And user should see 'Hello From Confirmation Message' on 'ConfirmationMessage' on 'OnboardingType' page
    When user creates an onboarding for prospect "616171" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616171" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+ConfirmationMessageProspect@riskscreen.com" email
    And user clicks on 'SummaryTab' on 'Refit' page
    Then user should see 'Hello From Confirmation Message' on 'ConfirmationMessage' on 'Refit' page

  @deleteOnboarding @OnboardingTypeConfigure2
  Scenario: 002 Verify that if Verification Support message is enabled and the verification code page should not display RiskScreen Label while login #ENG-T3574
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'VerificationSupportMessage' OB type on 'OnboardingType' page
    And user select 'Yes' option in 'VerificationMessageDropdown' dropdown on 'OnboardingType' page
    And user enter 'Hello From Verification Message' text in 'VerificationMessageTextbox' field on 'OnboardingType' page
    And user clicks on 'UpdateOBTypeButton' on 'OnboardingType' page
    And user clicks on 'PublishChangesButton' on 'OnboardingType' page
    When user creates an onboarding for prospect "616189" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616189" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" 
    Then user should see 'Hello From Verification Message' on 'VerificationMessageDisplay' on 'Refit' page
    # Disable verification support message on OB type
    And user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'VerificationSupportMessage' OB type on 'OnboardingType' page
    And user select 'No' option in 'VerificationMessageDropdown' dropdown on 'OnboardingType' page
    And user enter '' text in 'VerificationMessageTextbox' field on 'OnboardingType' page
    And user clicks on 'UpdateOBTypeButton' on 'OnboardingType' page
    And user clicks on 'PublishChangesButton' on 'OnboardingType' page
    When user creates a data request and collection link for prospect "616189" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink"
    Then user should see 'If you are experiencing problems' on 'VerificationMessageDisplay' on 'Refit' page
