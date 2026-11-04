@Regression @CLM @EntityRelationship
Feature: Entity Relationship API

  Background:
    Given user is authorized using an 'BEARER1'

  @Smoke
  Scenario: 001 Retrieve relationships for an entity that has relationships #ENG-T15391
    When user has a service named "/clm/entities/<CLM_PRIMARY_ENTITY_ID>/relationships"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "EntityRelationshipSchema"

  Scenario: 002 Retrieve relationship where entity is the source #ENG-T15392
    When user has a service named "/clm/entities/<CLM_PRIMARY_ENTITY_ID>/relationships"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "EntityRelationshipSchema"

  Scenario: 003 Retrieve relationship where entity is the target #ENG-T15393
    When user has a service named "/clm/entities/<CLM_ENTITY_FOR_GROUP_ID>/relationships"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "EntityRelationshipSchema"

  Scenario: 004 Retrieve relationships when the entity has none #ENG-T15394
    When user has a service named "/clm/entities/<CLM_ENTITY_ID_WITH_ARCHIVED_FIELD>/relationships"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response should have 0 records at path "relationships"

  Scenario: 005 Retrieve all relationships for an entity #ENG-T15395
    When user has a service named "/clm/entities/<CLM_ENTITY_FOR_GROUP_ID>/relationships"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "EntityRelationshipMultipleSchema"

  Scenario: 006 Retrieve relationships with a second valid API key #ENG-T15396
    When user has a service named "/clm/entities/<CLM_PRIMARY_ENTITY_ID>/relationships"
    And user is authorized using an 'BEARER2'
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "EntityRelationshipSchema"

  Scenario: 007 Reject the relationships request when the API key is invalid #ENG-T15397
    When user has a service named "/clm/entities/<CLM_PRIMARY_ENTITY_ID>/relationships"
    And user is authorized using an 'INVALIDBEARER'
    And user sends a 'GET' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key      | value                                                          |
      | instance | GET /clm/entities/<CLM_PRIMARY_ENTITY_ID>/relationships        |
      | title    | Unauthorized                                                   |
      | status   |                                                            401 |
      | detail   | API Key validation failed                                      |

  Scenario: 008 Return empty relationships when the entity does not exist #ENG-T15398
    When user has a service named "/clm/entities/<CLM_NONEXISTENT_ENTITY_ID>/relationships"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response should have 0 records at path "relationships"

  Scenario: 009 Return empty relationships when the entity is still a draft #ENG-T15399
    When user has a service named "/clm/draft/entities"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityDataAutomation1"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body have keyData with keyName
      | key | storeKey      |
      | id  | DraftEntityID |
    When user has a service named "/clm/entities/<DraftEntityID>/relationships"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response should have 0 records at path "relationships"

  Scenario: 010 Reject the relationships request when the entity id is not a GUID #ENG-T15400
    When user has a service named "/clm/entities/not-a-valid-guid/relationships"
    And user sends a 'GET' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value |
      | status |   400 |

  @Smoke
  Scenario: 011 Retrieve one relationship by id #ENG-T15401
    When user has a service named "/clm/entities/<CLM_PRIMARY_ENTITY_ID>/relationships"
    And user sends a 'GET' request
    Then response status should be 200
    When user store the response body have keyData with keyName
      | key                 | storeKey       |
      | relationships[0].id | RelationshipID |
    When user has a service named "/clm/entities/<CLM_PRIMARY_ENTITY_ID>/relationships/<RelationshipID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key | storedKey      |
      | id  | RelationshipID |
    And response body should match the schema from the file "EntityRelationshipByIdSchema"

  Scenario: 012 Retrieve a relationship by id where the entity is the target #ENG-T15402
    When user has a service named "/clm/entities/<CLM_ENTITY_FOR_GROUP_ID>/relationships"
    And user sends a 'GET' request
    Then response status should be 200
    When user store the response body have keyData with keyName
      | key                 | storeKey       |
      | relationships[0].id | RelationshipID |
    When user has a service named "/clm/entities/<CLM_ENTITY_FOR_GROUP_ID>/relationships/<RelationshipID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key | storedKey      |
      | id  | RelationshipID |
    And response body should match the schema from the file "EntityRelationshipByIdSchema"

  Scenario: 013 Retrieve a relationship by id with a second valid API key
    When user has a service named "/clm/entities/<CLM_PRIMARY_ENTITY_ID>/relationships"
    And user sends a 'GET' request
    Then response status should be 200
    When user store the response body have keyData with keyName
      | key                 | storeKey       |
      | relationships[0].id | RelationshipID |
    When user has a service named "/clm/entities/<CLM_PRIMARY_ENTITY_ID>/relationships/<RelationshipID>"
    And user is authorized using an 'BEARER2'
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key | storedKey      |
      | id  | RelationshipID |
    And response body should match the schema from the file "EntityRelationshipByIdSchema"

  Scenario: 014 Retrieve relationship by id even when entity path does not own the relationship #ENG-T15404
    When user has a service named "/clm/entities/<CLM_PRIMARY_ENTITY_ID>/relationships"
    And user sends a 'GET' request
    Then response status should be 200
    When user store the response body have keyData with keyName
      | key                 | storeKey       |
      | relationships[0].id | RelationshipID |
    When user has a service named "/clm/entities/<CLM_ENTITY_ID_WITH_ARCHIVED_FIELD>/relationships/<RelationshipID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key | storedKey      |
      | id  | RelationshipID |
    And response body should match the schema from the file "EntityRelationshipByIdSchema"

  Scenario: 015 Return not found when the relationship id does not exist #ENG-T15405
    When user has a service named "/clm/entities/<CLM_PRIMARY_ENTITY_ID>/relationships/<CLM_NONEXISTENT_ENTITY_ID>"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |

  Scenario: 016 Return not found when the entity does not exist #ENG-T15406
    When user has a service named "/clm/entities/<CLM_NONEXISTENT_ENTITY_ID>/relationships/<CLM_NONEXISTENT_ENTITY_ID>"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                          |
      | type   | https://httpstatuses.io/404    |
      | title  | Not Found                      |
      | status |                            404 |
      | detail | Entity Relationship not found  |

  Scenario: 017 Reject the relationship by id request when the API key is invalid #ENG-T15407
    When user has a service named "/clm/entities/<CLM_PRIMARY_ENTITY_ID>/relationships"
    And user sends a 'GET' request
    Then response status should be 200
    When user store the response body have keyData with keyName
      | key                 | storeKey       |
      | relationships[0].id | RelationshipID |
    When user has a service named "/clm/entities/<CLM_PRIMARY_ENTITY_ID>/relationships/<RelationshipID>"
    And user is authorized using an 'INVALIDBEARER'
    And user sends a 'GET' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key      | value                                                                           |
      | instance | GET /clm/entities/<CLM_PRIMARY_ENTITY_ID>/relationships/<RelationshipID>        |
      | title    | Unauthorized                                                                    |
      | status   |                                                                             401 |
      | detail   | API Key validation failed                                                       |

  Scenario: 018 Return not found when the relationship id is not a GUID #ENG-T15408
    When user has a service named "/clm/entities/<CLM_PRIMARY_ENTITY_ID>/relationships/not-a-valid-guid"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |