@Sanity @Regression @Prospect
Feature: Happy Path- Onboarding: Prospect

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add Prospect
    Given user has a service named '/api/v1/client/prospect/add'
    And user has a payload from the file 'prospect'
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value                     |
      | InterfaceReference        | PlaywrightAutomation123   |
      | LastName                  | AddedProspect             |
      | FirstName                 | API                       |
      | Email                     | krunallute@riskscreen.com |
      | AllowManageProspect       | true                      |
      | AllowKYBLookup            | true                      |
      | UseDefaultEmail           | true                      |
      | Imported                  | false                     |
      | MobilePhone               |                1234567890 |
      | BusinessUnitID            |                        10 |
      | OnboardingTypeID          |                       695 |
      | ProspectStatus            |                         1 |
      | HandledByGroupID          |                       325 |
      | HandledByUserID           |                       521 |
      | HandledBySupervisorUserID |                       547 |
      | HandledByManagerUserID    |                       532 |
      | HandledByDirectorUserID   |                       531 |
    And response body should match the schema from the file "prospect"
    When user store the response body keyData:"ClientProspectID" with keyName:"ClientProspectID"

  Scenario: 002 Should be able to fetch Prospect
    Given user has a service named '/api/v1/client/prospect/get'
    And user has a query params from the file 'prospect' with selected keys 'BusinessUnitID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'ClientProspectID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value                     |
      | InterfaceReference        | PlaywrightAutomation123   |
      | LastName                  | AddedProspect             |
      | FirstName                 | API                       |
      | Email                     | krunallute@riskscreen.com |
      | AllowManageProspect       | true                      |
      | AllowKYBLookup            | true                      |
      | UseDefaultEmail           | true                      |
      | Imported                  | false                     |
      | MobilePhone               |                1234567890 |
      | BusinessUnitID            |                        10 |
      | OnboardingTypeID          |                       695 |
      | ProspectStatus            |                         1 |
      | HandledByGroupID          |                       325 |
      | HandledByUserID           |                       521 |
      | HandledBySupervisorUserID |                       547 |
      | HandledByManagerUserID    |                       532 |
      | HandledByDirectorUserID   |                       531 |
    And response body should have key 'ClientProspectID' with the stored key value 'ClientProspectID'
    And response body should match the schema from the file "prospect"

  Scenario: 003 should be able to update Prospect
    Given user has a service named '/api/v1/client/prospect/update'
    And user has a payload from the file "prospect"
    And user add payload 'ClientProspectID' with the stored key value 'ClientProspectID'
    And user has payloads:
      """
      {
      "LastName":"UpdatedProspect",
      "InterfaceReference":"PlaywrightAutomationUpdate",
      "AllowManageProspect":"false",
      "AllowKYBLookup":"false"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value                      |
      | InterfaceReference        | PlaywrightAutomationUpdate |
      | LastName                  | UpdatedProspect            |
      | FirstName                 | API                        |
      | Email                     | krunallute@riskscreen.com  |
      | AllowManageProspect       | false                      |
      | AllowKYBLookup            | false                      |
      | UseDefaultEmail           | true                       |
      | Imported                  | false                      |
      | MobilePhone               |                 1234567890 |
      | BusinessUnitID            |                         10 |
      | OnboardingTypeID          |                        695 |
      | ProspectStatus            |                          1 |
      | HandledByGroupID          |                        325 |
      | HandledByUserID           |                        521 |
      | HandledBySupervisorUserID |                        547 |
      | HandledByManagerUserID    |                        532 |
      | HandledByDirectorUserID   |                        531 |
    And response body should have key 'ClientProspectID' with the stored key value 'ClientProspectID'
    And response body should match the schema from the file "prospect"

  Scenario: 004 Should be able to Search Prospect record
    Given user has a service named '/api/v1/client/prospect/search'
    And user has a query params from the file 'prospect' with selected keys 'BusinessUnitID,ReturnFormat'
    And user has query parameters:
      """
        {
        "SearchString":"UpdatedProspect",
        "SearchOn":"0",
        "SearchType":"0",
        "SearchStatus":"2",
        "IsImported":"false",
        "HandlerGroup":"325",
        "HandlerUser":"521"
        }
      
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have index key with the value:
      | index | key                       | value                      |
      |     1 | InterfaceReference        | PlaywrightAutomationUpdate |
      |     1 | LastName                  | UpdatedProspect            |
      |     1 | FirstName                 | API                        |
      |     1 | Email                     | krunallute@riskscreen.com  |
      |     1 | AllowManageProspect       | false                      |
      |     1 | AllowKYBLookup            | false                      |
      |     1 | UseDefaultEmail           | true                       |
      |     1 | Imported                  | false                      |
      |     1 | MobilePhone               |                 1234567890 |
      |     1 | BusinessUnitID            |                         10 |
      |     1 | OnboardingTypeID          |                        695 |
      |     1 | ProspectStatus            |                          1 |
      |     1 | HandledByGroupID          |                        325 |
      |     1 | HandledByUserID           |                        521 |
      |     1 | HandledBySupervisorUserID |                        547 |
      |     1 | HandledByManagerUserID    |                        532 |
      |     1 | HandledByDirectorUserID   |                        531 |
    And response body should have index key with the stored key value:
      | index | key              | storedKey        |
      |     1 | ClientProspectID | ClientProspectID |
    And response body should match the schema from the file "searchProspect"

  Scenario: 005 should be able to delete Prospect record
    Given user has a service named '/api/v1/client/prospect/delete'
    And user has a payload from the file 'prospect' with selected keys 'BusinessUnitID,ReturnFormat,ActionUserID'
    And user add payload 'ClientProspectID' with the stored key value 'ClientProspectID'
    When user sends a 'DELETE' request
    Then response status should be 200
    And response body should have key 'ClientProspectID' with the stored key value 'ClientProspectID'
    And response body should have key with the value:
      | key                       | value                      |
      | InterfaceReference        | PlaywrightAutomationUpdate |
      | LastName                  | UpdatedProspect            |
      | FirstName                 | API                        |
      | Email                     | krunallute@riskscreen.com  |
      | AllowManageProspect       | false                      |
      | AllowKYBLookup            | false                      |
      | UseDefaultEmail           | true                       |
      | Imported                  | false                      |
      | MobilePhone               |                 1234567890 |
      | BusinessUnitID            |                         10 |
      | OnboardingTypeID          |                        695 |
      | ProspectStatus            |                          1 |
      | HandledByGroupID          |                        325 |
      | HandledByUserID           |                        521 |
      | HandledBySupervisorUserID |                        547 |
      | HandledByManagerUserID    |                        532 |
      | HandledByDirectorUserID   |                        531 |

  Scenario: 006 user should fetch all prospect record when SearchString is pass as '%' for prospect/searchwithpagination. #ENG-T2597
    Given user has a service named '/api/v1/client/prospect/searchpaged'
    And user has a query params from the file 'prospect' with selected keys 'BusinessUnitID,ReturnFormat'
    And user has query parameters:
      """
        {
        "SearchString":"%",
        "SearchOn":"0",
        "SearchType":"0",
        "SearchStatus":"2",
        "IsImported":"false",
        "HandlerGroup":"325",
        "HandlerUser":"521",
        "CurrentPage":"1",
        "PageSize":"5"
        }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "prospectSearchPaged"

  Scenario: 007 User should fetch prospect/searchwithpagination records as per 'Current Page' and PageSize' parameter passed.
  Given user has a service named '/api/v1/client/prospect/searchpaged'
    And user has a query params from the file 'prospect' with selected keys 'BusinessUnitID,ReturnFormat'
    And user has query parameters:
      """
        {
        "SearchString":"%",
        "SearchOn":"0",
        "SearchType":"0",
        "SearchStatus":"2",
        "IsImported":"false",
        "HandlerGroup":"325",
        "HandlerUser":"521",
        "CurrentPage":"1",
        "PageSize":"50"
        }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "prospectSearchPaged"
    Then response should have 50 records at path 'Data'