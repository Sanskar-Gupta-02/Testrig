@Regression @ListGroups
Feature: List Groups

  Background:
    Given user login into 'REFIT' application with 'HandlerUserName' user
    And user is authorized using an 'APIKEY'

  @deleteOnboarding @ListGroups1
  Scenario: 001 Sort dropdown works as intended for Name-Alphabetical, Reference-Alphabetical #ENG-T3856
    When user navigate to 'AutomationListGroup' List Group
    And user select "Name-Alphabetical" option in "SortBy" dropdown on "ListGroups" page
    And user clicks on 'UpdateListGroup' on 'ListGroups' page
    Then user should see success banner with message 'List group updated successfully.'
    When user navigate to 'AutomationListGroup' List Group
    And user enter "1" text in "HeaderRows" field on 'ListGroups' page
    And user upload 'AutomationListGroupAlphabetical.xlsx' file on 'UploadListData' on 'ListGroups' page
    And user clicks on 'ImportListData' on 'ListGroups' page
    Then user should see success banner with message 'File Imported successfully'
    When user store List Data Ids
    And user store value:'616208' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
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
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL in new tab with the stored key value 'dataRequestLink' and enter OTP received on 'testautomations+ListGroup01@riskscreen.com' email
    Then user should see "Aurangabad,Mumbai,Nashik,Pune" options in dropdown "Group1Property1" on "Refit" page in same order
    When user switch to 'Welcome to KYC360 (TEST)' page
    When user delete onboarding with stored key value 'onboardingID'
    And user switch to 'Welcome to KYC360 (TEST)' page
    And user navigate to 'AutomationListGroup' List Group
    And user select "Reference-Alphabetical" option in "SortBy" dropdown on "ListGroups" page
    And user clicks on 'UpdateListGroup' on 'ListGroups' page
    Then user should see success banner with message 'List group updated successfully.'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
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
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL in new tab with the stored key value 'dataRequestLink' and enter OTP received on 'testautomations+ListGroup01@riskscreen.com' email
    Then user should see "Mumbai,Pune,Nashik,Aurangabad" options in dropdown "Group1Property1" on "Refit" page in same order
    When user delete List Data of '34669' List Group with stored IDs

@deleteOnboarding @ListGroups2
Scenario: 002 Sort dropdown works as intended for Name-Numerical, Reference-Numerical, ID-Numerical, Sort Order #ENG-T3856
    When user navigate to 'AutomationListGroup2' List Group
    And user select "Name-Numerical" option in "SortBy" dropdown on "ListGroups" page
    And user clicks on 'UpdateListGroup' on 'ListGroups' page
    Then user should see success banner with message 'List group updated successfully.'
    When user navigate to 'AutomationListGroup2' List Group
    And user enter "1" text in "HeaderRows" field on 'ListGroups' page
    And user upload 'AutomationListGroupNumerical.xlsx' file on 'UploadListData' on 'ListGroups' page
    And user clicks on 'ImportListData' on 'ListGroups' page
    Then user should see success banner with message 'File Imported successfully'
    When user store List Data Ids
    When user creates an onboarding for prospect "616219" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616219" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+ListGroup02@riskscreen.com" email
    Then user should see "13674,14145,76328,89237" options in dropdown "Group1Property1" on "Refit" page in same order
    When user switch to 'Welcome to KYC360 (TEST)' page
    And user delete onboarding with stored key value 'onboardingID'
    And user switch to 'Welcome to KYC360 (TEST)' page
    And user navigate to 'AutomationListGroup2' List Group
    And user select "Reference-Numerical" option in "SortBy" dropdown on "ListGroups" page
    And user clicks on 'UpdateListGroup' on 'ListGroups' page
    Then user should see success banner with message 'List group updated successfully.'
    When user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
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
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL in new tab with the stored key value 'dataRequestLink' and enter OTP received on 'testautomations+ListGroup01@riskscreen.com' email
    Then user should see "45178,46819,76348,80912" options in dropdown "Group1Property1" on "Refit" page in same order
    When user switch to 'Welcome to KYC360 (TEST)' page
    When user delete onboarding with stored key value 'onboardingID'
    And user switch to 'Welcome to KYC360 (TEST)' page
    And user navigate to 'AutomationListGroup2' List Group
    And user select "ID-Numerical" option in "SortBy" dropdown on "ListGroups" page
    And user clicks on 'UpdateListGroup' on 'ListGroups' page
    Then user should see success banner with message 'List group updated successfully.'
    When user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
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
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL in new tab with the stored key value 'dataRequestLink' and enter OTP received on 'testautomations+ListGroup01@riskscreen.com' email
    Then user should see "14145,89237,76328,13674" options in dropdown "Group1Property1" on "Refit" page in same order
    When user delete List Data of '34671' List Group with stored IDs