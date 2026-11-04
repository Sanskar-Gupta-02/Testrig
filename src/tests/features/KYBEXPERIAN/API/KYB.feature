@Regression @KYB
Feature: KYB API

  Background:
    Given user is authorized using an 'XAPIKEY'

  @KYB1
  Scenario: 001 KYB Post call should work as expected
    Given user has a service named "/api/kyb/search/Experian"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'KYB'
    When user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index based on array key with the value:
      | index | key                          | value                                               |
      |     1 | success                      | true                                                |
      |     1 | errors                       | null                                                |
      |     1 | providerName                 | Experian                                            |
      |     1 | totalResults                 |                                                   1 |
      |     1 | companies.companyId          |                                            11075880 |
      |     1 | companies.companyName        | SWAGE CONSULTING LTD.                               |
      |     1 | companies.registrationNumber |                                            11075880 |
      |     1 | companies.countryCode        | null                                                |
      |     1 | companies.countryName        | null                                                |
      |     1 | companies.status             | D                                                   |
      |     1 | companies.address            | 5 BLENHEIM WAY, HARROGATE, NORTH YORKSHIRE, HG2 9DS |
      |     1 | companies.state              | null                                                |
      |     1 | companies.lastUpdated        | null                                                |
      |     1 | totalResults                 |                                                   1 |
      |     1 | rawResponse                  | null                                                |
    And response body should match the schema from the file "KYB"

  @KYB2
  Scenario: 002 KYB Post call should return error when searchTerm is missing
    Given user has a service named "/api/kyb/search/Experian"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
        "countryCode": "NZ",
        "searchType": 0,
        "tenantId": "<TenantID>"
      }
      """
    When user sends a 'POST' request
    Then response status should be 400
    And response body in ascending order should have index key with the contains value:
      | index | key    | value                   |
      |     1 | errors | SearchTerm is required. |

  @KYB3
  Scenario: 003 KYB Post call should return error when searchTerm is empty
    Given user has a service named "/api/kyb/search/Experian"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
        "countryCode": "NZ",
        "searchTerm": "",
        "searchType": 0,
        "tenantId": "<TenantID>"
      }
      """
    When user sends a 'POST' request
    Then response status should be 400
    And response body in ascending order should have index key with the contains value:
      | index | key    | value                   |
      |     1 | errors | SearchTerm is required. |

  @KYB4
  Scenario: 004 KYB Post call should return error when tenantId is missing
    Given user has a service named "/api/kyb/search/Experian"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
        "countryCode": "NZ",
        "searchTerm": "SWAGE CONSULTING LTD",
        "searchType": 0
      }
      """
    When user sends a 'POST' request
    Then response status should be 400
    And response body in ascending order should have index key with the contains value:
      | index | key    | value                 |
      |     1 | errors | TenantId is required. |

  @KYB5
  Scenario: 005 KYB Post call should return error when tenantId format is invalid
    Given user has a service named "/api/kyb/search/Experian"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
        "countryCode": "NZ",
        "searchTerm": "SWAGE CONSULTING LTD",
        "searchType": 0,
        "tenantId": "invalid-tenant-id"
      }
      """
    When user sends a 'POST' request
    Then response status should be 400
    And response body in ascending order should have index key with the contains value:
      | index | key    | value                          |
      |     1 | errors | TenantId must be a valid GUID. |

  @KYB6
  Scenario: 006 KYB Post call with numerical countryCode should return valid response
    Given user has a service named "/api/kyb/search/Experian"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
        "countryCode": "21",
        "searchTerm": "SWAGE CONSULTING LTD",
        "searchType": 0,
        "tenantId": "<TenantID>"
      }
      """
    When user sends a 'POST' request
    Then response status should be 200
    And response body in ascending order should have index based on array key with the value:
      | index | key                          | value                                               |
      |     1 | success                      | true                                                |
      |     1 | errors                       | null                                                |
      |     1 | providerName                 | Experian                                            |
      |     1 | totalResults                 |                                                   1 |
      |     1 | companies.companyId          |                                            11075880 |
      |     1 | companies.companyName        | SWAGE CONSULTING LTD.                               |
      |     1 | companies.registrationNumber |                                            11075880 |
      |     1 | companies.countryCode        | null                                                |
      |     1 | companies.countryName        | null                                                |
      |     1 | companies.status             | D                                                   |
      |     1 | companies.address            | 5 BLENHEIM WAY, HARROGATE, NORTH YORKSHIRE, HG2 9DS |
      |     1 | companies.state              | null                                                |
      |     1 | companies.lastUpdated        | null                                                |
      |     1 | totalResults                 |                                                   1 |
      |     1 | rawResponse                  | null                                                |
    And response body should match the schema from the file "KYB"

  @KYB7
  Scenario: 007 KYB Post call should return error when searchType is invalid
    Given user has a service named "/api/kyb/search/Experian"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
        "countryCode": "NZ",
        "searchTerm": "SWAGE CONSULTING LTD",
        "searchType": 99,
        "tenantId": "<TenantID>"
      }
      """
    When user sends a 'POST' request
    Then response status should be 400
    And response body in ascending order should have index key with the contains value:
      | index | key    | value                                                                                |
      |     1 | errors | SearchType must be a valid value (Name = 0, RegistrationNumber = 1, DunsNumber = 2). |

  @KYB8
  Scenario: 008 KYB Post call should return zero results for a non-existent company
    Given user has a service named "/api/kyb/search/Experian"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
        "countryCode": "NZ",
        "searchTerm": "XYZNONEXISTENTCOMPANY12345",
        "searchType": 0,
        "tenantId": "<TenantID>"
      }
      """
    When user sends a 'POST' request
    Then response status should be 200
    And response body should have key "success" with the value "true"
    And response body should have key "totalResults" with the value "0"

  @KYB9
  Scenario: 009 User should be able to Retrieve full company details via Company Name
    Given user has a service named "/api/kyb/company/Experian"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'KYBSearchCompanyName'
    When user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "KYBSearchCompanyName"
    And response body should match the schema from the file "KYBSearchCompanyName"

  @KYB10
  Scenario: 010 User should be able to Retrieve full company details via Provider Company ID
    Given user has a service named "/api/kyb/company/Experian"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'KYBSearchProviderCompanyId'
    When user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "KYBSearchProviderCompanyId"
    And response body should match the schema from the file "KYBSearchProviderCompanyId"

  @KYB11
  Scenario: 011 User should not be able to Retrieve full company details wrong Provider Company ID
    Given user has a service named "/api/kyb/company/Experian"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
        "providerCompanyId": "1253691",
        "tenantId": "<TenantID>"
      }
      """
    When user sends a 'POST' request
    Then response status should be 502

  @KYB12
  Scenario: 012 User should not be able to Retrieve full company details with missing tenantId
    Given user has a service named "/api/kyb/company/Experian"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
        "providerCompanyId": "12536912"
      }
      """
    When user sends a 'POST' request
    Then response status should be 400

  @KYB13
  Scenario: 013 User should not be able to Retrieve full company details with invalid tenantId
    Given user has a service named "/api/kyb/company/Experian"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
        "providerCompanyId": "12536912",
        "tenantId": "invalid-tenant-id"
      }
      """
    When user sends a 'POST' request
    Then response status should be 400

  @KYB14
  Scenario: 014 User should be able to Retrieve full company details with using all valid non-mandatory fields
    Given user has a service named "/api/kyb/company/Experian"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'KYBSearchCompanyName'
    And user has raw payloads:
      """
      {
        "legalStatus":"L",
        "dataBlocks":["KeyParties"],
        "addressLine1":"UNIT H2 MAYLES LANE",
        "addressLine2":"KNOWLE",
        "addressLine3":"FAREHAM",
        "town":"FAREHAM",
        "county":"HAMPSHIRE",
        "country":"UNITED KINGDOM",
        "postcode":"PO17 5DY",
        "countryCode":"UK"
      }
      """
    When user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the expected data from the file "KYBSearchFullMatch"
    And response body should match the schema from the file "KYBSearchFullMatch"

  @KYB15
  Scenario: 015 User should not be able to Retrieve full company details with invalid Legal Status
    Given user has a service named "/api/kyb/company/Experian"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'KYBSearchCompanyName'
    And user has raw payloads:
      """
      {
        "legalStatus":"A"
      }
      """
    When user sends a 'POST' request
    Then response status should be 400
    And response body in ascending order should have index key with the contains value:
      | index | key    | value                                                   |
      |     1 | errors | LegalStatus must be 'L' (limited) or 'N' (non-limited). |

  @KYB16
  Scenario: 016 User should not be able to Retrieve full company details with invalid dataBlocks
    Given user has a service named "/api/kyb/company/Experian"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'KYBSearchCompanyName'
    And user has raw payloads:
      """
      {
        "dataBlocks":["InvalidDataBlock"]
      }
      """
    When user sends a 'POST' request
    Then response status should be 400
    And response body in ascending order should have index key with the contains value:
      | index | key    | value                                                                      |
      |     1 | errors | DataBlocks must only contain valid values: KeyParties, CompanyInformation. |

  @KYB17
  Scenario: 017 User should not be able to Retrieve full company details with invalid datasetType
    Given user has a service named "/api/kyb/company/Experian"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'KYBSearchCompanyName'
    And user has raw payloads:
      """
      {
        "datasetType":"invalid"
      }
      """
    When user sends a 'POST' request
    Then response status should be 400
    And response body in ascending order should have index key with the contains value:
      | index | key    | value                                                 |
      |     1 | errors | DatasetType must be one of: index, refresh, enhanced. |

  @KYB18
  Scenario: 018 User should be able to get raw response.
    Given user has a service named "/api/kyb/search/Experian"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'KYB'
    And user has raw payloads:
      """
      {
      "limit":1,
      "offset":1,
      "liveSearch": true,
      "includeRawResponse":true
      }
      """
    When user sends a 'POST' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index based on array key with the value:
      | index | key                          | value                                               |
      |     1 | success                      | true                                                |
      |     1 | errors                       | null                                                |
      |     1 | providerName                 | Experian                                            |
      |     1 | totalResults                 |                                                   1 |
      |     1 | companies.companyId          |                                            11075880 |
      |     1 | companies.companyName        | SWAGE CONSULTING LTD.                               |
      |     1 | companies.registrationNumber |                                            11075880 |
      |     1 | companies.countryCode        | null                                                |
      |     1 | companies.countryName        | null                                                |
      |     1 | companies.status             | D                                                   |
      |     1 | companies.address            | 5 BLENHEIM WAY, HARROGATE, NORTH YORKSHIRE, HG2 9DS |
      |     1 | companies.state              | null                                                |
      |     1 | companies.lastUpdated        | null                                                |
      |     1 | totalResults                 |                                                   1 |
      |     1 | rawResponse.providerName     | Experian                                            |
      |     1 | rawResponse.statusCode       | null                                                |
    And response body should match the schema from the file "KYB"

  @KYB19
  Scenario: 019 User should not be able to Retrieve full company details with invalid api key
    Given user is authorized using an 'INVALIDXAPIKEY'
    And user has a service named "/api/kyb/company/Experian"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'KYBSearchCompanyName'
    When user sends a 'POST' request
    Then response status should be 403

  @KYB20
  Scenario: 020 User should not be able to search Retrieve full company details with invalid api key
    Given user is authorized using an 'INVALIDXAPIKEY'
    And user has a service named "/api/kyb/search/Experian"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'KYB'
    When user sends a 'POST' request
    Then response status should be 403
