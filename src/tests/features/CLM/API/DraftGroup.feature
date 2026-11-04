@Regression @CLM @DraftGroup
Feature: Draft Group API

  Background:
    Given user is authorized using an 'BEARER1'

  Scenario: 001 Create a draft Group
    When user has a service named "clm/draft/groups/businessunits/<CLM_BU_AUTOMATION_ID>/groups"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "GroupPayloadData"
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                            | value                                                                                                                                    |
      | name                           | Test Group for Automation for API                                                                                                        |
      | description                    | This is a test group created for API automation testing. Please do not delete or modify this group as it is used in multiple test cases. |
      | groupType.id                   | <CLM_GROUP_TYPE_ID>                                                                                                                      |
      | groupType.name                 | Group Type - API Automation                                                                                                              |
      | primary.entity.id              | <CLM_PRIMARY_ENTITY_ID>                                                                                                                  |
      | primary.entity.nickname        | Primary Entity for Group - Do Not Touch                                                                                                  |
      | primary.entity.businessUnit.id | <CLM_BU_AUTOMATION_ID>                                                                                                                   |
    When user store the response body have keyData with keyName
      | key | storeKey |
      | id  | GroupID  |

  Scenario: 002 Get the draft Group By ID
    When user has a service named "clm/draft/groups/businessunits/<CLM_BU_AUTOMATION_ID>/groups/<GroupID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key | storedKey |
      | id  | GroupID   |
    When user store the response body have keyData with keyName
      | key        | storeKey       |
      | primary.id | ParentMemberID |

  Scenario: 003 Add Members to the Group
    When user has a service named "clm/draft/groups/businessunits/<CLM_BU_AUTOMATION_ID>/groups/<GroupID>/members"
    And user has header "Content-Type":"application/json"
    And user has raw payloads with dynamic values:
      """
      {
      "entityId": "<CLM_ENTITY_FOR_GROUP_ID>",
      "businessUnitId": "<CLM_BU_AUTOMATION_ID>",
      "parentMemberId": "{{ParentMemberID}}",
      "direction": 1
      
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                    | value                                       |
      | direction              |                                           1 |
      | entity.id              | <CLM_ENTITY_FOR_GROUP_ID>                   |
      | entity.businessUnit.id | <CLM_BU_AUTOMATION_ID>                      |
      | entity.nickname        | Entity For Relationship in Group Automation |
    When user store the response body have keyData with keyName
      | key                            | storeKey         |
      | id                             | MemberID         |
      | riskLayers[0].groupRiskLayerId | GroupRiskLayerID |

  Scenario: 004 Add Member to Group with Specific Member Id
    When user has a service named "clm/draft/groups/businessunits/<CLM_BU_AUTOMATION_ID>/groups/<GroupID>/members/<MemberID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads with dynamic values:
      """
      {
      "riskLayers": [
      {
      "groupRiskLayerId": "{{GroupRiskLayerID}}",
      "riskModelId": "<CLM_RISK_MODEL1_ID>",
      "weight": 70,
      "groupRiskLayerTypeId": "<CLM_GROUP_RISK_LAYER_TYPE_ID>"
      }
      ]
      }
      """
    And user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'

  Scenario: 005 Submit and Publish Group
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

  Scenario: 006 Submit and Publish Group when Group ID is Invalid
    When user has a service named "clm/draft/groups/businessunits/<CLM_BU_AUTOMATION_ID>/groups/019c949f-d428-7654-aea4-9877e3c65736/submit"
    And user sends a 'PUT' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |
      | detail | Group not found             |

  Scenario: 007 Get the Published Group By ID
    When user has a service named "clm/groups/businessunits/<CLM_BU_AUTOMATION_ID>/groups/<GroupID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key | storedKey |
      | id  | GroupID   |

  Scenario: 008 Get the Group when Group ID is Invalid
    When user has a service named "clm/groups/businessunits/<CLM_BU_AUTOMATION_ID>/groups/019c949f-d428-7654-aea4-9877e3c65736"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |
      | detail | Group not found             |

  Scenario: 009 Get the Group when it is not Published
    When user has a service named "clm/groups/businessunits/<CLM_BU_AUTOMATION_ID>/groups/<CLM_UNPUBLISHED_GROUP_ID>"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |
      | detail | No published version found  |

  Scenario: 010 Get the Draft Group when it is Published
    When user has a service named "clm/draft/groups/businessunits/<CLM_BU_AUTOMATION_ID>/groups/<GroupID>"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |
      | detail | No draft version found      |
