@Regression @OnboardingRisk
Feature: Onboaring Risk API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add Onboarding Risk
    Given user has a service named "/api/v1/static/risk/add"
    And user has a payload from the file 'onboardingRisk'
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value     |
      | Name        | NEW RISK  |
      | Description | RISK DESC |
      | Priority    |         1 |
    And response body should match the schema from the file "onboardingRisk"
    When user store the response body keyData:"RiskID" with keyName:"riskID"

  Scenario: 002 Should be able to get Onboarding Risk
    Given user has a service named "/api/v1/static/risk/get"
    And user has a payload from the file 'onboardingRisk'
    And user has a query params from the file 'onboardingRisk' with selected keys 'ReturnFormat'
    And user add query parameter "RiskID" with the stored key value "riskID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value     |
      | Name        | NEW RISK  |
      | Description | RISK DESC |
      | Priority    |         1 |
    And response body should match the schema from the file "onboardingRisk"

  Scenario: 003 Should be able to Update Onboarding Risk
    Given user has a service named "/api/v1/static/risk/update"
    And user has a payload from the file 'onboardingRisk'
    And user add payload "RiskID" with the stored key value "riskID"
    And user has payloads:
      """
      {
        "Name": "NEW RISK -Update",
        "Description": "RISK DESC -Update",
        "Priority": "2"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value             |
      | Name        | NEW RISK -Update  |
      | Description | RISK DESC -Update |
      | Priority    |                 2 |
    And response body should match the schema from the file "onboardingRisk"

  Scenario: 004 Should be able to getall Onboarding Risk
    Given user has a service named "/api/v1/static/risk/getall"
    And user has a query params from the file "onboardingRisk" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboardingRiskGetAll"

  Scenario: 005 Should be able to delete Onboarding risk
    Given user has a service named "/api/v1/static/risk/delete"
    And user has a query params from the file 'onboardingRisk' with selected keys 'ActionUserID,ReturnFormat'
    And user add query parameter "RiskID" with the stored key value "riskID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value             |
      | Name        | NEW RISK -Update  |
      | Description | RISK DESC -Update |
      | Priority    |                 2 |
    And response body should match the schema from the file "onboardingRisk"
