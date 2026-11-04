@Regression @StaticAVMMatchDiscount
Feature: Static AVM Match Discount Category

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add Static AVM Match Discount Category
    Given user has a service named "/api/v1/static/adversemedia/matchdiscountcategory/add"
    And user has a payload from the file 'staticAVMMatchDiscountCategory'
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
    And response body should match the schema from the file "staticAVMMatchDiscountCategory"
    When user store the response body keyData:"MatchDiscountCategoryID" with keyName:"matchDiscountCategoryID"

  Scenario: 002 Should be able to get AVM Match Discount Category
    Given user has a service named "api/v1/static/adversemedia/matchdiscountcategory/get"
    And user has a query params from the file 'staticAVMMatchDiscountCategory' with selected keys 'ReturnFormat'
    And user add query parameter "MatchCategoryID" with the stored key value "matchDiscountCategoryID"
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
    And response body should match the schema from the file "staticAVMMatchDiscountCategory"
    And response body should have key "MatchDiscountCategoryID" with the stored key value "matchDiscountCategoryID"

  Scenario: 003 Should be able to Update AVM Match Discount Category
    Given user has a service named "/api/v1/static/adversemedia/matchdiscountcategory/update"
    And user has a payload from the file 'staticAVMMatchDiscountCategory'
    And user add payload "MatchDiscountCategoryID" with the stored key value "matchDiscountCategoryID"
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
    And response body should match the schema from the file "staticAVMMatchDiscountCategory"
    And response body should have key "MatchDiscountCategoryID" with the stored key value "matchDiscountCategoryID"

  Scenario: 004 Should be able to getall AVM Match Discount Category
    Given user has a service named "/api/v1/static/adversemedia/matchdiscountcategory/getall"
    And user has a query params from the file "staticAVMMatchDiscountCategory" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticAVMMatchDiscountCategoryGetAll"

  Scenario: 005 Should be able to delete AVM Match Discount Category
    Given user has a service named "/api/v1/static/adversemedia/matchdiscountcategory/delete"
    And user has a query params from the file 'staticAVMMatchDiscountCategory' with selected keys 'ActionUserID,ReturnFormat'
    And user add query parameter "MatchDiscountCategoryID" with the stored key value "matchDiscountCategoryID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value                  |
      | Name        | Auto Test -Update      |
      | Description | Auto Test Desc -Update |
      | ScrapeType  |                      2 |
      | Scrape      | true                   |
    And response body should match the schema from the file "staticAVMMatchDiscountCategory"
    And response body should have key "MatchDiscountCategoryID" with the stored key value "matchDiscountCategoryID"
