@Regression @CLM @EntityPeriodicReview
Feature: Entity Periodic Review

  Background:
    Given user is authorized using an 'BEARER1'

  Scenario: 001 Create New Entity Meta Data For BU
    When user has a service named "/clm/draft/entities"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityDataAutomation1"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key             | value                             |
      | entityName      | Entities BU Automation 1          |
      | entityType.name | API Test Automaion - Do Not Touch |
    When user store the response body have keyData with keyName
      | key | storeKey |
      | id  | EntityID |
    And response body should match the expected data from the file "DraftEntityResponseData"

  Scenario: 002 Add BU to the Created Entity
    When user has a service named "/clm/draft/entities/<EntityID>/businessunits/"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityBUData"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key               | value                             |
      | entityName        | Entities BU Automation 1          |
      | entityType.name   | API Test Automaion - Do Not Touch |
      | businessUnit.id   | <CLM_BU_AUTOMATION_ID>            |
      | businessUnit.name | Automation Do Not Touch           |
      | workflow.state    | Draft                             |
    And response body should match the expected data from the file "DraftEntityBUResponseData"

  Scenario: 003 Create Entity Structure Periodic Review #ENG-T11961,T15415
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/reviews/<CLM_PERIODIC_REVIEW_ID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date": "07/09/2027"
      
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                        | value                           |
      | review.date        |                      07/09/2027 |
      | review.reason      | API automation - Do Not Touch |
      | review.description | API automation - Do Not Touch   |

  Scenario: 004 Create Entity Ad-Hoc Periodic Review #ENG-T11959,T15427
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/reviews"
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
    And response body should have key with the value:
      | key                        | value                               |
      | review.date        |                          07/09/2025 |
      | review.reason      | random reason just for testing      |
      | review.description | random test description for testing |

  Scenario: 005 Create Entity Ad-Hoc Periodic Review With Missing Required Fields Payload #ENG-T11963,T15429
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/reviews"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date":"07/09/2025",
      "description": "random test description for testing"
      }
      """
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                   |
      | title  | One or more validation errors occurred. |
      | status |                                     400 |
    And response body in ascending order should have index key with the contains value:
      | index | key           | value                         |
      |     1 | errors.Reason | The Reason field is required. |

  Scenario: 006 Create Entity Structure Periodic Review With Invalid Structure ID #ENG-T11962,T15417
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/reviews/019c89cd-cc48-72ac-be96-cf0781ee9ea6"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date":"07/09/2027"
      }
      """
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value       |
      | title  | Bad Request |
      | status |         400 |

  Scenario: 007 Validate When Adding Ad-hoc Periodic Review With Invalid Entity #ENG-T11960,T15433
    When user has a service named "clm/entities/<CLM_BU_AUTOMATION_ID>/businessunits/<CLM_BU_AUTOMATION_ID>/reviews"
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
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value            |
      | title  | Not Found        |
      | status |              404 |
      | detail | Entity not found |

  Scenario: 008 Create Entity Structure Periodic Review With Auth Key2 #ENG-T15416
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/reviews/<CLM_PERIODIC_REVIEW_ID>"
    And user is authorized using an 'BEARER2'
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date": "08/09/2027"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key           | value |
      | review.date   | 08/09/2027 |

  Scenario: 009 Reject Structure Periodic Review For A Different Entity Type #ENG-T15418
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/reviews/<CLM_GROUP_PERIODIC_REVIEW_ID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date": "07/09/2027"
      }
      """
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value       |
      | title  | Bad Request |
      | status |         400 |

  Scenario: 010 Reject Structure Periodic Review When Request Body Has No Date #ENG-T15419
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/reviews/<CLM_PERIODIC_REVIEW_ID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      }
      """
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                   |
      | title  | One or more validation errors occurred. |
      | status |                                     400 |
    And response body in ascending order should have index key with the contains value:
      | index | key         | value                      |
      |     1 | errors.Date | The Date field is required. |

  Scenario: 011 Create Structure Periodic Review With ISO Date Format #ENG-T15420
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/reviews/<CLM_PERIODIC_REVIEW_ID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date": "2027-09-07"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value      |
      | review.date | 09/07/2027 |

  Scenario: 012 Reject Structure Periodic Review When Entity Does Not Exist #ENG-T15421
    When user has a service named "clm/entities/<CLM_NONEXISTENT_ENTITY_ID>/businessunits/<CLM_BU_AUTOMATION_ID>/reviews/<CLM_PERIODIC_REVIEW_ID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date": "07/09/2027"
      }
      """
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                                        |
      | title  | Bad Request                                                  |
      | status |                                                          400 |
      | detail | Entity with ID '<CLM_NONEXISTENT_ENTITY_ID>' not found |

  Scenario: 013 Return Not Found For Structure Periodic Review When Business Unit Does Not Exist #ENG-T15422
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_NONEXISTENT_ENTITY_ID>/reviews/<CLM_PERIODIC_REVIEW_ID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date": "07/09/2027"
      }
      """
    And user sends a 'POST' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value     |
      | title  | Not Found |
      | status |       404 |

  Scenario: 014 Reject Structure Periodic Review When Business Unit Is Not Linked To Entity #ENG-T15423
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION2_ID>/reviews/<CLM_PERIODIC_REVIEW_ID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date": "07/09/2027"
      }
      """
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                                     |
      | title  | Bad Request                                               |
      | status |                                                       400 |
      | detail | Business Unit '<CLM_BU_AUTOMATION2_ID>' not found         |

  Scenario: 015 Reject Structure Periodic Review When API Key Cannot Access Business Unit #ENG-T15424
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_NO_ACCESS_ID>/reviews/<CLM_PERIODIC_REVIEW_ID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date": "07/09/2027"
      }
      """
    And user sends a 'POST' request
    Then response status should be 403
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/403 |
      | title  | Forbidden                   |
      | status |                         403 |

  Scenario: 016 Reject Structure Periodic Review When API Key Is Invalid #ENG-T15425
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/reviews/<CLM_PERIODIC_REVIEW_ID>"
    And user is authorized using an 'INVALIDBEARER'
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date": "07/09/2027"
      }
      """
    And user sends a 'POST' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                     |
      | title  | Unauthorized              |
      | status |                       401 |
      | detail | API Key validation failed |

  Scenario: 017 Return Not Found For Structure Periodic Review When Path Id Is Not A GUID #ENG-T15426
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/reviews/not-a-valid-guid"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date": "07/09/2027"
      }
      """
    And user sends a 'POST' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |

  Scenario: 018 Create Entity Ad-Hoc Periodic Review With Auth Key2 #ENG-T15428
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/reviews"
    And user is authorized using an 'BEARER2'
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date": "08/09/2025",
      "reason": "random reason just for testing",
      "description": "random test description for testing"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                | value                               |
      | review.date        |                          08/09/2025 |
      | review.reason      | random reason just for testing      |
      | review.description | random test description for testing |

  Scenario: 019 Reject Ad-Hoc Periodic Review When Date Is Missing #ENG-T15430
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/reviews"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "reason": "random reason just for testing",
      "description": "random test description for testing"
      }
      """
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                   |
      | title  | One or more validation errors occurred. |
      | status |                                     400 |
    And response body in ascending order should have index key with the contains value:
      | index | key         | value                         |
      |     1 | errors.Date | The Date field is required.   |

  Scenario: 020 Reject Ad-Hoc Periodic Review When Body Is Empty #ENG-T15431
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/reviews"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      }
      """
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value |
      | status |   400 |

  Scenario: 021 Create Ad-Hoc Periodic Review With ISO Date Format #ENG-T15432
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/reviews"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "date": "2025-09-07",
      "reason": "random reason just for testing",
      "description": "random test description for testing"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                | value                               |
      | review.date        |                          09/07/2025 |
      | review.reason      | random reason just for testing      |
      | review.description | random test description for testing |

  Scenario: 022 Return Not Found For Ad-Hoc Periodic Review When Business Unit Does Not Exist #ENG-T15434
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_NONEXISTENT_ENTITY_ID>/reviews"
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
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value     |
      | title  | Not Found |
      | status |       404 |

  Scenario: 023 Return Not Found For Ad-Hoc Periodic Review When Business Unit Is Not Linked To Entity #ENG-T15435
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION2_ID>/reviews"
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
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value     |
      | title  | Not Found |
      | status |       404 |

  Scenario: 024 Reject Ad-Hoc Periodic Review When API Key Cannot Access Business Unit #ENG-T15436
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_NO_ACCESS_ID>/reviews"
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
    Then response status should be 403
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/403 |
      | title  | Forbidden                   |
      | status |                         403 |

  Scenario: 025 Reject Ad-Hoc Periodic Review When API Key Is Invalid #ENG-T15437
    When user has a service named "clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/reviews"
    And user is authorized using an 'INVALIDBEARER'
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
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                     |
      | title  | Unauthorized              |
      | status |                       401 |
      | detail | API Key validation failed |
