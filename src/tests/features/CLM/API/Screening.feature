@Regression @CLM @Screening
Feature: Screening API

  Background:
    Given user is authorized using an 'BEARER1'

  @Smoke
  Scenario: 001 Get Individual Screening Returns Business Unit Field Key Mappings with Entity TypeID #ENG-T15047
    When user has a service named "clm/entitytypes/<CLM_SCREENING_ENTITY_TYPE_ID>/businessunits/<CLM_SCREENING_INDIVIDUAL_BU_ID>/screening"
    And user sends a 'GET' request
    Then response status should be 200
    And response body should have key with the value:
      | key                             | value                                     |
      | screening.screeningCriteriaId   |                                       481 |
      | screening.screeningCriteriaName | APIAutomationScreeningCriteria            |
      | screening.screeningMode         |                                         1 |
      | screening.fields.firstName      | bu.data.screeningapitemplate.screeningapi |
      | screening.fields.lastName       | bu.data.screeningapitemplate.screeningapi |

  @Smoke
  Scenario: 002 Get Individual Screening fields with Entity ID #ENG-T15043
    When user has a service named "clm/entities/<CLM_SCREENING_ENTITY_ID>/businessunits/<CLM_SCREENING_INDIVIDUAL_BU_ID>/screening"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "ScreeningIndividualData"
    And response body should have key with the value:
      | key                   | value                          |
      | screeningFirstname    | Automation Screening           |
      | screeningLastName     | Automation Screening           |
      | screeningCriteriaName | APIAutomationScreeningCriteria |

  @Smoke
  Scenario: 003 Get Company Screening Fields with Entity TypeID #ENG-T15044
    When user has a service named "clm/entitytypes/<CLM_SCREENING_ENTITY_TYPE_ID>/businessunits/<CLM_SCREENING_COMPANY_BU_ID>/screening"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "ScreeningCompanyData"
    And response body should have key with the value:
      | key                             | value                                                 |
      | screening.screeningCriteriaId   |                                                   480 |
      | screening.screeningCriteriaName | Test_Criteria_Entity                                  |
      | screening.screeningMode         |                                                     1 |
      | screening.fields.companyName    | bu.data.apiautomationscreening.apiautomationscreening |

  @Smoke
  Scenario: 004 Invalid Entity ID Returns Not Found #ENG-T15050
    When user has a service named "clm/entities/<CLM_SCREENING_Invalid_ENTITY_ID/businessunits/<CLM_SCREENING_INDIVIDUAL_BU_ID>/screening"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | title  | Not Found                   |
      | status |                         404 |
      | type   | https://httpstatuses.io/404 |

  @Smoke
  Scenario: 005 Invalid Entity Type ID Returns Not Found #ENG-T15050
    When user has a service named "clm/entitytypes/<CLM_SCREENING_Invalid_ENTITY_TYPE_ID>/businessunits/<CLM_SCREENING_INDIVIDUAL_BU_ID>/screening"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                       |
      | title  | Not Found                   |
      | status |                         404 |
      | type   | https://httpstatuses.io/404 |
      | detail | Entity Type not found       |

  @Smoke
  Scenario: 006 Get Screening With Invalid Auth Key
    When user has a service named "clm/entities/<CLM_SCREENING_ENTITY_ID>/businessunits/<CLM_SCREENING_INDIVIDUAL_BU_ID>/screening"
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
  Scenario: 007 Get Screening Without Business Unit Access Returns Forbidden
    When user has a service named "clm/entities/<CLM_SCREENING_ENTITY_ID>/businessunits/<CLM_BU_NO_ACCESS_ID2>/screening"
    And user sends a 'GET' request
    Then response status should be 403
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value     |
      | title  | Forbidden |
      | status |       403 |

  @Smoke
  Scenario: 008 Get Screening Without Business Unit Access Returns Forbidden
    When user has a service named "clm/entitytypes/<CLM_SCREENING_ENTITY_TYPE_ID>/businessunits/<CLM_BU_NO_ACCESS_ID2>/screening"
    And user sends a 'GET' request
    Then response status should be 403
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value     |
      | title  | Forbidden |
      | status |       403 |

  Scenario: 009 No Screening Record Returns Not Found #ENG-T15053,15054,15055
    When user has a service named "clm/entitytypes/<CLM_NoSCREENING_ENTITY_TYPE_ID>/businessunits/<CLM_SCREENING_NULL_FIELDS_BU_ID>/screening"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                                             |
      | title  | Not Found                                                         |
      | status |                                                               404 |
      | detail | Screening fields are not configured for Entity Type Business Unit |

  Scenario: 010 Caller Claim missing route Business Unit Returns Not Found #ENG-T15056
    When user has a service named "clm/entitytypes/<01a135f6-ac1c-757a-88f9-0798876fe355>/businessunits/<01a13081-d888-7332-b09f-d147903112f0>/screening"
    And user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key    | value                                           |
      | title  | Not Found                                       |
      | status |                                             404 |
