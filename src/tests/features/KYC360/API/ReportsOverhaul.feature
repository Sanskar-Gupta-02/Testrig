@Regression @ReportsOverhaul
Feature: Reports Overhaul API

  Scenario: 001 Successfully retrieve the first page of report #ENG-T11503,T11506
    Given user has a service named "/api/v1/reports/"
    And user has path parameter "MatchPotential"
    And user has a query params from the file "ReportsOverhaul" with selected keys "PageIndex,PageSize,UserId,SortColumn,SortDirection,Filters"
    When user sends a 'GET' request
    Then response status should be 401
    When user is authorized using an 'APIKEY'
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key           | value    |
      | SortColumn    | ClientId |
      | SortDirection | DESC     |
    And response body should match the schema from the file "ReportsOverhaul"

  Scenario: 002 Successfully retrieve the report with no filters #ENG-T11504
    Given user is authorized using an 'APIKEY'
    And user has a service named "/api/v1/reports/"
    And user has path parameter "MatchPotential"
    And user has a query params from the file "ReportsOverhaul" with selected keys "PageIndex,PageSize,UserId"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have array index key with the value:
      | arrayName | index | key                      | value    |
      | Items     |     1 | ClientInterfaceReference | AUTO2023 |
      | Items     |     2 | ClientInterfaceReference | AUTO2023 |
      | Items     |     3 | ClientInterfaceReference | AUTO2023 |
      | Items     |     4 | ClientInterfaceReference | AUTO2023 |
      | Items     |     5 | ClientInterfaceReference | AUTO2023 |
      | Items     |     6 | ClientInterfaceReference | AUTO2023 |
      | Items     |     7 | ClientInterfaceReference | AUTO2023 |
      | Items     |     8 | ClientInterfaceReference | AUTO2023 |
      | Items     |     9 | ClientInterfaceReference | AUTO2023 |
      | Items     |    10 | ClientInterfaceReference | AUTO2023 |
    And response should have 10 records at path 'Items'
    And response body should match the schema from the file "ReportsOverhaul"

  Scenario: 003 Successfully retrieve the report with multiple filters #ENG-T11505
    Given user is authorized using an 'APIKEY'
    And user has a service named "/api/v1/reports/"
    And user has path parameter "MatchPotential?PageIndex=1&PageSize=10&UserId=528&SortColumn=Id&SortDirection=DESC&Filters=GeneratedDate:MjAyNS8wMi8yMSAwMDowMDowMA==&Filters=FirstNameJCBias:MC44MTk0NDQ="
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have array index key with the value:
      | arrayName | index | key             | value               |
      | Items     |     1 | GeneratedDate   | 2025-02-21 00:00:00 |
      | Items     |     1 | FirstNameJCBias |            0.819444 |
      | Items     |     2 | GeneratedDate   | 2025-02-21 00:00:00 |
      | Items     |     2 | FirstNameJCBias |            0.819444 |
    And response should have 2 records at path 'Items'
    And response body should match the schema from the file "ReportsOverhaul"

  Scenario: 004 Invalid PageIndex returns Not Acceptable #ENG-T11507
    Given user is authorized using an 'APIKEY'
    And user has a service named "/api/v1/reports/"
    And user has path parameter "MatchPotential"
    And user has a query params from the file "ReportsOverhaul" with selected keys "PageSize,UserId"
    And user has query parameter "PageIndex":"abc"
    When user sends a 'GET' request
    Then response status should be 406
    And response header should be 'content-type':'application/json; charset=utf-8'

  Scenario: 005 Invalid filter format returns error #ENG-T11510
    Given user is authorized using an 'APIKEY'
    And user has a service named "/api/v1/reports/"
    And user has path parameter "MatchPotential"
    And user has a query params from the file "ReportsOverhaul" with selected keys "PageIndex,PageSize,UserId,SortColumn,SortDirection"
    And user has query parameter "Filters":"abc"
    When user sends a 'GET' request
    Then response status should be 400
    And response header should be 'content-type':'text/plain; charset=utf-8'