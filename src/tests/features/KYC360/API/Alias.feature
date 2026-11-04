@Regression @Alias
Feature: Client Alias API

  Background:
    Given user is authorized using an 'ALIASAPIKEY'

  Scenario: 001 Verify BULK UPDATE STATUS fails for invalid payload structure #ENG-T11526
    Given user has a service named "/api/v1/client/entity/bulkupdatestatus"
    And user has header "Content-Type":"application/json"
    And user has query parameter "BusinessUnitID":"10"
    And user has query parameter "ActionUserID":"524"
    And user has query parameter "ReturnFormat":"Json"
    And user has raw payloads:
      """
      	[ {
        "InterfaceReference": "APIImportIncludeHandledByInfo",
        "Status": ""
      },
        {
        "InterfaceReference": "",
        "Status": "APIImportMigrate"
      } ]
      """
    When user sends a 'PUT' request
    Then response status should be 406
    And response header should be 'content-type':'application/json; charset=utf-8'

  Scenario: 002 Verify BULK UPDATE STATUS fails partially if some references are invalid #ENG-T11524,T11525,T11523
    Given user has a service named "/api/v1/client/entity/bulkupdatestatus"
    And user has header "Content-Type":"application/json"
    And user has query parameter "BusinessUnitID":"10"
    And user has query parameter "ActionUserID":"524"
    And user has query parameter "ReturnFormat":"Json"
    And user has raw payloads:
      """
      	[{
        "InterfaceReference": "API0001",
        "Status": "0"
      } ,
      {
        "InterfaceReference": "AAPI001",
        "Status": "0"
      } ,
      {
        "InterfaceReference": "AAPI002",
        "Status": "0"
      } ,
      {
        "InterfaceReference": "RANDOMREFERENCE",
        "Status": "1"
      }]
      """
    When user sends a 'PUT' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                 | value |
      | TotalItemsProcessed |     4 |
      | ItemsUpdated        |     3 |
    And response body in ascending order should have index key with the contains value:
      | index | key                           | value                                  |
      |     1 | Rejections.InterfaceReference | RANDOMREFERENCE                        |
      |     1 | Rejections.Status             |                                      1 |
      |     1 | Rejections.Reason             | Interface Reference could not be found |

  Scenario: 003 Verify BULK UPDATE STATUS supports both entity and alias references for non-default BU #ENG-T11878
    Given user has a service named "/api/v1/client/entity/bulkupdatestatus"
    And user has header "Content-Type":"application/json"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "ActionUserID":"524"
    And user has query parameter "ReturnFormat":"Json"
    And user has raw payloads:
      """
      	[{
        "InterfaceReference": "NBAPI001",
        "Status": "0"
      } ,
      {
        "InterfaceReference": "NBAAPI001",
        "Status": "0"
      } ,
      {
        "InterfaceReference": "NAAPI002",
        "Status": "0"
      }]
      """
    When user sends a 'PUT' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And user has header "Content-Type":"application/json"
    And response body should have key with the value:
      | key                 | value |
      | TotalItemsProcessed |     3 |
      | ItemsUpdated        |     3 |

  Scenario: 004 Verify unauthorized user cannot call UPDATE ALIAS STATUS #ENG-T11522
    Given user has a service named "/api/v1/client/entity/updatealiasstatus"
    And user has payloads:
      """
      {
      "ActionUserID":632,
      "BusinessUnitID":10,
      "ParentInterfaceReference":"API0001",
      "InterfaceReference":"AAPI001",
      "Status":0,
      "ReturnFormat":"Json"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 400
    And response header should be 'content-type':'text/plain; charset=utf-8'

  Scenario: 005 Verify UPDATE ALIAS STATUS endpoint exists and is accessible for non-default BU #ENG-T11613
    Given user has a service named "/api/v1/client/entity/updatealiasstatus"
    And user has payloads:
      """
      {
      "ActionUserID":524,
      "BusinessUnitID":11,
      "ParentInterfaceReference":"NBAPI001",
      "InterfaceReference":"NBAAPI001",
      "Status":1,
      "ReturnFormat":"Json"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                  | value     |
      | ClientEntityID       |       462 |
      | InterfaceReference   | NBAAPI001 |
      | ParentClientEntityId |    447881 |
      | StatusID             |         1 |

  Scenario: 006 Verify UPDATE ALIAS STATUS fails for invalid alias reference #ENG-T11520
    Given user has a service named "/api/v1/client/entity/updatealiasstatus"
    And user has payloads:
      """
      {
      "ActionUserID":524,
      "BusinessUnitID":10,
      "ParentInterfaceReference":"API0001",
      "InterfaceReference":"NBAAPI001",
      "Status":0,
      "ReturnFormat":"Json"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 406
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key     | value                                                           |
      | Message | Entity/Alias with according interface references does not exist |

  Scenario: 007 Verify UPDATE ALIAS STATUS INTERNAL endpoint exists and is accessible #ENG-T11519
    Given user has a service named "/api/v1/client/entity/updatealiasstatusinternal"
    And user has payloads:
      """
      {
      "ActionUserID":524,
      "BusinessUnitID":10,
      "ParentClientEntityId":447882,
      "ClientEntityId":464,
      "Status":1,
      "ReturnFormat":"Json"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                  | value   |
      | ClientEntityID       |     464 |
      | InterfaceReference   | AAPI001 |
      | ParentClientEntityId |  447882 |
      | StatusID             |       1 |

  Scenario: 008 Verify UPDATE ALIAS STATUS INTERNAL endpoint exists and is accessible for non-default BU #ENG-T11877
    Given user has a service named "/api/v1/client/entity/updatealiasstatusinternal"
    And user has payloads:
      """
      {
      "ActionUserID":524,
      "BusinessUnitID":11,
      "ParentClientEntityId":447881,
      "ClientEntityId":462,
      "Status":1,
      "ReturnFormat":"Json"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                  | value     |
      | ClientEntityID       |       462 |
      | InterfaceReference   | NBAAPI001 |
      | ParentClientEntityId |    447881 |
      | StatusID             |         1 |

  Scenario: 009 Verify BULK UPDATE STATUS fails partially if some references are invalid #ENG-T11524,T11525,T11523
    Given user has a service named "/api/v1/client/entity/bulkupdatestatus"
    And user has header "Content-Type":"application/json"
    And user has query parameter "BusinessUnitID":"10"
    And user has query parameter "ActionUserID":"524"
    And user has query parameter "ReturnFormat":"Json"
    And user has raw payloads:
      """
      	[{
        "InterfaceReference": "API0001",
        "Status": "1"
      } ,
      {
        "InterfaceReference": "AAPI001",
        "Status": "1"
      } ,
      {
        "InterfaceReference": "AAPI002",
        "Status": "1"
      }]
      """
    When user sends a 'PUT' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                 | value |
      | TotalItemsProcessed |     3 |
      | ItemsUpdated        |     3 |

  Scenario: 010 Verify BULK UPDATE STATUS supports both entity and alias references for non-default BU #ENG-T11878
    Given user has a service named "/api/v1/client/entity/bulkupdatestatus"
    And user has header "Content-Type":"application/json"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "ActionUserID":"524"
    And user has query parameter "ReturnFormat":"Json"
    And user has raw payloads:
      """
      	[{
        "InterfaceReference": "NBAPI001",
        "Status": "1"
      } ,
      {
        "InterfaceReference": "NBAAPI001",
        "Status": "1"
      } ,
      {
        "InterfaceReference": "NAAPI002",
        "Status": "1"
      }]
      """
    When user sends a 'PUT' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                 | value |
      | TotalItemsProcessed |     3 |
      | ItemsUpdated        |     3 |

  Scenario: 011 Non Default BU - API Customer Management-Search Alias based on interface reference. #ENG-T12598
    Given user has a service named "/api/v1/client/entity/get"
    And user has header "Content-Type":"application/json"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "InterfaceReference":"BU001"
    And user has query parameter "ReturnFormat":"Json"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value within array :
      | key                                      | value                                        |
      | ClientEntityID                           |                                       447883 |
      | InterfaceReference                       | BU001                                        |
      | LastName                                 | TRANSFER                                     |
      | FirstName                                |                                              |
      | MiddleName                               |                                              |
      | CriteriaID                               |                                          202 |
      | CriteriaName                             | STGLOADTEST-WLWP Disable-Automation - Person |
      | GenderID                                 |                                            9 |
      | GenderName                               | Unknown                                      |
      | Date                                     | null                                         |
      | Country1ID                               |                                            0 |
      | Country1Name                             | Unknown                                      |
      | Country2ID                               |                                            0 |
      | Country2Name                             | Unknown                                      |
      | Country3ID                               |                                            0 |
      | Country3Name                             | Unknown                                      |
      | StatusID                                 |                                            0 |
      | StatusName                               | Disabled                                     |
      | DateAdded                                |                          2026-04-14 00:00:00 |
      | CustomText1                              |                                              |
      | CustomText2                              |                                              |
      | BusinessUnitID                           |                                           11 |
      | BusinessUnitName                         | Transfer                                     |
      | HandledByUserGroupID                     |                                          331 |
      | HandledByUserGroupName                   | Handler Group                                |
      | HandledByUserID                          |                                            0 |
      | RiskID                                   |                                          143 |
      | RiskName                                 | Unclassified                                 |
      | AdverseMediaFileCriteriaID               |                                            0 |
      | AdverseMediaDateRangeID                  |                                            7 |
      | AdverseMediaCountryID                    |                                           -1 |
      | AdditionalAndTerms                       |                                              |
      | AdditionalOrTerms                        |                                              |
      | ExcludeTerms                             |                                              |
      | AdverseMediaDateLastScreened             | null                                         |
      | ClientEntityAliases.ClientEntityID       |                                          466 |
      | ClientEntityAliases.InterfaceReference   | BUA001TEST                                   |
      | ClientEntityAliases.LastName             | ALIASTRANSFER                                |
      | ClientEntityAliases.FirstName            |                                              |
      | ClientEntityAliases.MiddleName           |                                              |
      | ClientEntityAliases.CriteriaID           |                                          202 |
      | ClientEntityAliases.CriteriaName         | STGLOADTEST-WLWP Disable-Automation - Person |
      | ClientEntityAliases.GenderID             |                                            9 |
      | ClientEntityAliases.GenderName           | Unknown                                      |
      | ClientEntityAliases.Date                 | null                                         |
      | ClientEntityAliases.Country1ID           |                                            0 |
      | ClientEntityAliases.Country1Name         | Unknown                                      |
      | ClientEntityAliases.Country2ID           |                                            0 |
      | ClientEntityAliases.Country2Name         | Unknown                                      |
      | ClientEntityAliases.Country3ID           |                                            0 |
      | ClientEntityAliases.Country3Name         | Unknown                                      |
      | ClientEntityAliases.StatusID             |                                            1 |
      | ClientEntityAliases.StatusName           | Active                                       |
      | ClientEntityAliases.DateAdded            |                          2026-04-14 00:00:00 |
      | ClientEntityAliases.CustomText1          |                                              |
      | ClientEntityAliases.CustomText2          |                                              |
      | ClientEntityAliases.ParentClientEntityId |                                       447883 |
    And response body should match the schema from the file "Alias"

  Scenario: 012 Non Default BU - API user should not be able to create Duplicate Interface reference. #ENG-T12604
    Given user has a service named "/api/v1/client/entity/addaliasinternal"
    And user has a payload from the file "Alias"
    And user has payload "InterfaceReference":"BU001"
    And user has payload "BusinessUnitID":"11"
    And user has payload "ParentClientEntityId":"448039"
    When user sends a 'POST' request
    Then response status should be 406
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should text contains "Interface Reference BU001 is already associated with an existing Client Entity"

  # Scenario: 013Non Default BU - API- Add Customer Alias for existing client entity(Max 5 alias can be added).#ENG-T12603,T12599
  #   Given user has a service named "/api/v1/client/entity/addaliasinternal"
  #   And user has a payload from the file "Alias"
  #   And user has payloads:
  #     """
  #     {
  #     "ActionUserID":524,
  #     "BusinessUnitID":11,
  #     "InterfaceReference":"AUTOMATIONTESTS12A5",
  #     "ParentClientEntityId":"448039",
  #     "ReturnFormat":"Json"
  #     }
  #     """
  #   When user sends a 'POST' request
  #   Then response status should be 200
  #   And response header should be 'content-type':'application/json; charset=utf-8'
  #   And response body should have key with the value:
  #     | key                  | value                                        |
  #     | InterfaceReference   | AUTOMATIONTESTS12A5                          |
  #     | LastName             | AUTOMATIONTEST                               |
  #     | FirstName            | TEST                                         |
  #     | MiddleName           | TEST                                         |
  #     | CriteriaID           |                                          202 |
  #     | CriteriaName         | STGLOADTEST-WLWP Disable-Automation - Person |
  #     | GenderID             |                                            9 |
  #     | GenderName           | Unknown                                      |
  #     | Date                 | null                                         |
  #     | Country1ID           |                                            0 |
  #     | Country1Name         | Unknown                                      |
  #     | Country2ID           |                                            0 |
  #     | Country2Name         | Unknown                                      |
  #     | Country3ID           |                                            0 |
  #     | Country3Name         | Unknown                                      |
  #     | StatusID             |                                            1 |
  #     | StatusName           | Active                                       |
  #     | DateAdded            |                          2026-02-24 00:00:00 |
  #     | CustomText1          | TEST                                         |
  #     | CustomText2          | TEST                                         |
  #     | ParentClientEntityId |                                       448039 |
  #   And response body should match the schema from the file "AliasCount"
  #   When user has payload "InterfaceReference":"AutoTest"
  #   And user sends a 'POST' request
  #   Then response status should be 406
  #   And response header should be 'content-type':'application/json; charset=utf-8'
  #   And response body should text contains "Maximum Number of Aliases Reached"
  #   When user has a service named "/api/v1/client/entity/deletealias"
  #   And user has a payload from the file "Alias" with selected keys "BusinessUnitID,,ActionUserID,ReturnFormat"
  #   And user has payload "ParentInterfaceReference":"AUTOMATIONTESTS12"
  #   And user has payload "InterfaceReference":"AUTOMATIONTESTS12A5"
  #   And user sends a 'DELETE' request
  #   Then response status should be 200
