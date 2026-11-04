@Regression @CLM @EntitiesBusinessUnits
Feature: Entities Business Units

  Background:
    Given user is authorized using an 'BEARER1'

  Scenario: 001 Create Entity Meta Data For BU
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

  Scenario: 002 Create Another Entity Meta Data For BU Automation 1
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
      | key | storeKey       |
      | id  | SecondEntityID |
    And response body should match the expected data from the file "DraftSecondEntityResponseData"

  Scenario: 003 Add BU to the First created Entity #ENG-T9428
    When user has a service named "/clm/draft/entities/<EntityID>/businessunits/"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityBUData"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key               | value                             |
      | entityName          | Entities BU Automation 1        |
      | entityType.name   | API Test Automaion - Do Not Touch |
      | businessUnit.id   | <CLM_BU_AUTOMATION_ID>            |
      | businessUnit.name | Automation Do Not Touch           |
      | workflow.state    | Draft                             |
    And response body should match the expected data from the file "DraftEntityBUResponseData"

  Scenario: 004 Add BU to the created Entity #ENG-T9428
    When user has a service named "/clm/draft/entities/<SecondEntityID>/businessunits/"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntitySecondBUData"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key               | value                             |
      | entityName          | Entities BU Automation 1        |
      | entityType.name   | API Test Automaion - Do Not Touch |
      | businessUnit.id   | <CLM_BU_4EYE_ID>                  |
      | businessUnit.name |           4 Eye Enable Automation |
      | workflow.state    | Draft                             |
    And response body should match the expected data from the file "DraftSecondEntityBUResponseData"

  Scenario: 005 Add Already Added BU for the Entity #ENG-T9430
    When user has a service named "/clm/draft/entities/<EntityID>/businessunits/"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityBUData"
    And user sends a 'POST' request
    Then response status should be 409
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                      |
      | type   | https://httpstatuses.io/409                |
      | title  | Conflict                                   |
      | status |                                        409 |
      | detail | Entity already contains this Business Unit |

  Scenario: 006 Add BU for the Entity When Entity Not Exists #ENG-T9433
    When user has a service named "/clm/draft/entities/<CLM_BU_4EYE_ID>/businessunits"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityBUData"
    And user sends a 'POST' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |
      | detail | Entity not found            |

  Scenario: 007 Add BU for the Entity When BU Does Not Have Data Structure
    When user has a service named "/clm/draft/entities/<SecondEntityID>/businessunits"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
       "businessUnitId": "<CLM_BU_AUTOMATION2_ID>",
      		"workflow": {
      		"comment": "test"
      		},
          "fields": []
      }
      """
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key               | value                             |
      | entityName          | Entities BU Automation 1        |
      | entityType.name   | API Test Automaion - Do Not Touch |
      | businessUnit.id   | <CLM_BU_AUTOMATION2_ID>           |
      | businessUnit.name | Automation 2                      |
      | workflow.state    | Draft                             |
      | fields            | []                                |

  Scenario: 008 Add BU for the Entity When Data Fields validation violation #ENG-T9435
    When user has a service named "/clm/draft/entities/<SecondEntityID>/businessunits"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityBUDataVoilation"
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value            |
      | title  | Validation error |
      | status |              400 |
    And response body in ascending order should have index key with the contains value:
      | index | key             | value                                                       |
      |     1 | errors.key      | bu.data.automationbustructur.linksdata                      |
      |     2 | errors.key      | bu.data.automationbustructur.datedata                       |
      |     3 | errors.key      | bu.data.automationbustructur.decimaldata                    |
      |     4 | errors.key      | bu.data.automationbustructur.integerdata                    |
      |     5 | errors.key      | bu.data.automationbustructur.emaildata                      |
      |     6 | errors.key      | bu.data.automationbustructur.giindata                       |
      |     7 | errors.key      | bu.data.automationbustructur.tindata                        |
      |     1 | errors.messages | Value is not correct for this Data Field, expected Links    |
      |     2 | errors.messages | date data must not be earlier than 01/01/2026               |
      |     3 | errors.messages | decimal data must not be greater than 100.999               |
      |     4 | errors.messages | integer data must not be greater than 200                   |
      |     5 | errors.messages | email data should match the pattern ^[^@]+@[^@]+\\\\.[^@]+$ |
      |     6 | errors.messages | giin data must not be longer than 19 characters             |
      |     7 | errors.messages | tin data must not be longer than 19 characters              |

  Scenario: 009 Add BU for the Entity When Invalid Key Data Field #ENG-T9436
    When user has a service named "/clm/draft/entities/<SecondEntityID>/businessunits/"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityBUInvalidDataKey"
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value            |
      | title  | Validation error |
      | status |              400 |
    And response body in ascending order should have index key with the contains value:
      | index | key             | value                                                  |
      |     1 | errors.key      | bu.data.automationbustructur.dateoNCKJSJJDfbirthdata   |
      |     1 | errors.messages | The data structure does not have a corresponding field |

  Scenario: 010 Add BU for the Entity With Invalid Auth Key #ENG-T9437
    When user has a service named "/clm/draft/entities/<EntityID>/businessunits/"
    And user is authorized using an "INVALIDBEARER"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityBUData"
    And user sends a 'POST' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                     |
      | title  | Unauthorized              |
      | status |                       401 |
      | detail | API Key validation failed |

  Scenario: 011 Update BU for the Entity #ENG-T9425
    When user has a service named "/clm/draft/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
          "fields": [
              { "value": false, "key": "bu.data.automationbustructur.booleandata" }
          ]
      }
      """
    And user sends a 'PUT' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key               | value                             |
      | entityName          | Entities BU Automation 1        |
      | entityType.name   | API Test Automaion - Do Not Touch |
      | businessUnit.id   | <CLM_BU_AUTOMATION_ID>            |
      | businessUnit.name | Automation Do Not Touch           |
      | workflow.state    | Draft                             |
    And response body should match the expected data from the file "UpdateEntityBUResponseData"

  Scenario: 012 Update BU for the Entity When Entity Not Exists #ENG-T9419
    When user has a service named "/clm/draft/entities/a399584c-6fd0-4eac-b9b1-99481cc31ae7/businessunits/<CLM_BU_AUTOMATION_ID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
          "fields": [
              { "value": false, "key": "bu.data.automationbustructur.booleandata" }
          ]
      }
      """
    And user sends a 'PUT' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |
      | detail | Entity not found            |

  Scenario: 013 Update BU for the Entity When Field Validation violation #ENG-T9420
    When user has a service named "/clm/draft/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      { 
          "fields": [
              { "value": 2000, "key": "bu.data.automationbustructur.integerdata" }
          ]
      }
      """
    And user sends a 'PUT' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value            |
      | title  | Validation error |
      | status |              400 |
    And response body in ascending order should have index key with the contains value:
      | index | key             | value                                     |
      |     1 | errors.key      | bu.data.automationbustructur.integerdata  |
      |     1 | errors.messages | integer data must not be greater than 200 |

  Scenario: 014 Update BU for the Entity When Field Does Not Exists #ENG-T9421
    When user has a service named "/clm/draft/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
          "fields": [
              { "value": "2000", "key": "bu.data.automationbustructur.intssegerdata" }
          ]
      }
      """
    And user sends a 'PUT' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value            |
      | title  | Validation error |
      | status |              400 |
    And response body in ascending order should have index key with the contains value:
      | index | key             | value                                                  |
      |     1 | errors.key      | bu.data.automationbustructur.intssegerdata             |
      |     1 | errors.messages | The data structure does not have a corresponding field |

  Scenario: 015 Update BU for the Entity When Auth Key Do Not have BU Access #ENG-T9423
    When user has a service named "/clm/draft/entities/<EntityID>/businessunits/<CLM_BU_NO_ACCESS_ID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
          "fields": [
              { "value": "2000", "key": "bu.data.automationbustructur.intssegerdata" }
          ]
      }
      """
    And user sends a 'PUT' request
    Then response status should be 403
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/403 |
      | title  | Forbidden                   |
      | status |                         403 |

  Scenario: 016 Get BU for the Entity when Data is Not Approved #ENG-T9370
    When user has a service named "/clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>"
    And user has header "Content-Type":"application/json"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                |
      | title  | Not Found            |
      | detail | Data is not Approved |

  Scenario: 017 Update BU for the Entity #ENG-T9429
    When user has a service named "/clm/draft/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/submit"
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

  Scenario: 018 Get BU for the Entity #ENG-T9364,T9370
    When user has a service named "/clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>"
    And user has header "Content-Type":"application/json"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key               | value                             |
      | entityName          | Entities BU Automation 1        |
      | entityType.name   | API Test Automaion - Do Not Touch |
      | businessUnit.id   | <CLM_BU_AUTOMATION_ID>            |
      | businessUnit.name | Automation Do Not Touch           |
      | workflow.state    | Approved                          |
    And response body should match the expected data from the file "ApprovedEntityBUResponseData"

  Scenario: 019 Get BU for the Entity When Entity Does Not Exists #ENG-T9367
    When user has a service named "/clm/entities/<CLM_BU_4EYE_ID>/businessunits/<CLM_BU_AUTOMATION_ID>"
    And user has header "Content-Type":"application/json"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |
      | detail | Entity not found            |

  Scenario: 020 Get BU for the Entity When API Do not Have Access to BU #ENG-T9366
    When user has a service named "/clm/entities/<CLM_BU_4EYE_ID>/businessunits/<CLM_BU_NO_ACCESS_ID>"
    And user has header "Content-Type":"application/json"
    And user sends a 'GET' request
    Then response status should be 403
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/403 |
      | title  | Forbidden                   |
      | status |                         403 |

  Scenario: 021 Get BU for the Entity When BU Does Not Exists #ENG-T9368
    When user has a service named "/clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION2_ID>"
    And user has header "Content-Type":"application/json"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |

  Scenario: 022 GET - Unauthorized access with invalid Auth connection. #ENG-T9365
    When user has a service named "/clm/entities/<CLM_BU_4EYE_ID>/businessunits/<CLM_BU_AUTOMATION_ID>"
    And user is authorized using an "INVALIDBEARER"
    And user has header "Content-Type":"application/json"
    And user sends a 'GET' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                     |
      | title  | Unauthorized              |
      | status |                       401 |
      | detail | API Key validation failed |
