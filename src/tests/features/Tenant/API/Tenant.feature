@Regression @Tenant
Feature: Tenant Configuration

  Scenario: 001 User should be able to fetch tenant details via tenantId.
    When user has a service named "/tenants/<TenantID>"
    And user has header "Content-Type":"application/json"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                          | value                                |
      | id                           | 798a794a-5bae-44cf-93e9-9f0ab7f73287 |
      | clientId                     |                                  101 |
      | databaseServer               |         10.255.0.5:STGUAT-RiskScreen |
      | name                         | STGUAT-CLIENT-101-DJ                 |
      | clmProduct.key               | clm                                  |
      | clmProduct.isValid           | false                                |
      | clmProduct.screeningSettings | null                                 |
    And response body should match the schema from the file "TenantResponse"

  Scenario: 002 User should be able to fetch client tenant details via tenantId.
    When user has a service named "/tenants/client/101/<TenantID>"
    And user has header "Content-Type":"application/json"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key | value                                |
      | id  | 798a794a-5bae-44cf-93e9-9f0ab7f73287 |
    And response body should match the schema from the file "Tenant"

  Scenario: 003 User should be able to fetch credits via ServiceID and tenantId.
    When user has a service in runtime named "/tenants/<TenantID2>/credits/<ServiceID:b152bd0c-4bda-4a4d-8673-a95df0e900cb>"
    And user has header "Content-Type":"application/json"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key       | value                                |
      | tenantId  | b8041e5f-df67-4f0c-bfe2-dada3ac671bf |
      | serviceId | b152bd0c-4bda-4a4d-8673-a95df0e900cb |
      | type      |                                    1 |
    And response body should match the schema from the file "TenantService"

  Scenario: 004 User should be able to add credits via ServiceID and tenantId.
    When user has a service in runtime named "/tenants/<TenantID2>/credits/<ServiceID:b152bd0c-4bda-4a4d-8673-a95df0e900cb>/add"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
        "credits": 5,
        "reason": "Test"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key       | value                                |
      | tenantId  | b8041e5f-df67-4f0c-bfe2-dada3ac671bf |
      | serviceId | b152bd0c-4bda-4a4d-8673-a95df0e900cb |
      | type      |                                    1 |
    And response body should match the schema from the file "TenantServiceAdd"

  Scenario: 005 User should be able to get keys via Tenant ID.
    When user has a service in runtime named "/tenants/<TenantID>/features/<key:kompanyversiontwo>"
    And user has header "Content-Type":"application/json"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key         | value              |
      | enabled     | true               |
      | title       | KompanyV2Migration |
      | description | KompanyV2Migration |
      | key         | kompanyversiontwo  |
      | status      |                155 |
    And response body should match the schema from the file "TenantKey"

  Scenario: 006 User should be able to get keys via Tenant ID features.
    When user has a service in runtime named "/tenants/<TenantID>/features"
    And user has header "Content-Type":"application/json"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have index key with the value:
      | index | key         | value                          |
      |     1 | enabled     | false                          |
      |     1 | title       | Tes                            |
      |     1 | description | Test                           |
      |     1 | key         | metest                         |
      |     1 | status      |                              3 |
      |     2 | enabled     | true                           |
      |     2 | title       | AME/AVM Data Source            |
      |     2 | key         | amedatasource                  |
      |     2 | status      |                            155 |
      |     3 | enabled     | true                           |
      |     3 | title       | Granular Screening             |
      |     3 | description | Granular Screening             |
      |     3 | key         | granularscreening              |
      |     3 | status      |                            155 |
      |     4 | enabled     | false                          |
      |     4 | title       | Test toggle title GUHOOUUVhuyy |
      |     4 | description | desc                           |
      |     4 | key         | test.nonglobal                 |
      |     4 | status      |                              1 |
     # |     2 | description | AME/AVM Data Source            |
    And response body should match the schema from the file "TenantFeaturesAll"

  Scenario: 007 User should be able to get keys via Tenant ID.
    When user has a service in runtime named "/tenants"
    And user has header "Content-Type":"application/json"
    And user sends a 'GET' request
    Then response status should be 200
    And response body should contain tenants with expected values:
      | index   | key                            | value                                  |
      |       0 | id                             |   798a794a-5bae-44cf-93e9-9f0ab7f73287 |
      |       0 | clientId                       |                                    101 |
      |       0 | databaseServer                 |           10.255.0.5:STGUAT-RiskScreen |
      |       0 | name                           | STGUAT-CLIENT-101-DJ                   |
      |       0 | isDemoTenant                   | false                                  |
      |       0 | isDemoTenantActive             | false                                  |
      |       0 | clmProduct.key                 | clm                                    |
      |       0 | clmProduct.screeningSettings   | null                                   |
      |       0 | clmProduct.isValid             | false                                  |
      |       1 | id                             |   04109130-5200-4d56-be55-27ec203b9302 |
      |       1 | clientId                       |                                    109 |
      |       1 | databaseServer                 |           10.255.0.5:STGUAT-RiskScreen |
      |       1 | name                           | STGUAT-CLIENT-109                      |
      |       1 | isDemoTenant                   | false                                  |
      |       1 | isDemoTenantActive             | false                                  |
      |       1 | clmProduct.key                 | clm                                    |
      |       1 | clmProduct.screeningSettings   | null                                   |
      |       1 | clmProduct.isValid             | true                                   |
