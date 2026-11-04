@Regression @StaticCriteria
Feature: Static Criteria API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add Static Criteria
    Given user has a service named "/api/v1/static/criteria/add"
    And user has a payload from the file 'staticCriteria'
    And user store the unique value for key:
      | key  |
      | name |
    And user add payload key with stored key value:
      | payloadKey | storedkey |
      | Name       | name      |
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                             | value                   |
      | Description                     | Static Criteria Testing |
      | LastNameBias                    |                    0.75 |
      | FirstNameBias                   |                     0.1 |
      | MiddleNameBias                  |                     0.1 |
      | EntityTypeID                    |                       1 |
      | EntityTypeName                  | Person                  |
      | ReverseSearch                   | true                    |
      | Constrained                     | false                   |
      | IsPEP                           | false                   |
      | IsRCA                           | false                   |
      | IsWBL                           | true                    |
      | IsSAN                           | false                   |
      | IsAVM                           | true                    |
      | IsOTH                           | false                   |
      | IsUNK                           | true                    |
      | BumpDateExactMatch              |                      20 |
      | BumpDateMonthYearMatch          |                      30 |
      | BumpDateYearMatch               |                      20 |
      | BumpDateMonthMatch              |                      20 |
      | BumpCountryMatch                |                      20 |
      | IncludeEmptyMiddleNames         | true                    |
      | ExcludeDatesExceptExactMatch    | true                    |
      | ExcludeMatchesOutsideYearRange  |                      10 |
      | ExcludeMatchesCountryNoMatch    | true                    |
      | ExcludeCountryNoMatchIncludePEP | true                    |
      | ExcludeCountryNoMatchIncludeSAN | true                    |
      | ExcludeCountryNoMatchIncludeWBL | false                   |
    And response body should match the schema from the file "staticCriteria"
    When user store the response body keyData:"CriteriaID" with keyName:"criteriaID"

  Scenario: 002 Should be able to get Static Criteria #ENG-T11480
    Given user has a service named "/api/v1/static/criteria/get"
    And user add query parameter "CriteriaID" with the stored key value "criteriaID"
    And user has a query params from the file "staticCriteria" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                             | value                   |
      | Description                     | Static Criteria Testing |
      | LastNameBias                    |                    0.75 |
      | FirstNameBias                   |                     0.1 |
      | MiddleNameBias                  |                     0.1 |
      | EntityTypeID                    |                       1 |
      | EntityTypeName                  | Person                  |
      | ReverseSearch                   | true                    |
      | Constrained                     | false                   |
      | IsPEP                           | false                   |
      | IsRCA                           | false                   |
      | IsWBL                           | true                    |
      | IsSAN                           | false                   |
      | IsAVM                           | true                    |
      | IsOTH                           | false                   |
      | IsUNK                           | true                    |
      | BumpDateExactMatch              |                      20 |
      | BumpDateMonthYearMatch          |                      30 |
      | BumpDateYearMatch               |                      20 |
      | BumpDateMonthMatch              |                      20 |
      | BumpCountryMatch                |                      20 |
      | IncludeEmptyMiddleNames         | true                    |
      | ExcludeDatesExceptExactMatch    | true                    |
      | ExcludeMatchesOutsideYearRange  |                      10 |
      | ExcludeMatchesCountryNoMatch    | true                    |
      | ExcludeCountryNoMatchIncludePEP | true                    |
      | ExcludeCountryNoMatchIncludeSAN | true                    |
      | ExcludeCountryNoMatchIncludeWBL | false                   |
    And response body should match the schema from the file "staticCriteria"
    And response body should have key "CriteriaID" with the stored key value "criteriaID"

  Scenario: 003 Should be able to update Static Criteria
    Given user has a service named "/api/v1/static/criteria/update"
    And user has a payload from the file 'staticCriteria'
    And user add payload "CriteriaID" with the stored key value "criteriaID"
    And user store the unique value for key:
      | key  |
      | name |
    And user add payload key with stored key value:
      | payloadKey | storedkey |
      | Name       | name      |
    And user has payloads:
      """
      {
        "Description":"Static Criteria Testing -Update",
        "LastNameBias":"0.80",
        "FirstNameBias":"0.25",
        "MiddleNameBias":"0.5",
        "ReverseSearch":"false",
        "Constrained":"false"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                             | value                           |
      | Description                     | Static Criteria Testing -Update |
      | LastNameBias                    |                             0.8 |
      | FirstNameBias                   |                            0.25 |
      | MiddleNameBias                  |                             0.5 |
      | EntityTypeID                    |                               1 |
      | EntityTypeName                  | Person                          |
      | ReverseSearch                   | false                           |
      | Constrained                     | false                           |
      | IsPEP                           | false                           |
      | IsRCA                           | false                           |
      | IsWBL                           | true                            |
      | IsSAN                           | false                           |
      | IsAVM                           | true                            |
      | IsOTH                           | false                           |
      | IsUNK                           | true                            |
      | BumpDateExactMatch              |                              20 |
      | BumpDateMonthYearMatch          |                              30 |
      | BumpDateYearMatch               |                              20 |
      | BumpDateMonthMatch              |                              20 |
      | BumpCountryMatch                |                              20 |
      | IncludeEmptyMiddleNames         | true                            |
      | ExcludeDatesExceptExactMatch    | true                            |
      | ExcludeMatchesOutsideYearRange  |                              10 |
      | ExcludeMatchesCountryNoMatch    | true                            |
      | ExcludeCountryNoMatchIncludePEP | true                            |
      | ExcludeCountryNoMatchIncludeSAN | true                            |
      | ExcludeCountryNoMatchIncludeWBL | false                           |
    And response body should have key "CriteriaID" with the stored key value "criteriaID"
    And response body should match the schema from the file "staticCriteria"

  Scenario: 004 Should be able to get all Static Criteria #ENG-T11484
    Given user has a service named "/api/v1/static/criteria/getall"
    And user has a query params from the file "staticCriteria" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticCriteriaGetAll"

  Scenario: 005 Should be able to delete Static Criteria #ENG-T11485
    Given user has a service named "/api/v1/static/criteria/delete"
    And user add query parameter "CriteriaID" with the stored key value "criteriaID"
    And user has a query params from the file "staticCriteria" with selected keys "ActionUserID,ReturnFormat"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                             | value                           |
      | Description                     | Static Criteria Testing -Update |
      | LastNameBias                    |                             0.8 |
      | FirstNameBias                   |                            0.25 |
      | MiddleNameBias                  |                             0.5 |
      | EntityTypeID                    |                               1 |
      | EntityTypeName                  | Person                          |
      | ReverseSearch                   | false                           |
      | Constrained                     | false                           |
      | IsPEP                           | false                           |
      | IsRCA                           | false                           |
      | IsWBL                           | true                            |
      | IsSAN                           | false                           |
      | IsAVM                           | true                            |
      | IsOTH                           | false                           |
      | IsUNK                           | true                            |
      | BumpDateExactMatch              |                              20 |
      | BumpDateMonthYearMatch          |                              30 |
      | BumpDateYearMatch               |                              20 |
      | BumpDateMonthMatch              |                              20 |
      | BumpCountryMatch                |                              20 |
      | IncludeEmptyMiddleNames         | true                            |
      | ExcludeDatesExceptExactMatch    | true                            |
      | ExcludeMatchesOutsideYearRange  |                              10 |
      | ExcludeMatchesCountryNoMatch    | true                            |
      | ExcludeCountryNoMatchIncludePEP | true                            |
      | ExcludeCountryNoMatchIncludeSAN | true                            |
      | ExcludeCountryNoMatchIncludeWBL | false                           |
    And response body should have key "CriteriaID" with the stored key value "criteriaID"
    And response body should match the schema from the file "staticCriteria"
