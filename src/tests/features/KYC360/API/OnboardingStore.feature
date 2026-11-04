@Regression @OnboardingStore
Feature: Onboarding Store API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add Onboarding
    Given user has a service named "/api/v1/client/prospect/add"
    And user has a payload from the file 'prospect'
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value                     |
      | BusinessUnitID            |                        10 |
      | OnboardingTypeID          |                       695 |
      | HandledByGroupID          |                       325 |
      | HandledByUserID           |                       521 |
      | HandledBySupervisorUserID |                       547 |
      | HandledByManagerUserID    |                       532 |
      | HandledByDirectorUserID   |                       531 |
      | InterfaceReference        | PlaywrightAutomation123   |
      | LastName                  | AddedProspect             |
      | FirstName                 | API                       |
      | Email                     | krunallute@riskscreen.com |
      | AllowKYBLookup            | true                      |
    And response body should match the schema from the file "prospect"
    When user store the response body keyData:"ClientProspectID" with keyName:"prospectID"
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                          | value           |
      | BusinessUnitID               |              10 |
      | OnboardingStageID            |               1 |
      | OnboardingStatus             |               1 |
      | OnboardingTypeID             |             695 |
      | ProspectHandledByUserGroupID |             325 |
      | ProspectHandledByUserID      |             521 |
      | EIDVUUIDReference            |                 |
      | Notes                        | Automation Note |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"

  Scenario: 002 Should be able to add Onboarding Store
    Given user has a service named "/api/v1/client/onboardingstore/add"
    When user has a payload from the file 'onboardingStore'
    And user has payloads:
      """
      {
          "OnboardingPropertyID":"121756",
          "StoreID":"1",
          "Text":"Riskscreen"
      }
      """
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value      |
      | BusinessUnitID            |         10 |
      | OnboardingPropertyGroupID |      59257 |
      | OnboardingPropertyID      |     121756 |
      | StoreID                   |          1 |
      | Text                      | Riskscreen |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboardingStore"
    When user has a payload from the file 'onboardingStore'
    And user has payloads:
      """
      {
          "OnboardingPropertyID":"121757",
          "StoreID":2,
          "Integer":25
      }
      """
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value  |
      | BusinessUnitID            |     10 |
      | OnboardingPropertyGroupID |  59257 |
      | OnboardingPropertyID      | 121757 |
      | StoreID                   |      2 |
      | Integer                   |     25 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboardingStore"
    When user has a payload from the file 'onboardingStore'
    And user has payloads:
      """
      {
          "OnboardingPropertyID":"121758",
          "StoreID":3,
          "Decimal":3.6
      }
      """
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value  |
      | BusinessUnitID            |     10 |
      | OnboardingPropertyGroupID |  59257 |
      | OnboardingPropertyID      | 121758 |
      | StoreID                   |      3 |
      | Decimal                   |    3.6 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboardingStore"
    When user has a payload from the file 'onboardingStore'
    And user has payloads:
      """
      {
          "OnboardingPropertyID":"121759",
          "StoreID":4,
          "Date":"<currentDateStamp>"
      }
      """
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value                       |
      | BusinessUnitID            |                          10 |
      | OnboardingPropertyGroupID |                       59257 |
      | OnboardingPropertyID      |                      121759 |
      | StoreID                   |                           4 |
      | Date                      | <currentDateStamp> 00:00:00 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboardingStore"
    When user has a payload from the file 'onboardingStore'
    And user has payloads:
      """
      {
          "OnboardingPropertyID":"121760",
          "StoreID":5,
          "ListGroupID": "33333",
          "ListDataID": "39879"
      }
      """
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value  |
      | BusinessUnitID            |     10 |
      | OnboardingPropertyGroupID |  59257 |
      | OnboardingPropertyID      | 121760 |
      | StoreID                   |      5 |
      | ListGroupID               |  33333 |
      | ListDataID                |  39879 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboardingStore"

  Scenario: 003 Should be able to submit for approval an Onboarding
    Given user has a service named "/api/v1/client/onboarding/submitforapproval"
    And user has a payload from the file "onboarding" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value |
      | BusinessUnitID |    10 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboarding"
    When user store the response body keyData:"OnboardingStageID" with keyName:"onboardingStageId"

  Scenario: 004 Should be able to get onboarding after submit
    Given user has a service named "/api/v1/client/onboarding/get"
    And user has a query params from the file 'onboarding' with selected keys 'OnboardingTypeID,IncludeDocumentData,ReturnEncodedValues,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                          | value |
      | BusinessUnitID               |    10 |
      | OnboardingStatus             |     1 |
      | OnboardingTypeID             |   695 |
      | ProspectHandledByUserGroupID |   325 |
      | ProspectHandledByUserID      |   521 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should have key "OnboardingStageID" with the stored key value "onboardingStageId"
    And response body should match the schema from the file "onboarding"

  Scenario: 005 Should be able initiate screening of an Onboarding
    Given user has a service named "/api/v1/client/onboarding/initiatescreening"
    And user has a payload from the file "onboarding" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value |
      | BusinessUnitID |    10 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboarding"
    When user store the response body keyData:"OnboardingStageID" with keyName:"onboardingStageId"
    And user store the response body keyData:"OnboardingStatus" with keyName:"onboardingStatus"

  Scenario: 006 Should be able to get onboarding after screening
    Given user has a service named "/api/v1/client/onboarding/get"
    And user has a query params from the file 'onboarding' with selected keys 'OnboardingTypeID,IncludeDocumentData,ReturnEncodedValues,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                          | value |
      | BusinessUnitID               |    10 |
      | OnboardingTypeID             |   695 |
      | ProspectHandledByUserGroupID |   325 |
      | ProspectHandledByUserID      |   521 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should have key "OnboardingStageID" with the stored key value "onboardingStageId"
    And response body should have key "OnboardingStatus" with the stored key value "onboardingStatus"
    And response body should match the schema from the file "onboarding"

  Scenario: 007 Should be able to export an onboarding
    Given user has a service named "/api/v1/client/onboarding/export"
    And user has a query params from the file 'onboarding' with selected keys 'BusinessUnitID,OnboardingTypeID,IncludeDocumentData,ReturnEncodedValues,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value |
      | BusinessUnitID            |    10 |
      | Prospect.OnboardingTypeID |   695 |
      | Prospect.HandledByGroupID |   325 |
      | Prospect.HandledByUserID  |   521 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should have key "OnboardingStage" with the stored key value "onboardingStageId"
    And response body should have key "OnboardingStatus" with the stored key value "onboardingStatus"
    And response body should match the schema from the file "onboardingExport"

  Scenario: 008 Should be able to delete an onboarding
    Given user has a service named "/api/v1/client/onboarding/delete"
    And user has a query params from the file 'onboarding' with selected keys 'OnboardingTypeID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    When user sends a 'Delete' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboarding"

  Scenario: 009 Should be able to delete prospect
    Given user has a service named "/api/v1/client/prospect/delete"
    And user has a payload from the file "prospect" with selected keys "OnboardingTypeID,ActionUserID,ReturnFormat"
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    When user sends a 'Delete' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "prospect"
