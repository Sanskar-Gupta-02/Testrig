@ManageProspect @Regression
Feature: Manage Prospect

  Background:
    Given user login to kyc360 with 'HandlerUserName' user
    And user is authorized using an 'APIKEY'

  @ManageProspect1 @deleteOnboarding @deleteCreatedProspect
  Scenario: 001 User validates Manage Prospect button is functional and displays the Structure Group correctly when configured with HBU. #ENG-T1047,T1020,T9182,T9184,T1005,T1006
    When user store value:'615264' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add" and has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request and checks response status 201
    And user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add" and has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user adds payloads with stored keys:
      | Key                | StoredKey    |
      | ClientProspectID   | prospectID   |
      | ClientOnboardingID | onboardingID |
    And user sends a 'POST' request and checks response status 201
    And user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user adds payloads with stored keys:
      | Key                | StoredKey     |
      | ClientProspectID   | prospectID    |
      | ClientOnboardingID | onboardingID  |
      | DataRequestID      | dataRequestID |
    And user has a service named "/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink" and has a payload from the file 'dataRequest'
    And user adds payloads with stored keys:
      | Key                | StoredKey     |
      | ClientProspectID   | prospectID    |
      | ClientOnboardingID | onboardingID  |
      | DataRequestID      | dataRequestID |
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request and checks response status 200
    And user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutomationTestS1@riskscreen.com" email
    And user clicks on 'ManageProspectButton' on 'Refit' page
    And user clicks on 'CreateProspect' on 'Refit' page
    And user enter data in following fields in Refit DCF:
      | field             | value                                           |
      | FamilyName        | refitExternalDCF                                |
      | FirstName         | RefitTest                                       |
      | OtherName         | Automation                                      |
      | Email             | testautomations+refitExternalDCF@riskscreen.com |
      | MobileNumber      |                                      1234567890 |
      | ProspectReference | REFIT123                                        |
    And user selects data in following fields in Refit DCF:
      | field                | value          |
      | ProspectRelationship | Director       |
      | OnboardingType       | TempOB         |
      | ParentProspect       | AutomationTest |
    And user clicks on 'CreateProspectButton' on 'Refit' page
    And user clicks on the expand button of 'RefitTest Automation refitExternalDCF (Director)' Prospect on Refit page
    Then user should see the following values in the Refit Prospect form:
      | field           | value                                            |
      | Name            | RefitTest Automation refitExternalDCF (Director) |
      | Onboarding type | TempOB                                           |
      | Mobile          |                                       1234567890 |
      | Email           | testautomations+refitExternalDCF@riskscreen.com  |
      | Prospect groups | AutomationTestGroup                              |
    And user store 'ProspectID' with keyName:'ProspectID' from 'Refit' page
    And user clicks on 'ShowOnBoardingDropDown' on 'Refit' page
    And user store 'OnBoardingID' with keyName:'OnBoardingID' from 'Refit' page
    And user clicks on 'ProspectDeleteButton' on 'Refit' page
    And user clicks on 'ConfirmDeleteButton' on 'Refit' page

  @ManageProspect2 @deleteOnboarding @deleteCreatedProspect
  Scenario: 002 User should be able to create a new prospect and verify that the Email field is disabled with the default email displayed when the checkbox is ticked. #ENG-T9087,T9112,T9111,T9081
    When user store value:'615286' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add" and has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request and checks response status 201
    And user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add" and has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user adds payloads with stored keys:
      | Key                | StoredKey    |
      | ClientProspectID   | prospectID   |
      | ClientOnboardingID | onboardingID |
    And user sends a 'POST' request and checks response status 201
    And user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user adds payloads with stored keys:
      | Key                | StoredKey     |
      | ClientProspectID   | prospectID    |
      | ClientOnboardingID | onboardingID  |
      | DataRequestID      | dataRequestID |
    And user has a service named "/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink" and has a payload from the file 'dataRequest'
    And user adds payloads with stored keys:
      | Key                | StoredKey     |
      | ClientProspectID   | prospectID    |
      | ClientOnboardingID | onboardingID  |
      | DataRequestID      | dataRequestID |
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request and checks response status 200
    And user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutomationTestS2@riskscreen.com" email
    Then user should to see the "ManageProspectButton" on "Refit" page
    When user clicks on 'ManageProspectButton' on 'Refit' page
    Then user should to see the "CreateProspect" on "Refit" page
    When user clicks on 'CreateProspect' on 'Refit' page
    And user enter "AutomationTest@riskscreen.com" text in "Email" field on "Refit" page
    And user clicks on "DefaultEmailCheckbox" on "Refit" page
    And user enter data in following fields in Refit DCF:
      | field             | value      |
      | FamilyName        | Automation |
      | FirstName         | Test       |
      | OtherName         | Check      |
      | MobileNumber      | 1234567890 |
      | ProspectReference | AutoTestS2 |
    And user selects data in following fields in Refit DCF:
      | field                | value          |
      | ProspectRelationship | Director       |
      | OnboardingType       | TempOB         |
      | ParentProspect       | AutomationTest |
    And user clicks on 'CreateProspectButton' on 'Refit' page
    And user clicks on the expand button of 'Test Check Automation (Director)' Prospect on Refit page
    Then user should see the following values in the Refit Prospect form:
      | field           | value                                           |
      | Name            | Test Check Automation (Director)                |
      | Onboarding type | TempOB                                          |
      | Mobile          |                                      1234567890 |
      | Email           | testautomations+AutomationTestS1@riskscreen.com |
      | Prospect groups | AutomationTestGroup                             |
    And user store 'ProspectID' with keyName:'ProspectID' from 'Refit' page
    And user clicks on 'ShowOnBoardingDropDown' on 'Refit' page
    And user store 'OnBoardingID' with keyName:'OnBoardingID' from 'Refit' page
    And user clicks on 'ProspectDeleteButton' on 'Refit' page
    And user clicks on 'ConfirmDeleteButton' on 'Refit' page

  @ManageProspect3 @deleteOnboarding @deleteCreatedProspect
  Scenario: 003 User should see the Add button next to an already added prospect and verify that the search box is working as expected. #ENG-T9090,T9110,T1021,T1022
    When user store value:'615326' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add" and has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request and checks response status 201
    And user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add" and has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user adds payloads with stored keys:
      | Key                | StoredKey    |
      | ClientProspectID   | prospectID   |
      | ClientOnboardingID | onboardingID |
    And user sends a 'POST' request and checks response status 201
    And user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user adds payloads with stored keys:
      | Key                | StoredKey     |
      | ClientProspectID   | prospectID    |
      | ClientOnboardingID | onboardingID  |
      | DataRequestID      | dataRequestID |
    And user has a service named "/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink" and has a payload from the file 'dataRequest'
    And user adds payloads with stored keys:
      | Key                | StoredKey     |
      | ClientProspectID   | prospectID    |
      | ClientOnboardingID | onboardingID  |
      | DataRequestID      | dataRequestID |
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request and checks response status 200
    And user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutomationTestS3@riskscreen.com" email
    And user clicks on 'ManageProspectButton' on 'Refit' page
    And user clicks on 'AddExistingProspectButton' on 'Refit' page
    And user clicks on 'SearchButton' on 'Refit' page
    And user wait until "ProspectSearchTable" process on "Refit" page is complete
    Then user should able to see "AutomationTest, AutomationTestS2, AutomationTestS3" on "ProspectNames" on "Refit" page
    When user clicks on 'CreateProspectButton2' on 'Refit' page
    And user enter data in following fields in Refit DCF:
      | field             | value                                     |
      | FamilyName        | AutoTestS3                                |
      | FirstName         | RefitTest                                 |
      | OtherName         | Automation                                |
      | Email             | testautomations+AutoTestS3@riskscreen.com |
      | MobileNumber      |                                1234567890 |
      | ProspectReference | AutoTestS3                                |
    And user selects data in following fields in Refit DCF:
      | field                | value          |
      | ProspectRelationship | Director       |
      | OnboardingType       | TempOB         |
      | ParentProspect       | AutomationTest |
    And user clicks on 'CreateProspectButton' on 'Refit' page
    And user clicks on the expand button of 'RefitTest Automation AutoTestS3 (Director)' Prospect on Refit page
    Then user should see the following values in the Refit Prospect form:
      | field           | value                                      |
      | Name            | RefitTest Automation AutoTestS3 (Director) |
      | Onboarding type | TempOB                                     |
      | Mobile          |                                 1234567890 |
      | Email           | testautomations+AutoTestS3@riskscreen.com  |
      | Prospect groups | AutomationTestGroup                        |
    And user store 'ProspectID' with keyName:'ProspectID' from 'Refit' page
    And user clicks on 'ShowOnBoardingDropDown' on 'Refit' page
    And user store 'OnBoardingID' with keyName:'OnBoardingID' from 'Refit' page
    And user clicks on 'AddExistingProspectButton' on 'Refit' page
    And user search Name : 'AutoTestS3', SearchOn : 'Last name', MatchType : 'Starts with' and ProspectStatus : 'All' on 'Refit' page
    And user wait until "ProspectSearchTable" process on "Refit" page is complete
    Then user should able to see "RefitTest Automation AutoTestS3" on "ProspectNames" on "Refit" page

  @ManageProspect4 @deleteOnboarding @deleteCreatedProspect
  Scenario: 004 Prospect details should be displayed after adding and should be visible on the Manage Prospect screen. #ENG-T9109,T1021
    When user store value:'615336' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add" and has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request and checks response status 201
    And user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add" and has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user adds payloads with stored keys:
      | Key                | StoredKey    |
      | ClientProspectID   | prospectID   |
      | ClientOnboardingID | onboardingID |
    And user sends a 'POST' request and checks response status 201
    And user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user adds payloads with stored keys:
      | Key                | StoredKey     |
      | ClientProspectID   | prospectID    |
      | ClientOnboardingID | onboardingID  |
      | DataRequestID      | dataRequestID |
    And user has a service named "/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink" and has a payload from the file 'dataRequest'
    And user adds payloads with stored keys:
      | Key                | StoredKey     |
      | ClientProspectID   | prospectID    |
      | ClientOnboardingID | onboardingID  |
      | DataRequestID      | dataRequestID |
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request and checks response status 200
    And user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutomationTestS4@riskscreen.com" email
    And user clicks on 'ManageProspectButton' on 'Refit' page
    And user clicks on 'AddExistingProspectButton' on 'Refit' page
    When user clicks on 'CreateProspectButton2' on 'Refit' page
    And user enter data in following fields in Refit DCF:
      | field             | value                                     |
      | FamilyName        | AutoTestS4                                |
      | FirstName         | RefitTest                                 |
      | OtherName         | Automation                                |
      | Email             | testautomations+AutoTestS4@riskscreen.com |
      | MobileNumber      |                                1234567890 |
      | ProspectReference | AutoTestS4                                |
    And user selects data in following fields in Refit DCF:
      | field                | value            |
      | ProspectRelationship | Director         |
      | OnboardingType       | TempOB           |
      | ParentProspect       | AutomationTestS4 |
    And user clicks on 'CreateProspectButton' on 'Refit' page
    And user clicks on the expand button of 'RefitTest Automation AutoTestS4 (Director)' Prospect on Refit page
    Then user should see the following values in the Refit Prospect form:
      | field           | value                                     |
      | Name            | RefitTest Automation AutoTestS4           |
      | Onboarding type | TempOB                                    |
      | Mobile          |                                1234567890 |
      | Email           | testautomations+AutoTestS4@riskscreen.com |
      | Prospect groups | AutomationTestGroup2                      |
    And user store 'ProspectID' with keyName:'ProspectID' from 'Refit' page
    And user clicks on 'ShowOnBoardingDropDown' on 'Refit' page
    And user store 'OnBoardingID' with keyName:'OnBoardingID' from 'Refit' page
    And user clicks on 'AddExistingProspectButton' on 'Refit' page
    And user search Name : 'AutoTestS4', SearchOn : 'Last name', MatchType : 'Starts with' and ProspectStatus : 'All' on 'Refit' page
    And user wait until "ProspectSearchTable" process on "Refit" page is complete
    Then user should able to see "RefitTest Automation AutoTestS4" on "ProspectNames" on "Refit" page
    Then user clicks add button of 'RefitTest Automation AutoTestS4' Prospect on Refit page
    Then user should see the following values in the Refit Prospect form before adding to group:
      | field           | value                                     |
      | Name            | RefitTest Automation AutoTestS4           |
      | Onboarding type | TempOB                                    |
      | Mobile          |                                1234567890 |
      | Email           | testautomations+AutoTestS4@riskscreen.com |

  @ManageProspect5 @deleteOnboarding
  Scenario: 005  Only onboarding types configured in Manage Externally Visible Onboarding Type Mappings should be visible in the dropdown when creating a prospect. #ENG-T9082,T1101,T4360,T1107,T4359,T1105,T4357,T1099
    When user store value:'615354' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add" and has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request and checks response status 201
    And user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add" and has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user adds payloads with stored keys:
      | Key                | StoredKey    |
      | ClientProspectID   | prospectID   |
      | ClientOnboardingID | onboardingID |
    And user sends a 'POST' request and checks response status 201
    And user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user adds payloads with stored keys:
      | Key                | StoredKey     |
      | ClientProspectID   | prospectID    |
      | ClientOnboardingID | onboardingID  |
      | DataRequestID      | dataRequestID |
    And user has a service named "/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink" and has a payload from the file 'dataRequest'
    And user adds payloads with stored keys:
      | Key                | StoredKey     |
      | ClientProspectID   | prospectID    |
      | ClientOnboardingID | onboardingID  |
      | DataRequestID      | dataRequestID |
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request and checks response status 200
    And user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutomationTestS5@riskscreen.com" email
    And user clicks on 'ManageProspectButton' on 'Refit' page
    And user clicks on 'CreateProspect' on 'Refit' page
    And user enter data in following fields in Refit DCF:
      | field             | value                                     |
      | FamilyName        | AutoTestS5                                |
      | FirstName         | RefitTest                                 |
      | OtherName         | Automation                                |
      | Email             | testautomations+AutoTestS5@riskscreen.com |
      | MobileNumber      |                                1234567890 |
      | ProspectReference | AutoTestS5None                            |
    And user selects data in following fields in Refit DCF:
      | field                | value            |
      | ProspectRelationship | (None)           |
      | OnboardingType       | testOBType       |
      | ParentProspect       | AutomationTestS5 |
    And user clicks on 'CreateProspectButton' on 'Refit' page
    And user clicks on 'CreateProspect' on 'Refit' page
    And user enter data in following fields in Refit DCF:
      | field             | value                                        |
      | FamilyName        | AutoTestS5                                   |
      | FirstName         | RefitTest2                                   |
      | OtherName         | Automation                                   |
      | Email             | testautomations+AutoTestS5Two@riskscreen.com |
      | MobileNumber      |                                   1234567890 |
      | ProspectReference | AutoTestS5Shareholder                        |
    And user selects data in following fields in Refit DCF:
      | field                | value             |
      | ProspectRelationship | Shareholder       |
      | OnboardingType       | AutocreationCheck |
      | ParentProspect       | AutomationTestS5  |
    And user clicks on 'CreateProspectButton' on 'Refit' page
    And user wait from 3 seconds
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutoTestS5None',selects SearchOn:'Interface reference' and select prospect from list
    And user delete onboarding and prospect
    And user enter SearchName:'AutoTestS5Shareholder',selects SearchOn:'Interface reference' and select prospect from list
    And user delete onboarding and prospect

  @ManageProspect6 @deleteOnboarding
  Scenario: 006 Prospect relationship dropdown should display all available relationships, and the Manage Prospect page should list already added prospects under the parent prospect.#ENG-T9107,T9089,T1093,T1077
    When user store value:'615376' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add" and has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request and checks response status 201
    And user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add" and has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user adds payloads with stored keys:
      | Key                | StoredKey    |
      | ClientProspectID   | prospectID   |
      | ClientOnboardingID | onboardingID |
    And user sends a 'POST' request and checks response status 201
    And user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user adds payloads with stored keys:
      | Key                | StoredKey     |
      | ClientProspectID   | prospectID    |
      | ClientOnboardingID | onboardingID  |
      | DataRequestID      | dataRequestID |
    And user has a service named "/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink" and has a payload from the file 'dataRequest'
    And user adds payloads with stored keys:
      | Key                | StoredKey     |
      | ClientProspectID   | prospectID    |
      | ClientOnboardingID | onboardingID  |
      | DataRequestID      | dataRequestID |
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request and checks response status 200
    And user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutomationTestS6One@riskscreen.com" email
    And user clicks on 'ManageProspectButton' on 'Refit' page
    And user clicks on 'CreateProspect' on 'Refit' page
    Then user should see "(None),Shareholder,Director" options in dropdown "ProspectRelationship" on "Refit" page
    And user should see "AutocreationCheck,testOBType" options in dropdown "OnboardingType" on "Refit" page
    And user should see "AutomationTestS6One,AutomationTestS6Two,AutomationTestS6Three" options in dropdown "ParentProspect" on "Refit" page
    #Defect Raised #ENG-T8642

  @ManageProspect7
  Scenario: 007 A nominee should not be able to add a prospect when disabled by another nominee. #ENG-T1061
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitAutomation2' OB type on 'OnboardingType' page
    And user clicks on 'DataCollectionLink' on 'OnboardingType' page
    Then user should see "Sequential" option selected on "NomineeDataCollectionType" on "OnboardingType" page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutomationTestS7',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text "Data Collection Requests" on Onboarding page
    And user clicks on 'Nominees' on 'Prospect' page
    And user clicks on 'Nominee1SendButton' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+AutomationTestS7N1@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    When user clicks on edit button of 'testautomations+AutomationTestS7N2@riskscreen.com' nominee on Refit page
    Then user should see checkbox 'Unchecked' on 'NotifyProspect' on 'Refit' page
    And user should see checkbox 'Checked' on 'AllowManageNominees' on 'Refit' page
    And user should see checkbox 'Unchecked' on 'AllowManageProspects' on 'Refit' page
    When user clicks on 'GoBackButton' on 'Refit' page
    And user clicks on send request button of 'testautomations+AutomationTestS7N2@riskscreen.com' nominee on Refit page
    And user clicks on "CopyLinkToFormButton" button and navigates to the link in "DataCollectionLinkContainer" on "Refit" page waiting until "Loading..." is gone
    And user enter OTP received on "testautomations+AutomationTestS7N2@riskscreen.com"
    Then user should not see "ManageProspectButton" on "Refit" page
    When user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    When user clicks on edit button of 'testautomations+AutomationTestS7N3@riskscreen.com' nominee on Refit page
    Then user should see checkbox 'Unchecked' on 'NotifyProspect' on 'Refit' page
    And user should see checkbox 'Checked' on 'AllowManageNominees' on 'Refit' page
    And user should see checkbox 'Checked' on 'AllowManageProspects' on 'Refit' page
    When user clicks on 'GoBackButton' on 'Refit' page
    And user clicks on send request button of 'testautomations+AutomationTestS7N3@riskscreen.com' nominee on Refit page
    And user clicks on "CopyLinkToFormButton" button and navigates to the link in "DataCollectionLinkContainer" on "Refit" page waiting until "Loading..." is gone
    And user enter OTP received on "testautomations+AutomationTestS7N3@riskscreen.com"
    Then user should able see "ManageProspectButton" on "Refit" page

  @ManageProspect8
  Scenario: 008 Manage prospect button should be displayed in external form given Nominee and Prospect permission are enabled and any OR no PGs are assigned to the Nominee. #ENG-T1063
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitAutomation2' OB type on 'OnboardingType' page
    And user clicks on 'DataCollectionLink' on 'OnboardingType' page
    Then user should see "Sequential" option selected on "NomineeDataCollectionType" on "OnboardingType" page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutomationTestS8',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text "Data Collection Requests" on Onboarding page
    And user clicks on 'Nominees' on 'Prospect' page
    And user clicks on 'Nominee1SendButton' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+AutomationTestS8N1@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    When user clicks on edit button of 'testautomations+AutomationTestS8N2@riskscreen.com' nominee on Refit page
    Then user should see checkbox 'Unchecked' on 'NotifyProspect' on 'Refit' page
    And user should see checkbox 'Checked' on 'AllowManageNominees' on 'Refit' page
    And user should see checkbox 'Unchecked' on 'AllowManageProspects' on 'Refit' page
    And user should see checkbox 'Unchecked' on 'Group1CheckBox' on 'Refit' page
    And user should see checkbox 'Unchecked' on 'Group2CheckBox' on 'Refit' page
    When user clicks on 'GoBackButton' on 'Refit' page
    And user clicks on send request button of 'testautomations+AutomationTestS8N2@riskscreen.com' nominee on Refit page
    And user clicks on "CopyLinkToFormButton" button and navigates to the link in "DataCollectionLinkContainer" on "Refit" page waiting until "Loading..." is gone
    And user enter OTP received on "testautomations+AutomationTestS8N2@riskscreen.com"
    Then user should not see "ManageProspectButton" on "Refit" page

  @ManageProspect9 @deleteOnboarding
  Scenario: 009 Allow Manage Prospect permission should work dependent on Manage Nominee Permission #ENG-T1064, #ENG-T1075,T1061
    When user store value:'615385' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add" and has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request and checks response status 201
    And user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add" and has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    When user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    # Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutomationTestS5@riskscreen.com" email
    And user shares form with email "testautomations+ManageNomineeS1@riskscreen.com" and saves nominee on 'Refit' page
    And user selects checkboxes "AllowManageNomineesCheckbox, AllowManageProspectsCheckbox" on share form using send button "NomineePlacardSendRequestButton" and stores link as "NomineeDCFLink" on 'Refit' page
    And user navigates to URL with the stored key value "NomineeDCFLink"
    When user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutomationTestS5@riskscreen.com" email
    Then user should able see 'ShareThisFormButton' on 'Refit' page
    And user should able see 'ManageProspectButton' on 'Refit' page
    And user shares form with email "testautomations+ManageNomineeS1@riskscreen.com" and saves nominee on 'Refit' page
    And user selects checkboxes "AllowManageProspectsCheckbox" on share form using send button "NomineePlacardSendRequestButton2" and stores link as "Nominee2DCFLink" on 'Refit' page
    And user navigates to URL with the stored key value "Nominee2DCFLink"
    Then user should not able see 'ShareThisFormButton' on 'Refit' page
    And user should not able see 'ManageProspectButton' on 'Refit' page

  @ManageProspect10 @deleteOnboarding @deleteCreatedProspect
  Scenario: 006   Display "Manage Prospect" button to a nominee only when both "Allow Nominee" and "Allow Prospect" permissions are enabled. #ENG-T9184,T1064,T4321,T1065,T4325
    When user store value:'615385' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add" and has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request and checks response status 201
    And user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add" and has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    When user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    # Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutomationTestS5@riskscreen.com" email
    And user shares form with email "testautomations+ManageNomineeS1@riskscreen.com" and saves nominee on 'Refit' page
    And user selects checkboxes "AllowManageNomineesCheckbox, AllowManageProspectsCheckbox" on share form using send button "NomineePlacardSendRequestButton" and stores link as "NomineeDCFLink" on 'Refit' page
    And user navigates to URL with the stored key value "NomineeDCFLink" and enter OTP received on "testautomations+ManageNomineeS1@riskscreen.com" email
    Then user should able see 'ShareThisFormButton' on 'Refit' page
    And user should able see 'ManageProspectButton' on 'Refit' page

  @deleteDataRequest @ManageProspect11
  Scenario: 011 Prospect accesses the DCF externally and submit the form, then handler user verifies data and delete Data collection request #ENG-T558,T4717,T6311,T5660
    When user store value:'616523' with keyName:'prospectID'
    And user store value:'355071' with keyName:'onboardingID'
    And user creates a data request and collection link for prospect "616523" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutomationExternallyFrom@riskscreen.com" email
    Then user should see progress bar percentage: "0% complete"
    And user should see PropertyGroup Name:"AutomationGroup"
    When user enter "GroupOne" text in "Group1TextField" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on "ContinueButton" on "Refit" page
    Then user should see PropertyGroup Name:"AutomationGroupTwo"
    When user enter "GroupTwo" text in "Group2TextField1" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on "ContinueButton" on "Refit" page
    And user clicks on 'FormSubmissionCheckbox' on 'Refit' page
    And user clicks on 'SubmitButtons' on 'Refit' page
    And user waits until submission process is completed
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user selects "12" Business Unit
    And user enter SearchName:'AutomationExternallyFrom',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataApprovalLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Risk Assessment' on Onboarding page
    Then user should see the following values in Risk assessment table:
      | Field                              | Value   |
      | AutomationGroupProperty            | Integer |
      | AutomationGroupRiskScore           |      25 |
      | AutomationGroupRiskWeighting       |    100% |
      | AutomationGroupRiskWeightingOutput |      25 |
      | TotalRiskScoreSHV                  |      25 |
      | TotalPossibleRiskScoreSHV          |     100 |
      | NormalisedRiskScoreD               |     25% |
      | NormalisedRiskScoreBandD           | Low     |
    When user clicks on Onboarding Stage Tab with text 'Data Approval' on Onboarding page
    Then user should see property group name one :"GroupOne" and property group name two :"GroupTwo"
    When user clicks on 'RejectOnboardingButton' on 'ManageProspect' page
    And user clears field on :"PropertyGroupNameOne" on "Prospect" page
    And user clears field on :"PropertyGroupNameTwo" on "Prospect" page
    And user clicks on 'SaveOnBoardingDataButton' on 'Onboarding' page

  # @ManageProspect12
  # Scenario: 012 The link in notification email should navigate the prospect to the 1st section of submitted sections of the complete DCF #ENG-T2310,T2304,T2307,T2306
  #   When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
  #   And user enter SearchName:'NomineeCheck',selects SearchOn:'Last name' and select prospect from list
  #   And user clicks on 'DataCollectionLink' on 'ManageProspect' page
  #   And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
  #   And user clicks on 'SendLink' on 'ManageProspect' page
  #   And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
  #   And user get the data link and open
  #   And user enter OTP received on "testautomations+NomineeCheck@riskscreen.com"
  #   And user clicks on 'ShareThisFormButton' on 'Refit' page
  #   When user clicks on 'AddPeopleButton' on 'Refit' page
  #   When user enter "testautomations+NomineeCheckNominee1@riskscreen.com" text in "EmailTextField" field on "Refit" page
  #   And user clicks on "NewNomineeSaveButton" on "Refit" page
  #   And user enter "Nominee 1" text in "EmailMessageBody" field on "Refit" page
  #   And user clicks on "SaveChanges" on "Refit" page
  #   #Waiting for Email Configuration done for DomainTest BU.

  @ManageProspect13 @deleteOnboarding
  Scenario: 013 SERV2964 - If no data entered in the LN DC property, then prospect name should not be updated #ENG-T8368
    When user creates an onboarding for prospect "616557" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616557" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+ProspectNameNotUpdateDoNotTouch@riskscreen.com" email
    When user enter "First Name" text in "Group1TextField" field on "Refit" page
    And user enter "Middle Name" text in "Group1TextField2" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on "ContinueButton" on "Refit" page
    And user clicks on "FormSubmissionCheckbox" on "Refit" page
    And user clicks on "FormSubmitButton" on "Refit" page
    And user waits until submission process is completed
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ProspectNameNotUpdateDoNotTouch',selects SearchOn:'Last name' and select prospect from list
    And user clicks on "DataApprovalLink" on "ManageProspect" page
    Then user should see "The mapped Last Name property does not contain data. The Prospect's name will not be updated. Please verify the customer's name details are correct." on "AlertWarning" on "Refit" page
    When user clicks on 'RejectOnboardingButton' on 'ManageProspect' page

  @ManageProspect14 @deleteOnboarding
  Scenario: 014 Prospect Reference field should accept input up to 50 characters via Manage prospect external DCF. #ENG-T10138
    When user creates an onboarding for prospect "616564" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616564" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutomationTest1@riskscreen.com" email
    And user clicks on "ManageProspectButton" on "Refit" page
    And user clicks on "CreateProspect" on "Refit" page
    And user enter data in following fields in Refit DCF:
      | field      | value                                            |
      | FamilyName | AutoTestS14                                      |
      | Email      | testautomations+AutomationTestS14@riskscreen.com |
    And user send "51" characters to "ProspectReference" textfield on "Refit" page
    And user selects data in following fields in Refit DCF:
      | field                | value                        |
      | ProspectRelationship | (None)                       |
      | OnboardingType       | AutomationIncreaseCharLimit2 |
      | ParentProspect       | AutomationTest1              |
    And user clicks on 'CreateProspectButton' on 'Refit' page
    And user clicks on the expand button of 'AutoTestS14' Prospect on Refit page
    And user click on View Onboarding button of 'AutoTestS14' prospect
    Then user should see the following values in the Refit Prospect form:
      | field           | value                                            |
      | Name            | AutoTestS14                                      |
      | Onboarding type | AutomationIncreaseCharLimit2                     |
      | Email           | testautomations+AutomationTestS14@riskscreen.com |
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutoTestS14',selects SearchOn:'Last name' and select prospect from list
    Then user should see 50 characters on "ProspectReference" textfield on "Prospect" page
    And user delete onboarding and prospect

  @ManageProspect15 @deleteOnboarding
  Scenario: 015 Data Collection banner on Onboarding report should work as expected #ENG-T3285,T3286
    When user creates an onboarding for prospect "616600" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616600" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+bannerCheckProspect@riskscreen.com" email
    And user enter "GroupOne" text in "Group1TextField" field on "Refit" page
    And user enter "10" text in "Group1TextField2" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on "ContinueButton" on "Refit" page
    And user clicks on "FormSubmissionCheckbox" on "Refit" page
    And user clicks on "FormSubmitButton" on "Refit" page
    And user waits until submission process is completed
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'bannerCheckProspect',selects SearchOn:'Last name' and select prospect from list
    And user clicks on "DataApprovalLink" on "ManageProspect" page
    And user clicks on "ViewOnboardingReportButton" on "Onboarding" page
    #Defect Raised #ENG-9614

  @ManageProspect16 @deleteOnboarding
  Scenario: 016 Validate send recipient options and send DCF link to prospect  #ENG-T12198,T12199
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'SendRecipentOption',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user creates a data request
    And user clicks on Onboarding Stage Tab with text "Data Collection Requests" on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    Then user should see "Prospect: testautomations+SendRecipentOption@riskscreen.com,Staff: shantanuchikerur+stgloadtestrefit@kyc360.com" options in dropdown "SendLinkTo" on "Onboarding" page
    When user select "Prospect: testautomations+SendRecipentOption@riskscreen.com" option in "SendLinkTo" dropdown on "Onboarding" page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+SendRecipentOption@riskscreen.com"
    And user enter "Text" text in "Group1TextField" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on "ContinueButton" on "Refit" page
    And user clicks on "FormSubmissionCheckbox" on "Refit" page
    And user clicks on "FormSubmitButton" on "Refit" page
    And user waits until submission process is completed
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'SendRecipentOption',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataApprovalLink' on 'ManageProspect' page
    And user clicks on 'RejectOnboardingButton' on 'ManageProspect' page
    And user deletes a data request