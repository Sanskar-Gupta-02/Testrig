@Regression @Onboarding
Feature: Onboaring API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add and update Onboarding
    Given user has a service named "/api/v1/client/prospect/add"
    And user has a payload from the file 'prospect'
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the values from "prospect" file
      | key                       |
      | BusinessUnitID            |
      | OnboardingTypeID          |
      | HandledByUserID           |
      | HandledBySupervisorUserID |
      | HandledByManagerUserID    |
      | HandledByDirectorUserID   |
      | InterfaceReference        |
      | LastName                  |
      | FirstName                 |
      | Email                     |
      | AllowKYBLookup            |
    And response body should have key with keys from 'prospect' file
      | keyFromResponse  | keyFromFile          |
      | HandledByGroupID | HandledByUserGroupID |
    And response body should match the schema from the file "prospect"
    When user store the response body keyData:"ClientProspectID" with keyName:"prospectID"
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with keys from 'prospect' file
      | keyFromResponse              | keyFromFile          |
      | OnboardingTypeID             | OnboardingTypeID     |
      | ProspectHandledByUserGroupID | HandledByUserGroupID |
      | ProspectHandledByUserID      | HandledByUserID      |
    And response body should have key with the values from "onboarding" file
      | key               |
      | BusinessUnitID    |
      | OnboardingStageID |
      | OnboardingStatus  |
      | EIDVUUIDReference |
      | Notes             |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingIDFirst"
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with keys from 'prospect' file
      | keyFromResponse              | keyFromFile          |
      | OnboardingTypeID             | OnboardingTypeID     |
      | ProspectHandledByUserGroupID | HandledByUserGroupID |
      | ProspectHandledByUserID      | HandledByUserID      |
    And response body should have key with the values from "onboarding" file
      | key               |
      | BusinessUnitID    |
      | OnboardingStageID |
      | OnboardingStatus  |
      | EIDVUUIDReference |
      | Notes             |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingIDSecond"
    And user has a service named "/api/v1/client/onboarding/update"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingIDSecond"
    And user has payloads:
      """
      {
          "AssessedRiskValue": "0",
          "WeightedRiskScore": "12",
          "WeightedRiskScoreBand": "Medium",
          "WeightedRiskScoreOverriden": "True"
      }
      """
    And user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboarding"
    And response body should have key with keys from 'prospect' file
      | keyFromResponse              | keyFromFile          |
      | OnboardingTypeID             | OnboardingTypeID     |
      | ProspectHandledByUserGroupID | HandledByUserGroupID |
      | ProspectHandledByUserID      | HandledByUserID      |
    And response body should have key with the values from "onboarding" file
      | key               |
      | BusinessUnitID    |
      | OnboardingStageID |
      | OnboardingStatus  |
      | EIDVUUIDReference |
      | Notes             |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"

  Scenario: 002 Should be able to get all onboarding details
    Given user has a service named "/api/v1/client/onboarding/getall"
    And user has query parameters:
      """
        {
        "OnboardingTypeID":"10",
        "IncludeDocumentData":"true",
        "ReturnEncodedValues":"true",
        "ReturnFormat":"Json"
        }
      """
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    When user sends a 'Get' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboardingSearch"
    And response body should have index key with values from file "onboardingSearch"
      | index | key               |
      |     1 | BusinessUnitID    |
      |     1 | OnboardingStageID |
      |     1 | OnboardingStatus  |
      |     2 | BusinessUnitID    |
      |     2 | OnboardingStageID |
      |     2 | OnboardingStatus  |
    And response body should have index key with the stored key value:
      | index | key                | storedKey          |
      |     1 | ClientProspectID   | prospectID         |
      |     1 | ClientOnboardingID | onboardingIDFirst  |
      |     2 | ClientProspectID   | prospectID         |
      |     2 | ClientOnboardingID | onboardingIDSecond |

  Scenario: 003 Should be able to delete onboardings
    Given user has a service named "/api/v1/client/onboarding/delete"
    And user has a query params from the file 'onboarding' with selected keys 'OnboardingTypeID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value '<onboardingID>'
    When user sends a 'Delete' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboarding"

    Examples:
      | onboardingID       |
      | onboardingIDFirst  |
      | onboardingIDSecond |

  Scenario: 004 Should be able to delete prospect
    Given user has a service named "/api/v1/client/prospect/delete"
    And user has a payload from the file "prospect" with selected keys "OnboardingTypeID,ActionUserID,ReturnFormat"
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    When user sends a 'Delete' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "prospect"

  Scenario: 005 Should be able to fetch prospect for Prescreening Stage.#ENG-T12691
    Given user has a service named "/api/v1/client/onboarding/get"
    And user is authorized using an 'ALIASAPIKEY'
    And user has query parameters:
      """
        {
        "BusinessUnitID": 10,
        "ClientProspectID": 614802,
        "ClientOnboardingID": 351464,
        "StageID": 7,
        "UniqueID": 7,
        "ReturnFormat": "Json"
        }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboardingStages"

  Scenario: 006 Should be able to Search for Client OnBoarding Records.#ENG-T12690,T12692
    Given user has a service named "/api/v1/client/onboarding/search"
    And user is authorized using an 'ALIASAPIKEY'
    And user has query parameters:
      """
      {
      "BusinessUnitID": 10,
      "OnboardingTypeID": 1930,
      "ClientProspectGroupID": 1279,
      "HandledByUserGroupID": 330,
      "HandledByUserID": 524,
      "FilterDataCollection": 0,
      "FilterRisk": 0,
      "FilterIdentityVerification": 0,
      "FilterScreening": 0,
      "FilterScreeningMatchFlagCategoryID": 0,
      "FilterCategory": 0,
      "AgeInDays": 3,
      "FromDate": "",
      "ToDate": "",
      "OnboardingStageID": 7,
      "OnboardingStatus": 1,
      "SortColumn": 0,
      "SortAscending": false,
      "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboardingSearchGet"
