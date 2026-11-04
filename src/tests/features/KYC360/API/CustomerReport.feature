@Regression @CustomerReport
Feature: Customer Report API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 User should be a able to fetch customer report for non-default. #ENG-T12602
    Given user is authorized using an 'ALIASAPIKEY'
    And user has a service named "/api/v1/client/entity/getreport"
    And user has header "Content-Type":"application/json"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "ClientEntityID":"447846"
    And user has query parameter "ActionUserID":"524"
    And user has query parameter "ReturnFormat":"Json"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    #Defect Raised - #ENG-10640

  Scenario: 002 Successfully retrieve the first page of report with Non-Default Business Unit. #ENG-T12607
    Given user has a service named "/api/v1/reports"
    And user has path parameter "/MatchPotential"
    And user has a query params from the file "ReportsOverhaulForBU" with selected keys "PageIndex,PageSize,UserId,SortColumn,SortDirection,Filters"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key           | value    |
      | SortColumn    | ClientId |
      | SortDirection | DESC     |
    And response body should match the schema from the file "ReportsOverhaulForBU"

  Scenario: 003 Successfully retrieve the AVM reports for Flag with Non-Default Business Unit. #ENG-T12607
    Given user is authorized using an 'ALIASAPIKEY'
    And user has a service named "/api/v1/client/adversemedia/matchflagged/get"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "InterfaceReference":"AUTOMATIONTESTS3"
    And user has query parameter "ReturnFormat":"Json"
    And user sends a 'GET' request
    Then response status should be 200
    And response body should have index key with the value:
      | index | key                            | value                                                                                                                                                                  |
      |     1 | ClientEntityID                 |                                                                                                                                                                 447891 |
      |     1 | ClientEntityInterfaceReference | AUTOMATIONTESTS3                                                                                                                                                       |
      |     1 | ClientEntityLastName           | POTENTIAL                                                                                                                                                              |
      |     1 | ClientEntityFirstName          | TEST                                                                                                                                                                   |
      |     1 | ClientEntityMiddleName         |                                                                                                                                                                        |
      |     1 | LinkUniqueKey                  |                                                                                                                               3EE4C73F97A0A55975C75B15EEFB8C6608556A56 |
      |     1 | Link                           | https://www.facebook.com/groups/215155240781012/posts/1299219572374568/                                                                                                |
      |     1 | DisplayLink                    |                                                                                                                                                            3 hours ago |
      |     1 | GeneratedDate                  |                                                                                                                                                    2026-04-14 00:00:00 |
      |     1 | Snippet                        | Ilhan Omar investigated for <b>potential fraud</b>. Royal Brown ▻ Laugh Until It Hurts. 2d · Public · Citizen investigator Nick Shirley has uncovered several cell ... |
      |     1 | SearchEngineType               |                                                                                                                                                                      1 |
      |     1 | MatchedDate                    |                                                                                                                                                    2026-04-14 00:00:00 |
      |     1 | ActionDays                     |                                                                                                                                                                      0 |
      |     1 | Reason                         |                                                                                                                                                                        |
      |     1 | MatchFlagCategoryID            |                                                                                                                                                                    129 |
      |     1 | MatchFlagCategoryName          | Auto_Test                                                                                                                                                              |
      |     1 | MatchFlagCategoryScrape        | false                                                                                                                                                                  |
      |     1 | ValidToDate                    |                                                                                                                                                    2099-12-31 00:00:00 |
      |     1 | HandledByUserGroupID           |                                                                                                                                                                    331 |
      |     1 | HandledByUserGroupName         | Handler Group                                                                                                                                                          |
      |     1 | HandledByUserID                |                                                                                                                                                                    524 |
      |     1 | HandledByUserName              | Akshay Pardeshi (WLWP Disable-Automation)                                                                                                                              |
      |     1 | ToBeScraped                    | false                                                                                                                                                                  |
    And response body should match the schema from the file "CustomerReport"

  Scenario: 004 Successfully retrieve the AVM reports for Discount with Non-Default Business Unit. #ENG-T12607
    Given user is authorized using an 'ALIASAPIKEY'
    And user has a service named "/api/v1/client/adversemedia/matchdiscounted/get"
    And user has query parameter "BusinessUnitID":"11"
    And user has query parameter "InterfaceReference":"AutomationTestS3"
    And user has query parameter "ReturnFormat":"Json"
    And user sends a 'GET' request
    Then response status should be 200
    And response body should have index key with the value:
      | index | key                            | value                                                                                                                                                                                        |
      |     1 | ClientEntityID                 |                                                                                                                                                                                       447891 |
      |     1 | ClientEntityInterfaceReference | AUTOMATIONTESTS3                                                                                                                                                                             |
      |     1 | ClientEntityLastName           | POTENTIAL                                                                                                                                                                                    |
      |     1 | ClientEntityFirstName          | TEST                                                                                                                                                                                         |
      |     1 | ClientEntityMiddleName         |                                                                                                                                                                                              |
      |     1 | LinkUniqueKey                  |                                                                                                                                                     69084D428058661019FFE7EC693A0A0ABCFBDC44 |
      |     1 | Link                           | https://www.texasattorneygeneral.gov/news/releases/attorney-general-ken-paxton-launches-investigation-lululemon-over-potential-presence-toxic-forever                                        |
      |     1 | DisplayLink                    | https://www.texasattorneygeneral.gov › news › releases                                                                                                                                       |
      |     1 | GeneratedDate                  |                                                                                                                                                                          2026-04-14 00:00:00 |
      |     1 | Snippet                        | 17 hours ago...Attorney General Ken Paxton Launches <b>Investigation</b> into Lululemon Over <b>Potential</b> Presence of Toxic ​“Forever Chemicals” in Activewear. Attorney General Ken ... |
      |     1 | SearchEngineType               |                                                                                                                                                                                            1 |
      |     1 | MatchedDate                    |                                                                                                                                                                          2026-04-14 00:00:00 |
      |     1 | ActionDays                     |                                                                                                                                                                                            0 |
      |     1 | Reason                         | Test                                                                                                                                                                                         |
      |     1 | MatchDiscountCategoryID        |                                                                                                                                                                                          138 |
      |     1 | MatchDiscountCategoryName      | Auto_Test                                                                                                                                                                                    |
      |     1 | MatchDiscountCategoryScrape    | false                                                                                                                                                                                        |
      |     1 | ValidToDate                    |                                                                                                                                                                          2099-12-31 00:00:00 |
      |     1 | HandledByUserGroupID           |                                                                                                                                                                                          331 |
      |     1 | HandledByUserGroupName         | Handler Group                                                                                                                                                                                |
      |     1 | HandledByUserID                |                                                                                                                                                                                          524 |
      |     1 | HandledByUserName              | Akshay Pardeshi (WLWP Disable-Automation)                                                                                                                                                    |
      |     1 | ToBeScraped                    | false                                                                                                                                                                                        |
    And response body should match the schema from the file "MatchDiscountReport"
