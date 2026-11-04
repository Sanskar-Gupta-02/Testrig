@Regression @StaticMatchFlagCategory
Feature: Static Match Flag Category

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add Static Match Flag Category
    Given user has a service named "/api/v1/static/matchflagcategory/add"
    And user has a payload from the file 'staticMatchFlagCategory'
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key           | value                      |
      | Name          | Static Match Flag Category |
      | Description   | SMFC Desc                  |
      | Grouping      |                          0 |
      | RequireReason | false                      |
    And response body should match the schema from the file "staticMatchFlagCategory"
    When user store the response body keyData:"MatchFlagCategoryID" with keyName:"matchFlagCategoryID"

  Scenario: 002 Should be able to get Static Match Flag Category
    Given user has a service named "/api/v1/static/matchflagcategory/get"
    And user add query parameter "MatchCategoryID" with the stored key value "matchFlagCategoryID"
    And user has a query params from the file "staticMatchFlagCategory" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key           | value                      |
      | Name          | Static Match Flag Category |
      | Description   | SMFC Desc                  |
      | RequireReason | false                      |
      | Grouping      |                          0 |
      | RequireReason | false                      |
    And response body should match the schema from the file "staticMatchFlagCategory"
    And response body should have key "MatchFlagCategoryID" with the stored key value "matchFlagCategoryID"

  Scenario: 003 Should be able to update Static Match Flag Category
    Given user has a service named "/api/v1/static/matchflagcategory/update"
    And user has a payload from the file 'staticMatchFlagCategory'
    And user add payload "MatchFlagCategoryID" with the stored key value "matchFlagCategoryID"
    And user has payloads:
      """
      {
        "Name":"Static Criteria Testing -Update",
        "Description":"SMFC Desc -Update",
        "Grouping":"1",
        "RequireReason":"true"
      
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key           | value                           |
      | Name          | Static Criteria Testing -Update |
      | Description   | SMFC Desc -Update               |
      | Grouping      |                               1 |
      | RequireReason | true                            |
    And response body should have key "MatchFlagCategoryID" with the stored key value "matchFlagCategoryID"
    And response body should match the schema from the file "staticMatchFlagCategory"

  Scenario: 004 Should be able to Get All Static Match Flag Category
    Given user has a service named "/api/v1/static/matchflagcategory/getall"
    And user has a query params from the file "staticMatchFlagCategory" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticMatchFlagCategoryGetAll"

  Scenario: 005 Should be able to delete Static Criteria
    Given user has a service named "/api/v1/static/matchflagcategory/delete"
    And user add query parameter "MatchFlagCategoryID" with the stored key value "matchFlagCategoryID"
    And user has a query params from the file "staticCriteria" with selected keys "ActionUserID,ReturnFormat"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value                           |
      | Name        | Static Criteria Testing -Update |
      | Description | SMFC Desc -Update               |
      | Grouping    |                               1 |
    And response body should have key "MatchFlagCategoryID" with the stored key value "matchFlagCategoryID"
    And response body should match the schema from the file "staticMatchFlagCategory"
