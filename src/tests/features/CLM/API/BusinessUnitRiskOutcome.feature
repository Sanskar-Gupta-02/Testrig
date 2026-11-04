@Regression @CLM @BURISK
Feature: BusinessUnit Risk Outcome API

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

  Scenario: 002 Create BU for the Entity #ENG-T9428
    When user has a service named "/clm/draft/entities/<EntityID>/businessunits"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityBUData"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                 | value                             |
      | entityName          | Entities BU Automation 1          |
      | entityType.name     | API Test Automaion - Do Not Touch |
      | businessUnit.id     | <CLM_BU_AUTOMATION_ID>            |
      | businessUnit.name   | Automation Do Not Touch           |
      | workflow.state      | Draft                             |
    And response body should match the expected data from the file "BURiskCreateBUResponseData"

  Scenario: 003 Update BU for the Entity for Risk Trigger #ENG-T9423
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

  Scenario: 004 Get BU RISK
    When user wait from 30 seconds
    And user has a service named "/clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/risk"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                   | storedKey |
      |     1 | riskOutcomes.entityId | EntityID  |
      |     2 | riskOutcomes.entityId | EntityID  |
      |     3 | riskOutcomes.entityId | EntityID  |
    And response body should match the schema from the file "EntityBURiskSchema"

  Scenario: 005 Update BU data for the Entity #ENG-T9425
    When user has a service named "/clm/draft/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
          "fields": [
              { "value": "60.00", "key": "bu.data.automationbustructur.decimaldata" },
              { "value": "60",    "key": "bu.data.automationbustructur.integerdata" },
              { "value": "item2", "key": "bu.data.automationbustructur.listdata" }
          ]
      }
      """
    And user sends a 'PUT' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                 | value                             |
      | entityName          | Entities BU Automation 1          |
      | entityType.name     | API Test Automaion - Do Not Touch |
      | businessUnit.id     | <CLM_BU_AUTOMATION_ID>            |
      | businessUnit.name   | Automation Do Not Touch           |
      | workflow.state      | Draft                             |
    And response body should match the expected data from the file "BURiskUpdateBUResponseData"

  Scenario: 006 Submit BU DATA For Risk Trigger
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

  Scenario: 007 Get BU RISK After Submit
    When user wait from 30 seconds
    And user has a service named "/clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/risk"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                   | storedKey |
      |     1 | riskOutcomes.entityId | EntityID  |
      |     2 | riskOutcomes.entityId | EntityID  |
      |     3 | riskOutcomes.entityId | EntityID  |
    And response body should match the schema from the file "EntityBURiskSchema"

  Scenario: 008 BU RISK(Weighted) After Submit By Risk ID
    When user has a service named "/clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/risks/<CLM_RISK_MODEL1_ID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key      | storedKey |
      | entityId | EntityID  |
    And response body should have key with the value:
      | key                            | value                           |
      | entityTypeId                   | <CLM_ENTITY_TYPE_ID>            |
      | businessUnitId                 | <CLM_BU_AUTOMATION_ID>          |
      | riskModelId                    | <CLM_RISK_MODEL1_ID>            |
      | riskModelName                  | API Automation RT Weighted Risk |
      | score.calculatedRiskValue      |                             260 |
      | score.maxRiskValue             |                             315 |
      | score.normalisedRiskLevelScore |                               5 |
      | score.riskLevel                |                               5 |

  Scenario: 009 BU RISK(Total) After Submit By Risk ID
    When user has a service named "/clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/risks/<CLM_RISK_MODEL2_ID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key      | storedKey |
      | entityId | EntityID  |
    And response body should have key with the value:
      | key                            | value                        |
      | entityTypeId                   | <CLM_ENTITY_TYPE_ID>         |
      | businessUnitId                 | <CLM_BU_AUTOMATION_ID>       |
      | riskModelId                    | <CLM_RISK_MODEL2_ID>         |
      | riskModelName                  | API Automation RT Total Risk |
      | score.calculatedRiskValue      |                          310 |
      | score.maxRiskValue             |                          365 |
      | score.normalisedRiskLevelScore |                            5 |
      | score.riskLevel                |                            5 |

  Scenario: 0010 BU RISK(Single Highest Value) After Submit By Risk ID
    When user has a service named "/clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/risks/<CLM_RISK_MODEL3_ID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key      | storedKey |
      | entityId | EntityID  |
    And response body should have key with the value:
      | key                            | value                                       |
      | entityTypeId                   | <CLM_ENTITY_TYPE_ID>                        |
      | businessUnitId                 | <CLM_BU_AUTOMATION_ID>                      |
      | riskModelId                    | <CLM_RISK_MODEL3_ID>                        |
      | riskModelName                  | API Automation RT Single Highest Value Risk |
      | score.calculatedRiskValue      |                                          75 |
      | score.maxRiskValue             |                                          90 |
      | score.normalisedRiskLevelScore |                                        3.99 |
      | score.riskLevel                |                                           3 |

  Scenario: 011 Get All Risk Models #ENG-T10117
    When user has a service named "/clm/riskmodels"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "RiskModelSchema"

  Scenario: 012 Get Weighted Risk, Risk Model by ID
    When user has a service named "/clm/riskmodels/<CLM_RISK_MODEL1_ID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value                                          |
      | entityTypeId   | <CLM_ENTITY_TYPE_ID>                           |
      | businessUnitId | <CLM_BU_AUTOMATION_ID>                         |
      | id             | <CLM_RISK_MODEL1_ID>                           |
      | name           | API Automation RT Weighted Risk                |
      | description    | API Automation RT Weighted Risk - Do Not Touch |

  Scenario: 013 Get Total Risk, Risk Model by ID
    When user has a service named "/clm/riskmodels/<CLM_RISK_MODEL2_ID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value                                     |
      | entityTypeId   | <CLM_ENTITY_TYPE_ID>                      |
      | businessUnitId | <CLM_BU_AUTOMATION_ID>                    |
      | id             | <CLM_RISK_MODEL2_ID>                      |
      | name           | API Automation RT Total Risk              |
      | description    | API Automation RT Total Risk Do Not Touch |

  Scenario: 014 Get Single Highest Value Risk, Risk Model by ID
    When user has a service named "/clm/riskmodels/<CLM_RISK_MODEL3_ID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value                                                    |
      | entityTypeId   | <CLM_ENTITY_TYPE_ID>                                     |
      | businessUnitId | <CLM_BU_AUTOMATION_ID>                                   |
      | id             | <CLM_RISK_MODEL3_ID>                                     |
      | name           | API Automation RT Single Highest Value Risk              |
      | description    | API Automation RT Single Highest Value Risk Do Not touch |

  Scenario: 015 Get BU Risk with Invalid BU ID #ENG-10068
    When user has a service named "/clm/entities/<EntityID>/businessunits/0197b000-f889-723a-ad2c-80596d0457af/risks/019c69f0-1c3a-7756-870e-8f038050c00d"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |

  Scenario: 016 Get BU Risk with Invalid Risk Model ID #ENG-10069
    When user has a service named "/clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/risks/019c69f0-1c3a-7756-870e-8f038050c00e"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |
      | detail | Risk Model not found        |

  @Smoke
  Scenario: 017 Get Risk with Invalid Risk Model ID #ENG-10069
    When user has a service named "/clm/riskmodels/019c69f0-1c3a-7756-870e-8f038050c00e"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |
      | detail | Risk Model not found        |

