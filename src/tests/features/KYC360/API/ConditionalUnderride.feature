@Regression @ConditionalUnderride
Feature: Onboarding Conditional Underride API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to create OnboardingType, OnboardingPropertyGroup, OnboardingProperties (Integer and List)
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
    And user has a service named "/api/v1/static/onboardingpropertygroup/add"
    And user has a payload from the file 'onboardingPropertyGroup'
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeId"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"OnboardingPropertyGroupID" with keyName:"onboardingPropertyGroupID"
    And user has a service named "/api/v1/static/onboardingstructure/add"
    And user has a payload from the file 'staticOnboardingStructure'
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeId"
    And user add payload "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And user has payloads:
      """
      {
        "OnboardingPropertyName": "Auto - Integer",
        "OnboardingPropertyDescription": "AutoDec - Integer",
        "PropertyOrder": "1",
        "IntegerDefaultValue": "10",
        "StoreID": "2",
        "IntegerMinimumValue": "1",
        "IntegerMaximumValue": "100",
        "RiskDefaultValue": "25",
        "WeightedRiskDefaultValue": "50",
        "EnabledForRisk": "true"
      }
      """
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"OnboardingPropertyID" with keyName:"integerOnboardingPropertyID"
    And user has a service named "/api/v1/static/onboardingstructure/add"
    And user has a payload from the file 'staticOnboardingStructure'
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeId"
    And user add payload "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And user has payloads:
      """
      {
        "OnboardingPropertyName": "Auto - List",
        "OnboardingPropertyDescription": "AutoDec - List",
        "PropertyOrder": "4",
        "ListDefaultListDataID": "39879",
        "StoreID": "5",
        "ListGroupID": "33333"
      }
      """
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"OnboardingPropertyID" with keyName:"listOnboardingPropertyID"
  # Scenario: 002 Should not be able to create Conditional Underride with risk score exceeding maximum
  #   Given user has a service named "/api/v1/static/conditionalunderride"
  #   And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
  #   And user has a payload from the file 'conditionalUnderride' with selected keys "ConditionalPropertyTargetValue"
  #   And user has payload "ConditionalRiskScoreUnderrideValue":"101"
  #   And user add payload "PropertyId" with the stored key value "integerOnboardingPropertyID"
  #   And user add payload "ConditionalPropertyId" with the stored key value "listOnboardingPropertyID"
  #   When user sends a 'POST' request
  #   Then response status should be 400
  #   And response body should have key 'Message' with the message:"ConditionalRiskScoreUnderrideValue exceeds maximum value"

  Scenario: 003 Should be able to create Conditional Underride
    When user has a service named "/api/v1/static/conditionalunderride"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    And user has a payload from the file 'conditionalUnderride' with selected keys "ConditionalPropertyTargetValue,ConditionalRiskScoreUnderrideValue"
    And user add payload "PropertyId" with the stored key value "integerOnboardingPropertyID"
    And user add payload "ConditionalPropertyId" with the stored key value "listOnboardingPropertyID"
    And user sends a 'POST' request
    Then response status should be 201
    And response body should match the schema from the file "conditionalUnderride"
    And response body should have key with the stored value:
      | key                   | storedKey                   |
      | PropertyId            | integerOnboardingPropertyID |
      | ConditionalPropertyId | listOnboardingPropertyID    |
    And response body should have key with the value:
      | key                                | value |
      | ConditionalPropertyTargetValue     | 39879 |
      | ConditionalRiskScoreUnderrideValue |    10 |
    When user store the response body keyData:"Id" with keyName:"conditionalUnderrideId"
    And user has a service named "/api/v1/static/conditionalunderride"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    And user has payload "ConditionalPropertyTargetValue":"39880"
    And user has payload "ConditionalRiskScoreUnderrideValue":"20"
    And user add payload "PropertyId" with the stored key value "integerOnboardingPropertyID"
    And user add payload "ConditionalPropertyId" with the stored key value "listOnboardingPropertyID"
    And user sends a 'POST' request
    Then response status should be 201
    And response body should match the schema from the file "conditionalUnderride"
    And response body should have key with the stored value:
      | key                   | storedKey                   |
      | PropertyId            | integerOnboardingPropertyID |
      | ConditionalPropertyId | listOnboardingPropertyID    |
    And response body should have key with the value:
      | key                                | value |
      | ConditionalPropertyTargetValue     | 39880 |
      | ConditionalRiskScoreUnderrideValue |    20 |
    And user store the response body keyData:"Id" with keyName:"secondConditionalUnderrideId"

  Scenario: 004 Should be able to get Conditional Underride by Id
    Given user has a service named "/api/v1/static/conditionalunderride/getbyid"
    And user add query parameter "UnderrideId" with the stored key value "conditionalUnderrideId"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response body should match the schema from the file "conditionalUnderride"
    And response body should have key "Id" with the stored key value "conditionalUnderrideId"
    And response body should have key with the stored value:
      | key                   | storedKey                   |
      | PropertyId            | integerOnboardingPropertyID |
      | ConditionalPropertyId | listOnboardingPropertyID    |
    And response body should have key with the value:
      | key                                | value |
      | ConditionalPropertyTargetValue     | 39879 |
      | ConditionalRiskScoreUnderrideValue |     10 |

  Scenario: 005 Should be able to update a Conditional Underride
    Given user has a service named "/api/v1/static/conditionalunderride"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    And user has a payload from the file 'conditionalUnderride' with selected keys "ConditionalPropertyTargetValue"
    And user has payload "ConditionalRiskScoreUnderrideValue":"30"
    And user add payload "PropertyId" with the stored key value "integerOnboardingPropertyID"
    And user add payload "ConditionalPropertyId" with the stored key value "listOnboardingPropertyID"
    And user add payload "Id" with the stored key value "conditionalUnderrideId"
    When user sends a 'PUT' request
    Then response status should be 200

  Scenario: 006 Should be able to get all conditionalUnderride by OnboardingTypeId
    Given user has a service named "/api/v1/static/conditionalunderride/getbyonboardingtype"
    And user add query parameter "OnboardingTypeId" with the stored key value "onboardingTypeId"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response body should match the schema from the file "conditionalUnderrideGetAll"
    And response body should have index key with the value:
      | index | key                                | value |
      |     1 | ConditionalPropertyTargetValue     | 39879 |
      |     1 | ConditionalRiskScoreUnderrideValue |    30 |
      |     2 | ConditionalPropertyTargetValue     | 39880 |
      |     2 | ConditionalRiskScoreUnderrideValue |    20 |
    And response body should have index key with the stored key value:
      | index | key                   | storedKey                    |
      |     1 | PropertyId            | integerOnboardingPropertyID  |
      |     1 | Id                    | conditionalUnderrideId       |
      |     1 | ConditionalPropertyId | listOnboardingPropertyID     |
      |     2 | PropertyId            | integerOnboardingPropertyID  |
      |     2 | Id                    | secondConditionalUnderrideId |
      |     2 | ConditionalPropertyId | listOnboardingPropertyID     |

  Scenario: 007 Should be able to get all conditionalUnderride by PropertyId
    Given user has a service named "/api/v1/static/conditionalunderride"
    And user add query parameter "PropertyId" with the stored key value "integerOnboardingPropertyID"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response body should match the schema from the file "conditionalUnderrideGetAll"
    And response body should have index key with the value:
      | index | key                                | value |
      |     1 | ConditionalPropertyTargetValue     | 39879 |
      |     1 | ConditionalRiskScoreUnderrideValue |    30 |
      |     2 | ConditionalPropertyTargetValue     | 39880 |
      |     2 | ConditionalRiskScoreUnderrideValue |    20 |
    And response body should have index key with the stored key value:
      | index | key                   | storedKey                    |
      |     1 | PropertyId            | integerOnboardingPropertyID  |
      |     1 | Id                    | conditionalUnderrideId       |
      |     1 | ConditionalPropertyId | listOnboardingPropertyID     |
      |     2 | PropertyId            | integerOnboardingPropertyID  |
      |     2 | Id                    | secondConditionalUnderrideId |
      |     2 | ConditionalPropertyId | listOnboardingPropertyID     |

  Scenario: 008 Should not be able to create Conditional Underride with invalid PropertyId
    Given user has a service named "/api/v1/static/conditionalunderride"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    And user has a payload from the file 'conditionalUnderride' with selected keys "ConditionalPropertyTargetValue,ConditionalRiskScoreUnderrideValue"
    And user has payload "PropertyId":"99999999"
    And user add payload "ConditionalPropertyId" with the stored key value "listOnboardingPropertyID"
    When user sends a 'POST' request
    Then response status should be 406
    And response body should have key 'Message' with the message:'Property with id 99999999 does not exist'

  Scenario: 009 Should not be able to create Conditional Underride with invalid ConditionalPropertyId
    Given user has a service named "/api/v1/static/conditionalunderride"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    And user has a payload from the file 'conditionalUnderride' with selected keys "ConditionalPropertyTargetValue,ConditionalRiskScoreUnderrideValue"
    And user add payload "PropertyId" with the stored key value "integerOnboardingPropertyID"
    And user has payload "ConditionalPropertyId":"99999999"
    When user sends a 'POST' request
    Then response status should be 406
    And response body should have key 'Message' with the message:"All underrides assigned to a property must have matching ConditionalUnderrideId values"

  Scenario: 010 Should not be able to create Conditional Underride with missing required fields
    Given user has a service named "/api/v1/static/conditionalunderride"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    And user has payload "ConditionalRiskScoreUnderrideValue":"10"
    When user sends a 'POST' request
    Then response status should be 406
    And response body should have key 'Message' with the message:"The request is invalid."

  Scenario: 011 Should not be able to create Conditional Underride with negative risk score
    Given user has a service named "/api/v1/static/conditionalunderride"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    And user has a payload from the file 'conditionalUnderride' with selected keys "ConditionalPropertyTargetValue"
    And user has payload "ConditionalRiskScoreUnderrideValue":"-10"
    And user add payload "PropertyId" with the stored key value "integerOnboardingPropertyID"
    And user add payload "ConditionalPropertyId" with the stored key value "listOnboardingPropertyID"
    When user sends a 'POST' request
    Then response status should be 406
    And response body should have key 'Message' with the message:"The request is invalid."

  Scenario: 012 Should not be able to create duplicate Conditional Underride
    Given user has a service named "/api/v1/static/conditionalunderride"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    And user has a payload from the file 'conditionalUnderride' with selected keys "ConditionalPropertyTargetValue,ConditionalRiskScoreUnderrideValue"
    And user add payload "PropertyId" with the stored key value "integerOnboardingPropertyID"
    And user add payload "ConditionalPropertyId" with the stored key value "listOnboardingPropertyID"
    When user sends a 'POST' request
    Then response status should be 406
    And response body should have key 'Message' with the message:"Cannot create more than one underride per-property with the same Target Value. An underride already exists with the target value '39879'"

  Scenario: 013 Should not be able to create Conditional Underride with same PropertyId and ConditionalPropertyId
    Given user has a service named "/api/v1/static/conditionalunderride"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    And user has a payload from the file 'conditionalUnderride'
    And user add payload "PropertyId" with the stored key value "integerOnboardingPropertyID"
    And user add payload "ConditionalPropertyId" with the stored key value "integerOnboardingPropertyID"
    When user sends a 'POST' request
    Then response status should be 406
    And response body should have key 'Message' with the message:"All underrides assigned to a property must have matching ConditionalUnderrideId values"

  Scenario: 014 Should handle special characters in ConditionalPropertyTargetValue
    Given user has a service named "/api/v1/static/conditionalunderride"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    And user has payload "ConditionalPropertyTargetValue":"<script>alert('test')</script>"
    And user has payload "ConditionalRiskScoreUnderrideValue":"10"
    And user add payload "PropertyId" with the stored key value "integerOnboardingPropertyID"
    And user add payload "ConditionalPropertyId" with the stored key value "listOnboardingPropertyID"
    When user sends a 'POST' request
    Then response status should be 406
    And response body should have key 'Message' with the message:"The request is invalid."

  Scenario: 015 Should not be able to access Conditional Underride API with invalid API key
    Given user is authorized using an 'INVALIDAPIKEY'
    And user has a service named "/api/v1/static/conditionalunderride"
    And user add query parameter "UnderrideId" with the stored key value "conditionalUnderrideId"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 401

  Scenario: 016 Should not be able to update Conditional Underride with invalid Id
    Given user has a service named "/api/v1/static/conditionalunderride"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    And user has a payload from the file 'conditionalUnderride'
    And user has payload "Id":"99999999"
    When user sends a 'PUT' request
    Then response status should be 406
    And response body should have key 'Message' with the message:"Underride with id 99999999 does not exist."

  Scenario: 017 Should not be able to update Conditional Underride without Id
    Given user has a service named "/api/v1/static/conditionalunderride"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    And user has a payload from the file 'conditionalUnderride' with selected keys "ConditionalPropertyTargetValue"
    And user has payload "ConditionalRiskScoreUnderrideValue":"30"
    And user add payload "PropertyId" with the stored key value "integerOnboardingPropertyID"
    And user add payload "ConditionalPropertyId" with the stored key value "listOnboardingPropertyID"
    When user sends a 'PUT' request
    Then response status should be 406
    And response body should have key 'Message' with the message:"The request is invalid."

  Scenario: 018 Should not be able to get Conditional Underride with invalid query parameters
    Given user has a service named "/api/v1/static/conditionalunderride/getbyid"
    And user has query parameter "Id":"99999999"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 406
    And response body should have key 'Message' with the message:"Id must be greater than zero"

  Scenario: 019 Should return empty array when no Conditional Underrides exist for OnboardingType
    Given user has a service named "/api/v1/static/conditionalunderride/getbyonboardingtype"
    And user has query parameter "OnboardingTypeId":"99999999"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response body should be an empty array

  Scenario: 020 Should not accept string value for numeric fields
    Given user has a service named "/api/v1/static/conditionalunderride"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    And user has a payload from the file 'conditionalUnderride' with selected keys "ConditionalPropertyTargetValue"
    And user has payload "ConditionalRiskScoreUnderrideValue":"abc"
    And user add payload "PropertyId" with the stored key value "integerOnboardingPropertyID"
    And user add payload "ConditionalPropertyId" with the stored key value "listOnboardingPropertyID"
    When user sends a 'POST' request
    Then response status should be 406
    And response body should have key 'Message' with the message:"The request is invalid."

  Scenario: 021 Should handle null values appropriately
    Given user has a service named "/api/v1/static/conditionalunderride"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    And user has payload "ConditionalPropertyTargetValue":""
    And user has payload "ConditionalRiskScoreUnderrideValue":"10"
    And user add payload "PropertyId" with the stored key value "integerOnboardingPropertyID"
    And user add payload "ConditionalPropertyId" with the stored key value "listOnboardingPropertyID"
    When user sends a 'POST' request
    Then response status should be 406
    And response body should have key 'Message' with the message:"The request is invalid."

  Scenario: 022 Should be able to delete a conditionalUnderride and OnboardingType
    Given user has a service named "/api/v1/static/conditionalunderride"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    And user has a payload from the file 'conditionalUnderride' with selected keys "ConditionalPropertyTargetValue"
    And user has payload "ConditionalRiskScoreUnderrideValue":"30"
    And user add payload "PropertyId" with the stored key value "integerOnboardingPropertyID"
    And user add payload "ConditionalPropertyId" with the stored key value "listOnboardingPropertyID"
    And user add payload "Id" with the stored key value "conditionalUnderrideId"
    When user sends a 'DELETE' request
    Then response status should be 200
    When user has a service named "/api/v1/static/conditionalunderride"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    And user has payload "ConditionalPropertyTargetValue":"39880"
    And user has payload "ConditionalRiskScoreUnderrideValue":"20"
    And user add payload "PropertyId" with the stored key value "integerOnboardingPropertyID"
    And user add payload "ConditionalPropertyId" with the stored key value "listOnboardingPropertyID"
    And user add payload "Id" with the stored key value "secondConditionalUnderrideId"
    And user sends a 'DELETE' request
    Then response status should be 200
    When user has a service named "/api/v1/static/onboardingtype/delete"
    And user has a query params from the file 'onboardingTypes' with selected keys 'ActionUserID,ReturnFormat'
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeId"
    And user sends a 'DELETE' request
    Then response status should be 200

  Scenario: 023 Should not be able to delete already deleted Conditional Underride
    Given user has a service named "/api/v1/static/conditionalunderride"
    And user has a query params from the file "conditionalUnderride" with selected keys "ReturnFormat"
    And user has a payload from the file 'conditionalUnderride' with selected keys "ConditionalPropertyTargetValue"
    And user has payload "ConditionalRiskScoreUnderrideValue":"30"
    And user add payload "PropertyId" with the stored key value "integerOnboardingPropertyID"
    And user add payload "ConditionalPropertyId" with the stored key value "listOnboardingPropertyID"
    And user add payload "Id" with the stored key value "conditionalUnderrideId"
    When user sends a 'DELETE' request
    Then response status should be 400
