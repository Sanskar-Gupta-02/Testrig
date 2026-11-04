@Regression @IdentityVerification
Feature: Identity Verification Automation

  Background:
    Given user login into 'REFIT' application with 'HandlerUserName' user
    And user is authorized using an 'APIKEY'

  @OldDCF @IdentityVerification1 @deleteOnboarding
Scenario: 002 Send IDPAL link automatically to prospect on submitting DCF & verify the submission message and IDPAL email content displayed and received by the prospect respectively #ENG-T5525
    When user creates an onboarding for prospect "616856" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616856" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+SendIDPALAutoLink@riskscreen.com" email
    And user enter "GroupOne" text in "Group1TextField" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on "ContinueButton" on "Refit" page
    And user clicks on "ContinueButton" on "Refit" page
    And user clicks on "FormSubmissionCheckbox" on "Refit" page
    And user clicks on "FormSubmitButton" on "Refit" page
    And user waits until submission process is completed
    Then user should receives email from:"noreply@id-pal.com" and to:"testautomations+SendIDPALAutoLink@riskscreen.com" and body should contains "Hello SendIDPALAutoLink, Please follow these instructions to complete your electronic identification process: Please open this email on your mobile device and click the link below to download" on outlook
    # Raised Defect ENG-9708
