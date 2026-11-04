@Regression @StaticOnboardingStage
Feature: Static Onboarding Stage API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to get Static Onboarding Stage
    Given user has a service named "/api/v1/static/onboardingstage/get"
    And user has a query params from the file "staticOnboardingStage" with selected keys "OnboardingStageID,ReturnFormat,OnboardingTypeID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "staticOnboardingStage"
    And response body should match the schema from the file "staticOnboardingStage"

  Scenario: 002 Should be able to get all Static Onboarding Stage
    Given user has a service named "/api/v1/static/onboardingstage/getall"
    And user has a query params from the file "staticOnboardingStage" with selected keys "ReturnFormat,OnboardingTypeID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "staticOnboardingStageGetAll"
    And response body should match the schema from the file "staticOnboardingStageGetAll"

  Scenario: 003 Should be able to get Pre Screening Onboarding Stage
    Given user is authorized using an 'ALIASAPIKEY'
    And user has a service named "/api/v1/static/onboardingstage/get"
    And user has a query params from the file "preScreeningStaticOnboardingStage" with selected keys "OnboardingStageID,ReturnFormat,OnboardingTypeID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "preScreeningStaticOnboardingStage"
    And response body should match the schema from the file "preScreeningStaticOnboardingStage"

  Scenario: 004 Should be able to get all Pre Screening Onboarding Stage
    Given user is authorized using an 'ALIASAPIKEY'
    And user has a service named "/api/v1/static/onboardingstage/getall"
    And user has a query params from the file "preScreeningStaticOnboardingStage" with selected keys "ReturnFormat,OnboardingTypeID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "preScreeningStaticOnboardingStageGetAll"
    And response body should match the schema from the file "preScreeningStaticOnboardingStageGetAll"
