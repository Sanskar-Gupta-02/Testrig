@Regression @Client
Feature: Client API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Add Customer
    Given user has a service named "/api/v1/client/entity/add"
    And user has a payload from the file "AddCustomer"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                     | value           |
      | ClientEntity.InterfaceReference         | APIADDCUSTOMER  |
      | ClientEntity.LastName                   | KUMAR           |
      | ClientEntity.FirstName                  | AKSHAY          |
      | ClientEntity.MiddleName                 | HARI            |
      | ClientEntity.CriteriaID                 |             253 |
      | ClientEntity.CriteriaName               | Person 2        |
      | ClientEntity.GenderID                   |               1 |
      | ClientEntity.GenderName                 | Male            |
      | ClientEntity.StatusID                   |               0 |
      | ClientEntity.StatusName                 | Disabled        |
      | ClientEntity.BusinessUnitID             |              10 |
      | ClientEntity.BusinessUnitName           | Default         |
      | ClientEntity.HandledByUserGroupID       |             325 |
      | ClientEntity.HandledByUserGroupName     | Handler Group   |
      | ClientEntity.HandledByUserID            |             521 |
      | ClientEntity.HandledByUserName          | Automation User |
      | ClientEntity.RiskID                     |             134 |
      | ClientEntity.RiskName                   | High            |
      | ClientEntity.AdverseMediaFileCriteriaID |            1080 |
    When user store the response body have keyData with keyName
      | key                             | storeKey           |
      | ClientEntity.ClientEntityID     | ClientEntityID     |
      | ClientEntity.InterfaceReference | InterfaceReference |
    Then response body should match the schema from the file "AddCustomer"

  Scenario: 002 Search Customer. #ENG-T1405
    Given user has a service named "/api/v1/client/entity/search"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "SearchString" with the stored key value "InterfaceReference"
    And user has query parameter "SearchOn":"4"
    And user has query parameter "SearchStatus":"2"
    And user has query parameter "SearchType":"0"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                | storedKey          |
      |     1 | ClientEntityID     | ClientEntityID     |
      |     1 | InterfaceReference | InterfaceReference |
    And response body in ascending order should have index key with the contains value:
      | index | key        | value  |
      |     1 | LastName   | KUMAR  |
      |     1 | FirstName  | AKSHAY |
      |     1 | MiddleName | HARI   |

  Scenario: 003 Move Business Unit. #ENG-1408
    Given user has a service named "/api/v1/client/entity/move"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payloads:
      """
      {
      "SourceBusinessUnitID":10,
      "DestinationBusinessUnitID":11,
      "ReassignmentUserGroupID":325,
      "ReturnFormat":"Json",
      "ActionUserID":521
      }
      """
    When user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                | storedKey          |
      | ClientEntityID     | ClientEntityID     |
      | InterfaceReference | InterfaceReference |
    And response body should have key with the value:
      | key                        | value            |
      | LastName                   | KUMAR            |
      | FirstName                  | AKSHAY           |
      | MiddleName                 | HARI             |
      | CriteriaID                 |              253 |
      | CriteriaName               | Person 2         |
      | GenderID                   |                1 |
      | GenderName                 | Male             |
      | StatusID                   |                0 |
      | StatusName                 | Disabled         |
      | BusinessUnitID             |               11 |
      | BusinessUnitName           | Automation Check |
      | HandledByUserGroupID       |              325 |
      | HandledByUserGroupName     | Handler Group    |
      | HandledByUserID            |              521 |
      | HandledByUserName          | Automation User  |
      | RiskID                     |              134 |
      | RiskName                   | High             |
      | AdverseMediaFileCriteriaID |             1080 |

  Scenario: 004 Get Customer By Interface Reference. #ENG-1406
    Given user has a service named "/api/v1/client/entity/get"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat"
    And user has query parameter "BusinessUnitID":"11"
    And user add query parameter "InterfaceReference" with the stored key value "InterfaceReference"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                | storedKey          |
      | ClientEntityID     | ClientEntityID     |
      | InterfaceReference | InterfaceReference |
    And response body should have key with the value:
      | key                        | value            |
      | LastName                   | KUMAR            |
      | FirstName                  | AKSHAY           |
      | MiddleName                 | HARI             |
      | CriteriaID                 |              253 |
      | CriteriaName               | Person 2         |
      | GenderID                   |                1 |
      | GenderName                 | Male             |
      | StatusID                   |                0 |
      | StatusName                 | Disabled         |
      | BusinessUnitID             |               11 |
      | BusinessUnitName           | Automation Check |
      | HandledByUserGroupID       |              325 |
      | HandledByUserGroupName     | Handler Group    |
      | HandledByUserID            |              521 |
      | HandledByUserName          | Automation User  |
      | RiskID                     |              134 |
      | RiskName                   | High             |
      | AdverseMediaFileCriteriaID |             1080 |

  Scenario: 005 Customer screen
    Given user has a service named "/api/v1/client/entity/screen"
    And user has a payload from the file "AddCustomer" with selected keys "ActionUserID,ReturnFormat"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    And user has payload "BusinessUnitID":"11"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                            | storedKey          |
      |     1 | ClientEntityID                 | ClientEntityID     |
      |     1 | ClientEntityInterfaceReference | InterfaceReference |
    And response body in ascending order should have index key with the contains value:
      | index | key                    | value         |
      |     1 | ClientEntityLastName   | KUMAR         |
      |     1 | ClientEntityFirstName  | AKSHAY        |
      |     1 | ClientEntityMiddleName | HARI          |
      |     1 | HandledByUserGroupID   |           325 |
      |     1 | HandledByUserGroupName | Handler Group |
      |     1 | HandledByUserID        |           521 |

  Scenario: 006 Get Customer Detils
    Given user has a service named "/api/v1/client/entity/getdetail"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat"
    And user add query parameter "InterfaceReference" with the stored key value "InterfaceReference"
    And user has query parameter "BusinessUnitID":"11"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                | storedKey          |
      | ClientEntityID     | ClientEntityID     |
      | InterfaceReference | InterfaceReference |
    And response body should have key with the value:
      | key              | value            |
      | BusinessUnitID   |               11 |
      | BusinessUnitName | Automation Check |
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                                           | storedKey          |
      |     1 | MatchPotential.ClientEntityID                 | ClientEntityID     |
      |     1 | MatchPotential.ClientEntityInterfaceReference | InterfaceReference |
    And response body in ascending order should have index key with the contains value:
      | index | key                                   | value  |
      |     1 | MatchPotential.ClientEntityLastName   | KUMAR  |
      |     1 | MatchPotential.ClientEntityFirstName  | AKSHAY |
      |     1 | MatchPotential.ClientEntityMiddleName | HARI   |

  Scenario: 007 Customer ADVERSE MEDIA SCREEN
    Given user has a service named "/api/v1/client/entity/adversemediascreen"
    And user has a payload from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'

  Scenario: 008 Delete all AVM PM
    Given user has a service named "/api/v1/client/adversemedia/matchpotential/deleteall"
    And user has a payload from the file "AddCustomerForReport" with selected keys "ActionUserID,ReturnFormat"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payload "BusinessUnitID":"11"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storekey with the value:
      | index | key            | storekey       |
      |     1 | ClientEntityID | ClientEntityID |

  Scenario: 009 Delete all PM
    Given user has a service named "/api/v1/client/matchpotential/deleteallinternal"
    And user has a payload from the file "AddCustomer" with selected keys "ActionUserID,ReturnFormat"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payload "BusinessUnitID":"11"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storekey with the value:
      | index | key            | storekey       |
      |     1 | ClientEntityID | ClientEntityID |

  Scenario: 010 Update Customer
    Given user has a service named "/api/v1/client/entity/update"
    And user has a query params from the file "AddCustomer" with selected keys "Screen,ReturnFormat,InterfaceReference"
    And user has query parameter "BusinessUnitID":"11"
    And user has a payload from the file "AddCustomer"
    And user has payloads:
      """
      {
      "LastName":"KUMARUPDATE",
      "FirstName":"AKSHAYUPDATE",
      "MiddleName":"HARIUPDATE",
      "GenderID":2
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                     | value            |
      | ClientEntity.InterfaceReference         | APIADDCUSTOMER   |
      | ClientEntity.LastName                   | KUMARUPDATE      |
      | ClientEntity.FirstName                  | AKSHAYUPDATE     |
      | ClientEntity.MiddleName                 | HARIUPDATE       |
      | ClientEntity.CriteriaID                 |              253 |
      | ClientEntity.CriteriaName               | Person 2         |
      | ClientEntity.GenderID                   |                2 |
      | ClientEntity.GenderName                 | Female           |
      | ClientEntity.StatusID                   |                0 |
      | ClientEntity.StatusName                 | Disabled         |
      | ClientEntity.BusinessUnitID             |               11 |
      | ClientEntity.BusinessUnitName           | Automation Check |
      | ClientEntity.HandledByUserGroupID       |              325 |
      | ClientEntity.HandledByUserGroupName     | Handler Group    |
      | ClientEntity.HandledByUserID            |              521 |
      | ClientEntity.HandledByUserName          | Automation User  |
      | ClientEntity.RiskID                     |              134 |
      | ClientEntity.RiskName                   | High             |
      | ClientEntity.AdverseMediaFileCriteriaID |             1080 |
    When user store the response body have keyData with keyName
      | key                             | storeKey           |
      | ClientEntity.ClientEntityID     | ClientEntityID     |
      | ClientEntity.InterfaceReference | InterfaceReference |

  Scenario: 011 UPDATE STATUS
    Given user has a service named "/api/v1/client/entity/updatestatus"
    And user has a payload from the file "AddCustomer" with selected keys "ActionUserID,ReturnFormat,InterfaceReference"
    And user has payload "BusinessUnitID":"11"
    And user has payload "Status":"0"
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                        | value            |
      | InterfaceReference         | APIADDCUSTOMER   |
      | LastName                   | KUMARUPDATE      |
      | FirstName                  | AKSHAYUPDATE     |
      | MiddleName                 | HARIUPDATE       |
      | CriteriaID                 |              253 |
      | CriteriaName               | Person 2         |
      | GenderID                   |                2 |
      | GenderName                 | Female           |
      | StatusID                   |                0 |
      | StatusName                 | Disabled         |
      | BusinessUnitID             |               11 |
      | BusinessUnitName           | Automation Check |
      | HandledByUserGroupID       |              325 |
      | HandledByUserGroupName     | Handler Group    |
      | HandledByUserID            |              521 |
      | HandledByUserName          | Automation User  |
      | RiskID                     |              134 |
      | RiskName                   | High             |
      | AdverseMediaFileCriteriaID |             1080 |
    When user store the response body have keyData with keyName
      | key                | storeKey           |
      | ClientEntityID     | ClientEntityID     |
      | InterfaceReference | InterfaceReference |

  Scenario: 012 Delete Customer. #ENG-1410
    Given user has a service named "/api/v1/client/entity/delete"
    And user has a payload from the file "AddCustomer" with selected keys "ActionUserID,ReturnFormat"
    And user has payload "BusinessUnitID":"11"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                | storedKey          |
      | ClientEntityID     | ClientEntityID     |
      | InterfaceReference | InterfaceReference |
    And response body should have key with the value:
      | key        | value        |
      | LastName   | KUMARUPDATE  |
      | FirstName  | AKSHAYUPDATE |
      | MiddleName | HARIUPDATE   |

  Scenario: 013 Import Customer. #ENG-1403
    Given user has a service named "/api/v1/client/entity/import"
    And user has header "Content-Type":"application/json"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user has query parameter "IncludeDetailInResult":"true"
    And user has a raw payload from the file "AddImport"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                        | value |
      | ImportRejections           |     0 |
      | ValidItemsActionRequired   |     1 |
      | ValidItemsNoActionRequired |     0 |
    And response body in ascending order should have index key with the contains value:
      | index | key                                               | value     |
      |     1 | Allocations.ItemNumber                            |         1 |
      |     1 | Allocations.InterfaceReference                    | APIImport |
      |     1 | ValidItemsActionRequiredList.FileRow              |         1 |
      |     1 | ValidItemsActionRequiredList.ClientID             |       116 |
      |     1 | ValidItemsActionRequiredList.InterfaceReference   | APIImport |
      |     1 | ValidItemsActionRequiredList.HandledByUserGroupID |       325 |
      |     1 | ValidItemsActionRequiredList.HandledByUserID      |       521 |
    When user store the response body have index keyData with keyName
      | index | key                            | storeKey                 |
      |     1 | Allocations.ClientEntityID     | ImportClientEntityID     |
      |     1 | Allocations.InterfaceReference | ImportInterfaceReference |

  Scenario: 014 Import in clude handled by info Customer. #ENG-1402
    Given user has a service named "/api/v1/client/entity/import"
    And user has header "Content-Type":"application/json"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user has query parameter "IncludeDetailInResult":"true"
    And user has a raw payload from the file "AddImportIncludeHandledByInfo"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                        | value |
      | ImportRejections           |     0 |
      | ValidItemsActionRequired   |     1 |
      | ValidItemsNoActionRequired |     0 |
    And response body in ascending order should have index key with the contains value:
      | index | key                                               | value                         |
      |     1 | Allocations.ItemNumber                            |                             1 |
      |     1 | Allocations.InterfaceReference                    | APIImportIncludeHandledByInfo |
      |     1 | ValidItemsActionRequiredList.FileRow              |                             1 |
      |     1 | ValidItemsActionRequiredList.ClientID             |                           116 |
      |     1 | ValidItemsActionRequiredList.InterfaceReference   | APIImportIncludeHandledByInfo |
      |     1 | ValidItemsActionRequiredList.HandledByUserGroupID |                           325 |
      |     1 | ValidItemsActionRequiredList.HandledByUserID      |                           521 |
    When user store the response body have index keyData with keyName
      | index | key                            | storeKey                                     |
      |     1 | Allocations.ClientEntityID     | ImportIncludeHandledByInfoClientEntityID     |
      |     1 | Allocations.InterfaceReference | ImportIncludeHandledByInfoInterfaceReference |

  Scenario: 015 Migrate Client Entity data Updates Interface References in Bulk.
    Given user has a service named "/api/v1/client/entity/migrate"
    And user has header "Content-Type":"application/json"
    And user has a query params from the file "AddCustomer" with selected keys "ActionUserID,ReturnFormat,BusinessUnitID"
    And user has raw payloads:
      """
      	[{
        "FromInterfaceReference": "APIImport",
        "ToInterfaceReference": "APIImportMigrate"
      } ,
      {
        "FromInterfaceReference": "APIImportIncludeHandledByInfo",
        "ToInterfaceReference": "APIImportIncludeHandledByInfoMigrate"
      }]
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                 | value |
      | TotalItemsProcessed |     2 |
      | ItemsUpdated        |     2 |

  Scenario: 016 Bulk Update Status of Client Entities based on Interface Reference
    Given user has a service named "/api/v1/client/entity/bulkupdatestatus"
    And user has header "Content-Type":"application/json"
    And user has a query params from the file "AddCustomer" with selected keys "ActionUserID,ReturnFormat,BusinessUnitID"
    And user has raw payloads:
      """
      	[{
      "InterfaceReference": "APIImportMigrate",
      "Status": "0"
      },
      {
      "InterfaceReference": "APIImportIncludeHandledByInfoMigrate",
      "Status": "0"
      }]
      """
    When user sends a 'PUT' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                 | value |
      | TotalItemsProcessed |     2 |
      | ItemsUpdated        |     2 |

  Scenario: 017 Bulk Delete Client Entities based on Interface Reference. #ENG-T1411
    Given user has a service named "/api/v1/client/entity/bulkdelete"
    And user has header "Content-Type":"application/json"
    And user has a query params from the file "AddCustomer" with selected keys "ActionUserID,ReturnFormat,BusinessUnitID"
    And user has raw payloads:
      """
      	[{
        "InterfaceReference": "APIImportMigrate"
      },
      {
        "InterfaceReference": "APIImportIncludeHandledByInfoMigrate"
      },
      {
        "InterfaceReference": "APIADDCUSTOMER"
      }]
      """
    When user sends a 'DELETE' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                 | value |
      | TotalItemsProcessed |     3 |
      | ItemsDeleted        |     2 |

  Scenario: 018 Add Customer for ClientID
    Given user has a service named "/api/v1/client/entity/add"
    And user has a payload from the file "AddCustomer"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                     | value           |
      | ClientEntity.InterfaceReference         | APIADDCUSTOMER  |
      | ClientEntity.LastName                   | KUMAR           |
      | ClientEntity.FirstName                  | AKSHAY          |
      | ClientEntity.MiddleName                 | HARI            |
      | ClientEntity.CriteriaID                 |             253 |
      | ClientEntity.CriteriaName               | Person 2        |
      | ClientEntity.GenderID                   |               1 |
      | ClientEntity.GenderName                 | Male            |
      | ClientEntity.StatusID                   |               0 |
      | ClientEntity.StatusName                 | Disabled        |
      | ClientEntity.BusinessUnitID             |              10 |
      | ClientEntity.BusinessUnitName           | Default         |
      | ClientEntity.HandledByUserGroupID       |             325 |
      | ClientEntity.HandledByUserGroupName     | Handler Group   |
      | ClientEntity.HandledByUserID            |             521 |
      | ClientEntity.HandledByUserName          | Automation User |
      | ClientEntity.RiskID                     |             134 |
      | ClientEntity.RiskName                   | High            |
      | ClientEntity.AdverseMediaFileCriteriaID |            1080 |
    When user store the response body have keyData with keyName
      | key                             | storeKey           |
      | ClientEntity.ClientEntityID     | ClientEntityID     |
      | ClientEntity.InterfaceReference | InterfaceReference |
    Then response body should match the schema from the file "AddCustomer"

  Scenario: 019 Fetch a Client Entity based on Client Entity Identifier
    Given user has a service named "/api/v1/client/entity/getinternal"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
    And response body should have key with the value:
      | key                        | value           |
      | InterfaceReference         | APIADDCUSTOMER  |
      | LastName                   | KUMAR           |
      | FirstName                  | AKSHAY          |
      | MiddleName                 | HARI            |
      | CriteriaID                 |             253 |
      | CriteriaName               | Person 2        |
      | GenderID                   |               1 |
      | GenderName                 | Male            |
      | StatusID                   |               0 |
      | StatusName                 | Disabled        |
      | BusinessUnitID             |              10 |
      | BusinessUnitName           | Default         |
      | HandledByUserGroupID       |             325 |
      | HandledByUserGroupName     | Handler Group   |
      | HandledByUserID            |             521 |
      | HandledByUserName          | Automation User |
      | RiskID                     |             134 |
      | RiskName                   | High            |
      | AdverseMediaFileCriteriaID |            1080 |

  Scenario: 020 Screen a Client Entity based on Client Entity Identifier. #ENG-1409
    Given user has a service named "/api/v1/client/entity/screeninternal"
    And user has a payload from the file "AddCustomer" with selected keys "ActionUserID,ReturnFormat,BusinessUnitID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                            | storedKey          |
      |     1 | ClientEntityID                 | ClientEntityID     |
      |     1 | ClientEntityInterfaceReference | InterfaceReference |
    And response body in ascending order should have index key with the contains value:
      | index | key                    | value         |
      |     1 | ClientEntityLastName   | KUMAR         |
      |     1 | ClientEntityFirstName  | AKSHAY        |
      |     1 | ClientEntityMiddleName | HARI          |
      |     1 | HandledByUserGroupID   |           325 |
      |     1 | HandledByUserGroupName | Handler Group |
      |     1 | HandledByUserID        |           521 |

  Scenario: 021 Fetch Match Potential records based on Interface Reference
    Given user has a service named "/api/v1/client/matchpotential/get"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "InterfaceReference" with the stored key value "InterfaceReference"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storekey with the value:
      | index | key            | storekey       |
      |     1 | ClientEntityID | ClientEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                            | value           |
      |     1 | ClientEntityInterfaceReference | APIADDCUSTOMER  |
      |     1 | ClientEntityLastName           | KUMAR           |
      |     1 | ClientEntityFirstName          | AKSHAY          |
      |     1 | ClientEntityMiddleName         | HARI            |
      |     1 | HandledByUserGroupID           |             325 |
      |     1 | HandledByUserGroupName         | Handler Group   |
      |     1 | HandledByUserID                |             521 |
      |     1 | HandledByUserName              | Automation User |

  Scenario: 022 Fetch a Client Entities Match Potentials, Discounts and Flags based on Client Entity Identifier. #ENG-1407
    Given user has a service named "/api/v1/client/entity/getdetailinternal"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat,BusinessUnitID"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                | storedKey          |
      | ClientEntityID     | ClientEntityID     |
      | InterfaceReference | InterfaceReference |
    And response body should have key with the value:
      | key              | value   |
      | BusinessUnitID   |      10 |
      | BusinessUnitName | Default |
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                                           | storedKey          |
      |     1 | MatchPotential.ClientEntityID                 | ClientEntityID     |
      |     1 | MatchPotential.ClientEntityInterfaceReference | InterfaceReference |
    And response body in ascending order should have index key with the contains value:
      | index | key                                   | value  |
      |     1 | MatchPotential.ClientEntityLastName   | KUMAR  |
      |     1 | MatchPotential.ClientEntityFirstName  | AKSHAY |
      |     1 | MatchPotential.ClientEntityMiddleName | HARI   |

  Scenario: 023 Reassign/Unassign a Client Match Potential based on Client Entity Identifier
    Given user has a service named "/api/v1/client/matchpotential/reassign"
    And user has a payload from the file "AddCustomer" with selected keys "ActionUserID,ReturnFormat,HandledByUserGroupID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payload "AssignToUserID":"527"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                | storedKey          |
      | ClientEntityID     | ClientEntityID     |
      | InterfaceReference | InterfaceReference |
    And response body should have key with the value:
      | key                        | value           |
      | LastName                   | KUMAR           |
      | FirstName                  | AKSHAY          |
      | MiddleName                 | HARI            |
      | CriteriaID                 |             253 |
      | CriteriaName               | Person 2        |
      | GenderID                   |               1 |
      | GenderName                 | Male            |
      | StatusID                   |               0 |
      | StatusName                 | Disabled        |
      | BusinessUnitID             |              10 |
      | BusinessUnitName           | Default         |
      | HandledByUserGroupID       |             325 |
      | HandledByUserGroupName     | Handler Group   |
      | HandledByUserID            |             521 |
      | HandledByUserName          | Automation User |
      | RiskID                     |             134 |
      | RiskName                   | High            |
      | AdverseMediaFileCriteriaID |            1080 |

  Scenario: 024 Fetch Match Potential records based on Client Entity Identifier
    Given user has a service named "/api/v1/client/matchpotential/getinternal"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                            | storedKey          |
      |     1 | ClientEntityID                 | ClientEntityID     |
      |     1 | ClientEntityInterfaceReference | InterfaceReference |
    And response body in ascending order should have index key with the contains value:
      | index | key                    | value              |
      |     1 | ClientEntityLastName   | KUMAR              |
      |     1 | ClientEntityFirstName  | AKSHAY             |
      |     1 | ClientEntityMiddleName | HARI               |
      |     1 | HandledByUserGroupID   |                325 |
      |     1 | HandledByUserGroupName | Handler Group      |
      |     1 | HandledByUserID        |                527 |
      |     1 | HandledByUserName      | HandlerGroupMember |
    When user store the response body have index keyData with keyName
      | index | key      | storeKey       |
      |     1 | EntityID | FirstEntityID  |
      |     2 | EntityID | SecondEntityID |
      |     3 | EntityID | ThirdEntityID  |
      |     4 | EntityID | FourthEntityID |
      |     5 | EntityID | FifthEntityID  |

  Scenario: 025 Take ownership of a Client Match Potential based on Client Entity Identifier
    Given user has a service named "/api/v1/client/matchpotential/takeownership"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat,HandledByUserGroupID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payload "UserID":"521"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                | storedKey          |
      | ClientEntityID     | ClientEntityID     |
      | InterfaceReference | InterfaceReference |
    And response body should have key with the value:
      | key                        | value           |
      | LastName                   | KUMAR           |
      | FirstName                  | AKSHAY          |
      | MiddleName                 | HARI            |
      | CriteriaID                 |             253 |
      | CriteriaName               | Person 2        |
      | GenderID                   |               1 |
      | GenderName                 | Male            |
      | StatusID                   |               0 |
      | StatusName                 | Disabled        |
      | BusinessUnitID             |              10 |
      | BusinessUnitName           | Default         |
      | HandledByUserGroupID       |             325 |
      | HandledByUserGroupName     | Handler Group   |
      | HandledByUserID            |             521 |
      | HandledByUserName          | Automation User |
      | RiskID                     |             134 |
      | RiskName                   | High            |
      | AdverseMediaFileCriteriaID |            1080 |

  Scenario: 026 Perform an Adverse Media Screen of a Client Entity based on Client Entity Identifier
    Given user has a service named "/api/v1/client/entity/adversemediascreeninternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'

  Scenario: 027 Delete all AVM PM
    Given user has a service named "/api/v1/client/adversemedia/matchpotential/deleteall"
    And user has a payload from the file "AddCustomer" with selected keys "ActionUserID,ReturnFormat,BusinessUnitID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storekey with the value:
      | index | key            | storekey       |
      |     1 | ClientEntityID | ClientEntityID |

  Scenario: 028 Match a Client Match Potential record by converting it into a Client Match Discounted or Flagged Record based on Client Entity Identifier
    Given user has a service named "api/v1/client/matchpotential/matchinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "EntityID" with the stored key value "FirstEntityID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payloads:
      """
      {
      "MatchType":"Discount",
      "Reason":"Testing",
      "MatchCategoryID":187,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | FirstEntityID  |
    And response body should have key with the value:
      | key                       | value                 |
      | ClientEntityLastName      | KUMAR                 |
      | ClientEntityFirstName     | AKSHAY                |
      | ClientEntityMiddleName    | HARI                  |
      | Reason                    | Testing               |
      | MatchDiscountCategoryID   |                   187 |
      | MatchDiscountCategoryName | Auto2DiscountCategory |
      | HandledByUserGroupID      |                   325 |
      | HandledByUserGroupName    | Handler Group         |
      | HandledByUserID           |                   521 |
      | HandledByUserName         | Automation User       |

  Scenario: 029 Update a Client Match Discounted record based on Interface Reference
    Given user has a service named "/api/v1/client/matchdiscounted/update"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "InterfaceReference" with the stored key value "InterfaceReference"
    And user add query parameter "EntityID" with the stored key value "FirstEntityID"
    And user has payloads:
      """
      {
      "ActionUserID":521,
      "Reason":"TestingUpdated",
      "MatchDiscountCategoryID":187,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | FirstEntityID  |
    And response body should have key with the value:
      | key                       | value                 |
      | ClientEntityLastName      | KUMAR                 |
      | ClientEntityFirstName     | AKSHAY                |
      | ClientEntityMiddleName    | HARI                  |
      | Reason                    | TestingUpdated        |
      | MatchDiscountCategoryID   |                   187 |
      | MatchDiscountCategoryName | Auto2DiscountCategory |
      | HandledByUserGroupID      |                   325 |
      | HandledByUserGroupName    | Handler Group         |
      | HandledByUserID           |                   521 |
      | HandledByUserName         | Automation User       |

  Scenario: 030 Fetch Match Discounted records based on Client Entity Identifier
    Given user has a service named "/api/v1/client/matchdiscounted/getinternal"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key            | storedKey      |
      |     1 | ClientEntityID | ClientEntityID |
      |     1 | EntityID       | FirstEntityID  |
    And response body in ascending order should have index key with the contains value:
      | index | key                       | value                 |
      |     1 | ClientEntityLastName      | KUMAR                 |
      |     1 | ClientEntityFirstName     | AKSHAY                |
      |     1 | ClientEntityMiddleName    | HARI                  |
      |     1 | Reason                    | TestingUpdated        |
      |     1 | MatchDiscountCategoryID   |                   187 |
      |     1 | MatchDiscountCategoryName | Auto2DiscountCategory |
      |     1 | HandledByUserGroupID      |                   325 |
      |     1 | HandledByUserGroupName    | Handler Group         |
      |     1 | HandledByUserID           |                   521 |
      |     1 | HandledByUserName         | Automation User       |

  Scenario: 031 Fetch Match Discounted records based on Client Entity Identifier and Dow Jones Entity Identifier
    Given user has a service named "/api/v1/client/matchdiscounted/getinternalentity"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user add query parameter "EntityID" with the stored key value "FirstEntityID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | FirstEntityID  |
    And response body should have key with the value:
      | key                       | value                 |
      | ClientEntityLastName      | KUMAR                 |
      | ClientEntityFirstName     | AKSHAY                |
      | ClientEntityMiddleName    | HARI                  |
      | Reason                    | TestingUpdated        |
      | MatchDiscountCategoryID   |                   187 |
      | MatchDiscountCategoryName | Auto2DiscountCategory |
      | HandledByUserGroupID      |                   325 |
      | HandledByUserGroupName    | Handler Group         |
      | HandledByUserID           |                   521 |
      | HandledByUserName         | Automation User       |

  Scenario: 032 Match a Client Match Potential record by converting it into a Client Match Discounted or Flagged Record based on Client Entity Identifier To Convert
    Given user has a service named "api/v1/client/matchpotential/matchinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "EntityID" with the stored key value "ThirdEntityID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payloads:
      """
      {
      "MatchType":"Discount",
      "Reason":"Testing",
      "MatchCategoryID":187,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | ThirdEntityID  |
    And response body should have key with the value:
      | key                       | value                 |
      | ClientEntityLastName      | KUMAR                 |
      | ClientEntityFirstName     | AKSHAY                |
      | ClientEntityMiddleName    | HARI                  |
      | Reason                    | Testing               |
      | MatchDiscountCategoryID   |                   187 |
      | MatchDiscountCategoryName | Auto2DiscountCategory |
      | HandledByUserGroupID      |                   325 |
      | HandledByUserGroupName    | Handler Group         |
      | HandledByUserID           |                   521 |
      | HandledByUserName         | Automation User       |

  Scenario: 033 Converts a Client Match Discounted record into a Client Match Flagged Record based on Interface Reference
    Given user has a service named "api/v1/client/matchdiscounted/convert"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "EntityID" with the stored key value "ThirdEntityID"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    And user has payloads:
      """
      {
      "Reason":"Testing",
      "MatchFlagCategoryID":379
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | ThirdEntityID  |
    And response body should have key with the value:
      | key                    | value           |
      | ClientEntityLastName   | KUMAR           |
      | ClientEntityFirstName  | AKSHAY          |
      | ClientEntityMiddleName | HARI            |
      | Reason                 | Testing         |
      | MatchFlagCategoryID    |             379 |
      | MatchFlagCategoryName  | Irrelevant      |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

  Scenario: 034 Match a Client Match Potential record by converting it into a Client Match Discounted or Flagged Record based on Client Entity Identifier To Convert
    Given user has a service named "api/v1/client/matchpotential/matchinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "EntityID" with the stored key value "FourthEntityID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payloads:
      """
      {
      "MatchType":"Discount",
      "Reason":"Testing",
      "MatchCategoryID":187,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | FourthEntityID |
    And response body should have key with the value:
      | key                       | value                 |
      | ClientEntityLastName      | KUMAR                 |
      | ClientEntityFirstName     | AKSHAY                |
      | ClientEntityMiddleName    | HARI                  |
      | Reason                    | Testing               |
      | MatchDiscountCategoryID   |                   187 |
      | MatchDiscountCategoryName | Auto2DiscountCategory |
      | HandledByUserGroupID      |                   325 |
      | HandledByUserGroupName    | Handler Group         |
      | HandledByUserID           |                   521 |
      | HandledByUserName         | Automation User       |

  Scenario: 035 Converts a Client Match Discounted record into a Client Match Flagged record based on Client Entity Identifier
    Given user has a service named "/api/v1/client/matchdiscounted/convertinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "EntityID" with the stored key value "FourthEntityID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payloads:
      """
      {
      "Reason":"Testing",
      "MatchFlagCategoryID":379
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | FourthEntityID |
    And response body should have key with the value:
      | key                    | value           |
      | ClientEntityLastName   | KUMAR           |
      | ClientEntityFirstName  | AKSHAY          |
      | ClientEntityMiddleName | HARI            |
      | Reason                 | Testing         |
      | MatchFlagCategoryID    |             379 |
      | MatchFlagCategoryName  | Irrelevant      |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

  Scenario: 036 Match a Client Match Potential record by converting it into a Client Match Discounted or Flagged Record based on Client Entity Identifier
    Given user has a service named "api/v1/client/matchpotential/matchinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "EntityID" with the stored key value "FifthEntityID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payloads:
      """
      {
      "MatchType":"Discount",
      "Reason":"Testing",
      "MatchCategoryID":187,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | FifthEntityID  |
    And response body should have key with the value:
      | key                       | value                 |
      | ClientEntityLastName      | KUMAR                 |
      | ClientEntityFirstName     | AKSHAY                |
      | ClientEntityMiddleName    | HARI                  |
      | Reason                    | Testing               |
      | MatchDiscountCategoryID   |                   187 |
      | MatchDiscountCategoryName | Auto2DiscountCategory |
      | HandledByUserGroupID      |                   325 |
      | HandledByUserGroupName    | Handler Group         |
      | HandledByUserID           |                   521 |
      | HandledByUserName         | Automation User       |

  Scenario: 037 Update a Client Match Discounted record based on Client Entity Identifier
    Given user has a service named "/api/v1/client/matchdiscounted/updateinternal"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user add query parameter "EntityID" with the stored key value "FifthEntityID"
    And user has payloads:
      """
      {
      "ActionUserID":521,
      "Reason":"TestingUpdated",
      "MatchDiscountCategoryID":187,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | FifthEntityID  |
    And response body should have key with the value:
      | key                       | value                 |
      | ClientEntityLastName      | KUMAR                 |
      | ClientEntityFirstName     | AKSHAY                |
      | ClientEntityMiddleName    | HARI                  |
      | Reason                    | TestingUpdated        |
      | MatchDiscountCategoryID   |                   187 |
      | MatchDiscountCategoryName | Auto2DiscountCategory |
      | HandledByUserGroupID      |                   325 |
      | HandledByUserGroupName    | Handler Group         |
      | HandledByUserID           |                   521 |
      | HandledByUserName         | Automation User       |

  Scenario: 038 Fetch Match Discounted Audit records based on User Identifier and Date Range. #ENG-T1250
    Given user has a service named "/api/v1/client/matchdiscounted/audit/getall"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat,BusinessUnitID"
    And user has query parameter "UserID":"521"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                            | value                 |
      |     1 | ClientEntityInterfaceReference | APIADDCUSTOMER        |
      |     1 | ClientEntityLastName           | KUMAR                 |
      |     1 | ClientEntityFirstName          | AKSHAY                |
      |     1 | ClientEntityMiddleName         | HARI                  |
      |     1 | Reason                         | TestingUpdated        |
      |     1 | MatchDiscountCategoryID        |                   187 |
      |     1 | MatchDiscountCategoryName      | Auto2DiscountCategory |
      |     1 | HandledByUserGroupID           |                   325 |
      |     1 | HandledByUserGroupName         | Handler Group         |
      |     1 | HandledByUserID                |                   521 |
      |     1 | HandledByUserName              | Automation User       |
    When user store the response body have index keyData with keyName
      | index | key           | storeKey      |
      |     1 | AuditTranDate | AuditTranDate |
      |     1 | EntityID      | AuditEntityID |
      |     1 | AuditTypeID   | AuditTypeID   |

  Scenario: 039 Fetch an existing Match Discounted Audit record based on Client Entity Identifier, Dow Jones Entity Identifier and Audit Date
    Given user has a service named "/api/v1/client/matchdiscounted/audit/get"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user add query parameter "EntityID" with the stored key value "AuditEntityID"
    And user add query parameter "TransactionDate" with the stored key value "AuditTranDate"
    And user add query parameter "AuditType" with the stored key value "AuditTypeID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | AuditEntityID  |
      | AuditTypeID    | AuditTypeID    |
    And response body should have key with the value:
      | key                       | value                 |
      | ClientEntityLastName      | KUMAR                 |
      | ClientEntityFirstName     | AKSHAY                |
      | ClientEntityMiddleName    | HARI                  |
      | Reason                    | TestingUpdated        |
      | MatchDiscountCategoryID   |                   187 |
      | MatchDiscountCategoryName | Auto2DiscountCategory |
      | HandledByUserGroupID      |                   325 |
      | HandledByUserGroupName    | Handler Group         |
      | HandledByUserID           |                   521 |
      | HandledByUserName         | Automation User       |

  Scenario: 040 Delete a Client Match Discounted record based on Client Entity Identifier
    Given user has a service named "/api/v1/client/matchdiscounted/deleteinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user add payload "EntityID" with the stored key value "FifthEntityID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | FifthEntityID  |
    And response body should have key with the value:
      | key                       | value                 |
      | ClientEntityLastName      | KUMAR                 |
      | ClientEntityFirstName     | AKSHAY                |
      | ClientEntityMiddleName    | HARI                  |
      | Reason                    | TestingUpdated        |
      | MatchDiscountCategoryID   |                   187 |
      | MatchDiscountCategoryName | Auto2DiscountCategory |
      | HandledByUserGroupID      |                   325 |
      | HandledByUserGroupName    | Handler Group         |
      | HandledByUserID           |                   521 |
      | HandledByUserName         | Automation User       |

  Scenario: 041 Delete Discount PM
    Given user has a service named "/api/v1/client/matchdiscounted/delete"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,InterfaceReference,ActionUserID,ReturnFormat"
    And user add payload "EntityID" with the stored key value "FirstEntityID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | FirstEntityID  |
    And response body should have key with the value:
      | key                       | value                 |
      | ClientEntityLastName      | KUMAR                 |
      | ClientEntityFirstName     | AKSHAY                |
      | ClientEntityMiddleName    | HARI                  |
      | Reason                    | TestingUpdated        |
      | MatchDiscountCategoryID   |                   187 |
      | MatchDiscountCategoryName | Auto2DiscountCategory |
      | HandledByUserGroupID      |                   325 |
      | HandledByUserGroupName    | Handler Group         |
      | HandledByUserID           |                   521 |
      | HandledByUserName         | Automation User       |

  Scenario: 042 Delete a Client Match Potential record based on Client Entity Identifier
    Given user has a service named "/api/v1/client/matchpotential/deleteinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "EntityID" with the stored key value "SecondEntityID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | SecondEntityID |
    And response body should have key with the value:
      | key                    | value           |
      | ClientEntityLastName   | KUMAR           |
      | ClientEntityFirstName  | AKSHAY          |
      | ClientEntityMiddleName | HARI            |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

  Scenario: 043 Delete all PM
    Given user has a service named "/api/v1/client/matchpotential/deleteallinternal"
    And user has a payload from the file "AddCustomer" with selected keys "ActionUserID,ReturnFormat,BusinessUnitID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storekey with the value:
      | index | key            | storekey       |
      |     1 | ClientEntityID | ClientEntityID |

  Scenario: 044 Screen a Client Entity based on Client Entity Identifier
    Given user has a service named "/api/v1/client/entity/screeninternal"
    And user has a payload from the file "AddCustomer" with selected keys "ActionUserID,ReturnFormat,BusinessUnitID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                            | storedKey          |
      |     1 | ClientEntityID                 | ClientEntityID     |
      |     1 | ClientEntityInterfaceReference | InterfaceReference |
    And response body in ascending order should have index key with the contains value:
      | index | key                    | value         |
      |     1 | ClientEntityLastName   | KUMAR         |
      |     1 | ClientEntityFirstName  | AKSHAY        |
      |     1 | ClientEntityMiddleName | HARI          |
      |     1 | HandledByUserGroupID   |           325 |
      |     1 | HandledByUserGroupName | Handler Group |
      |     1 | HandledByUserID        |           521 |

  Scenario: 045 Fetch Match Potential records based on Client Entity Identifier
    Given user has a service named "/api/v1/client/matchpotential/getinternal"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                            | storedKey          |
      |     1 | ClientEntityID                 | ClientEntityID     |
      |     1 | ClientEntityInterfaceReference | InterfaceReference |
    And response body in ascending order should have index key with the contains value:
      | index | key                    | value           |
      |     1 | ClientEntityLastName   | KUMAR           |
      |     1 | ClientEntityFirstName  | AKSHAY          |
      |     1 | ClientEntityMiddleName | HARI            |
      |     1 | HandledByUserGroupID   |             325 |
      |     1 | HandledByUserGroupName | Handler Group   |
      |     1 | HandledByUserID        |             521 |
      |     1 | HandledByUserName      | Automation User |
    When user store the response body have index keyData with keyName
      | index | key      | storeKey       |
      |     1 | EntityID | FirstEntityID  |
      |     2 | EntityID | SecondEntityID |
      |     3 | EntityID | ThirdEntityID  |
      |     4 | EntityID | FourthEntityID |
      |     5 | EntityID | FifthEntityID  |

  Scenario: 046 Match a Client Match Potential record by converting it into a Client Match Discounted or Flagged Record based on Client Entity Identifier
    Given user has a service named "api/v1/client/matchpotential/matchinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "EntityID" with the stored key value "FirstEntityID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payloads:
      """
       {
      "MatchType":"Flag",
      "Reason":"Testing",
      "MatchCategoryID":379,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | FirstEntityID  |
    And response body should have key with the value:
      | key                    | value           |
      | ClientEntityLastName   | KUMAR           |
      | ClientEntityFirstName  | AKSHAY          |
      | ClientEntityMiddleName | HARI            |
      | Reason                 | Testing         |
      | MatchFlagCategoryID    |             379 |
      | MatchFlagCategoryName  | Irrelevant      |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

  Scenario: 047 Match a Client Match Potential record by converting it into a Client Match Discounted or Flagged Record based on Client Entity Identifier
    Given user has a service named "api/v1/client/matchpotential/matchinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "EntityID" with the stored key value "SecondEntityID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payloads:
      """
       {
      "MatchType":"Flag",
      "Reason":"Testing",
      "MatchCategoryID":379,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | SecondEntityID |
    And response body should have key with the value:
      | key                    | value           |
      | ClientEntityLastName   | KUMAR           |
      | ClientEntityFirstName  | AKSHAY          |
      | ClientEntityMiddleName | HARI            |
      | Reason                 | Testing         |
      | MatchFlagCategoryID    |             379 |
      | MatchFlagCategoryName  | Irrelevant      |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

  Scenario: 048 Match a Client Match Potential record by converting it into a Client Match Discounted or Flagged Record based on Client Entity Identifier
    Given user has a service named "api/v1/client/matchpotential/matchinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "EntityID" with the stored key value "ThirdEntityID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payloads:
      """
       {
      "MatchType":"Flag",
      "Reason":"Testing",
      "MatchCategoryID":379,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | ThirdEntityID  |
    And response body should have key with the value:
      | key                    | value           |
      | ClientEntityLastName   | KUMAR           |
      | ClientEntityFirstName  | AKSHAY          |
      | ClientEntityMiddleName | HARI            |
      | Reason                 | Testing         |
      | MatchFlagCategoryID    |             379 |
      | MatchFlagCategoryName  | Irrelevant      |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

  Scenario: 049 Match a Client Match Potential record by converting it into a Client Match Discounted or Flagged Record based on Client Entity Identifier
    Given user has a service named "api/v1/client/matchpotential/matchinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "EntityID" with the stored key value "FourthEntityID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payloads:
      """
       {
      "MatchType":"Flag",
      "Reason":"Testing",
      "MatchCategoryID":379,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | FourthEntityID |
    And response body should have key with the value:
      | key                    | value           |
      | ClientEntityLastName   | KUMAR           |
      | ClientEntityFirstName  | AKSHAY          |
      | ClientEntityMiddleName | HARI            |
      | Reason                 | Testing         |
      | MatchFlagCategoryID    |             379 |
      | MatchFlagCategoryName  | Irrelevant      |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

  Scenario: 050 Match a Client Match Potential record by converting it into a Client Match Discounted or Flagged Record based on Client Entity Identifier
    Given user has a service named "api/v1/client/matchpotential/matchinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "EntityID" with the stored key value "FifthEntityID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payloads:
      """
       {
      "MatchType":"Flag",
      "Reason":"Testing",
      "MatchCategoryID":379,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | FifthEntityID  |
    And response body should have key with the value:
      | key                    | value           |
      | ClientEntityLastName   | KUMAR           |
      | ClientEntityFirstName  | AKSHAY          |
      | ClientEntityMiddleName | HARI            |
      | Reason                 | Testing         |
      | MatchFlagCategoryID    |             379 |
      | MatchFlagCategoryName  | Irrelevant      |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

  Scenario: 051 Converts a Client Match Flagged record into a Client Match Discounted Record based on Interface Reference
    Given user has a service named "api/v1/client/matchflagged/convert"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "EntityID" with the stored key value "FirstEntityID"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    And user has payloads:
      """
      {
      "Reason":"Testing",
      "MatchDiscountCategoryID":187
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | FirstEntityID  |
    And response body should have key with the value:
      | key                       | value                 |
      | ClientEntityLastName      | KUMAR                 |
      | ClientEntityFirstName     | AKSHAY                |
      | ClientEntityMiddleName    | HARI                  |
      | Reason                    | Testing               |
      | MatchDiscountCategoryID   |                   187 |
      | MatchDiscountCategoryName | Auto2DiscountCategory |
      | HandledByUserGroupID      |                   325 |
      | HandledByUserGroupName    | Handler Group         |
      | HandledByUserID           |                   521 |
      | HandledByUserName         | Automation User       |

  Scenario: 052 Update a Client Match Flagged record based on Interface Reference
    Given user has a service named "/api/v1/client/matchflagged/update"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "InterfaceReference" with the stored key value "InterfaceReference"
    And user add query parameter "EntityID" with the stored key value "SecondEntityID"
    And user has payloads:
      """
      {
      "ActionUserID":521,
      "Reason":"TestingUpdated",
      "MatchFlagCategoryID":418,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | SecondEntityID |
    And response body should have key with the value:
      | key                    | value           |
      | ClientEntityLastName   | KUMAR           |
      | ClientEntityFirstName  | AKSHAY          |
      | ClientEntityMiddleName | HARI            |
      | Reason                 | TestingUpdated  |
      | MatchFlagCategoryID    |             418 |
      | MatchFlagCategoryName  | New Env         |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

  Scenario: 053 Delete a Client Match Flagged record based on Interface Reference
    Given user has a service named "/api/v1/client/matchflagged/delete"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    And user add payload "EntityID" with the stored key value "SecondEntityID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | SecondEntityID |
    And response body should have key with the value:
      | key                    | value           |
      | ClientEntityLastName   | KUMAR           |
      | ClientEntityFirstName  | AKSHAY          |
      | ClientEntityMiddleName | HARI            |
      | Reason                 | TestingUpdated  |
      | MatchFlagCategoryID    |             418 |
      | MatchFlagCategoryName  | New Env         |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

  Scenario: 054 Fetch Match Flagged records based on Client Entity Identifier
    Given user has a service named "/api/v1/client/matchflagged/getinternal"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key            | storedKey      |
      |     1 | ClientEntityID | ClientEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                    | value           |
      |     1 | ClientEntityLastName   | KUMAR           |
      |     1 | ClientEntityFirstName  | AKSHAY          |
      |     1 | ClientEntityMiddleName | HARI            |
      |     1 | Reason                 | Testing         |
      |     1 | MatchFlagCategoryID    |             379 |
      |     1 | MatchFlagCategoryName  | Irrelevant      |
      |     1 | HandledByUserGroupID   |             325 |
      |     1 | HandledByUserGroupName | Handler Group   |
      |     1 | HandledByUserID        |             521 |
      |     1 | HandledByUserName      | Automation User |

  Scenario: 055 Fetch Match Flagged records based on Client Entity Identifier and Dow Jones Entity Identifier
    Given user has a service named "/api/v1/client/matchflagged/getinternalentity"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user add query parameter "EntityID" with the stored key value "ThirdEntityID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | ThirdEntityID  |
    And response body should have key with the value:
      | key                    | value           |
      | ClientEntityLastName   | KUMAR           |
      | ClientEntityFirstName  | AKSHAY          |
      | ClientEntityMiddleName | HARI            |
      | Reason                 | Testing         |
      | MatchFlagCategoryID    |             379 |
      | MatchFlagCategoryName  | Irrelevant      |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

  Scenario: 056 Converts a Client Match Flagged record into a Client Match Discounted record based on Client Entity Identifier
    Given user has a service named "/api/v1/client/matchflagged/convertinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "EntityID" with the stored key value "FourthEntityID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payloads:
      """
      {
      "Reason":"Testing",
      "MatchDiscountCategoryID":187
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | FourthEntityID |
    And response body should have key with the value:
      | key                       | value                 |
      | ClientEntityLastName      | KUMAR                 |
      | ClientEntityFirstName     | AKSHAY                |
      | ClientEntityMiddleName    | HARI                  |
      | Reason                    | Testing               |
      | MatchDiscountCategoryID   |                   187 |
      | MatchDiscountCategoryName | Auto2DiscountCategory |
      | HandledByUserGroupID      |                   325 |
      | HandledByUserGroupName    | Handler Group         |
      | HandledByUserID           |                   521 |
      | HandledByUserName         | Automation User       |

  Scenario: 057 Update a Client Match Flagged record based on Client Entity Identifier
    Given user has a service named "/api/v1/client/matchflagged/updateinternal"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user add query parameter "EntityID" with the stored key value "FifthEntityID"
    And user has payloads:
      """
      {
      "ActionUserID":521,
      "Reason":"TestingUpdated",
      "MatchFlagCategoryID":418,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | FifthEntityID  |
    And response body should have key with the value:
      | key                    | value           |
      | ClientEntityLastName   | KUMAR           |
      | ClientEntityFirstName  | AKSHAY          |
      | ClientEntityMiddleName | HARI            |
      | Reason                 | TestingUpdated  |
      | MatchFlagCategoryID    |             418 |
      | MatchFlagCategoryName  | New Env         |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

  Scenario: 058 Fetch Match Flagged Audit records based on User Identifier and Date Range. #ENG-T1251
    Given user has a service named "/api/v1/client/matchflagged/audit/getall"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat,BusinessUnitID"
    And user has query parameter "UserID":"521"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                            | value           |
      |     1 | ClientEntityInterfaceReference | APIADDCUSTOMER  |
      |     1 | ClientEntityLastName           | KUMAR           |
      |     1 | ClientEntityFirstName          | AKSHAY          |
      |     1 | ClientEntityMiddleName         | HARI            |
      |     1 | Reason                         | TestingUpdated  |
      |     1 | MatchFlagCategoryID            |             418 |
      |     1 | MatchFlagCategoryName          | New Env         |
      |     1 | HandledByUserGroupID           |             325 |
      |     1 | HandledByUserGroupName         | Handler Group   |
      |     1 | HandledByUserID                |             521 |
      |     1 | HandledByUserName              | Automation User |
    When user store the response body have index keyData with keyName
      | index | key           | storeKey      |
      |     1 | AuditTranDate | AuditTranDate |
      |     1 | EntityID      | AuditEntityID |
      |     1 | AuditTypeID   | AuditTypeID   |

  Scenario: 059 Fetch an existing Match Flagged Audit record based on Client Entity Identifier, Dow Jones Entity Identifier and Audit Date
    Given user has a service named "/api/v1/client/matchflagged/audit/get"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user add query parameter "EntityID" with the stored key value "AuditEntityID"
    And user add query parameter "TransactionDate" with the stored key value "AuditTranDate"
    And user add query parameter "AuditType" with the stored key value "AuditTypeID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | AuditEntityID  |
      | AuditTypeID    | AuditTypeID    |
    And response body should have key with the value:
      | key                    | value           |
      | ClientEntityLastName   | KUMAR           |
      | ClientEntityFirstName  | AKSHAY          |
      | ClientEntityMiddleName | HARI            |
      | Reason                 | TestingUpdated  |
      | MatchFlagCategoryID    |             418 |
      | MatchFlagCategoryName  | New Env         |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

  Scenario: 060 Delete a Client Match Flagged record based on Client Entity Identifier
    Given user has a service named "/api/v1/client/matchflagged/deleteinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user add payload "EntityID" with the stored key value "FifthEntityID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey      |
      | ClientEntityID | ClientEntityID |
      | EntityID       | FifthEntityID  |
    And response body should have key with the value:
      | key                    | value           |
      | ClientEntityLastName   | KUMAR           |
      | ClientEntityFirstName  | AKSHAY          |
      | ClientEntityMiddleName | HARI            |
      | Reason                 | TestingUpdated  |
      | MatchFlagCategoryID    |             418 |
      | MatchFlagCategoryName  | New Env         |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

  Scenario: 061 Update a Client Entity based on Client Entity Identifier
    Given user has a service named "/api/v1/client/entity/updateinternal"
    And user has a query params from the file "AddCustomer" with selected keys "Screen,ReturnFormat,BusinessUnitID"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user has a payload from the file "AddCustomer"
    And user has payloads:
      """
      {
      "LastName":"KUMARUPDATE",
      "FirstName":"AKSHAYUPDATE",
      "MiddleName":"HARIUPDATE",
      "GenderID":2
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                     | value           |
      | ClientEntity.InterfaceReference         | APIADDCUSTOMER  |
      | ClientEntity.LastName                   | KUMARUPDATE     |
      | ClientEntity.FirstName                  | AKSHAYUPDATE    |
      | ClientEntity.MiddleName                 | HARIUPDATE      |
      | ClientEntity.CriteriaID                 |             253 |
      | ClientEntity.CriteriaName               | Person 2        |
      | ClientEntity.GenderID                   |               2 |
      | ClientEntity.GenderName                 | Female          |
      | ClientEntity.StatusID                   |               0 |
      | ClientEntity.StatusName                 | Disabled        |
      | ClientEntity.BusinessUnitID             |              10 |
      | ClientEntity.BusinessUnitName           | Default         |
      | ClientEntity.HandledByUserGroupID       |             325 |
      | ClientEntity.HandledByUserGroupName     | Handler Group   |
      | ClientEntity.HandledByUserID            |             521 |
      | ClientEntity.HandledByUserName          | Automation User |
      | ClientEntity.RiskID                     |             134 |
      | ClientEntity.RiskName                   | High            |
      | ClientEntity.AdverseMediaFileCriteriaID |            1080 |
    When user store the response body have keyData with keyName
      | key                             | storeKey           |
      | ClientEntity.ClientEntityID     | ClientEntityID     |
      | ClientEntity.InterfaceReference | InterfaceReference |

  Scenario: 062 Update status of a Client Entity based on Client Entity Identifier
    Given user has a service named "/api/v1/client/entity/updatestatusinternal"
    And user has a payload from the file "AddCustomer" with selected keys "ActionUserID,ReturnFormat,BusinessUnitID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payload "Status":"0"
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                        | value           |
      | InterfaceReference         | APIADDCUSTOMER  |
      | LastName                   | KUMARUPDATE     |
      | FirstName                  | AKSHAYUPDATE    |
      | MiddleName                 | HARIUPDATE      |
      | CriteriaID                 |             253 |
      | CriteriaName               | Person 2        |
      | GenderID                   |               2 |
      | GenderName                 | Female          |
      | StatusID                   |               0 |
      | StatusName                 | Disabled        |
      | BusinessUnitID             |              10 |
      | BusinessUnitName           | Default         |
      | HandledByUserGroupID       |             325 |
      | HandledByUserGroupName     | Handler Group   |
      | HandledByUserID            |             521 |
      | HandledByUserName          | Automation User |
      | RiskID                     |             134 |
      | RiskName                   | High            |
      | AdverseMediaFileCriteriaID |            1080 |
    When user store the response body have keyData with keyName
      | key                | storeKey           |
      | ClientEntityID     | ClientEntityID     |
      | InterfaceReference | InterfaceReference |

  Scenario: 063 Fetch Client Entity Audit records based on User Identifier and Date Range
    Given user has a service named "/api/v1/client/entity/audit/getall"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat,BusinessUnitID"
    And user has query parameter "UserID":"521"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                    | value           |
      |     1 | InterfaceReference     | APIADDCUSTOMER  |
      |     1 | LastName               | KUMARUPDATE     |
      |     1 | FirstName              | AKSHAYUPDATE    |
      |     1 | MiddleName             | HARIUPDATE      |
      |     1 | CriteriaID             |             253 |
      |     1 | CriteriaName           | Person 2        |
      |     1 | GenderID               |               2 |
      |     1 | GenderName             | Female          |
      |     1 | StatusID               |               0 |
      |     1 | StatusName             | Disabled        |
      |     1 | BusinessUnitID         |              10 |
      |     1 | BusinessUnitName       | Default         |
      |     1 | HandledByUserGroupID   |             325 |
      |     1 | HandledByUserGroupName | Handler Group   |
      |     1 | HandledByUserID        |             521 |
      |     1 | HandledByUserName      | Automation User |
      |     1 | RiskID                 |             134 |
      |     1 | RiskName               | High            |
    When user store the response body have index keyData with keyName
      | index | key                | storeKey           |
      |     1 | InterfaceReference | InterfaceReference |
      |     1 | ClientEntityID     | ClientEntityID     |
      |     1 | AuditTypeID        | AuditTypeID        |
      |     1 | AuditTranDate      | AuditTranDate      |

  Scenario: 064 Fetch an existing Client Entity Audit record based on Client Entity Identifier and Audit Date
    Given user has a service named "/api/v1/client/entity/audit/get"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat,BusinessUnitID"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user add query parameter "AuditType" with the stored key value "AuditTypeID"
    And user add query parameter "TransactionDate" with the stored key value "AuditTranDate"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key           | storedKey     |
      | AuditTypeID   | AuditTypeID   |
      | AuditTranDate | AuditTranDate |
    And response body should have key with the value:
      | key                    | value           |
      | InterfaceReference     | APIADDCUSTOMER  |
      | LastName               | KUMARUPDATE     |
      | FirstName              | AKSHAYUPDATE    |
      | MiddleName             | HARIUPDATE      |
      | CriteriaID             |             253 |
      | CriteriaName           | Person 2        |
      | GenderID               |               2 |
      | GenderName             | Female          |
      | StatusID               |               0 |
      | StatusName             | Disabled        |
      | BusinessUnitID         |              10 |
      | BusinessUnitName       | Default         |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |
      | RiskID                 |             134 |
      | RiskName               | High            |
    When user store the response body have keyData with keyName
      | key                | storeKey           |
      | ClientEntityID     | ClientEntityID     |
      | InterfaceReference | InterfaceReference |

  Scenario: 065 Fetch Client Entity Audit records based on User Identifier, Date Range in batches for the given PageIndex and Number of Rows to fetch
    Given user has a service named "/api/v1/client/entity/audit/getallpaged"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat,BusinessUnitID"
    And user has query parameter "UserID":"521"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    And user has query parameter "SearchString":""
    And user has query parameter "SearchOn":"0"
    And user has query parameter "SearchType":"0"
    And user has query parameter "SearchStatus":"2"
    And user has query parameter "CurrentPage":"1"
    And user has query parameter "PageSize":"100"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                         | value           |
      |     1 | Data.InterfaceReference     | APIADDCUSTOMER  |
      |     1 | Data.LastName               | KUMAR           |
      |     1 | Data.FirstName              | AKSHAY          |
      |     1 | Data.MiddleName             | HARI            |
      |     1 | Data.CriteriaID             |             253 |
      |     1 | Data.CriteriaName           | Person 2        |
      |     1 | Data.GenderID               |               1 |
      |     1 | Data.GenderName             | Male            |
      |     1 | Data.StatusID               |               0 |
      |     1 | Data.StatusName             | Disabled        |
      |     1 | Data.BusinessUnitID         |              10 |
      |     1 | Data.BusinessUnitName       | Default         |
      |     1 | Data.HandledByUserGroupID   |             325 |
      |     1 | Data.HandledByUserGroupName | Handler Group   |
      |     1 | Data.HandledByUserID        |             521 |
      |     1 | Data.HandledByUserName      | Automation User |
      |     1 | Data.RiskID                 |             134 |
      |     1 | Data.RiskName               | High            |
    When user store the response body have keyData with keyName
      | index | key                     | storeKey           |
      |     1 | Data.ClientEntityID     | ClientEntityID     |
      |     1 | Data.InterfaceReference | InterfaceReference |

  Scenario: 066 Delete Customer
    Given user has a service named "/api/v1/client/entity/deleteinternal"
    And user has a payload from the file "AddCustomer" with selected keys "ActionUserID,ReturnFormat,BusinessUnitID"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                | storedKey          |
      | ClientEntityID     | ClientEntityID     |
      | InterfaceReference | InterfaceReference |
    And response body should have key with the value:
      | key        | value        |
      | LastName   | KUMARUPDATE  |
      | FirstName  | AKSHAYUPDATE |
      | MiddleName | HARIUPDATE   |

  Scenario: 067 Fetch Match Potential records based on Row information
    Given user has a service named "/api/v1/client/matchpotential/getrows"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "RowOffset":"1"
    And user has query parameter "RowsToFetch":"1"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                    | value |
      | RowsHeader.RowOffset   |     1 |
      | RowsHeader.RowsFetched |     1 |
    And response body in ascending order should have index key with the contains value:
      | index | key                                 | value               |
      |     1 | Data.ClientEntityID                 |              412743 |
      |     1 | Data.ClientEntityInterfaceReference | AK1                 |
      |     1 | Data.ClientEntityLastName           | KUMAR1              |
      |     1 | Data.ClientEntityFirstName          | AKSHAY              |
      |     1 | Data.EntityID                       |             2273009 |
      |     1 | Data.EntityFullName                 | ABHAY KUMAR         |
      |     1 | Data.EntityLastName                 | KUMAR               |
      |     1 | Data.EntityLastNameJCBias           |            0.944444 |
      |     1 | Data.EntityFirstName                | ABHAY               |
      |     1 | Data.EntityMiddleNameJCBias         |                   0 |
      |     1 | Data.HandledByUserGroupID           |                 325 |
      |     1 | Data.HandledByUserGroupName         | Handler Group       |
      |     1 | Data.HandledByUserID                |                 528 |
      |     1 | Data.HandledByUserName              | Report_HandlerUser1 |

  Scenario: 068 Fetch Client Match Potential Summary records based on Row information
    Given user has a service named "/api/v1/client/matchpotentialsummary/getrows"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "RowOffset":"1"
    And user has query parameter "RowsToFetch":"1"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                    | value |
      | RowsHeader.RowOffset   |     1 |
      | RowsHeader.RowsFetched |     1 |
    And response body in ascending order should have index key with the contains value:
      | index | key                                 | value               |
      |     1 | Data.ClientEntityID                 |              412744 |
      |     1 | Data.ClientEntityInterfaceReference | AK2                 |
      |     1 | Data.ClientEntityLastName           | KUMAR2              |
      |     1 | Data.ClientEntityFirstName          | AKSHAY              |
      |     1 | Data.HandledByUserGroupID           |                 325 |
      |     1 | Data.HandledByUserGroupName         | Handler Group       |
      |     1 | Data.HandledByUserID                |                 528 |
      |     1 | Data.HandledByUserName              | Report_HandlerUser1 |

  Scenario: 069 Fetch Client Match Potential Summary records based on Interface Reference
    Given user has a service named "/api/v1/client/matchpotentialsummary/get"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "InterfaceReference":"AK2"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                            | value               |
      | ClientEntityID                 |              412744 |
      | ClientEntityInterfaceReference | AK2                 |
      | ClientEntityLastName           | KUMAR2              |
      | ClientEntityFirstName          | AKSHAY              |
      | HandledByUserGroupID           |                 325 |
      | HandledByUserGroupName         | Handler Group       |
      | HandledByUserID                |                 528 |
      | HandledByUserName              | Report_HandlerUser1 |

  Scenario: 070 Fetch Client Match Potential Summary records based on Client Entity Identifier
    Given user has a service named "/api/v1/client/matchpotentialsummary/getinternal"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "ClientEntityID":"412744"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                            | value               |
      | ClientEntityID                 |              412744 |
      | ClientEntityInterfaceReference | AK2                 |
      | ClientEntityLastName           | KUMAR2              |
      | ClientEntityFirstName          | AKSHAY              |
      | HandledByUserGroupID           |                 325 |
      | HandledByUserGroupName         | Handler Group       |
      | HandledByUserID                |                 528 |
      | HandledByUserName              | Report_HandlerUser1 |

  Scenario: 071 Fetch Match Discounted records based on Row information
    Given user has a service named "/api/v1/client/matchdiscounted/getrows"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "RowOffset":"1"
    And user has query parameter "RowsToFetch":"1"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                    | value |
      | RowsHeader.RowOffset   |     1 |
      | RowsHeader.RowsFetched |     1 |
    And response body in ascending order should have index key with the contains value:
      | index | key                                 | value                                |
      |     1 | Data.ClientEntityID                 |                               412753 |
      |     1 | Data.ClientEntityInterfaceReference | 847B0BBC-229A-4A48-926C-1D22F78FC9A6 |
      |     1 | Data.ClientEntityLastName           | KUMAR                                |
      |     1 | Data.ClientEntityFirstName          | AKSHAY                               |
      |     1 | Data.HandledByUserGroupID           |                                  325 |
      |     1 | Data.HandledByUserGroupName         | Handler Group                        |
      |     1 | Data.HandledByUserID                |                                  521 |
      |     1 | Data.HandledByUserName              | Automation User                      |

  Scenario: 072 Fetch Match Discounted records based on Interface Reference
    Given user has a service named "/api/v1/client/matchdiscounted/get"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "InterfaceReference":"847B0BBC-229A-4A48-926C-1D22F78FC9A6"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                            | value                                |
      |     1 | ClientEntityID                 |                               412753 |
      |     1 | ClientEntityInterfaceReference | 847B0BBC-229A-4A48-926C-1D22F78FC9A6 |
      |     1 | ClientEntityLastName           | KUMAR                                |
      |     1 | ClientEntityFirstName          | AKSHAY                               |
      |     1 | HandledByUserGroupID           |                                  325 |
      |     1 | HandledByUserGroupName         | Handler Group                        |
      |     1 | HandledByUserID                |                                  521 |
      |     1 | HandledByUserName              | Automation User                      |
    When user store the response body have index keyData with keyName
      | index | key      | storeKey |
      |     1 | EntityID | EntityID |

  Scenario: 073 Fetch Match Discounted records based on Interface Reference and Dow Jones Entity Identifier
    Given user has a service named "/api/v1/client/matchdiscounted/getentity"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "InterfaceReference":"847B0BBC-229A-4A48-926C-1D22F78FC9A6"
    And user add query parameter "EntityID" with the stored key value "EntityID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key      | storedKey |
      | EntityID | EntityID  |
    And response body in ascending order should have index key with the contains value:
      | key                            | value                                |
      | ClientEntityID                 |                               412753 |
      | ClientEntityInterfaceReference | 847B0BBC-229A-4A48-926C-1D22F78FC9A6 |
      | ClientEntityLastName           | KUMAR                                |
      | ClientEntityFirstName          | AKSHAY                               |
      | HandledByUserGroupID           |                                  325 |
      | HandledByUserGroupName         | Handler Group                        |
      | HandledByUserID                |                                  521 |
      | HandledByUserName              | Automation User                      |

  Scenario: 074 Fetch Match Flagged records based on Row information
    Given user has a service named "/api/v1/client/matchflagged/getrows"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "RowOffset":"1"
    And user has query parameter "RowsToFetch":"1"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                    | value |
      | RowsHeader.RowOffset   |     1 |
      | RowsHeader.RowsFetched |     1 |
    And response body in ascending order should have index key with the contains value:
      | index | key                                 | value                                |
      |     1 | Data.ClientEntityID                 |                               412754 |
      |     1 | Data.ClientEntityInterfaceReference | DE925748-D2C5-4F70-B9A2-61897B1E136F |
      |     1 | Data.ClientEntityLastName           | KUMAR                                |
      |     1 | Data.ClientEntityFirstName          | AKSHAY                               |
      |     1 | Data.HandledByUserGroupID           |                                  325 |
      |     1 | Data.HandledByUserGroupName         | Handler Group                        |
      |     1 | Data.HandledByUserID                |                                  521 |
      |     1 | Data.HandledByUserName              | Automation User                      |

  Scenario: 075 Fetch Match Flagged records based on Interface Reference
    Given user has a service named "/api/v1/client/matchflagged/get"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "InterfaceReference":"DE925748-D2C5-4F70-B9A2-61897B1E136F"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                            | value                                |
      |     1 | ClientEntityID                 |                               412754 |
      |     1 | ClientEntityInterfaceReference | DE925748-D2C5-4F70-B9A2-61897B1E136F |
      |     1 | ClientEntityLastName           | KUMAR                                |
      |     1 | ClientEntityFirstName          | AKSHAY                               |
      |     1 | HandledByUserGroupID           |                                  325 |
      |     1 | HandledByUserGroupName         | Handler Group                        |
      |     1 | HandledByUserID                |                                  521 |
      |     1 | HandledByUserName              | Automation User                      |
    When user store the response body have index keyData with keyName
      | index | key      | storeKey |
      |     1 | EntityID | EntityID |

  Scenario: 076 Fetch Match Flagged records based on Interface Reference and Dow Jones Entity Identifier
    Given user has a service named "/api/v1/client/matchflagged/getentity"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "InterfaceReference":"DE925748-D2C5-4F70-B9A2-61897B1E136F"
    And user add query parameter "EntityID" with the stored key value "EntityID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key      | storedKey |
      | EntityID | EntityID  |
    And response body in ascending order should have index key with the contains value:
      | key                            | value                                |
      | ClientEntityID                 |                               412754 |
      | ClientEntityInterfaceReference | DE925748-D2C5-4F70-B9A2-61897B1E136F |
      | ClientEntityLastName           | KUMAR                                |
      | ClientEntityFirstName          | AKSHAY                               |
      | HandledByUserGroupID           |                                  325 |
      | HandledByUserGroupName         | Handler Group                        |
      | HandledByUserID                |                                  521 |
      | HandledByUserName              | Automation User                      |

  Scenario: 077 Fetch client entity report successfully in json format #ENG-T11596
    Given user has a service named "/api/v1/client/entity/getreport"
    And user has a query params from the file "ClientEntityReport" with selected keys "BusinessUnitID,ClientEntityID,ActionUserID,ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    #Defect Raised - #ENG-10640

  Scenario: 078 Fetch client entity report successfully in xml format #ENG-T11596
    Given user has a service named "/api/v1/client/entity/getreport"
    And user has a query params from the file "ClientEntityReport" with selected keys "BusinessUnitID,ClientEntityID,ActionUserID"
    And user has query parameter "ReturnFormat":"xml"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/xml; charset=utf-8'
    #Defect Raised - #ENG-10640

  Scenario: 079 Fetch client entity report successfully with using default business unit Id #ENG-T11597
    Given user has a service named "/api/v1/client/entity/getreport"
    And user has a query params from the file "ClientEntityReport" with selected keys "ClientEntityID,ActionUserID,ReturnFormat"
    And user has query parameter "BusinessUnitID":"10"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    #Defect Raised - #ENG-10640

  Scenario: 080 Fetch client entity report successfully in json format in Non-Default BU #ENG-T11596
    Given user has a service named "/api/v1/client/entity/getreport"
    And user has a query params from the file "ClientEntityReport" with selected keys "ActionUserID,ReturnFormat"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "ClientEntityID":"447840"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    #Defect Raised - #ENG-10640

  Scenario: 081 Fetch client entity report unsuccessfully with using invalid BU id parameter #ENG-T11610
    Given user has a service named "/api/v1/client/entity/getreport"
    And user has a query params from the file "ClientEntityReport" with selected keys "ClientEntityID,ActionUserID,ReturnFormat"
    And user has query parameter "BusinessUnitID":"abc"
    When user sends a 'GET' request
    Then response status should be 406
    And response header should be 'content-type':'application/json; charset=utf-8'

  Scenario: 082 Fetch client entity report unsuccessfully without using Client Entity Id #ENG-T11605
    Given user has a service named "/api/v1/client/entity/getreport"
    And user has a query params from the file "ClientEntityReport" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 406
    And response header should be 'content-type':'application/json; charset=utf-8'

  Scenario: 083 Fetch client entity report unsuccessfully with using invalid ReturnFormat parameter #ENG-T11604
    Given user has a service named "/api/v1/client/entity/getreport"
    And user has a query params from the file "ClientEntityReport" with selected keys "BusinessUnitID,ClientEntityID,ActionUserID,"
    And user has query parameter "ReturnFormat":"pdf"
    When user sends a 'GET' request
    Then response status should be 406
    And response header should be 'content-type':'application/json; charset=utf-8'

  Scenario: 084 Fetch client entity report unsuccessfully with using invalid ActionUserID parameter #ENG-T11600
    Given user has a service named "/api/v1/client/entity/getreport"
    And user has a query params from the file "ClientEntityReport" with selected keys "BusinessUnitID,ClientEntityID,ReturnFormat"
    And user has query parameter "ClientEntityID":"447840"
    And user has query parameter "ActionUserID":"1000"
    When user sends a 'GET' request
    Then response status should be 400
    And response header should be 'content-type':'text/plain; charset=utf-8'

  Scenario: 085 Fetch client entity report unsuccessfully with using invalid APIKEY #ENG-T11598
    When user is authorized using an 'INVALIDAPIKEY'
    And user has a service named "/api/v1/client/entity/getreport"
    And user has a query params from the file "ClientEntityReport" with selected keys "BusinessUnitID,ClientEntityID,ActionUserID,ReturnFormat"
    And user sends a 'GET' request
    Then response status should be 401

  Scenario: 086 Fetch client entity report unsuccessfully using client entity id of different BU #ENG-T11611
    Given user has a service named "/api/v1/client/entity/getreport"
    And user has a query params from the file "ClientEntityReport" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user has query parameter "ClientEntityID":"446960"
    When user sends a 'GET' request
    Then response status should be 400
    And response header should be 'content-type':'text/plain; charset=utf-8'

  @IdSearchImport
  Scenario: 087 Reject Import with ID Entries When ID Search Is Disabled #ENG-T13753,T1400,1401
    Given user has a service named "/api/v1/client/entity/import"
    And user has header "Content-Type":"application/json"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user has query parameter "IncludeDetailInResult":"true"
    And user has a raw payload from the file "ImportCustomerWithIds" with updates:
      | 0.InterfaceReference | CLIENT_ID_SEARCH_OFF_IMPORT |
    When user sends a 'POST' request
    Then response status should be 406
    And response body should contains "Your subscription level does not allow for Id entries!"
    And response body should contains "Please contact sales to add this to your subscription."