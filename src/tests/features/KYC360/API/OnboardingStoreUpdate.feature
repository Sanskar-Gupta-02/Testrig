@Regression @OnboardingStoreUpdate
Feature: Onboarding Store API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add Onboarding
    Given user has a service named "/api/v1/client/prospect/add"
    And user has a payload from the file 'prospect'
    And user store the unique value for key:
      | key                |
      | interfaceReference |
      | firstName          |
      | lastName           |
    And user add payload key with stored key value:
      | payloadKey         | storedkey          |
      | InterfaceReference | interfaceReference |
      | FirstName          | firstName          |
      | LastName           | lastName           |
    When user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientProspectID" with keyName:"prospectID"
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"

  Scenario: 002 Should be able to add and update Onboarding Store Text
    Given user has a service named "/api/v1/client/onboardingstore/add"
    When user has a payload from the file 'onboardingStore'
    And user has payloads:
      """
      {
          "OnboardingPropertyID":"121756",
          "StoreID":"1",
          "Text":"Riskscreen"
      }
      """
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user has a service named "/api/v1/client/onboardingstore/update"
    And user has a payload from the file 'onboardingStore'
    And user has payloads:
      """
      {
          "OnboardingPropertyID":"121756",
          "StoreID":"1",
          "Text":"KYC360"
      }
      """
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value  |
      | BusinessUnitID            |     10 |
      | OnboardingPropertyGroupID |  59257 |
      | OnboardingPropertyID      | 121756 |
      | StoreID                   |      1 |
      | Text                      | KYC360 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboardingStore"

  Scenario: 003 Should be able to get onboarding store text details
    Given user has a service named "/api/v1/client/onboardingstore/get"
    And user has a query params from the file 'onboardingStore' with selected keys 'BusinessUnitID,OnboardingPropertyGroupID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    And user has query parameters:
      """
        {
        "OnboardingPropertyID":"121756",
        "StoreID":"1"
        }
      
      """
    When user sends a 'Get' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboardingStore"
    And response body should have key with the value:
      | key                       | value  |
      | BusinessUnitID            |     10 |
      | OnboardingPropertyGroupID |  59257 |
      | OnboardingPropertyID      | 121756 |
      | StoreID                   |      1 |
      | Text                      | KYC360 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"

  Scenario: 004 Should be able to add and update Onboarding Store Integer
    Given user has a service named "/api/v1/client/onboardingstore/add"
    When user has a payload from the file 'onboardingStore'
    And user has payloads:
      """
      {
          "OnboardingPropertyID":"121757",
          "StoreID":"2",
          "Integer":"25"
      }
      """
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user has a service named "/api/v1/client/onboardingstore/update"
    And user has a payload from the file 'onboardingStore'
    And user has payloads:
      """
      {
          "OnboardingPropertyID":"121757",
          "StoreID":"2",
          "Integer":"45"
      }
      """
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value  |
      | BusinessUnitID            |     10 |
      | OnboardingPropertyGroupID |  59257 |
      | OnboardingPropertyID      | 121757 |
      | StoreID                   |      2 |
      | Integer                   |     45 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboardingStore"

  Scenario: 005 Should be able to get onboarding store integer details
    Given user has a service named "/api/v1/client/onboardingstore/get"
    And user has a query params from the file 'onboardingStore' with selected keys 'BusinessUnitID,OnboardingPropertyGroupID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    And user has query parameters:
      """
        {
        "OnboardingPropertyID":"121757",
        "StoreID":"2"
        }
      
      """
    When user sends a 'Get' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboardingStore"
    And response body should have key with the value:
      | key                       | value  |
      | BusinessUnitID            |     10 |
      | OnboardingPropertyGroupID |  59257 |
      | OnboardingPropertyID      | 121757 |
      | StoreID                   |      2 |
      | Integer                   |     45 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"

  Scenario: 006 Should be able to add and update Onboarding Store Decimal
    Given user has a service named "/api/v1/client/onboardingstore/add"
    When user has a payload from the file 'onboardingStore'
    And user has payloads:
      """
      {
          "OnboardingPropertyID":"121758",
          "StoreID":"3",
          "Decimal":"5.6"
      }
      """
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user has a service named "/api/v1/client/onboardingstore/update"
    And user has a payload from the file 'onboardingStore'
    And user has payloads:
      """
      {
          "OnboardingPropertyID":"121758",
          "StoreID":"3",
          "Decimal":"3.2"
      }
      """
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value  |
      | BusinessUnitID            |     10 |
      | OnboardingPropertyGroupID |  59257 |
      | OnboardingPropertyID      | 121758 |
      | StoreID                   |      3 |
      | Decimal                   |    3.2 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboardingStore"

  Scenario: 007 Should be able to get onboarding store decimal details
    Given user has a service named "/api/v1/client/onboardingstore/get"
    And user has a query params from the file 'onboardingStore' with selected keys 'BusinessUnitID,OnboardingPropertyGroupID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    And user has query parameters:
      """
        {
        "OnboardingPropertyID":"121758",
        "StoreID":"3"
        }
      
      """
    When user sends a 'Get' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboardingStore"
    And response body should have key with the value:
      | key                       | value  |
      | BusinessUnitID            |     10 |
      | OnboardingPropertyGroupID |  59257 |
      | OnboardingPropertyID      | 121758 |
      | StoreID                   |      3 |
      | Decimal                   |    3.2 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"

  Scenario: 008 Should be able to add and update Onboarding Store Date
    Given user has a service named "/api/v1/client/onboardingstore/add"
    When user has a payload from the file 'onboardingStore'
    And user has payloads:
      """
      {
          "OnboardingPropertyID":"121759",
          "StoreID":"4",
          "Date":"<currentDateStamp>"
      }
      """
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user has a service named "/api/v1/client/onboardingstore/update"
    And user has a payload from the file 'onboardingStore'
    And user has payloads:
      """
      {
          "OnboardingPropertyID":"121759",
          "StoreID":"4",
          "Date":"<currentDateStamp>"
      }
      """
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value                       |
      | BusinessUnitID            |                          10 |
      | OnboardingPropertyGroupID |                       59257 |
      | OnboardingPropertyID      |                      121759 |
      | StoreID                   |                           4 |
      | Date                      | <currentDateStamp> 00:00:00 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboardingStore"

  Scenario: 009 Should be able to get onboarding store date details
    Given user has a service named "/api/v1/client/onboardingstore/get"
    And user has a query params from the file 'onboardingStore' with selected keys 'BusinessUnitID,OnboardingPropertyGroupID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    And user has query parameters:
      """
        {
        "OnboardingPropertyID":"121759",
        "StoreID":"4"
        }
      
      """
    When user sends a 'Get' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboardingStore"
    And response body should have key with the value:
      | key                       | value                       |
      | BusinessUnitID            |                          10 |
      | OnboardingPropertyGroupID |                       59257 |
      | OnboardingPropertyID      |                      121759 |
      | StoreID                   |                           4 |
      | Date                      | <currentDateStamp> 00:00:00 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"

  Scenario: 010 Should be able to add and update Onboarding Store List
    Given user has a service named "/api/v1/client/onboardingstore/add"
    When user has a payload from the file 'onboardingStore'
    And user has payloads:
      """
      {
          "OnboardingPropertyID":"121760",
          "StoreID":5,
          "ListGroupID": "33333",
          "ListDataID": "39879"
      }
      """
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user has a service named "/api/v1/client/onboardingstore/update"
    And user has a payload from the file 'onboardingStore'
    And user has payloads:
      """
      {
          "OnboardingPropertyID":"121760",
          "StoreID":5,
          "ListGroupID": "33333",
          "ListDataID": "39879"
      }
      """
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value  |
      | BusinessUnitID            |     10 |
      | OnboardingPropertyGroupID |  59257 |
      | OnboardingPropertyID      | 121760 |
      | StoreID                   |      5 |
      | ListDataID                |  39879 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboardingStore"

  Scenario: 011 Should be able to get onboarding store list details
    Given user has a service named "/api/v1/client/onboardingstore/get"
    And user has a query params from the file 'onboardingStore' with selected keys 'BusinessUnitID,OnboardingPropertyGroupID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    And user has query parameters:
      """
        {
        "OnboardingPropertyID":"121760",
        "StoreID":"5"
        }
      
      """
    When user sends a 'Get' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboardingStore"
    And response body should have key with the value:
      | key                       | value  |
      | BusinessUnitID            |     10 |
      | OnboardingPropertyGroupID |  59257 |
      | OnboardingPropertyID      | 121760 |
      | StoreID                   |      5 |
      | ListDataID                |  39879 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"

  Scenario: 012 Should be able to get all onboarding store details
    Given user has a service named "/api/v1/client/onboardingstore/getall"
    And user has a query params from the file 'onboardingStore' with selected keys 'BusinessUnitID,OnboardingPropertyGroupID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    When user sends a 'Get' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboardingStoreGetAll"
    And response body should have index key with the value:
      | index | key                       | value                       |
      |     1 | BusinessUnitID            |                          10 |
      |     1 | OnboardingPropertyGroupID |                       59257 |
      |     1 | OnboardingPropertyID      |                      121756 |
      |     1 | StoreID                   |                           1 |
      |     1 | Text                      | KYC360                      |
      |     2 | BusinessUnitID            |                          10 |
      |     2 | OnboardingPropertyGroupID |                       59257 |
      |     2 | OnboardingPropertyID      |                      121757 |
      |     2 | StoreID                   |                           2 |
      |     2 | Integer                   |                          45 |
      |     3 | BusinessUnitID            |                          10 |
      |     3 | OnboardingPropertyGroupID |                       59257 |
      |     3 | OnboardingPropertyID      |                      121758 |
      |     3 | StoreID                   |                           3 |
      |     3 | Decimal                   |                         3.2 |
      |     4 | BusinessUnitID            |                          10 |
      |     4 | OnboardingPropertyGroupID |                       59257 |
      |     4 | OnboardingPropertyID      |                      121759 |
      |     4 | StoreID                   |                           4 |
      |     4 | Date                      | <currentDateStamp> 00:00:00 |
      |     5 | BusinessUnitID            |                          10 |
      |     5 | OnboardingPropertyGroupID |                       59257 |
      |     5 | OnboardingPropertyID      |                      121760 |
      |     5 | StoreID                   |                           5 |
      |     5 | ListDataID                |                       39879 |
    And response body should have index key with the stored key value:
      | index | key                | storedKey    |
      |     1 | ClientProspectID   | prospectID   |
      |     1 | ClientOnboardingID | onboardingID |
      |     2 | ClientProspectID   | prospectID   |
      |     2 | ClientOnboardingID | onboardingID |
      |     3 | ClientProspectID   | prospectID   |
      |     3 | ClientOnboardingID | onboardingID |
      |     4 | ClientProspectID   | prospectID   |
      |     4 | ClientOnboardingID | onboardingID |
      |     5 | ClientProspectID   | prospectID   |
      |     5 | ClientOnboardingID | onboardingID |

  Scenario: 013 Should be able to delete an onboarding store text
    Given user has a service named "/api/v1/client/onboardingstore/delete"
    And user has a query params from the file 'onboardingStore' with selected keys 'BusinessUnitID,OnboardingPropertyGroupID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    And user has query parameters:
      """
        {
        "OnboardingPropertyID":"121756",
        "StoreID":"1"
        }
      
      """
    When user sends a 'Delete' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value  |
      | BusinessUnitID            |     10 |
      | OnboardingPropertyGroupID |  59257 |
      | OnboardingPropertyID      | 121756 |
      | StoreID                   |      1 |
      | Text                      | KYC360 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboardingStore"

  Scenario: 014 Should be able to delete an onboarding store integer
    Given user has a service named "/api/v1/client/onboardingstore/delete"
    And user has a query params from the file 'onboardingStore' with selected keys 'BusinessUnitID,OnboardingPropertyGroupID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    And user has query parameters:
      """
        {
        "OnboardingPropertyID":"121757",
        "StoreID":"2"
        }
      
      """
    When user sends a 'Delete' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value  |
      | BusinessUnitID            |     10 |
      | OnboardingPropertyGroupID |  59257 |
      | OnboardingPropertyID      | 121757 |
      | StoreID                   |      2 |
      | Integer                   |     45 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboardingStore"

  Scenario: 015 Should be able to delete an onboarding store decimal
    Given user has a service named "/api/v1/client/onboardingstore/delete"
    And user has a query params from the file 'onboardingStore' with selected keys 'BusinessUnitID,OnboardingPropertyGroupID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    And user has query parameters:
      """
        {
        "OnboardingPropertyID":"121758",
        "StoreID":"3"
        }
      
      """
    When user sends a 'Delete' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value  |
      | BusinessUnitID            |     10 |
      | OnboardingPropertyGroupID |  59257 |
      | OnboardingPropertyID      | 121758 |
      | StoreID                   |      3 |
      | Decimal                   |    3.2 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboardingStore"

  Scenario: 016 Should be able to delete an onboarding store date
    Given user has a service named "/api/v1/client/onboardingstore/delete"
    And user has a query params from the file 'onboardingStore' with selected keys 'BusinessUnitID,OnboardingPropertyGroupID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    And user has query parameters:
      """
        {
        "OnboardingPropertyID":"121759",
        "StoreID":"4"
        }
      
      """
    When user sends a 'Delete' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value                       |
      | BusinessUnitID            |                          10 |
      | OnboardingPropertyGroupID |                       59257 |
      | OnboardingPropertyID      |                      121759 |
      | StoreID                   |                           4 |
      | Date                      | <currentDateStamp> 00:00:00 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboardingStore"

  Scenario: 017 Should be able to delete an onboarding store list
    Given user has a service named "/api/v1/client/onboardingstore/delete"
    And user has a query params from the file 'onboardingStore' with selected keys 'BusinessUnitID,OnboardingPropertyGroupID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    And user has query parameters:
      """
        {
        "OnboardingPropertyID":"121760",
        "StoreID":"5"
        }
      
      """
    When user sends a 'Delete' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value  |
      | BusinessUnitID            |     10 |
      | OnboardingPropertyGroupID |  59257 |
      | OnboardingPropertyID      | 121760 |
      | StoreID                   |      5 |
      | ListDataID                |  39879 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboardingStore"

  Scenario: 018 Should be able to add onboarding store using bulk add by ref
    Given user has a service named "/api/v1/client/onboardingstore/bulkaddbyref"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "onboardingStoreBulkAddByRef" with updates:
      | key                                    | value               |
      | ClientProspectID                       | stored:prospectID   |
      | ClientOnboardingID                     | stored:onboardingID |
      | DataCollectionData.3.PropertyDataValue | <currentDateStamp>  |
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value |
      | BusinessUnitID |    10 |
    And response body should have key "ClientProspectID" with the stored key value "prospectID"
    And response body should have key "ClientOnboardingID" with the stored key value "onboardingID"
    And response body should match the schema from the file "onboardingStoreBulkAddByRef"

  Scenario: 019 Should be able to delete an onboarding
    Given user has a service named "/api/v1/client/onboarding/delete"
    And user has a query params from the file 'onboarding' with selected keys 'OnboardingTypeID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectID' with the stored key value 'prospectID'
    And user add query parameter 'ClientOnboardingID' with the stored key value 'onboardingID'
    When user sends a 'Delete' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboarding"

  Scenario: 020 Should be able to delete prospect
    Given user has a service named "/api/v1/client/prospect/delete"
    And user has a payload from the file "prospect" with selected keys "OnboardingTypeID,ActionUserID,ReturnFormat"
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    When user sends a 'Delete' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "prospect"
