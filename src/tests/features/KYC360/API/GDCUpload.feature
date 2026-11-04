@Regression @GDCUpload
Feature: GDC Upload get summary and details

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to get all onboarding GDC upload summary details
    Given user has a service named "/api/v1/client/gdcupload/StagingGetSummary"
    And user has a query params from the file 'gdcUpload' with selected keys 'BusinessUnitID,ReturnFormat'
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
    And response body should match the schema from the file "gdcUpload"
    And response body should have index key with the value:
      | index | key            | value                                |
      |     1 | BusinessUnitID |                                   26 |
      |     1 | Reference      | 696edb21-6364-48c2-a69f-9322b1204fad |
      |     1 | FileName       | Test file JPM and GDC 3008Reg.csv    |
      |     1 | RequestedOn    |                  12/05/2025 09:24:41 |
      |     1 | Status         |                                    2 |
      |     1 | PendingRows    |                                    0 |
      |     1 | SuccessfulRows |                                   13 |
      |     1 | FailedRows     |                                    0 |
      |     1 | Type           |                                    0 |

  Scenario: 002 Should be able to get onboarding GDC upload summary details on name
    Given user has a service named "/api/v1/client/gdcupload/StagingGetSummary"
    And user has a query params from the file 'gdcUpload' with selected keys 'BusinessUnitID,ReturnFormat'
    And user has query parameters:
      """
        {
            "SearchTerm":"Test file JPM and GDC 3008Reg.csv",
            "SearchOn":"1"
        }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "gdcUpload"
    And response body should have index key with the value:
      | index | key            | value                                |
      |     1 | BusinessUnitID |                                   26 |
      |     1 | Reference      | 696edb21-6364-48c2-a69f-9322b1204fad |
      |     1 | FileName       | Test file JPM and GDC 3008Reg.csv    |
      |     1 | RequestedOn    |                  12/05/2025 09:24:41 |
      |     1 | Status         |                                    2 |
      |     1 | PendingRows    |                                    0 |
      |     1 | SuccessfulRows |                                   13 |
      |     1 | FailedRows     |                                    0 |
      |     1 | Type           |                                    0 |

  Scenario: 003 Should be able to get onboarding gdc upload summary details on reference
    Given user has a service named "/api/v1/client/gdcupload/StagingGetSummary"
    And user has a query params from the file 'gdcUpload' with selected keys 'BusinessUnitID,ReturnFormat'
    And user has query parameters:
      """
        {
            "SearchTerm":"696edb21-6364-48c2-a69f-9322b1204fad",
            "SearchOn":"0"
        }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "gdcUpload"
    And response body should have index key with the value:
      | index | key            | value                                |
      |     1 | BusinessUnitID |                                   26 |
      |     1 | Reference      | 696edb21-6364-48c2-a69f-9322b1204fad |
      |     1 | FileName       | Test file JPM and GDC 3008Reg.csv    |
      |     1 | RequestedOn    |                  12/05/2025 09:24:41 |
      |     1 | Status         |                                    2 |
      |     1 | PendingRows    |                                    0 |
      |     1 | SuccessfulRows |                                   13 |
      |     1 | FailedRows     |                                    0 |
      |     1 | Type           |                                    0 |

  Scenario: 004 Should be able to get onboarding gdc upload details on reference
    Given user has a service named "/api/v1/client/gdcupload/getdetails"
    And user has a query params from the file 'gdcUpload' with selected keys 'BusinessUnitID,Status,ReturnFormat'
    And user has query parameters:
      """
        {
            "SearchTerm":"696edb21-6364-48c2-a69f-9322b1204fad",
            "SearchOn":"0"
        }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "gdcUploadGetDetails"
    And response body should match the expected data from the file "gdcUploadGetDetails"

  Scenario: 005 Should be able to get onboarding gdc upload details on name
    Given user has a service named "/api/v1/client/gdcupload/getdetails"
    And user has a query params from the file 'gdcUpload' with selected keys 'BusinessUnitID,Status,ReturnFormat'
    And user has query parameters:
      """
        {
            "SearchTerm":"Test file JPM and GDC 3008Reg.csv",
            "SearchOn":"1"
        }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "gdcUploadGetDetails"
    And response body should match the expected data from the file "gdcUploadGetDetails"

  Scenario: 006 Should be able to get onboarding gdc Record Count Summary on name
    Given user has a service named "/api/v1/client/gdcupload/GetRecordCountSummary"
    And user has a query params from the file 'gdcUpload' with selected keys 'BusinessUnitID,ReturnFormat'
    And user has query parameters:
      """
        {
            "SearchTerm":"Test file JPM and GDC 3008Reg.csv",
            "SearchOn":"1"
        }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "gdcUploadRecordCountSummary"
    And response body should match the expected data from the file "gdcUploadRecordCountSummary"

  Scenario: 007 Should be able to get onboarding gdc Record Count Summary on reference
    Given user has a service named "/api/v1/client/gdcupload/GetRecordCountSummary"
    And user has a query params from the file 'gdcUpload' with selected keys 'BusinessUnitID,ReturnFormat'
    And user has query parameters:
      """
        {
            "SearchTerm":"696edb21-6364-48c2-a69f-9322b1204fad",
            "SearchOn":"0"
        }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "gdcUploadRecordCountSummary"
    And response body should match the expected data from the file "gdcUploadRecordCountSummary"

  Scenario: 008 Should be able to get onboarding gdc export on name
    Given user has a service named "/api/v1/client/gdcupload/Export"
    And user has a query params from the file 'gdcUpload' with selected keys 'BusinessUnitID,ReturnFormat'
    And user has query parameters:
      """
        {
            "SearchTerm":"Test file JPM and GDC 3008Reg.csv",
            "SearchOn":"1"
        }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "gdcUploadExport"

  Scenario: 009 Should be able to get onboarding gdc export on reference
    Given user has a service named "/api/v1/client/gdcupload/Export"
    And user has a query params from the file 'gdcUpload' with selected keys 'BusinessUnitID,ReturnFormat'
    And user has query parameters:
      """
        {
            "SearchTerm":"696edb21-6364-48c2-a69f-9322b1204fad",
            "SearchOn":"0"
        }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "gdcUploadExport"

  Scenario: 010 should be able to send emails based on OB type configurations #ENG-T3230
    Given user has a service named "/api/v1/client/gdcupload/SendEmail"
    And user has header "Content-Type":"application/json"
    And user has a query params from the file 'gdcUploadSendEmail' with selected keys 'BusinessUnitID,Reference,ActionUserID,ReturnFormat'
    And user has a raw payload from the file "gdcUploadSendEmailRawBody"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "gdcUploadSendEmail"
    And response body should have key with the value:
      | key           | value                                |
      | Reference     | 696edb21-6364-48c2-a69f-9322b1204fad |
      | FileName      | Test file JPM and GDC 3008Reg.csv    |
      | FileRows      |                                   13 |
      | LoadingStatus |                                    2 |