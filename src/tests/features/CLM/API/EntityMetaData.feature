@Regression @CLM @EntityMetaData
Feature: Entities Meta Data

  Background:
    Given user is authorized using an 'BEARER1'

  Scenario: 001 Create Entity Meta Data When the entity type does not exist #ENG-T9380
    When user has a service named "/clm/draft/entities"
    And user is authorized using an 'BEARER2'
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityData"
    And user has raw payloads:
      """
      {
          "entityTypeId": "019c6526-c1a2-7300-9fad-a46e1e338938"
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
      | detail | Entity Type not found       |

  Scenario: 002 Create Entity Meta Data Missing Entity Type ID #ENG-T9377
    When user has a service named "/clm/draft/entities"
    And user is authorized using an 'BEARER2'
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityDataMissingEntityType"
    And user sends a 'POST' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |
      | detail | Entity Type not found       |

  Scenario: 003 Create Entity Meta Data With Invalid API KEY #ENG-T9376
    When user has a service named "/clm/draft/entities"
    And user is authorized using an 'INVALIDBEARER'
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityData"
    And user sends a 'POST' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key      | value                     |
      | instance | POST /clm/draft/entities  |
      | title    | Unauthorized              |
      | status   |                       401 |
      | detail   | API Key validation failed |

  Scenario: 004 Create Entity Meta Data key field validation voilation #ENG-T9379
    When user has a service named "/clm/draft/entities"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityDataFieldVoilation"
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key      | value                    |
      | instance | POST /clm/draft/entities |
      | title    | Validation error         |
      | status   |                      400 |
    And response body in ascending order should have index key with the contains value:
      | index | key             | value                                                       |
      |     1 | errors.key      | entity.entitymetadatacustom.linksdata                       |
      |     2 | errors.key      | entity.entitymetadatacustom.datedata                        |
      |     3 | errors.key      | entity.entitymetadatacustom.decimaldata                     |
      |     4 | errors.key      | entity.entitymetadatacustom.integerdata                     |
      |     5 | errors.key      | entity.entitymetadatacustom.emaildata                       |
      |     6 | errors.key      | entity.entitymetadatacustom.giindata                        |
      |     7 | errors.key      | entity.entitymetadatacustom.tindata                         |
      |     1 | errors.messages | Value is not correct for this Data Field, expected Links    |
      |     2 | errors.messages | date data must not be later than 01/01/2027                 |
      |     3 | errors.messages | decimal data must not be greater than 100                   |
      |     4 | errors.messages | integer data must not be greater than 200                   |
      |     5 | errors.messages | email data should match the pattern ^[^@]+@[^@]+\\\\.[^@]+$ |
      |     6 | errors.messages | giin data must not be longer than 19 characters             |
      |     7 | errors.messages | tin data must not be longer than 19 characters              |

  Scenario: 005 Create Entity Meta Data Invalid Field Key #ENG-T9378
    When user has a service named "/clm/draft/entities"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityDataInvalidKey"
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key      | value                    |
      | instance | POST /clm/draft/entities |
      | title    | Validation error         |
      | status   |                      400 |
    And response body in ascending order should have index key with the contains value:
      | index | key             | value                                                  |
      |     1 | errors.key      | entity.entitymetadatacustom.dateoNCKJSJJDfbirthdata    |
      |     1 | errors.messages | The data structure does not have a corresponding field |

  Scenario: 006 Create Entity Meta Data With Required Field Missing #ENG-T9395
    When user has a service named "/clm/draft/entities"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityDataMissingRequiredFeild"
    And user sends a 'POST' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key      | value                    |
      | instance | POST /clm/draft/entities |
      | title    | Validation error         |
      | status   |                      400 |
    And response body in ascending order should have index key with the contains value:
      | index | key             | value                                   |
      |     1 | errors.key      | entity.entitymetadatacustom.integerdata |
      |     1 | errors.messages | integer data is required                |

  Scenario: 007 Create Entity Meta Data #ENG-T9375
    When user has a service named "/clm/draft/entities"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityData"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key             | value                             |
      | entityName      | New Test API2                     |
      | entityType.name | API Test Automaion - Do Not Touch |
    When user store the response body have keyData with keyName
      | key | storeKey |
      | id  | EntityID |
    And response body should match the expected data from the file "EntityMetaDataCreateResponse"

  Scenario: 008 Update Entity Meta Data #ENG-T9388
    When user has a service named "/clm/draft/entities/<EntityID>"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityDataUpdate"
    And user sends a 'PUT' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key             | value                             |
      | entityName      | New Test API2                     |
      | entityType.name | API Test Automaion - Do Not Touch |
    And response body should match the expected data from the file "EntityMetaDataUpdateResponse"

  Scenario: 009 Update Entity Meta Data With Auth KYE2 #ENG-T9388
    When user has a service named "/clm/draft/entities/<EntityID>"
    And user is authorized using an 'BEARER2'
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityDataUpdate"
    And user sends a 'PUT' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key             | value                             |
      | entityName      | New Test API2                     |
      | entityType.name | API Test Automaion - Do Not Touch |
    And response body should match the expected data from the file "EntityMetaDataUpdateResponse"

  Scenario: 010 Update Entity Meta Data With Invalid Auth Key #ENG-T9390
    When user has a service named "/clm/draft/entities/<EntityID>"
    And user is authorized using an 'INVALIDBEARER'
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityDataUpdate"
    And user sends a 'PUT' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                     |
      | title  | Unauthorized              |
      | status |                       401 |
      | detail | API Key validation failed |

  Scenario: 011 Update Entity Meta Data When Entity Does Not Exists#ENG-T9389
    When user has a service named "/clm/draft/entities/0167a6c2-638d-6763-67fe-d6b6f6d6062d"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityDataUpdate"
    And user sends a 'PUT' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |
      | detail | Entity not found            |

  Scenario: 012 Update Entity Meta Data key field validation voilation
    When user has a service named "/clm/draft/entities/<EntityID>"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityDataUpdateDataVoilation"
    And user sends a 'PUT' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value            |
      | title  | Validation error |
      | status |              400 |
    And response body in ascending order should have index key with the contains value:
      | index | key             | value                                                       |
      |     1 | errors.key      | entity.entitymetadatacustom.linksdata                       |
      |     2 | errors.key      | entity.entitymetadatacustom.datedata                        |
      |     3 | errors.key      | entity.entitymetadatacustom.decimaldata                     |
      |     4 | errors.key      | entity.entitymetadatacustom.integerdata                     |
      |     5 | errors.key      | entity.entitymetadatacustom.emaildata                       |
      |     6 | errors.key      | entity.entitymetadatacustom.giindata                        |
      |     7 | errors.key      | entity.entitymetadatacustom.tindata                         |
      |     1 | errors.messages | Value is not correct for this Data Field, expected Links    |
      |     2 | errors.messages | date data must not be earlier than 01/01/2026               |
      |     3 | errors.messages | decimal data must not be greater than 100.999               |
      |     4 | errors.messages | integer data must not be greater than 200                   |
      |     5 | errors.messages | email data should match the pattern ^[^@]+@[^@]+\\\\.[^@]+$ |
      |     6 | errors.messages | giin data must not be longer than 19 characters             |
      |     7 | errors.messages | tin data must not be longer than 19 characters              |

  Scenario: 013 Update Entity Meta Data Invalid Field Key #ENG-T9392
    When user has a service named "/clm/draft/entities/<EntityID>"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "EntityDataUpdateInvalidKey"
    And user sends a 'PUT' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value            |
      | title  | Validation error |
      | status |              400 |
    And response body in ascending order should have index key with the contains value:
      | index | key             | value                                                  |
      |     1 | errors.key      | entity.entitymetadatacustom.dateoNCKJSJJDfbirthdata    |
      |     1 | errors.messages | The data structure does not have a corresponding field |

  Scenario: 014 Get Entity Meta Data #ENG-T9371
    When user has a service named "/clm/draft/entities/<EntityID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key             | value                             |
      | entityName      | New Test API2                     |
      | entityType.name | API Test Automaion - Do Not Touch |
    And response body should match the expected data from the file "EntityMetaDataUpdateResponse"

  Scenario: 015 Get Entity Meta Data With Auth Key2
    When user has a service named "/clm/draft/entities/<EntityID>"
    And user is authorized using an 'BEARER2'
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key             | value                             |
      | entityName      | New Test API2                     |
      | entityType.name | API Test Automaion - Do Not Touch |
    And response body should match the expected data from the file "EntityMetaDataUpdateResponse"

  Scenario: 016 Get Entity Meta Data With Invalid Auth Key #ENG-T9373
    When user has a service named "/clm/draft/entities/<EntityID>"
    And user is authorized using an 'INVALIDBEARER'
    And user sends a 'GET' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                     |
      | title  | Unauthorized              |
      | status |                       401 |
      | detail | API Key validation failed |

  Scenario: 017 Get Entity Meta Data When Entity Does Not Exists #ENG-T9372
    When user has a service named "/clm/entities/0197a5c2-438d-7763-97fe-d4bafcd3022d"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |
      | detail | Entity not found            |

  Scenario: 018 Get Draft Entity Meta Data When Entity Does Not Exists.
    When user has a service named "/clm/draft/entities/0197a5c2-438d-7763-97fe-d4bafcd3022d"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | type   | https://httpstatuses.io/404 |
      | title  | Not Found                   |
      | status |                         404 |
      | detail | Entity not found            |

  @Smoke
  Scenario: 019 Verify hidden fields/templates are not returned in response. #ENG-T9374
    When user has a service named "/clm/entities/<CLM_ENTITY_ID_WITH_ARCHIVED_FIELD>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body have key with the value for nested object:
      | key             | value                                |
      | id              | <CLM_ENTITY_ID_WITH_ARCHIVED_FIELD>  |
      | entityName      | EntityWithArchivedDF                 |
      | entityType.name | EntityTypeWithArchivedDF             |
      | fields[0].type  | String                               |
      | fields[0].key   | entity.metadata.entityName           |
      | fields[0].value | EntityWithArchivedDF                 |
      | fields[1].type  | List                                 |
      | fields[1].key   | entity.metadata.entityRole           |

