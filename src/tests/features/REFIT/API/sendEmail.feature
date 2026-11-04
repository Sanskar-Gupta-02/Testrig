@sendEmail @Regression
Feature: Email Service Send email API

  Scenario: 001 Send email to valid email address in 'To' section
    Given user has a service named "/email/send"
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
    Given user has a service named "/email/send"
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
    Given user has a service named "/email/send"
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

  Scenario: 004 send email to blacklisted email address in 'To' section
    Given user has a service named "/email/blacklist"
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
    Given user has a service named "/email/send"
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

  Scenario: 005 Send email to blacklisted email address in 'Cc' section
    Given user has a service named "/email/send"
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
    When user sends a 'POST' request
    Then response status should be 400

  Scenario: 006 Send email to blacklisted email address in 'Bcc' section
    Given user has a service named "/email/send"
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
    When user sends a 'POST' request
    Then response status should be 400

  Scenario: 007 Should be able to delete blacklisted entry
    Given user has a service named "/email/blacklist/"
    And user has path parameter with the stored key value "blacklistId"
    And user has header "Content-Type":"application/json"
    When user sends a 'DELETE' request
    Then response status should be 204

  Scenario: 008 Send email to invalid email address in 'To' section
    Given user has a service named "/email/send"
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

  Scenario: 009 Send email to invalid email address in 'Cc' section
    Given user has a service named "/email/send"
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

  Scenario: 010 Send email to invalid email address in 'Bcc' section
    Given user has a service named "/email/send"
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
