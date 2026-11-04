@Regression @OnboardingRiskBand
Feature: Onboarding RiskBand API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to create OnboardingType and Risk Band
    Given user has a service named "/api/v1/static/onboardingtype/add"
    And user has a payload from the file 'onboardingTypes'
    And user store the unique value for key:
      | key                |
      | onboardingTypeName |
    And user add payload key with stored key value:
      | payloadKey         | storedkey          |
      | OnboardingTypeName | onboardingTypeName |
    When user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"OnboardingTypeID" with keyName:"onboardingTypeId"
    And user has a service named "/api/v1/static/onboardingriskband"
    And user has a query params from the file "onboardingRiskBand" with selected keys "ReturnFormat"
    And user has a payload from the file 'onboardingRiskBand' with selected keys "Name,Order"
    And user add payload "OnboardingTypeId" with the stored key value "onboardingTypeId"
    When user sends a 'POST' request
    Then response status should be 201
    And response body should match the schema from the file "onboardingRiskBand"
    And response body should have key "OnboardingTypeId" with the stored key value "onboardingTypeId"
    And user store the response body keyData:"Id" with keyName:"riskBandId"
    And response body should have key with the value:
      | key   | value          |
      | Name  | Auto Risk Band |
      | Order |              1 |

  Scenario: 002 Should be able to get Risk Band by Id
    Given user has a service named "/api/v1/static/onboardingriskband"
    And user add query parameter "Id" with the stored key value "riskBandId"
    And user has a query params from the file "onboardingRiskBand" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response body should match the schema from the file "onboardingRiskBand"
    And response body should have key "Id" with the stored key value "riskBandId"
    And response body should have key "OnboardingTypeId" with the stored key value "onboardingTypeId"
    And response body should have key with the value:
      | key   | value          |
      | Name  | Auto Risk Band |
      | Order |              1 |

  Scenario: 003 Should be able to get all Risk Bands
    Given user has a service named "/api/v1/static/onboardingriskband"
    And user has a query params from the file "onboardingRiskBand" with selected keys "ReturnFormat"
    And user has payloads:
      """
      {
        "Name": "Auto Risk Band 2",
        "Order": "2"
      }
      """
    And user add payload "OnboardingTypeId" with the stored key value "onboardingTypeId"
    When user sends a 'POST' request
    Then response status should be 201
    And response body should match the schema from the file "onboardingRiskBand"
    And response body should have key "OnboardingTypeId" with the stored key value "onboardingTypeId"
    And user store the response body keyData:"Id" with keyName:"riskBandId2"
    And response body should have key with the value:
      | key   | value            |
      | Name  | Auto Risk Band 2 |
      | Order |                2 |
    When user has a service named "/api/v1/static/onboardingriskband/all"
    And user has a query params from the file "onboardingRiskBand" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response body should match the schema from the file "onboardingRiskBandGetAll"

  Scenario: 004 Should be able to get all Risk Bands by OnboardingTypeId
    Given user has a service named "/api/v1/static/onboardingriskband/onboardingtype"
    And user add query parameter "OnboardingTypeId" with the stored key value "onboardingTypeId"
    And user has a query params from the file "onboardingRiskBand" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response body should match the schema from the file "onboardingRiskBandGetAll"
    And response body should have index key with the value:
      | index | key   | value            |
      |     1 | Name  | Auto Risk Band   |
      |     1 | Order |                1 |
      |     2 | Name  | Auto Risk Band 2 |
      |     2 | Order |                2 |
    And response body should have index key with the stored key value:
      | index | key              | storedKey        |
      |     1 | OnboardingTypeId | onboardingTypeId |
      |     1 | Id               | riskBandId       |
      |     2 | OnboardingTypeId | onboardingTypeId |
      |     2 | Id               | riskBandId2      |

  Scenario: 005 Should be able to update a Risk Band
    Given user has a service named "/api/v1/static/onboardingriskband"
    And user has a query params from the file "onboardingRiskBand" with selected keys "ReturnFormat"
    And user has payloads:
      """
      {
        "Name": "Auto Risk Band Updated",
        "Order": 2
      }
      """
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeId"
    And user add payload "Id" with the stored key value "riskBandId"
    When user sends a 'PUT' request
    Then response status should be 200
    And response body should match the schema from the file "onboardingRiskBand"
    And response body should have key "Id" with the stored key value "riskBandId"
    And response body should have key "OnboardingTypeId" with the stored key value "onboardingTypeId"
    And response body should have key with the value:
      | key   | value                  |
      | Name  | Auto Risk Band Updated |
      | Order |                      2 |
    When user has a service named "/api/v1/static/onboardingriskband"
    And user has a query params from the file "onboardingRiskBand" with selected keys "ReturnFormat"
    And user has payloads:
      """
      {
        "Name": "Auto Risk Band 2",
        "Order": 1
      }
      """
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeId"
    And user add payload "Id" with the stored key value "riskBandId2"
    When user sends a 'PUT' request
    Then response status should be 200
    And response body should match the schema from the file "onboardingRiskBand"
    And response body should have key "Id" with the stored key value "riskBandId2"
    And response body should have key "OnboardingTypeId" with the stored key value "onboardingTypeId"
    And response body should have key with the value:
      | key   | value            |
      | Name  | Auto Risk Band 2 |
      | Order |                1 |

  Scenario: 006 Should be able to get all Risk Bands by OnboardingTypeId
    Given user has a service named "/api/v1/static/onboardingriskband/onboardingtype"
    And user add query parameter "OnboardingTypeId" with the stored key value "onboardingTypeId"
    And user has a query params from the file "onboardingRiskBand" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response body should match the schema from the file "onboardingRiskBandGetAll"
    And response body should have index key with the value:
      | index | key   | value                  |
      |     1 | Name  | Auto Risk Band 2       |
      |     1 | Order |                      1 |
      |     2 | Name  | Auto Risk Band Updated |
      |     2 | Order |                      2 |
    And response body should have index key with the stored key value:
      | index | key              | storedKey        |
      |     1 | OnboardingTypeId | onboardingTypeId |
      |     1 | Id               | riskBandId2      |
      |     2 | OnboardingTypeId | onboardingTypeId |
      |     2 | Id               | riskBandId       |

  Scenario: 007 Should not create Risk Band with missing required fields
    Given user has a service named "/api/v1/static/onboardingriskband"
    And user has a query params from the file "onboardingRiskBand" with selected keys "ReturnFormat"
    And user has a payload from the file 'onboardingRiskBand' with selected keys "Name,Order"
    When user sends a 'POST' request
    Then response status should be 406
    And response body should contains "The OnboardingTypeId property is required"

  Scenario: 008 Should not get Risk Band with invalid Id
    Given user has a service named "/api/v1/static/onboardingriskband"
    And user has query parameter "Id":"999999"
    And user has query parameter "ReturnFormat":"Json"
    When user sends a 'GET' request
    Then response status should be 406
    And response body should contains "Risk band not found with the provided ID."

  Scenario: 009 Should be able to delete a Risk Band and OnboardingType
    Given user has a service named "/api/v1/static/onboardingriskband"
    And user add query parameter "Id" with the stored key value "riskBandId"
    When user sends a 'DELETE' request
    Then response status should be 200
    And user has a service named "/api/v1/static/onboardingriskband"
    And user add query parameter "Id" with the stored key value "riskBandId2"
    When user sends a 'DELETE' request
    Then response status should be 200
    When user has a service named "/api/v1/static/onboardingtype/delete"
    And user has a query params from the file 'onboardingTypes' with selected keys 'ActionUserID,ReturnFormat'
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeId"
    And user sends a 'DELETE' request
    Then response status should be 200
