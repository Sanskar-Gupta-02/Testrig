@CLM
Feature: User and Invitation Management
  //add user api's

  Scenario: 001 Add user from UI
    Given user login into the 'CLM' application with 'AdminUserName' user
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH"
    And user add user by navigates User page and FirstName:'TestingInvite',LastName:'test' and email:'TestingInvite@test.com' with unique suffix
    Then user should able see "ViewUser" with text "View: TestingInvite test" on 'Users' page
    And user close browser

  Scenario: 002 GetUserID - Get 404 Error when Invalid Email ID is Passed #ENG-T8956
    Given user has a service named "/users?email=TestingInvite0001@test.com"
    When user sends a 'GET' request
    Then response status should be 404

  Scenario: 003 GetUserID - Get User ID when Valid Email ID is Passed #ENG-T8955
    Given user has a service named "/users?email=<EmailID>"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key              | value         |
      | firstName        | TestingInvite |
      | lastName         | test          |
      | membershipStatus |             0 |
      | profileStatus    |             4 |
    And response body should have key 'email' with the stored key value 'EmailID'
    When user store the response body keyData:"userId" with keyName:"UserID"
    And user store the response body keyData:"email" with keyName:"EmailID"

  Scenario: 004 InviteUser - User Invite when Correct Tenant and User ID are Provided #ENG-T8839
    Given user has a service named "/tenants/<TenantID>/users/<UserID>/invite"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key        | value                                 |
      | firstName  | TestingInvite                         |
      | lastName   | test                                  |
      | tenantName | TEST AUTOMATION TENANT - DO NOT TOUCH |
    And response body should have key 'email' with the stored key value 'EmailID'
    And response body should have key 'userId' with the stored key value 'UserID'
    When user store the response body keyData:"inviteId" with keyName:"InviteId"

  Scenario: 005 InviteUser - User Invite when <Scenario> #ENG-T8966,T8837,8834,8833
    Given user has a service named "/tenants/<TenantID>/users/<InviteId>/invite"
    When user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'text/plain; charset=utf-8'
    And response body should text contains "<Message>"

    Examples:
      | Scenario                                             | TenantID          | InviteId                             | Message         |
      | Invalid Tenant ID and Valid Invitation ID are Passed | <InvalidTenantID> | <InviteId>                           | User not found. |
      | Correct Tenant ID and Incorrect Invite ID are Passed | <TenantID>        | b0f4ceb4-4fbb-460f-ba22-2618bed64397 | User not found. |

  Scenario: 006 RevokeInvitation - Revoke User Invitation with Valid Tenant ID and Invite ID #ENG-T8832
    Given user has a service named "/tenants/<TenantID>/users/invites/<InviteId>/revoke"
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key     | value |
      | success | true  |

  Scenario: 007 SendInvitation - Send User Invitation #ENG-T8977
    Given user has a service named "/tenants/<TenantID>/users/Invite"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
        {
          "emailAddress": "TestingInvite@test.com",
          "invite": {
            "body": "string",
            "subject": "string"
          }
        }
      """
    And user add raw payload "emailAddress" with the stored key value "EmailID"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key 'email' with the stored key value 'EmailID'
    And response body should have key 'id' with the stored key value 'UserID'

  Scenario: 008 InviteUser - User Invite when Correct Tenant and User ID are Provided #ENG-T8839
    Given user has a service named "/tenants/<TenantID>/users/<UserID>/invite"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key        | value                                 |
      | firstName  | TestingInvite                         |
      | lastName   | test                                  |
      | tenantName | TEST AUTOMATION TENANT - DO NOT TOUCH |
    And response body should have key 'email' with the stored key value 'EmailID'
    And response body should have key 'userId' with the stored key value 'UserID'
    When user store the response body keyData:"inviteId" with keyName:"InviteId"

  Scenario: 009 DeclineInvitation - Decline User Invitation #ENG-T9057
    Given user has a service named "tenants/<TenantID>/users/invites/<InviteId>/decline"
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key     | value |
      | success | true  |

  Scenario: 010 InviteManagement - Get Invite call Return Error When Declined Invitation User ID is Passed and Invitation Has Not Been Sent #ENG-T8838,T8836
    Given user has a service named "/tenants/<TenantID>/users/<UserID>/invite"
    When user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'text/plain; charset=utf-8'
    And response body should text contains "Invite not found."

  Scenario: 011 RevokeInvitation - Revoke Invitation for User Whose Invitation is Declined #ENG-T9058
    Given user has a service named "/tenants/<TenantID>/users/invites/<InviteId>/revoke"
    When user sends a 'PUT' request
    Then response status should be 404
    And response header should be 'content-type':'text/plain; charset=utf-8'
    And response body should text contains "Invite not found."

  Scenario: 012 Reinstate Access - Restore access for a user whose invitation was declined when correct Tenant and User ID are provided #ENG-T8819
    Given user has a service named "/tenants/<TenantID>/users/<UserID>/access/reinstate"
    When user sends a 'PUT' request
    Then response status should be 404
    And response header should be 'content-type':'text/plain; charset=utf-8'
    And response body should text contains "Membership not found."

  Scenario: 013 SendInvitation - Send User Invitation #ENG-T8977
    Given user has a service named "/tenants/<TenantID>/users/Invite"
    And user has header "Content-Type":"application/json"
    And user has raw payloads:
      """
        {
          "emailAddress": "TestingInvite@test.com",
          "invite": {
            "body": "string",
            "subject": "string"
          }
        }
      """
    And user add raw payload "emailAddress" with the stored key value "EmailID"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key 'email' with the stored key value 'EmailID'
    And response body should have key 'id' with the stored key value 'UserID'

  Scenario: 014 InviteManagement - User Invite When Correct Tenant and User ID Whose Invitation Has Been Sent and Accepted is Passed #ENG-T8839
    Given user has a service named "/tenants/<TenantID>/users/<UserID>/invite"
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key        | value                                 |
      | firstName  | TestingInvite                         |
      | lastName   | test                                  |
      | tenantName | TEST AUTOMATION TENANT - DO NOT TOUCH |
    And response body should have key 'email' with the stored key value 'EmailID'
    And response body should have key 'userId' with the stored key value 'UserID'
    When user store the response body keyData:"inviteId" with keyName:"InviteId"

  Scenario: 015 RevokeInvitation - Revoke User Invitation After Acceptance <Scenario> #ENG-T8787,T8956
    Given user has a service named "/tenants/<TenantID>/users/invites/<InviteId>/revoke"
    When user sends a 'PUT' request
    Then response status should be 404
    And response header should be 'content-type':'text/plain; charset=utf-8'
    And response body should text contains "<Message>"

    Examples:
      | Scenario                             | TenantID          | InviteId                             | Message           |
      | with Invalid Tenant ID and Invite ID | <InvalidTenantID> | <InviteId>                           | Invite not found. |
      | with Valid Tenant ID and Invite ID   | <TenantID>        | b0f4ceb4-4fbb-460f-ba22-2618be6b4398 | Invite not found. |

  Scenario: 016 ReinstateAccess - Reinstate  ENG-T8812,T8790,T8791
    Given user has a service named "/tenants/<TenantID>/users/<UserID>/access/reinstate"
    When user sends a 'PUT' request
    Then response status should be 404
    And response header should be 'content-type':'text/plain; charset=utf-8'
    And response body should text contains "<Message>"

    Examples:
      | Scenario                                                | TenantID          | UserID                               | Message               |
      | with valid Tenant and Invalid User Id is passed.        | <TenantID>        | b0f4ceb4-4fbb-460f-ba22-2618be6b4398 | User not found.       |
      | Invitation for User Who Has Not Accepted Invitation Yet | <TenantID>        | <UserID>                             | Membership not found. |
      | with invalid Tenant and Valid User Id is passed.        | <InvalidTenantID> | <UserID>                             | Tenant not found.     |

  Scenario: 017 AcceptInvitation - Accept invite with valid data #ENG-T8840
    Given user has a service named "tenants/<TenantID>/users/invites/<InviteId>/accept"
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key 'userId' with the stored key value 'UserID'
    And response body should have key 'emailAddress' with the stored key value 'EmailID'

  Scenario: 018 InviteManagement - User Invitation with Valid Tenant ID and Invite ID of Accepted User #ENG-T8835
    Given user has a service named "/tenants/<TenantID>/users/<UserID>/invite"
    When user sends a 'GET' request
    Then response status should be 404
    And response header should be 'content-type':'text/plain; charset=utf-8'
    And response body should text contains "Invite not found."

  Scenario: 019 RevokeInvitation - Revoke Invitation for User Who Has Accepted Invitation #ENG-T8785
    Given user has a service named "/tenants/<TenantID>/users/invites/<InviteId>/revoke"
    When user sends a 'PUT' request
    Then response status should be 404
    And response header should be 'content-type':'text/plain; charset=utf-8'
    And response body should text contains "Invite not found."

  Scenario: 020 ReinstateAccess - Reinstate Access for User Whose Access is Not Revoked ENG-T8792
    Given user has a service named "/tenants/<TenantID>/users/<UserID>/access/reinstate"
    When user sends a 'PUT' request
    Then response status should be 404
    And response header should be 'content-type':'text/plain; charset=utf-8'
    And response body should text contains "Membership not found."

  Scenario: 021 AccessControl - Revoke User Access with Valid Tenant and User ID #ENG-T8785
    Given user has a service named "/tenants/<TenantID>/users/<UserID>/access/revoke"
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key     | value |
      | success | true  |

  Scenario: 022 AccessControl - Revoke Access for Already Revoked User ENG-T8786
    Given user has a service named "/tenants/<TenantID>/users/<UserID>/access/revoke"
    When user sends a 'PUT' request
    Then response status should be 404
    And response header should be 'content-type':'text/plain; charset=utf-8'
    And response body should text contains "Membership not found"

  Scenario: 023 ReinstateAccess - Reinstate User Access When Valid Tenant and User ID Are Provided #ENG-T8789
    Given user has a service named "/tenants/<TenantID>/users/<UserID>/access/reinstate"
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key     | value |
      | success | true  |
