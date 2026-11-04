@Regression @BulkUpload
Feature: Bulk Upload get summary and details

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to get all onboarding bulk upload summary details
    Given user has a service named "/api/v1/client/bulkupload/StagingGetSummary"
    And user has a query params from the file 'bulkUpload' with selected keys 'BusinessUnitID,ReturnFormat'
    And user has query parameters:
      """
        {
            "SearchTerm":"%",
            "SearchOn":"0"
        }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "bulkUpload"
    And response body should have index key with the value:
      | index | key            | value                                   |
      |     1 | BusinessUnitID |                                      26 |
      |     1 | Reference      |    9b568c4f-e00d-4ddc-b595-97cd50884c57 |
      |     1 | FileName       | ExportTemplate_10_04_2025 19_30_40.xlsx |
      |     1 | RequestedOn    |                     10/04/2025 15:02:12 |
      |     1 | Status         |                                       2 |
      |     1 | PendingRows    |                                       0 |
      |     1 | SuccessfulRows |                                       5 |
      |     1 | FailedRows     |                                       0 |
      |     1 | Type           |                                       0 |
      |     2 | BusinessUnitID |                                      26 |
      |     2 | Reference      |    7ed4ce0e-4e6c-41eb-87fa-84b093eb93c2 |
      |     2 | FileName       | ExportTemplate_10_04_2025 11_41_39.xlsx |
      |     2 | RequestedOn    |                     10/04/2025 13:10:53 |
      |     2 | Status         |                                       2 |
      |     2 | PendingRows    |                                       0 |
      |     2 | SuccessfulRows |                                       5 |
      |     2 | FailedRows     |                                       5 |
      |     2 | Type           |                                       0 |

  Scenario: 002 Should be able to get onboarding bulk upload summary details on name
    Given user has a service named "/api/v1/client/bulkupload/StagingGetSummary"
    And user has a query params from the file 'bulkUpload' with selected keys 'BusinessUnitID,ReturnFormat'
    And user has query parameters:
      """
        {
            "SearchTerm":"ExportTemplate_10_04_2025 11_41_39.xlsx",
            "SearchOn":"1"
        }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "bulkUpload"
    And response body should have index key with the value:
      | index | key            | value                                   |
      |     1 | BusinessUnitID |                                      26 |
      |     1 | Reference      |    7ed4ce0e-4e6c-41eb-87fa-84b093eb93c2 |
      |     1 | FileName       | ExportTemplate_10_04_2025 11_41_39.xlsx |
      |     1 | RequestedOn    |                     10/04/2025 13:10:53 |
      |     1 | Status         |                                       2 |
      |     1 | PendingRows    |                                       0 |
      |     1 | SuccessfulRows |                                       5 |
      |     1 | FailedRows     |                                       5 |
      |     1 | Type           |                                       0 |
      |     2 | BusinessUnitID |                                      26 |
      |     2 | Reference      |    75d6ed23-4090-4ba6-a17a-2563ca9c4322 |
      |     2 | FileName       | ExportTemplate_10_04_2025 11_41_39.xlsx |
      |     2 | RequestedOn    |                     10/04/2025 11:54:28 |
      |     2 | Status         |                                       2 |
      |     2 | PendingRows    |                                       0 |
      |     2 | SuccessfulRows |                                      10 |
      |     2 | FailedRows     |                                       0 |
      |     2 | Type           |                                       0 |

  Scenario: 003 Should be able to get onboarding bulk upload summary details on reference
    Given user has a service named "/api/v1/client/bulkupload/StagingGetSummary"
    And user has a query params from the file 'bulkUpload' with selected keys 'BusinessUnitID,ReturnFormat'
    And user has query parameters:
      """
        {
            "SearchTerm":"75d6ed23-4090-4ba6-a17a-2563ca9c4322",
            "SearchOn":"0"
        }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "bulkUpload"
    And response body should have index key with the value:
      | index | key            | value                                   |
      |     1 | BusinessUnitID |                                      26 |
      |     1 | Reference      |    75d6ed23-4090-4ba6-a17a-2563ca9c4322 |
      |     1 | FileName       | ExportTemplate_10_04_2025 11_41_39.xlsx |
      |     1 | RequestedOn    |                     10/04/2025 11:54:28 |
      |     1 | Status         |                                       2 |
      |     1 | PendingRows    |                                       0 |
      |     1 | SuccessfulRows |                                      10 |
      |     1 | FailedRows     |                                       0 |
      |     1 | Type           |                                       0 |

  Scenario: 004 Should be able to get onboarding bulk upload details on reference
    Given user has a service named "/api/v1/client/bulkupload/StagingGetDetails"
    And user has a query params from the file 'bulkUpload' with selected keys 'BusinessUnitID,Status,ReturnFormat'
    And user has query parameters:
      """
        {
            "SearchTerm":"9b568c4f-e00d-4ddc-b595-97cd50884c57",
            "SearchOn":"0"
        }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "bulkUploadGetDetails"
    And response body should match the expected data from the file "bulkUploadGetDetails"

  Scenario: 005 Should be able to get onboarding bulk upload details on name
    Given user has a service named "/api/v1/client/bulkupload/StagingGetDetails"
    And user has a query params from the file 'bulkUpload' with selected keys 'BusinessUnitID,Status,ReturnFormat'
    And user has query parameters:
      """
        {
            "SearchTerm":"ExportTemplate_10_04_2025 19_30_40.xlsx",
            "SearchOn":"1"
        }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "bulkUploadGetDetails"
    And response body should match the expected data from the file "bulkUploadGetDetails"
