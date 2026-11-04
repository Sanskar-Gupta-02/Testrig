@Regression @OnboardingProfileType
Feature: Onboarding Profile Type

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to get Onboarding Profile Type
    Given user has a service named "/api/v1/static/onboardingprofiletype/get"
    And user has a payload from the file 'onboardingProfileType'
    And user has a query params from the file 'onboardingProfileType' with selected keys 'OnboardingProfileTypeID,ReturnFormat'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                              | value       |
      | OnboardingProfileTypeID          |         577 |
      | OnboardingProfileTypeName        | KYC360 eIDV |
      | OnboardingProfileTypeDescription | KYC360 eIDV |
    And response body should match the schema from the file "onboardingProfileType"

  Scenario: 002 Should be able to getall Onboarding Profile Type
    Given user has a service named "/api/v1/static/onboardingprofiletype/getall"
    And user has a query params from the file "onboardingProfileType" with selected keys "ActionUserID,ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboardingProfileTypeGetAll"
