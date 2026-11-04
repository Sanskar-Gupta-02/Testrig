@Regression @StaticEmailTemplate
Feature: Static Email Template

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to get Static Email Template
    Given user has a service named "/api/v1/static/emailtemplate/get"
    And user has query parameter "EmailTemplateID":"83"
    And user has a query params from the file "staticEmailTemplate" with selected keys "IncludeHeaderImage,IncludeFooterImage,IncludeCSS,IncludeEmailBody,ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                          | value                                      |
      | EmailTemplate ID             |                                         83 |
      | Name                         | Try2                                       |
      | EmailSubject                 | Personal details                           |
      | Description                  | Try2                                       |
      | EmailTemplateStatus          |                                          1 |
      | ButtonLabel                  | Start                                      |
      | EmailBody                    | <b>Your one-time verification code is:</b> |
      | EmailTemplateType            |                                          1 |
      | VerificationEmailTemplate ID |                                         72 |
      | BusinessUnitID               |                                         10 |
      | BusinessUnitName             | Default                                    |
      | Client ID                    |                                          0 |
    And response body should match the schema from the file "staticEmailTemplate"

  Scenario: 002 Should be able to get all Static Email Template
    Given user has a service named "/api/v1/static/emailtemplate/getall"
    And user has a query params from the file "staticEmailTemplateGetAll" with selected keys "IncludeHeaderImage,IncludeFooterImage,IncludeCSS,IncludeEmailBody,ReturnFormat"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "staticEmailTemplateGetAll"
