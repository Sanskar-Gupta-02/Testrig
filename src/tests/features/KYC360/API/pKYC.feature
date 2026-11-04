@Regression @pKYC
Feature: pKYC API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to should fetch appropriate pKYC rule on passing OB type ID and PKYCID. #ENG-T2987
    Given user has a service named "/api/v1/static/onboardingtypepkyc/get"
    And user has query parameters:
      """
      {
        "OnboardingTypeID": "1761",
        "PKYCID": "55",
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the value:
      | index | key                     | value                                              |
      |     1 | OnboardingTypeID        |                                               1761 |
      |     1 | PKYCID                  |                                                 55 |
      |     1 | PKYCName                | Test purpose                                       |
      |     1 | PKYCDesc                | random test description                            |
      |     1 | TriggerTypeId           |                                                  2 |
      |     1 | TriggerTypeDesc         | Property                                           |
      |     1 | TriggerDateOperator     |                                                  2 |
      |     1 | TriggerDateOperatorDesc | BeforeDate                                         |
      |     1 | TriggerDateMagnitude    |                                                  1 |
      |     1 | TriggerDateTimespan     |                                                  5 |
      |     1 | TriggerDateTimespanDesc | Years                                              |
      |     1 | TriggerValueDesc        | [Property group for pKYC]-[Standard Date property] |

  Scenario: 002 Should be able to should fetch All pKYC rule details on passing OB type ID. #ENG-T2986
    Given user has a service named "/api/v1/static/onboardingtypepkyc/GetAll"
    And user has query parameters:
      """
      {
        "OnboardingTypeID": "1761",
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "obTypepKYC"

  Scenario: 003 Should be able to add a pKYC rule for Onboarded Date triggering type. #ENG-T2992
    Given user has a service named "/api/v1/static/onboardingtypepkyc/add"
    And user has a payload from the file "obTypepKYC"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the value:
      | index | key                     | value                |
      |     1 | OnboardingTypeID        |                 1761 |
      |     1 | PKYCName                | API (Onboarded Date) |
      |     1 | PKYCDesc                | OnboardedDateCheck   |
      |     1 | TriggerTypeId           |                    4 |
      |     1 | TriggerTypeDesc         | OnboardedDate        |
      |     1 | TriggerDateOperator     |                    1 |
      |     1 | TriggerDateOperatorDesc | AfterDate            |
      |     1 | TriggerDateMagnitude    |                    1 |
      |     1 | TriggerDateTimespan     |                    5 |
      |     1 | TriggerDateTimespanDesc | Years                |
    When user store the response body have index keyData with keyName
      | index | key    | storeKey     |
      |     1 | PKYCID | pKYCIDStored |

  Scenario: 004 Should be able to update  Email Recipent, Operator, Magnitude and Timespan of existing rule. #ENG-T2995,T2996
    Given user has a service named "/api/v1/static/onboardingtypepkyc/update"
    When user add payload 'PKYCID' with the stored key value 'pKYCIDStored'
    And user has a payload from the file "obTypepKYC"
    And user has payloads:
      """
       { 
        "TriggerEmailRecipientIDs":2,
        "TriggerDateOperator": 1,
        "TriggerDateMagnitude": 2,
        "TriggerDateTimespan": 4
       }
      """
    And user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the value:
      | index | key                       | value                |
      |     1 | OnboardingTypeID          |                 1761 |
      |     1 | PKYCName                  | API (Onboarded Date) |
      |     1 | PKYCDesc                  | OnboardedDateCheck   |
      |     1 | TriggerTypeId             |                    4 |
      |     1 | TriggerTypeDesc           | OnboardedDate        |
      |     1 | TriggerDateOperator       |                    1 |
      |     1 | TriggerDateOperatorDesc   | AfterDate            |
      |     1 | TriggerDateMagnitude      |                    2 |
      |     1 | TriggerDateTimespan       |                    4 |
      |     1 | TriggerDateTimespanDesc   | Quarters             |
      |     1 | TriggerEmailRecipientIDs  |                    2 |
      |     1 | TriggerEmailRecipientDesc | Supervisor           |

  Scenario: 005 Should be able to delete a pKYC rule of identity approval triggering type. #ENG-T2999
    Given user has a service named "/api/v1/static/onboardingtypepkyc/delete"
    When user add query parameter "PKYCID" with the stored key value "pKYCIDStored"
    And user has query parameters:
      """
      {
          "OnboardingTypeID": "1761",
          "ActionUserID": "521",
          "ReturnFormat": "Json"
      }
      """
    And user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
