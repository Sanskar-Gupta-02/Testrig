@Regression @StaticMatchDiscountCategory
Feature: Static Match Discount Category

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add Static Match Discount Category
    Given user has a service named "/api/v1/static/matchdiscountcategory/add"
    And user has a payload from the file 'staticMatchDiscountCategory'
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key           | value                          |
      | Name          | Static Match Discount Category |
      | Description   | SMDC Desc                      |
      | RequireReason | false                          |
      | Grouping      |                              0 |
    And response body should match the schema from the file "staticMatchDiscountCategory"
    When user store the response body keyData:"MatchDiscountCategoryID" with keyName:"matchDiscountCategoryID"

  Scenario: 002 Should be able to get Static Match Discount Category
    Given user has a service named "/api/v1/static/matchdiscountcategory/get"
    And user add query parameter "MatchCategoryID" with the stored key value "matchDiscountCategoryID"
    And user has a query params from the file "staticMatchDiscountCategory" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key           | value                          |
      | Name          | Static Match Discount Category |
      | Description   | SMDC Desc                      |
      | RequireReason | false                          |
      | Grouping      |                              0 |
    And response body should match the schema from the file "staticMatchDiscountCategory"
    And response body should have key "MatchDiscountCategoryID" with the stored key value "matchDiscountCategoryID"

  Scenario: 003 Should be able to update Static Match Discount Category
    Given user has a service named "/api/v1/static/matchdiscountcategory/update"
    And user has a payload from the file 'staticMatchDiscountCategory'
    And user add payload "MatchDiscountCategoryID" with the stored key value "matchDiscountCategoryID"
    And user has payloads:
      """
      {
        "Name":"Static Criteria Testing -Update",
        "Description":"SMDC Desc -Update",
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
      | Description   | SMDC Desc -Update               |
      | Grouping      |                               1 |
      | RequireReason | true                            |
    And response body should have key "MatchDiscountCategoryID" with the stored key value "matchDiscountCategoryID"
    And response body should match the schema from the file "staticMatchDiscountCategory"

  Scenario: 004 Should be able to Get All Static Match Discount Category
    Given user has a service named "/api/v1/static/matchdiscountcategory/getall"
    And user has a query params from the file "staticMatchDiscountCategory" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticMatchDiscountCategoryGetAll"

  Scenario: 005 Should be able to delete Static Criteria
    Given user has a service named "/api/v1/static/matchdiscountcategory/delete"
    And user add query parameter "MatchDiscountCategoryID" with the stored key value "matchDiscountCategoryID"
    And user has a query params from the file "staticCriteria" with selected keys "ActionUserID,ReturnFormat"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key           | value                           |
      | Name          | Static Criteria Testing -Update |
      | Description   | SMDC Desc -Update               |
      | Grouping      |                               1 |
      | RequireReason | true                            |
    And response body should have key "MatchDiscountCategoryID" with the stored key value "matchDiscountCategoryID"
    And response body should match the schema from the file "staticMatchDiscountCategory"
