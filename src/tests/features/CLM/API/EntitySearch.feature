@Regression @CLM @EntitySearch
Feature: Entity Search API

  Background:
    Given user is authorized using an 'BEARER1'

  Scenario: 001 Search for an Entity using valid search term
    When user has a service named "clm/entities/search"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "text": "automation",
      "fields": [
      {
      "key": "nickname",
      "value": "Entities BU Automation 1"
      }
      ]
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
      | index | key        | value                                                         |
      |     1 | errors.key |                                                               |
      |     1 | errors     | Only one of the parameters ['Text', 'Fields'] can be provided |

  Scenario: 002 Search for an Entity using only text as search term
    When user has a service named "clm/entities/search"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "text": "Automation"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "EntitySearchSchema"

  Scenario: 003 Search for an Entity using only fields as search term
    When user has a service named "clm/entities/search"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "fields": [
      {
      "key": "nickname",
      "value": "Entities BU Automation 1"
      }
      ]
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'

  Scenario: 004 Search for an Entity with Invalid API KEY
    When user has a service named "clm/entities/search"
    And user is authorized using an 'INVALIDBEARER'
    And user has raw payloads:
      """
      {
      "text": "Automation"
      }
      """
    And user sends a 'POST' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key      | value                     |
      | instance | POST /clm/entities/search |
      | title    | Unauthorized              |
      | status   |                       401 |
      | detail   | API Key validation failed |

  Scenario: 005 Search for an Entity using More than 4 fields
    When user has a service named "clm/entities/search"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "fields": [
      {
      "key":"k1",
      "value":"v1"
      },
      {
      "key":"k2",
      "value":"v2"
      },
      {
      "key":"k3",
      "value":"v3"
      },
      {
      "key":"k4",
      "value":"v4"
      },
      {
      "key":"k5",
      "value":"v5"
      }
      ]
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
      | index | key           | value                                                                        |
      |     1 | errors.key    |                                                                              |
      |     1 | errors.Fields | The field Fields must be a string or array type with a maximum length of '4' |

  Scenario: 006 Search for an Entity using fields as search term and missing Field Key
    When user has a service named "clm/entities/search"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "fields": [
      {
      "value": "Entities BU Automation 1"
      }
      ]
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

  Scenario: 007 Search for an Entity using fields as search term and missing Field Value
    When user has a service named "clm/entities/search"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "fields": [
      {
      "key": "nickname"
      }
      ]
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

  Scenario: 008 Search for an Entity using Text as a search term and Text length greater than 50 chars
    When user has a service named "clm/entities/search"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "text": "Automation for API Automation for API Automation for API Automation for API Automation for API"
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
      | index | key         | value                                                                        |
      |     1 | errors.key  |                                                                              |
      |     1 | errors.Text | The field Text must be a string or array type with a maximum length of '50'. |
