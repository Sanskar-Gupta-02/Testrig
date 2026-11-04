@Regression @CLM @ScreeningSubmit
Feature: Entity Screening Submit API

  Background:
    Given user is authorized using an 'BEARER1'

  Scenario Outline: 001 Create Entity Meta Data For Screening Submit
    When user has a service named "/clm/draft/entities"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "ScreeningEntityData"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key        | value                       |
      | entityName | Screening Submit Automation |
    When user store the response body have keyData with keyName
      | key | storeKey   |
      | id  | <storeKey> |

    Examples:
      | storeKey       |
      | EntityID       |
      | SecondEntityID |
      | ThirdEntityID  |

  Scenario Outline: 002 Add Screening BU to the Created Entity
    When user has a service named "/clm/draft/entities/<<entityKey>>/businessunits/"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "ScreeningEntityBUData"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key             | value                            |
      | entityName      | Screening Submit Automation      |
      | businessUnit.id | <CLM_SCREENING_INDIVIDUAL_BU_ID> |
      | workflow.state  | Draft                            |

    Examples:
      | entityKey      |
      | EntityID       |
      | SecondEntityID |
      | ThirdEntityID  |

  Scenario: 003 Submit Entity to Screening With Invalid Screening Mode #ENG-T15516
    When user has a service named "/clm/entities/<EntityID>/businessunits/<CLM_SCREENING_INDIVIDUAL_BU_ID>/screening/submit"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
          "screeningMode": 0
      }
      """
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                            |
      | type   | https://httpstatuses.io/400      |
      | title  | Bad Request                      |
      | status |                              400 |
      | detail | Invalid screening mode 'NotSet'. |

  @Smoke
  Scenario: 004 Submit Entity to Screening With Overnight Mode #ENG-T15514
    When user has a service named "/clm/entities/<EntityID>/businessunits/<CLM_SCREENING_INDIVIDUAL_BU_ID>/screening/submit"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
          "screeningMode": 2
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key      | storedKey |
      | entityId | EntityID  |
    And response body should have key with the value:
      | key    | value |
      | status |     1 |

  @Smoke
  Scenario: 005 Submit Entity to Screening With Now Mode #ENG-T15475
    When user has a service named "/clm/entities/<SecondEntityID>/businessunits/<CLM_SCREENING_INDIVIDUAL_BU_ID>/screening/submit"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
          "screeningMode": 1
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key      | storedKey      |
      | entityId | SecondEntityID |
    And response body should have key with the value:
      | key    | value |
      | status |     1 |

  @Smoke
  Scenario: 006 Submit Entity to Screening With Inactive Mode #ENG-T15515
    When user has a service named "/clm/entities/<ThirdEntityID>/businessunits/<CLM_SCREENING_INDIVIDUAL_BU_ID>/screening/submit"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
          "screeningMode": 3
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key      | storedKey     |
      | entityId | ThirdEntityID |
    And response body should have key with the value:
      | key    | value |
      | status |     1 |

  Scenario: 007 Submit Already Submitted Entity to Screening #ENG-T15517
    When user has a service named "/clm/entities/<EntityID>/businessunits/<CLM_SCREENING_INDIVIDUAL_BU_ID>/screening/submit"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
          "screeningMode": 2
      }
      """
    And user sends a 'POST' request
    Then response status should be 409
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                  |
      | type   | https://httpstatuses.io/409            |
      | title  | Conflict                               |
      | status |                                    409 |
      | detail | Entity already submitted to screening. |

  Scenario: 008 Submit Entity to Screening When Entity Does Not Exist #ENG-T15518
    When user has a service named "/clm/entities/00a133e2-1e9f-766f-a11b-659aee6dd000/businessunits/<CLM_SCREENING_INDIVIDUAL_BU_ID>/screening/submit"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
          "screeningMode": 2
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

  Scenario: 009 Submit Entity to Screening With Invalid Auth Key
    When user has a service named "/clm/entities/<EntityID>/businessunits/<CLM_SCREENING_INDIVIDUAL_BU_ID>/screening/submit"
    And user is authorized using an "INVALIDBEARER"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
          "screeningMode": 2
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

  Scenario: 010 Submit Entity to Screening Without Business Unit Access #ENG-T15519
    When user has a service named "/clm/entities/<EntityID>/businessunits/<CLM_BU_NO_ACCESS_ID2>/screening/submit"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
          "screeningMode": 2
      }
      """
    And user sends a 'POST' request
    Then response status should be 403
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value     |
      | title  | Forbidden |
      | status |       403 |

  Scenario: 011 Create Entity For On Demand Screening
    When user has a service named "/clm/draft/entities"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "ScreeningEntityData"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key        | value                       |
      | entityName | Screening Submit Automation |
    When user store the response body have keyData with keyName
      | key | storeKey         |
      | id  | OnDemandEntityID |

  Scenario: 012 Add Screening BU to the On Demand Entity
    When user has a service named "/clm/draft/entities/<OnDemandEntityID>/businessunits/"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "ScreeningEntityBUData"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key             | value                            |
      | entityName      | Screening Submit Automation      |
      | businessUnit.id | <CLM_SCREENING_INDIVIDUAL_BU_ID> |
      | workflow.state  | Draft                            |

  Scenario: 013 Approve Screening BU for the On Demand Entity
    When user has a service named "/clm/draft/entities/<OnDemandEntityID>/businessunits/<CLM_SCREENING_INDIVIDUAL_BU_ID>/submit"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
          "skipFourEyes": true
      }
      """
    And user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value    |
      | workflow.state | Approved |

  @Smoke
  Scenario: 014 Trigger On Demand Screening #ENG-T15520
    When user has a service named "/clm/entities/<OnDemandEntityID>/businessunits/<CLM_SCREENING_INDIVIDUAL_BU_ID>/screening/submit/now"
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key      | storedKey        |
      | entityId | OnDemandEntityID |
    And response body should have key with the value:
      | key    | value |
      | status |     1 |

  Scenario: 015 Trigger On Demand Screening Again Returns Too Many Requests #ENG-T15521
    When user has a service named "/clm/entities/<OnDemandEntityID>/businessunits/<CLM_SCREENING_INDIVIDUAL_BU_ID>/screening/submit/now"
    And user sends a 'POST' request
    Then response status should be 429
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/429 |
      | title  | Too Many Requests           |
      | status |                         429 |

  Scenario: 016 Trigger On Demand Screening When Data Is Not Approved #ENG-T15522
    When user has a service named "/clm/entities/<EntityID>/businessunits/<CLM_SCREENING_INDIVIDUAL_BU_ID>/screening/submit/now"
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/400 |
      | title  | Bad Request                 |
      | status |                         400 |

  Scenario: 017 Trigger On Demand Screening When Entity Does Not Exist #ENG-T15523
    When user has a service named "/clm/entities/00a133e2-1e9f-766f-a11b-659aee6dd000/businessunits/<CLM_SCREENING_INDIVIDUAL_BU_ID>/screening/submit/now"
    And user sends a 'POST' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |

  Scenario: 018 Trigger On Demand Screening Without Business Unit Access #ENG-T15524
    When user has a service named "/clm/entities/<EntityID>/businessunits/<CLM_BU_NO_ACCESS_ID2>/screening/submit/now"
    When user has a service named "/clm/entities/<OnDemandEntityID>/businessunits/<CLM_BU_NO_ACCESS_ID2>/screening/submit/now"
    And user sends a 'POST' request
    Then response status should be 403
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value     |
      | title  | Forbidden |
      | status |       403 |
