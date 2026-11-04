@Regression @User
Feature: User Configuration

  Scenario: 001 User validates home page with the get action.
    When user has a service named ""
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'text/html;charset=utf-8'

  Scenario: 002 User validates fetching a text file.
    When user has a service named "robots933456.txt"
    And user sends a 'GET' request
    Then response status should be 204

  Scenario: 003 user should be able to send invites to that particular tenant.
    When user has a service named "/tenants/<TenantID>/users/invite"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
       {
      "emailAddress": "AutomationTesting@example.com",
      "firstName": "Automation",
      "lastName": "Test"
      }
      """
    And user sends a 'POST' request
    Then response status should be 201
    And response body should match the schema from the file "User"

  Scenario: 004 user should be able to fetch tenantId Based on its Email.
    When user has a service named "/tenants"
    And user has query parameter "Email":"test@gmail.com"
    And user sends a 'GET' request
    Then response status should be 200
    And response body in ascending order should have index key with the contains value:
      | index | key                                | value                                |
      |     1 | tenantMemberships.tenantId         | f6808a9d-4187-428c-9127-0e94f9dbe7dd |
      |     1 | tenantMemberships.created          |         2025-09-29T07:16:13.9911728Z |
      |     1 | tenantMemberships.updated          |         2025-09-29T07:16:13.9911737Z |
      |     1 | tenantMemberships.membershipStatus |                                    1 |
      |     1 | tenantMemberships.accepted         | null                                 |

  Scenario: 005 user should be able to fetch user based on tenantID.
    When user has a service named "/tenants/<TenantID>/users"
    And user has header "Content-Type":"application/json"
    And user sends a 'GET' request
    Then response status should be 200
    And response body should match the schema from the file "UserGet"

  Scenario: 006 user should be able to fetch users based on its Email.
    When user has a service named "/users"
    And user has query parameter "Email":"test@gmail.com"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key              | value                                |
      | userId           | 63b40458-753b-4b6d-a1c7-114db90ac27f |
      | firstName        | TEST                                 |
      | lastName         | string                               |
      | email            | test@gmail.com                       |
      | created          |         2025-09-29T07:16:13.8265751Z |
      | membershipStatus |                                    0 |
      | profileStatus    |                                    8 |

  Scenario: 007 user should be able to fetch user's profile based on its userID.
    When user has a service named "/users/<UserID>/profile"
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key              | value                                |
      | userId           | 63b40458-753b-4b6d-a1c7-114db90ac27f |
      | firstName        | TEST                                 |
      | lastName         | string                               |
      | email            | test@gmail.com                       |
      | created          |         2025-09-29T07:16:13.8265751Z |
      | membershipStatus |                                    0 |
      | profileStatus    |                                    8 |

  Scenario: 008 user should be able to update User profile details based on its userID.
    When user has a service named "/users/<UserID>/profile"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
      {
      "firstName": "TEST1",
      "lastName": "string"
      }
      """
    And user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key       | value  |
      | firstName | TEST1  |
      | lastName  | string |
    #Data Revert
    And user has raw payloads:
      """
      {
      "firstName": "TEST"
      }
      """
    And user sends a 'PUT' request
    Then response status should be 200
