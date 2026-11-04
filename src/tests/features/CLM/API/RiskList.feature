@Regression @CLM @RiskList
Feature: Risk List API

  Background:
    Given user is authorized using an 'BEARER1'

  @Smoke
  Scenario: 001 Get All Risk List #ENG-T9420
    When user has a service named "clm/risklists/"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "RiskListSchema"

  Scenario: 003 Get All Risk List With Auth Key2
    When user has a service named "clm/risklists/"
    And user is authorized using an "BEARER2"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "RiskListSchema"

  Scenario: 004 Get All Risk List With Invalid Auth Key
    When user has a service named "clm/risklists/"
    And user is authorized using an "INVALIDBEARER"
    And user sends a 'GET' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                     |
      | title  | Unauthorized              |
      | status |                       401 |
      | detail | API Key validation failed |

  @Smoke
  Scenario: 005 Get Risk List By ID
    When user has a service named "clm/risklists/<CLM_RISK_LIST_ID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value                  |
      | id          | <CLM_RISK_LIST_ID>     |
      | name        | Automation Risk List   |
      | description | Automation Risk List   |
      | recordState | Active                 |

  @Smoke
  Scenario: 006 Get Risk Models used in Risk List By ID
    When user has a service named "clm/risklists/<CLM_RISK_LIST_ID>/riskmodels"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "RiskModelsData"
