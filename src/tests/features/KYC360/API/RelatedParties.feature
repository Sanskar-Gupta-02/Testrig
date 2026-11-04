@RelatedParties
Feature: Related parties

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Retrieve prospect group settings with valid parameters #ENG-T13828
    Given user has a service named '/api/v1/prospectgroupprospectsettings/GetSettings'
    And user has a query params from the file 'RelatedParties' with selected keys 'clientProspectGroupId,pageIndex,pageSize'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body have key with the value for nested object:
      | key                          | value     |
      | ClientProspectGroupId        |      1408 |
      | Items[0].AllowManageProspect | true      |
      | Items[0].ClientProspectId    |    616062 |
      | Items[0].FirstName           |           |
      | Items[0].IsHiddenExternally  | false     |
      | Items[0].IsIntermediary      | true      |
      | Items[0].LastName            | LeadParty |
      | Items[0].MiddleName          |           |
      | Items[0].SettingId           |       111 |
      | Items[1].AllowManageProspect | true      |
      | Items[1].ClientProspectId    |    616063 |
      | Items[1].FirstName           |           |
      | Items[1].IsHiddenExternally  | false     |
      | Items[1].IsIntermediary      | false     |
      | Items[1].LastName            | party1    |
      | Items[1].MiddleName          |           |
      | Items[1].SettingId           |         0 |
      | Items[2].AllowManageProspect | true      |
      | Items[2].ClientProspectId    |    616064 |
      | Items[2].FirstName           |           |
      | Items[2].IsHiddenExternally  | false     |
      | Items[2].IsIntermediary      | false     |
      | Items[2].LastName            | party2    |
      | Items[2].MiddleName          |           |
      | Items[2].SettingId           |         0 |
      | PageIndex                    |         1 |
      | PageSize                     |        20 |
      | TotalCount                   |         3 |
    And response body should match the schema from the file "RelatedParties"

  Scenario: 002 Get Prospect Group Settings with missing required parameter #ENG-T13829
    Given user has a service named '/api/v1/prospectgroupprospectsettings/GetSettings'
    And user has query parameters:
      """
      {
       "clientProspectGroupId":"",
        "pageIndex": 1,
        "pageSize": 20
      }
      """
    When user sends a 'GET' request
    Then response status should be 400
    And response body should have key with the value:
      | key     | value                   |
      | Message | The request is invalid. |

  Scenario: 003 Get All Related Party Items successfully #ENG-T13830
    Given user has a service named '/api/v1/prospectgroupprospectsettings/GetAllRelatedPartyItems'
    And user has a query params from the file 'RelatedPartiesGetAll' with selected keys 'clientProspectGroupId,businessUnitId'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "RelatedPartiesGetAll"
    And response body should match the schema from the file "RelatedPartiesGetAll"

  Scenario: 004 Verify if a prospect is an intermediary #ENG-T13831
    Given user has a service named '/api/v1/prospectgroupprospectsettings/IsProspectIntermediary'
    And user has a query params from the file 'RelatedPartiesCheck' with selected keys 'clientProspectId,ReturnFormat'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body have key with the value for nested object:
      | key                   | value          |
      | IsIntermediary        | true           |
      | ProspectGroupNames[0] | Relatedparties |
    And response body should match the schema from the file "RelatedPartiesCheck"

  Scenario: 005 Verify if a prospect is not an intermediary #ENG-T13831
    Given user has a service named '/api/v1/prospectgroupprospectsettings/IsProspectIntermediary'
    And user has query parameters:
      """
      {
       "clientProspectId": "616063",
        "ReturnFormat": "json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                | value |
      | IsIntermediary     | false |
      | ProspectGroupNames | []    |
    And response body should match the schema from the file "RelatedPartiesCheck"

  Scenario: 006 Update prospect setting with valid data #ENG-T13832
    Given user has a service named '/api/v1/prospectgroupprospectsettings/UpdateSettings'
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "ClientProspectGroupId": 1416,
      "Settings": [
      {
      "ClientProspectId": 616204,
      "IsIntermediary": false,
       "IsHiddenExternally": false
      },
      {
      "ClientProspectId": 616205,
      "IsIntermediary": false,
      "IsHiddenExternally": false
      }
      ]
      }
      """
    When user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "RelatedPartiesGroupSetting"
    #Revert Data
    Given user has a service named '/api/v1/prospectgroupprospectsettings/UpdateSettings'
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "ClientProspectGroupId": 1416,
      "Settings": [
      {
      "ClientProspectId": 616204,
      "IsIntermediary": false,
       "IsHiddenExternally": true
      },
      {
      "ClientProspectId": 616205,
      "IsIntermediary": true,
      "IsHiddenExternally": false
      }
      ]
      }
      """
    When user sends a 'POST' request
    Then response status should be 200

  Scenario: 007 Update prospect setting with invalid data #ENG-T13833,T13837
    Given user has a service named '/api/v1/prospectgroupprospectsettings/UpdateSettings'
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "ClientProspectGroupId": 1416,
      "Settings": [
      {
      "ClientProspectId": 616204,
      "IsIntermediary": true,
       "IsHiddenExternally": true
      },
      {
      "ClientProspectId": 616205,
      "IsIntermediary": false,
      "IsHiddenExternally": false
      }
      ]
      }
      """
    When user sends a 'POST' request
    Then response status should be 400

  Scenario: 008 verify prospect can submit data #ENG-T13834
    Given user has a service named '/api/v1/prospectgroupprospectsettings/CheckCanSubmit'
    And user has a query params from the file 'RelatedPartiesCheckSubmission' with selected keys 'clientProspectId,clientProspectGroupId'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body have key with the value for nested object:
      | key                                  | value  |
      | CanSubmit                            | false  |
      | IsIntermediary                       | true   |
      | PendingProspects[0].ClientProspectId | 616063 |
      | PendingProspects[0].FirstName        |        |
      | PendingProspects[0].LastName         | party1 |
      | PendingProspects[1].ClientProspectId | 616064 |
      | PendingProspects[1].FirstName        |        |
      | PendingProspects[1].LastName         | party2 |
    And response body should match the schema from the file "RelatedPartiesCheckSubmission"

  Scenario: 009 verify prospect can submit data without any OB created #ENG-T13834
    Given user has a service named '/api/v1/prospectgroupprospectsettings/CheckCanSubmit'
    And user has query parameters:
      """
      {
       "clientProspectGroupId": 1416,
        "clientProspectId": 616205
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key              | value |
      | CanSubmit        | true  |
      | IsIntermediary   | true  |
      | PendingProspects | []    |
    And response body should match the schema from the file "RelatedPartiesCheckSubmission"

  Scenario: 010 verify prospect can submit data for non-intermediaries with OB created  #ENG-T13834
    Given user has a service named '/api/v1/prospectgroupprospectsettings/CheckCanSubmit'
    And user has query parameters:
      """
      {
       "clientProspectGroupId": 1408,
        "clientProspectId": 616064
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key              | value |
      | CanSubmit        | true  |
      | IsIntermediary   | false |
      | PendingProspects | []    |
    And response body should match the schema from the file "RelatedPartiesCheckSubmission"

  Scenario: 011 Verify data collection link generated successfully #ENG-T13835
    Given user has a service named '/api/v1/prospectgroupprospectsettings/GenerateIntermediaryDataCollectionLink'
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "BusinessUnitID":10,
      "ClientProspectID":616220,
      "ClientOnboardingID":354460,
      "DataRequestID":"e7df741a-f77a-4620-96dc-d11776fa6c29",
      "ActionUserID":547,
      "IntermediaryId":616220,
      "ProspectGroupId":1420,
      "Email":"testautomations+supervisor2@riskscreen.com",
      "UpdateDataRequestedOn":true
      }
      """
    When user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should contains "https://app-rs-sh-qa-dcf-frc1-001.ase-rs-app-dev-ase-frc1-001.appserviceenvironment.net/login?"
   
