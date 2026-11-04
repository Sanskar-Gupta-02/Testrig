@Regression @AVMReport
Feature: AVM Reports API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Add Customer
    Given user has a service named "/api/v1/client/entity/add"
    And user has a payload from the file "AddCustomerForReport"
    And user has payload "InterfaceReference":"APIAVMADDCUSTOMER"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                     | value             |
      | ClientEntity.InterfaceReference         | APIAVMADDCUSTOMER |
      | ClientEntity.LastName                   | KUMAR             |
      | ClientEntity.FirstName                  | AKSHAY            |
      | ClientEntity.MiddleName                 | HARI              |
      | ClientEntity.CriteriaID                 |               253 |
      | ClientEntity.CriteriaName               | Person 2          |
      | ClientEntity.GenderID                   |                 1 |
      | ClientEntity.GenderName                 | Male              |
      | ClientEntity.StatusID                   |                 1 |
      | ClientEntity.StatusName                 | Active            |
      | ClientEntity.BusinessUnitID             |                11 |
      | ClientEntity.BusinessUnitName           | Automation Check  |
      | ClientEntity.HandledByUserGroupID       |               325 |
      | ClientEntity.HandledByUserGroupName     | Handler Group     |
      | ClientEntity.HandledByUserID            |               521 |
      | ClientEntity.HandledByUserName          | Automation User   |
      | ClientEntity.RiskID                     |               134 |
      | ClientEntity.RiskName                   | High              |
      | ClientEntity.AdverseMediaFileCriteriaID |              1080 |
    And response body in ascending order should have index key with the value:
      | index | key                                                  | value             |
      |     1 | ClientMatchPotentials.ClientEntityInterfaceReference | APIAVMADDCUSTOMER |
      |     1 | ClientMatchPotentials.ClientEntityLastName           | KUMAR             |
      |     1 | ClientMatchPotentials.ClientEntityFirstName          | AKSHAY            |
      |     1 | ClientMatchPotentials.ClientEntityMiddleName         | HARI              |
      |     1 | ClientMatchPotentials.CriteriaID                     |               253 |
      |     1 | ClientMatchPotentials.HandledByUserGroupID           |               325 |
      |     1 | ClientMatchPotentials.HandledByUserGroupName         | Handler Group     |
      |     1 | ClientMatchPotentials.HandledByUserID                |               521 |
      |     1 | ClientMatchPotentials.HandledByUserName              | Automation User   |
      |     1 | ClientMatchPotentials.CriteriaName                   | Person 2          |
    When user store the response body have index keyData with keyName
      | index | key                                                  | storeKey           |
      |     1 | ClientMatchPotentials.ClientEntityID                 | ClientEntityID     |
      |     1 | ClientMatchPotentials.ClientEntityInterfaceReference | InterfaceReference |
    Then response body should match the schema from the file "AddCustomerForReport"

  Scenario: 002 AVM screen. #ENG-T1167
    Given user has a service named "/api/v1/client/entity/adversemediascreen"
    And user has a payload from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'

  Scenario: 003 Get All screen Records.#ENG-T1168, T1186
    Given user has a service named "/api/v1/client/adversemedia/matchpotential/getallinternal"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,HandledByUserGroupID,ReturnFormat"
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

  Scenario: 004 AVM Discount matches. #ENG-T1169
    Given user has a service named "/api/v1/client/adversemedia/matchpotential/match"
    And user has a payload from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
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

  Scenario: 005 AVM Flag matches. #ENG-T1169
    Given user has a service named "/api/v1/client/adversemedia/matchpotential/match"
    And user has a payload from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "LinkUniqueKey" with the stored key value "SecondLinkUniqueKey"
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
      | LinkUniqueKey                  | SecondLinkUniqueKey |
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

  Scenario: 006 Entity details
    Given user has a service named "/api/v1/report/client/entity/detail"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                                                                       |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                                                                              |
      |     1 | ReportDataSources.Value | "ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitName":"Automation Check"                                                                                                       |
      |     1 | ReportDataSources.Value | "InterfaceReference":"APIAVMADDCUSTOMER","LastName":"KUMAR","FirstName":"AKSHAY","MiddleName":"HARI","Gender":"Male"                                                                        |
      |     1 | ReportDataSources.Value | "Status":"Active","Country1":"Unknown","Country2":"Unknown","Country3":"Unknown","Risk":"High","HandledByUserGroup":"Handler Group","HandledByUser":"Automation User","Criteria":"Person 2" |

  Scenario: 007 Match discounted
    Given user has a service named "/api/v1/report/client/entity/matchdiscounted"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                                                                       |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                                                                              |
      |     1 | ReportDataSources.Value | "ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitName":"Automation Check"                                                                                                       |
      |     1 | ReportDataSources.Value | "InterfaceReference":"APIAVMADDCUSTOMER","LastName":"KUMAR","FirstName":"AKSHAY","MiddleName":"HARI","Gender":"Male"                                                                        |
      |     1 | ReportDataSources.Value | "Status":"Active","Country1":"Unknown","Country2":"Unknown","Country3":"Unknown","Risk":"High","HandledByUserGroup":"Handler Group","HandledByUser":"Automation User","Criteria":"Person 2" |

  Scenario: 008 Match flagged
    Given user has a service named "/api/v1/report/client/entity/matchflagged"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                                                                       |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                                                                              |
      |     1 | ReportDataSources.Value | "ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitName":"Automation Check"                                                                                                       |
      |     1 | ReportDataSources.Value | "InterfaceReference":"APIAVMADDCUSTOMER","LastName":"KUMAR","FirstName":"AKSHAY","MiddleName":"HARI","Gender":"Male"                                                                        |
      |     1 | ReportDataSources.Value | "Status":"Active","Country1":"Unknown","Country2":"Unknown","Country3":"Unknown","Risk":"High","HandledByUserGroup":"Handler Group","HandledByUser":"Automation User","Criteria":"Person 2" |

  Scenario: 009 Search History
    Given user has a service named "/api/v1/report/client/entity/searchhistory"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                                                                       |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                                                                              |
      |     1 | ReportDataSources.Value | "ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitName":"Automation Check"                                                                                                       |
      |     1 | ReportDataSources.Value | "InterfaceReference":"APIAVMADDCUSTOMER","LastName":"KUMAR","FirstName":"AKSHAY","MiddleName":"HARI","Gender":"Male"                                                                        |
      |     1 | ReportDataSources.Value | "Status":"Active","Country1":"Unknown","Country2":"Unknown","Country3":"Unknown","Risk":"High","HandledByUserGroup":"Handler Group","HandledByUser":"Automation User","Criteria":"Person 2" |

  Scenario: 010 AVM Detail
    Given user has a service named "/api/v1/report/client/entity/AVMDetail"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                                                                       |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                                                                              |
      |     1 | ReportDataSources.Value | "ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen"                                                                                                                                             |
      |     1 | ReportDataSources.Value | "InterfaceReference":"APIAVMADDCUSTOMER","LastName":"KUMAR","FirstName":"AKSHAY","MiddleName":"HARI","Gender":"Male"                                                                        |
      |     1 | ReportDataSources.Value | "Status":"Active","Country1":"Unknown","Country2":"Unknown","Country3":"Unknown","Risk":"High","HandledByUserGroup":"Handler Group","HandledByUser":"Automation User","Criteria":"Person 2" |

  Scenario: 011 Delete all AVM PM
    Given user has a service named "/api/v1/client/adversemedia/matchpotential/deleteall"
    And user has a payload from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storekey with the value:
      | index | key            | storekey       |
      |     1 | ClientEntityID | ClientEntityID |

  Scenario: 012 Delete AVM Discount
    Given user has a service named "/api/v1/client/adversemedia/matchdiscounted/delete"
    And user has a payload from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
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

  Scenario: 013 Delete AVM Flag
    Given user has a service named "/api/v1/client/adversemedia/matchflagged/delete"
    And user has a payload from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "InterfaceReference" with the stored key value "InterfaceReference"
    And user add payload "LinkUniqueKey" with the stored key value "SecondLinkUniqueKey"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the stored value:
      | key            | storedKey           |
      | ClientEntityID | ClientEntityID      |
      | LinkUniqueKey  | SecondLinkUniqueKey |
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

  Scenario: 014 Delete all PM
    Given user has a service named "/api/v1/client/matchpotential/deleteallinternal"
    And user has a payload from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storekey with the value:
      | index | key            | storekey       |
      |     1 | ClientEntityID | ClientEntityID |

  Scenario: 015 Delete Customer
    Given user has a service named "/api/v1/client/entity/delete"
    And user has a payload from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
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
