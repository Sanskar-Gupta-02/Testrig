@Regression @OnboardingStage
Feature: Onboarding Store API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add Onboarding stage for awaiting approval prospect
    Given user has a service named "/api/v1/client/prospect/add"
    And user has a payload from the file 'prospect'
    And user store the unique value for key:
      | key                |
      | interfaceReference |
      | firstName          |
      | lastName           |
    And user add payload key with stored key value:
      | payloadKey         | storedkey          |
      | InterfaceReference | interfaceReference |
      | FirstName          | firstName          |
      | LastName           | lastName           |
    When user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientProspectID" with keyName:"prospectID"
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user has payloads:
      """
      {
          "OnboardingStageID": "6",
          "OnboardingStatus": "1",
          "AssessedRiskValue": "0",
          "WeightedRiskScore": "12",
          "WeightedRiskScoreBand": "Medium",
          "WeightedRiskScoreOverriden": "True"
      }
      """
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingstage/add"
    And user has a payload from the file 'onboardingStage'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user has payloads:
      """
      {
          "StageDate": "<currentDateStamp>",
          "HandlerAuthorisationDate": "<currentDateStamp>",
          "Supervisor1AuthorisationDate": "<currentDateStamp>",
          "Supervisor2AuthorisationDate": "<currentDateStamp>",
          "Manager1AuthorisationDate": "<currentDateStamp>",
          "Manager2AuthorisationDate": "<currentDateStamp>",
          "DirectorAuthorisationDate": "<currentDateStamp>",
          "OnboardingStageID": "6",
          "OnboardingStatus": "1"
      }
      """
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                            | value                       |
      | BusinessUnitID                 |                          10 |
      | OnboardingStageID              |                           6 |
      | HandlerNotes                   | Auto-Handler                |
      | HandlerUserID                  |                         521 |
      | HandlerAuthorisationStatus     |                           1 |
      | HandlerAuthorisationDate       | <currentDateStamp> 00:00:00 |
      | Supervisor1Notes               | Auto-Supervisor1            |
      | Supervisor1UserID              |                         547 |
      | Supervisor1AuthorisationStatus |                           1 |
      | Supervisor1AuthorisationDate   | <currentDateStamp> 00:00:00 |
      | Supervisor2Notes               | Auto-Supervisor2            |
      | Supervisor2UserID              |                         547 |
      | Supervisor2AuthorisationStatus |                           1 |
      | Supervisor2AuthorisationDate   | <currentDateStamp> 00:00:00 |
      | Manager1Notes                  | Auto-Manager1               |
      | Manager1UserID                 |                         532 |
      | Manager1AuthorisationStatus    |                           0 |
      | Manager1AuthorisationDate      | <currentDateStamp> 00:00:00 |
      | Manager2Notes                  | Auto-Manager2               |
      | Manager2UserID                 |                         532 |
      | Manager2AuthorisationStatus    |                           0 |
      | Manager2AuthorisationDate      | <currentDateStamp> 00:00:00 |
      | DirectorNotes                  | Auto-Director               |
      | DirectorUserID                 |                         531 |
      | DirectorAuthorisationStatus    |                           0 |
      | DirectorAuthorisationDate      | <currentDateStamp> 00:00:00 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboardingStage"
    And user store the response body keyData:"UniqueID" with keyName:"uniqueID"

  Scenario: 002 Should be able to update Onboarding stage for awaiting approval prospect
    Given user has a service named "/api/v1/client/onboardingstage/update"
    And user has a payload from the file 'onboardingStage'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "UniqueID" with the stored key value "uniqueID"
    And user has payloads:
      """
      {
          "OnboardingStageID": "6",
          "OnboardingStatus": "1",
          "Manager1AuthorisationStatus": "1",
          "Manager2AuthorisationStatus": "1",
          "DirectorAuthorisationStatus": "1",
          "StageDate": "<currentDateStamp>",
          "HandlerAuthorisationDate": "<currentDateStamp>",
          "Supervisor1AuthorisationDate": "<currentDateStamp>",
          "Supervisor2AuthorisationDate": "<currentDateStamp>",
          "Manager1AuthorisationDate": "<currentDateStamp>",
          "Manager2AuthorisationDate": "<currentDateStamp>",
          "DirectorAuthorisationDate": "<currentDateStamp>"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                            | value                       |
      | BusinessUnitID                 |                          10 |
      | OnboardingStageID              |                           6 |
      | HandlerNotes                   | Auto-Handler                |
      | HandlerUserID                  |                         521 |
      | HandlerAuthorisationStatus     |                           1 |
      | HandlerAuthorisationDate       | <currentDateStamp> 00:00:00 |
      | Supervisor1Notes               | Auto-Supervisor1            |
      | Supervisor1UserID              |                         547 |
      | Supervisor1AuthorisationStatus |                           1 |
      | Supervisor1AuthorisationDate   | <currentDateStamp> 00:00:00 |
      | Supervisor2Notes               | Auto-Supervisor2            |
      | Supervisor2UserID              |                         547 |
      | Supervisor2AuthorisationStatus |                           1 |
      | Supervisor2AuthorisationDate   | <currentDateStamp> 00:00:00 |
      | Manager1Notes                  | Auto-Manager1               |
      | Manager1UserID                 |                         532 |
      | Manager1AuthorisationStatus    |                           1 |
      | Manager1AuthorisationDate      | <currentDateStamp> 00:00:00 |
      | Manager2Notes                  | Auto-Manager2               |
      | Manager2UserID                 |                         532 |
      | Manager2AuthorisationStatus    |                           1 |
      | Manager2AuthorisationDate      | <currentDateStamp> 00:00:00 |
      | DirectorNotes                  | Auto-Director               |
      | DirectorUserID                 |                         531 |
      | DirectorAuthorisationStatus    |                           1 |
      | DirectorAuthorisationDate      | <currentDateStamp> 00:00:00 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should have key "UniqueID" with the stored key value "uniqueID"
    And response body should match the schema from the file "onboardingStage"

  Scenario: 003 Should be able to get an onboarding stage for awaiting approval prospect
    Given user has a service named "/api/v1/client/onboardingstage/get"
    And user has a query params from the file 'onboardingStage' with selected keys 'BusinessUnitID,ReturnFormat'
    And user has query parameters:
      """
      {
          "StageID":"6"
      }
      """
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    And user add query parameter 'UniqueID' with the stored key value 'uniqueID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                            | value                       |
      | BusinessUnitID                 |                          10 |
      | OnboardingStageID              |                           6 |
      | HandlerNotes                   | Auto-Handler                |
      | HandlerUserID                  |                         521 |
      | HandlerAuthorisationStatus     |                           1 |
      | HandlerAuthorisationDate       | <currentDateStamp> 00:00:00 |
      | Supervisor1Notes               | Auto-Supervisor1            |
      | Supervisor1UserID              |                         547 |
      | Supervisor1AuthorisationStatus |                           1 |
      | Supervisor1AuthorisationDate   | <currentDateStamp> 00:00:00 |
      | Supervisor2Notes               | Auto-Supervisor2            |
      | Supervisor2UserID              |                         547 |
      | Supervisor2AuthorisationStatus |                           1 |
      | Supervisor2AuthorisationDate   | <currentDateStamp> 00:00:00 |
      | Manager1Notes                  | Auto-Manager1               |
      | Manager1UserID                 |                         532 |
      | Manager1AuthorisationStatus    |                           1 |
      | Manager1AuthorisationDate      | <currentDateStamp> 00:00:00 |
      | Manager2Notes                  | Auto-Manager2               |
      | Manager2UserID                 |                         532 |
      | Manager2AuthorisationStatus    |                           1 |
      | Manager2AuthorisationDate      | <currentDateStamp> 00:00:00 |
      | DirectorNotes                  | Auto-Director               |
      | DirectorUserID                 |                         531 |
      | DirectorAuthorisationStatus    |                           1 |
      | DirectorAuthorisationDate      | <currentDateStamp> 00:00:00 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should have key "UniqueID" with the stored key value "uniqueID"
    And response body should match the schema from the file "onboardingStage"

  Scenario: 004 Should be able to get all onboarding stage for awaiting approval prospect
    Given user has a service named "/api/v1/client/onboardingstage/getall"
    And user has a query params from the file 'onboardingStage' with selected keys 'BusinessUnitID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have index key with the value:
      | index | key                            | value                       |
      |     1 | BusinessUnitID                 |                          10 |
      |     1 | OnboardingStageID              |                           6 |
      |     1 | HandlerNotes                   | Auto-Handler                |
      |     1 | HandlerUserID                  |                         521 |
      |     1 | HandlerAuthorisationStatus     |                           1 |
      |     1 | HandlerAuthorisationDate       | <currentDateStamp> 00:00:00 |
      |     1 | Supervisor1Notes               | Auto-Supervisor1            |
      |     1 | Supervisor1UserID              |                         547 |
      |     1 | Supervisor1AuthorisationStatus |                           1 |
      |     1 | Supervisor1AuthorisationDate   | <currentDateStamp> 00:00:00 |
      |     1 | Supervisor2Notes               | Auto-Supervisor2            |
      |     1 | Supervisor2UserID              |                         547 |
      |     1 | Supervisor2AuthorisationStatus |                           1 |
      |     1 | Supervisor2AuthorisationDate   | <currentDateStamp> 00:00:00 |
      |     1 | Manager1Notes                  | Auto-Manager1               |
      |     1 | Manager1UserID                 |                         532 |
      |     1 | Manager1AuthorisationStatus    |                           1 |
      |     1 | Manager1AuthorisationDate      | <currentDateStamp> 00:00:00 |
      |     1 | Manager2Notes                  | Auto-Manager2               |
      |     1 | Manager2UserID                 |                         532 |
      |     1 | Manager2AuthorisationStatus    |                           1 |
      |     1 | Manager2AuthorisationDate      | <currentDateStamp> 00:00:00 |
      |     1 | DirectorNotes                  | Auto-Director               |
      |     1 | DirectorUserID                 |                         531 |
      |     1 | DirectorAuthorisationStatus    |                           1 |
      |     1 | DirectorAuthorisationDate      | <currentDateStamp> 00:00:00 |
    And response body should have index key with the stored key value:
      | index | key                | storedKey    |
      |     1 | ClientProspectID   | prospectID   |
      |     1 | ClientOnboardingID | onboardingID |
      |     1 | UniqueID           | uniqueID     |
    And response body should match the schema from the file "onboardingStageGetAll"

  Scenario: 005 Should be able to delete an onboarding stage for awaiting approval prospect
    Given user has a service named "/api/v1/client/onboardingstage/delete"
    And user has a query params from the file 'onboardingStage' with selected keys 'BusinessUnitID,ActionUserID,ReturnFormat'
    And user has query parameters:
      """
      {
          "StageID":"6"
      }
      """
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    And user add query parameter 'UniqueID' with the stored key value 'uniqueID'
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboardingStage"

  Scenario: 006 Should be able to delete an onboarding
    Given user has a service named "/api/v1/client/onboarding/update"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user has payloads:
      """
      {
          "OnboardingStageID": "1",
          "AssessedRiskValue": "0",
          "WeightedRiskScore": "12",
          "WeightedRiskScoreBand": "Medium",
          "WeightedRiskScoreOverriden": "True"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    When user has a service named "/api/v1/client/onboarding/delete"
    And user has a query params from the file 'onboarding' with selected keys 'OnboardingTypeID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    And user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboarding"

  Scenario: 007 Should be able to delete prospect
    Given user has a service named "/api/v1/client/prospect/delete"
    And user has a payload from the file "prospect" with selected keys "OnboardingTypeID,ActionUserID,ReturnFormat"
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "prospect"

  Scenario: 008 Should be able to add Onboarding stage for onboarded prospect
    Given user has a service named "/api/v1/client/prospect/add"
    And user has a payload from the file 'prospect'
    And user store the unique value for key:
      | key                |
      | interfaceReference |
      | firstName          |
      | lastName           |
    And user add payload key with stored key value:
      | payloadKey         | storedkey          |
      | InterfaceReference | interfaceReference |
      | FirstName          | firstName          |
      | LastName           | lastName           |
    When user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientProspectID" with keyName:"prospectIDApproved"
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectIDApproved"
    And user has payloads:
      """
      {
          "OnboardingStageID": "6",
          "OnboardingStatus": "2",
          "AssessedRiskValue": "0",
          "WeightedRiskScore": "12",
          "WeightedRiskScoreBand": "Medium",
          "WeightedRiskScoreOverriden": "True"
      }
      """
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingIDApproved"
    And user has a service named "/api/v1/client/onboardingstage/add"
    And user has a payload from the file 'onboardingStage'
    And user add payload "ClientProspectID" with the stored key value "prospectIDApproved"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingIDApproved"
    And user has payloads:
      """
      {
          "StageDate": "<currentDateStamp>",
          "HandlerAuthorisationDate": "<currentDateStamp>",
          "Supervisor1AuthorisationDate": "<currentDateStamp>",
          "Supervisor2AuthorisationDate": "<currentDateStamp>",
          "Manager1AuthorisationDate": "<currentDateStamp>",
          "Manager2AuthorisationDate": "<currentDateStamp>",
          "DirectorAuthorisationDate": "<currentDateStamp>",
          "OnboardingStageID": "6",
          "OnboardingStatus": "2"
      }
      """
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                            | value                       |
      | BusinessUnitID                 |                          10 |
      | OnboardingStageID              |                           6 |
      | HandlerNotes                   | Auto-Handler                |
      | HandlerUserID                  |                         521 |
      | HandlerAuthorisationStatus     |                           1 |
      | HandlerAuthorisationDate       | <currentDateStamp> 00:00:00 |
      | Supervisor1Notes               | Auto-Supervisor1            |
      | Supervisor1UserID              |                         547 |
      | Supervisor1AuthorisationStatus |                           1 |
      | Supervisor1AuthorisationDate   | <currentDateStamp> 00:00:00 |
      | Supervisor2Notes               | Auto-Supervisor2            |
      | Supervisor2UserID              |                         547 |
      | Supervisor2AuthorisationStatus |                           1 |
      | Supervisor2AuthorisationDate   | <currentDateStamp> 00:00:00 |
      | Manager1Notes                  | Auto-Manager1               |
      | Manager1UserID                 |                         532 |
      | Manager1AuthorisationStatus    |                           0 |
      | Manager1AuthorisationDate      | <currentDateStamp> 00:00:00 |
      | Manager2Notes                  | Auto-Manager2               |
      | Manager2UserID                 |                         532 |
      | Manager2AuthorisationStatus    |                           0 |
      | Manager2AuthorisationDate      | <currentDateStamp> 00:00:00 |
      | DirectorNotes                  | Auto-Director               |
      | DirectorUserID                 |                         531 |
      | DirectorAuthorisationStatus    |                           0 |
      | DirectorAuthorisationDate      | <currentDateStamp> 00:00:00 |
    And response body should have key "ClientProspectID" with the stored key value "prospectIDApproved"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingIDApproved"
    And response body should match the schema from the file "onboardingStage"
    And user store the response body keyData:"UniqueID" with keyName:"uniqueIDApproved"

  Scenario: 009 Should be able to update Onboarding stage for onboarded prospect
    Given user has a service named "/api/v1/client/onboardingstage/update"
    And user has a payload from the file 'onboardingStage'
    And user add payload "ClientProspectID" with the stored key value "prospectIDApproved"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingIDApproved"
    And user add payload "UniqueID" with the stored key value "uniqueIDApproved"
    And user has payloads:
      """
      {
          "OnboardingStageID": "6",
          "OnboardingStatus": "2",
          "Manager1AuthorisationStatus": "1",
          "Manager2AuthorisationStatus": "1",
          "DirectorAuthorisationStatus": "1",
          "StageDate": "<currentDateStamp>",
          "HandlerAuthorisationDate": "<currentDateStamp>",
          "Supervisor1AuthorisationDate": "<currentDateStamp>",
          "Supervisor2AuthorisationDate": "<currentDateStamp>",
          "Manager1AuthorisationDate": "<currentDateStamp>",
          "Manager2AuthorisationDate": "<currentDateStamp>",
          "DirectorAuthorisationDate": "<currentDateStamp>"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                            | value                       |
      | BusinessUnitID                 |                          10 |
      | OnboardingStageID              |                           6 |
      | HandlerNotes                   | Auto-Handler                |
      | HandlerUserID                  |                         521 |
      | HandlerAuthorisationStatus     |                           1 |
      | HandlerAuthorisationDate       | <currentDateStamp> 00:00:00 |
      | Supervisor1Notes               | Auto-Supervisor1            |
      | Supervisor1UserID              |                         547 |
      | Supervisor1AuthorisationStatus |                           1 |
      | Supervisor1AuthorisationDate   | <currentDateStamp> 00:00:00 |
      | Supervisor2Notes               | Auto-Supervisor2            |
      | Supervisor2UserID              |                         547 |
      | Supervisor2AuthorisationStatus |                           1 |
      | Supervisor2AuthorisationDate   | <currentDateStamp> 00:00:00 |
      | Manager1Notes                  | Auto-Manager1               |
      | Manager1UserID                 |                         532 |
      | Manager1AuthorisationStatus    |                           1 |
      | Manager1AuthorisationDate      | <currentDateStamp> 00:00:00 |
      | Manager2Notes                  | Auto-Manager2               |
      | Manager2UserID                 |                         532 |
      | Manager2AuthorisationStatus    |                           1 |
      | Manager2AuthorisationDate      | <currentDateStamp> 00:00:00 |
      | DirectorNotes                  | Auto-Director               |
      | DirectorUserID                 |                         531 |
      | DirectorAuthorisationStatus    |                           1 |
      | DirectorAuthorisationDate      | <currentDateStamp> 00:00:00 |
    And response body should have key "ClientProspectID" with the stored key value "prospectIDApproved"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingIDApproved"
    And response body should have key "UniqueID" with the stored key value "uniqueIDApproved"
    And response body should match the schema from the file "onboardingStage"

  Scenario: 010 Should be able to get an onboarding stage for onboarded prospect
    Given user has a service named "/api/v1/client/onboardingstage/get"
    And user has a query params from the file 'onboardingStage' with selected keys 'BusinessUnitID,ReturnFormat'
    And user has query parameters:
      """
      {
          "StageID":"6"
      }
      """
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectIDApproved'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingIDApproved'
    And user add query parameter 'UniqueID' with the stored key value 'uniqueIDApproved'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                            | value                       |
      | BusinessUnitID                 |                          10 |
      | OnboardingStageID              |                           6 |
      | HandlerNotes                   | Auto-Handler                |
      | HandlerUserID                  |                         521 |
      | HandlerAuthorisationStatus     |                           1 |
      | HandlerAuthorisationDate       | <currentDateStamp> 00:00:00 |
      | Supervisor1Notes               | Auto-Supervisor1            |
      | Supervisor1UserID              |                         547 |
      | Supervisor1AuthorisationStatus |                           1 |
      | Supervisor1AuthorisationDate   | <currentDateStamp> 00:00:00 |
      | Supervisor2Notes               | Auto-Supervisor2            |
      | Supervisor2UserID              |                         547 |
      | Supervisor2AuthorisationStatus |                           1 |
      | Supervisor2AuthorisationDate   | <currentDateStamp> 00:00:00 |
      | Manager1Notes                  | Auto-Manager1               |
      | Manager1UserID                 |                         532 |
      | Manager1AuthorisationStatus    |                           1 |
      | Manager1AuthorisationDate      | <currentDateStamp> 00:00:00 |
      | Manager2Notes                  | Auto-Manager2               |
      | Manager2UserID                 |                         532 |
      | Manager2AuthorisationStatus    |                           1 |
      | Manager2AuthorisationDate      | <currentDateStamp> 00:00:00 |
      | DirectorNotes                  | Auto-Director               |
      | DirectorUserID                 |                         531 |
      | DirectorAuthorisationStatus    |                           1 |
      | DirectorAuthorisationDate      | <currentDateStamp> 00:00:00 |
    And response body should have key "ClientProspectID" with the stored key value "prospectIDApproved"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingIDApproved"
    And response body should have key "UniqueID" with the stored key value "uniqueIDApproved"
    And response body should match the schema from the file "onboardingStage"

  Scenario: 011 Should be able to get all onboarding stage for onboarded prospect
    Given user has a service named "/api/v1/client/onboardingstage/getall"
    And user has a query params from the file 'onboardingStage' with selected keys 'BusinessUnitID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectIDApproved'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingIDApproved'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have index key with the value:
      | index | key                            | value                       |
      |     1 | BusinessUnitID                 |                          10 |
      |     1 | OnboardingStageID              |                           6 |
      |     1 | HandlerNotes                   | Auto-Handler                |
      |     1 | HandlerUserID                  |                         521 |
      |     1 | HandlerAuthorisationStatus     |                           1 |
      |     1 | HandlerAuthorisationDate       | <currentDateStamp> 00:00:00 |
      |     1 | Supervisor1Notes               | Auto-Supervisor1            |
      |     1 | Supervisor1UserID              |                         547 |
      |     1 | Supervisor1AuthorisationStatus |                           1 |
      |     1 | Supervisor1AuthorisationDate   | <currentDateStamp> 00:00:00 |
      |     1 | Supervisor2Notes               | Auto-Supervisor2            |
      |     1 | Supervisor2UserID              |                         547 |
      |     1 | Supervisor2AuthorisationStatus |                           1 |
      |     1 | Supervisor2AuthorisationDate   | <currentDateStamp> 00:00:00 |
      |     1 | Manager1Notes                  | Auto-Manager1               |
      |     1 | Manager1UserID                 |                         532 |
      |     1 | Manager1AuthorisationStatus    |                           1 |
      |     1 | Manager1AuthorisationDate      | <currentDateStamp> 00:00:00 |
      |     1 | Manager2Notes                  | Auto-Manager2               |
      |     1 | Manager2UserID                 |                         532 |
      |     1 | Manager2AuthorisationStatus    |                           1 |
      |     1 | Manager2AuthorisationDate      | <currentDateStamp> 00:00:00 |
      |     1 | DirectorNotes                  | Auto-Director               |
      |     1 | DirectorUserID                 |                         531 |
      |     1 | DirectorAuthorisationStatus    |                           1 |
      |     1 | DirectorAuthorisationDate      | <currentDateStamp> 00:00:00 |
    And response body should have index key with the stored key value:
      | index | key                | storedKey            |
      |     1 | ClientProspectID   | prospectIDApproved   |
      |     1 | ClientOnboardingID | onboardingIDApproved |
      |     1 | UniqueID           | uniqueIDApproved     |
    And response body should match the schema from the file "onboardingStageGetAll"

  Scenario: 012 Should be able to delete an onboarding stage for onboarded prospect
    Given user has a service named "/api/v1/client/onboardingstage/delete"
    And user has a query params from the file 'onboardingStage' with selected keys 'BusinessUnitID,ActionUserID,ReturnFormat'
    And user has query parameters:
      """
      {
          "StageID":"6"
      }
      """
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectIDApproved'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingIDApproved'
    And user add query parameter 'UniqueID' with the stored key value 'uniqueIDApproved'
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboardingStage"

  Scenario: 013 Should be able to delete an onboarding
    Given user has a service named "/api/v1/client/onboarding/update"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectIDApproved"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingIDApproved"
    And user has payloads:
      """
      {
          "OnboardingStageID": "1",
          "AssessedRiskValue": "0",
          "WeightedRiskScore": "12",
          "WeightedRiskScoreBand": "Medium",
          "WeightedRiskScoreOverriden": "True"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    When user has a service named "/api/v1/client/onboarding/delete"
    And user has a query params from the file 'onboarding' with selected keys 'OnboardingTypeID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectIDApproved'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingIDApproved'
    And user sends a 'DELETE' request
    Then response status should be 200

  Scenario: 014 Should be able to delete prospect
    Given user has a service named "/api/v1/client/prospect/delete"
    And user has a payload from the file "prospect" with selected keys "OnboardingTypeID,ActionUserID,ReturnFormat"
    And user add payload "ClientProspectID" with the stored key value "prospectIDApproved"
    When user sends a 'DELETE' request
    Then response status should be 200
