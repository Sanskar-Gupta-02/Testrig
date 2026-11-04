@Regression @StaticAVMCriteria
Feature: Static AVM Criteria API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add Static AVM Criteria
    Given user has a service named "/api/v1/static/adversemedia/criteria/add"
    And user has a payload from the file 'staticAVMCriteria'
    And user store the unique value for key:
      | key  |
      | name |
    And user add payload key with stored key value:
      | payloadKey | storedkey |
      | Name       | name      |
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                   | value                    |
      | Description           | AVM Criteria Desc        |
      | TermGroupName         | Default Group [CID: 116] |
      | SearchEngineGroupName | Default Group [CID: 116] |
      | DateRangeID           |                        0 |
      | DateRangeName         | All                      |
      | CountryID             |                        0 |
      | FrequencyInDays       |                        1 |
      | SearchTermOption      |                        1 |
      | SafeSearch            | false                    |
      | SearchTermProximity   |                        0 |
    And response body in ascending order should have index key with the value:
      | index | key                            | value |
      |     1 | SearchEngineOptions.IsSelected | true  |
      |     1 | SearchEngineOptions.PageSize   |     5 |
      |     1 | SearchEngineOptions.SearchType |     1 |
      |     2 | SearchEngineOptions.IsSelected | true  |
      |     2 | SearchEngineOptions.PageSize   |     5 |
      |     2 | SearchEngineOptions.SearchType |     2 |
      |     3 | SearchEngineOptions.IsSelected | true  |
      |     3 | SearchEngineOptions.PageSize   |     5 |
      |     3 | SearchEngineOptions.SearchType |     3 |
    And response body should match the schema from the file "staticAVMCriteria"
    When user store the response body keyData:"CriteriaID" with keyName:"criteriaID"
    And user store the response body keyData:"TermGroupID" with keyName:"termGroupID"
    And user store the response body keyData:"SearchEngineGroupID" with keyName:"searchEngineGroupID"
    And user store the response body keyData:"Name" with keyName:"name"

  Scenario: 002 Should be able to get Static AVM Criteria #ENG-T8193
    Given user has a service named "/api/v1/static/adversemedia/criteria/get"
    And user has a query params from the file 'staticAVMCriteria' with selected keys 'ReturnFormat'
    And user add query parameter "CriteriaID" with the stored key value "criteriaID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                   | value                    |
      | Description           | AVM Criteria Desc        |
      | TermGroupName         | Default Group [CID: 116] |
      | SearchEngineGroupName | Default Group [CID: 116] |
      | DateRangeID           |                        0 |
      | DateRangeName         | All                      |
      | CountryID             |                        0 |
      | FrequencyInDays       |                        1 |
      | SearchTermOption      |                        1 |
      | SafeSearch            | false                    |
      | SearchTermProximity   |                        0 |
    And response body in ascending order should have index key with the value:
      | index | key                            | value |
      |     1 | SearchEngineOptions.IsSelected | true  |
      |     1 | SearchEngineOptions.PageSize   |     5 |
      |     1 | SearchEngineOptions.SearchType |     1 |
      |     2 | SearchEngineOptions.IsSelected | true  |
      |     2 | SearchEngineOptions.PageSize   |     5 |
      |     2 | SearchEngineOptions.SearchType |     2 |
      |     3 | SearchEngineOptions.IsSelected | true  |
      |     3 | SearchEngineOptions.PageSize   |     5 |
      |     3 | SearchEngineOptions.SearchType |     3 |
    And response body should match the schema from the file "staticAVMCriteria"
    And response body should have key "CriteriaID" with the stored key value "criteriaID"
    And response body should have key "TermGroupID" with the stored key value "termGroupID"
    And response body should have key "SearchEngineGroupID" with the stored key value "searchEngineGroupID"
    And response body should have key "Name" with the stored key value "name"

  Scenario: 003 Should be able to Update Static AVM Criteria
    Given user has a service named "/api/v1/static/adversemedia/criteria/update"
    And user has a payload from the file 'staticAVMCriteria'
    And user add payload "CriteriaID" with the stored key value "criteriaID"
    And user add payload "Name" with the stored key value "name"
    And user has payloads:
      """
      {
        "Description": "AVM Criteria Desc -Update",
        "DateRangeID": "1",
        "CountryID":"1",
        "FrequencyInDays": "5",
        "SearchTermOption": "5",
        "SafeSearch": "true",
        "SearchTermProximity": "10",
        "SearchEngineOptions[0].SearchType": "Google",
        "SearchEngineOptions[0].IsSelected": "true",
        "SearchEngineOptions[0].PageSize": "10",
        "SearchEngineOptions[1].SearchType": "BingWeb",
        "SearchEngineOptions[1].IsSelected": "true",
        "SearchEngineOptions[1].PageSize": "15",
        "SearchEngineOptions[2].SearchType": "BingNews",
        "SearchEngineOptions[2].IsSelected": "true",
        "SearchEngineOptions[2].PageSize": "20"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                   | value                     |
      | Description           | AVM Criteria Desc -Update |
      | TermGroupName         | Default Group [CID: 116]  |
      | SearchEngineGroupName | Default Group [CID: 116]  |
      | DateRangeName         | Last 24 Hours             |
      | DateRangeID           |                         1 |
      | FrequencyInDays       |                         5 |
      | SearchTermOption      |                         5 |
      | SafeSearch            | true                      |
      | SearchTermProximity   |                        10 |
    And response body in ascending order should have index key with the value:
      | index | key                            | value |
      |     1 | SearchEngineOptions.IsSelected | true  |
      |     1 | SearchEngineOptions.PageSize   |    10 |
      |     1 | SearchEngineOptions.SearchType |     1 |
      |     2 | SearchEngineOptions.IsSelected | true  |
      |     2 | SearchEngineOptions.PageSize   |    15 |
      |     2 | SearchEngineOptions.SearchType |     2 |
      |     3 | SearchEngineOptions.IsSelected | true  |
      |     3 | SearchEngineOptions.PageSize   |    20 |
      |     3 | SearchEngineOptions.SearchType |     3 |
    And response body should match the schema from the file "staticAVMCriteria"
    And response body should have key "CriteriaID" with the stored key value "criteriaID"
    And response body should have key "TermGroupID" with the stored key value "termGroupID"
    And response body should have key "SearchEngineGroupID" with the stored key value "searchEngineGroupID"
    And response body should have key "Name" with the stored key value "name"

  Scenario: 004 Should be able to getall Static AVM Criteria
    Given user has a service named "/api/v1/static/adversemedia/criteria/getall"
    And user has a query params from the file "staticAVMCriteria" with selected keys "ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticAVMCriteriaGetAll"

  Scenario: 005 Should be able to add Linked Term Set
    Given user has a service named "/api/v1/static/adversemedia/criteria/addlinkedtermset"
    And user has a payload from the file 'staticAVMCriteriaTermSet'
    And user add payload "CriteriaID" with the stored key value "criteriaID"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key          | value                         |
      | TermsSetName | Static AVM Criteria Term Set  |
      | Terms        | Fraud,Money Laundaring,Terror |
    And response body should match the schema from the file "staticAVMCriteriaTermSet"
    When user store the response body keyData:"TermsSetID" with keyName:"termsSetID"
    And user store the response body keyData:"TermsSetName" with keyName:"termsSetName"
    And user store the response body keyData:"Terms" with keyName:"terms"

  Scenario: 006 Should be able to Update an existing Static AVM Criteria Linked Term Set
    Given user has a service named "/api/v1/static/adversemedia/criteria/updatelinkedtermset"
    And user has a payload from the file "staticAVMCriteriaTermSet" with selected keys "ActionUserID,ReturnFormat"
    And user add payload "CriteriaID" with the stored key value "criteriaID"
    And user add payload "TermsSetID" with the stored key value "termsSetID"
    And user has payloads:
      """
      {
        "TermsSetName": "TermsSetName -Update",
        "Terms": "Terms -Update"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key          | value                |
      | TermsSetName | TermsSetName -Update |
      | Terms        | Terms -Update        |
    And response body should match the schema from the file "staticAVMCriteriaTermSet"
    And response body should have key "TermsSetID" with the stored key value "termsSetID"

  Scenario: 007 Should be able to get all Linked Term Sets
    Given user has a service named "/api/v1/static/adversemedia/criteria/getlinkedtermsets"
    And user has a query params from the file 'staticAVMCriteriaTermSet' with selected keys 'ReturnFormat'
    And user add query parameter "CriteriaID" with the stored key value "criteriaID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticAVMCriteriaTermSetGetAll"

  Scenario: 008 Should be able to get all Linked Search Engine Configurations
    Given user has a service named "/api/v1/static/adversemedia/criteria/getlinkedseconfigs"
    And user has a query params from the file 'staticAVMCriteriaTermSEConfi' with selected keys 'ReturnFormat'
    And user add query parameter "CriteriaID" with the stored key value "criteriaID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticAVMCriteriaTermSEConfi"

  Scenario: 009 Should be able to Delete Linked Term Set
    Given user has a service named "/api/v1/static/adversemedia/criteria/deletelinkedtermset"
    And user has a query params from the file 'staticAVMCriteria' with selected keys 'ActionUserID,ReturnFormat'
    And user add query parameter "CriteriaID" with the stored key value "criteriaID"
    And user add query parameter "TermsSetID" with the stored key value "termsSetID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key          | value                |
      | TermsSetName | TermsSetName -Update |
      | Terms        | Terms -Update        |
    And response body should have key "TermsSetID" with the stored key value "termsSetID"
    And response body should match the schema from the file "staticAVMCriteriaTermSet"

  Scenario: 010 Should be able to delete Static AVM Criteria
    Given user has a service named "/api/v1/static/adversemedia/criteria/delete"
    And user has a query params from the file 'staticAVMCriteria' with selected keys 'ActionUserID,ReturnFormat'
    And user add query parameter "CriteriaID" with the stored key value "criteriaID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                   | value                     |
      | Description           | AVM Criteria Desc -Update |
      | TermGroupName         | Default Group [CID: 116]  |
      | SearchEngineGroupName | Default Group [CID: 116]  |
      | DateRangeName         | Last 24 Hours             |
      | DateRangeID           |                         1 |
      | FrequencyInDays       |                         5 |
      | SearchTermOption      |                         5 |
      | SafeSearch            | true                      |
      | SearchTermProximity   |                        10 |
    And response body in ascending order should have index key with the value:
      | index | key                            | value |
      |     1 | SearchEngineOptions.IsSelected | true  |
      |     1 | SearchEngineOptions.PageSize   |    10 |
      |     1 | SearchEngineOptions.SearchType |     1 |
      |     2 | SearchEngineOptions.IsSelected | true  |
      |     2 | SearchEngineOptions.PageSize   |    15 |
      |     2 | SearchEngineOptions.SearchType |     2 |
      |     3 | SearchEngineOptions.IsSelected | true  |
      |     3 | SearchEngineOptions.PageSize   |    20 |
      |     3 | SearchEngineOptions.SearchType |     3 |
    And response body should match the schema from the file "staticAVMCriteria"
    And response body should have key "CriteriaID" with the stored key value "criteriaID"
    And response body should have key "TermGroupID" with the stored key value "termGroupID"
    And response body should have key "SearchEngineGroupID" with the stored key value "searchEngineGroupID"
    And response body should have key "Name" with the stored key value "name"

  Scenario: 010 Serach Term Proximity should have min/max values while adding criteria #ENG-T8192
    Given user has a service named "/api/v1/static/adversemedia/criteria/add"
    And user has a payload from the file 'staticAVMCriteria'
    And user has payloads:
      """
      {
        "Name":"AuomationAPITest2",
        "SearchTermProximity": "-1"
      }
      """
    When user sends a 'POST' request
    Then response status should be 406
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key     | value                   |
      | Message | The request is invalid. |
    When user has payloads:
      """
      {
        "Name":"AuomationAPITest2",
        "SearchTermProximity": "251"
      }
      """
    And user sends a 'POST' request
    Then response status should be 406
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key     | value                   |
      | Message | The request is invalid. |

  Scenario: 011 Serach Term Proximity should have min/max values while updating criteria #ENG-T8194
    Given user has a service named "/api/v1/static/adversemedia/criteria/update"
    And user has a payload from the file 'staticAVMCriteria'
    And user has payloads:
      """
      {
        "CriteriaID":"1230",
        "Name":"AuomationAPITest",
        "SearchTermProximity": "-1"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 406
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key     | value                   |
      | Message | The request is invalid. |
    When user has payloads:
      """
      {
        "SearchTermProximity": "251"
      }
      """
    And user sends a 'PUT' request
    Then response status should be 406
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key     | value                   |
      | Message | The request is invalid. |
