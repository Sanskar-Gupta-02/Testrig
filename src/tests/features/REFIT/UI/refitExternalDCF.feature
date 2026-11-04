@refitExternalDCF
Feature: External DCF Refit

  Background:
    Given user login to kyc360 with 'HandlerUserName' user

  Scenario: form  accessible when  refit  flag  is  turned on
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'refitExternalDCF',selects SearchOn:'Last name' and select prospect from list
    Then user should see the following texts in following fields
      | field          | page           | text                                            |
      | OnboardingType | ManageProspect | PnG Malta                                       |
      | ProspectStatus | ManageProspect | Active                                          |
      | Email          | ManageProspect | testautomations+refitExternalDCF@riskscreen.com |
      | HandlerUser    | ManageProspect | shantanu                                        |
      | HandlerGroup   | ManageProspect | Handler Group                                   |
    When user clicks on 'DataCollectionLink' on 'ManageProspect' page
    Then user should see 'DataCollectionRequests' table on 'ManageProspect' page
    When user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    Then user should see link pop up 'DataCollectionLinkPopup' on 'ManageProspect' page
    When user get the data link and open in new tab
    And user should able see "onboardingData" on 'Onboarding' page
    And user should see "testautomations+refitExternalDCF@riskscreen.com" text in "UserEmailId" field on 'Onboarding' page

  Scenario: Checking validation messages for Mandatory properties
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'refitExternalDCF',selects SearchOn:'Last name' and select prospect from list
    Then user should see the following texts in following fields
      | field          | text                                            |
      | OnboardingType | PnG Malta                                       |
      | ProspectStatus | Active                                          |
      | Email          | testautomations+refitExternalDCF@riskscreen.com |
      | HandlerUser    | shantanu                                        |
      | HandlerGroup   | Handler Group                                   |
    When user clicks on 'DataCollectionLink' on 'ManageProspect' page
    Then user should see 'DataCollectionRequests' table on 'ManageProspect' page
    When user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    Then user should see link pop up 'DataCollectionLinkPopup' on 'ManageProspect' page
    When user get the data link and open in new tab
    When user enter "" text in "Property1" field on 'Onboarding' page
    And user enter "" text in "Property2" field on 'Onboarding' page
    And user enter "" text in "Property3" field on 'Onboarding' page
    And user select "India" option in "Dropdown1" dropdown on 'Onboarding' page
    And user select "Online Casino" option in "Dropdown2" dropdown on 'Onboarding' page
    And user clicks on "ContinueButton" on 'Onboarding' page
    Then user should able see "MandatoryFieldWarningMessages" on 'Onboarding' page

  Scenario: Filling out Form and checking if Value is getting saved.
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'refitExternalDCF',selects SearchOn:'Last name' and select prospect from list
    Then user should see the following texts in following fields
      | field          | page           | text                                            |
      | OnboardingType | ManageProspect | PnG Malta                                       |
      | ProspectStatus | ManageProspect | Active                                          |
      | Email          | ManageProspect | testautomations+refitExternalDCF@riskscreen.com |
      | HandlerUser    | ManageProspect | shantanu                                        |
      | HandlerGroup   | ManageProspect | Handler Group                                   |
    When user clicks on 'DataCollectionLink' on 'ManageProspect' page
    Then user should see 'DataCollectionRequests' table on 'ManageProspect' page
    When user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    Then user should see link pop up 'DataCollectionLinkPopup' on 'ManageProspect' page
    When user get the data link and open in new tab
    When user enter "refitProspect" text in "Property1" field on 'Onboarding' page
    And user enter "Pune" text in "Property2" field on 'Onboarding' page
    And user enter "12345" text in "Property3" field on 'Onboarding' page
    And user enter "2001-07-26" text in "DateProperty" field on 'Onboarding' page
    And user select "India" option in "Dropdown1" dropdown on 'Onboarding' page
    And user select "Online Casino" option in "Dropdown2" dropdown on 'Onboarding' page
    And user select "Yes" option in "Dropdown3" dropdown on 'Onboarding' page
    And user select "Yes" option in "Dropdown4" dropdown on 'Onboarding' page
    And user select "Nominee Shareholder" option in "Dropdown5" dropdown on 'Onboarding' page
    And user select "Entity is publicly listed" option in "Dropdown6" dropdown on 'Onboarding' page
    And user select "India" option in "Dropdown7" dropdown on 'Onboarding' page
    And user enter "refitlink" text in "Property4" field on 'Onboarding' page
    And user enter "refitlink" text in "Property5" field on 'Onboarding' page
    And user enter "refitBody" text in "Property6" field on 'Onboarding' page
    And user select "India" option in "Dropdown8" dropdown on 'Onboarding' page
    And user select "Exclusively cryptocurrency" option in "Dropdown9" dropdown on 'Onboarding' page
    Then user clicks on "ContinueButton" on 'Onboarding' page
    When user login back to kyc360 after dcf submission with 'HandlerUserName' user
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    When user enter SearchName:'refitExternalDCF',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    Then user should see 'DataCollectionRequests' table on 'ManageProspect' page
    And user should see "MatchProperty1" value in "refitProspect" field on 'ManageProspect' page
    And user should see the following value in following fields
      | field          | page           | text          |
      | MatchProperty1 | ManageProspect | refitProspect |
      | MatchProperty2 | ManageProspect | Pune          |
      | MatchProperty3 | ManageProspect |         12345 |
      | MatchProperty4 | ManageProspect |    2001-07-26 |
    #    |Country of incorporation | 2001-07-26  |
    #     |Type of  business | 2001-07-26  |
    #     | contracting party | 2001-07-26  |
    #     | contracting entity | 2001-07-26  |
    #     | contracting accepted| 2001-07-26  |
    When user enter "" text in "MatchProperty1" field on 'ManageProspect' page
    And user enter "" text in "MatchProperty2" field on 'ManageProspect' page
    And user enter "" text in "MatchProperty3" field on 'ManageProspect' page
    And user enter "" text in "MatchProperty4" field on 'ManageProspect' page
    And user clicks on 'SaveOnBoardingDataButton' on 'ManageProspect' page
    # Then user should see 'Onboarding data saved successfully.' text in 'Suc
