@Regression @CLM @GroupSearch
Feature: Group Search API

  Background:
    Given user is authorized using an 'BEARER1'

  Scenario: 001 Search for a Group using valid search term
    When user has a service named "clm/groups/search"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "name": "Automation for API",
      "businessUnitId": "<CLM_BU_AUTOMATION_ID>",
      "groupTypeId": "<CLM_GROUP_TYPE_ID>"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value |
      | hasMoreResults | true |
    And response body in ascending order should have index key with the value:
      | index | key                    | value                                                                                                                                    |
      |     1 | results.name           | Test Group for Automation for API                                                                                                        |
      |     1 | results.description    | This is a test group created for API automation testing. Please do not delete or modify this group as it is used in multiple test cases. |
      |     1 | results.businessUnitId |                                                                                                     <CLM_BU_AUTOMATION_ID> |
    And response body in ascending order should have index based on array key with the value:
      | index | key                  | value                                |
      |     1 | results.groupType.id | <CLM_GROUP_TYPE_ID> |

  Scenario: 002 Search for a Group When Name exceeds 150 characters
    When user has a service named "clm/groups/search"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "name": "Automation for API Automation for API Automation for API Automation for API Automation for API Automation for API Automation for API Automation for API",
      "businessUnitId": "<CLM_BU_AUTOMATION_ID>",
      "groupTypeId": "<CLM_GROUP_TYPE_ID>"
      }
      """
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                   |
      | type   | https://httpstatuses.io/400             |
      | title  | One or more validation errors occurred. |
      | status |                                     400 |
    And response body in ascending order should have index key with the contains value:
      | index | key         | value                                                                         |
      |     1 | errors.key  |                                                                               |
      |     1 | errors.Name | The field Name must be a string or array type with a maximum length of '150'. |

  Scenario: 003 Search for a Group using Invalid groupTypeId format
    When user has a service named "clm/groups/search"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "name": "Automation for API",
      "businessUnitId": "<CLM_BU_AUTOMATION_ID>",
      "groupTypeId": "019c932e-f3-72a1-b24b-757db91da7be"
      }
      """
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                   |
      | type   | https://httpstatuses.io/400             |
      | title  | One or more validation errors occurred. |
      | status |                                     400 |

  Scenario: 004 Search for a Group when Page = 0
    When user has a service named "clm/groups/search"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "name": "Automation for API",
      "businessUnitId": "<CLM_BU_AUTOMATION_ID>",
      "groupTypeId": "<CLM_GROUP_TYPE_ID>",
      "page": 0
      }
      """
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                   |
      | type   | https://httpstatuses.io/400             |
      | title  | One or more validation errors occurred. |
      | status |                                     400 |
    And response body in ascending order should have index key with the contains value:
      | index | key         | value                               |
      |     1 | errors.key  |                                     |
      |     1 | errors.Page | Page size must be between 1 and 100 |

  Scenario: 005 Search for a Group using Invalid API KEY
    When user has a service named "clm/groups/search"
    And user is authorized using an 'INVALIDBEARER'
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "name": "Automation for API",
      "businessUnitId": "<CLM_BU_AUTOMATION_ID>",
      "groupTypeId": "<CLM_GROUP_TYPE_ID>"
      }
      """
    And user sends a 'POST' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key      | value                     |
      | instance | POST /clm/groups/search   |
      | title    | Unauthorized              |
      | status   |                       401 |
      | detail   | API Key validation failed |

  Scenario: 006 Search for a Group using only businessUnitId and groupTypeId
    When user has a service named "clm/groups/search"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "businessUnitId": "<CLM_BU_AUTOMATION_ID>",
      "groupTypeId": "<CLM_GROUP_TYPE_ID>"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "GroupSearchSchema"

  Scenario: 007 Search for a Group using name which does not exist
    When user has a service named "clm/groups/search"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "name": "Automationssss",
      "businessUnitId": "<CLM_BU_AUTOMATION_ID>",
      "groupTypeId": "<CLM_GROUP_TYPE_ID>"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "GroupSearchSchema"
