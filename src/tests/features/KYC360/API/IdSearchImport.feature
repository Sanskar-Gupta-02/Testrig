@Regression @IdSearchImport
Feature: Import Entities with ID Values and Validate ID Handling

  Background:
    Given user is authorized using an 'ALIASAPIKEY'

  Scenario: 001 Import Customer with ID Values and Verify Persistence #ENG-T13749,T13575,T14385
    Given user has a service named "/api/v1/client/entity/import"
    And user has header "Content-Type":"application/json"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "10",
        "IncludeDetailInResult": "true",
        "ActionUserID": "524",
        "ReturnFormat": "Json"
      }
      """
    And user has a raw payload from the file "ImportCustomerWithIds"
    When user sends a 'POST' request
    Then response status should be 201
    And response body should match the schema from the file "ImportCustomerWithIds"
    And response body should have key with the value:
      | key                        | value |
      | ImportRejections           |     0 |
      | ValidItemsActionRequired   |     1 |
      | ValidItemsNoActionRequired |     0 |
    And response body in ascending order should have index key with the contains value:
      | index | key                                             | value         |
      |     1 | Allocations.ItemNumber                          |             1 |
      |     1 | Allocations.InterfaceReference                  | QA_IMPORT_001 |
      |     1 | ValidItemsActionRequiredList.FileRow            |             1 |
      |     1 | ValidItemsActionRequiredList.ClientID           |           119 |
      |     1 | ValidItemsActionRequiredList.InterfaceReference | QA_IMPORT_001 |
    Given user has a service named "/api/v1/client/entity/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "10",
        "ReturnFormat": "Json",
        "InterfaceReference": "QA_IMPORT_001"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response body have key with the value for nested object:
      | key                        | value   |
      | ClientEntityIds[0].IdType  |      34 |
      | ClientEntityIds[0].IdValue | 1234567 |

  Scenario: 002 Import Existing Customer with Additional ID and Verify Persistence #ENG-T13752
    Given user has a service named "/api/v1/client/entity/import"
    And user has header "Content-Type":"application/json"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "10",
        "IncludeDetailInResult": "true",
        "ActionUserID": "524",
        "ReturnFormat": "Json"
      }
      """
    And user has a raw payload from the file "ImportCustomerWithIds" with updates:
      |            0.InterfaceReference | QA_IMPORT_001 |
      |  0.ClientEntityIdItems.1.IdType |           470 |
      | 0.ClientEntityIdItems.1.IdValue |          8405 |
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "ImportCustomerWithIds"
    And response body should have key with the value:
      | key                        | value |
      | ImportRejections           |     0 |
      | ValidItemsActionRequired   |     1 |
      | ValidItemsNoActionRequired |     0 |
    And response should have 0 records at path "Rejections"
    And response should have 0 records at path "Allocations"
    And response should have 1 records at path "ValidItemsActionRequiredList"
    And response should have 0 records at path "ValidItemsNoActionRequiredList"
    And response body in ascending order should have index key with the contains value:
      | index | key                                               | value         |
      |     1 | ValidItemsActionRequiredList.FileRow              |             1 |
      |     1 | ValidItemsActionRequiredList.ClientID             |           119 |
      |     1 | ValidItemsActionRequiredList.InterfaceReference   | QA_IMPORT_001 |
      |     1 | ValidItemsActionRequiredList.HandledByUserGroupID |           331 |
      |     1 | ValidItemsActionRequiredList.HandledByUserID      |           524 |
    Given user has a service named "/api/v1/client/entity/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "10",
        "ReturnFormat": "Json",
        "InterfaceReference": "QA_IMPORT_001"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response body have key with the value for nested object:
      | key                        | value   |
      | ClientEntityIds[0].IdType  |      34 |
      | ClientEntityIds[0].IdValue | 1234567 |
      | ClientEntityIds[1].IdType  |     470 |
      | ClientEntityIds[1].IdValue |    8405 |

  Scenario: 003 Import Existing Customer with Updated ID Value and Verify Persistence ENG-T13752
    Given user has a service named "/api/v1/client/entity/import"
    And user has header "Content-Type":"application/json"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "10",
        "IncludeDetailInResult": "true",
        "ActionUserID": "524",
        "ReturnFormat": "Json"
      }
      """
    And user has a raw payload from the file "ImportCustomerWithIds" with updates:
      |            0.InterfaceReference | QA_IMPORT_001 |
      |  0.ClientEntityIdItems.0.IdType |            34 |
      | 0.ClientEntityIdItems.0.IdValue |       7654321 |
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "ImportCustomerWithIds"
    And response body should have key with the value:
      | key                        | value |
      | ImportRejections           |     0 |
      | ValidItemsActionRequired   |     1 |
      | ValidItemsNoActionRequired |     0 |
    And response should have 0 records at path "Rejections"
    And response should have 0 records at path "Allocations"
    And response should have 1 records at path "ValidItemsActionRequiredList"
    And response should have 0 records at path "ValidItemsNoActionRequiredList"
    And response body in ascending order should have index key with the contains value:
      | index | key                                               | value         |
      |     1 | ValidItemsActionRequiredList.FileRow              |             1 |
      |     1 | ValidItemsActionRequiredList.ClientID             |           119 |
      |     1 | ValidItemsActionRequiredList.InterfaceReference   | QA_IMPORT_001 |
      |     1 | ValidItemsActionRequiredList.HandledByUserGroupID |           331 |
      |     1 | ValidItemsActionRequiredList.HandledByUserID      |           524 |
    Given user has a service named "/api/v1/client/entity/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "10",
        "ReturnFormat": "Json",
        "InterfaceReference": "QA_IMPORT_001"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response body have key with the value for nested object:
      | key                        | value   |
      | ClientEntityIds[0].IdType  |      34 |
      | ClientEntityIds[0].IdValue | 7654321 |

  Scenario: 004 Import Existing Customer Without ID Values and Verify Removal #ENG-T13752
    Given user has a service named "/api/v1/client/entity/import"
    And user has header "Content-Type":"application/json"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "10",
        "IncludeDetailInResult": "true",
        "ActionUserID": "524",
        "ReturnFormat": "Json"
      }
      """
    And user has a raw payload from the file "ImportCustomerWithoutIds"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "ImportCustomerWithIds"
    Given user has a service named "/api/v1/client/entity/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "10",
        "ReturnFormat": "Json",
        "InterfaceReference": "QA_IMPORT_001"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response should have 0 records at path "ClientEntityIds"

  Scenario: 005 Reject ID Values for Alias Entity Import #ENG-T13750
    Given user has a service named "/api/v1/client/entity/import"
    And user has header "Content-Type":"application/json"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "10",
        "IncludeDetailInResult": "true",
        "ActionUserID": "524",
        "ReturnFormat": "Json"
      }
      """
    And user has a raw payload from the file "ImportCustomerAliasWithIds"
    When user sends a 'POST' request
    Then response status should be 201
    And response body should match the schema from the file "ImportCustomerWithIds"
    And response body should have key with the value:
      | key                        | value |
      | ImportRejections           |     1 |
      | ValidItemsActionRequired   |     0 |
      | ValidItemsNoActionRequired |     0 |
    And response should have 1 records at path "Rejections"
    And response should have 0 records at path "Allocations"
    And response should have 0 records at path "ValidItemsActionRequiredList"
    And response should have 0 records at path "ValidItemsNoActionRequiredList"
    And response body in ascending order should have index key with the contains value:
      | index | key                           | value                                    |
      |     1 | Rejections.ItemNumber         |                                        1 |
      |     1 | Rejections.InterfaceReference | QA_IMPORT_ALIAS_001                      |
      |     1 | Rejections.Reason             | Id entries not allowed for alias records |

  Scenario: 006 Reject Import with Duplicate ID Types #ENG-T13751
    Given user has a service named "/api/v1/client/entity/import"
    And user has header "Content-Type":"application/json"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "10",
        "IncludeDetailInResult": "true",
        "ActionUserID": "524",
        "ReturnFormat": "Json"
      }
      """
    And user has a raw payload from the file "ImportCustomerWithIds" with updates:
      |            0.InterfaceReference | QA_IMPORT_DUPLICATE_ID |
      |  0.ClientEntityIdItems.1.IdType |                     34 |
      | 0.ClientEntityIdItems.1.IdValue |                1234567 |
    When user sends a 'POST' request
    Then response status should be 201
    And response body should match the schema from the file "ImportCustomerWithIds"
    And response body should have key with the value:
      | key                        | value |
      | ImportRejections           |     1 |
      | ValidItemsActionRequired   |     0 |
      | ValidItemsNoActionRequired |     0 |
    And response should have 1 records at path "Rejections"
    And response should have 0 records at path "Allocations"
    And response should have 0 records at path "ValidItemsActionRequiredList"
    And response should have 0 records at path "ValidItemsNoActionRequiredList"
    And response body should contains "Duplicated Id types found"

  Scenario: 007 Reject Import with More Than Five ID Entries #ENG-T13751
    Given user has a service named "/api/v1/client/entity/import"
    And user has header "Content-Type":"application/json"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "10",
        "IncludeDetailInResult": "true",
        "ActionUserID": "524",
        "ReturnFormat": "Json"
      }
      """
    And user has a raw payload from the file "ImportCustomerWithIds" with updates:
      |            0.InterfaceReference | QA_IMPORT_MORE_THAN_FIVE_IDS                      |
      |  0.ClientEntityIdItems.1.IdType |                                                14 |
      | 0.ClientEntityIdItems.1.IdValue |                                              8405 |
      |  0.ClientEntityIdItems.2.IdType |                                               446 |
      | 0.ClientEntityIdItems.2.IdValue |                                             34453 |
      |  0.ClientEntityIdItems.3.IdType |                                                18 |
      | 0.ClientEntityIdItems.3.IdValue |                                             87052 |
      |  0.ClientEntityIdItems.4.IdType |                                               449 |
      | 0.ClientEntityIdItems.4.IdValue | The Russia (Sanctions) (EU Exit) Regulations 2019 |
      |  0.ClientEntityIdItems.5.IdType |                                               448 |
      | 0.ClientEntityIdItems.5.IdValue | RUS2171                                           |
    When user sends a 'POST' request
    Then response status should be 201
    And response body should match the schema from the file "ImportCustomerWithIds"
    And response body should have key with the value:
      | key                        | value |
      | ImportRejections           |     1 |
      | ValidItemsActionRequired   |     0 |
      | ValidItemsNoActionRequired |     0 |
    And response should have 1 records at path "Rejections"
    And response should have 0 records at path "Allocations"
    And response should have 0 records at path "ValidItemsActionRequiredList"
    And response should have 0 records at path "ValidItemsNoActionRequiredList"
    And response body should contains "Max 5 id entries are allowed per entity"

  Scenario Outline: 008 Reject Import with Invalid IMO Number #ENG-T13751
    Given user has a service named "/api/v1/client/entity/import"
    And user has header "Content-Type":"application/json"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "10",
        "IncludeDetailInResult": "true",
        "ActionUserID": "524",
        "ReturnFormat": "Json"
      }
      """
    And user has a raw payload from the file "ImportCustomerWithIds" with updates:
      |            0.InterfaceReference | QA_IMPORT_INVALID_IMO |
      | 0.ClientEntityIdItems.0.IdValue | <imoValue>            |
    When user sends a 'POST' request
    Then response status should be 201
    And response body should match the schema from the file "ImportCustomerWithIds"
    And response body should have key with the value:
      | key                        | value |
      | ImportRejections           |     1 |
      | ValidItemsActionRequired   |     0 |
      | ValidItemsNoActionRequired |     0 |
    And response should have 1 records at path "Rejections"
    And response should have 0 records at path "Allocations"
    And response should have 0 records at path "ValidItemsActionRequiredList"
    And response should have 0 records at path "ValidItemsNoActionRequiredList"
    And response body should contains "Invalid IMO number <imoValue>"

    Examples:
      | imoValue |
      |   123456 |
      | 12345678 |
      |  12A4567 |
      |  12 3456 |
      | testimo  |

  Scenario: 009 Reject Import When ID Type Is Missing From ID Entry #ENG-T13751
    Given user has a service named "/api/v1/client/entity/import"
    And user has header "Content-Type":"application/json"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "10",
        "IncludeDetailInResult": "true",
        "ActionUserID": "524",
        "ReturnFormat": "Json"
      }
      """
    And user has a raw payload from the file "ImportCustomerWithIds" with updates:
      |           0.InterfaceReference | QA_IMPORT_MISSING_ID_TYPE |
      | 0.ClientEntityIdItems.0.IdType |                           |
    When user sends a 'POST' request
    Then response status should be 406
    And response body should contains "The request is invalid."
    And response body should contains "Parameters[0].ClientEntityIdItems[0].IdType"
    And response body should contains "Parameter value is required?"

  Scenario: 010 Reject Import When ID Value Is Missing From ID Entry #ENG-T13751
    Given user has a service named "/api/v1/client/entity/import"
    And user has header "Content-Type":"application/json"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "10",
        "IncludeDetailInResult": "true",
        "ActionUserID": "524",
        "ReturnFormat": "Json"
      }
      """
    And user has a raw payload from the file "ImportCustomerWithIds" with updates:
      |            0.InterfaceReference | QA_IMPORT_MISSING_ID_VALUE |
      | 0.ClientEntityIdItems.0.IdValue |                            |
    When user sends a 'POST' request
    Then response status should be 406
    And response body should contains "The request is invalid."
    And response body should contains "Parameters[0].ClientEntityIdItems[0].IdValue"
    And response body should contains "Parameter value is required?"

  Scenario: 011 Delete the customer imported with ID values #ENG-T13239
    Given user has a service named "/api/v1/client/entity/delete"
    And user has payload "ActionUserID":"524"
    And user has payload "ReturnFormat":"Json"
    And user has payload "BusinessUnitID":"10"
    And user has payload "InterfaceReference":"QA_IMPORT_001"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                | value         |
      | InterfaceReference | QA_IMPORT_001 |