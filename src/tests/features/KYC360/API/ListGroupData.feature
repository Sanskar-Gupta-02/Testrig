@Sanity @Regression @ListGroup
Feature: Happy Path- Onboarding: List Group

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add list group
    Given user has a service named '/api/v1/static/listgroup/add'
    And user has a payload from the file 'listGroup'
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key             | value   |
      | Name            | Country |
      | Description     | Country |
      | ScreeningID     |       0 |
      | ListDisplayMode |       0 |
      | SortBy          |       1 |
    And response body should match the schema from the file "listGroup"
    When user store the response body keyData:"ListGroupID" with keyName:"listGroupID"

  Scenario: 002 Should be able to get list group
    Given user has a service named '/api/v1/static/listgroup/get'
    And user has a query params from the file 'listGroup' with selected keys 'ReturnFormat'
    And user add query parameter 'ListGroupID' with the stored key value 'listGroupID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key             | value   |
      | Name            | Country |
      | Description     | Country |
      | ScreeningID     |       0 |
      | ListDisplayMode |       0 |
      | SortBy          |       1 |
    And response body should have key 'ListGroupID' with the stored key value 'listGroupID'
    And response body should match the schema from the file "listGroup"

  Scenario: 003 should be able to update list group
    Given user has a service named '/api/v1/static/listgroup/update'
    And user has a payload from the file "listGroup"
    And user add payload 'ListGroupID' with the stored key value 'listGroupID'
    And user has payloads:
      """
      {
      "Name": "Country - Update",
      "Description": "Country - Update",
      "ListDisplayMode": "1"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key             | value            |
      | Name            | Country - Update |
      | Description     | Country - Update |
      | ScreeningID     |                0 |
      | ListDisplayMode |                1 |
      | SortBy          |                1 |
    And response body should have key 'ListGroupID' with the stored key value 'listGroupID'
    And response body should match the schema from the file "listGroup"

  Scenario: 004 Should be able to get all list group
    Given user has a service named '/api/v1/static/listgroup/getall'
    And user has a query params from the file 'listGroup' with selected keys 'ReturnFormat'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "listGroupGetAll"

  Scenario: 005 Should be able to add list data
    Given user has a service named '/api/v1/static/listdata/add'
    And user has a payload from the file 'listData'
    And user add payload 'ListGroupID' with the stored key value 'listGroupID'
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key             | value         |
      | Name            | Auto listdata |
      | Reference       | Auto          |
      | ScreeningDataID |             0 |
      | SortOrder       |             1 |
    And response body should match the schema from the file "listData"
    And response body should have key 'ListGroupID' with the stored key value 'listGroupID'
    When user store the response body keyData:"ListDataID" with keyName:"listDataID"

  Scenario: 006 Should be able to get list data
    Given user has a service named '/api/v1/static/listdata/get'
    And user has a query params from the file 'listData' with selected keys 'ReturnFormat'
    And user add query parameter 'ListGroupID' with the stored key value 'listGroupID'
    And user add query parameter 'ListDataID' with the stored key value 'listDataID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key             | value         |
      | Name            | Auto listdata |
      | Reference       | Auto          |
      | ScreeningDataID |             0 |
      | SortOrder       |             1 |
    And response body should match the schema from the file "listData"
    And response body should have key 'ListGroupID' with the stored key value 'listGroupID'
    And response body should have key 'ListDataID' with the stored key value 'listDataID'

  Scenario: 007 should be able to update list data
    Given user has a service named '/api/v1/static/listdata/update'
    And user has a payload from the file "listData"
    And user add payload 'ListGroupID' with the stored key value 'listGroupID'
    And user add payload 'ListDataID' with the stored key value 'listDataID'
    And user has payloads:
      """
      {
      "Name": "Auto listdata - Update",
      "Reference": "Auto - Update"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key             | value                  |
      | Name            | Auto listdata - Update |
      | Reference       | Auto - Update          |
      | ScreeningDataID |                      0 |
      | SortOrder       |                      1 |
    And response body should have key 'ListGroupID' with the stored key value 'listGroupID'
    And response body should have key 'ListDataID' with the stored key value 'listDataID'
    And response body should match the schema from the file "listData"

  Scenario: 008 Should be able to get all list data
    Given user has a service named '/api/v1/static/listdata/getall'
    And user has a query params from the file 'listData' with selected keys 'ReturnFormat'
    And user add query parameter 'ListGroupID' with the stored key value 'listGroupID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have index key with the value:
      | index | key             | value                  |
      |     1 | Name            | Auto listdata - Update |
      |     1 | Reference       | Auto - Update          |
      |     1 | ScreeningDataID |                      0 |
      |     1 | SortOrder       |                      1 |
    And response body should have index key with the stored key value:
      | index | key         | storedKey   |
      |     1 | ListGroupID | listGroupID |
      |     1 | ListDataID  | listDataID  |
    And response body should match the schema from the file "listDataGetAll"

  Scenario: 009 should be able to delete list data
    Given user has a service named '/api/v1/static/listdata/delete'
    And user has a query params from the file 'listData' with selected keys 'ReturnFormat,ActionUserID'
    And user add query parameter 'ListGroupID' with the stored key value 'listGroupID'
    And user add query parameter 'ListDataID' with the stored key value 'listDataID'
    When user sends a 'DELETE' request
    Then response status should be 200
    And response body should have key 'ListGroupID' with the stored key value 'listGroupID'
    And response body should have key 'ListDataID' with the stored key value 'listDataID'
    And response body should match the schema from the file "listData"
    And response body should have key with the value:
      | key             | value                  |
      | Name            | Auto listdata - Update |
      | Reference       | Auto - Update          |
      | ScreeningDataID |                      0 |
      | SortOrder       |                      1 |

  Scenario: 010 should be able to delete list group
    Given user has a service named '/api/v1/static/listgroup/delete'
    And user has a query params from the file 'listGroup' with selected keys 'ReturnFormat,ActionUserID'
    And user add query parameter 'ListGroupID' with the stored key value 'listGroupID'
    When user sends a 'DELETE' request
    Then response status should be 200
    And response body should have key 'ListGroupID' with the stored key value 'listGroupID'
    And response body should match the schema from the file "listGroup"
    And response body should have key with the value:
      | key             | value            |
      | Name            | Country - Update |
      | Description     | Country - Update |
      | ScreeningID     |                0 |
      | ListDisplayMode |                1 |
      | SortBy          |                1 |
