@Regression @CloneProspect
Feature: Clone Prospect API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 User should be able to Clone a Prospect without any Onboarding. #ENG-T11087
    Given user has a service named "/api/v1/client/prospect/clone"
    And user has a payload from the file "cloneProspect"
    And user has payloads:
      """
      {
      "InterfaceReference":"CLONEPROSPECTINT",
      "LastName": "CloneProspectAPI"
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                    | value                        |
      | BusinessUnitId         |                           10 |
      | ClientProspectId       |                       614783 |
      | CloneProspect          | true                         |
      | ClonedOnboardingId     |                            0 |
      | Email                  | CloneProspectAPI@example.com |
      | InterfaceReference     | CLONEPROSPECTINT             |
      | LastName               | CloneProspectAPI             |
      | OnboardingId           |                       351450 |
      | OnboardingTypeId       |                          695 |
      | ParentClientProspectId |                            0 |
      | ParentClientProspectId |                            0 |
      | ProspectRelationshipId |                            0 |
      | UniqueId               |                            0 |
    And response body should match the schema from the file "cloneProspect"
    When user store the response body keyData:"ClonedProspectId" with keyName:"ClonedProspectId"

  Scenario: 002 User should not be able to clone prospect with duplicate Interface reference. #ENG-T11086
    Given user has a service named "/api/v1/client/prospect/clone"
    And user has a payload from the file "cloneProspect"
    And user has payloads:
      """
      {
      "InterfaceReference":"CLONEPROSPECTINT",
      "LastName": "CloneProspect-API"
      }
      """
    When user sends a 'POST' request
    Then response status should be 406

  Scenario: 003 Delete Cloned Prospect
    Given user has a service named "/api/v1/client/prospect/delete"
    And user has a payload from the file 'prospect' with selected keys 'BusinessUnitID,ReturnFormat,ActionUserID'
    And user add payload 'ClientProspectID' with the stored key value 'ClonedProspectId'
    When user sends a 'DELETE' request
    Then response status should be 200

  Scenario: 004 user successfully clone a Prospect and Onboarding into a new Prospect. #ENG-T11084
    Given user has a service named "/api/v1/client/prospect/clone"
    And user has a payload from the file "cloneProspect"
    And user has payloads:
      """
      {
      "OnboardingTypeId":"0",
      "OnboardingId":"351450",
      "InterfaceReference":"CLONEPROSPECTINT-2",
      "LastName": "CloneProspect-API-2"
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                    | value                        |
      | BusinessUnitId         |                           10 |
      | ClientProspectId       |                       614783 |
      | CloneProspect          | true                         |
      | Email                  | CloneProspectAPI@example.com |
      | InterfaceReference     | CLONEPROSPECTINT-2           |
      | LastName               | CloneProspect-API-2          |
      | OnboardingTypeId       |                            0 |
      | ParentClientProspectId |                            0 |
      | ProspectRelationshipId |                            0 |
      | UniqueId               |                            0 |
    And response body should match the schema from the file "cloneProspect"
    When user store the response body keyData:"ClonedProspectId" with keyName:"ClonedProspectId2"
    And user store the response body keyData:"ClonedOnboardingId" with keyName:"OnboardingId"

  Scenario: 005 Delete Cloned Prospect and Onboarding
    Given user has a service named "/api/v1/client/onboarding/delete"
    And user has a query params from the file 'cloneProspect' with selected keys 'ActionUserId,ReturnFormat,BusinessUnitID'
    And user add query parameter "ClientOnboardingID" with the stored key value "OnboardingId"
    And user add query parameter "ClientProspectID" with the stored key value "ClonedProspectId2"
    When user sends a 'DELETE' request
    Then response status should be 200
    Given user has a service named "/api/v1/client/prospect/delete"
    And user has a payload from the file 'prospect' with selected keys 'BusinessUnitID,ReturnFormat,ActionUserID'
    And user add payload 'ClientProspectID' with the stored key value 'ClonedProspectId2'
    When user sends a 'DELETE' request
    Then response status should be 200

  Scenario: 006 User should be able to clone onboarding with the same prospect where clone prospect is false #ENG-T11085
    Given user has a service named "/api/v1/client/prospect/clone"
    And user has a payload from the file "cloneProspect"
    And user has payloads:
      """
      {
      "CloneProspect":"false",
      "InterfaceReference":"CLONEPROSPECTINT-3",
      "LastName": "CloneProspect-API-3",
      "OnboardingId":"351450"
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                    | value                        |
      | BusinessUnitId         |                           10 |
      | ClientProspectId       |                       614783 |
      | CloneProspect          | false                        |
      | Email                  | CloneProspectAPI@example.com |
      | InterfaceReference     | CLONEPROSPECTINT-3           |
      | LastName               | CloneProspect-API-3          |
      | OnboardingId           |                       351450 |
      | OnboardingTypeId       |                          695 |
      | ParentClientProspectId |                            0 |
      | ProspectRelationshipId |                            0 |
      | UniqueId               |                            0 |
    And response body should match the schema from the file "cloneProspect"
    And user store the response body keyData:"ClonedOnboardingId" with keyName:"OnboardingId2"
    And user store the response body keyData:"ClientProspectId" with keyName:"ClientProspectId2"

  Scenario: 007 Delete Onboarding
    Given user has a service named "/api/v1/client/onboarding/delete"
    And user has a query params from the file 'cloneProspect' with selected keys 'ActionUserId,ReturnFormat,BusinessUnitID'
    And user add query parameter "ClientProspectId" with the stored key value "ClientProspectId2"
    And user add query parameter "ClientOnboardingID" with the stored key value "OnboardingId2"
    When user sends a 'Delete' request
    Then response status should be 200
