@Regression @StaticGender
Feature: Static Gender API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to get all Static Gender
    Given user has a service named "/api/v1/static/gender/getall"
    And user has a query params from the file "staticGenderGetAll" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticGenderGetAll"
