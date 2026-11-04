Feature: External DCF

  Background:
    Given user login to kyc360 with 'HandlerUserName' user

  @oldDCF @Test
  Scenario: user should be able to save external DCF with Data in different properties
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'RefitTrialProspect',selects SearchOn:'Last name' and select prospect from list
    Then user should see the following texts in following fields
      | field          | page           | text                                              |
      | OnboardingType | ManageProspect | Ravenscroft-TEST-Entity-O...                      |
      | ProspectStatus | ManageProspect | Active                                            |
      | Email          | ManageProspect | testautomations+RefitTrialProspect@riskscreen.com |
      | HandlerUser    | ManageProspect | shantanu                                          |
      | HandlerGroup   | ManageProspect | Handler Group                                     |
    When user clicks on 'DataCollectionLink' on 'ManageProspect' page
    Then user should see 'DataCollectionRequests' table on 'ManageProspect' page
    When user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    Then user should see link pop up 'DataCollectionLinkPopup' on 'ManageProspect' page
    When user get the data link and open in new tab
    And user should see 'Request Verification Code' title on 'Onboarding' page
    When user clicks on "SendVerificationCodeforRiskScreenButton" on 'Onboarding' page
    Then user should see 'Enter Verification Code' title on 'Onboarding' page
    When user get the Verification code from:'noreply@riskscreen.com' and to:'testautomations+RefitTrialProspect@riskscreen.com' email
    And user enter the Verification code
    And user clicks on "EnterRiskScreenButton" on 'Onboarding' page
    And user clicks on "ContinuetoDataCollectionLink" on 'Onboarding' page
    And user enter "Company Name Copy" text in "NameOfAccountCopy" field on 'Onboarding' page
    And user select "Guernsey" option in "WhichOfficeCopy" dropdown on 'Onboarding' page
    And user select "Advisory" option in "RequiredServiceCopy" dropdown on 'Onboarding' page
    And user select "Individuals" option in "CorporateTrustCopy" dropdown on 'Onboarding' page
    And user enter "Company Name" text in "NameOfAccount" field on 'Onboarding' page
    And user select "Jersey" option in "WhichOffice" dropdown on 'Onboarding' page
    And user select "Cash Management" option in "RequiredService" dropdown on 'Onboarding' page
    And user select "Listed Companies" option in "CorporateTrust" dropdown on 'Onboarding' page
    And user clicks on "SaveButton" on 'Onboarding' page
    And user should see "banner" "Onboarding data saved successfully." on "Onboarding" page
    Then user login back to kyc360 after dcf submission with 'HandlerUserName' user
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'RefitTrialProspect',selects SearchOn:'Last name' and select prospect from list
    Then user should see the following texts in following fields
      | field          | page           | text                                              |
      | OnboardingType | ManageProspect | Ravenscroft-TEST-Entity-O...                      |
      | ProspectStatus | ManageProspect | Active                                            |
      | Email          | ManageProspect | testautomations+RefitTrialProspect@riskscreen.com |
      | HandlerUser    | ManageProspect | shantanu                                          |
      | HandlerGroup   | ManageProspect | Handler Group                                     |
    When user clicks on "DataCollectionLink" on 'ManageProspect' page
    Then user should see 'DataCollectionRequests' table on 'ManageProspect' page
    When user enter "" text in "NameOfAccountCopy" field on 'Onboarding' page
    And user select "" option in "WhichOfficeCopy" dropdown on 'Onboarding' page
    And user select "" option in "RequiredServiceCopy" dropdown on 'Onboarding' page
    And user select "" option in "CorporateTrustCopy" dropdown on 'Onboarding' page
    And user enter "" text in "NameOfAccount" field on 'Onboarding' page
    And user select "" option in "WhichOffice" dropdown on 'Onboarding' page
    And user select "" option in "RequiredService" dropdown on 'Onboarding' page
    And user select "" option in "CorporateTrust" dropdown on 'Onboarding' page
    And user clicks on 'SaveOnBoardingDataButton' on 'Onboarding' page
    Then user should see 'Onboarding data saved successfully.' text in 'SuccessMessage' field on 'Onboarding' page
