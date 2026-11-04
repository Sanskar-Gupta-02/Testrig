@Regression @StaticAVMMatchFlagCategory
Feature: Static AVM Match Flag Category

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add Static AVM Match Flag Category
    Given user has a service named "/api/v1/static/adversemedia/matchflagcategory/add"
    And user has a payload from the file 'staticAVMMatchFlagCategory'
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key           | value          |
      | Name          | Auto Test      |
      | Description   | Auto Test Desc |
      | RequireReason | true           |
      | Grouping      |              1 |
      | ScrapeType    |              1 |
      | Scrape        | false          |
    And response body should match the schema from the file "staticAVMMatchFlagCategory"
    When user store the response body keyData:"MatchFlagCategoryID" with keyName:"matchFlagCategoryID"

  Scenario: 002 Should be able to get AVM Match Flag Category
    Given user has a service named "api/v1/static/adversemedia/matchflagcategory/get"
    And user has a query params from the file 'staticAVMMatchFlagCategory' with selected keys 'ReturnFormat'
    And user add query parameter "MatchCategoryID" with the stored key value "matchFlagCategoryID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key           | value          |
      | Name          | Auto Test      |
      | Description   | Auto Test Desc |
      | RequireReason | true           |
      | Grouping      |              1 |
      | ScrapeType    |              1 |
      | Scrape        | false          |
    And response body should match the schema from the file "staticAVMMatchFlagCategory"
    And response body should have key "MatchFlagCategoryID" with the stored key value "matchFlagCategoryID"

  Scenario: 003 Should be able to Update AVM Match Flag Category
    Given user has a service named "/api/v1/static/adversemedia/matchflagcategory/update"
    And user has a payload from the file 'staticAVMMatchFlagCategory'
    And user add payload "MatchFlagCategoryID" with the stored key value "matchFlagCategoryID"
    And user has payloads:
      """
      {
        "Name": "Auto Test -Update",
        "Description": "Auto Test Desc -Update",
        "ScrapeType": "2",
        "Scrape":"true"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value                  |
      | Name        | Auto Test -Update      |
      | Description | Auto Test Desc -Update |
      | ScrapeType  |                      2 |
      | Scrape      | true                   |
    And response body should match the schema from the file "staticAVMMatchFlagCategory"
    And response body should have key "MatchFlagCategoryID" with the stored key value "matchFlagCategoryID"

  Scenario: 004 Should be able to getall AVM Match Flag Category
    Given user has a service named "/api/v1/static/adversemedia/matchflagcategory/getall"
    And user has a query params from the file "staticAVMMatchFlagCategory" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticAVMMatchFlagCategoryGetAll"

  Scenario: 005 Should be able to delete AVM Match Flag Category
    Given user has a service named "/api/v1/static/adversemedia/matchflagcategory/delete"
    And user has a query params from the file 'staticAVMMatchFlagCategory' with selected keys 'ActionUserID,ReturnFormat'
    And user add query parameter "MatchFlagCategoryID" with the stored key value "matchFlagCategoryID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value                  |
      | Name        | Auto Test -Update      |
      | Description | Auto Test Desc -Update |
      | ScrapeType  |                      2 |
      | Scrape      | true                   |
    And response body should match the schema from the file "staticAVMMatchFlagCategory"
    And response body should have key "MatchFlagCategoryID" with the stored key value "matchFlagCategoryID"
