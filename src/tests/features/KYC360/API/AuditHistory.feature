@Regression @AuditHistory
Feature: Audit History API

  Background:
    Given user is authorized using an 'APIKEY'

  @Test
  Scenario: 001 Audit History getall should work as intened #ENG-T1249
    Given user has a service named "/api/v1/client/entity/audit/getall"
    And user has a query params from the file "AuditHistory" with selected keys "BusinessUnitID,UserID,FromDate,ToDate,ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "AuditHistory"
    And response body should have index key with the value:
      | index | key                  | value             |
      |     1 | ClientEntityID       |            436159 |
      |     1 | InterfaceReference   | APIADDCUSTOMERAVM |
      |     1 | LastName             | KUMAR             |
      |     1 | CriteriaID           |               253 |
      |     1 | CriteriaName         | Person 2          |
      |     1 | HandledByUserID      |               521 |
      |     1 | HandledByUserGroupID |               325 |
      |     1 | AuditTypeID          |                 2 |

  Scenario: 002 Audit History getall should work as intened on Non-default BU #ENG-T1249
    Given user has a service named "/api/v1/client/entity/audit/getall"
    And user has a query params from the file "AuditHistory" with selected keys "UserID,ReturnFormat"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "FromDate":"2025-05-14"
    And user has query parameter "ToDate":"2025-05-15"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "AuditHistory"
    And response body should have index key with the value:
      | index | key                  | value          |
      |     1 | ClientEntityID       |         434243 |
      |     1 | InterfaceReference   | APIADDCUSTOMER |
      |     1 | LastName             | KUMARUPDATE    |
      |     1 | CriteriaID           |            253 |
      |     1 | CriteriaName         | Person 2       |
      |     1 | HandledByUserID      |            521 |
      |     1 | HandledByUserGroupID |            325 |
      |     1 | AuditTypeID          |              3 |

  Scenario: 003 Audit History getallpaged should work as intened #ENG-T1477
    Given user has a service named "/api/v1/client/entity/audit/getallpaged"
    And user has a query params from the file "AuditHistoryGetAll" with selected keys "BusinessUnitID,UserID,FromDate,ToDate,SearchString,SearchOn,SearchType,SearchStatus,CurrentPage,PageSize,ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "AuditHistoryGetAll"
    And response body have key with the value for nested object:
      | key                    | value  |
      | Data[0].ClientEntityID | 433487 |
      | Data[1].ClientEntityID | 433487 |

  Scenario: 004 Audit History getallpaged should work as intened on Non-Defaul BU #ENG-T1477
    Given user has a service named "/api/v1/client/entity/audit/getallpaged"
    And user has a query params from the file "AuditHistoryGetAll" with selected keys "UserID,FromDate,ToDate,SearchString,SearchOn,SearchType,SearchStatus,CurrentPage,PageSize,ReturnFormat"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "SearchString":"kumar"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "AuditHistoryGetAll"
    And response body have key with the value for nested object:
      | key                    | value  |
      | Data[0].ClientEntityID | 436014 |
      | Data[1].ClientEntityID | 436144 |
