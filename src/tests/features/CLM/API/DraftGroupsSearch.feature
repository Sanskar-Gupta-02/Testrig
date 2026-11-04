@Regression @CLM @DraftGroupsSearch
Feature: Draft Group Search API

  Background:
    Given user is authorized using an 'BEARER1'

  Scenario: 001 Search for draft groups using a valid page number #ENG-15504,#ENG-15474
    When user has a service named "clm/draft/groups/search"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "DraftGroupsSearchPayloadData" with payload key "validSearch"
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "GroupSearchSchema"
    And response body in ascending order should have index key with the value:
      | index | key                    | value             |
      |     1 | results.name           | Test Group for Automation for API                                                                                                        |
      |     1 | results.description    | This is a test group created for API automation testing. Please do not delete or modify this group as it is used in multiple test cases. |
      |     1 | results.businessUnitId | <CLM_BU_AUTOMATION_ID>                                                                                                                   |
    And response body in ascending order should have index based on array key with the value:
      | index | key                  | value               |
      |     1 | results.groupType.id | <CLM_GROUP_TYPE_ID> |

  Scenario: 002 Search for a draft Group using Invalid groupTypeId format #ENG-15505
    When user has a service named "clm/draft/groups/search"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "DraftGroupsSearchPayloadData" with payload key "invalidGroupTypeId"
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                   |
      | type   | https://httpstatuses.io/400             |
      | title  | One or more validation errors occurred. |
      | status | 400                                     |

  Scenario: 003 Search for a draft Group when Page = 0 #ENG-15506
    When user has a service named "clm/draft/groups/search"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "DraftGroupsSearchPayloadData" with payload key "pageZero"
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                   |
      | type   | https://httpstatuses.io/400             |
      | title  | One or more validation errors occurred. |
      | status | 400                                     |
    And response body in ascending order should have index key with the contains value:
      | index | key         | value                               |
      |     1 | errors.key  |                                     |
      |     1 | errors.Page | Page size must be between 1 and 100 |

  Scenario: 004 Search for a draft Group using Invalid API KEY #ENG-15507
    When user has a service named "clm/draft/groups/search"
    And user is authorized using an 'INVALIDBEARER'
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "DraftGroupsSearchPayloadData" with payload key "validSearch"
    And user sends a 'POST' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key      | value                         |
      | instance | POST /clm/draft/groups/search |
      | title    | Unauthorized                  |
      | status   | 401                           |
      | detail   | API Key validation failed     |

  Scenario: 005 Search for a draft Group using a name which does not exist #ENG-15508
    When user has a service named "clm/draft/groups/search"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "DraftGroupsSearchPayloadData" with payload key "nameNotFound"
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "GroupSearchSchema"
    And response body should have key with the value:
      | key            | value |
      | hasMoreResults | false |
      | results        | []    |

  Scenario: 006 Search for a draft group without businessUnitId #ENG-15509
    When user has a service named "clm/draft/groups/search"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "DraftGroupsSearchPayloadData" with payload key "withoutBusinessUnitId"
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "GroupSearchSchema"
    And response body should have key with the value:
      | key            | value |
      | hasMoreResults | false |
    And response body in ascending order should have index based on array key with the value:
      | index | key                    | value                             |
      |     1 | results.name           | Test Group for Automation for API |
      |     1 | results.businessUnitId | <CLM_BU_AUTOMATION_ID>            |
      |     1 | results.groupType.id   | <CLM_GROUP_TYPE_ID>               |

  Scenario: 007 Search for a draft group when page exceeds available results #ENG-15510
    When user has a service named "clm/draft/groups/search"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "DraftGroupsSearchPayloadData" with payload key "pageBeyondResults"
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "GroupSearchSchema"
    And response body should have key with the value:
      | key            | value |
      | hasMoreResults | false |
      | results        | []    |

  Scenario: 008 Search for a draft group with no request body #ENG-15511
    When user has a service named "clm/draft/groups/search"
    And user has header "Content-Type":"application/json"
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                   |
      | type   | https://httpstatuses.io/400             |
      | title  | One or more validation errors occurred. |
      | status | 400                                     |
    And response body should contains "A non-empty request body is required."

  Scenario: 009 Search for a draft group with an empty JSON object #ENG-15512
    When user has a service named "clm/draft/groups/search"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "DraftGroupsSearchPayloadData" with payload key "emptyPayload"
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                   |
      | type   | https://httpstatuses.io/400             |
      | title  | One or more validation errors occurred. |
      | status | 400                                     |
    And response body should contains "A non-empty request body is required."

  Scenario: 010 Search for a draft group with an invalid request payload #ENG-15571
    When user has a service named "clm/draft/groups/search"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "DraftGroupsSearchPayloadData" with payload key "pageOverflow"
    And user sends a 'POST' request
    Then response status should be 500
    And response body should have key with the value:
      | key      | value                         |
      | type     | CosmosException               |
      | title    | InternalServerError           |
      | status   | 500                           |
      | instance | POST /clm/draft/groups/search |
    And response body should contains "The OFFSET count value exceeds the maximum allowed value."

  Scenario: 011 Search for a draft group when page is greater than 100
    When user has a service named "clm/draft/groups/search"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
        "page": 101,
        "name": "Automation for API",
        "businessUnitId": "<CLM_BU_AUTOMATION_ID>",
        "groupTypeId": "<CLM_GROUP_TYPE_ID>"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "GroupSearchSchema"
    And response body should have key with the value:
      | key            | value |
      | hasMoreResults | false |
