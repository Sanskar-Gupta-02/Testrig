@Regression @CLM @BUConfig
Feature: Business Units Configuration

  Background:
    Given user is authorized using an 'BEARER1'

  @Test @Smoke
  Scenario: 001 Get All Business Units Configuration #ENG-T9975
    When user has a service named "/clm/businessunits/"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "BusinessUnitsConfig"

  Scenario: 002 Get All Business Units Configuration With Pagination #ENG-T9975
    When user has a service named "/clm/businessunits?page=1&pageSize=5"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key      | value |
      | pageSize |     5 |
      | page     |     1 |

  Scenario: 003 Get All Business Units Configuration With Auth Key2 #ENG-T9986
    When user has a service named "/clm/businessunits/"
    And user is authorized using an 'BEARER2'
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "BusinessUnitsConfig"

  Scenario: 004 Get All Business Units Configuration With Invalid Auth Key #ENG-T9977,T9978
    When user has a service named "/clm/businessunits/"
    And user is authorized using an 'INVALIDBEARER'
    And user sends a 'GET' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key      | value                     |
      | instance | GET /clm/businessunits/   |
      | title    | Unauthorized              |
      | status   |                       401 |
      | detail   | API Key validation failed |

  @Smoke
  Scenario: 005 Get Business Unit Configuration By ID #ENG-T9929
    When user has a service named "/clm/businessunits/<CLM_BU_AUTOMATION_ID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value                       |
      | id          | <CLM_BU_AUTOMATION_ID>      |
      | name        | Automation Do Not Touch     |
      | description | Automation Do Not Touch     |
      | recordState |                           1 |

  Scenario: 006 Get Business Unit Configuration By ID With API Key2 #ENG-T9929
    When user has a service named "/clm/businessunits/<CLM_BU_AUTOMATION_ID>"
    And user is authorized using an 'BEARER2'
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value                       |
      | id          | <CLM_BU_AUTOMATION_ID>      |
      | name        | Automation Do Not Touch     |
      | description | Automation Do Not Touch     |
      | recordState |                           1 |

  Scenario: 007 Get Business Unit Configuration By ID With Invalid API Key #ENG-T9933,T9934
    When user has a service named "/clm/businessunits/<CLM_BU_AUTOMATION_ID>"
    And user is authorized using an 'INVALIDBEARER'
    And user sends a 'GET' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key      | value                                               |
      | instance | GET /clm/businessunits/<CLM_BU_AUTOMATION_ID>       |
      | title    | Unauthorized                                        |
      | status   |                                                 401 |
      | detail   | API Key validation failed                           |

  @Smoke
  Scenario: 008 Get Business Unit Configuration Wiht Invalid BU ID #ENG-T9932
    When user has a service named "/clm/businessunits/d8cfc1cc-77df-46fb-ae46-4d4b16c05920"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |

  Scenario: 009 Get Archived Business Unit Configuration #ENG-T9939
    When user has a service named "/clm/businessunits/<CLM_BU_ARCHIVE_ID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value                           |
      | id          | <CLM_BU_ARCHIVE_ID>             |
      | name        | Automation Archive              |
      | description | Automation Archive Do Not Touch |
      | recordState |                               2 |
