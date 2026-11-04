@Regression @ProspectGroup
Feature: Propect Group API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add prospect group record
    Given user has a service named "/api/v1/client/prospectgroup/add"
    And user has a payload from the file "prospectGroup" with selected keys "BusinessUnitID,Name,Description,ActionUserID,ReturnFormat"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value                   |
      | BusinessUnitID |                      10 |
      | Name           | PlaywrightProspectGroup |
      | Description    | Playwright Description  |
    And response body should match the schema from the file "prospectGroup"
    When user store the response body keyData:"ClientProspectGroupID" with keyName:"prospectGroupID"

  Scenario: 002 Should be able to search prospect group record
    Given user has a service named "/api/v1/client/prospectgroup/search"
    And user has a query params from the file 'prospectGroup' with selected keys 'BusinessUnitID,SearchString,SearchOn,SearchType,UserId,CurrentPage,PageSize,ReturnFormat'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have index key with the value:
      | index | key            | value                   |
      |     1 | BusinessUnitID |                      10 |
      |     1 | Name           | PlaywrightProspectGroup |
      |     1 | Description    | Playwright Description  |
    And response body should match the schema from the file "prospectGroupSearch"

  Scenario: 003 Should be able to get prospect group record
    Given user has a service named "/api/v1/client/prospectgroup/get"
    And user has a query params from the file 'prospectGroup' with selected keys 'BusinessUnitID,ReturnFormat'
    And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value                   |
      | BusinessUnitID |                      10 |
      | Name           | PlaywrightProspectGroup |
      | Description    | Playwright Description  |
    And response body should match the schema from the file "prospectGroup"

  Scenario: 004 Should be able to update prospect group record
    Given user has a service named "/api/v1/client/prospectgroup/update"
    And user has a payload from the file "prospectGroup" with selected keys "BusinessUnitID,Name,Description,ActionUserID,ReturnFormat"
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And user has payloads:
      """
      {
          "Name":"PG Name Auto Update",
          "Description":"PG Description Auto Update"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value                      |
      | BusinessUnitID |                         10 |
      | Name           | PG Name Auto Update        |
      | Description    | PG Description Auto Update |
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should match the schema from the file "prospectGroup"
    When user store the response body keyData:"Name" with keyName:"prospectGroupName"

  Scenario: 005 Should be able to search updated prospect group record
    Given user has a service named "/api/v1/client/prospectgroup/search"
    And user has a query params from the file 'prospectGroup' with selected keys 'BusinessUnitID,SearchString,SearchOn,SearchType,UserId,CurrentPage,PageSize,ReturnFormat'
    And user add query parameter 'SearchString' with the stored key value 'prospectGroupName'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have index key with the value:
      | index | key            | value                      |
      |     1 | BusinessUnitID |                         10 |
      |     1 | Name           | PG Name Auto Update        |
      |     1 | Description    | PG Description Auto Update |
    And response body should match the schema from the file "prospectGroupSearch"

  Scenario: 006 Should be able to delete a prospect group
    Given user has a service named "/api/v1/client/prospectgroup/delete"
    And user has a payload from the file "prospectGroup" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value                      |
      | BusinessUnitID |                         10 |
      | Name           | PG Name Auto Update        |
      | Description    | PG Description Auto Update |
    And response body should match the schema from the file "prospectGroup"
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"

  Scenario: 007 Should be able to confirm delete a prospect group
    Given user has a service named "/api/v1/client/prospectgroup/delete"
    And user has a payload from the file "prospectGroup" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    When user sends a 'DELETE' request
    Then response status should be 406
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key 'Message' with the message:'Unable to retrieve the Client Prospect Group with Identifier <prospectGroupID> from the database!'
