@Regression @OnboardingType
Feature: Onboaring Type API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add Onboarding type with Risk Model Type as Single Highest
    Given user has a service named "/api/v1/static/onboardingtype/add"
    And user has a payload from the file 'onboardingTypes'
    And user store the unique value for key:
      | key                |
      | onboardingTypeName |
    And user add payload key with stored key value:
      | payloadKey         | storedkey          |
      | OnboardingTypeName | onboardingTypeName |
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                        | value           |
      | OnboardingTypeDescription                  | New Env testing |
      | LowRiskIDPalProfileType                    |             632 |
      | StandardRiskIDPalProfileType               |             632 |
      | HighRiskIDPalProfileType                   |             632 |
      | VeryHighRiskIDPalProfileType               |             632 |
      | LowRiskOnboardingApprovalType              |               0 |
      | StandardRiskOnboardingApprovalType         |               0 |
      | HighRiskOnboardingApprovalType             |               0 |
      | VeryHighRiskOnboardingApprovalType         |               0 |
      | ClientBrandingID                           |               0 |
      | LowRiskCriteriaID                          |             184 |
      | StandardRiskCriteriaID                     |             184 |
      | HighRiskCriteriaID                         |             184 |
      | VeryHighRiskCriteriaID                     |             184 |
      | LowRiskClientEntityRiskID                  |             132 |
      | StandardRiskClientEntityRiskID             |             132 |
      | HighRiskClientEntityRiskID                 |             132 |
      | VeryHighRiskClientEntityRiskID             |             132 |
      | ExcludeOnboardingStageDataCollection       | false           |
      | ExcludeOnboardingStageDataApproval         | false           |
      | ExcludeOnboardingStageIdentityVerification | false           |
      | ExcludeOnboardingStageIdentityApproval     | false           |
      | ExcludeOnboardingStageScreening            | false           |
      | ExcludeOnboardingStageComplianceApproval   | false           |
      | NomineeDataCollectionType                  |               0 |
      | ExternalProspectAutosendEmailTemplateID    |               0 |
      | EmailAlertDisabled                         | true            |
      | LeadProspectApprovalType                   |               0 |
      | KYBPersonProspectOnboardingTypeID          |               0 |
      | KYBPersonProspectEmailTemplateID           |               0 |
      | KYBCorporateProspectOnboardingTypeID       |               0 |
      | KYBCorporateProspectEmailTemplateID        |               0 |
      | DataCollectionWelcomeMessage               | hello           |
      | TermsAndConditionsEnabled                  | false           |
      | TermsAndConditionsMessage                  | not enabled     |
      | ConfirmationMessageEnabled                 | false           |
      | ConfirmationMessage                        | true            |
      | VerificationMessageEnabled                 | false           |
      | RiskModelType                              |               0 |
      | SnapshotType                               |               0 |
      | LowWeightedRiskScoreUpperLimit             |              25 |
      | StandardWeightedRiskScoreUpperLimit        |              50 |
      | HighWeightedRiskScoreUpperLimit            |              75 |
      | VeryHighWeightedRiskScoreUpperLimit        |             100 |
      | LowRiskCriteriaName                        | Person          |
      | StandardRiskCriteriaName                   | Person          |
      | HighRiskCriteriaName                       | Person          |
      | VeryHighRiskCriteriaName                   | Person          |
      | AllowKYBLookup                             | false           |
      | TotalPossibleRiskScore                     |               0 |
    And response body should match the schema from the file "onboardingTypes"
    And response body should have key 'OnboardingTypeName' with the stored key value 'onboardingTypeName'
    When user store the response body keyData:"OnboardingTypeID" with keyName:"onboardingTypeID"

  Scenario: 002 Should be able to get onboarding Type details
    Given user has a service named "/api/v1/static/onboardingtype/get"
    And user has a query params from the file "onboardingTypes" with selected keys "ReturnFormat,IncludeDataCollectionLogo"
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                        | value           |
      | OnboardingTypeDescription                  | New Env testing |
      | LowRiskIDPalProfileType                    |             632 |
      | StandardRiskIDPalProfileType               |             632 |
      | HighRiskIDPalProfileType                   |             632 |
      | VeryHighRiskIDPalProfileType               |             632 |
      | LowRiskOnboardingApprovalType              |               0 |
      | StandardRiskOnboardingApprovalType         |               0 |
      | HighRiskOnboardingApprovalType             |               0 |
      | VeryHighRiskOnboardingApprovalType         |               0 |
      | ClientBrandingID                           |               0 |
      | LowRiskCriteriaID                          |             184 |
      | StandardRiskCriteriaID                     |             184 |
      | HighRiskCriteriaID                         |             184 |
      | VeryHighRiskCriteriaID                     |             184 |
      | LowRiskClientEntityRiskID                  |             132 |
      | StandardRiskClientEntityRiskID             |             132 |
      | HighRiskClientEntityRiskID                 |             132 |
      | VeryHighRiskClientEntityRiskID             |             132 |
      | ExcludeOnboardingStageDataCollection       | false           |
      | ExcludeOnboardingStageDataApproval         | false           |
      | ExcludeOnboardingStageIdentityVerification | false           |
      | ExcludeOnboardingStageIdentityApproval     | false           |
      | ExcludeOnboardingStageScreening            | false           |
      | ExcludeOnboardingStageComplianceApproval   | false           |
      | NomineeDataCollectionType                  |               0 |
      | ExternalProspectAutosendEmailTemplateID    |               0 |
      | EmailAlertDisabled                         | true            |
      | LeadProspectApprovalType                   |               0 |
      | KYBPersonProspectOnboardingTypeID          |               0 |
      | KYBPersonProspectEmailTemplateID           |               0 |
      | KYBCorporateProspectOnboardingTypeID       |               0 |
      | KYBCorporateProspectEmailTemplateID        |               0 |
      | DataCollectionWelcomeMessage               | hello           |
      | TermsAndConditionsEnabled                  | false           |
      | TermsAndConditionsMessage                  | not enabled     |
      | ConfirmationMessageEnabled                 | false           |
      | ConfirmationMessage                        | true            |
      | VerificationMessageEnabled                 | false           |
      | RiskModelType                              |               0 |
      | SnapshotType                               |               0 |
      | LowWeightedRiskScoreUpperLimit             |              25 |
      | StandardWeightedRiskScoreUpperLimit        |              50 |
      | HighWeightedRiskScoreUpperLimit            |              75 |
      | VeryHighWeightedRiskScoreUpperLimit        |             100 |
      | LowRiskCriteriaName                        | Person          |
      | StandardRiskCriteriaName                   | Person          |
      | HighRiskCriteriaName                       | Person          |
      | VeryHighRiskCriteriaName                   | Person          |
      | AllowKYBLookup                             | false           |
      | TotalPossibleRiskScore                     |             0 |
    And response body should match the schema from the file "onboardingTypes"
    And response body should have key 'OnboardingTypeName' with the stored key value 'onboardingTypeName'
    And response body should have key 'OnboardingTypeID' with the stored key value 'onboardingTypeID'

  Scenario: 003 Should be able to update Onboarding Type details with TotalPossibleRiskScore greater than 100
    Given user has a service named "/api/v1/static/onboardingtype/update"
    And user has a payload from the file "onboardingTypes"
    And user store the unique value for key:
      | key                      |
      | onboardingTypeNameUpdate |
    And user add payload key with stored key value:
      | payloadKey         | storedkey                |
      | OnboardingTypeName | onboardingTypeNameUpdate |
    And user has payloads:
      """
      {
        "RiskModelType": "1",
        "TotalPossibleRiskScore": "101"
      }
      """
    And user add payload 'OnboardingTypeID' with the stored key value 'onboardingTypeID'
    When user sends a 'PUT' request
    Then response status should be 406
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key 'Message' with the message:'The request is invalid.'

  Scenario: 004 Should be able to update Onboarding Type details with TotalPossibleRiskScore less than 100
    Given user has a service named "/api/v1/static/onboardingtype/update"
    And user has a payload from the file "onboardingTypes"
    And user store the unique value for key:
      | key                      |
      | onboardingTypeNameUpdate |
    And user add payload key with stored key value:
      | payloadKey         | storedkey                |
      | OnboardingTypeName | onboardingTypeNameUpdate |
    And user has payloads:
      """
      {
        "OnboardingTypeDescription":"Hidden Leaf Village",
        "LowRiskCriteriaID": "185",
        "StandardRiskCriteriaID": "185",
        "HighRiskCriteriaID": "185",
        "VeryHighRiskCriteriaID": "185",
        "LowRiskClientEntityRiskID": "133",
        "StandardRiskClientEntityRiskID": "133",
        "HighRiskClientEntityRiskID": "133",
        "VeryHighRiskClientEntityRiskID": "133",
        "RiskModelType": "1",
        "TotalPossibleRiskScore": "50"
      }
      """
    And user add payload 'OnboardingTypeID' with the stored key value 'onboardingTypeID'
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                        | value               |
      | OnboardingTypeDescription                  | Hidden Leaf Village |
      | LowRiskIDPalProfileType                    |                 632 |
      | StandardRiskIDPalProfileType               |                 632 |
      | HighRiskIDPalProfileType                   |                 632 |
      | VeryHighRiskIDPalProfileType               |                 632 |
      | LowRiskOnboardingApprovalType              |                   0 |
      | StandardRiskOnboardingApprovalType         |                   0 |
      | HighRiskOnboardingApprovalType             |                   0 |
      | VeryHighRiskOnboardingApprovalType         |                   0 |
      | ClientBrandingID                           |                   0 |
      | LowRiskCriteriaID                          |                 185 |
      | StandardRiskCriteriaID                     |                 185 |
      | HighRiskCriteriaID                         |                 185 |
      | VeryHighRiskCriteriaID                     |                 185 |
      | LowRiskClientEntityRiskID                  |                 133 |
      | StandardRiskClientEntityRiskID             |                 133 |
      | HighRiskClientEntityRiskID                 |                 133 |
      | VeryHighRiskClientEntityRiskID             |                 133 |
      | ExcludeOnboardingStageDataCollection       | false               |
      | ExcludeOnboardingStageDataApproval         | false               |
      | ExcludeOnboardingStageIdentityVerification | false               |
      | ExcludeOnboardingStageIdentityApproval     | false               |
      | ExcludeOnboardingStageScreening            | false               |
      | ExcludeOnboardingStageComplianceApproval   | false               |
      | NomineeDataCollectionType                  |                   0 |
      | ExternalProspectAutosendEmailTemplateID    |                   0 |
      | EmailAlertDisabled                         | true                |
      | LeadProspectApprovalType                   |                   0 |
      | KYBPersonProspectOnboardingTypeID          |                   0 |
      | KYBPersonProspectEmailTemplateID           |                   0 |
      | KYBCorporateProspectOnboardingTypeID       |                   0 |
      | KYBCorporateProspectEmailTemplateID        |                   0 |
      | DataCollectionWelcomeMessage               | hello               |
      | TermsAndConditionsEnabled                  | false               |
      | TermsAndConditionsMessage                  | not enabled         |
      | ConfirmationMessageEnabled                 | false               |
      | ConfirmationMessage                        | true                |
      | VerificationMessageEnabled                 | false               |
      | RiskModelType                              |                   1 |
      | SnapshotType                               |                   0 |
      | LowWeightedRiskScoreUpperLimit             |                  25 |
      | StandardWeightedRiskScoreUpperLimit        |                  50 |
      | HighWeightedRiskScoreUpperLimit            |                  75 |
      | VeryHighWeightedRiskScoreUpperLimit        |                 100 |
      | LowRiskCriteriaName                        | Entity              |
      | StandardRiskCriteriaName                   | Entity              |
      | HighRiskCriteriaName                       | Entity              |
      | VeryHighRiskCriteriaName                   | Entity              |
      | AllowKYBLookup                             | false               |
      | TotalPossibleRiskScore                     |                  50 |
    And response body should match the schema from the file "onboardingTypes"
    And response body should have key 'OnboardingTypeName' with the stored key value 'onboardingTypeNameUpdate'
    And response body should have key 'OnboardingTypeID' with the stored key value 'onboardingTypeID'

  Scenario: 005 Should be able to get onboarding Type details with TotalPossibleRiskScore less than 100
    Given user has a service named "/api/v1/static/onboardingtype/get"
    And user has a query params from the file "onboardingTypes" with selected keys "ReturnFormat,IncludeDataCollectionLogo"
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                        | value               |
      | OnboardingTypeDescription                  | Hidden Leaf Village |
      | LowRiskIDPalProfileType                    |                 632 |
      | StandardRiskIDPalProfileType               |                 632 |
      | HighRiskIDPalProfileType                   |                 632 |
      | VeryHighRiskIDPalProfileType               |                 632 |
      | LowRiskOnboardingApprovalType              |                   0 |
      | StandardRiskOnboardingApprovalType         |                   0 |
      | HighRiskOnboardingApprovalType             |                   0 |
      | VeryHighRiskOnboardingApprovalType         |                   0 |
      | ClientBrandingID                           |                   0 |
      | LowRiskCriteriaID                          |                 185 |
      | StandardRiskCriteriaID                     |                 185 |
      | HighRiskCriteriaID                         |                 185 |
      | VeryHighRiskCriteriaID                     |                 185 |
      | LowRiskClientEntityRiskID                  |                 133 |
      | StandardRiskClientEntityRiskID             |                 133 |
      | HighRiskClientEntityRiskID                 |                 133 |
      | VeryHighRiskClientEntityRiskID             |                 133 |
      | ExcludeOnboardingStageDataCollection       | false               |
      | ExcludeOnboardingStageDataApproval         | false               |
      | ExcludeOnboardingStageIdentityVerification | false               |
      | ExcludeOnboardingStageIdentityApproval     | false               |
      | ExcludeOnboardingStageScreening            | false               |
      | ExcludeOnboardingStageComplianceApproval   | false               |
      | NomineeDataCollectionType                  |                   0 |
      | ExternalProspectAutosendEmailTemplateID    |                   0 |
      | EmailAlertDisabled                         | true                |
      | LeadProspectApprovalType                   |                   0 |
      | KYBPersonProspectOnboardingTypeID          |                   0 |
      | KYBPersonProspectEmailTemplateID           |                   0 |
      | KYBCorporateProspectOnboardingTypeID       |                   0 |
      | KYBCorporateProspectEmailTemplateID        |                   0 |
      | DataCollectionWelcomeMessage               | hello               |
      | TermsAndConditionsEnabled                  | false               |
      | TermsAndConditionsMessage                  | not enabled         |
      | ConfirmationMessageEnabled                 | false               |
      | ConfirmationMessage                        | true                |
      | VerificationMessageEnabled                 | false               |
      | RiskModelType                              |                   1 |
      | SnapshotType                               |                   0 |
      | LowWeightedRiskScoreUpperLimit             |                  25 |
      | StandardWeightedRiskScoreUpperLimit        |                  50 |
      | HighWeightedRiskScoreUpperLimit            |                  75 |
      | VeryHighWeightedRiskScoreUpperLimit        |                 100 |
      | LowRiskCriteriaName                        | Entity              |
      | StandardRiskCriteriaName                   | Entity              |
      | HighRiskCriteriaName                       | Entity              |
      | VeryHighRiskCriteriaName                   | Entity              |
      | AllowKYBLookup                             | false               |
      | TotalPossibleRiskScore                     |                  50 |
    And response body should match the schema from the file "onboardingTypes"
    And response body should have key 'OnboardingTypeName' with the stored key value 'onboardingTypeNameUpdate'
    And response body should have key 'OnboardingTypeID' with the stored key value 'onboardingTypeID'

  Scenario: 006 Should be able to getall Onboarding type details
    Given user has a service named "/api/v1/static/onboardingtype/getall"
    And user has a query params from the file "onboardingTypes" with selected keys "ReturnFormat,IncludeDataCollectionLogo"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "onboardingTypesGetAll"

  Scenario: 007 Should be able to delete Onboarding type
    Given user has a service named "/api/v1/static/onboardingtype/delete"
    And user has a query params from the file 'onboardingTypes' with selected keys 'ActionUserID,ReturnFormat'
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                        | value               |
      | OnboardingTypeDescription                  | Hidden Leaf Village |
      | LowRiskIDPalProfileType                    |                 632 |
      | StandardRiskIDPalProfileType               |                 632 |
      | HighRiskIDPalProfileType                   |                 632 |
      | VeryHighRiskIDPalProfileType               |                 632 |
      | LowRiskOnboardingApprovalType              |                   0 |
      | StandardRiskOnboardingApprovalType         |                   0 |
      | HighRiskOnboardingApprovalType             |                   0 |
      | VeryHighRiskOnboardingApprovalType         |                   0 |
      | ClientBrandingID                           |                   0 |
      | LowRiskCriteriaID                          |                 185 |
      | StandardRiskCriteriaID                     |                 185 |
      | HighRiskCriteriaID                         |                 185 |
      | VeryHighRiskCriteriaID                     |                 185 |
      | LowRiskClientEntityRiskID                  |                 133 |
      | StandardRiskClientEntityRiskID             |                 133 |
      | HighRiskClientEntityRiskID                 |                 133 |
      | VeryHighRiskClientEntityRiskID             |                 133 |
      | ExcludeOnboardingStageDataCollection       | false               |
      | ExcludeOnboardingStageDataApproval         | false               |
      | ExcludeOnboardingStageIdentityVerification | false               |
      | ExcludeOnboardingStageIdentityApproval     | false               |
      | ExcludeOnboardingStageScreening            | false               |
      | ExcludeOnboardingStageComplianceApproval   | false               |
      | NomineeDataCollectionType                  |                   0 |
      | ExternalProspectAutosendEmailTemplateID    |                   0 |
      | EmailAlertDisabled                         | true                |
      | LeadProspectApprovalType                   |                   0 |
      | KYBPersonProspectOnboardingTypeID          |                   0 |
      | KYBPersonProspectEmailTemplateID           |                   0 |
      | KYBCorporateProspectOnboardingTypeID       |                   0 |
      | KYBCorporateProspectEmailTemplateID        |                   0 |
      | DataCollectionWelcomeMessage               | hello               |
      | TermsAndConditionsEnabled                  | false               |
      | TermsAndConditionsMessage                  | not enabled         |
      | ConfirmationMessageEnabled                 | false               |
      | ConfirmationMessage                        | true                |
      | VerificationMessageEnabled                 | false               |
      | RiskModelType                              |                   1 |
      | SnapshotType                               |                   0 |
      | LowWeightedRiskScoreUpperLimit             |                  25 |
      | StandardWeightedRiskScoreUpperLimit        |                  50 |
      | HighWeightedRiskScoreUpperLimit            |                  75 |
      | VeryHighWeightedRiskScoreUpperLimit        |                 100 |
      | LowRiskCriteriaName                        | Entity              |
      | StandardRiskCriteriaName                   | Entity              |
      | HighRiskCriteriaName                       | Entity              |
      | VeryHighRiskCriteriaName                   | Entity              |
      | AllowKYBLookup                             | false               |
      | TotalPossibleRiskScore                     |                  50 |
    And response body should match the schema from the file "onboardingTypes"
    And response body should have key 'OnboardingTypeName' with the stored key value 'onboardingTypeNameUpdate'
    And response body should have key 'OnboardingTypeID' with the stored key value 'onboardingTypeID'

  Scenario: 008 Should be able to add Onboarding type with Total Possible Risk Score less than 100
    Given user has a service named "/api/v1/static/onboardingtype/add"
    And user has a payload from the file 'onboardingTypes'
    And user store the unique value for key:
      | key                 |
      | onboardingTypeName1 |
    And user add payload key with stored key value:
      | payloadKey         | storedkey           |
      | OnboardingTypeName | onboardingTypeName1 |
    And user has payloads:
      """
      {
        "RiskModelType": "1",
        "TotalPossibleRiskScore": "50"
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                        | value           |
      | OnboardingTypeDescription                  | New Env testing |
      | LowRiskIDPalProfileType                    |             632 |
      | StandardRiskIDPalProfileType               |             632 |
      | HighRiskIDPalProfileType                   |             632 |
      | VeryHighRiskIDPalProfileType               |             632 |
      | LowRiskOnboardingApprovalType              |               0 |
      | StandardRiskOnboardingApprovalType         |               0 |
      | HighRiskOnboardingApprovalType             |               0 |
      | VeryHighRiskOnboardingApprovalType         |               0 |
      | ClientBrandingID                           |               0 |
      | LowRiskCriteriaID                          |             184 |
      | StandardRiskCriteriaID                     |             184 |
      | HighRiskCriteriaID                         |             184 |
      | VeryHighRiskCriteriaID                     |             184 |
      | LowRiskClientEntityRiskID                  |             132 |
      | StandardRiskClientEntityRiskID             |             132 |
      | HighRiskClientEntityRiskID                 |             132 |
      | VeryHighRiskClientEntityRiskID             |             132 |
      | ExcludeOnboardingStageDataCollection       | false           |
      | ExcludeOnboardingStageDataApproval         | false           |
      | ExcludeOnboardingStageIdentityVerification | false           |
      | ExcludeOnboardingStageIdentityApproval     | false           |
      | ExcludeOnboardingStageScreening            | false           |
      | ExcludeOnboardingStageComplianceApproval   | false           |
      | NomineeDataCollectionType                  |               0 |
      | ExternalProspectAutosendEmailTemplateID    |               0 |
      | EmailAlertDisabled                         | true            |
      | LeadProspectApprovalType                   |               0 |
      | KYBPersonProspectOnboardingTypeID          |               0 |
      | KYBPersonProspectEmailTemplateID           |               0 |
      | KYBCorporateProspectOnboardingTypeID       |               0 |
      | KYBCorporateProspectEmailTemplateID        |               0 |
      | DataCollectionWelcomeMessage               | hello           |
      | TermsAndConditionsEnabled                  | false           |
      | TermsAndConditionsMessage                  | not enabled     |
      | ConfirmationMessageEnabled                 | false           |
      | ConfirmationMessage                        | true            |
      | VerificationMessageEnabled                 | false           |
      | RiskModelType                              |               1 |
      | SnapshotType                               |               0 |
      | LowWeightedRiskScoreUpperLimit             |              25 |
      | StandardWeightedRiskScoreUpperLimit        |              50 |
      | HighWeightedRiskScoreUpperLimit            |              75 |
      | VeryHighWeightedRiskScoreUpperLimit        |             100 |
      | LowRiskCriteriaName                        | Person          |
      | StandardRiskCriteriaName                   | Person          |
      | HighRiskCriteriaName                       | Person          |
      | VeryHighRiskCriteriaName                   | Person          |
      | AllowKYBLookup                             | false           |
      | TotalPossibleRiskScore                     |              50 |
    And response body should match the schema from the file "onboardingTypes"
    And response body should have key 'OnboardingTypeName' with the stored key value 'onboardingTypeName1'
    When user store the response body keyData:"OnboardingTypeID" with keyName:"onboardingTypeID1"

  Scenario: 009 Should be able to get onboarding Type details with Total Possible Risk Score less than 100
    Given user has a service named "/api/v1/static/onboardingtype/get"
    And user has a query params from the file "onboardingTypes" with selected keys "ReturnFormat,IncludeDataCollectionLogo"
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID1"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                        | value           |
      | OnboardingTypeDescription                  | New Env testing |
      | LowRiskIDPalProfileType                    |             632 |
      | StandardRiskIDPalProfileType               |             632 |
      | HighRiskIDPalProfileType                   |             632 |
      | VeryHighRiskIDPalProfileType               |             632 |
      | LowRiskOnboardingApprovalType              |               0 |
      | StandardRiskOnboardingApprovalType         |               0 |
      | HighRiskOnboardingApprovalType             |               0 |
      | VeryHighRiskOnboardingApprovalType         |               0 |
      | ClientBrandingID                           |               0 |
      | LowRiskCriteriaID                          |             184 |
      | StandardRiskCriteriaID                     |             184 |
      | HighRiskCriteriaID                         |             184 |
      | VeryHighRiskCriteriaID                     |             184 |
      | LowRiskClientEntityRiskID                  |             132 |
      | StandardRiskClientEntityRiskID             |             132 |
      | HighRiskClientEntityRiskID                 |             132 |
      | VeryHighRiskClientEntityRiskID             |             132 |
      | ExcludeOnboardingStageDataCollection       | false           |
      | ExcludeOnboardingStageDataApproval         | false           |
      | ExcludeOnboardingStageIdentityVerification | false           |
      | ExcludeOnboardingStageIdentityApproval     | false           |
      | ExcludeOnboardingStageScreening            | false           |
      | ExcludeOnboardingStageComplianceApproval   | false           |
      | NomineeDataCollectionType                  |               0 |
      | ExternalProspectAutosendEmailTemplateID    |               0 |
      | EmailAlertDisabled                         | true            |
      | LeadProspectApprovalType                   |               0 |
      | KYBPersonProspectOnboardingTypeID          |               0 |
      | KYBPersonProspectEmailTemplateID           |               0 |
      | KYBCorporateProspectOnboardingTypeID       |               0 |
      | KYBCorporateProspectEmailTemplateID        |               0 |
      | DataCollectionWelcomeMessage               | hello           |
      | TermsAndConditionsEnabled                  | false           |
      | TermsAndConditionsMessage                  | not enabled     |
      | ConfirmationMessageEnabled                 | false           |
      | ConfirmationMessage                        | true            |
      | VerificationMessageEnabled                 | false           |
      | RiskModelType                              |               1 |
      | SnapshotType                               |               0 |
      | LowWeightedRiskScoreUpperLimit             |              25 |
      | StandardWeightedRiskScoreUpperLimit        |              50 |
      | HighWeightedRiskScoreUpperLimit            |              75 |
      | VeryHighWeightedRiskScoreUpperLimit        |             100 |
      | LowRiskCriteriaName                        | Person          |
      | StandardRiskCriteriaName                   | Person          |
      | HighRiskCriteriaName                       | Person          |
      | VeryHighRiskCriteriaName                   | Person          |
      | AllowKYBLookup                             | false           |
      | TotalPossibleRiskScore                     |              50 |
    And response body should match the schema from the file "onboardingTypes"
    And response body should have key 'OnboardingTypeName' with the stored key value 'onboardingTypeName1'
    And response body should have key 'OnboardingTypeID' with the stored key value 'onboardingTypeID1'

  Scenario: 010 Should be able to update Onboarding Type details with Risk Model Type as Single Highest
    Given user has a service named "/api/v1/static/onboardingtype/update"
    And user has a payload from the file "onboardingTypes"
    And user store the unique value for key:
      | key                       |
      | onboardingTypeNameUpdate1 |
    And user add payload key with stored key value:
      | payloadKey         | storedkey                 |
      | OnboardingTypeName | onboardingTypeNameUpdate1 |
    And user has payloads:
      """
      {
        "OnboardingTypeDescription":"Hidden Leaf Village",
        "LowRiskCriteriaID": "185",
        "StandardRiskCriteriaID": "185",
        "HighRiskCriteriaID": "185",
        "VeryHighRiskCriteriaID": "185",
        "LowRiskClientEntityRiskID": "133",
        "StandardRiskClientEntityRiskID": "133",
        "HighRiskClientEntityRiskID": "133",
        "VeryHighRiskClientEntityRiskID": "133",
        "RiskModelType": "0"
      }
      """
    And user add payload 'OnboardingTypeID' with the stored key value 'onboardingTypeID1'
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                        | value               |
      | OnboardingTypeDescription                  | Hidden Leaf Village |
      | LowRiskIDPalProfileType                    |                 632 |
      | StandardRiskIDPalProfileType               |                 632 |
      | HighRiskIDPalProfileType                   |                 632 |
      | VeryHighRiskIDPalProfileType               |                 632 |
      | LowRiskOnboardingApprovalType              |                   0 |
      | StandardRiskOnboardingApprovalType         |                   0 |
      | HighRiskOnboardingApprovalType             |                   0 |
      | VeryHighRiskOnboardingApprovalType         |                   0 |
      | ClientBrandingID                           |                   0 |
      | LowRiskCriteriaID                          |                 185 |
      | StandardRiskCriteriaID                     |                 185 |
      | HighRiskCriteriaID                         |                 185 |
      | VeryHighRiskCriteriaID                     |                 185 |
      | LowRiskClientEntityRiskID                  |                 133 |
      | StandardRiskClientEntityRiskID             |                 133 |
      | HighRiskClientEntityRiskID                 |                 133 |
      | VeryHighRiskClientEntityRiskID             |                 133 |
      | ExcludeOnboardingStageDataCollection       | false               |
      | ExcludeOnboardingStageDataApproval         | false               |
      | ExcludeOnboardingStageIdentityVerification | false               |
      | ExcludeOnboardingStageIdentityApproval     | false               |
      | ExcludeOnboardingStageScreening            | false               |
      | ExcludeOnboardingStageComplianceApproval   | false               |
      | NomineeDataCollectionType                  |                   0 |
      | ExternalProspectAutosendEmailTemplateID    |                   0 |
      | EmailAlertDisabled                         | true                |
      | LeadProspectApprovalType                   |                   0 |
      | KYBPersonProspectOnboardingTypeID          |                   0 |
      | KYBPersonProspectEmailTemplateID           |                   0 |
      | KYBCorporateProspectOnboardingTypeID       |                   0 |
      | KYBCorporateProspectEmailTemplateID        |                   0 |
      | DataCollectionWelcomeMessage               | hello               |
      | TermsAndConditionsEnabled                  | false               |
      | TermsAndConditionsMessage                  | not enabled         |
      | ConfirmationMessageEnabled                 | false               |
      | ConfirmationMessage                        | true                |
      | VerificationMessageEnabled                 | false               |
      | RiskModelType                              |                   0 |
      | SnapshotType                               |                   0 |
      | LowWeightedRiskScoreUpperLimit             |                  25 |
      | StandardWeightedRiskScoreUpperLimit        |                  50 |
      | HighWeightedRiskScoreUpperLimit            |                  75 |
      | VeryHighWeightedRiskScoreUpperLimit        |                 100 |
      | LowRiskCriteriaName                        | Entity              |
      | StandardRiskCriteriaName                   | Entity              |
      | HighRiskCriteriaName                       | Entity              |
      | VeryHighRiskCriteriaName                   | Entity              |
      | AllowKYBLookup                             | false               |
      | TotalPossibleRiskScore                     |                 0 |
    And response body should match the schema from the file "onboardingTypes"
    And response body should have key 'OnboardingTypeName' with the stored key value 'onboardingTypeNameUpdate1'
    And response body should have key 'OnboardingTypeID' with the stored key value 'onboardingTypeID1'

  Scenario: 011 Should be able to delete Onboarding type
    Given user has a service named "/api/v1/static/onboardingtype/delete"
    And user has a query params from the file 'onboardingTypes' with selected keys 'ActionUserID,ReturnFormat'
    And user add query parameter "OnboardingTypeID" with the stored key value "onboardingTypeID1"
    When user sends a 'DELETE' request
    Then response status should be 200

  Scenario: 012 Should be able to add Onboarding type with LiveAVM criteria
    Given user is authorized using an 'ALIASAPIKEY'
    And user has a service named "/api/v1/static/onboardingtype/add"
    And user has a payload from the file 'preScreeningOnboardingTypes'
    And user store the unique value for key:
      | key                            |
      | preScreeningOnboardingTypeName |
    And user add payload key with stored key value:
      | payloadKey         | storedkey                      |
      | OnboardingTypeName | preScreeningOnboardingTypeName |
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                        | value                                        |
      | OnboardingTypeDescription                  | preScreeningLiveAVM                          |
      | LowRiskIDPalProfileType                    |                                            0 |
      | StandardRiskIDPalProfileType               |                                            0 |
      | HighRiskIDPalProfileType                   |                                            0 |
      | VeryHighRiskIDPalProfileType               |                                            0 |
      | LowRiskOnboardingApprovalType              |                                            0 |
      | StandardRiskOnboardingApprovalType         |                                            0 |
      | HighRiskOnboardingApprovalType             |                                            0 |
      | VeryHighRiskOnboardingApprovalType         |                                            0 |
      | ClientBrandingID                           |                                            0 |
      | LowRiskCriteriaID                          |                                          202 |
      | StandardRiskCriteriaID                     |                                          202 |
      | HighRiskCriteriaID                         |                                          202 |
      | VeryHighRiskCriteriaID                     |                                          202 |
      | LowRiskClientEntityRiskID                  |                                          143 |
      | StandardRiskClientEntityRiskID             |                                          143 |
      | HighRiskClientEntityRiskID                 |                                          143 |
      | VeryHighRiskClientEntityRiskID             |                                          143 |
      | ExcludeOnboardingStageDataCollection       | false                                        |
      | ExcludeOnboardingStageDataApproval         | false                                        |
      | ExcludeOnboardingStageIdentityVerification | false                                        |
      | ExcludeOnboardingStageIdentityApproval     | false                                        |
      | ExcludeOnboardingStageScreening            | false                                        |
      | ExcludeOnboardingStageComplianceApproval   | false                                        |
      | NomineeDataCollectionType                  |                                            0 |
      | ExternalProspectAutosendEmailTemplateID    |                                            0 |
      | EmailAlertDisabled                         | true                                         |
      | LeadProspectApprovalType                   |                                            0 |
      | KYBPersonProspectOnboardingTypeID          |                                            0 |
      | KYBPersonProspectEmailTemplateID           |                                            0 |
      | KYBCorporateProspectOnboardingTypeID       |                                            0 |
      | KYBCorporateProspectEmailTemplateID        |                                            0 |
      | DataCollectionWelcomeMessage               | hello                                        |
      | TermsAndConditionsEnabled                  | false                                        |
      | TermsAndConditionsMessage                  | not enabled                                  |
      | ConfirmationMessageEnabled                 | false                                        |
      | ConfirmationMessage                        | true                                         |
      | VerificationMessageEnabled                 | false                                        |
      | RiskModelType                              |                                            0 |
      | SnapshotType                               |                                            0 |
      | LowWeightedRiskScoreUpperLimit             |                                           25 |
      | StandardWeightedRiskScoreUpperLimit        |                                           50 |
      | HighWeightedRiskScoreUpperLimit            |                                           75 |
      | VeryHighWeightedRiskScoreUpperLimit        |                                          100 |
      | LowRiskCriteriaName                        | STGLOADTEST-WLWP Disable-Automation - Person |
      | StandardRiskCriteriaName                   | STGLOADTEST-WLWP Disable-Automation - Person |
      | HighRiskCriteriaName                       | STGLOADTEST-WLWP Disable-Automation - Person |
      | VeryHighRiskCriteriaName                   | STGLOADTEST-WLWP Disable-Automation - Person |
      | AllowKYBLookup                             | false                                        |
      | TotalPossibleRiskScore                     |                                            0 |
      | LowRiskAVMCriteriaID                       |                                         1220 |
      | StandardRiskAVMCriteriaID                  |                                         1220 |
      | HighRiskAVMCriteriaID                      |                                         1220 |
      | VeryHighRiskAVMCriteriaID                  |                                         1220 |
    And response body should match the schema from the file "preScreeningOnboardingTypes"
    And response body should have key 'OnboardingTypeName' with the stored key value 'preScreeningOnboardingTypeName'
    When user store the response body keyData:"OnboardingTypeID" with keyName:"preScreeningOnboardingTypeID"

  Scenario: 013 Should be able to get onboarding Type details with LiveAVM criteria
    Given user is authorized using an 'ALIASAPIKEY'
    And user has a service named "/api/v1/static/onboardingtype/get"
    And user has a query params from the file "preScreeningOnboardingTypes" with selected keys "ReturnFormat,IncludeDataCollectionLogo"
    And user add query parameter "OnboardingTypeID" with the stored key value "preScreeningOnboardingTypeID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                        | value                                        |
      | OnboardingTypeDescription                  | preScreeningLiveAVM                          |
      | LowRiskIDPalProfileType                    |                                            0 |
      | StandardRiskIDPalProfileType               |                                            0 |
      | HighRiskIDPalProfileType                   |                                            0 |
      | VeryHighRiskIDPalProfileType               |                                            0 |
      | LowRiskOnboardingApprovalType              |                                            0 |
      | StandardRiskOnboardingApprovalType         |                                            0 |
      | HighRiskOnboardingApprovalType             |                                            0 |
      | VeryHighRiskOnboardingApprovalType         |                                            0 |
      | ClientBrandingID                           |                                            0 |
      | LowRiskCriteriaID                          |                                          202 |
      | StandardRiskCriteriaID                     |                                          202 |
      | HighRiskCriteriaID                         |                                          202 |
      | VeryHighRiskCriteriaID                     |                                          202 |
      | LowRiskClientEntityRiskID                  |                                          143 |
      | StandardRiskClientEntityRiskID             |                                          143 |
      | HighRiskClientEntityRiskID                 |                                          143 |
      | VeryHighRiskClientEntityRiskID             |                                          143 |
      | ExcludeOnboardingStageDataCollection       | false                                        |
      | ExcludeOnboardingStageDataApproval         | false                                        |
      | ExcludeOnboardingStageIdentityVerification | false                                        |
      | ExcludeOnboardingStageIdentityApproval     | false                                        |
      | ExcludeOnboardingStageScreening            | false                                        |
      | ExcludeOnboardingStageComplianceApproval   | false                                        |
      | NomineeDataCollectionType                  |                                            0 |
      | ExternalProspectAutosendEmailTemplateID    |                                            0 |
      | EmailAlertDisabled                         | true                                         |
      | LeadProspectApprovalType                   |                                            0 |
      | KYBPersonProspectOnboardingTypeID          |                                            0 |
      | KYBPersonProspectEmailTemplateID           |                                            0 |
      | KYBCorporateProspectOnboardingTypeID       |                                            0 |
      | KYBCorporateProspectEmailTemplateID        |                                            0 |
      | DataCollectionWelcomeMessage               | hello                                        |
      | TermsAndConditionsEnabled                  | false                                        |
      | TermsAndConditionsMessage                  | not enabled                                  |
      | ConfirmationMessageEnabled                 | false                                        |
      | ConfirmationMessage                        | true                                         |
      | VerificationMessageEnabled                 | false                                        |
      | RiskModelType                              |                                            0 |
      | SnapshotType                               |                                            0 |
      | LowWeightedRiskScoreUpperLimit             |                                           25 |
      | StandardWeightedRiskScoreUpperLimit        |                                           50 |
      | HighWeightedRiskScoreUpperLimit            |                                           75 |
      | VeryHighWeightedRiskScoreUpperLimit        |                                          100 |
      | LowRiskCriteriaName                        | STGLOADTEST-WLWP Disable-Automation - Person |
      | StandardRiskCriteriaName                   | STGLOADTEST-WLWP Disable-Automation - Person |
      | HighRiskCriteriaName                       | STGLOADTEST-WLWP Disable-Automation - Person |
      | VeryHighRiskCriteriaName                   | STGLOADTEST-WLWP Disable-Automation - Person |
      | AllowKYBLookup                             | false                                        |
      | TotalPossibleRiskScore                     |                                            0 |
      | LowRiskAVMCriteriaID                       |                                         1220 |
      | StandardRiskAVMCriteriaID                  |                                         1220 |
      | HighRiskAVMCriteriaID                      |                                         1220 |
      | VeryHighRiskAVMCriteriaID                  |                                         1220 |
    And response body should match the schema from the file "preScreeningOnboardingTypes"
    And response body should have key 'OnboardingTypeName' with the stored key value 'preScreeningOnboardingTypeName'
    And response body should have key 'OnboardingTypeID' with the stored key value 'preScreeningOnboardingTypeID'

  Scenario: 014 Should be able to update Onboarding Type details with LiveAVM criteria
    Given user is authorized using an 'ALIASAPIKEY'
    And user has a service named "/api/v1/static/onboardingtype/update"
    And user has a payload from the file "preScreeningOnboardingTypes"
    And user store the unique value for key:
      | key                                  |
      | preScreeningOnboardingTypeNameUpdate |
    And user add payload key with stored key value:
      | payloadKey         | storedkey                            |
      | OnboardingTypeName | preScreeningOnboardingTypeNameUpdate |
    And user has payloads:
      """
      {
        "LowRiskAVMCriteriaID":"1231",
        "StandardRiskAVMCriteriaID":"1231",
        "HighRiskAVMCriteriaID":"1231",
        "VeryHighRiskAVMCriteriaID":"1231"
      }
      """
    And user add payload 'OnboardingTypeID' with the stored key value 'preScreeningOnboardingTypeID'
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                        | value                                        |
      | OnboardingTypeDescription                  | preScreeningLiveAVM                          |
      | LowRiskIDPalProfileType                    |                                            0 |
      | StandardRiskIDPalProfileType               |                                            0 |
      | HighRiskIDPalProfileType                   |                                            0 |
      | VeryHighRiskIDPalProfileType               |                                            0 |
      | LowRiskOnboardingApprovalType              |                                            0 |
      | StandardRiskOnboardingApprovalType         |                                            0 |
      | HighRiskOnboardingApprovalType             |                                            0 |
      | VeryHighRiskOnboardingApprovalType         |                                            0 |
      | ClientBrandingID                           |                                            0 |
      | LowRiskCriteriaID                          |                                          202 |
      | StandardRiskCriteriaID                     |                                          202 |
      | HighRiskCriteriaID                         |                                          202 |
      | VeryHighRiskCriteriaID                     |                                          202 |
      | LowRiskClientEntityRiskID                  |                                          143 |
      | StandardRiskClientEntityRiskID             |                                          143 |
      | HighRiskClientEntityRiskID                 |                                          143 |
      | VeryHighRiskClientEntityRiskID             |                                          143 |
      | ExcludeOnboardingStageDataCollection       | false                                        |
      | ExcludeOnboardingStageDataApproval         | false                                        |
      | ExcludeOnboardingStageIdentityVerification | false                                        |
      | ExcludeOnboardingStageIdentityApproval     | false                                        |
      | ExcludeOnboardingStageScreening            | false                                        |
      | ExcludeOnboardingStageComplianceApproval   | false                                        |
      | NomineeDataCollectionType                  |                                            0 |
      | ExternalProspectAutosendEmailTemplateID    |                                            0 |
      | EmailAlertDisabled                         | true                                         |
      | LeadProspectApprovalType                   |                                            0 |
      | KYBPersonProspectOnboardingTypeID          |                                            0 |
      | KYBPersonProspectEmailTemplateID           |                                            0 |
      | KYBCorporateProspectOnboardingTypeID       |                                            0 |
      | KYBCorporateProspectEmailTemplateID        |                                            0 |
      | DataCollectionWelcomeMessage               | hello                                        |
      | TermsAndConditionsEnabled                  | false                                        |
      | TermsAndConditionsMessage                  | not enabled                                  |
      | ConfirmationMessageEnabled                 | false                                        |
      | ConfirmationMessage                        | true                                         |
      | VerificationMessageEnabled                 | false                                        |
      | RiskModelType                              |                                            0 |
      | SnapshotType                               |                                            0 |
      | LowWeightedRiskScoreUpperLimit             |                                           25 |
      | StandardWeightedRiskScoreUpperLimit        |                                           50 |
      | HighWeightedRiskScoreUpperLimit            |                                           75 |
      | VeryHighWeightedRiskScoreUpperLimit        |                                          100 |
      | LowRiskCriteriaName                        | STGLOADTEST-WLWP Disable-Automation - Person |
      | StandardRiskCriteriaName                   | STGLOADTEST-WLWP Disable-Automation - Person |
      | HighRiskCriteriaName                       | STGLOADTEST-WLWP Disable-Automation - Person |
      | VeryHighRiskCriteriaName                   | STGLOADTEST-WLWP Disable-Automation - Person |
      | AllowKYBLookup                             | false                                        |
      | TotalPossibleRiskScore                     |                                            0 |
      | LowRiskAVMCriteriaID                       |                                         1231 |
      | StandardRiskAVMCriteriaID                  |                                         1231 |
      | HighRiskAVMCriteriaID                      |                                         1231 |
      | VeryHighRiskAVMCriteriaID                  |                                         1231 |
    And response body should match the schema from the file "preScreeningOnboardingTypes"
    And response body should have key 'OnboardingTypeName' with the stored key value 'preScreeningOnboardingTypeNameUpdate'
    And response body should have key 'OnboardingTypeID' with the stored key value 'preScreeningOnboardingTypeID'

  Scenario: 015 Should be able to delete pre screening Onboarding type
    Given user is authorized using an 'ALIASAPIKEY'
    And user has a service named "/api/v1/static/onboardingtype/delete"
    And user has a query params from the file 'preScreeningOnboardingTypes' with selected keys 'ActionUserID,ReturnFormat'
    And user add query parameter "OnboardingTypeID" with the stored key value "preScreeningOnboardingTypeID"
    When user sends a 'DELETE' request
    Then response status should be 200