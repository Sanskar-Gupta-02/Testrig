@Regression @CLM @PeriodicReview
Feature: Periodic Review

  Background:
    Given user is authorized using an 'BEARER1'

  Scenario: 001 Get All Periodic Review #ENG-T9421,T11951
    When user has a service named "clm/reviewsstructured/"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "PeriodicReviewEntitySchema"

  Scenario: 002 Get All Periodic Review With Auth Key2 #ENG-T15555
    When user has a service named "clm/reviewsstructured/"
    And user is authorized using an "BEARER2"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "PeriodicReviewEntitySchema"

  Scenario: 003 Get All Periodic Review With Invalid Auth Key #ENG-T15556
    When user has a service named "clm/reviewsstructured/"
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
  Scenario: 004 Get Entity Periodic Review By ID #ENG-T15557
    When user has a service named "clm/reviewsstructured/<CLM_PERIODIC_REVIEW_ID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value                           |
      | id          | <CLM_PERIODIC_REVIEW_ID>        |
      | name        | API automation - Do Not Touch   |
      | reason      | API automation - Do Not Touch   |
      | description | API automation - Do Not Touch   |
      | type        | Entity                          |

  @Smoke
  Scenario: 005 Get Periodic Review By Incorrect ID #ENG-T15560
    When user has a service named "clm/reviewsstructured/019c69f6-4722-7180-9325-a9c58290adfe"
    And user has header "Content-Type":"application/json"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | title  | Not Found                   |
      | status |                         404 |
      | detail | Review Structured not found |

  @Smoke
  Scenario: 006 Get Specific Periodic Review Data Structure #ENG-T15564
    When user has a service named "clm/reviewsstructured/<CLM_PERIODIC_REVIEW_ID>/datastructure"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "PeriodicReviewEntityData"

  @Smoke
  Scenario: 007 Get Specific Periodic Review Data Structure With Invalid ID #ENG-T15567
    When user has a service named "clm/reviewsstructured/019c69f6-4722-7180-9325-a9c58290adff/datastructure"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | title  | Not Found                   |
      | status |                         404 |
      | detail | Review Structured not found |

  @Smoke
  Scenario: 008 Get Specific Group Periodic Review By Id #ENG-T15561
    When user has a service named "clm/reviewsstructured/<CLM_GROUP_PERIODIC_REVIEW_ID>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value                                 |
      | id             | <CLM_GROUP_PERIODIC_REVIEW_ID>        |
      | name           | Review Automation                     |
      | reason         | just for testing Group API automation |
      | description    | API automation - Do Not Touch         |
      | type           | Group                                 |
      | groupType.id   | <CLM_GROUP_TYPE_ID>                   |
      | groupType.name | Group Type - API Automation           |
    And response body in ascending order should have index based on array key with the value:
      | index | key                                                             | value                             |
      |     1 | entityReviews.entityType.id                                     | <CLM_ENTITY_TYPE_ID>              |
      |     1 | entityReviews.entityType.name                                   | API Test Automaion - Do Not Touch |
      |     1 | entityReviews.entityReviewStructured.entityReviewStructuredId   | <CLM_PERIODIC_REVIEW_ID>          |
      |     1 | entityReviews.entityReviewStructured.name                       | API automation - Do Not Touch     |
      |     1 | entityReviews.entityReviewStructured.reason                     | API automation - Do Not Touch     |

  Scenario: 009 Get All Periodic Review With Pagination #ENG-T15554
    When user has a service named "clm/reviewsstructured?page=1&pageSize=1"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key      | value |
      | page     |     1 |
      | pageSize |     1 |
    And response should have 1 records at path "reviewsStructured"
    And response body should match the schema from the file "PeriodicReviewEntitySchema"

  Scenario: 010 Get Entity Periodic Review By ID With Auth Key2 #ENG-T15558
    When user has a service named "clm/reviewsstructured/<CLM_PERIODIC_REVIEW_ID>"
    And user is authorized using an "BEARER2"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value                         |
      | id          | <CLM_PERIODIC_REVIEW_ID>      |
      | name        | API automation - Do Not Touch |
      | reason      | API automation - Do Not Touch |
      | description | API automation - Do Not Touch |
      | type        | Entity                        |

  Scenario: 011 Get Group Periodic Review By ID With Auth Key2 #ENG-T15562
    When user has a service named "clm/reviewsstructured/<CLM_GROUP_PERIODIC_REVIEW_ID>"
    And user is authorized using an "BEARER2"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value                                 |
      | id             | <CLM_GROUP_PERIODIC_REVIEW_ID>        |
      | name           | Review Automation                     |
      | reason         | just for testing Group API automation |
      | description    | API automation - Do Not Touch         |
      | type           | Group                                 |
      | groupType.id   | <CLM_GROUP_TYPE_ID>                   |
      | groupType.name | Group Type - API Automation           |
    And response body in ascending order should have index based on array key with the value:
      | index | key                                                             | value                             |
      |     1 | entityReviews.entityType.id                                     | <CLM_ENTITY_TYPE_ID>              |
      |     1 | entityReviews.entityType.name                                   | API Test Automaion - Do Not Touch |
      |     1 | entityReviews.entityReviewStructured.entityReviewStructuredId   | <CLM_PERIODIC_REVIEW_ID>          |
      |     1 | entityReviews.entityReviewStructured.name                       | API automation - Do Not Touch     |
      |     1 | entityReviews.entityReviewStructured.reason                     | API automation - Do Not Touch     |

  Scenario Outline: 012 Get Periodic Review With Invalid Auth Key #ENG-T15559,T15563,T15566,T15570
    When user has a service named "<service>"
    And user is authorized using an "INVALIDBEARER"
    And user sends a 'GET' request
    Then response status should be 401
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                     |
      | title  | Unauthorized              |
      | status |                       401 |
      | detail | API Key validation failed |

    Examples:
      | Scenario                   | service                                                                            |
      | Entity By ID               | clm/reviewsstructured/<CLM_PERIODIC_REVIEW_ID>                                     |
      | Group By ID                | clm/reviewsstructured/<CLM_GROUP_PERIODIC_REVIEW_ID>                               |
      | Entity Data Structure      | clm/reviewsstructured/<CLM_PERIODIC_REVIEW_ID>/datastructure                       |
      | Group Data Structure       | clm/reviewsstructured/<CLM_GROUP_PERIODIC_REVIEW_ID>/datastructure                 |

  Scenario: 013 Get Entity Periodic Review Data Structure With Auth Key2 #ENG-T15565
    When user has a service named "clm/reviewsstructured/<CLM_PERIODIC_REVIEW_ID>/datastructure"
    And user is authorized using an "BEARER2"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "PeriodicReviewEntityData"

  Scenario Outline: 014 Get Group Periodic Review Data Structure #ENG-T15568,T15569
    When user has a service named "clm/reviewsstructured/<CLM_GROUP_PERIODIC_REVIEW_ID>/datastructure"
    And user is authorized using an "<auth>"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "PeriodicReviewDataStructureSchema"

    Examples:
      | Scenario     | auth    |
      | Valid Auth   | BEARER1 |
      | Auth Key2    | BEARER2 |
