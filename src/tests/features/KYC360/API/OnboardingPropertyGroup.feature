@Regression @OnboardingPropertyGroup
Feature: Onboaring PropertyGroup API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add Onboarding PropertyGroup
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
    And user has a service named "/api/v1/static/onboardingpropertygroup/add"
    And user has a payload from the file 'onboardingPropertyGroup'
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                   | value             |
      | Name                  | Auto - OB PG      |
      | Description           | Auto - OB PG Desc |
      | Notes                 | Auto test         |
      | PropertyGroupOrder    |                 1 |
      | Section               |                 1 |
      | Hidden                | false             |
      | Responsive            |                 1 |
      | ComplianceOnlyVisible | false             |
      | BeforeAfterTnC        | false             |
    And response body should match the schema from the file "onboardingPropertyGroup"
    And response body should have key "OnboardingTypeID" with the stored key value "onboardingTypeID"
    When user store the response body keyData:"OnboardingPropertyGroupID" with keyName:"onboardingPropertyGroupID"

  Scenario: 002 Should be able to get Onboarding PropertyGroup
    Given user has a service named "/api/v1/static/onboardingpropertygroup/get"
    And user has a payload from the file 'onboardingPropertyGroup'
    And user has a query params from the file "onboardingPropertyGroup" with selected keys "ReturnFormat"
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user add query parameter "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                   | value             |
      | Name                  | Auto - OB PG      |
      | Description           | Auto - OB PG Desc |
      | Notes                 | Auto test         |
      | PropertyGroupOrder    |                 1 |
      | Section               |                 1 |
      | Hidden                | false             |
      | Responsive            |                 1 |
      | ComplianceOnlyVisible | false             |
      | BeforeAfterTnC        | false             |
    And response body should have key "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And response body should have key "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And response body should match the schema from the file "onboardingPropertyGroup"

  Scenario: 003 Should be able to Update Onboarding PropertyGroup
    Given user has a service named "/api/v1/static/onboardingpropertygroup/update"
    And user has a payload from the file 'onboardingPropertyGroup'
    And user has payloads:
      """
      {
        "Name": "Auto - OB PG Update",
        "Description": "Auto - OB PG Desc Update",
        "Hidden": "true",
        "Responsive": "2"
      }
      """
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user add payload "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                   | value                    |
      | Name                  | Auto - OB PG Update      |
      | Description           | Auto - OB PG Desc Update |
      | Notes                 | Auto test                |
      | PropertyGroupOrder    |                        1 |
      | Section               |                        1 |
      | BeforeAfterTnC        | false                    |
      | Hidden                | true                     |
      | ComplianceOnlyVisible | false                    |
      | Responsive            |                        2 |
    And response body should match the schema from the file "onboardingPropertyGroup"
    And user store the response body keyData:"OnboardingPropertyGroupID" with keyName:"onboardingPropertyGroupID"

  Scenario: 004 Should be able to getall Onboarding PropertyGroup
    Given user has a service named "/api/v1/static/onboardingpropertygroup/add"
    And user has a payload from the file 'onboardingPropertyGroup'
    And user has payloads:
      """
      {
        "Name": "Auto - OB PG 2",
        "Description": "Auto - OB PG Desc 2",
        "Hidden": "false",
        "Responsive": "1",
        "PropertyGroupOrder": "2",
        "Section": "2"
      }
      """
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeID"
    When user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"OnboardingPropertyGroupID" with keyName:"secondOnboardingPropertyGroupID"
    And user has a service named "/api/v1/static/onboardingpropertygroup/getall"
    And user has a query params from the file "onboardingPropertyGroup" with selected keys "ReturnFormat"
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have index key with the value:
      | index | key                   | value                    |
      |     1 | Name                  | Auto - OB PG Update      |
      |     1 | Description           | Auto - OB PG Desc Update |
      |     1 | Notes                 | Auto test                |
      |     1 | PropertyGroupOrder    |                        1 |
      |     1 | Section               |                        1 |
      |     1 | BeforeAfterTnC        | false                    |
      |     1 | Hidden                | true                     |
      |     1 | ComplianceOnlyVisible | false                    |
      |     1 | Responsive            |                        2 |
      |     2 | Name                  | Auto - OB PG 2           |
      |     2 | Description           | Auto - OB PG Desc 2      |
      |     2 | Notes                 | Auto test                |
      |     2 | PropertyGroupOrder    |                        2 |
      |     2 | Section               |                        2 |
      |     2 | BeforeAfterTnC        | false                    |
      |     2 | Hidden                | false                    |
      |     2 | ComplianceOnlyVisible | false                    |
      |     2 | Responsive            |                        1 |
    And response body should have index key with the stored key value:
      | index | key                       | storedKey                       |
      |     1 | OnboardingTypeID          | onboardingTypeID                |
      |     1 | OnboardingPropertyGroupID | onboardingPropertyGroupID       |
      |     2 | OnboardingTypeID          | onboardingTypeID                |
      |     2 | OnboardingPropertyGroupID | secondOnboardingPropertyGroupID |
    And response body should match the schema from the file "onboardingPropertyGroupGetAll"

  Scenario: 005 Should be able to get Onboarding PropertyGroup Link
    Given user has a service named "/api/v1/static/onboardingtypepropertygrouplink/get"
    And user has a query params from the file "onboardingPropertyGroup" with selected keys "ReturnFormat"
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user add query parameter "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                | value                    |
      | OnboardingTypeDescription          | New Env testing          |
      | OnboardingPropertyGroupName        | Auto - OB PG Update      |
      | OnboardingPropertyGroupDescription | Auto - OB PG Desc Update |
      | OnboardingPropertyGroupNotes       | Auto test                |
      | PropertyGroupOrder                 |                        1 |
      | Section                            |                        1 |
      | Hidden                             | true                     |
      | Responsive                         |                        2 |
      | ComplianceOnlyVisible              | false                    |
    And response body should have key "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And response body should match the schema from the file "onboardingPropertyGroupLink"

  Scenario: 006 Should be able to Update Onboarding Property Group Link
    Given user has a service named "/api/v1/static/onboardingtypepropertygrouplink/update"
    And user has a payload from the file "onboardingPropertyGroup"
    And user add payload "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user add payload "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And user has payloads:
      """
      {
        "Hidden": "false",
        "Responsive": "1",
        "Section": "2"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                | value                    |
      | OnboardingTypeDescription          | New Env testing          |
      | OnboardingPropertyGroupName        | Auto - OB PG Update      |
      | OnboardingPropertyGroupDescription | Auto - OB PG Desc Update |
      | OnboardingPropertyGroupNotes       | Auto test                |
      | PropertyGroupOrder                 |                        2 |
      | Section                            |                        2 |
      | Hidden                             | false                    |
      | Responsive                         |                        1 |
      | ComplianceOnlyVisible              | false                    |
    And response body should have key "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And response body should match the schema from the file "onboardingPropertyGroupLink"

  Scenario: 007 Should be able to get all Onboarding PropertyGroup Link
    Given user has a service named "/api/v1/static/onboardingtypepropertygrouplink/getall"
    And user has a query params from the file "onboardingPropertyGroup" with selected keys "ReturnFormat"
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID"
    When user sends a 'GET' request
    Then response status should be 200
    And response body should have index key with the value:
      | index | key                                | value                    |
      |     1 | OnboardingTypeDescription          | New Env testing          |
      |     1 | OnboardingPropertyGroupName        | Auto - OB PG Update      |
      |     1 | OnboardingPropertyGroupDescription | Auto - OB PG Desc Update |
      |     1 | OnboardingPropertyGroupNotes       | Auto test                |
      |     1 | PropertyGroupOrder                 |                        2 |
      |     1 | Section                            |                        2 |
      |     1 | Hidden                             | false                    |
      |     1 | Responsive                         |                        1 |
      |     1 | ComplianceOnlyVisible              | false                    |
      |     2 | OnboardingTypeDescription          | New Env testing          |
      |     2 | OnboardingPropertyGroupName        | Auto - OB PG 2           |
      |     2 | OnboardingPropertyGroupDescription | Auto - OB PG Desc 2      |
      |     2 | OnboardingPropertyGroupNotes       | Auto test                |
      |     2 | PropertyGroupOrder                 |                        2 |
      |     2 | Section                            |                        2 |
      |     2 | Hidden                             | false                    |
      |     2 | Responsive                         |                        1 |
      |     2 | ComplianceOnlyVisible              | false                    |
    And response body should have index key with the stored key value:
      | index | key                       | storedKey                       |
      |     1 | OnboardingTypeID          | onboardingTypeID                |
      |     1 | OnboardingTypeName        | onboardingTypeName              |
      |     1 | OnboardingPropertyGroupID | onboardingPropertyGroupID       |
      |     2 | OnboardingTypeID          | onboardingTypeID                |
      |     2 | OnboardingTypeName        | onboardingTypeName              |
      |     2 | OnboardingPropertyGroupID | secondOnboardingPropertyGroupID |
    And response body should match the schema from the file "onboardingPropertyGroupLinkGetAll"

  Scenario: 008 Should be able to delete Onboarding PropertyGroup
    Given user has a service named "/api/v1/static/onboardingpropertygroup/delete"
    And user has a query params from the file "onboardingPropertyGroup" with selected keys "ActionUserID,ReturnFormat"
    And user add query parameter "OnboardingPropertyGroupID" with the stored key value "onboardingPropertyGroupID"
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                   | value                    |
      | Name                  | Auto - OB PG Update      |
      | Description           | Auto - OB PG Desc Update |
      | Notes                 | Auto test                |
      | PropertyGroupOrder    |                        2 |
      | Section               |                        2 |
      | BeforeAfterTnC        | false                    |
      | Hidden                | false                    |
      | ComplianceOnlyVisible | false                    |
      | Responsive            |                        1 |
    And response body should match the schema from the file "onboardingPropertyGroup"
    When user has a service named "/api/v1/static/onboardingtype/delete"
    And user has a query params from the file 'onboardingTypes' with selected keys 'ActionUserID,ReturnFormat'
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID"
    And user sends a 'DELETE' request
    Then response status should be 200
