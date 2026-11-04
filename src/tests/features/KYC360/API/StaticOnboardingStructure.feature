@Regression @StaticOnboardingStructure
Feature: Static Onboarding Structure API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add an onboarding type
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

  Scenario: 003 Should be able to add Static Onboarding Structure Text
    Given user has a service named "/api/v1/static/onboardingstructure/add"
    And user has a payload from the file 'staticOnboardingStructure'
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user add payload "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And user has payloads:
      """
      {
        "OnboardingPropertyName": "Auto - Text",
        "OnboardingPropertyDescription": "AutoDec - Text",
        "PropertyOrder": "1",
        "TextDefaultValue": "Auto-Test",
        "StoreID": "1",
        "TextMinimumSize": "1",
        "TextMaximumSize": "100"
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticOnboardingStructure"
    And response body should have key with the value:
      | key                           | value          |
      | OnboardingPropertyName        | Auto - Text    |
      | OnboardingPropertyDescription | AutoDec - Text |
      | PropertyOrder                 |              1 |
      | TextDefaultValue              | Auto-Test      |
      | StoreID                       |              1 |
      | TextMinimumSize               |              1 |
      | TextMaximumSize               |            100 |
      | Hidden                        | false          |
      | Responsive                    |              0 |
      | RequiredField                 | true           |
      | ScreeningID                   |              0 |
      | OnboardingPropertyNotes       | auto test      |
    And response body should have key "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And response body should have key "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    When user store the response body keyData:"OnboardingPropertyID" with keyName:"textOnboardingPropertyID"

  Scenario: 004 Should be able to add Static Onboarding Structure Integer
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
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticOnboardingStructure"
    And response body should have key with the value:
      | key                           | value             |
      | OnboardingPropertyName        | Auto - Integer    |
      | OnboardingPropertyDescription | AutoDec - Integer |
      | PropertyOrder                 |                 2 |
      | IntegerDefaultValue           |                10 |
      | StoreID                       |                 2 |
      | IntegerMinimumValue           |                 1 |
      | IntegerMaximumValue           |               100 |
      | Hidden                        | false             |
      | Responsive                    |                 0 |
      | RequiredField                 | true              |
      | ScreeningID                   |                 0 |
      | OnboardingPropertyNotes       | auto test         |
    And response body should have key "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And response body should have key "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    When user store the response body keyData:"OnboardingPropertyID" with keyName:"integerOnboardingPropertyID"

  Scenario: 005 Should be able to add Static Onboarding Structure decimal
    Given user has a service named "/api/v1/static/onboardingstructure/add"
    And user has a payload from the file 'staticOnboardingStructure'
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user add payload "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And user has payloads:
      """
      {
        "OnboardingPropertyName": "Auto - Decimal",
        "OnboardingPropertyDescription": "AutoDec - Decimal",
        "PropertyOrder": "3",
        "DecimalDefaultValue": "10.5",
        "StoreID": "3",
        "DecimalMinimumValue": "1.5",
        "DecimalMaximumValue": "20.5"
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticOnboardingStructure"
    And response body should have key with the value:
      | key                           | value             |
      | OnboardingPropertyName        | Auto - Decimal    |
      | OnboardingPropertyDescription | AutoDec - Decimal |
      | PropertyOrder                 |                 3 |
      | DecimalDefaultValue           |              10.5 |
      | StoreID                       |                 3 |
      | DecimalMinimumValue           |               1.5 |
      | DecimalMaximumValue           |              20.5 |
      | Hidden                        | false             |
      | Responsive                    |                 0 |
      | RequiredField                 | true              |
      | ScreeningID                   |                 0 |
      | OnboardingPropertyNotes       | auto test         |
      | DecimalSymbol                 |                 1 |
      | DecimalDigits                 |                 2 |
    And response body should have key "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And response body should have key "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    When user store the response body keyData:"OnboardingPropertyID" with keyName:"decimalOnboardingPropertyID"

  Scenario: 006 Should be able to add Static Onboarding Structure list
    Given user has a service named "/api/v1/static/onboardingstructure/add"
    And user has a payload from the file 'staticOnboardingStructure'
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeID"
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
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticOnboardingStructure"
    And response body should have key with the value:
      | key                           | value          |
      | OnboardingPropertyName        | Auto - List    |
      | OnboardingPropertyDescription | AutoDec - List |
      | PropertyOrder                 |              4 |
      | DefaultListDataID             |          39879 |
      | StoreID                       |              5 |
      | ListGroupID                   |          33333 |
      | Hidden                        | false          |
      | Responsive                    |              0 |
      | RequiredField                 | true           |
      | ScreeningID                   |              0 |
      | OnboardingPropertyNotes       | auto test      |
    And response body should have key "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And response body should have key "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    When user store the response body keyData:"OnboardingPropertyID" with keyName:"listOnboardingPropertyID"

  Scenario: 007 Should be able to add Static Onboarding Structure date
    Given user has a service named "/api/v1/static/onboardingstructure/add"
    And user has a payload from the file 'staticOnboardingStructure'
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user add payload "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And user has payloads:
      """
      {
        "OnboardingPropertyName": "Auto - Date",
        "OnboardingPropertyDescription": "AutoDec - Date",
        "PropertyOrder": "5",
        "DateMinimumValue": "<currentDateStamp>",
        "StoreID": "4",
        "DateMaximumValue": "<currentDateStamp>"
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticOnboardingStructure"
    And response body should have key with the value:
      | key                           | value                       |
      | OnboardingPropertyName        | Auto - Date                 |
      | OnboardingPropertyDescription | AutoDec - Date              |
      | PropertyOrder                 |                           5 |
      | DateMinimumValue              | <currentDateStamp> 00:00:00 |
      | StoreID                       |                           4 |
      | DateMaximumValue              | <currentDateStamp> 00:00:00 |
      | Hidden                        | false                       |
      | Responsive                    |                           0 |
      | RequiredField                 | true                        |
      | ScreeningID                   |                           0 |
      | OnboardingPropertyNotes       | auto test                   |
    And response body should have key "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And response body should have key "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    When user store the response body keyData:"OnboardingPropertyID" with keyName:"dateOnboardingPropertyID"

  Scenario: 008 Should be able to get Static Onboarding Structure text
    Given user has a service named "/api/v1/static/onboardingstructure/get"
    And user has a query params from the file 'onboardingTypes' with selected keys 'ReturnFormat'
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user add query parameter "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And user add query parameter "OnboardingPropertyID" with the stored key value "textOnboardingPropertyID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                           | value          |
      | OnboardingPropertyName        | Auto - Text    |
      | OnboardingPropertyDescription | AutoDec - Text |
      | PropertyOrder                 |              1 |
      | TextDefaultValue              | Auto-Test      |
      | StoreID                       |              1 |
      | TextMinimumSize               |              1 |
      | TextMaximumSize               |            100 |
      | Hidden                        | false          |
      | Responsive                    |              0 |
      | RequiredField                 | true           |
      | ScreeningID                   |              0 |
      | OnboardingPropertyNotes       | auto test      |
    And response body should match the schema from the file "staticOnboardingStructure"
    And response body should have key "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And response body should have key "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And response body should have key "OnboardingPropertyID" with the stored key value "textOnboardingPropertyID"

  Scenario: 009 Should be able to update Static Onboarding Structure text
    Given user has a service named "/api/v1/static/onboardingstructure/update"
    And user has a payload from the file 'staticOnboardingStructure'
    And user add payload "OnboardingPropertyID" with the stored key value "textOnboardingPropertyID"
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user add payload "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And user has payloads:
      """
      {
       "OnboardingPropertyName": "Auto - Text -Update",
       "OnboardingPropertyDescription": "AutoDec - Text -Update",
       "PropertyOrder": "2",
       "TextDefaultValue": "Auto-Test -Update",
       "StoreID": "1",
       "TextMinimumSize": "4",
       "TextMaximumSize": "104",
       "OnboardingPropertyNotes":"auto test -Update",
       "RequiredField":"false",
       "ScreeningID":"1"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                           | value                  |
      | OnboardingPropertyName        | Auto - Text -Update    |
      | OnboardingPropertyDescription | AutoDec - Text -Update |
      | PropertyOrder                 |                      2 |
      | TextDefaultValue              | Auto-Test -Update      |
      | StoreID                       |                      1 |
      | TextMinimumSize               |                      4 |
      | TextMaximumSize               |                    104 |
      | Hidden                        | false                  |
      | Responsive                    |                      0 |
      | RequiredField                 | false                  |
      | ScreeningID                   |                      1 |
      | OnboardingPropertyNotes       | auto test -Update      |
    And response body should match the schema from the file "staticOnboardingStructure"
    And response body should have key "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And response body should have key "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And response body should have key "OnboardingPropertyID" with the stored key value "textOnboardingPropertyID"

  Scenario: 010 Should be able to get all Static Onboarding Structure
    Given user has a service named "/api/v1/static/onboardingstructure/getall"
    And user has a query params from the file 'onboardingTypes' with selected keys 'ReturnFormat'
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user add query parameter "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have index key with the value:
      | index | key                           | value                       |
      |     1 | OnboardingPropertyName        | Auto - Text -Update         |
      |     1 | OnboardingPropertyDescription | AutoDec - Text -Update      |
      |     1 | PropertyOrder                 |                           2 |
      |     1 | TextDefaultValue              | Auto-Test -Update           |
      |     1 | StoreID                       |                           1 |
      |     1 | TextMinimumSize               |                           4 |
      |     1 | TextMaximumSize               |                         104 |
      |     1 | Hidden                        | false                       |
      |     1 | Responsive                    |                           0 |
      |     1 | RequiredField                 | false                       |
      |     1 | ScreeningID                   |                           1 |
      |     1 | OnboardingPropertyNotes       | auto test -Update           |
      |     2 | OnboardingPropertyName        | Auto - Integer              |
      |     2 | OnboardingPropertyDescription | AutoDec - Integer           |
      |     2 | PropertyOrder                 |                           2 |
      |     2 | IntegerDefaultValue           |                          10 |
      |     2 | StoreID                       |                           2 |
      |     2 | IntegerMinimumValue           |                           1 |
      |     2 | IntegerMaximumValue           |                         100 |
      |     2 | Hidden                        | false                       |
      |     2 | Responsive                    |                           0 |
      |     2 | RequiredField                 | true                        |
      |     2 | ScreeningID                   |                           0 |
      |     2 | OnboardingPropertyNotes       | auto test                   |
      |     3 | OnboardingPropertyName        | Auto - Decimal              |
      |     3 | OnboardingPropertyDescription | AutoDec - Decimal           |
      |     3 | PropertyOrder                 |                           3 |
      |     3 | DecimalDefaultValue           |                        10.5 |
      |     3 | StoreID                       |                           3 |
      |     3 | DecimalMinimumValue           |                         1.5 |
      |     3 | DecimalMaximumValue           |                        20.5 |
      |     3 | Hidden                        | false                       |
      |     3 | Responsive                    |                           0 |
      |     3 | RequiredField                 | true                        |
      |     3 | ScreeningID                   |                           0 |
      |     3 | OnboardingPropertyNotes       | auto test                   |
      |     3 | DecimalSymbol                 |                           1 |
      |     3 | DecimalDigits                 |                           2 |
      |     4 | OnboardingPropertyName        | Auto - List                 |
      |     4 | OnboardingPropertyDescription | AutoDec - List              |
      |     4 | PropertyOrder                 |                           4 |
      |     4 | DefaultListDataID             |                       39879 |
      |     4 | StoreID                       |                           5 |
      |     4 | ListGroupID                   |                       33333 |
      |     4 | Hidden                        | false                       |
      |     4 | Responsive                    |                           0 |
      |     4 | RequiredField                 | true                        |
      |     4 | ScreeningID                   |                           0 |
      |     4 | OnboardingPropertyNotes       | auto test                   |
      |     5 | OnboardingPropertyName        | Auto - Date                 |
      |     5 | OnboardingPropertyDescription | AutoDec - Date              |
      |     5 | PropertyOrder                 |                           5 |
      |     5 | DateMinimumValue              | <currentDateStamp> 00:00:00 |
      |     5 | StoreID                       |                           4 |
      |     5 | DateMaximumValue              | <currentDateStamp> 00:00:00 |
      |     5 | Hidden                        | false                       |
      |     5 | Responsive                    |                           0 |
      |     5 | RequiredField                 | true                        |
      |     5 | ScreeningID                   |                           0 |
      |     5 | OnboardingPropertyNotes       | auto test                   |
    And response body should have index key with the stored key value:
      | index | key                       | storedKey                   |
      |     1 | OnboardingTypeID          | onboardingTypeID            |
      |     1 | OnboardingPropertyGroupID | onboardingPropertyGroupID   |
      |     1 | OnboardingPropertyID      | textOnboardingPropertyID    |
      |     2 | OnboardingTypeID          | onboardingTypeID            |
      |     2 | OnboardingPropertyGroupID | onboardingPropertyGroupID   |
      |     2 | OnboardingPropertyID      | integerOnboardingPropertyID |
      |     3 | OnboardingTypeID          | onboardingTypeID            |
      |     3 | OnboardingPropertyGroupID | onboardingPropertyGroupID   |
      |     3 | OnboardingPropertyID      | decimalOnboardingPropertyID |
      |     4 | OnboardingTypeID          | onboardingTypeID            |
      |     4 | OnboardingPropertyGroupID | onboardingPropertyGroupID   |
      |     4 | OnboardingPropertyID      | listOnboardingPropertyID    |
      |     5 | OnboardingTypeID          | onboardingTypeID            |
      |     5 | OnboardingPropertyGroupID | onboardingPropertyGroupID   |
      |     5 | OnboardingPropertyID      | dateOnboardingPropertyID    |
    And response body should match the schema from the file "staticOnboardingStructureGetAll"

  Scenario: 011 Should be able to delete Onboarding Type Structure
    Given user has a service named "/api/v1/static/onboardingstructure/delete"
    And user has a query params from the file 'onboardingTypes' with selected keys 'ActionUserID,ReturnFormat'
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user add query parameter "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And user add query parameter "OnboardingPropertyID" with the stored key value "textOnboardingPropertyID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                           | value                  |
      | OnboardingPropertyName        | Auto - Text -Update    |
      | OnboardingPropertyDescription | AutoDec - Text -Update |
      | PropertyOrder                 |                      2 |
      | TextDefaultValue              | Auto-Test -Update      |
      | StoreID                       |                      1 |
      | TextMinimumSize               |                      4 |
      | TextMaximumSize               |                    104 |
      | Hidden                        | false                  |
      | Responsive                    |                      0 |
      | RequiredField                 | false                  |
      | ScreeningID                   |                      1 |
      | OnboardingPropertyNotes       | auto test -Update      |
    And response body should match the schema from the file "staticOnboardingStructure"
    And response body should have key "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And response body should have key "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And response body should have key "OnboardingPropertyID" with the stored key value "textOnboardingPropertyID"

  Scenario: 012 Should be able to delete Onboarding type
    Given user has a service named "/api/v1/static/onboardingtype/delete"
    And user has a query params from the file 'onboardingTypes' with selected keys 'ActionUserID,ReturnFormat'
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'

  Scenario: 013 Should be able to export Static Onboarding structure
    Given user has a service named "/api/v1/static/onboardingstructure/export"
    And user has a query params from the file 'staticOnboardingStructureExport' with selected keys 'OnboardingTypeIDs,ActionUserID,ReturnFormat'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticOnboardingStructureExport"
