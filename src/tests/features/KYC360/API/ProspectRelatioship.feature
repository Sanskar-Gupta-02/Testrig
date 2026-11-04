@Regression @ProspectRelationship
Feature: Prospect Relationship API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add lead prospect relationship
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
    When user store the response body keyData:"ClientProspectID" with keyName:"leadProspectID"
    And user has a service named "/api/v1/client/prospectgroup/add"
    And user has a payload from the file "prospectGroup" with selected keys "BusinessUnitID,Name,Description,ActionUserID,ReturnFormat"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value                   |
      | BusinessUnitID |                      10 |
      | Name           | PlaywrightProspectGroup |
      | Description    | Playwright Description  |
    And response body should match the schema from the file "prospectGroup"
    When user store the response body keyData:"ClientProspectGroupID" with keyName:"prospectGroupID"
    And user has a service named "/api/v1/client/prospectrelationship/add"
    And user has a payload from the file 'prospectRelationship'
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And user add payload "ClientProspectID" with the stored key value "leadProspectID"
    And user has payloads:
      """
      {
          "ProspectRelationshipID":"2046",
          "ParentClientProspectID":"0",
          "ParentUniqueID":"0",
          "OriginClientProspectID":"0"
      }
      """
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value |
      | BusinessUnitID            |    10 |
      | ProspectRelationshipID    |  2046 |
      | ParentClientProspectID    |     0 |
      | ParentUniqueID            |     0 |
      | UBOOwnershipPercentage    |    10 |
      | DirectOwnershipPercentage |    20 |
    And response body should have key "ClientProspectID" with the stored key value "leadProspectID"
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should match the schema from the file "prospectRelationship"
    When user store the response body keyData:"UniqueID" with keyName:"ParentUniqueID"

  Scenario: 002 Should be able to add prospect relationship
    Given user has a service named "/api/v1/client/prospect/add"
    And user has a payload from the file 'prospect'
    And user has payloads:
      """
      {
          "InterfaceReference": "PlaywrightAutomationSecondProspect"
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value                              |
      | BusinessUnitID            |                                 10 |
      | OnboardingTypeID          |                                695 |
      | HandledByGroupID          |                                325 |
      | HandledByUserID           |                                521 |
      | HandledBySupervisorUserID |                                547 |
      | HandledByManagerUserID    |                                532 |
      | HandledByDirectorUserID   |                                531 |
      | InterfaceReference        | PlaywrightAutomationSecondProspect |
      | LastName                  | AddedProspect                      |
      | FirstName                 | API                                |
      | Email                     | krunallute@riskscreen.com          |
      | AllowKYBLookup            | true                               |
    And response body should match the schema from the file "prospect"
    When user store the response body keyData:"ClientProspectID" with keyName:"prospectID"
    And user has a service named "/api/v1/client/prospectrelationship/add"
    And user has a payload from the file 'prospectRelationship'
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ParentClientProspectID" with the stored key value "leadProspectID"
    And user add payload "ParentUniqueID" with the stored key value "ParentUniqueID"
    And user has payloads:
      """
      {
          "ProspectRelationshipID":"2086",
          "OriginClientProspectID":"0"
      }
      """
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value |
      | BusinessUnitID            |    10 |
      | ProspectRelationshipID    |  2086 |
      | UBOOwnershipPercentage    |    10 |
      | DirectOwnershipPercentage |    20 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should have key "ParentClientProspectID" with the stored key value "leadProspectID"
    And response body should have key "ParentUniqueID" with the stored key value "ParentUniqueID"
    And response body should match the schema from the file "prospectRelationship"
    When user store the response body keyData:"UniqueID" with keyName:"UniqueID"
    And user store the response body keyData:"ClientID" with keyName:"clientID"
    And user store the response body keyData:"BusinessUnitID" with keyName:"businessUnitID"

  Scenario: 003 Should be able to get all prospect relationship details
    Given user has a service named "/api/v1/client/prospectrelationship/getall"
    And user has a query params from the file 'prospectRelationship' with selected keys 'BusinessUnitID,ReturnFormat'
    And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have index key with the value:
      | index | key                       | value |
      |     1 | BusinessUnitID            |    10 |
      |     1 | ProspectRelationshipID    |  2046 |
      |     1 | ParentClientProspectID    |     0 |
      |     1 | ParentUniqueID            |     0 |
      |     1 | UBOOwnershipPercentage    |    10 |
      |     1 | DirectOwnershipPercentage |    20 |
      |     2 | BusinessUnitID            |    10 |
      |     2 | ProspectRelationshipID    |  2086 |
      |     2 | UBOOwnershipPercentage    |    10 |
      |     2 | DirectOwnershipPercentage |    20 |
    And response body should have index key with the stored key value:
      | index | key              | storedKey      |
      |     1 | ClientProspectID | leadProspectID |
      |     1 | UniqueID         | ParentUniqueID |
      |     2 | ClientProspectID | prospectID     |
    And response body should match the schema from the file "getProspectRelationships"

  Scenario: 004 Should be able to update prospect relationship
    Given user has a service named "/api/v1/client/prospectrelationship/update"
    And user has a payload from the file "prospectRelationship" with selected keys "BusinessUnitID,Value1,Value2,Value3,Value4,Value5,Value6,Value7,ActionUserID,ReturnFormat"
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ParentClientProspectID" with the stored key value "leadProspectID"
    And user add payload "ParentUniqueID" with the stored key value "ParentUniqueID"
    And user add payload "UniqueID" with the stored key value "UniqueID"
    And user has payloads:
      """
      {
          "ProspectRelationshipID":"2059",
          "UBOOwnershipPercentage":"40",
          "DirectOwnershipPercentage":"60",
          "OriginClientProspectID":"0"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value |
      | BusinessUnitID            |    10 |
      | ProspectRelationshipID    |  2059 |
      | UBOOwnershipPercentage    |    40 |
      | DirectOwnershipPercentage |    60 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should have key "ParentClientProspectID" with the stored key value "leadProspectID"
    And response body should have key "ParentUniqueID" with the stored key value "ParentUniqueID"
    And response body should have key "UniqueID" with the stored key value "UniqueID"
    And response body should match the schema from the file "prospectRelationship"

  Scenario: 005 Should be able to delete prospect relationship
    Given user has a service named "/api/v1/client/prospectrelationship/delete"
    And user has a query params from the file 'prospectRelationship' with selected keys 'BusinessUnitID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'UniqueID' with the stored key value 'UniqueID'
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value |
      | BusinessUnitID            |    10 |
      | ProspectRelationshipID    |  2059 |
      | UBOOwnershipPercentage    |    40 |
      | DirectOwnershipPercentage |    60 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ParentClientProspectID" with the stored key value "leadProspectID"
    And response body should have key "ParentUniqueID" with the stored key value "ParentUniqueID"
    And response body should have key "UniqueID" with the stored key value "UniqueID"
    And response body should match the schema from the file "prospectRelationship"
    # Delete Lead Prospect Relationship
    When user has a service named "/api/v1/client/prospectrelationship/delete"
    And user has a query params from the file 'prospectRelationship' with selected keys 'BusinessUnitID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
    And user add query parameter 'ClientProspectID' with the stored key value 'leadProspectID'
    And user add query parameter 'UniqueID' with the stored key value 'ParentUniqueID'
    And user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value |
      | BusinessUnitID            |    10 |
      | ProspectRelationshipID    |  2046 |
      | UBOOwnershipPercentage    |    10 |
      | DirectOwnershipPercentage |    20 |
    And response body should have key "ClientProspectID" with the stored key value "leadProspectID"
    And response body should have key "UniqueID" with the stored key value "ParentUniqueID"
    And response body should match the schema from the file "prospectRelationship"

  Scenario: 006 Confirm deletion prospect relationship
    Given user has a service named "/api/v1/client/prospectrelationship/delete"
    And user has a query params from the file 'prospectRelationship' with selected keys 'BusinessUnitID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
    And user add query parameter 'ClientProspectID' with the stored key value 'leadProspectID'
    And user add query parameter 'UniqueID' with the stored key value 'ParentUniqueID'
    When user sends a 'DELETE' request
    Then response status should be 406
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key 'Message' with the message:'Unable to retrieve the Client Prospect Relationship with Identifier <clientID> - <businessUnitID> - <prospectGroupID> - <leadProspectID> - <ParentUniqueID> from the database!'

  Scenario: 007 Should be able to delete prospect and prospect group
    Given user has a service named "/api/v1/client/prospect/delete"
    And user has a payload from the file "prospect" with selected keys "OnboardingTypeID,ActionUserID,ReturnFormat"
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    When user sends a 'Delete' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "prospect"
    When user has a service named "/api/v1/client/prospect/delete"
    And user has a payload from the file "prospect" with selected keys "OnboardingTypeID,ActionUserID,ReturnFormat"
    And user add payload "ClientProspectID" with the stored key value "leadProspectID"
    When user sends a 'Delete' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "prospect"
    When user has a service named "/api/v1/client/prospectgroup/delete"
    And user has a payload from the file "prospectGroup" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value                   |
      | BusinessUnitID |                      10 |
      | Name           | PlaywrightProspectGroup |
      | Description    | Playwright Description  |
    And response body should match the schema from the file "prospectGroup"
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
