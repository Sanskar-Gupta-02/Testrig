@Regression @CLM @GroupPeriodicReview
Feature: Group Periodic Review

  Background:
    Given user is authorized using an 'BEARER1'

  Scenario: 001 Create Group
    When user has a service named "clm/draft/groups/businessunits/<CLM_BU_AUTOMATION_ID>/groups"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
        "groupTypeId": "<CLM_GROUP_TYPE_ID>",
        "name": "Test Group for Automation in Periodic Review",
        "description": "This is a test group created for API automation testing. Please do not delete or modify this group as it is used in multiple test cases.",
        "primary": {
            "entityId": "<CLM_PRIMARY_ENTITY_ID>",
            "businessUnitId": "<CLM_BU_AUTOMATION_ID>"
        }
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    When user store the response body have keyData with keyName
      | key | storeKey |
      | id  | GroupID  |

  Scenario: 002 Submit and Publish Group
    When user has a service named "clm/draft/groups/businessunits/<CLM_BU_AUTOMATION_ID>/groups/<GroupID>/submit"
    And user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key | storedKey |
      | id  | GroupID   |
    And response body should have key with the value:
      | key               | value     |
      | publishing.status | Published |

  Scenario: 003 Create Group Ad-Hoc Periodic Review #ENG-T11964
    When user has a service named "clm/groups/businessunits/<CLM_BU_AUTOMATION_ID>/groups/<GroupID>/reviews"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date": "07/09/2025",
      "reason": "random reason just for testing",
      "description": "random test description for testing"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key      | storedKey |
      | group.id | GroupID   |
    And response body should have key with the value:
      | key                | value                               |
      | review.date        |                          07/09/2025 |
      | review.reason      | random reason just for testing      |
      | review.description | random test description for testing |

  Scenario: 004 Create Group Structure Periodic Review
    When user has a service named "clm/groups/businessunits/<CLM_BU_AUTOMATION_ID>/groups/<GroupID>/reviews/<CLM_GROUP_PERIODIC_REVIEW_ID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date": "07/09/2025"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key      | storedKey |
      | group.id | GroupID   |
    And response body should have key with the value:
      | key                | value                                 |
      | review.date        |                            07/09/2025 |
      | review.reason      | just for testing Group API automation |
      | review.description | API automation - Do Not Touch         |

  Scenario: 005 Create Group Structure Periodic Review With Invalid Structure ID
    When user has a service named "clm/groups/businessunits/<CLM_BU_AUTOMATION_ID>/groups/<GroupID>/reviews/019c9331-62c9-7263-8b4d-36265e10454f"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date": "07/09/2025"
      }
      """
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/400 |
      | title  | Bad Request                 |
      | status |                         400 |

  Scenario: 006 Create Group Ad-Hoc Periodic Review With Missing Required Fields Payload
    When user has a service named "clm/groups/businessunits/<CLM_BU_AUTOMATION_ID>/groups/<GroupID>/reviews"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date": "07/09/2025",
      "description": "API automation - Do Not Touch"
      }
      """
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/400 |
      | title  | Bad Request                 |
      | status |                         400 |
      | detail | 'Reason' must not be empty. |

  Scenario: 007 Validate When Adding Ad-hoc Periodic Review With Invalid Group #ENG-T11960
    When user has a service named "clm/groups/businessunits/<CLM_BU_AUTOMATION_ID>/groups/019c9466-a19b-7230-858b-7ca18b613e68/reviews"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date":"07/09/2025",
      "reason": "random reason just for testing",
      "description": "random test description for testing"
      }
      """
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/400 |
      | title  | Bad Request                 |
      | status |                         400 |
