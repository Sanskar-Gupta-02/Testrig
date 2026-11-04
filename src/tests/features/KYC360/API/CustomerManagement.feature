@Regression @CustomerManagement
Feature: Customer Management API

  Background:
    Given user is authorized using an 'ALIASAPIKEY'

  Scenario: 001 Non Default BU - API Move to Business Unit from Non-default BU to Default BU.#ENG-T12601
    Given user has a service named "/api/v1/client/entity/move"
    And user has a payload from the file 'CustomerManagement'
    When user sends a 'POST' request
    Then response status should be 200
    And response body should have key with the value:
      | key                          | value                                        |
      | ClientEntityID               |                                       447845 |
      | InterfaceReference           | BENFICA                                      |
      | LastName                     | MOVEAPITEST                                  |
      | CriteriaID                   |                                          202 |
      | CriteriaName                 | STGLOADTEST-WLWP Disable-Automation - Person |
      | GenderID                     |                                            9 |
      | GenderName                   | Unknown                                      |
      | Date                         | null                                         |
      | Country1ID                   |                                            0 |
      | Country1Name                 | Unknown                                      |
      | Country2ID                   |                                            0 |
      | Country2Name                 | Unknown                                      |
      | Country3ID                   |                                            0 |
      | Country3Name                 | Unknown                                      |
      | StatusID                     |                                            0 |
      | StatusName                   | Disabled                                     |
      | DateAdded                    |                          2026-04-10 00:00:00 |
      | BusinessUnitID               |                                           10 |
      | BusinessUnitName             | Default                                      |
      | HandledByUserGroupID         |                                          330 |
      | HandledByUserGroupName       | Admin Group                                  |
      | HandledByUserID              |                                            0 |
      | RiskID                       |                                          144 |
      | RiskName                     | Low                                          |
      | AdverseMediaFileCriteriaID   |                                            0 |
      | AdverseMediaDateRangeID      |                                            7 |
      | AdverseMediaCountryID        |                                           -1 |
      | AdverseMediaDateLastScreened | null                                         |
    And response body should match the schema from the file "CustomerManagement"
    #Data Revert
    And user has payloads:
      """
      {
      "SourceBusinessUnitID": "10",
      "DestinationBusinessUnitID":"11",
      "ReassignmentUserGroupID":"331"
      }
      """
    When user sends a 'POST' request
    Then response status should be 200
    And response body should have key with the value:
      | key                    | value         |
      | BusinessUnitID         |            11 |
      | BusinessUnitName       | Transfer      |
      | HandledByUserGroupID   |           331 |
      | HandledByUserGroupName | Handler Group |
