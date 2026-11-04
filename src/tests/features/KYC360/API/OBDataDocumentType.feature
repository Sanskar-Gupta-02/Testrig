@Sanity @Regression @OBDataDocumentType
Feature: Happy Path- Static: Onboarding Data Document Type

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add Onboarding Data Document Type
    Given user has a service named '/api/v1/static/onboardingdatadocumenttype/add'
    And user has a payload from the file 'onboardingDataDocumentType'
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the values from "onboardingDataDocumentType" file
      | key              |
      | OnboardingTypeID |
      | Name             |
      | Description      |
    And response body should have key with the value:
      | key       | value |
      | Mandatory | true  |
    And response body should match the schema from the file "onboardingDataDocumentType"
    When user store the response body keyData:"OnboardingDataDocumentTypeID" with keyName:"FirstOnboardingDataDocumentTypeID"

  Scenario: 002 Should be able to fetch Onboarding Data Document Type
    Given user has a service named '/api/v1/static/onboardingdatadocumenttype/get'
    And user has a query params from the file 'onboardingDataDocumentType' with selected keys 'OnboardingTypeID,ReturnFormat'
    And user add query parameter 'OnboardingDataDocumentTypeID' with the stored key value 'FirstOnboardingDataDocumentTypeID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the values from "onboardingDataDocumentType" file
      | key              |
      | OnboardingTypeID |
      | Name             |
      | Description      |
    And response body should have key with the value:
      | key       | value |
      | Mandatory | true  |
    And response body should have key 'OnboardingDataDocumentTypeID' with the stored key value 'FirstOnboardingDataDocumentTypeID'
    And response body should match the schema from the file "onboardingDataDocumentType"

  Scenario: 003 should be able to update Onboarding Data Document Type
    Given user has a service named '/api/v1/static/onboardingdatadocumenttype/update'
    And user has a payload from the file 'onboardingDataDocumentType' updates the key 'Name' with the value 'Driving License - Update'
    And user add payload 'OnboardingDataDocumentTypeID' with the stored key value 'FirstOnboardingDataDocumentTypeID'
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the values from "onboardingDataDocumentType" file
      | key              |
      | OnboardingTypeID |
      | Description      |
    And response body should have key with the value:
      | key       | value                    |
      | Name      | Driving License - Update |
      | Mandatory | true                     |
    And response body should have key 'OnboardingDataDocumentTypeID' with the stored key value 'FirstOnboardingDataDocumentTypeID'
    And response body should match the schema from the file "onboardingDataDocumentType"

  Scenario: 004 should be able to add second Onboarding Data Document Type
    Given user has a service named '/api/v1/static/onboardingdatadocumenttype/add'
    And user has a payload from the file 'onboardingDataDocumentType'
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the values from "onboardingDataDocumentType" file
      | key              |
      | OnboardingTypeID |
      | Name             |
      | Description      |
    And response body should have key with the value:
      | key       | value |
      | Mandatory | true  |
    And response body should match the schema from the file "onboardingDataDocumentType"
    When user store the response body keyData:"OnboardingDataDocumentTypeID" with keyName:"SecondOnboardingDataDocumentTypeID"

  Scenario: 005 should be able to fetch all Onboarding Data Document Type
    Given user has a service named '/api/v1/static/onboardingdatadocumenttype/getall'
    And user has a query params from the file 'onboardingDataDocumentType' with selected keys 'OnboardingTypeID,ReturnFormat'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have index key with values from file "getAllOnboardingDocumentDataType"
      | index | key              |
      |     1 | OnboardingTypeID |
      |     2 | OnboardingTypeID |
    And response body should have index key with the stored key value:
      | index | key                          | storedKey                          |
      |     1 | OnboardingDataDocumentTypeID | FirstOnboardingDataDocumentTypeID  |
      |     2 | OnboardingDataDocumentTypeID | SecondOnboardingDataDocumentTypeID |

  Scenario: 006 Should be able to get Onboarding Type Data Document Type Link
    Given user has a service named "/api/v1/static/onboardingtypedatadocumenttypelink/get"
    And user has a query params from the file 'onboardingDataDocumentType' with selected keys 'OnboardingTypeID,ReturnFormat'
    And user add query parameter "OnboardingDataDocumentTypeID" with the stored key value "FirstOnboardingDataDocumentTypeID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key "OnboardingDataDocumentTypeID" with the stored key value "FirstOnboardingDataDocumentTypeID"
    And response body should have key with the value:
      | key                                   | value                    |
      | Mandatory                             | true                     |
      | OnboardingTypeID                      |                      695 |
      | OnboardingTypeName                    | API Automation Check     |
      | OnboardingTypeDescription             | API Automation           |
      | OnboardingDataDocumentTypeName        | Driving License - Update |
      | OnboardingDataDocumentTypeDescription | Playwright Automation    |
      | Hidden External                       | false                    |
      | Order                                 |                        0 |
    And response body should match the schema from the file "onboardingTypeDataDocumentTypeLink"

  Scenario: 007 user should be able to update Onboarding type Data Document Type link
    Given user has a service named '/api/v1/static/onboardingtypedatadocumenttypelink/update'
    And user has a payload from the file "onboardingDataDocumentType"
    And user add payload 'OnboardingDataDocumentTypeID' with the stored key value 'SecondOnboardingDataDocumentTypeID'
    And user has payloads:
      """
      {
        "DataDocumentTypeOrder": "0",
        "Mandatory":"false"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key "OnboardingDataDocumentTypeID" with the stored key value "SecondOnboardingDataDocumentTypeID"
    And response body should have key with the value:
      | key                                   | value                 |
      | Mandatory                             | false                 |
      | OnboardingTypeID                      |                   695 |
      | OnboardingTypeName                    | API Automation Check  |
      | OnboardingTypeDescription             | API Automation        |
      | OnboardingDataDocumentTypeName        | Driving License       |
      | OnboardingDataDocumentTypeDescription | Playwright Automation |
      | Hidden External                       | false                 |
      | Order                                 |                     0 |
    And response body should match the schema from the file "onboardingTypeDataDocumentTypeLink"

  Scenario: 008 user should be able to get all Onboarding type Data Document Type link
    Given user has a service named '/api/v1/static/onboardingtypedatadocumenttypelink/getall'
    And user has a query params from the file 'onboardingDataDocumentType' with selected keys 'OnboardingTypeID,ReturnFormat'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have index key with the value:
      | index | key                                   | value                    |
      |     1 | Mandatory                             | true                     |
      |     1 | OnboardingTypeID                      |                      695 |
      |     1 | OnboardingTypeName                    | API Automation Check     |
      |     1 | OnboardingTypeDescription             | API Automation           |
      |     1 | OnboardingDataDocumentTypeName        | Driving License - Update |
      |     1 | OnboardingDataDocumentTypeDescription | Playwright Automation    |
      |     1 | Hidden External                       | false                    |
      |     1 | Order                                 |                        0 |
      |     2 | Mandatory                             | false                    |
      |     2 | OnboardingTypeID                      |                      695 |
      |     2 | OnboardingTypeName                    | API Automation Check     |
      |     2 | OnboardingTypeDescription             | API Automation           |
      |     2 | OnboardingDataDocumentTypeName        | Driving License          |
      |     2 | OnboardingDataDocumentTypeDescription | Playwright Automation    |
      |     2 | Hidden External                       | false                    |
      |     2 | Order                                 |                        0 |
    And response body should have index key with the stored key value:
      | index | key                          | storedKey                          |
      |     1 | OnboardingDataDocumentTypeID | FirstOnboardingDataDocumentTypeID  |
      |     2 | OnboardingDataDocumentTypeID | SecondOnboardingDataDocumentTypeID |
    And response body should match the schema from the file "onboardingTypeDataDocumentTypeLinkGetAll"

  Scenario: 009 user should be able to delete Onboarding Data Document Type
    Given user has a service named '/api/v1/static/onboardingdatadocumenttype/delete'
    And user has a query params from the file 'onboardingDataDocumentType' with selected keys 'OnboardingTypeID,ReturnFormat,ActionUserID'
    And user add query parameter 'OnboardingDataDocumentTypeID' with the stored key value '<OnboardingDataDocumentTypeID>'
    When user sends a 'DELETE' request
    Then response status should be 200
    And response body should have key 'OnboardingTypeID' with the value '695'
    And response body should have key 'OnboardingDataDocumentTypeID' with the stored key value '<OnboardingDataDocumentTypeID>'

    Examples:
      | OnboardingDataDocumentTypeID       |
      | FirstOnboardingDataDocumentTypeID  |
      | SecondOnboardingDataDocumentTypeID |