@Regression @StaticPropertyRisk
Feature: Static Property Risk API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add Onboarding type
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
    When user store the response body keyData:"OnboardingTypeID" with keyName:"onboardingTypeID"

  Scenario: 002 Should be able to add an onboarding property group
    Given user has a service named "/api/v1/static/onboardingpropertygroup/add"
    And user has a payload from the file 'onboardingPropertyGroup'
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeID"
    When user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"OnboardingPropertyGroupID" with keyName:"onboardingPropertyGroupID"

  Scenario: 003 Should be able to add Static Onboarding Structure Integer
    Given user has a service named "/api/v1/static/onboardingstructure/add"
    And user has a payload from the file 'staticOnboardingStructure'
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user add payload "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And user has payloads:
      """
      {
        "OnboardingPropertyName": "Auto - Integer",
        "OnboardingPropertyDescription": "AutoDec - Integer",
        "PropertyOrder": "2",
        "IntegerDefaultValue": "10",
        "StoreID": "2",
        "IntegerMinimumValue": "1",
        "IntegerMaximumValue": "100"
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"OnboardingPropertyID" with keyName:"integerOnboardingPropertyID"

  Scenario: 004 Should be able to add Static Property Risk
    Given user has a service named "/api/v1/static/propertyrisk/add"
    And user has a payload from the file 'staticPropertyRisk'
    And user add payload "OnboardingPropertyID" with the stored key value "integerOnboardingPropertyID"
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user add payload "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                | value               |
      | ListDataID         |                   0 |
      | IntegerStart       |                   1 |
      | IntegerEnd         |                  25 |
      | DecimalStart       |                   1 |
      | DecimalEnd         |                   1 |
      | DateOperator       |                   0 |
      | DateMagnitude      |                   0 |
      | DateTimespan       |                   0 |
      | DateMode           |                   0 |
      | DateSpecificdate   | 2025-01-29 00:00:00 |
      | RiskMarker         |                  40 |
      | WeightedRiskScore  |                   0 |
      | RiskFactorOverride | false               |
    When user store the response body keyData:"UniqueID" with keyName:"integerUniqueID"
    And response body should match the schema from the file "staticPropertyRisk"
    And user has payloads:
      """
      {
      "IntegerStart":"30",
      "IntegerEnd":"60",
      "RiskMarker":"90",
      "RiskFactorOverride":"true"
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                | value               |
      | ListDataID         |                   0 |
      | IntegerStart       |                  30 |
      | IntegerEnd         |                  60 |
      | DecimalStart       |                   1 |
      | DecimalEnd         |                   1 |
      | DateOperator       |                   0 |
      | DateMagnitude      |                   0 |
      | DateTimespan       |                   0 |
      | DateMode           |                   0 |
      | DateSpecificdate   | 2025-01-29 00:00:00 |
      | RiskMarker         |                  90 |
      | WeightedRiskScore  |                   0 |
      | RiskFactorOverride | true                |
    When user store the response body keyData:"UniqueID" with keyName:"secondIntegerUniqueID"
    Then response body should match the schema from the file "staticPropertyRisk"
    And response body should have key "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And response body should have key "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And response body should have key "OnboardingPropertyID" with the stored key value "integerOnboardingPropertyID"

  Scenario: 005 Should be able to get Integer Onboarding Property Risk
    Given user has a service named "/api/v1/static/propertyrisk/get"
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user add query parameter "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And user add query parameter "OnboardingPropertyID" with the stored key value "integerOnboardingPropertyID"
    And user add query parameter "OnboardingPropertyRuleUniqueID" with the stored key value "integerUniqueID"
    And user has a query params from the file "staticPropertyRisk" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                | value               |
      | ListDataID         |                   0 |
      | IntegerStart       |                   1 |
      | IntegerEnd         |                  25 |
      | DecimalStart       |                   1 |
      | DecimalEnd         |                   1 |
      | DateOperator       |                   0 |
      | DateMagnitude      |                   0 |
      | DateTimespan       |                   0 |
      | DateMode           |                   0 |
      | DateSpecificdate   | 2025-01-29 00:00:00 |
      | RiskMarker         |                  40 |
      | WeightedRiskScore  |                   0 |
      | RiskFactorOverride | false               |
    And response body should match the schema from the file "staticPropertyRisk"
    And response body should have key "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And response body should have key "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And response body should have key "OnboardingPropertyID" with the stored key value "integerOnboardingPropertyID"
    And response body should have key "UniqueID" with the stored key value "integerUniqueID"

  Scenario: 006 Should be able to update Static Onboarding Property Risk
    Given user has a service named "/api/v1/static/propertyrisk/update"
    And user has a payload from the file "staticPropertyRisk"
    And user add payload "OnboardingPropertyID" with the stored key value "integerOnboardingPropertyID"
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user add payload "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And user add payload "OnboardingPropertyRuleUniqueID" with the stored key value "integerUniqueID"
    And user has payloads:
      """
      {
      "IntegerStart":"0",
      "IntegerEnd":"30",
      "RiskMarker":"45",
      "RiskFactorOverride":"true"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                | value |
      | IntegerStart       |     0 |
      | IntegerEnd         |    30 |
      | RiskMarker         |    45 |
      | RiskFactorOverride | true  |
    And response body should match the schema from the file "staticPropertyRisk"
    And response body should have key "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And response body should have key "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And response body should have key "OnboardingPropertyID" with the stored key value "integerOnboardingPropertyID"
    And response body should have key "UniqueID" with the stored key value "integerUniqueID"

  Scenario: 007 Should be able to get all Static Onboarding Property Risk
    Given user has a service named "/api/v1/static/propertyrisk/getall"
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user add query parameter "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And user add query parameter "OnboardingPropertyID" with the stored key value "integerOnboardingPropertyID"
    And user has a query params from the file "staticPropertyRisk" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have index key with the stored key value:
      | index | key                       | storedKey                   |
      |     1 | UniqueID                  | integerUniqueID             |
      |     1 | OnboardingTypeID          | onboardingTypeID            |
      |     1 | OnboardingPropertyGroupID | onboardingPropertyGroupID   |
      |     1 | OnboardingPropertyID      | integerOnboardingPropertyID |
      |     2 | UniqueID                  | secondIntegerUniqueID       |
      |     2 | OnboardingTypeID          | onboardingTypeID            |
      |     2 | OnboardingPropertyGroupID | onboardingPropertyGroupID   |
      |     2 | OnboardingPropertyID      | integerOnboardingPropertyID |
    And response body should have index key with the value:
      | index | key                | value               |
      |     1 | ListDataID         |                   0 |
      |     1 | IntegerStart       |                   0 |
      |     1 | IntegerEnd         |                  30 |
      |     1 | DecimalStart       |                   1 |
      |     1 | DecimalEnd         |                   1 |
      |     1 | DateOperator       |                   0 |
      |     1 | DateMagnitude      |                   0 |
      |     1 | DateTimespan       |                   0 |
      |     1 | DateMode           |                   0 |
      |     1 | DateSpecificdate   | 2025-01-29 00:00:00 |
      |     1 | RiskMarker         |                  45 |
      |     1 | WeightedRiskScore  |                   0 |
      |     1 | RiskFactorOverride | true                |
      |     2 | ListDataID         |                   0 |
      |     2 | IntegerStart       |                  30 |
      |     2 | IntegerEnd         |                  60 |
      |     2 | DecimalStart       |                   1 |
      |     2 | DecimalEnd         |                   1 |
      |     2 | DateOperator       |                   0 |
      |     2 | DateMagnitude      |                   0 |
      |     2 | DateTimespan       |                   0 |
      |     2 | DateMode           |                   0 |
      |     2 | DateSpecificdate   | 2025-01-29 00:00:00 |
      |     2 | RiskMarker         |                  90 |
      |     2 | WeightedRiskScore  |                   0 |
      |     2 | RiskFactorOverride | true                |
    And response body should match the schema from the file "staticPropertyRiskGetAll"

  Scenario: 008 Should be able to delete Onboarding PropertyID
    Given user has a service named "/api/v1/static/propertyrisk/delete"
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user add query parameter "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And user add query parameter "OnboardingPropertyID" with the stored key value "integerOnboardingPropertyID"
    And user add query parameter "OnboardingPropertyRuleUniqueID" with the stored key value "integerUniqueID"
    And user has a query params from the file "staticPropertyRisk" with selected keys "ReturnFormat,ActionUserID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                | value               |
      | ListDataID         |                   0 |
      | IntegerStart       |                   0 |
      | IntegerEnd         |                  30 |
      | DecimalStart       |                   1 |
      | DecimalEnd         |                   1 |
      | DateOperator       |                   0 |
      | DateMagnitude      |                   0 |
      | DateTimespan       |                   0 |
      | DateMode           |                   0 |
      | DateSpecificdate   | 2025-01-29 00:00:00 |
      | RiskMarker         |                  45 |
      | WeightedRiskScore  |                   0 |
      | RiskFactorOverride | true                |
    And response body should have key "OnboardingPropertyID" with the stored key value "integerOnboardingPropertyID"
    And response body should match the schema from the file "staticPropertyRisk"
    And response body should have key "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And response body should have key "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And response body should have key "OnboardingPropertyID" with the stored key value "integerOnboardingPropertyID"
    And response body should have key "UniqueID" with the stored key value "integerUniqueID"

  Scenario: 009 Should be able to delete Onboarding Type
    Given user has a service named "/api/v1/static/onboardingtype/delete"
    And user has a query params from the file 'onboardingTypes' with selected keys 'ActionUserID,ReturnFormat'
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
