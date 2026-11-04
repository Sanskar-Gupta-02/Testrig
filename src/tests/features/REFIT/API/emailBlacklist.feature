@Regression @emailBlacklist
Feature: Email Service Blacklist API

  @Test
  Scenario: 001 Should be able add email address to blacklist
    Given user has a service named "/email/blacklist"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'emailBlacklist'
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And email response body in descending order should have index key with the value:
      | index | key            | value                            |
      |     1 | entries.value  | shantanuchikerur+stgloadtestrefit@kyc360.com |
      |     1 | entries.type   | EmailAddress                     |
      |     1 | entries.reason | Complaint                        |
    And response body should match the schema from the file "emailBlacklist"
    When user store the email response body keyData:"entries.id" with keyName:"blacklistId"

  Scenario: 002 Balcklisted entry should be logged correctly
    Given user has a service named "/email/blacklist"
    And user has header "Content-Type":"application/json"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And email response body in descending order should have index key with the value:
      | index | key            | value                            |
      |     1 | entries.value  | shantanuchikerur+stgloadtestrefit@kyc360.com |
      |     1 | entries.type   | EmailAddress                     |
      |     1 | entries.reason | Complaint                        |
    And response body should match the schema from the file "emailBlacklist"

  Scenario: 003 Should be able to delete blacklisted entry
    Given user has a service named "/email/blacklist/"
    And user has path parameter with the stored key value "blacklistId"
    And user has header "Content-Type":"application/json"
    When user sends a 'DELETE' request
    Then response status should be 204

  Scenario: 004 Should be able to get blacklisted entries
    Given user has a service named "/email/blacklist"
    And user has header "Content-Type":"application/json"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "emailBlacklist"

  Scenario: 005 Should be able add email domain to blacklist
    Given user has a service named "/email/blacklist"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'emailDomain'
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And email response body in descending order should have index key with the value:
      | index | key            | value      |
      |     1 | entries.value  | domain.com |
      |     1 | entries.type   | Domain     |
      |     1 | entries.reason | Bounced    |
    And response body should match the schema from the file "emailDomain"
    When user store the email response body keyData:"entries.id" with keyName:"blacklistId"

  Scenario: 006 Balcklisted entry should be logged correctly
    Given user has a service named "/email/blacklist"
    And user has header "Content-Type":"application/json"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And email response body in descending order should have index key with the value:
      | index | key            | value      |
      |     1 | entries.value  | domain.com |
      |     1 | entries.type   | Domain     |
      |     1 | entries.reason | Bounced    |
    And response body should match the schema from the file "emailDomain"

  Scenario: 007 Should be able to delete blacklisted entry
    Given user has a service named "/email/blacklist/"
    And user has path parameter with the stored key value "blacklistId"
    And user has header "Content-Type":"application/json"
    When user sends a 'DELETE' request
    Then response status should be 204

  Scenario: 008 Should be able add email regexPattern to blacklist
    Given user has a service named "/email/blacklist"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'emailRegExPattern'
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And email response body in descending order should have index key with the value:
      | index | key            | value         |
      |     1 | entries.value  | ^.*abc\\.com$ |
      |     1 | entries.type   | RegExPattern  |
      |     1 | entries.reason | Manual        |
    And response body should match the schema from the file "emailRegExPattern"
    When user store the email response body keyData:"entries.id" with keyName:"blacklistId"

  Scenario: 009 Balcklisted entry should be logged correctly
    Given user has a service named "/email/blacklist"
    And user has header "Content-Type":"application/json"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And email response body in descending order should have index key with the value:
      | index | key            | value         |
      |     1 | entries.value  | ^.*abc\\.com$ |
      |     1 | entries.type   | RegExPattern  |
      |     1 | entries.reason | Manual        |
    And response body should match the schema from the file "emailRegExPattern"

  Scenario: 010 Should be able to delete blacklisted entry
    Given user has a service named "/email/blacklist/"
    And user has path parameter with the stored key value "blacklistId"
    And user has header "Content-Type":"application/json"
    When user sends a 'DELETE' request
    Then response status should be 204

  Scenario: 011 Should not be able to add duplicate email address to blacklist
    Given user has a service named "/email/blacklist"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'duplicateEmailBlacklist'
    When user sends a 'PUT' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key   | value            |
      | title | Validation error |

  Scenario: 012 Should not be able to add duplicate email domain to blacklist
    Given user has a service named "/email/blacklist"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'duplicateEmailDomain'
    When user sends a 'PUT' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key   | value            |
      | title | Validation error |

  Scenario: 013 Should not be able to add duplicate email regexPattern to blacklist
    Given user has a service named "/email/blacklist"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'duplicateEmailRegExPattern'
    When user sends a 'PUT' request
    Then response status should be 400
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key   | value            |
      | title | Validation error |

  Scenario: 014 Should be able to delete blacklisted entry
    Given user has a service named "/email/blacklist/"
    And user has path parameter "14cd2c8c-9b42-480b-96fc-917888575e11"
    And user has header "Content-Type":"application/json"
    When user sends a 'DELETE' request
    Then response status should be 404
    And response header should be 'content-type':'application/problem+json; charset=utf-8'
    And response body should have key with the value:
      | key   | value     |
      | title | Not Found |
