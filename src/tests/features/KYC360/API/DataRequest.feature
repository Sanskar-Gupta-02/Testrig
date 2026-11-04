@Sanity @Regression @dataRequest
Feature: Happy Path- Data request

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to create Data request
    Given user has a service named '/api/v1/client/prospect/add'
    And user has a payload from the file 'prospect'
    And user has payloads:
      """
      {
        "InterfaceReference": "dataRequestProspect"
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientProspectID" with keyName:"prospectID"
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
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "dataRequest"
    And response body should have key with the values from "dataRequest" file
      | key            |
      | BusinessUnitID |
      | Message        |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"

  Scenario: 002 shuld be able fetch data request
    Given user has a service named '/api/v1/client/onboardingdatarequest/get'
    And user has a query params from the file 'dataRequest' with selected keys 'BusinessUnitID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    And user add query parameter 'DataRequestID' with the stored key value 'dataRequestID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "dataRequest"
    And response body should have key with the values from "dataRequest" file
      | key            |
      | BusinessUnitID |
      | Message        |
    And response body should have key "ExpiryDate" with tomorrow date
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"

  Scenario: 003 shold be able to update data request
    Given user has a service named '/api/v1/client/onboardingdatarequest/update'
    And user has a payload from the file 'updatedDataRequest'
    And user add "DataRequestedOn" with today date
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "updatedDataRequest"
    And response body should have key with the values from "updatedDataRequest" file
      | key             |
      | BusinessUnitID  |
      | EmailTemplateID |
      | Message         |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should have key "DataRequestID" with the stored key value "dataRequestID"

  Scenario: 004 should be able to fetch updated data request
    Given user has a service named '/api/v1/client/onboardingdatarequest/get'
    And user has a query params from the file 'dataRequest' with selected keys 'BusinessUnitID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    And user add query parameter 'DataRequestID' with the stored key value 'dataRequestID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "updatedDataRequest"
    And response body should have key with the values from "updatedDataRequest" file
      | key             |
      | BusinessUnitID  |
      | EmailTemplateID |
      | Message         |
    And response body should have key "DataRequestedOn" with today date
    And response body should have key "ExpiryDate" with tomorrow date
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"

  Scenario: 005 should be able to add second data request
    Given user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "dataRequest"
    And response body should have key with the values from "dataRequest" file
      | key            |
      | BusinessUnitID |
      | Message        |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    When user store the response body keyData:"DataRequestID" with keyName:"secondDataRequestID"

  Scenario: 006 should be able to fetch all data requests
    Given user has a service named '/api/v1/client/onboardingdatarequest/getall'
    And user has a query params from the file 'dataRequest' with selected keys 'BusinessUnitID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "fetchDataRequests"
    And response body should have index key with values from file "fetchDataRequests"
      | index | key             |
      |     1 | BusinessUnitID  |
      |     1 | Message         |
      |     1 | EmailTemplateID |
      |     2 | BusinessUnitID  |
      |     2 | Message         |

  Scenario: 007 Should be able to send data collection request
    Given user has a service named '/api/v1/client/onboardingdatarequest/send'
    And user has a payload from the file 'dataRequestSend'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    When user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "dataRequestSend"
    And response body should have key with keys from 'dataRequestSend' file
      | keyFromResponse | keyFromFile     |
      | BusinessUnitID  | BusinessUnitID  |
      | ProspectEmail   | SendEmailLinkTo |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should have key "DataRequestID" with the stored key value "dataRequestID"

  Scenario: 008 should be able to generate data collection link
    Given user has a service named '/api/v1/client/onboardingdatarequest/send'
    And user has a payload from the file 'dataRequestSend'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    When user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "dataRequestSend"

  Scenario: 009 should be able to delete data request
    Given user has a service named '/api/v1/client/onboardingdatarequest/delete'
    And user has a query params from the file "dataRequest" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add query parameter "ClientProspectID" with the stored key value "prospectID"
    And user add query parameter "ClientOnboardingID" with the stored key value "onboardingID"
    And user add query parameter "DataRequestID" with the stored key value "dataRequestID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "dataRequestSend"
    And response body should have key with the values from "dataRequest" file
      | key            |
      | BusinessUnitID |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should have key "DataRequestID" with the stored key value "dataRequestID"

  Scenario: 010 Should be able to delete onboardings
    Given user has a service named "/api/v1/client/onboarding/delete"
    And user has a query params from the file 'onboarding' with selected keys 'OnboardingTypeID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    When user sends a 'Delete' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboarding"

  Scenario: 011 Should be able to delete prospect
    Given user has a service named "/api/v1/client/prospect/delete"
    And user has a payload from the file "prospect" with selected keys "OnboardingTypeID,ActionUserID,ReturnFormat"
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    When user sends a 'Delete' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "prospect"
