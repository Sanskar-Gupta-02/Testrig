Feature: External DCF

  Background:
    Given user login to kyc360 with 'HandlerUserName' user

  @oldDCFSimpleOB
  Scenario: user should be able to save external DCF with Data in different properties
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'Gnanark',selects SearchOn:'Last name' and select prospect from list
    Then user should see the following texts in following fields
      | field          | page           | text                                   |
      | OnboardingType | ManageProspect |                               03022025 |
      | ProspectStatus | ManageProspect | Active                                 |
      | Email          | ManageProspect | testautomations+Gnanark@riskscreen.com |
      | HandlerUser    | ManageProspect | shantanu                               |
      | HandlerGroup   | ManageProspect | Handler Group                          |
    When user clicks on 'CreateOnboardingLink' on 'ManageProspect' page
    And user enter 'Automation Onboarding Notes' text in 'CreateOnbarodingNotes' field on 'ManageProspect' page
    And user clicks on 'CreateOnboardingButton' on 'ManageProspect' page
    And user should see "banner" "Onboarding added successfully." on "ManageProspect" page
    When user clicks on 'DataCollectionLink' on 'ManageProspect' page
    When user clicks on "CreateDataRequestLink" on 'ManageProspect' page
    And user enter 'Automation Data Request Notes' text in 'textCreateDataRequest' field on 'ManageProspect' page
    And user clicks on 'CreateDataRequestButton' on 'ManageProspect' page
    Then user should see 'DataCollectionRequests' table on 'ManageProspect' page
    When user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    Then user should see link pop up 'DataCollectionLinkPopup' on 'ManageProspect' page
    When user get the data link and open in new tab
    And user should see 'Request Verification Code' title on 'Onboarding' page
    When user clicks on "SendVerificationCodeforRiskScreenButton" on 'Onboarding' page
    Then user should see 'Enter Verification Code' title on 'Onboarding' page
    When user get the Verification code from:'noreply@riskscreen.com' and to:'testautomations+Gnanark@riskscreen.com' email
    And user enter the Verification code
    And user clicks on "EnterRiskScreenButton" on 'Onboarding' page
    And user clicks on "ContinuetoDataCollectionLink" on 'Onboarding' page
    And user enter "Gnanark" text in "textLastName" field on 'Onboarding' page
    And user enter "testautomations+Gnanark@riskscreen.com" text in "textEmail" field on 'Onboarding' page
    And user clicks on "SaveAndContinueButton" on 'Onboarding' page
    And user clicks on "SubmitButton" on 'Onboarding' page
    And user clicks on "DataCollectionSubmitButton" on 'Onboarding' page
    And user should see "banner" "Onboarding data submitted by prospect successfully." on "Onboarding" page
    And user login back to kyc360 after dcf submission with 'HandlerUserName' user
    And user enter SearchName:'Gnanark',selects SearchOn:'Last name' and select prospect from list
    Then user should see the following texts in following fields
      | field          | page           | text                                   |
      | OnboardingType | ManageProspect |                               03022025 |
      | ProspectStatus | ManageProspect | Active                                 |
      | Email          | ManageProspect | testautomations+Gnanark@riskscreen.com |
      | HandlerUser    | ManageProspect | shantanu                               |
      | HandlerGroup   | ManageProspect | Handler Group                          |
    And user should able see "DataApprovalLink" on 'ManageProspect' page
    And user clicks on "DataApprovalLink" on 'ManageProspect' page
    And user clicks on "ApproveOnboardingDataButton" on 'Onboarding' page
    And user clicks on "SubmitIdentityApprovalButton" on 'Onboarding' page
    And user should able see "IdentityApprovalButton" on 'Onboarding' page
    And user clicks on "IdentityApprovalButton" on 'Onboarding' page
    And user enter "Approval" text in "ApprovalText" field on 'Onboarding' page
    And user clicks on "SubmitOnboardingForApprovalButton" on 'Onboarding' page
    And user should see "banner" "Onboarding approved successfully." on "Onboarding" page
    And user should able see "ApprovedLabel" on 'Onboarding' page
    # Reverser Journey
    And user clicks on "RevertToDataCollectionButton" on 'Onboarding' page
    And user should see "banner" "Onboarding stage reverted successfully." on "Onboarding" page
    And user clicks on "GoBackLink" on 'Onboarding' page
    And user clicks on "DeleteOnBoardingLink" on 'ManageProspect' page
    And user clicks on "OnboardingConfirmDeletionButton" on 'ManageProspect' page
    And user should see "banner" "Onboarding deleted successfully." on "Onboarding" page
