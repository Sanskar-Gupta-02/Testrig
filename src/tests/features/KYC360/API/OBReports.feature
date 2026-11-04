@Regression @OBReport
Feature: OB Reports API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to get client onboarding summary
    Given user has a service named "/api/v1/report/clientonboarding/clientonboardingsummary"
    And user has a query params from the file "clientonboardingsummary" with selected keys "BusinessUnitID,OnboardingTypeID,OnboardingStageID,HandledByUserGroupID,HandledByUserID,IsTestSystem,FromDate,ToDate,ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "clientonboardingsummary"
    And response body should match the schema from the file "clientonboardingsummary"

  Scenario: 002 Should be able to get data collection summary
    Given user has a service named "/api/v1/report/clientonboarding/dcfSummary"
    And user has a query params from the file "dcfSummary" with selected keys "BusinessUnitID,FromDate,ToDate,ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "dcfSummary"
    And response body should match the schema from the file "dcfSummary"

  Scenario: 003 Should be able to get total prospect processing time
    Given user has a service named "/api/v1/report/clientonboarding/totalprospectprocessingtime"
    And user has a query params from the file "totalprospectprocessingtime" with selected keys "BusinessUnitID,OnboardingTypeID,ClientProspectGroupID,HandledByUserGroupID,HandledByUserID,IsTestSystem,FromDate,ToDate,ReturnFormat,PageSize,CurrentPage"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "totalprospectprocessingtime"
    And response body should match the schema from the file "totalprospectprocessingtime"
