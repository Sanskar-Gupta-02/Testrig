@Regression @HBReport
Feature: HB Reports API

  Background:
    Given user is authorized using an 'APIKEY'

 Scenario: 001 Add Customer
    Given user has a service named "/api/v1/client/entity/add"
    And user has a payload from the file "AddCustomerForReport"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                                     | value            |
      | ClientEntity.InterfaceReference         | APIHBADDCUSTOMER |
      | ClientEntity.LastName                   | KUMAR            |
      | ClientEntity.FirstName                  | AKSHAY           |
      | ClientEntity.MiddleName                 | HARI             |
      | ClientEntity.CriteriaID                 |              253 |
      | ClientEntity.CriteriaName               | Person 2         |
      | ClientEntity.GenderID                   |                1 |
      | ClientEntity.GenderName                 | Male             |
      | ClientEntity.StatusID                   |                1 |
      | ClientEntity.StatusName                 | Active           |
      | ClientEntity.BusinessUnitID             |               11 |
      | ClientEntity.BusinessUnitName           | Automation Check |
      | ClientEntity.HandledByUserGroupID       |              325 |
      | ClientEntity.HandledByUserGroupName     | Handler Group    |
      | ClientEntity.HandledByUserID            |              521 |
      | ClientEntity.HandledByUserName          | Automation User  |
      | ClientEntity.RiskID                     |              134 |
      | ClientEntity.RiskName                   | High             |
      | ClientEntity.AdverseMediaFileCriteriaID |             1080 |
    And response body in ascending order should have index key with the value:
      | index | key                                                  | value            |
      |     1 | ClientMatchPotentials.ClientEntityInterfaceReference | APIHBADDCUSTOMER |
      |     1 | ClientMatchPotentials.ClientEntityLastName           | KUMAR            |
      |     1 | ClientMatchPotentials.ClientEntityFirstName          | AKSHAY           |
      |     1 | ClientMatchPotentials.ClientEntityMiddleName         | HARI             |
      |     1 | ClientMatchPotentials.CriteriaID                     |              253 |
      |     1 | ClientMatchPotentials.HandledByUserGroupID           |              325 |
      |     1 | ClientMatchPotentials.HandledByUserGroupName         | Handler Group    |
      |     1 | ClientMatchPotentials.HandledByUserID                |              521 |
      |     1 | ClientMatchPotentials.HandledByUserName              | Automation User  |
      |     1 | ClientMatchPotentials.CriteriaName                   | Person 2         |
    When user store the response body have index keyData with keyName
      | index | key                                                  | storeKey           |
      |     1 | ClientMatchPotentials.ClientEntityID                 | ClientEntityID     |
      |     1 | ClientMatchPotentials.ClientEntityInterfaceReference | InterfaceReference |
      |     1 | ClientMatchPotentials.EntityID                       | FirstEntityID      |
      |     2 | ClientMatchPotentials.EntityID                       | SecondEntityID     |
      |     2 | ClientMatchPotentials.HandledByUserGroupID           | UserGroupID        |
    Then response body should match the schema from the file "AddCustomerForReport"

  Scenario: 002 Discount matches
    Given user has a service named "/api/v1/client/matchpotential/match"
    And user has a payload from the file "AddCustomerForReport" with selected keys "BusinessUnitID,InterfaceReference,ActionUserID,ReturnFormat"
    And user add payload "EntityID" with the stored key value "FirstEntityID"
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
      | key                            | storedKey          |
      | ClientEntityID                 | ClientEntityID     |
      | ClientEntityInterfaceReference | InterfaceReference |
      | EntityID                       | FirstEntityID      |
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

  Scenario: 003 Flag matches
    Given user has a service named "/api/v1/client/matchpotential/match"
    And user has a payload from the file "AddCustomerForReport" with selected keys "BusinessUnitID,InterfaceReference,ActionUserID,ReturnFormat"
    And user add payload "EntityID" with the stored key value "SecondEntityID"
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
      | key                            | storedKey          |
      | ClientEntityID                 | ClientEntityID     |
      | ClientEntityInterfaceReference | InterfaceReference |
      | EntityID                       | SecondEntityID     |
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

  Scenario: 004 match discount by day. #ENG-T1237
    Given user has a service named "/api/v1/report/matchmonitor/matchdiscountbyday"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "UserGroupID" with the stored key value "UserGroupID"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
      |     1 | ReportDataSources.Value | FirstEntityID  |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                                                                |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                                                                       |
      |     1 | ReportDataSources.Value | "ClientID":116,"ClientInterfaceReference":"APIHBADDCUSTOMER","ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitID":11,"BusinessUnitName":"Automation Check" |
      |     1 | ReportDataSources.Value | "ClientLastName":"KUMAR","ClientFirstName":"AKSHAY","ClientMiddleName":"HARI"                                                                                                        |
      |     1 | ReportDataSources.Value | "ActionDays":0,"Note":"Testing","MatchDiscountedCategoryID":187,"MatchDiscountedCategoryName":"Auto2DiscountCategory"                                                                |
      |     1 | ReportDataSources.Value | "Notify":"No","HandledByUserGroupID":325,"HandledByUserGroupName":"Handler Group","HandledByUserID":521,"HandledByUserName":"Automation User"                                        |

  Scenario: 005 match flag by day. #ENG-T1238
    Given user has a service named "/api/v1/report/matchmonitor/matchflagbyday"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "UserGroupID" with the stored key value "UserGroupID"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
      |     1 | ReportDataSources.Value | SecondEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                                                                |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                                                                       |
      |     1 | ReportDataSources.Value | "ClientID":116,"ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitID":11,"BusinessUnitName":"Automation Check","ClientInterfaceReference":"APIHBADDCUSTOMER" |
      |     1 | ReportDataSources.Value | "ClientLastName":"KUMAR","ClientFirstName":"AKSHAY","ClientMiddleName":"HARI"                                                                                                        |
      |     1 | ReportDataSources.Value | "ActionDays":0,"Note":"Testing","MatchFlaggedCategoryID":379,"MatchFlaggedCategoryName":"Irrelevant"                                                                                 |
      |     1 | ReportDataSources.Value | "Notify":"No","HandledByUserGroupID":325,"HandledByUserGroupName":"Handler Group","HandledByUserID":521,"HandledByUserName":"Automation User"                                        |

  Scenario: 006 match potential. #ENG-T1239
    Given user has a service named "/api/v1/report/matchmonitor/matchpotential"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "UserGroupID" with the stored key value "UserGroupID"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                                                                |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                                                                       |
      |     1 | ReportDataSources.Value | "ClientID":116,"BusinessUnitID":11,"ClientInterfaceReference":"APIHBADDCUSTOMER","ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitName":"Automation Check" |
      |     1 | ReportDataSources.Value | "ClientEntityLastName":"KUMAR","ClientEntityFirstName":"AKSHAY","ClientEntityMiddleName":"HARI"                                                                                      |
      |     1 | ReportDataSources.Value | "HandledByUserGroupID":325,"HandledByUserGroupName":"Handler Group","HandledByUserID":521,"HandledByUserName":"Automation User"                                                      |

  Scenario: 007 match potentia. #ENG-T1240
    Given user has a service named "/api/v1/report/matchmonitor/matchpotentialstatistics"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "UserGroupID" with the stored key value "UserGroupID"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                                                                                      |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                                                                                             |
      |     1 | ReportDataSources.Value | "ClientID":116,"ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitID":11,"BusinessUnitName":"Automation Check","HandledByUserGroupID":325,"HandledByUserGroupName":"Handler Group" |

  Scenario: 008 match potential summary. #ENG-T1241
    Given user has a service named "/api/v1/report/matchmonitor/matchpotentialsummary"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "UserGroupID" with the stored key value "UserGroupID"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                  |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                         |
      |     1 | ReportDataSources.Value | "ClientID":116,"ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitID":11,"BusinessUnitName":"Automation Check" |
      |     1 | ReportDataSources.Value | "ClientEntityLastName":"KUMAR","ClientEntityFirstName":"AKSHAY","ClientEntityMiddleName":"HARI"                                        |
      |     1 | ReportDataSources.Value | "HandledByUserGroupID":325,"HandledByUserGroupName":"Handler Group","HandledByUserID":521,"HandledByUserName":"Automation User"        |

  Scenario: 009 match potential volume
    Given user has a service named "/api/v1/report/matchmonitor/matchpotentialvolume"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "UserGroupID" with the stored key value "UserGroupID"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                   |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                          |
      |     1 | ReportDataSources.Value | "CLMP_STCL_NAME":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","CLMP_STBU_NAME":"Automation Check" |

  Scenario: 010 match data by day. #ENG-1243
    Given user has a service named "/api/v1/report/matchmonitor/matchdatabyday"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user has query parameter "Date":"<currentDateStamp>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                  |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                         |
      |     1 | ReportDataSources.Value | "ClientID":116,"ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitID":11,"BusinessUnitName":"Automation Check" |
      |     1 | ReportDataSources.Value | "ClientEntityLastName":"KUMAR","ClientEntityFirstName":"AKSHAY","ClientEntityMiddleName":"HARI"                                        |

  Scenario: 011 match discount by category. #ENG-T1244
    Given user has a service named "/api/v1/report/matchmonitor/matchdiscountbycategory"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user has query parameter "MatchDiscountCategoryID":"187"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                      |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                             |
      |     1 | ReportDataSources.Value | "CLMD_STCL_ID":116,"CLMD_STCL_NAME":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","CLMD_STBU_ID":11,"CLMD_STBU_NAME":"Automation Check" |
      |     1 | ReportDataSources.Value | "CLMD_CLEN_IFREF":"APIHBADDCUSTOMER","CLMD_CLEN_LASTNAME":"KUMAR","CLMD_CLEN_FIRSTNAME":"AKSHAY","CLMD_CLEN_MIDDLENAME":"HARI"             |
      |     1 | ReportDataSources.Value | "CLMD_NOTE":"Testing","CLMD_STMD_ID":187,"CLMD_STMD_NAME":"Auto2DiscountCategory"                                                          |

  Scenario: 012 match flag by category. #ENG-T1245
    Given user has a service named "/api/v1/report/matchmonitor/matchflagbycategory"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user has query parameter "MatchFlagCategoryID":"379"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                      |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                             |
      |     1 | ReportDataSources.Value | "CLMF_STCL_ID":116,"CLMF_STCL_NAME":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","CLMF_STBU_ID":11,"CLMF_STBU_NAME":"Automation Check" |
      |     1 | ReportDataSources.Value | "CLMF_CLEN_IFREF":"APIHBADDCUSTOMER","CLMF_CLEN_LASTNAME":"KUMAR","CLMF_CLEN_FIRSTNAME":"AKSHAY","CLMF_CLEN_MIDDLENAME":"HARI"             |
      |     1 | ReportDataSources.Value | "CLMF_NOTE":"Testing","CLMF_STMF_ID":379,"CLMF_STMF_NAME":"Irrelevant"                                                                     |

  Scenario: 013 match checking. #ENG-T1246
    Given user has a service named "/api/v1/report/matchmonitor/matchchecking"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "UserGroupID" with the stored key value "UserGroupID"
    And user has query parameter "Date":"<currentDateStamp>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                                                                |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                                                                       |
      |     1 | ReportDataSources.Value | "ClientID":116,"ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitID":11,"BusinessUnitName":"Automation Check","ClientInterfaceReference":"APIHBADDCUSTOMER" |
      |     1 | ReportDataSources.Value | "ClientLastName":"KUMAR","ClientFirstName":"AKSHAY","ClientMiddleName":"HARI"                                                                                                        |

  Scenario: 014 processing statistics. #ENG-1247
    Given user has a service named "/api/v1/report/matchmonitor/processingstatistics"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user has query parameter "Date":"<currentDateStamp>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                  |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                         |
      |     1 | ReportDataSources.Value | "ClientID":116,"ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitID":11,"BusinessUnitName":"Automation Check" |

  Scenario: 015 client notify change. #ENG-1248
    Given user has a service named "/api/v1/report/matchmonitor/clientnotifychange"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                    | value          |
      |     1 | ReportDataSources.Name | ReportDataSet1 |

  Scenario: 016 client notify change
    Given user has a service named "/api/v1/report/matchmonitor/clientnotifychange"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    And user has query parameter "CurrentPage":"1"
    And user has query parameter "PageSize":"11"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                    | value          |
      |     1 | ReportDataSources.Name | ReportDataSet1 |

  Scenario: 017 processing statistics. #ENG-T1469
    Given user has a service named "/api/v1/report/matchmonitor/matchflagbydaypaged"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "UserGroupID" with the stored key value "UserGroupID"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    And user has query parameter "UserID":"521"
    And user has query parameter "CurrentPage":"1"
    And user has query parameter "PageSize":"11"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                  |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                         |
      |     1 | ReportDataSources.Value | "ClientID":116,"ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitID":11,"BusinessUnitName":"Automation Check" |
      |     1 | ReportDataSources.Value | "ClientInterfaceReference":"APIHBADDCUSTOMER","ClientLastName":"KUMAR","ClientFirstName":"AKSHAY","ClientMiddleName":"HARI"            |

  Scenario: 018 match discount by day paged. #ENG-T1470
    Given user has a service named "/api/v1/report/matchmonitor/matchdiscountbydaypaged"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "UserGroupID" with the stored key value "UserGroupID"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    And user has query parameter "UserID":"521"
    And user has query parameter "CurrentPage":"1"
    And user has query parameter "PageSize":"10"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
      |     1 | ReportDataSources.Value | FirstEntityID  |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                  |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                         |
      |     1 | ReportDataSources.Value | "ClientID":116,"ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitID":11,"BusinessUnitName":"Automation Check" |
      |     1 | ReportDataSources.Value | "ClientInterfaceReference":"APIHBADDCUSTOMER","ClientLastName":"KUMAR","ClientFirstName":"AKSHAY","ClientMiddleName":"HARI"            |

  Scenario: 019 match potential paged. #ENG-T1471
    Given user has a service named "/api/v1/report/matchmonitor/matchpotentialpaged"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "UserGroupID" with the stored key value "UserGroupID"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    And user has query parameter "CurrentPage":"1"
    And user has query parameter "PageSize":"10"
    And user has query parameter "IncludeSummary":"false"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                  |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                         |
      |     1 | ReportDataSources.Value | "ClientID":116,"ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitID":11,"BusinessUnitName":"Automation Check" |

  Scenario: 020 match potential summary paged. #ENG-1472
    Given user has a service named "/api/v1/report/matchmonitor/matchpotentialsummarypaged"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user add query parameter "UserGroupID" with the stored key value "UserGroupID"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    And user has query parameter "CurrentPage":"1"
    And user has query parameter "PageSize":"10"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                                                                |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                                                                       |
      |     1 | ReportDataSources.Value | "ClientID":116,"BusinessUnitID":11,"ClientInterfaceReference":"APIHBADDCUSTOMER","ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitName":"Automation Check" |
      |     1 | ReportDataSources.Value | "ClientEntityLastName":"KUMAR","ClientEntityFirstName":"AKSHAY","ClientEntityMiddleName":"HARI"                                                                                      |

  Scenario: 021 match data by day paged. #ENG-T1473
    Given user has a service named "/api/v1/report/matchmonitor/matchdatabydaypaged"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user has query parameter "Date":"<currentDateStamp>"
    And user has query parameter "UserID":"521"
    And user has query parameter "CurrentPage":"1"
    And user has query parameter "PageSize":"10"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                                            |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                                                   |
      |     1 | ReportDataSources.Value | "MatchType":"Outstanding","ClientID":116,"ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitID":11,"BusinessUnitName":"Automation Check" |
      |     1 | ReportDataSources.Value | "ClientEntityRefernce":"APIHBADDCUSTOMER","ClientEntityLastName":"KUMAR","ClientEntityFirstName":"AKSHAY","ClientEntityMiddleName":"HARI"                        |

  Scenario: 022 match data by day paged. #ENG-T1474
    Given user has a service named "/api/v1/report/matchmonitor/matchdiscountbycategorypaged"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user has query parameter "MatchDiscountCategoryID":"187"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    And user has query parameter "UserID":"521"
    And user has query parameter "CurrentPage":"1"
    And user has query parameter "PageSize":"10"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                      |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                             |
      |     1 | ReportDataSources.Value | "CLMD_STCL_ID":116,"CLMD_STCL_NAME":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","CLMD_STBU_ID":11,"CLMD_STBU_NAME":"Automation Check" |
      |     1 | ReportDataSources.Value | "CLMD_CLEN_IFREF":"APIHBADDCUSTOMER","CLMD_CLEN_LASTNAME":"KUMAR","CLMD_CLEN_FIRSTNAME":"AKSHAY","CLMD_CLEN_MIDDLENAME":"HARI"             |

  Scenario: 023 match flag by category paged. #ENG-T1475
    Given user has a service named "/api/v1/report/matchmonitor/matchflagbycategorypaged"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user has query parameter "MatchFlagCategoryID":"379"
    And user has query parameter "FromDate":"<currentDateStamp>"
    And user has query parameter "ToDate":"<currentDateStamp>"
    And user has query parameter "UserID":"521"
    And user has query parameter "CurrentPage":"1"
    And user has query parameter "PageSize":"10"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                                      |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                                             |
      |     1 | ReportDataSources.Value | "CLMF_STCL_ID":116,"CLMF_STCL_NAME":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","CLMF_STBU_ID":11,"CLMF_STBU_NAME":"Automation Check" |
      |     1 | ReportDataSources.Value | "CLMF_CLEN_IFREF":"APIHBADDCUSTOMER","CLMF_CLEN_LASTNAME":"KUMAR","CLMF_CLEN_FIRSTNAME":"AKSHAY","CLMF_CLEN_MIDDLENAME":"HARI"             |

  Scenario: 024 match checking paged. #ENG-1476
    Given user has a service named "/api/v1/report/matchmonitor/matchcheckingpaged"
    And user has a query params from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ReturnFormat"
    And user has query parameter "UserGroupID":"325"
    And user has query parameter "Date":"<currentDateStamp>"
    And user has query parameter "UserID":"521"
    And user has query parameter "CurrentPage":"1"
    And user has query parameter "PageSize":"10"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storedkey with the contains value:
      | index | key                     | storedKey      |
      |     1 | ReportDataSources.Value | ClientEntityID |
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                                                                                                       |
      |     1 | ReportDataSources.Name  | ReportDataSet1                                                                                                              |
      |     1 | ReportDataSources.Value | "ClientName":"STGLOADTEST-NONPKYC - Automation-QA-RiskScreen","BusinessUnitID":11,"BusinessUnitName":"Automation Check"     |
      |     1 | ReportDataSources.Value | "ClientInterfaceReference":"APIHBADDCUSTOMER","ClientLastName":"KUMAR","ClientFirstName":"AKSHAY","ClientMiddleName":"HARI" |

  Scenario: 025 Delete Flag PM
    Given user has a service named "/api/v1/client/matchflagged/delete"
    And user has a payload from the file "AddCustomerForReport" with selected keys "BusinessUnitID,InterfaceReference,ActionUserID,ReturnFormat"
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
      | Reason                 | Testing         |
      | MatchFlagCategoryID    |             379 |
      | MatchFlagCategoryName  | Irrelevant      |
      | HandledByUserGroupID   |             325 |
      | HandledByUserGroupName | Handler Group   |
      | HandledByUserID        |             521 |
      | HandledByUserName      | Automation User |

  Scenario: 026 Delete Discount PM
    Given user has a service named "/api/v1/client/matchdiscounted/delete"
    And user has a payload from the file "AddCustomerForReport" with selected keys "BusinessUnitID,InterfaceReference,ActionUserID,ReturnFormat"
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
      | Reason                    | Testing               |
      | MatchDiscountCategoryID   |                   187 |
      | MatchDiscountCategoryName | Auto2DiscountCategory |
      | HandledByUserGroupID      |                   325 |
      | HandledByUserGroupName    | Handler Group         |
      | HandledByUserID           |                   521 |
      | HandledByUserName         | Automation User       |

  Scenario: 027 Delete all PM
    Given user has a service named "/api/v1/client/matchpotential/deleteallinternal"
    And user has a payload from the file "AddCustomerForReport" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "ClientEntityID" with the stored key value "ClientEntityID"
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index storekey with the value:
      | index | key            | storekey       |
      |     1 | ClientEntityID | ClientEntityID |

  Scenario: 028 Delete Customer
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
