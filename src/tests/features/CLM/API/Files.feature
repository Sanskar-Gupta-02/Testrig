@Regression @CLM @Files
Feature: API - Files

  Background:
    Given user is authorized using an "BEARER1"

  Scenario: 001 Create an Entity for Files
    When user has a service named "/clm/draft/entities"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "entityTypeId": "<CLM_ENTITY_TYPE_FILE_ID>",
      "fields": [
      {
                "value": "Entity for File API Automation",
                "key": "entity.metadata.entityName"
            },
            {
                "value": "END_CLIENT",
                "key": "entity.metadata.entityRole"
            }
      ]
      }
      """
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    When user store the response body have keyData with keyName
      | key | storeKey |
      | id  | EntityID |

  Scenario: 002 Add BU with File to the Created Entity
    When user has a service named "/clm/draft/entities/<EntityID>/businessunits/"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "businessUnitId": "<CLM_BU_AUTOMATION_ID>",
      "workflow": {
      "comment": "test"
      },
      "fields": [
      {
      
      "key": "bu.data.templateforfileapi.apiautomationfiles",
      "value": [
                {
                    "fileName": "ListCountries.pdf"
                }
            ]
      }
      ]
      }
      """
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    When user store the response body have keyData with keyName
      | key                          | storeKey  |
      | fields[0].value[0].uploadUrl | uploadURL |

  Scenario: 003 Verify the Uploaded File in UI
    And user uploads file with stored url "uploadURL":
      | file              |
      | ListCountries.pdf |
    Then response status should be 204

  Scenario: 004 Update BU for the Entity #ENG-T9429
    When user has a service named "/clm/draft/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>/submit"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
          "skipFourEyes": true
      }
      """
    And user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value    |
      | workflow.state | Approved |

  Scenario: 005 GET call returns Entity BU data with file field #ENG-T12361,T12362
    When user has a service named "/clm/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>"
    And user has header "Content-Type":"application/json"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body have key with the value for nested object:
      | key                         | value             |
      | fields[0].value[0].fileName | ListCountries.pdf |
    When user store the response body have keyData with keyName
      | key                   | storeKey       |
      | fields[0].value[0].id | uploadedFileID |

  Scenario: 006 Delete call to remove the file from the Entity BU #ENG-T12366
    When user has a service named "/clm/draft/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads with dynamic values:
      """
      {
      "fields": [
      {
      "key": "bu.data.templateforfileapi.apiautomationfiles",
      "value": [
       {
         "id": "{{uploadedFileID}}",
         "remove": true
       }]
      }]
      }
      """
    And user sends a 'PUT' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body have key with the value for nested object:
      | key             | value |
      | fields[0].value | []    |

  Scenario: 007 Delete call to remove the file from the Entity BU That Does Not Have the File #ENG-T12367
    When user has a service named "/clm/draft/entities/<EntityID>/businessunits/<CLM_BU_AUTOMATION_ID>"
    And user has header "Content-Type":"application/json"
    And user has raw payloads with dynamic values:
      """
      {
      "fields": [
      {
      "key": "bu.data.templateforfileapi.apiautomationfiles",
      "value": [
       {
         "id": "{{uploadedFileID}}",
         "remove": true
       }]
      }]
      }
      """
    And user sends a 'PUT' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
