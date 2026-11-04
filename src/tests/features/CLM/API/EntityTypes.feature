@Regression @CLM @EntityTypes
Feature: Entity Types API

  Background:
    Given user is authorized using an 'BEARER1'

  @Smoke
  Scenario: 001 Get All Entity Types #ENG-T9922
    When user has a service named "clm/entitytypes/"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "EntityTypeSchema"

  Scenario: 002 Get All Entity Types With Pagination #ENG-T9922,T9924
    When user has a service named "clm/entitytypes?page=1&pageSize=1"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key      | value |
      | page     |     1 |
      | pageSize |     1 |

  Scenario: 003 Get All Entity Types With Auth Key2
    When user has a service named "clm/entitytypes/"
    And user is authorized using an "BEARER2"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "EntityTypeSchema"

  Scenario: 004 Get All Entity Types With Invalid Auth Key #ENG-T9926
    When user has a service named "clm/entitytypes/"
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
  Scenario: 005 Get Entity Type By ID #ENG-T9984,T9985,T9976
    When user has a service named "clm/entitytypes/<CLM_ENTITY_TYPE_ID>/businessunits"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "EntityTypeBUList"

  Scenario: 006 Get Entity Type With Auht Key2 #ENG-T9984,T9968
    When user has a service named "clm/entitytypes/<CLM_ENTITY_TYPE_ID>/businessunits"
    And user is authorized using an "BEARER2"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "EntityTypeBUList"

  Scenario: 007 Get Entity Type With Invalid Auth Key #ENG-T9871
    When user has a service named "clm/entitytypes/<CLM_ENTITY_TYPE_ID>"
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
  Scenario: 008 Get Entity Type With Invalid ID #ENG-T9870,T9979
    When user has a service named "clm/entitytypes/0197a5c2-438d-7763-97fe-dd34s55fgv2d"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | title  | Not Found                   |
      | status |                         404 |
      | type   | https://httpstatuses.io/404 |

  @Smoke
  Scenario: 009 Get Entity Type Business Unit Data Structure #ENG-T9872,T9873
    When user has a service named "clm/entitytypes/<CLM_ENTITY_TYPE_ID>/businessunits/<CLM_BU_AUTOMATION_ID>/datastructure"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "BUDataStructure"

  Scenario: 010 Get Entity Type Business Unit Data Structure With Auth Key2 #ENG-T9878,T9874
    When user has a service named "clm/entitytypes/<CLM_ENTITY_TYPE_ID>/businessunits/<CLM_BU_AUTOMATION_ID>/datastructure"
    And user is authorized using an "BEARER2"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "BUDataStructure"

  Scenario: 011 Get Entity Type Business Unit Data Structure With Inavlid Auth Key #ENG-T9876
    When user has a service named "clm/entitytypes/01991360-f94a-744d-a770-e3f92dc8c6b2/businessunits/01991354-30b8-7102-897a-7d8a5d6c2953/datastructure"
    And user is authorized using an "INVALIDBEARER"
    And user sends a 'GET' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                     |
      | title  | Unauthorized              |
      | status |                       401 |
      | detail | API Key validation failed |

  Scenario: 012 Get Entity Type Business Unit Data Structure With Incorrect BU ID #ENG-T9875
    When user has a service named "clm/entitytypes/019c6526-c1a2-7300-9fad-a46e1e338937/businessunits/0197b000-f889-723a-ad2c-80596d0457af/datastructure"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value     |
      | title  | Not Found |
      | status |       404 |

  @Smoke
  Scenario: 013 Get Entity Type Meta Data #ENG-T9869
    When user has a service named "clm/entitytypes/<CLM_ENTITY_TYPE_ID>/metadata"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "EntityMetaDataStructure"

  Scenario: 014 Get Entity Type Meta Data With Auth Key2 #ENG-T9869
    When user has a service named "clm/entitytypes/<CLM_ENTITY_TYPE_ID>/metadata"
    And user is authorized using an "BEARER2"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "EntityMetaDataStructure"

  @Smoke
  Scenario: 015 Get Entity Type Meta Data With Invalid Auth Key #ENG-T9876
    When user has a service named "clm/entitytypes/01991360-f94a-744d-a770-e3f92dc8c6b2/metadata"
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
  Scenario: 016 Verify response returns 404 when the BU ID is not associated with the Entity Type. #ENG-T9891
    When user has a service named "clm/entitytypes/<CLM_ENTITY_TYPE_ID>/businessunits/<CLM_BU_NOT_ASSOCIATED_WITH_ENTITY_TYPE_ID>/datastructure"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                           |
      | title  | Not Found                                       |
      | status |                                             404 |
      | detail | Business Unit is not associated for Entity Type |
