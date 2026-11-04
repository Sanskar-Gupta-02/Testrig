@Regression @IdSearch
Feature: ID Based Screening - Create, Retrieve and Delete Customer with ID Details

  Background:
    Given user is authorized using an 'ALIASAPIKEY'

  Scenario: 001 Create Customer with Five ID Pairs and Verify Persistence #ENG-T13198,ENG-T13199,ENG-T13200, ENG-T13201,ENG-T13202,ENG-T14450
    Given user has a service named "/api/v1/client/entity/add"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "AddCustomerWithIds"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                 | value                                        |
      | ClientEntity.InterfaceReference     | IMO_TEST_101                                 |
      | ClientEntity.LastName               | TEST VESSEL                                  |
      | ClientEntity.FirstName              |                                              |
      | ClientEntity.MiddleName             |                                              |
      | ClientEntity.CriteriaID             |                                          203 |
      | ClientEntity.CriteriaName           | STGLOADTEST-WLWP Disable-Automation - Entity |
      | ClientEntity.GenderID               |                                            9 |
      | ClientEntity.GenderName             | Unknown                                      |
      | ClientEntity.StatusID               |                                            1 |
      | ClientEntity.StatusName             | Active                                       |
      | ClientEntity.BusinessUnitID         |                                           10 |
      | ClientEntity.BusinessUnitName       | Default                                      |
      | ClientEntity.HandledByUserGroupID   |                                          330 |
      | ClientEntity.HandledByUserGroupName | Admin Group                                  |
      | ClientEntity.HandledByUserID        |                                          524 |
      | ClientEntity.HandledByUserName      | Akshay Pardeshi (WLWP Disable-Automation)    |
      | ClientEntity.RiskID                 |                                          144 |
      | ClientEntity.RiskName               | Low                                          |
    Then response body have key with the value for nested object:
      | key                                     | value   |
      | ClientEntity.ClientEntityIds[0].IdType  |      34 |
      | ClientEntity.ClientEntityIds[0].IdValue | 9292204 |
      | ClientEntity.ClientEntityIds[1].IdType  |     470 |
      | ClientEntity.ClientEntityIds[1].IdValue |    8405 |
      | ClientEntity.ClientEntityIds[2].IdType  |      18 |
      | ClientEntity.ClientEntityIds[2].IdValue |   87052 |
      | ClientEntity.ClientEntityIds[3].IdType  |     467 |
      | ClientEntity.ClientEntityIds[3].IdValue |   34453 |
      | ClientEntity.ClientEntityIds[4].IdType  |     445 |
      | ClientEntity.ClientEntityIds[4].IdValue | RUS2192 |
    When user store the response body have keyData with keyName
      | key                             | storeKey           |
      | ClientEntity.ClientEntityID     | ClientEntityID     |
      | ClientEntity.InterfaceReference | InterfaceReference |
    Then response body should match the schema from the file "AddCustomerWithIds"

  Scenario: 002 Retrieve Added Customer with Interface Reference and Verify ID Details #ENG-T13202 #ENG-T13570
    Given user has a service named "/api/v1/client/entity/get"
    And user has query parameters:
      """
      {
        "ReturnFormat": "Json",
        "BusinessUnitID": "10"
      }
      """
    And user add query parameter "InterfaceReference" with the stored key value "InterfaceReference"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                | storedKey          |
      | ClientEntityID     | ClientEntityID     |
      | InterfaceReference | InterfaceReference |
    And response body should have key with the value:
      | key                    | value                                        |
      | InterfaceReference     | IMO_TEST_101                                 |
      | LastName               | TEST VESSEL                                  |
      | FirstName              |                                              |
      | MiddleName             |                                              |
      | CriteriaID             |                                          203 |
      | CriteriaName           | STGLOADTEST-WLWP Disable-Automation - Entity |
      | GenderID               |                                            9 |
      | GenderName             | Unknown                                      |
      | StatusID               |                                            1 |
      | StatusName             | Active                                       |
      | BusinessUnitID         |                                           10 |
      | BusinessUnitName       | Default                                      |
      | HandledByUserGroupID   |                                          330 |
      | HandledByUserGroupName | Admin Group                                  |
      | HandledByUserID        |                                          524 |
      | HandledByUserName      | Akshay Pardeshi (WLWP Disable-Automation)    |
      | RiskID                 |                                          144 |
      | RiskName               | Low                                          |
    Then response body have key with the value for nested object:
      | key                        | value   |
      | ClientEntityIds[0].IdType  |      34 |
      | ClientEntityIds[0].IdValue | 9292204 |
      | ClientEntityIds[1].IdType  |     470 |
      | ClientEntityIds[1].IdValue |    8405 |
      | ClientEntityIds[2].IdType  |      18 |
      | ClientEntityIds[2].IdValue |   87052 |
      | ClientEntityIds[3].IdType  |     467 |
      | ClientEntityIds[3].IdValue |   34453 |
      | ClientEntityIds[4].IdType  |     445 |
      | ClientEntityIds[4].IdValue | RUS2192 |

  Scenario Outline: 003 Reject Customer Creation with Invalid IMO Number #ENG-T13209, ENG-T13210, ENG-T13211,ENG-T13213
    Given user has a service named "/api/v1/client/entity/add"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "addCustomerWithIds" with updates:
      | ClientEntityIds.0.IdValue | <imoValue> |
    When user sends a 'POST' request
    Then response status should be 406
    And response body should contains "Invalid IMO number entered"

    Examples:
      | imoValue |
      |   123456 |
      | 12345678 |
      |  12A4567 |
      |  12 3456 |
      | testimo  |

  Scenario: 004 Reject Customer Creation When an ID Entry Is Missing an ID Type #ENG-T13199,ENG-T13206
    Given user has a service named "/api/v1/client/entity/add"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "addCustomerWithIdsMissingIdType"
    When user sends a 'POST' request
    Then response status should be 406
    And response body should contains "Parameters.ClientEntityIds[0].IdType"
    And response body should contains "Parameter value is required?"

  Scenario: 005 Reject Customer Creation When an ID Entry Is Missing an ID Value #ENG-T13199, ENG-T13207
    Given user has a service named "/api/v1/client/entity/add"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "addCustomerWithIdsMissingIdValue"
    When user sends a 'POST' request
    Then response status should be 406
    And response body should contains "Parameters.ClientEntityIds[0].IdValue"
    And response body should contains "Parameter value is required?"

  Scenario: 006 Reject Customer Creation When ID Entries Contain Duplicate ID Types #ENG-T13208
    Given user has a service named "/api/v1/client/entity/add"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "addCustomerWithIdsDuplicateIdType"
    When user sends a 'POST' request
    Then response status should be 406
    And response body should contains "Duplicated Id Types found in the request"

  Scenario: 007 Reject Customer Creation When More Than Five ID Entries Are Provided #ENG-T13212
    Given user has a service named "/api/v1/client/entity/add"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "AddCustomerWithIdsOverFive"
    When user sends a 'POST' request
    Then response status should be 406
    And response body should contains "Too many Id entries entered"

  Scenario: 008 Delete Customer and Verify Associated ID Details #ENG-T13239 ENG-T13572
    Given user has a service named "/api/v1/client/entity/delete"
    And user has a payload from the file "AddCustomerWithIds" with selected keys "ActionUserID,ReturnFormat"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                | storedKey          |
      | ClientEntityID     | ClientEntityID     |
      | InterfaceReference | InterfaceReference |
    And response body should have key with the value:
      | key      | value       |
      | LastName | TEST VESSEL |
    Then response body have key with the value for nested object:
      | key                        | value   |
      | ClientEntityIds[0].IdType  |      34 |
      | ClientEntityIds[0].IdValue | 9292204 |
      | ClientEntityIds[1].IdType  |     470 |
      | ClientEntityIds[1].IdValue |    8405 |
      | ClientEntityIds[2].IdType  |      18 |
      | ClientEntityIds[2].IdValue |   87052 |
      | ClientEntityIds[3].IdType  |     467 |
      | ClientEntityIds[3].IdValue |   34453 |
      | ClientEntityIds[4].IdType  |     445 |
      | ClientEntityIds[4].IdValue | RUS2192 |

  Scenario: 009 Create Individual with ID in a Non-Default Business Unit and Verify Persistence #ENG-T13197,ENG-T13216, ENG-T13231
    Given user has a service named "/api/v1/client/entity/add"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "AddIndividualWithIdsNonDefaultBusinessUnit"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                 | value                                        |
      | ClientEntity.InterfaceReference     | VP_API_TEST_001                              |
      | ClientEntity.LastName               | PUTIN                                        |
      | ClientEntity.FirstName              | VLADIMIR                                     |
      | ClientEntity.MiddleName             |                                              |
      | ClientEntity.CriteriaID             |                                          202 |
      | ClientEntity.CriteriaName           | STGLOADTEST-WLWP Disable-Automation - Person |
      | ClientEntity.GenderID               |                                            1 |
      | ClientEntity.GenderName             | Male                                         |
      | ClientEntity.StatusID               |                                            1 |
      | ClientEntity.StatusName             | Active                                       |
      | ClientEntity.BusinessUnitID         |                                           11 |
      | ClientEntity.BusinessUnitName       | Transfer                                     |
      | ClientEntity.HandledByUserGroupID   |                                          330 |
      | ClientEntity.HandledByUserGroupName | Admin Group                                  |
      | ClientEntity.HandledByUserID        |                                          524 |
      | ClientEntity.HandledByUserName      | Akshay Pardeshi (WLWP Disable-Automation)    |
      | ClientEntity.RiskID                 |                                          145 |
      | ClientEntity.RiskName               | Medium                                       |
    Then response body have key with the value for nested object:
      | key                                     | value |
      | ClientEntity.ClientEntityIds[0].IdType  |    14 |
      | ClientEntity.ClientEntityIds[0].IdValue |  6678 |
    When user store the response body have keyData with keyName
      | key                             | storeKey           |
      | ClientEntity.ClientEntityID     | ClientEntityID     |
      | ClientEntity.InterfaceReference | InterfaceReference |
    Then response body should match the schema from the file "AddIndividualWithIdsNonDefaultBusinessUnit"

  Scenario Outline: 010 Reject an Invalid IMO Number When Adding an ID by Client Entity ID #ENG-T14454
    Given user has a service named "/api/v1/client/entity/addidinternal"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "AddUpdateIdForCustomer" with updates:
      | IdType  |         34 |
      | IdValue | <imoValue> |
    And user add raw payload "ClientEntityId" with the stored key value "ClientEntityID"
    When user sends a 'POST' request
    Then response status should be 406
    And response body should contains "Invalid IMO number entered"

    Examples:
      | imoValue |
      |   123456 |
      | 12345678 |
      |  12A4567 |
      |  12 3456 |
      | testimo  |

  Scenario: 011 Add an ID to the Individual Using the Internal Reference #ENG-T14451
    Given user has a service named "/api/v1/client/entity/addidinternal"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "AddUpdateIdForCustomer" with updates:
      | IdType  |   467 |
      | IdValue | 16102 |
    And user add raw payload "ClientEntityId" with the stored key value "ClientEntityID"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key      | storedKey      |
      | EntityId | ClientEntityID |
    And response body should have key with the value:
      | key             | value |
      | BusinessUnit    |    11 |
      | ClientId        |   119 |
      | IdType          |   467 |
      | IdValue         | 16102 |
      | UserLastChanged |   524 |
    When user store the response body have keyData with keyName
      | key | storeKey        |
      | Id  | AddedInternalId |

  Scenario Outline: 012 Reject an Invalid IMO Number When Updating an ID by Client Entity ID #ENG-T14454
    Given user has a service named "/api/v1/client/entity/updateidinternal"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "AddUpdateIdForCustomer" with updates:
      | IdType  |         34 |
      | IdValue | <imoValue> |
    And user add raw payload "ClientEntityId" with the stored key value "ClientEntityID"
    And user add raw payload "Id" with the stored key value "AddedInternalId"
    When user sends a 'PUT' request
    Then response status should be 406
    And response body should contains "Invalid IMO number entered"

    Examples:
      | imoValue |
      |   123456 |
      | 12345678 |
      |  12A4567 |
      |  12 3456 |
      | testimo  |

  Scenario: 013 Update the Added ID Using the Internal Reference #ENG-T14452
    Given user has a service named "/api/v1/client/entity/updateidinternal"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "AddUpdateIdForCustomer" with updates:
      | IdType  |    467 |
      | IdValue | 161021 |
    And user add raw payload "ClientEntityId" with the stored key value "ClientEntityID"
    And user add raw payload "Id" with the stored key value "AddedInternalId"
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key      | storedKey       |
      | EntityId | ClientEntityID  |
      | Id       | AddedInternalId |
    And response body should have key with the value:
      | key             | value  |
      | BusinessUnit    |     11 |
      | ClientId        |    119 |
      | IdType          |    467 |
      | IdValue         | 161021 |
      | UserLastChanged |    524 |

  Scenario: 014 Retrieve the Individual by Client Entity ID and Verify the Updated ID #ENG-T14452, ENG-T13571
    Given user has a service named "/api/v1/client/entity/getinternal"
    And user has a query params from the file "AddIndividualWithIdsNonDefaultBusinessUnit" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                | storedKey          |
      | ClientEntityID     | ClientEntityID     |
      | InterfaceReference | InterfaceReference |
    And response body should have key with the value:
      | key                    | value                                        |
      | InterfaceReference     | VP_API_TEST_001                              |
      | LastName               | PUTIN                                        |
      | FirstName              | VLADIMIR                                     |
      | MiddleName             |                                              |
      | CriteriaID             |                                          202 |
      | CriteriaName           | STGLOADTEST-WLWP Disable-Automation - Person |
      | GenderID               |                                            1 |
      | GenderName             | Male                                         |
      | StatusID               |                                            1 |
      | StatusName             | Active                                       |
      | BusinessUnitID         |                                           11 |
      | BusinessUnitName       | Transfer                                     |
      | HandledByUserGroupID   |                                          330 |
      | HandledByUserGroupName | Admin Group                                  |
      | HandledByUserID        |                                          524 |
      | HandledByUserName      | Akshay Pardeshi (WLWP Disable-Automation)    |
      | RiskID                 |                                          145 |
      | RiskName               | Medium                                       |
    And response should have 0 records at path "ClientEntityAliases"
    Then response body have key with the value for nested object:
      | key                        | value  |
      | ClientEntityIds[0].IdType  |     14 |
      | ClientEntityIds[0].IdValue |   6678 |
      | ClientEntityIds[1].IdType  |    467 |
      | ClientEntityIds[1].IdValue | 161021 |

  Scenario: 015 Delete the Added ID Using the Internal Reference #ENG-T14382
    Given user has a service named "/api/v1/client/entity/deleteidinternal"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
        "BusinessUnitID": 11,
        "ActionUserID": 524,
        "ReturnFormat": "Json"
      }
      """
    And user add raw payload "ClientEntityId" with the stored key value "ClientEntityID"
    And user add raw payload "Id" with the stored key value "AddedInternalId"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key      | storedKey       |
      | EntityId | ClientEntityID  |
      | Id       | AddedInternalId |
    And response body should have key with the value:
      | key             | value  |
      | BusinessUnit    |     11 |
      | ClientId        |    119 |
      | IdType          |    467 |
      | IdValue         | 161021 |
      | UserLastChanged |    524 |

  Scenario Outline: 016 Reject an Invalid IMO Number When Adding an ID by Interface Reference #ENG-T14454
    Given user has a service named "/api/v1/client/entity/addid"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "AddUpdateIdForCustomer" with updates:
      | IdType  |         34 |
      | IdValue | <imoValue> |
    And user add raw payload "ClientEntityInterfaceReference" with the stored key value "InterfaceReference"
    When user sends a 'POST' request
    Then response status should be 406
    And response body should contains "Invalid IMO number entered"

    Examples:
      | imoValue |
      |   123456 |
      | 12345678 |
      |  12A4567 |
      |  12 3456 |
      | testimo  |

  Scenario: 017 Add an ID to the Individual Using the Interface Reference #ENG-T14380
    Given user has a service named "/api/v1/client/entity/addid"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "AddUpdateIdForCustomer" with updates:
      | IdType  |    18 |
      | IdValue | 49812 |
    And user add raw payload "ClientEntityInterfaceReference" with the stored key value "InterfaceReference"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key      | storedKey      |
      | EntityId | ClientEntityID |
    And response body should have key with the value:
      | key             | value |
      | BusinessUnit    |    11 |
      | ClientId        |   119 |
      | IdType          |    18 |
      | IdValue         | 49812 |
      | UserLastChanged |   524 |
    When user store the response body have keyData with keyName
      | key | storeKey        |
      | Id  | AddedExternalId |

  Scenario Outline: 018 Reject an Invalid IMO Number When Updating an ID by Interface Reference #ENG-T14454
    Given user has a service named "/api/v1/client/entity/updateid"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "AddUpdateIdForCustomer" with updates:
      | IdType  |         34 |
      | IdValue | <imoValue> |
    And user add raw payload "ClientEntityInterfaceReference" with the stored key value "InterfaceReference"
    And user add raw payload "Id" with the stored key value "AddedExternalId"
    When user sends a 'PUT' request
    Then response status should be 406
    And response body should contains "Invalid IMO number entered"

    Examples:
      | imoValue |
      |   123456 |
      | 12345678 |
      |  12A4567 |
      |  12 3456 |
      | testimo  |

  Scenario: 019 Update the Added ID Using the Interface Reference #ENG-T14381
    Given user has a service named "/api/v1/client/entity/updateid"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "AddUpdateIdForCustomer" with updates:
      | IdType  |     18 |
      | IdValue | 498121 |
    And user add raw payload "ClientEntityInterfaceReference" with the stored key value "InterfaceReference"
    And user add raw payload "Id" with the stored key value "AddedExternalId"
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key      | storedKey       |
      | EntityId | ClientEntityID  |
      | Id       | AddedExternalId |
    And response body should have key with the value:
      | key             | value  |
      | BusinessUnit    |     11 |
      | ClientId        |    119 |
      | IdType          |     18 |
      | IdValue         | 498121 |
      | UserLastChanged |    524 |

  Scenario: 020 Delete the Added ID Using the Interface Reference #ENG-T14383
    Given user has a service named "/api/v1/client/entity/deleteid"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
        "BusinessUnitID": 11,
        "ActionUserID": 524,
        "ReturnFormat": "Json"
      }
      """
    And user add raw payload "ClientEntityInterfaceReference" with the stored key value "InterfaceReference"
    And user add raw payload "Id" with the stored key value "AddedExternalId"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key      | storedKey       |
      | EntityId | ClientEntityID  |
      | Id       | AddedExternalId |
    And response body should have key with the value:
      | key             | value  |
      | BusinessUnit    |     11 |
      | ClientId        |    119 |
      | IdType          |     18 |
      | IdValue         | 498121 |
      | UserLastChanged |    524 |

  Scenario: 021 Retrieve Individual ID Audit History by Client Entity ID #ENG-T14456
    Given user has a service named "/api/v1/client/entityid/audit/getallpaged"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "11",
        "UserID": "524",
        "FromDate": "<currentDateStamp>",
        "ToDate": "<currentDateStamp>",
        "CurrentPage": "1",
        "PageSize": "30",
        "SearchOn": "3",
        "SearchType": "0",
        "SearchStatus": "1",
        "ReturnFormat": "Json"
      }
      """
    And user add query parameter "SearchString" with the stored key value "ClientEntityID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key          | value |
      | TotalRecords |     7 |
    And response audit rows at "Data" should match:
      | idStoredKey     | auditTypeID | idType | idTypeName            | idValue | dateStoreKey            | auditTypeStoreKey         |
      | AddedExternalId |           1 |     18 | SECO SSID             |   49812 | ExternalAddAuditDate    | ExternalAddAuditTypeID    |
      | AddedExternalId |           2 |     18 | SECO SSID             |  498121 | ExternalUpdateAuditDate | ExternalUpdateAuditTypeID |
      | AddedExternalId |           3 |     18 | SECO SSID             |  498121 | ExternalDeleteAuditDate | ExternalDeleteAuditTypeID |
      | AddedInternalId |           1 |    467 | NSDC Unique ID        |   16102 |                         |                           |
      | AddedInternalId |           2 |    467 | NSDC Unique ID        |  161021 |                         |                           |
      | AddedInternalId |           3 |    467 | NSDC Unique ID        |  161021 |                         |                           |
      |                 |           1 |     14 | DFAT Reference Number |    6678 |                         |                           |

  Scenario: 022 Retrieve the Audit Record for Adding an External ID #ENG-T14456
    Given user has a service named "/api/v1/client/entityid/audit/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "11",
        "ReturnFormat": "Json"
      }
      """
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user add query parameter "TransactionDate" with the stored key value "ExternalAddAuditDate"
    And user add query parameter "AuditType" with the stored key value "ExternalAddAuditTypeID"
    And user add query parameter "RecordId" with the stored key value "AddedExternalId"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key       | storedKey            |
      | AuditDate | ExternalAddAuditDate |
      | EntityId  | ClientEntityID       |
      | Id        | AddedExternalId      |
    And response body should have key with the value:
      | key                       | value           |
      | AuditTypeID               |               1 |
      | ClientId                  |             119 |
      | BusinessUnit              |              11 |
      | CurrentInterfaceReference | VP_API_TEST_001 |
      | CurrentLastName           | PUTIN           |
      | CurrentFirstName          | VLADIMIR        |
      | CurrentMiddleName         |                 |
      | IdType                    |              18 |
      | IdTypeName                | SECO SSID       |
      | IdValue                   |           49812 |
      | UserLastChanged           |             524 |

  Scenario: 023 Retrieve the Audit Record for Updating an External ID #ENG-T14456
    Given user has a service named "/api/v1/client/entityid/audit/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "11",
        "ReturnFormat": "Json"
      }
      """
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user add query parameter "TransactionDate" with the stored key value "ExternalUpdateAuditDate"
    And user add query parameter "AuditType" with the stored key value "ExternalUpdateAuditTypeID"
    And user add query parameter "RecordId" with the stored key value "AddedExternalId"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key       | storedKey               |
      | AuditDate | ExternalUpdateAuditDate |
      | EntityId  | ClientEntityID          |
      | Id        | AddedExternalId         |
    And response body should have key with the value:
      | key                       | value           |
      | AuditTypeID               |               2 |
      | ClientId                  |             119 |
      | BusinessUnit              |              11 |
      | CurrentInterfaceReference | VP_API_TEST_001 |
      | CurrentLastName           | PUTIN           |
      | CurrentFirstName          | VLADIMIR        |
      | CurrentMiddleName         |                 |
      | IdType                    |              18 |
      | IdTypeName                | SECO SSID       |
      | IdValue                   |          498121 |
      | UserLastChanged           |             524 |

  Scenario: 024 Retrieve the Audit Record for Deleting an External ID #ENG-T14456
    Given user has a service named "/api/v1/client/entityid/audit/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "11",
        "ReturnFormat": "Json"
      }
      """
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user add query parameter "TransactionDate" with the stored key value "ExternalDeleteAuditDate"
    And user add query parameter "AuditType" with the stored key value "ExternalDeleteAuditTypeID"
    And user add query parameter "RecordId" with the stored key value "AddedExternalId"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key       | storedKey               |
      | AuditDate | ExternalDeleteAuditDate |
      | EntityId  | ClientEntityID          |
      | Id        | AddedExternalId         |
    And response body should have key with the value:
      | key                       | value           |
      | AuditTypeID               |               3 |
      | ClientId                  |             119 |
      | BusinessUnit              |              11 |
      | CurrentInterfaceReference | VP_API_TEST_001 |
      | CurrentLastName           | PUTIN           |
      | CurrentFirstName          | VLADIMIR        |
      | CurrentMiddleName         |                 |
      | IdType                    |              18 |
      | IdTypeName                | SECO SSID       |
      | IdValue                   |          498121 |
      | UserLastChanged           |             524 |

  Scenario: 025 Retrieve the Current-Day ID Audit History for a User #ENG-T14456
    Given user has a service named "/api/v1/client/entityid/audit/getall"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "11",
        "UserID": "524",
        "FromDate": "<currentDateStamp>",
        "ToDate": "<currentDateStamp>",
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response audit rows at "" should match:
      | idStoredKey     | auditTypeID | idType | idTypeName | idValue | dateStoreKey | auditTypeStoreKey |
      | AddedExternalId |           1 |     18 | SECO SSID  |   49812 |              |                   |

  Scenario: 026 Retrieve ID Audit History by ID Value #ENG-T14456
    Given user has a service named "/api/v1/client/entityid/audit/getallpaged"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "11",
        "UserID": "524",
        "FromDate": "<currentDateStamp>",
        "ToDate": "<currentDateStamp>",
        "CurrentPage": "1",
        "PageSize": "30",
        "SearchString": "498121",
        "SearchOn": "5",
        "SearchType": "0",
        "SearchStatus": "1",
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response audit rows at "Data" should match:
      | idStoredKey     | auditTypeID | idType | idTypeName | idValue | dateStoreKey | auditTypeStoreKey |
      | AddedExternalId |           3 |     18 | SECO SSID  |  498121 |              |                   |
      | AddedExternalId |           2 |     18 | SECO SSID  |  498121 |              |                   |

  Scenario: 027 Move the Individual to the Default Business Unit and Verify the ID #ENG-T13574
    Given user has a service named "/api/v1/client/entity/move"
    And user has payloads:
      """
      {
        "SourceBusinessUnitID": 11,
        "DestinationBusinessUnitID": 10,
        "ReassignmentUserGroupID": 330,
        "ActionUserID": 524,
        "ReturnFormat": "Json"
      }
      """
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                | storedKey          |
      | ClientEntityID     | ClientEntityID     |
      | InterfaceReference | InterfaceReference |
    And response body should have key with the value:
      | key                    | value                                        |
      | InterfaceReference     | VP_API_TEST_001                              |
      | LastName               | PUTIN                                        |
      | FirstName              | VLADIMIR                                     |
      | MiddleName             |                                              |
      | CriteriaID             |                                          202 |
      | CriteriaName           | STGLOADTEST-WLWP Disable-Automation - Person |
      | GenderID               |                                            1 |
      | GenderName             | Male                                         |
      | StatusID               |                                            1 |
      | StatusName             | Active                                       |
      | BusinessUnitID         |                                           10 |
      | BusinessUnitName       | Default                                      |
      | HandledByUserGroupID   |                                          330 |
      | HandledByUserGroupName | Admin Group                                  |
      | HandledByUserID        |                                          524 |
      | HandledByUserName      | Akshay Pardeshi (WLWP Disable-Automation)    |
      | RiskID                 |                                          145 |
      | RiskName               | Medium                                       |
    And response should have 0 records at path "ClientEntityAliases"
    Then response body have key with the value for nested object:
      | key                             | value |
      | ClientEntityIds[0].BusinessUnit |    10 |
      | ClientEntityIds[0].IdType       |    14 |
      | ClientEntityIds[0].IdValue      |  6678 |

  Scenario: 028 Delete the Moved Individual by Client Entity ID and Verify the ID #ENG-T13573
    Given user has a service named "/api/v1/client/entity/deleteinternal"
    And user has payloads:
      """
      {
        "BusinessUnitID": 10,
        "ActionUserID": 524,
        "ReturnFormat": "Json"
      }
      """
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                | storedKey          |
      | ClientEntityID     | ClientEntityID     |
      | InterfaceReference | InterfaceReference |
    And response body should have key with the value:
      | key                    | value                                        |
      | InterfaceReference     | VP_API_TEST_001                              |
      | LastName               | PUTIN                                        |
      | FirstName              | VLADIMIR                                     |
      | MiddleName             |                                              |
      | CriteriaID             |                                          202 |
      | CriteriaName           | STGLOADTEST-WLWP Disable-Automation - Person |
      | GenderID               |                                            1 |
      | GenderName             | Male                                         |
      | StatusID               |                                            1 |
      | StatusName             | Active                                       |
      | BusinessUnitID         |                                           10 |
      | BusinessUnitName       | Default                                      |
      | HandledByUserGroupID   |                                          330 |
      | HandledByUserGroupName | Admin Group                                  |
      | HandledByUserID        |                                          524 |
      | HandledByUserName      | Akshay Pardeshi (WLWP Disable-Automation)    |
      | RiskID                 |                                          145 |
      | RiskName               | Medium                                       |
    And response should have 0 records at path "ClientEntityAliases"
    Then response body have key with the value for nested object:
      | key                             | value |
      | ClientEntityIds[0].BusinessUnit |    10 |
      | ClientEntityIds[0].IdType       |    14 |
      | ClientEntityIds[0].IdValue      |  6678 |