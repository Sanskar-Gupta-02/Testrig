@Regression @onboardingSubmission
Feature: Onboarding Submission API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add Submission
    Given user has a service named "/api/v1/client/onboardingsubmission/add"
    And user has a payload from the file 'onboardingSubmission'
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value                                           |
      | BusinessUnitID            |                                              10 |
      | ClientProspectID          |                                          606536 |
      | ClientOnboardingID        |                                          340126 |
      | Phone                     |                                      1234567890 |
      | FirstName                 | Idpal                                           |
      | LastName                  | Submission                                      |
      | MaidenName                | Manual                                          |
      | Email                     | testautomation+idpalmanualsubmission@kyc360.com |
      | GenderID                  |                                               1 |
      | GenderName                | Male                                            |
      | DateOfBirth               |                             1997-05-21 00:00:00 |
      | CountryOfBirthID          |                                              98 |
      | CountryOfBirth            | India                                           |
      | AddressLine1              | testrig1                                        |
      | AddressLine2              | testrig2                                        |
      | City                      | Pune                                            |
      | County                    | India                                           |
      | CountryID                 |                                              98 |
      | CountryName               | India                                           |
      | PostalCode                |                                          411057 |
      | PassportExpiryDate        |                             2040-12-21 00:00:00 |
      | IDExpiryDate              |                             2040-12-12 00:00:00 |
      | OSType                    | Windows                                         |
      | HardwareType              | Del                                             |
      | FreeMemory                |                                            20gb |
      | AvailableStorage          |                                            50gb |
      | ApprovalNotes             | Approved By Automation Team                     |
      | SubmissionSource          |                                               2 |
      | SubmissionStatus          |                                               1 |
      | AddressVerificationResult |                                               1 |
      | IdDetectResult            |                                               1 |
      | EVerificationDetails      | eVerification not done                          |
      | EVerificationCustomField  | E-verification by Automation                    |
      | LivenessTestResult        |                                               0 |
    When user store the response body keyData:"SubmissionID" with keyName:"SubmissionID"
    Then response body should match the schema from the file "onboardingSubmission"

  Scenario: 002 Should be able to fetch onboarding Submission
    Given user has a service named '/api/v1/client/onboardingsubmission/get'
    And user has a query params from the file 'onboardingSubmission' with selected keys 'BusinessUnitID,ClientProspectID,ClientOnboardingID,ReturnFormat'
    And user add query parameter 'SubmissionID' with the stored key value 'SubmissionID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key "SubmissionID" with the stored key value "SubmissionID"
    And response body should have key with the value:
      | key                       | value                                           |
      | BusinessUnitID            |                                              10 |
      | ClientProspectID          |                                          606536 |
      | ClientOnboardingID        |                                          340126 |
      | Phone                     |                                      1234567890 |
      | FirstName                 | Idpal                                           |
      | LastName                  | Submission                                      |
      | MaidenName                | Manual                                          |
      | Email                     | testautomation+idpalmanualsubmission@kyc360.com |
      | GenderID                  |                                               1 |
      | GenderName                | Male                                            |
      | DateOfBirth               |                             1997-05-21 00:00:00 |
      | CountryOfBirthID          |                                              98 |
      | CountryOfBirth            | India                                           |
      | AddressLine1              | testrig1                                        |
      | AddressLine2              | testrig2                                        |
      | City                      | Pune                                            |
      | County                    | India                                           |
      | CountryID                 |                                              98 |
      | CountryName               | India                                           |
      | PostalCode                |                                          411057 |
      | PassportExpiryDate        |                             2040-12-21 00:00:00 |
      | IDExpiryDate              |                             2040-12-12 00:00:00 |
      | OSType                    | Windows                                         |
      | HardwareType              | Del                                             |
      | FreeMemory                |                                            20gb |
      | AvailableStorage          |                                            50gb |
      | ApprovalNotes             | Approved By Automation Team                     |
      | SubmissionSource          |                                               2 |
      | SubmissionStatus          |                                               1 |
      | AddressVerificationResult |                                               1 |
      | IdDetectResult            |                                               1 |
      | EVerificationDetails      | eVerification not done                          |
      | EVerificationCustomField  | E-verification by Automation                    |
      | LivenessTestResult        |                                               0 |
    And response body should match the schema from the file "onboardingSubmission"

  Scenario: 003 Should be able to update onboarding Submission
    Given user has a service named '/api/v1/client/onboardingsubmission/update'
    And user has a payload from the file 'onboardingSubmission'
    And user add payload 'SubmissionID' with the stored key value 'SubmissionID'
    And user has payloads:
      """
      {
      "FirstName":"IdpalUpdated",
      "LastName":"SubmissionUpdated",
      "MaidenName": "ManualUpdated",
      "GenderID":2,
      "DateOfBirth":"1998-06-22",
      "AddressLine1":"testrig1-Updated",
      "AddressLine2":"testrig2-Updated",
      "EVerificationDetails" : "eVerification done Updated",
      "EVerificationCustomField" : "E-verification by Automation Updated"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                       | value                                           |
      | BusinessUnitID            |                                              10 |
      | ClientProspectID          |                                          606536 |
      | ClientOnboardingID        |                                          340126 |
      | Phone                     |                                      1234567890 |
      | FirstName                 | IdpalUpdated                                    |
      | LastName                  | SubmissionUpdated                               |
      | MaidenName                | ManualUpdated                                   |
      | Email                     | testautomation+idpalmanualsubmission@kyc360.com |
      | GenderID                  |                                               2 |
      | GenderName                | Female                                          |
      | DateOfBirth               |                             1998-06-22 00:00:00 |
      | CountryOfBirthID          |                                              98 |
      | CountryOfBirth            | India                                           |
      | AddressLine1              | testrig1-Updated                                |
      | AddressLine2              | testrig2-Updated                                |
      | City                      | Pune                                            |
      | County                    | India                                           |
      | CountryID                 |                                              98 |
      | CountryName               | India                                           |
      | PostalCode                |                                          411057 |
      | PassportExpiryDate        |                             2040-12-21 00:00:00 |
      | IDExpiryDate              |                             2040-12-12 00:00:00 |
      | OSType                    | Windows                                         |
      | HardwareType              | Del                                             |
      | FreeMemory                |                                            20gb |
      | AvailableStorage          |                                            50gb |
      | ApprovalNotes             | Approved By Automation Team                     |
      | SubmissionSource          |                                               2 |
      | SubmissionStatus          |                                               1 |
      | AddressVerificationResult |                                               1 |
      | IdDetectResult            |                                               1 |
      | EVerificationDetails      | eVerification done Updated                      |
      | EVerificationCustomField  | E-verification by Automation Updated            |
      | LivenessTestResult        |                                               1 |
    And response body should match the schema from the file "onboardingSubmission"

  Scenario: 004 Should be able to get all onboarding Submission details
    Given user has a service named "/api/v1/client/onboardingsubmission/getall"
    And user has a query params from the file 'onboardingSubmission' with selected keys 'BusinessUnitID,ClientProspectID,ClientOnboardingID,ReturnFormat'
    When user sends a 'Get' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboardingSubmissionGetAll"
    And response body should have index key with the value:
      | index | key                       | value                                                 |
      |     1 | BusinessUnitID            |                                                    10 |
      |     1 | ClientProspectID          |                                                606536 |
      |     1 | ClientOnboardingID        |                                                340126 |
      |     1 | Phone                     |                                            1234567890 |
      |     1 | SubmissionID              |                                                    57 |
      |     1 | FirstName                 | Idpal                                                 |
      |     1 | LastName                  | SubmissionFromUI                                      |
      |     1 | MaidenName                | Manual                                                |
      |     1 | Email                     | testautomation+idpalmanualsubmissionfromUI@kyc360.com |
      |     1 | GenderID                  |                                                     1 |
      |     1 | GenderName                | Male                                                  |
      |     1 | DateOfBirth               |                                   1998-06-22 00:00:00 |
      |     1 | CountryOfBirthID          |                                                     0 |
      |     1 | CountryOfBirth            | India                                                 |
      |     1 | AddressLine1              | Address1                                              |
      |     1 | AddressLine2              | Address2                                              |
      |     1 | City                      | Pune                                                  |
      |     1 | County                    | India                                                 |
      |     1 | CountryID                 |                                                    98 |
      |     1 | CountryName               | India                                                 |
      |     1 | PostalCode                |                                                411057 |
      |     1 | PassportExpiryDate        |                                   2050-12-21 00:00:00 |
      |     1 | IDExpiryDate              |                                   2050-12-12 00:00:00 |
      |     1 | OSType                    | WindowsUI                                             |
      |     1 | HardwareType              | Del                                                   |
      |     1 | FreeMemory                |                                                  50gb |
      |     1 | AvailableStorage          |                                                1000gb |
      |     1 | ApprovalNotes             |                                                       |
      |     1 | SubmissionSource          |                                                     2 |
      |     1 | SubmissionStatus          |                                                     1 |
      |     1 | AddressVerificationResult |                                                     1 |
      |     1 | IdDetectResult            |                                                     0 |
      |     1 | EVerificationDetails      | eVerification done Updated                            |
      |     1 | EVerificationCustomField  | E-verification by Automation Updated                  |
      |     1 | LivenessTestResult        |                                                     0 |
      |     2 | BusinessUnitID            |                                                    10 |
      |     2 | ClientProspectID          |                                                606536 |
      |     2 | ClientOnboardingID        |                                                340126 |
      |     2 | Phone                     |                                            1234567890 |
      |     2 | FirstName                 | IdpalUpdated                                          |
      |     2 | LastName                  | SubmissionUpdated                                     |
      |     2 | MaidenName                | ManualUpdated                                         |
      |     2 | Email                     | testautomation+idpalmanualsubmission@kyc360.com       |
      |     2 | GenderID                  |                                                     2 |
      |     2 | GenderName                | Female                                                |
      |     2 | DateOfBirth               |                                   1998-06-22 00:00:00 |
      |     2 | CountryOfBirthID          |                                                    98 |
      |     2 | CountryOfBirth            | India                                                 |
      |     2 | AddressLine1              | testrig1-Updated                                      |
      |     2 | AddressLine2              | testrig2-Updated                                      |
      |     2 | City                      | Pune                                                  |
      |     2 | County                    | India                                                 |
      |     2 | CountryID                 |                                                    98 |
      |     2 | CountryName               | India                                                 |
      |     2 | PostalCode                |                                                411057 |
      |     2 | PassportExpiryDate        |                                   2040-12-21 00:00:00 |
      |     2 | IDExpiryDate              |                                   2040-12-12 00:00:00 |
      |     2 | OSType                    | Windows                                               |
      |     2 | HardwareType              | Del                                                   |
      |     2 | FreeMemory                |                                                  20gb |
      |     2 | AvailableStorage          |                                                  50gb |
      |     2 | ApprovalNotes             | Approved By Automation Team                           |
      |     2 | SubmissionSource          |                                                     2 |
      |     2 | SubmissionStatus          |                                                     1 |
      |     2 | AddressVerificationResult |                                                     1 |
      |     2 | IdDetectResult            |                                                     1 |
      |     2 | EVerificationDetails      | eVerification done Updated                            |
      |     2 | EVerificationCustomField  | E-verification by Automation Updated                  |
      |     2 | LivenessTestResult        |                                                     1 |

  Scenario: 005 should be able to delete onboarding Submission
    Given user has a service named '/api/v1/client/onboardingsubmission/delete'
    And user has a query params from the file "onboardingSubmission" with selected keys 'BusinessUnitID,ClientProspectID,ClientOnboardingID,ReturnFormat,ActionUserID'
    And user add query parameter "SubmissionID" with the stored key value "SubmissionID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response body should have key 'SubmissionID' with the stored key value 'SubmissionID'
    And response body should have key with the value:
      | key                       | value                                           |
      | BusinessUnitID            |                                              10 |
      | ClientProspectID          |                                          606536 |
      | ClientOnboardingID        |                                          340126 |
      | Phone                     |                                      1234567890 |
      | FirstName                 | IdpalUpdated                                    |
      | LastName                  | SubmissionUpdated                               |
      | MaidenName                | ManualUpdated                                   |
      | Email                     | testautomation+idpalmanualsubmission@kyc360.com |
      | GenderID                  |                                               2 |
      | GenderName                | Female                                          |
      | DateOfBirth               |                             1998-06-22 00:00:00 |
      | CountryOfBirthID          |                                              98 |
      | CountryOfBirth            | India                                           |
      | AddressLine1              | testrig1-Updated                                |
      | AddressLine2              | testrig2-Updated                                |
      | City                      | Pune                                            |
      | County                    | India                                           |
      | CountryID                 |                                              98 |
      | CountryName               | India                                           |
      | PostalCode                |                                          411057 |
      | PassportExpiryDate        |                             2040-12-21 00:00:00 |
      | IDExpiryDate              |                             2040-12-12 00:00:00 |
      | OSType                    | Windows                                         |
      | HardwareType              | Del                                             |
      | FreeMemory                |                                            20gb |
      | AvailableStorage          |                                            50gb |
      | ApprovalNotes             | Approved By Automation Team                     |
      | SubmissionSource          |                                               2 |
      | SubmissionStatus          |                                               1 |
      | AddressVerificationResult |                                               1 |
      | IdDetectResult            |                                               1 |
      | EVerificationDetails      | eVerification done Updated                      |
      | EVerificationCustomField  | E-verification by Automation Updated            |
      | LivenessTestResult        |                                               1 |
    And response body should match the schema from the file "onboardingSubmission"
