@Regression @StaticBusinessUnit
Feature: StaticBusinessUnit

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to get Static Business Unit
    Given user has a service named "/api/v1/static/businessunit/get"
    And user has a query params from the file "staticBusinessUnit" with selected keys "BusinessUnitID,ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value   |
      | BusinessUnitID |      10 |
      | Name           | Default |
      | Description    | Default |
      | IsActive       | true    |
      | EmailSettingId |       0 |
    And response body should match the schema from the file "staticBusinessUnit"

  Scenario: 002 Should be able to get all Static Business Unit
    Given user has a service named "/api/v1/static/businessunit/getall"
    And user has a query params from the file "staticBusinessUnit" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticBusinessUnitGetAll"
