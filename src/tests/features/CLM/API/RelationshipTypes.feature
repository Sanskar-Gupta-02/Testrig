@Regression @CLM @RelationshipTypes
Feature: Relationship Types API

  Background:
    Given user is authorized using an 'BEARER1'

  @Smoke
  Scenario: 001 Get All RelationshipTypes
    When user has a service named "/clm/relationshiptypes/"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "RelationshipTypesSchema"

  Scenario: 002 Get All RelationshipTypes With Pagination
    When user has a service named "/clm/relationshiptypes?page=1&pageSize=2"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key      | value |
      | pageSize |     2 |
      | page     |     1 |

  Scenario: 003 Get All RelationshipTypes With Auth Key2
    When user has a service named "/clm/relationshiptypes/"
    And user is authorized using an 'BEARER2'
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "RelationshipTypesSchema"

  Scenario: 004 Get All RelationshipTypes With Invalid Auth Key #ENG-T9977,T9978
    When user has a service named "/clm/relationshiptypes/"
    And user is authorized using an 'INVALIDBEARER'
    And user sends a 'GET' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key      | value                       |
      | instance | GET /clm/relationshiptypes/ |
      | title    | Unauthorized                |
      | status   |                         401 |
      | detail   | API Key validation failed   |

  @Smoke
  Scenario: 005 Get A RelationshipType With ID #ENG-T9929
    When user has a service named "/clm/relationshiptypes/<CLM_REL_TYPE_ID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value                       |
      | id          | <CLM_REL_TYPE_ID>           |
      | name        | API Automation Do Not Touch |
      | description | API Automation Do Not Touch |
      | recordState |                           1 |

  Scenario: 006 Get A RelationshipType With ID With API Key2 #ENG-T9929
    When user has a service named "/clm/relationshiptypes/<CLM_REL_TYPE_ID>"
    And user is authorized using an 'BEARER2'
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value                       |
      | id          | <CLM_REL_TYPE_ID>           |
      | name        | API Automation Do Not Touch |
      | description | API Automation Do Not Touch |
      | recordState |                           1 |

  Scenario: 007 Get RelationshipType By ID With Invalid API Key #ENG-T9937
    When user has a service named "/clm/relationshiptypes/019933bf-4a7a-7799-a9a9-71e442102548"
    And user is authorized using an 'INVALIDBEARER'
    And user sends a 'GET' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key      | value                                                           |
      | instance | GET /clm/relationshiptypes/019933bf-4a7a-7799-a9a9-71e442102548 |
      | title    | Unauthorized                                                    |
      | status   |                                                             401 |
      | detail   | API Key validation failed                                       |

  @Smoke
  Scenario: 008 Get RelationshipType DataStructure With API Key2 #ENG-T9936,T9940,T9935
    When user has a service named "/clm/relationshiptypes/<CLM_REL_TYPE_ID>/datastructure"
    And user is authorized using an 'BEARER2'
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "RelationshipTypesData"

  @Smoke
  Scenario: 009 Return 404 When no data structure is available for relationship type. #ENG-T9938
    When user has a service named "/clm/relationshiptypes/<CLM_REL_TYPE_NO_DS_ID>/datastructure"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                                 |
      | type   | https://httpstatuses.io/404                           |
      | title  | Not Found                                             |
      | status |                                                   404 |
      | detail | Data structure is not published for Relationship Type |

  @Smoke
  Scenario: 010 Return 404 when relationship ID is invalid or does not exist #ENG-T10038
    When user has a service named "/clm/relationshiptypes/019c700a-5a89-762b-8dd9-e6725c354ed9/datastructure"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |
      | detail | Relationship Type not found |
