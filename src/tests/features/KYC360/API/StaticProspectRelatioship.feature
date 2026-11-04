@Regression @StaticProspectRelationship
Feature: Static Prospect Relationship API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add Static prospect relationship
    Given user has a service named "/api/v1/static/prospectrelationship/add"
    And user has a payload from the file 'staticProspectRelatioship'
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value        |
      | Name           | Auto-Testing |
      | Description    | testing      |
      | Value1Name     |           10 |
      | Value2Name     |           20 |
      | Value3Name     |           30 |
      | Value1Decimals |            1 |
      | Value2Decimals |            2 |
      | Value3Decimals |            3 |
      | Value1Enabled  | true         |
      | Value2Enabled  | true         |
      | Value3Enabled  | true         |
    And response body should match the schema from the file "staticProspectRelatioship"
    When user store the response body keyData:"ProspectRelationshipID" with keyName:"prospectRelationshipID"

  Scenario: 002 Should be able to get Static prospect relationship
    Given user has a service named "/api/v1/static/prospectrelationship/get"
    And user add query parameter "ProspectRelationshipID" with the stored key value "prospectRelationshipID"
    And user has a query params from the file "staticProspectRelatioship" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value        |
      | Name           | Auto-Testing |
      | Description    | testing      |
      | Value1Name     |           10 |
      | Value2Name     |           20 |
      | Value3Name     |           30 |
      | Value1Decimals |            1 |
      | Value2Decimals |            2 |
      | Value3Decimals |            3 |
      | Value1Enabled  | true         |
      | Value2Enabled  | true         |
      | Value3Enabled  | true         |
    And response body should match the schema from the file "staticProspectRelatioship"
    And response body should have key "ProspectRelationshipID" with the stored key value "prospectRelationshipID"

  Scenario: 003 Should be able to update Static Prospect Relationship
    Given user has a service named "/api/v1/static/prospectrelationship/update"
    And user has a payload from the file 'staticProspectRelatioship'
    And user add payload "ProspectRelationshipID" with the stored key value "prospectRelationshipID"
    And user has payloads:
      """
      {
        "Name":"Auto-Testing -Update",
        "Description":"testing -Update",
        "Value1Name":"40",
        "Value2Name":"50",
        "Value3Name":"60",
        "Value1Decimals":"4",
        "Value2Decimals":"5",
        "Value3Decimals":"6",
        "Value4Enabled":"false",
        "Value5Enabled":"false",
        "Value6Enabled":"false"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value                |
      | Name           | Auto-Testing -Update |
      | Description    | testing -Update      |
      | Value1Name     |                   40 |
      | Value2Name     |                   50 |
      | Value3Name     |                   60 |
      | Value1Decimals |                    4 |
      | Value2Decimals |                    5 |
      | Value3Decimals |                    6 |
      | Value4Enabled  | false                |
      | Value5Enabled  | false                |
      | Value6Enabled  | false                |
    And response body should have key "ProspectRelationshipID" with the stored key value "prospectRelationshipID"
    And response body should match the schema from the file "staticProspectRelatioship"

  Scenario: 004 Should be able to get all Static Prospect Relationship
    Given user has a service named "/api/v1/static/prospectrelationship/getall"
    And user has a query params from the file "staticProspectRelatioship" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticProspectRelatioshipGetAll"

  Scenario: 005 Should be able to delete Static Prospect Relationship
    Given user has a service named "/api/v1/static/prospectrelationship/delete"
    And user add query parameter "ProspectRelationshipID" with the stored key value "prospectRelationshipID"
    And user has a query params from the file "staticProspectRelatioship" with selected keys "ActionUserID,ReturnFormat"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value                |
      | Name           | Auto-Testing -Update |
      | Description    | testing -Update      |
      | Value1Name     |                   40 |
      | Value2Name     |                   50 |
      | Value3Name     |                   60 |
      | Value1Decimals |                    4 |
      | Value2Decimals |                    5 |
      | Value3Decimals |                    6 |
      | Value4Enabled  | false                |
      | Value5Enabled  | false                |
      | Value6Enabled  | false                |
    And response body should have key "ProspectRelationshipID" with the stored key value "prospectRelationshipID"
    And response body should match the schema from the file "staticProspectRelatioship"
