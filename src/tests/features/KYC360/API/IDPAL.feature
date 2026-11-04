@Regression @IDPAL
Feature: IDPAL API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to get all id pal profiles
    Given user has a service named "/api/v1/idpal/idverification/getallidpalprofiles"
    And user has query parameter "IncludeDetail":"true"
    And user has query parameter "ReturnFormat":"Json"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "getallidpalprofiles"
    And response body should match the schema from the file "getallidpalprofiles"

  Scenario: 002 Should be able to get all app link submissions
    Given user has a service named "/api/v1/idpal/idverification/getallapplinksubmissions"
    And user has a query params from the file "getallapplinksubmissions" with selected keys "BusinessUnitID,ClientProspectID,ClientOnboardingID,ActionUserID,ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "getallapplinksubmissions"
    And response body should match the schema from the file "getallapplinksubmissions"

  Scenario: 003 Should be able to get submission
    Given user has a service named "/api/v1/idpal/idverification/getsubmission"
    And user has a query params from the file "getallapplinksubmissions" with selected keys "BusinessUnitID,ClientProspectID,ClientOnboardingID,ActionUserID,ReturnFormat"
    And user has query parameter "SubmissionID":"4474030"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "getsubmission"
    And response body should match the schema from the file "getsubmission"

  Scenario: 004 Should be able to send app link
    Given user has a service named "/api/v1/idpal/idverification/sendapplink"
    And user has a payload from the file "getallapplinksubmissions" updates the key "ClientProspectID" with the value "606535"
    And user has payload "ClientOnboardingID":"340125"
    When user sends a 'POST' request
    Then response status should be 202
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key     | value        |
      | Success | false        |
      | Status  | MessageSent  |
      | Message | message sent |
    When user store the response body keyData:"UUID" with keyName:"UUID"
    Then user should receives email from:'noreply@id-pal.com' and to:'testautomations+APIIDPal2@riskscreen.com' and body should contains 'uuid=<UUID>' on outlook

  Scenario: 005 Should be able to get document stream
    Given user has a service named "/api/v1/idpal/idverification/getdocumentstream"
    And user has a query params from the file "getallapplinksubmissions" with selected keys "BusinessUnitID,ClientProspectID,ClientOnboardingID,ActionUserID,ReturnFormat"
    And user has query parameter "SubmissionID":"4474030"
    And user has query parameter "DocumentID":"8516112"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "getdocumentstream"
    And response body should match the schema from the file "getdocumentstream"

  Scenario: 006 Should be able to send submission notification
    Given user has a service named "/api/v1/idpal/idverification/acknowledgesubmissioncomplete"
    And user has a payload from the file "getallapplinksubmissions"
    And user has payload "ClientOnboardingID":"340136"
    And user has payload "SubmissionID":"4478747"
    When user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                | value                 |
      | IDPalMessageStatus |                     0 |
      | Message            | submission id invalid |

  Scenario: 007 Should be able to send submission notification
    Given user has a service named "/api/v1/idpal/idverification/sendsubmissionnotification"
    And user has a payload from the file "getallapplinksubmissions"
    And user has payload "SubmissionID":"4474030"
    And user has payload "NotificationMessage":"Test"
    When user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                | value |
      | IDPalMessageStatus |     0 |
      | Success            | True  |
    And user should receives email from:'noreply@id-pal.com' and to:'testautomations+APIIDPal@riskscreen.com' and body should contains 'https://qf97.app.link/0gL69PUUZx?uuid=1y2t9xl4' on outlook
