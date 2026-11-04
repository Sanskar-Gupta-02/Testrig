@Regression @AVM
Feature: AVM Reports API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Add Customer
    Given user has a service named "/api/v1/client/entity/add"
    And user has a payload from the file "AddCustomer"
    And user has payload "InterfaceReference":"APIADDCUSTOMERAVM"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                     | value             |
      | ClientEntity.InterfaceReference         | APIADDCUSTOMERAVM |
      | ClientEntity.LastName                   | KUMAR             |
      | ClientEntity.FirstName                  | AKSHAY            |
      | ClientEntity.MiddleName                 | HARI              |
      | ClientEntity.CriteriaID                 |               253 |
      | ClientEntity.CriteriaName               | Person 2          |
      | ClientEntity.GenderID                   |                 1 |
      | ClientEntity.GenderName                 | Male              |
      | ClientEntity.StatusID                   |                 0 |
      | ClientEntity.StatusName                 | Disabled            |
      | ClientEntity.BusinessUnitID             |                10 |
      | ClientEntity.BusinessUnitName           | Default           |
      | ClientEntity.HandledByUserGroupID       |               325 |
      | ClientEntity.HandledByUserGroupName     | Handler Group     |
      | ClientEntity.HandledByUserID            |               521 |
      | ClientEntity.HandledByUserName          | Automation User   |
      | ClientEntity.RiskID                     |               134 |
      | ClientEntity.RiskName                   | High              |
      | ClientEntity.AdverseMediaFileCriteriaID |              1080 |
    When user store the response body have keyData with keyName
      | key                             | storeKey           |
      | ClientEntity.ClientEntityID     | ClientEntityID     |
      | ClientEntity.InterfaceReference | InterfaceReference |
    Then response body should match the schema from the file "AddCustomer"

  Scenario: 002 AVM screen
    Given user has a service named "/api/v1/client/entity/adversemediascreen"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'

  Scenario: 003 Fetch AVM Match Potential records based on Client Entity and Handled by User Group Identifiers
    Given user has a service named "/api/v1/client/adversemedia/matchpotential/getallinternal"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,HandledByUserGroupID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                            | storedKey          |
      |     1 | ClientEntityID                 | ClientEntityID     |
      |     1 | ClientEntityInterfaceReference | InterfaceReference |
    And response body in ascending order should have index key with the contains value:
      | index | key                    | value  |
      |     1 | ClientEntityLastName   | KUMAR  |
      |     1 | ClientEntityFirstName  | AKSHAY |
      |     1 | ClientEntityMiddleName | HARI   |
    When user store the response body have index keyData with keyName
      | index | key           | storeKey            |
      |     1 | LinkUniqueKey | FirstLinkUniqueKey  |
      |     2 | LinkUniqueKey | SecondLinkUniqueKey |
      |     3 | LinkUniqueKey | ThirdLinkUniqueKey  |
      |     4 | LinkUniqueKey | FourthLinkUniqueKey |

  Scenario: 004 Fetch the AVM Match Potential record based on Client Entity and Link Unique Key Identifiers
    Given user has a service named "/api/v1/client/adversemedia/matchpotential/getinternal"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user add query parameter "LinkUniqueKey" with the stored key value "FirstLinkUniqueKey"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                            | storedKey          |
      | ClientEntityID                 | ClientEntityID     |
      | ClientEntityInterfaceReference | InterfaceReference |
      | LinkUniqueKey                  | FirstLinkUniqueKey |
    And response body should have key with the value:
      | key                    | value           |
      | ClientEntityLastName   | KUMAR           |
      | ClientEntityFirstName  | AKSHAY          |
      | ClientEntityMiddleName | HARI            |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

 Scenario: 005 Match a Client AVM Match Potential record by converting it into a Discounted or Flagged Record based on Interface Reference
    Given user has a service named "/api/v1/client/adversemedia/matchpotential/match"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "LinkUniqueKey" with the stored key value "FirstLinkUniqueKey"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    And user has payloads:
      """
      {
      "MatchType":"Discount",
      "Reason":"AVMReport",
      "MatchCategoryID":86,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                            | storedKey          |
      | ClientEntityID                 | ClientEntityID     |
      | ClientEntityInterfaceReference | InterfaceReference |
      | LinkUniqueKey                  | FirstLinkUniqueKey |
    And response body should have key with the value:
      | key                       | value           |
      | ClientEntityLastName      | KUMAR           |
      | ClientEntityFirstName     | AKSHAY          |
      | ClientEntityMiddleName    | HARI            |
      | Reason                    | AVMReport       |
      | MatchDiscountCategoryID   |              86 |
      | MatchDiscountCategoryName | Other           |
      | HandledByUserGroupID      |             325 |
      | HandledByUserGroupName    | Handler Group   |
      | HandledByUserID           |             521 |
      | HandledByUserName         | Automation User |

  Scenario: 006 Fetch AVM Match Discounted records based on Interface Reference and Link Unique Key Identifier
    Given user has a service named "/api/v1/client/adversemedia/matchdiscounted/getitem"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat , BusinessUnitID"
    And user add query parameter "LinkUniqueKey" with the stored key value "FirstLinkUniqueKey"
    And user add query parameter "InterfaceReference" with the stored key value "InterfaceReference"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                            | storedKey          |
      | ClientEntityID                 | ClientEntityID     |
      | ClientEntityInterfaceReference | InterfaceReference |
      | LinkUniqueKey                  | FirstLinkUniqueKey |
    And response body should have key with the value:
      | key                       | value           |
      | ClientEntityLastName      | KUMAR           |
      | ClientEntityFirstName     | AKSHAY          |
      | ClientEntityMiddleName    | HARI            |
      | Reason                    | AVMReport       |
      | MatchDiscountCategoryID   |              86 |
      | MatchDiscountCategoryName | Other           |
      | HandledByUserGroupID      |             325 |
      | HandledByUserGroupName    | Handler Group   |
      | HandledByUserID           |             521 |
      | HandledByUserName         | Automation User |

  Scenario: 007 Fetch AVM Match Discounted records based on Interface Reference. #ENG-T1187
    Given user has a service named "/api/v1/client/adversemedia/matchdiscounted/get"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat , BusinessUnitID"
    And user add query parameter "InterfaceReference" with the stored key value "InterfaceReference"
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
      |     1 | HandledByUserGroupID   |             325 |
      |     1 | HandledByUserGroupName | Handler Group   |
      |     1 | HandledByUserID        |             521 |
      |     1 | HandledByUserName      | Automation User |
    When user store the response body have index keyData with keyName
      | index | key           | storeKey                   |
      |     1 | LinkUniqueKey | MatchDiscountLinkUniqueKey |

  Scenario: 008 Match a Client AVM Match Potential record by converting it into a Discounted or Flagged Record based on Client Entity Identifier #ENG-T1170
    Given user has a service named "api/v1/client/adversemedia/matchpotential/matchinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "LinkUniqueKeys" with the stored key value "SecondLinkUniqueKey"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payloads:
      """
      {
      "MatchType":"Discount",
      "Reason":"AVMReport",
      "MatchCategoryID":86,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                       | value           |
      |     1 | ClientEntityLastName      | KUMAR           |
      |     1 | ClientEntityFirstName     | AKSHAY          |
      |     1 | ClientEntityMiddleName    | HARI            |
      |     1 | Reason                    | AVMReport       |
      |     1 | MatchDiscountCategoryID   |              86 |
      |     1 | MatchDiscountCategoryName | Other           |
      |     1 | HandledByUserGroupID      |             325 |
      |     1 | HandledByUserGroupName    | Handler Group   |
      |     1 | HandledByUserID           |             521 |
      |     1 | HandledByUserName         | Automation User |
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                            | storedKey           |
      |     1 | ClientEntityID                 | ClientEntityID      |
      |     1 | ClientEntityInterfaceReference | InterfaceReference  |
      |     1 | LinkUniqueKey                  | SecondLinkUniqueKey |

  Scenario: 009 Reassign/Unassign a Client AVM Match Potential based on Client Entity Identifier #ENG-T1171
    Given user has a service named "/api/v1/client/adversemedia/matchpotential/reassign"
    And user has a payload from the file "AddCustomer" with selected keys "ActionUserID,ReturnFormat,HandledByUserGroupID,BusinessUnitID"
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
      | StatusName                 | Disabled          |
      | BusinessUnitID             |              10 |
      | BusinessUnitName           | Default         |
      | HandledByUserGroupID       |             325 |
      | HandledByUserGroupName     | Handler Group   |
      | HandledByUserID            |             521 |
      | HandledByUserName          | Automation User |
      | RiskID                     |             134 |
      | RiskName                   | High            |
      | AdverseMediaFileCriteriaID |            1080 |

  Scenario: 010 Take ownership of a Client AVM Match Potential based on Client Entity Identifier #ENG-T1172
    Given user has a service named "/api/v1/client/adversemedia/matchpotential/takeownership"
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
      | StatusName                 | Disabled          |
      | BusinessUnitID             |              10 |
      | BusinessUnitName           | Default         |
      | HandledByUserGroupID       |             325 |
      | HandledByUserGroupName     | Handler Group   |
      | HandledByUserID            |             521 |
      | HandledByUserName          | Automation User |
      | RiskID                     |             134 |
      | RiskName                   | High            |
      | AdverseMediaFileCriteriaID |            1080 |

  Scenario: 011 Fetch Client AVM Match Potential Summary records based on Row information
    Given user has a service named "/api/v1/client/adversemedia/matchpotentialsummary/getrows"
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
      |     1 | Data.ClientEntityInterfaceReference | AK44                |
      |     1 | Data.ClientEntityID                 |              412762 |
      |     1 | Data.ClientEntityLastName           | KUMAR4              |
      |     1 | Data.ClientEntityFirstName          | AKSHAY              |
      |     1 | Data.HandledByUserGroupID           |                 325 |
      |     1 | Data.HandledByUserGroupName         | Handler Group       |
      |     1 | Data.HandledByUserID                |                 528 |
      |     1 | Data.HandledByUserName              | Report_HandlerUser1 |

  Scenario: 012 Fetch Client AVM Match Potential Summary records based on Interface Reference
    Given user has a service named "/api/v1/client/adversemedia/matchpotentialsummary/get"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "InterfaceReference":"AK44"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                            | value               |
      | ClientEntityID                 |              412762 |
      | ClientEntityInterfaceReference | AK44                |
      | ClientEntityLastName           | KUMAR4              |
      | ClientEntityFirstName          | AKSHAY              |
      | HandledByUserGroupID           |                 325 |
      | HandledByUserGroupName         | Handler Group       |
      | HandledByUserID                |                 528 |
      | HandledByUserName              | Report_HandlerUser1 |

  Scenario: 013 Fetch Client AVM Match Potential Summary records based on Interface Reference for priorities
    Given user has a service named "/api/v1/client/adversemedia/matchpotentialsummary/getall"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "InterfaceReference":"AK44"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                            | value               |
      |     1 | ClientEntityInterfaceReference | AK44                |
      |     1 | ClientEntityID                 |              412762 |
      |     1 | ClientEntityLastName           | KUMAR4              |
      |     1 | ClientEntityFirstName          | AKSHAY              |
      |     1 | HandledByUserGroupID           |                 325 |
      |     1 | HandledByUserGroupName         | Handler Group       |
      |     1 | HandledByUserID                |                 528 |
      |     1 | HandledByUserName              | Report_HandlerUser1 |

  Scenario: 014 Fetch Client AVM Match Potential Summary records based on Client Entity Identifier
    Given user has a service named "/api/v1/client/adversemedia/matchpotentialsummary/getinternal"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "ClientEntityID":"412762"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                            | value               |
      | ClientEntityID                 |              412762 |
      | ClientEntityInterfaceReference | AK44                |
      | ClientEntityLastName           | KUMAR4              |
      | ClientEntityFirstName          | AKSHAY              |
      | HandledByUserGroupID           |                 325 |
      | HandledByUserGroupName         | Handler Group       |
      | HandledByUserID                |                 528 |
      | HandledByUserName              | Report_HandlerUser1 |

  Scenario: 015 Update a Client AVM Match Discounted record based on Interface Reference and LinkUniqueKey
    Given user has a service named "/api/v1/client/adversemedia/matchdiscounted/update"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "InterfaceReference" with the stored key value "InterfaceReference"
    And user add query parameter "LinkUniqueKey" with the stored key value "FirstLinkUniqueKey"
    And user has payloads:
      """
      {
      "ActionUserID":521,
      "Reason":"AVMReportUpdated",
      "MatchDiscountCategoryID":86,
      "ValidToDate":"2999-12-16"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey          |
      | ClientEntityID | ClientEntityID     |
      | LinkUniqueKey  | FirstLinkUniqueKey |
    And response body should have key with the value:
      | key                       | value            |
      | ClientEntityLastName      | KUMAR            |
      | ClientEntityFirstName     | AKSHAY           |
      | ClientEntityMiddleName    | HARI             |
      | Reason                    | AVMReportUpdated |
      | MatchDiscountCategoryID   |               86 |
      | MatchDiscountCategoryName | Other            |
      | HandledByUserGroupID      |              325 |
      | HandledByUserGroupName    | Handler Group    |
      | HandledByUserID           |              521 |
      | HandledByUserName         | Automation User  |

  Scenario: 016 Delete a Client AVM Match Discounted record based on Interface Reference and Link Unique Key
    Given user has a service named "/api/v1/client/adversemedia/matchdiscounted/delete"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    And user add payload "LinkUniqueKey" with the stored key value "FirstLinkUniqueKey"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey          |
      | ClientEntityID | ClientEntityID     |
      | LinkUniqueKey  | FirstLinkUniqueKey |
    And response body should have key with the value:
      | key                       | value            |
      | ClientEntityLastName      | KUMAR            |
      | ClientEntityFirstName     | AKSHAY           |
      | ClientEntityMiddleName    | HARI             |
      | Reason                    | AVMReportUpdated |
      | MatchDiscountCategoryID   |               86 |
      | MatchDiscountCategoryName | Other            |
      | HandledByUserGroupID      |              325 |
      | HandledByUserGroupName    | Handler Group    |
      | HandledByUserID           |              521 |
      | HandledByUserName         | Automation User  |

  Scenario: 017 Fetch AVM Match Discounted records based on Client Entity Identifier
    Given user has a service named "/api/v1/client/adversemedia/matchdiscounted/getinternal"
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
      | index | key                    | value  |
      |     1 | ClientEntityLastName   | KUMAR  |
      |     1 | ClientEntityFirstName  | AKSHAY |
      |     1 | ClientEntityMiddleName | HARI   |

  Scenario: 018 Fetch AVM Match Discounted records based on Client Entity Identifier and Link Unique Key Identifier
    Given user has a service named "/api/v1/client/adversemedia/matchdiscounted/getiteminternal"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user add query parameter "LinkUniqueKey" with the stored key value "SecondLinkUniqueKey"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                            | storedKey           |
      | ClientEntityID                 | ClientEntityID      |
      | ClientEntityInterfaceReference | InterfaceReference  |
      | LinkUniqueKey                  | SecondLinkUniqueKey |
    And response body should have key with the value:
      | key                    | value           |
      | ClientEntityLastName   | KUMAR           |
      | ClientEntityFirstName  | AKSHAY          |
      | ClientEntityMiddleName | HARI            |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

  Scenario: 019 Update a Client AVM Match Discounted record based on Client Entity and Link Unique Key Identifier
    Given user has a service named "/api/v1/client/adversemedia/matchdiscounted/updateinternal"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user add query parameter "LinkUniqueKey" with the stored key value "SecondLinkUniqueKey"
    And user has payloads:
      """
      {
      "ActionUserID":521,
      "Reason":"AVMReportUpdated",
      "MatchDiscountCategoryID":86,
      "ValidToDate":"2999-12-16"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey           |
      | ClientEntityID | ClientEntityID      |
      | LinkUniqueKey  | SecondLinkUniqueKey |
    And response body should have key with the value:
      | key                       | value            |
      | ClientEntityLastName      | KUMAR            |
      | ClientEntityFirstName     | AKSHAY           |
      | ClientEntityMiddleName    | HARI             |
      | Reason                    | AVMReportUpdated |
      | MatchDiscountCategoryID   |               86 |
      | MatchDiscountCategoryName | Other            |
      | HandledByUserGroupID      |              325 |
      | HandledByUserGroupName    | Handler Group    |
      | HandledByUserID           |              521 |
      | HandledByUserName         | Automation User  |

  Scenario: 020 Delete a Client AVM Match Discounted record based on Client Entity and Link Unique Key Identifier
    Given user has a service named "/api/v1/client/adversemedia/matchdiscounted/deleteinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user add payload "LinkUniqueKey" with the stored key value "SecondLinkUniqueKey"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey           |
      | ClientEntityID | ClientEntityID      |
      | LinkUniqueKey  | SecondLinkUniqueKey |
    And response body should have key with the value:
      | key                       | value            |
      | ClientEntityLastName      | KUMAR            |
      | ClientEntityFirstName     | AKSHAY           |
      | ClientEntityMiddleName    | HARI             |
      | Reason                    | AVMReportUpdated |
      | MatchDiscountCategoryID   |               86 |
      | MatchDiscountCategoryName | Other            |
      | HandledByUserGroupID      |              325 |
      | HandledByUserGroupName    | Handler Group    |
      | HandledByUserID           |              521 |
      | HandledByUserName         | Automation User  |

  Scenario: 021 AVM Flag matches
    Given user has a service named "/api/v1/client/adversemedia/matchpotential/match"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "LinkUniqueKey" with the stored key value "ThirdLinkUniqueKey"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    And user has payloads:
      """
      {
      "MatchType":"Flag",
      "Reason":"AVMReport",
      "MatchCategoryID":86,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                            | storedKey          |
      | ClientEntityID                 | ClientEntityID     |
      | ClientEntityInterfaceReference | InterfaceReference |
      | LinkUniqueKey                  | ThirdLinkUniqueKey |
    And response body should have key with the value:
      | key                    | value              |
      | ClientEntityLastName   | KUMAR              |
      | ClientEntityFirstName  | AKSHAY             |
      | ClientEntityMiddleName | HARI               |
      | Reason                 | AVMReport          |
      | MatchFlagCategoryID    |                 86 |
      | MatchFlagCategoryName  | Relevant-High Risk |
      | HandledByUserGroupID   |                325 |
      | HandledByUserGroupName | Handler Group      |
      | HandledByUserID        |                521 |
      | HandledByUserName      | Automation User    |

  Scenario: 022 Fetch AVM Match Flagged records based on Interface Reference
    Given user has a service named "/api/v1/client/adversemedia/matchflagged/get"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat , BusinessUnitID"
    And user add query parameter "InterfaceReference" with the stored key value "InterfaceReference"
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
      |     1 | HandledByUserGroupID   |             325 |
      |     1 | HandledByUserGroupName | Handler Group   |
      |     1 | HandledByUserID        |             521 |
      |     1 | HandledByUserName      | Automation User |

  Scenario: 023 Fetch AVM Match Flagged record based on Interface Reference and Link Unique Key Identifier
    Given user has a service named "/api/v1/client/adversemedia/matchflagged/getitem"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat , BusinessUnitID"
    And user add query parameter "LinkUniqueKey" with the stored key value "ThirdLinkUniqueKey"
    And user add query parameter "InterfaceReference" with the stored key value "InterfaceReference"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                            | storedKey          |
      | ClientEntityID                 | ClientEntityID     |
      | ClientEntityInterfaceReference | InterfaceReference |
      | LinkUniqueKey                  | ThirdLinkUniqueKey |
    And response body should have key with the value:
      | key                    | value              |
      | ClientEntityLastName   | KUMAR              |
      | ClientEntityFirstName  | AKSHAY             |
      | ClientEntityMiddleName | HARI               |
      | Reason                 | AVMReport          |
      | MatchFlagCategoryID    |                 86 |
      | MatchFlagCategoryName  | Relevant-High Risk |
      | HandledByUserGroupID   |                325 |
      | HandledByUserGroupName | Handler Group      |
      | HandledByUserID        |                521 |
      | HandledByUserName      | Automation User    |

  Scenario: 024 Update a Client AVM Match Flagged record based on Interface Reference and Link Unique Key
    Given user has a service named "/api/v1/client/adversemedia/matchflagged/update"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "InterfaceReference" with the stored key value "InterfaceReference"
    And user add query parameter "LinkUniqueKey" with the stored key value "ThirdLinkUniqueKey"
    And user has payloads:
      """
      {
      "ActionUserID":521,
      "Reason":"AVMReportUpdated",
      "MatchFlagCategoryID":86,
      "ValidToDate":"2999-12-16"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey          |
      | ClientEntityID | ClientEntityID     |
      | LinkUniqueKey  | ThirdLinkUniqueKey |
    And response body should have key with the value:
      | key                    | value              |
      | ClientEntityLastName   | KUMAR              |
      | ClientEntityFirstName  | AKSHAY             |
      | ClientEntityMiddleName | HARI               |
      | Reason                 | AVMReportUpdated   |
      | MatchFlagCategoryID    |                 86 |
      | MatchFlagCategoryName  | Relevant-High Risk |
      | HandledByUserGroupID   |                325 |
      | HandledByUserGroupName | Handler Group      |
      | HandledByUserID        |                521 |
      | HandledByUserName      | Automation User    |

  Scenario: 025 Delete a Client AVM Match Flagged record based on Interface Reference
    Given user has a service named "/api/v1/client/adversemedia/matchflagged/delete"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    And user add payload "LinkUniqueKey" with the stored key value "ThirdLinkUniqueKey"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey          |
      | ClientEntityID | ClientEntityID     |
      | LinkUniqueKey  | ThirdLinkUniqueKey |
    And response body should have key with the value:
      | key                    | value              |
      | ClientEntityLastName   | KUMAR              |
      | ClientEntityFirstName  | AKSHAY             |
      | ClientEntityMiddleName | HARI               |
      | Reason                 | AVMReportUpdated   |
      | MatchFlagCategoryID    |                 86 |
      | MatchFlagCategoryName  | Relevant-High Risk |
      | HandledByUserGroupID   |                325 |
      | HandledByUserGroupName | Handler Group      |
      | HandledByUserID        |                521 |
      | HandledByUserName      | Automation User    |

  Scenario: 026 AVM Flag matches
    Given user has a service named "/api/v1/client/adversemedia/matchpotential/match"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "LinkUniqueKey" with the stored key value "FourthLinkUniqueKey"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    And user has payloads:
      """
      {
      "MatchType":"Flag",
      "Reason":"AVMReport",
      "MatchCategoryID":86,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                            | storedKey           |
      | ClientEntityID                 | ClientEntityID      |
      | ClientEntityInterfaceReference | InterfaceReference  |
      | LinkUniqueKey                  | FourthLinkUniqueKey |
    And response body should have key with the value:
      | key                    | value              |
      | ClientEntityLastName   | KUMAR              |
      | ClientEntityFirstName  | AKSHAY             |
      | ClientEntityMiddleName | HARI               |
      | Reason                 | AVMReport          |
      | MatchFlagCategoryID    |                 86 |
      | MatchFlagCategoryName  | Relevant-High Risk |
      | HandledByUserGroupID   |                325 |
      | HandledByUserGroupName | Handler Group      |
      | HandledByUserID        |                521 |
      | HandledByUserName      | Automation User    |

  Scenario: 027 Fetch AVM Match Flagged records based on Client Entity Identifier.#ENG-T12580
    Given user has a service named "/api/v1/client/adversemedia/matchflagged/getinternal"
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
      | index | key                    | value  |
      |     1 | ClientEntityLastName   | KUMAR  |
      |     1 | ClientEntityFirstName  | AKSHAY |
      |     1 | ClientEntityMiddleName | HARI   |

  Scenario: 028 Fetch AVM Match Flagged records based on Client Entity and Link Unique Key Identifier
    Given user has a service named "/api/v1/client/adversemedia/matchflagged/getiteminternal"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user add query parameter "LinkUniqueKey" with the stored key value "FourthLinkUniqueKey"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                            | storedKey           |
      | ClientEntityID                 | ClientEntityID      |
      | ClientEntityInterfaceReference | InterfaceReference  |
      | LinkUniqueKey                  | FourthLinkUniqueKey |
    And response body should have key with the value:
      | key                    | value           |
      | ClientEntityLastName   | KUMAR           |
      | ClientEntityFirstName  | AKSHAY          |
      | ClientEntityMiddleName | HARI            |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

  Scenario: 029 Update a Client AVM Match Flagged record based on Client Entity and Link Unique Key Identifier
    Given user has a service named "/api/v1/client/adversemedia/matchflagged/updateinternal"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user add query parameter "LinkUniqueKey" with the stored key value "FourthLinkUniqueKey"
    And user has payloads:
      """
      {
      "ActionUserID":521,
      "Reason":"AVMReportUpdated",
      "MatchFlagCategoryID":86,
      "ValidToDate":"2999-12-16"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey           |
      | ClientEntityID | ClientEntityID      |
      | LinkUniqueKey  | FourthLinkUniqueKey |
    And response body should have key with the value:
      | key                    | value              |
      | ClientEntityLastName   | KUMAR              |
      | ClientEntityFirstName  | AKSHAY             |
      | ClientEntityMiddleName | HARI               |
      | Reason                 | AVMReportUpdated   |
      | MatchFlagCategoryID    |                 86 |
      | MatchFlagCategoryName  | Relevant-High Risk |
      | HandledByUserGroupID   |                325 |
      | HandledByUserGroupName | Handler Group      |
      | HandledByUserID        |                521 |
      | HandledByUserName      | Automation User    |

  Scenario: 030 Delete a Client AVM Match Flagged record based on Client Entity and Link Unique Key Identifier
    Given user has a service named "/api/v1/client/adversemedia/matchflagged/deleteinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user add payload "LinkUniqueKey" with the stored key value "FourthLinkUniqueKey"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey           |
      | ClientEntityID | ClientEntityID      |
      | LinkUniqueKey  | FourthLinkUniqueKey |
    And response body should have key with the value:
      | key                    | value              |
      | ClientEntityLastName   | KUMAR              |
      | ClientEntityFirstName  | AKSHAY             |
      | ClientEntityMiddleName | HARI               |
      | Reason                 | AVMReportUpdated   |
      | MatchFlagCategoryID    |                 86 |
      | MatchFlagCategoryName  | Relevant-High Risk |
      | HandledByUserGroupID   |                325 |
      | HandledByUserGroupName | Handler Group      |
      | HandledByUserID        |                521 |
      | HandledByUserName      | Automation User    |

  Scenario: 031 Delete all outstanding Client AVM Match Potential records based on Client Entity Identifier
    Given user has a service named "/api/v1/client/adversemedia/matchpotential/deleteall"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                            | storedKey          |
      |     1 | ClientEntityID                 | ClientEntityID     |
      |     1 | ClientEntityInterfaceReference | InterfaceReference |

  Scenario: 032 Delete Customer
    Given user has a service named "/api/v1/client/entity/delete"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key                | storedKey          |
      | ClientEntityID     | ClientEntityID     |
      | InterfaceReference | InterfaceReference |
    And response body should have key with the value:
      | key        | value  |
      | LastName   | KUMAR  |
      | FirstName  | AKSHAY |
      | MiddleName | HARI   |

  Scenario: 033 Add Customer.#ENG-T7418,T7416
    Given user has a service named "/api/v1/client/entity/add"
    And user has a payload from the file "AddCustomer"
    And user has payload "InterfaceReference":"APICUSTOMERAVMFORREASON"
    When user sends a 'POST' request
    Then response status should be 201
    When user store the response body have keyData with keyName
      | key                             | storeKey           |
      | ClientEntity.ClientEntityID     | ClientEntityID     |
      | ClientEntity.InterfaceReference | InterfaceReference |
    And user has a service named "/api/v1/client/entity/adversemediascreen"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    And user sends a 'POST' request
    Then response status should be 201
    When user has a service named "/api/v1/client/adversemedia/matchpotential/getallinternal"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,HandledByUserGroupID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user sends a 'GET' request
    Then response status should be 200
    When user store the response body have index keyData with keyName
      | index | key           | storeKey            |
      |     1 | LinkUniqueKey | FirstLinkUniqueKey  |
      |     2 | LinkUniqueKey | SecondLinkUniqueKey |
      |     3 | LinkUniqueKey | ThirdLinkUniqueKey  |
      |     4 | LinkUniqueKey | FourthLinkUniqueKey |

  Scenario: 034 Match a Client AVM Match Potential record by converting it into a Discounted Record based on Client Entity Identifier #ENG-T1170
    Given user has a service named "api/v1/client/adversemedia/matchpotential/matchinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "LinkUniqueKeys" with the stored key value "SecondLinkUniqueKey"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payloads:
      """
      {
      "MatchType":"Discount",
      "Reason":"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&()-_=+[",
      "MatchCategoryID":86,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response body in ascending order should have index key with the contains value:
      | index | key    | value                                                                        |
      |     1 | Reason | abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&()-_=+[ |

  Scenario: 035 Match a Client AVM Match Potential record by converting it into a Flagged Record based on Client Entity Identifier #ENG-T1170
    Given user has a service named "api/v1/client/adversemedia/matchpotential/matchinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "LinkUniqueKeys" with the stored key value "ThirdLinkUniqueKey"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user has payloads:
      """
      {
      "MatchType":"Flag",
      "Reason":"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&()-_=+[",
      "MatchCategoryID":86,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    And response body in ascending order should have index key with the contains value:
      | index | key    | value                                                                        |
      |     1 | Reason | abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&()-_=+[ |
    When user store the response body have index keyData with keyName
      | index | key    | storeKey |
      |     1 | Reason | Reason   |

  Scenario: 036 Match a Client AVM Match Potential record by converting it into a Flagged Record based on Client Entity Identifier #ENG-T1170
    Given user has a service named "api/v1/client/adversemedia/matchpotential/matchinternal"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "LinkUniqueKeys" with the stored key value "FourthLinkUniqueKey"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    And user add payload "largeCharacters" with the stored key value "Reason"
    And user has payloads:
      """
      {
      "MatchType":"Flag",
      "MatchCategoryID":86,
      "ValidToDate":"2999-12-16",
      "Notify":false
      }
      """
    When user sends a 'POST' request
    Then response status should be 406
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key     | value                                                             |
      |     1 | Message | The request is invalid.                                           |

  Scenario: 037 Delete Customer
    Given user has a service named "/api/v1/client/entity/delete"
    And user has a payload from the file "AddCustomer" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    When user sends a 'DELETE' request
    Then response status should be 200

  Scenario: 038 Verify batch/get -successfully fetch most recent AVM Batch run information.#ENG-T1166
    Given user has a service named "/api/v1/client/adversemedia/batch/get"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response body should have key with the value:
      | key                 | value                                          |
      | ClientID            |                                            116 |
      | ClientName          | STGLOADTEST-NONPKYC - Automation-QA-RiskScreen |
      | BusinessUnitID      |                                             10 |
      | BusinessUnitName    | Default                                        |

  Scenario: 039  AVM-Verify matchflagged/get- successfully fetch AVM Potential record using Interface Reference.#ENG-T1185
    Given user has a service named "/api/v1/client/adversemedia/matchflagged/get"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user has query parameter "InterfaceReference":"TESTAUTOMATION"
    When user sends a 'GET' request
    Then response status should be 200

  Scenario: 040 Verify matchdiscounted/getinternal-successfully fetch AVM Match Discounted records using Client Entity Identifier.#ENG-T1188
    Given user has a service named "/api/v1/client/adversemedia/matchdiscounted/getinternal"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user has query parameter "ClientEntityID":"447799"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                            | value                                                                                                                                                                                               |
      |     1 | ClientEntityID                 |                                                                                                                                                                                              447799 |
      |     1 | ClientEntityInterfaceReference | TESTAUTOMATION                                                                                                                                                                                      |
      |     1 | ClientEntityLastName           | AUTOMATION                                                                                                                                                                                          |
      |     1 | ClientEntityFirstName          |                                                                                                                                                                                                     |
      |     1 | ClientEntityMiddleName         |                                                                                                                                                                                                     |
      |     1 | LinkUniqueKey                  |                                                                                                                                                            3EA59EFB95E18310437D7D604880D746513050B6 |
      |     1 | Link                           | https://bankingjournal.aba.com/2026/04/recent-news-from-treasurys-office-of-foreign-assets-control-april-6/                                                                                         |
      |     1 | DisplayLink                    | https://bankingjournal.aba.com › Uncategorized                                                                                                                                                      |
      |     1 | GeneratedDate                  |                                                                                                                                                                                 2026-04-06 00:00:00 |
      |     1 | Snippet                        | 4 hours ago...<b>OFAC</b> clarifies <b>sanctions</b> risk under Venezuela general licenses: On March 31, <b>OFAC</b> ... How top agricultural lenders are approaching AI, <b>automation</b> and ... |
      |     1 | SearchEngineType               |                                                                                                                                                                                                   1 |
      |     1 | MatchedDate                    |                                                                                                                                                                                 2026-04-06 00:00:00 |
      |     1 | ActionDays                     |                                                                                                                                                                                                   0 |
      |     1 | Reason                         | Test                                                                                                                                                                                                |
      |     1 | MatchDiscountCategoryID        |                                                                                                                                                                                                  77 |
      |     1 | MatchDiscountCategoryName      | Auto2AVMDiscountCategory                                                                                                                                                                            |
      |     1 | MatchDiscountCategoryScrape    | true                                                                                                                                                                                                |
      |     1 | ValidToDate                    |                                                                                                                                                                                 2099-12-31 00:00:00 |
      |     1 | HandledByUserGroupID           |                                                                                                                                                                                                 324 |
      |     1 | HandledByUserGroupName         | Admin Group                                                                                                                                                                                         |
      |     1 | HandledByUserID                |                                                                                                                                                                                                 521 |
      |     1 | HandledByUserName              | Automation User                                                                                                                                                                                     |
      |     1 | ToBeScraped                    | false                                                                                                                                                                                               |
      |     2 | ClientEntityID                 |                                                                                                                                                                                              447799 |
      |     2 | ClientEntityInterfaceReference | TESTAUTOMATION                                                                                                                                                                                      |
      |     2 | ClientEntityLastName           | AUTOMATION                                                                                                                                                                                          |
      |     2 | ClientEntityFirstName          |                                                                                                                                                                                                     |
      |     2 | ClientEntityMiddleName         |                                                                                                                                                                                                     |
      |     2 | LinkUniqueKey                  |                                                                                                                                                            2C3B384D1AFD0493A156ED6B91F36EFAE2BB822B |
      |     2 | Link                           | https://www.dictionary.com/browse/automation                                                                                                                                                        |
      |     2 | DisplayLink                    | https://www.dictionary.com › browse › automation                                                                                                                                                    |
      |     2 | GeneratedDate                  |                                                                                                                                                                                 2026-04-06 00:00:00 |
      |     2 | Snippet                        |                        13 hours ago...<b>AUTOMATION</b> definition: the technique, method, or system of operating or controlling a process by highly automatic means, as by electronic devices, ... |
      |     2 | SearchEngineType               |                                                                                                                                                                                                   1 |
      |     2 | MatchedDate                    |                                                                                                                                                                                 2026-04-06 00:00:00 |
      |     2 | ActionDays                     |                                                                                                                                                                                                   0 |
      |     2 | Reason                         | Test                                                                                                                                                                                                |
      |     2 | MatchDiscountCategoryID        |                                                                                                                                                                                                  77 |
      |     2 | MatchDiscountCategoryName      | Auto2AVMDiscountCategory                                                                                                                                                                            |
      |     2 | MatchDiscountCategoryScrape    | true                                                                                                                                                                                                |
      |     2 | ValidToDate                    |                                                                                                                                                                                 2099-12-31 00:00:00 |
      |     2 | HandledByUserGroupID           |                                                                                                                                                                                                 324 |
      |     2 | HandledByUserGroupName         | Admin Group                                                                                                                                                                                         |
      |     2 | HandledByUserID                |                                                                                                                                                                                                 521 |
      |     2 | HandledByUserName              | Automation User                                                                                                                                                                                     |
      |     2 | ToBeScraped                    | false                                                                                                                                                                                               |
    Then response body should match the schema from the file "AVMDiscountResponse"

  Scenario: 041 Verify matchflagged/getinternal-successfully fetch AVM Match Flagged records using Client Entity Identifier.#ENG-T12580
    Given user has a service named "/api/v1/client/adversemedia/matchflagged/getinternal"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user has query parameter "ClientEntityID":"447799"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                            | value                                                                                                                                                                                    |
      |     1 | ClientEntityID                 |                                                                                                                                                                                   447799 |
      |     1 | ClientEntityInterfaceReference | TESTAUTOMATION                                                                                                                                                                           |
      |     1 | ClientEntityLastName           | AUTOMATION                                                                                                                                                                               |
      |     1 | ClientEntityFirstName          |                                                                                                                                                                                          |
      |     1 | ClientEntityMiddleName         |                                                                                                                                                                                          |
      |     1 | LinkUniqueKey                  | CC91CB9251D2DE58C5C6D9A183A3315C3685670A                                                                                                                                                 |
      |     1 | Link                           | https://steelindustry.news/ai-cybersecurity-jobs-how-automation-is-reshaping-work-and-risk-in-manufacturing/                                                                             |
      |     1 | DisplayLink                    | https://steelindustry.news › Technology › AI                                                                                                                                             |
      |     1 | GeneratedDate                  |                                                                                                                                                                      2026-04-06 00:00:00 |
      |     1 | Snippet                        |    6 hours ago...✓Key Takeaways. AI and robotics are reshaping manufacturing jobs, reducing some routine roles while creating new, higher skill positions in data, <b>automation</b> ... |
      |     1 | SearchEngineType               |                                                                                                                                                                                        1 |
      |     1 | MatchedDate                    |                                                                                                                                                                      2026-04-07 00:00:00 |
      |     1 | ActionDays                     |                                                                                                                                                                                        1 |
      |     1 | Reason                         | AUTO-TEST                                                                                                                                                                                |
      |     1 | MatchFlagCategoryID            |                                                                                                                                                                                       75 |
      |     1 | MatchFlagCategoryName          | Auto2AVMFlagCategory                                                                                                                                                                     |
      |     1 | MatchFlagCategoryScrape        | true                                                                                                                                                                                     |
      |     1 | ValidToDate                    |                                                                                                                                                                      2099-12-31 00:00:00 |
      |     1 | HandledByUserGroupID           |                                                                                                                                                                                      324 |
      |     1 | HandledByUserGroupName         | Admin Group                                                                                                                                                                              |
      |     1 | HandledByUserID                |                                                                                                                                                                                      521 |
      |     1 | HandledByUserName              | Automation User                                                                                                                                                                          |
      |     1 | ToBeScraped                    | false                                                                                                                                                                                    |
      |     2 | LinkUniqueKey                  | FA0CBD923EEC2E2836F4AF663E2B53D827EEC402                                                                                                                                                 |
      |     2 | Link                           | https://www.expressvpn.com/glossary/network-automation/?srsltid=AfmBOoqu_gYPMVFNUepy-Dr79VMgwzyAza2UyT1BK8EMFDvBgIiu7DJp                                                                 |
      |     2 | DisplayLink                    | https://www.expressvpn.com › glossary › network-auto...                                                                                                                                  |
      |     2 | GeneratedDate                  |                                                                                                                                                                      2026-04-06 00:00:00 |
      |     2 | Snippet                        | 8 hours ago...Network <b>automation</b> is the use of software to manage, configure, and operate network infrastructure. It relies on controllers, scripts, and APIs to consistently ... |
      |     2 | SearchEngineType               |                                                                                                                                                                                        1 |
      |     2 | MatchedDate                    |                                                                                                                                                                      2026-04-07 00:00:00 |
      |     2 | ActionDays                     |                                                                                                                                                                                        1 |
      |     2 | Reason                         | AUTO-TEST                                                                                                                                                                                |
      |     2 | MatchFlagCategoryID            |                                                                                                                                                                                       75 |
      |     2 | MatchFlagCategoryName          | Auto2AVMFlagCategory                                                                                                                                                                     |
      |     2 | MatchFlagCategoryScrape        | true                                                                                                                                                                                     |
      |     2 | ValidToDate                    |                                                                                                                                                                      2099-12-31 00:00:00 |
      |     2 | HandledByUserGroupID           |                                                                                                                                                                                      324 |
      |     2 | HandledByUserGroupName         | Admin Group                                                                                                                                                                              |
      |     2 | HandledByUserID                |                                                                                                                                                                                      521 |
      |     2 | HandledByUserName              | Automation User                                                                                                                                                                          |
      |     2 | ToBeScraped                    | false                                                                                                                                                                                    |
    And response body should match the schema from the file "AVMFlagResponse"

  Scenario: 042 Verify matchlpotentialsummary/getinternal- successfully fetch Client AVM Potential Match summary record using Client Entity ID.#ENG-T1176
    Given user has a service named "/api/v1/client/adversemedia/matchpotentialsummary/getinternal"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user has query parameter "ClientEntityID":"447799"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                            | value               |
      | BusinessUnitID                 |                  10 |
      | BusinessUnitName               | Default             |
      | ClientEntityID                 |              447799 |
      | ClientEntityInterfaceReference | TESTAUTOMATION      |
      | ClientEntityLastName           | AUTOMATION          |
      | ClientEntityFirstName          |                     |
      | ClientEntityMiddleName         |                     |
      | GeneratedDate                  | 2026-04-06 00:00:00 |
      | LatestRecordDate               | 2026-04-06 00:00:00 |
      | MatchPotentialVolume           |                  53 |
      | HandledByUserGroupID           |                 324 |
      | HandledByUserGroupName         | Admin Group         |
      | HandledByUserID                |                   0 |
      | HandledByUserName              |                     |
      | Priority                       |                   8 |
    And response body should match the schema from the file "AVMMatchedPotential"

  Scenario: 043 Verify matchpotentialsummary/getrows - fetch the Client AVM Potential Match Summary record using Row information.#ENG-T1174
    Given user has a service named "/api/v1/client/adversemedia/matchpotentialsummary/getrows"
    And user has a query params from the file "AddCustomer" with selected keys "BusinessUnitID,ReturnFormat"
    And user has query parameter "RowOffset":"1"
    And user has query parameter "RowsToFetch":"1"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                    | value |
      | RowsHeader.RowOffset   |     1 |
      | RowsHeader.RowsFetched |     1 |
      | RowsHeader.RowStart    |     2 |
      | RowsHeader.RowEnd      |     2 |
    And response body should have array index key with the value:
      | arrayName | index | key                            | value               |
      | Data      |     1 | BusinessUnitID                 |                  10 |
      | Data      |     1 | BusinessUnitName               | Default             |
      | Data      |     1 | ClientEntityID                 |              412597 |
      | Data      |     1 | ClientEntityInterfaceReference | EM                  |
      | Data      |     1 | ClientEntityLastName           | MASK                |
      | Data      |     1 | ClientEntityFirstName          |                     |
      | Data      |     1 | ClientEntityMiddleName         |                     |
      | Data      |     1 | GeneratedDate                  | 2024-08-16 00:00:00 |
      | Data      |     1 | LatestRecordDate               | 2024-08-16 00:00:00 |
      | Data      |     1 | MatchPotentialVolume           |                   9 |
      | Data      |     1 | HandledByUserGroupID           |                 325 |
      | Data      |     1 | HandledByUserGroupName         | Handler Group       |
      | Data      |     1 | HandledByUserID                |                   0 |
      | Data      |     1 | HandledByUserName              |                     |
      | Data      |     1 | Priority                       |                   0 |

  Scenario: 044 Verify matchpotential/deleteall- deletes all outstanding client AVM Potential record using Client entity ID.#ENG-T1173
    Given user has a service named "/api/v1/client/entity/adversemediascreen"
    And user has a payload from the file "AVMMatchDelete" with selected keys "InterfaceReference,BusinessUnitID,ActionUserID,ReturnFormat"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And user has a service named "/api/v1/client/adversemedia/matchpotential/deleteall"
    And user has a payload from the file "AVMMatchDelete" with selected keys "ClientEntityID,BusinessUnitID,ActionUserID,ReturnFormat"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'

  Scenario: 045 Verify matchdiscounted/getinternal-successfully fetch AVM Match Discounted records using Client Entity Identifier.#ENG-T12600
    Given user has a service named "/api/v1/client/adversemedia/matchdiscounted/getinternal"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat"
    And user has query parameter "ClientEntityID":"447806"
    And user has query parameter "BusinessUnitID":"43"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                         | value                                                                                                                                                    |
      |     1 | LinkUniqueKey               |                                                                                                                 4B479168AE798FE8E6981FFDA1FC5531DC3EEC29 |
      |     1 | Link                        | https://boards.4chan.org/vg/thread/562675225/the-idolmster-general                                                                                       |
      |     1 | DisplayLink                 | https://boards.4chan.org › vg › thread                                                                                                                   |
      |     1 | GeneratedDate               |                                                                                                                                      2026-04-07 00:00:00 |
      |     1 | Snippet                     | 1 day ago.../@/ - The iDOLM@STER General - "/vg/ - Video Game Generals" is 4chan's imageboard dedicated to the discussion of PC and console video games. |
      |     1 | SearchEngineType            |                                                                                                                                                        2 |
      |     1 | MatchedDate                 |                                                                                                                                      2026-04-07 00:00:00 |
      |     1 | ActionDays                  |                                                                                                                                                        0 |
      |     1 | Reason                      | Meowwwwwww                                                                                                                                               |
      |     1 | MatchDiscountCategoryID     |                                                                                                                                                       77 |
      |     1 | MatchDiscountCategoryName   | Auto2AVMDiscountCategory                                                                                                                                 |
      |     1 | MatchDiscountCategoryScrape | true                                                                                                                                                     |
      |     1 | ValidToDate                 |                                                                                                                                      2099-12-31 00:00:00 |
      |     1 | HandledByUserGroupID        |                                                                                                                                                      325 |
      |     1 | HandledByUserGroupName      | Handler Group                                                                                                                                            |
      |     1 | HandledByUserID             |                                                                                                                                                      521 |
      |     1 | HandledByUserName           | Automation User                                                                                                                                          |
      |     1 | ToBeScraped                 | false                                                                                                                                                    |
      |     2 | LinkUniqueKey               | E3D18C6BFC498C8BA1667024D702B75800F80657                                                                                                                 |
      |     2 | Link                        | https://www.movieinsider.com/movies/genres/animated/2026                                                                                                 |
      |     2 | DisplayLink                 | https://www.movieinsider.com › movies › genres › animated                                                                                                |
      |     2 | GeneratedDate               |                                                                                                                                      2026-04-07 00:00:00 |
      |     2 | Snippet                     |                         1 day ago...An all-new original film that follows an awkward teenage boy and his Type - A mom, who discover that what ma… more » |
      |     2 | SearchEngineType            |                                                                                                                                                        2 |
      |     2 | MatchedDate                 |                                                                                                                                      2026-04-07 00:00:00 |
      |     2 | ActionDays                  |                                                                                                                                                        0 |
      |     2 | Reason                      | Meowwwwwww                                                                                                                                               |
      |     2 | MatchDiscountCategoryID     |                                                                                                                                                       77 |
      |     2 | MatchDiscountCategoryName   | Auto2AVMDiscountCategory                                                                                                                                 |
      |     2 | MatchDiscountCategoryScrape | true                                                                                                                                                     |
      |     2 | ValidToDate                 |                                                                                                                                      2099-12-31 00:00:00 |
      |     2 | HandledByUserGroupID        |                                                                                                                                                      325 |
      |     2 | HandledByUserGroupName      | Handler Group                                                                                                                                            |
      |     2 | HandledByUserID             |                                                                                                                                                      521 |
      |     2 | HandledByUserName           | Automation User                                                                                                                                          |
      |     2 | ToBeScraped                 | false                                                                                                                                                    |
    Then response body should match the schema from the file "AVMDiscountResponse"

  Scenario: 046 Verify matchflagged/getinternal-successfully fetch AVM Match Flagged records using Client Entity Identifier.#ENG-T12600
    Given user has a service named "/api/v1/client/adversemedia/matchflagged/getinternal"
    And user has a query params from the file "AddCustomer" with selected keys "ReturnFormat"
    And user has query parameter "ClientEntityID":"447806"
    And user has query parameter "BusinessUnitID":"43"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index   | key                          | value                                                                                                                                                                                                             |
      |       1 | LinkUniqueKey                |                                                                                                                                                                          23F759D948072A3D91249DFE4DA39B33627A192B |
      |       1 | Link                         | https://archiveofourown.org/users/whitewomanspotted/pseuds/whitewomanspotted/works                                                                                                                                |
      |       1 | DisplayLink                  | https://archiveofourown.org › users › whitewoman...                                                                                                                                                               |
      |       1 | GeneratedDate                |                                                                                                                                                                                               2026-04-07 00:00:00 |
      |       1 | Snippet                      | 1 day ago...Transformation Incest Corruption The Qurio is still infesting Fiorayne, and it's worse than ever now that Malzeno is dead. In fact, she's the new Malzeno! And she's kissing her sister! And eating … |
      |       1 | SearchEngineType             |                                                                                                                                                                                                                 2 |
      |       1 | MatchedDate                  |                                                                                                                                                                                               2026-04-07 00:00:00 |
      |       1 | ActionDays                   |                                                                                                                                                                                                                 0 |
      |       1 | Reason                       | Meowwwwwww                                                                                                                                                                                                        |
      |       1 | MatchFlagCategoryID          |                                                                                                                                                                                                                75 |
      |       1 | MatchFlagCategoryName        | Auto2AVMFlagCategory                                                                                                                                                                                              |
      |       1 | MatchFlagCategoryScrape      | true                                                                                                                                                                                                              |
      |       1 | ValidToDate                  |                                                                                                                                                                                               2099-12-31 00:00:00 |
      |       1 | HandledByUserGroupID         |                                                                                                                                                                                                               325 |
      |       1 | HandledByUserGroupName       | Handler Group                                                                                                                                                                                                     |
      |       1 | HandledByUserID              |                                                                                                                                                                                                               521 |
      |       1 | HandledByUserName            | Automation User                                                                                                                                                                                                   |
      |       1 | ToBeScraped                  | false                                                                                                                                                                                                             |
      |       2 | LinkUniqueKey                |                                                                                                                                                                          98164690C6A893D9335F9F7F6A6AD92A54D7A4E9 |
      |       2 | Link                         | https://www.rolimons.com/item/108693001102385                                                                                                                                                                     |
      |       2 | DisplayLink                  | https://www.rolimons.com › item                                                                                                                                                                                   |
      |       2 | GeneratedDate                |                                                                                                                                                                                               2026-04-07 00:00:00 |
      |       2 | Snippet                      |        8 hours ago...Pink Drakobloxxer Sleeve (Right) is a Roblox UGC Shoulder Accessory created by the group Sumekke's House. It's for sale for 50 Robux. Created Apr 7, 2026, it has 0 favorite and its asset … |
      |       2 | SearchEngineType             |                                                                                                                                                                                                                 2 |
      |       2 | MatchedDate                  |                                                                                                                                                                                               2026-04-07 00:00:00 |
      |       2 | ActionDays                   |                                                                                                                                                                                                                 0 |
      |       2 | Reason                       | Meowwwwwww                                                                                                                                                                                                        |
      |       2 | MatchFlagCategoryID          |                                                                                                                                                                                                                75 |
      |       2 | MatchFlagCategoryName        | Auto2AVMFlagCategory                                                                                                                                                                                              |
      |       2 | MatchFlagCategoryScrape      | true                                                                                                                                                                                                              |
      |       2 | ValidToDate                  |                                                                                                                                                                                               2099-12-31 00:00:00 |
      |       2 | HandledByUserGroupID         |                                                                                                                                                                                                               325 |
      |       2 | HandledByUserGroupName       | Handler Group                                                                                                                                                                                                     |
      |       2 | HandledByUserID              |                                                                                                                                                                                                               521 |
      |       2 | HandledByUserName            | Automation User                                                                                                                                                                                                   |
      |       2 | ToBeScraped                  | false                                                                                                                                                                                                             |
    And response body should match the schema from the file "AVMFlagResponse"