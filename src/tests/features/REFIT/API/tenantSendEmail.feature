@tenantSendEmail @Regression
Feature: Email Service Send email API

  Scenario: 001 Send email to valid email address in 'To' section
    Given user has a service named "/tenant/<TenantID>/email/send"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'validEmailAddresses'
    And user has raw payloads:
      """
      {
        "to": ["testautomation+play@kyc360.com"],
        "from": "testautomations@kyc360.com",
        "bcc":[],
        "cc":[]
      }
      """
    When user sends a 'POST' request
    Then response status should be 200

  Scenario: 002 Send email to valid email address in 'Cc' section
    Given user has a service named "/tenant/<TenantID>/email/send"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'validEmailAddresses'
    And user has raw payloads:
      """
      {
        "to": ["testautomation+play@kyc360.com"],
        "from": "testautomations@kyc360.com",
        "bcc":[],
        "cc":["testautomation+cc@kyc360.com"]
      }
      """
    When user sends a 'POST' request
    Then response status should be 200

  Scenario: 003 Send email to valid email address in 'Bcc' section
    Given user has a service named "/tenant/<TenantID>/email/send"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'validEmailAddresses'
    And user has raw payloads:
      """
      {
        "to": ["testautomation+play@kyc360.com"],
        "from": "testautomations@kyc360.com",
        "bcc":["testautomation+bcc@kyc360.com"],
        "cc":[]
      }
      """
    When user sends a 'POST' request
    Then response status should be 200

  Scenario: 004 Should not Send email to blacklisted email address in 'To' section
    Given user has a service named "/tenant/<TenantID>/email/blacklist/"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'emailBlacklist'
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And email response body in descending order should have index key with the value:
      | index | key            | value        |
      |     1 | entries.value  | shantanuchikerur+stgloadtestrefit@kyc360.com |
      |     1 | entries.type   | EmailAddress |
      |     1 | entries.reason | Complaint    |
    And response body should match the schema from the file "emailBlacklist"
    When user store the email response body keyData:"entries.id" with keyName:"blacklistId"
    And user has a service named "/tenant/<TenantID>/email/send"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'validEmailAddresses'
    And user has raw payloads:
      """
      {
        "to": ["shantanuchikerur+stgloadtestrefit@kyc360.com"],
        "from": "testautomations@kyc360.com",
        "bcc":[],
        "cc":[]
      }
      """
    When user sends a 'POST' request
    Then response status should be 400
    When user has a service named "/tenant/<TenantID>/email/blacklist/"
    And user has path parameter with the stored key value "blacklistId"
    And user has header "Content-Type":"application/json"
    And user sends a 'DELETE' request
    Then response status should be 204

  Scenario: 005 Should not Send email to blacklisted email address in 'Cc' section
    Given user has a service named "/tenant/<TenantID>/email/blacklist/"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'emailBlacklist'
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And email response body in descending order should have index key with the value:
      | index | key            | value        |
      |     1 | entries.value  | shantanuchikerur+stgloadtestrefit@kyc360.com |
      |     1 | entries.type   | EmailAddress |
      |     1 | entries.reason | Complaint    |
    And response body should match the schema from the file "emailBlacklist"
    When user store the email response body keyData:"entries.id" with keyName:"blacklistId"
    And user has a service named "/tenant/<TenantID>/email/send"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'validEmailAddresses'
    And user has raw payloads:
      """
      {
        "to": ["testautomation+play@kyc360.com"],
        "from": "testautomations@kyc360.com",
        "bcc":[],
        "cc":["shantanuchikerur+stgloadtestrefit@kyc360.com"]
      }
      """
    And user sends a 'POST' request
    Then response status should be 400
    When user has a service named "/tenant/<TenantID>/email/blacklist/"
    And user has path parameter with the stored key value "blacklistId"
    And user has header "Content-Type":"application/json"
    And user sends a 'DELETE' request
    Then response status should be 204

  Scenario: 006  Should not Send email to blacklisted email address in 'Bcc' section
    Given user has a service named "/tenant/<TenantID>/email/blacklist/"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'emailBlacklist'
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And email response body in descending order should have index key with the value:
      | index | key            | value        |
      |     1 | entries.value  | shantanuchikerur+stgloadtestrefit@kyc360.com |
      |     1 | entries.type   | EmailAddress |
      |     1 | entries.reason | Complaint    |
    And response body should match the schema from the file "emailBlacklist"
    When user store the email response body keyData:"entries.id" with keyName:"blacklistId"
    And user has a service named "/tenant/<TenantID>/email/send"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'validEmailAddresses'
    And user has raw payloads:
      """
      {
        "to": ["testautomation+play@kyc360.com"],
        "from": "testautomations@kyc360.com",
        "bcc":["shantanuchikerur+stgloadtestrefit@kyc360.com"],
        "cc":[]
      }
      """
    And user sends a 'POST' request
    Then response status should be 400
    And user has a service named "/tenant/<TenantID>/email/blacklist/"
    And user has path parameter with the stored key value "blacklistId"
    And user has header "Content-Type":"application/json"
    When user sends a 'DELETE' request
    Then response status should be 204

  Scenario: 007 Send  email addressto valid email address and validate
    Given user has a service named "/tenant/<TenantID>/email/validate-addresses"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'validateEmailAddresses'
    When user sends a 'POST' request
    Then response status should be 200
    And email response body in descending order should have index key with the value:
      | index | key            | value               |
      |     1 | emails.address | abcvalid@kyc360.com |
      |     1 | emails.isValid | true                |
    And response body should match the schema from the file "validateEmailAddresses"

  Scenario: 008 Validate blacklist domain
    Given user has a service named "/tenant/<TenantID>/email/blacklist/"
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
    And user has a service named "/tenant/<TenantID>/email/validate-addresses"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'validateEmailAddresses'
    And user has raw payloads:
      """
      {
        "emails": ["abc@domain.com"]
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And email response body in descending order should have index key with the value:
      | index | key            | value               |
      |     1 | emails.address | abc@domain.com      |
      |     1 | emails.isValid | false               |
      |     1 | emails.error   | Blacklisted address |
    And response body should match the schema from the file "validateEmailAddresses"
    When user has a service named "/tenant/<TenantID>/email/blacklist/"
    And user has path parameter with the stored key value "blacklistId"
    And user has header "Content-Type":"application/json"
    And user sends a 'DELETE' request
    Then response status should be 204

  Scenario: 009 Validate blacklist RegExPattern
    Given user has a service named "/tenant/<TenantID>/email/blacklist/"
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
    And user has a service named "/tenant/<TenantID>/email/validate-addresses"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'validateEmailAddresses'
    And user has raw payloads:
      """
      {
        "emails": ["open@1abc.com"]
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    And email response body in descending order should have index key with the value:
      | index | key            | value               |
      |     1 | emails.address | open@1abc.com       |
      |     1 | emails.isValid | false               |
      |     1 | emails.error   | Blacklisted address |
    And response body should match the schema from the file "validateEmailAddresses"
    And user has a service named "/tenant/<TenantID>/email/blacklist/"
    And user has path parameter with the stored key value "blacklistId"
    And user has header "Content-Type":"application/json"
    When user sends a 'DELETE' request
    Then response status should be 204

  Scenario: 010 Validate addresses of Multiple Email addresses
    Given user has a service named "/tenant/<TenantID>/email/validate-addresses"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'validateEmailAddresses'
    And user has raw payloads:
      """
       {
         "emails": ["valid@example.com", "invalid@domain.com", "open@abc.com", "user@valid.com"]
       }
      """
    When user sends a 'POST' request
    Then response status should be 200
    And email response body in descending order should have index key with the value:
      | index | key            | value             |
      |     1 | emails.address | user@valid.com    |
      |     1 | emails.isValid | true              |
      |     2 | emails.address | open@abc.com      |
      |     2 | emails.isValid | true              |
      |     3 | emails.address | invalid@domain.com    |
      |     3 | emails.isValid | true              |
      |     4 | emails.address | valid@example.com |
      |     4 | emails.isValid | true              |
    And response body should match the schema from the file "validateEmailAddresses"

  Scenario: 011 Should not Send email to invalid email address in 'To' section
    Given user has a service named "/tenant/<TenantID>/email/send"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'validEmailAddresses'
    And user has raw payloads:
      """
      {
        "to": ["testautomation+invalid"],
        "from": "testautomations@kyc360.com",
        "bcc":[],
        "cc":[]
      }
      """
    When user sends a 'POST' request
    Then response status should be 400

  Scenario: 012 Should not  Send email to invalid email address in 'Cc' section
    Given user has a service named "/tenant/<TenantID>/email/send"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'validEmailAddresses'
    And user has raw payloads:
      """
      {
        "to": ["testautomation+play@kyc360.com"],
        "from": "testautomations@kyc360.com",
        "bcc":[],
        "cc":["testautomationinvalid"]
      }
      """
    When user sends a 'POST' request
    Then response status should be 400

  Scenario: 013 Should not Send email to invalid email address in 'Bcc' section
    Given user has a service named "/tenant/<TenantID>/email/send"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file 'validEmailAddresses'
    And user has raw payloads:
      """
      {
        "to": ["testautomation+play@kyc360.com"],
        "from": "testautomations@kyc360.com",
        "bcc":["testautomationinvalid"],
        "cc":[]
      }
      """
    When user sends a 'POST' request
    Then response status should be 400
