@Regression @Admin
Feature: Admin

  Scenario: 001 User validates home page with the get action.
    When user has a service named ""
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'text/html;charset=utf-8'

  Scenario: 002 User validates fetching a text file.
    When user has a service named "robots933456.txt"
    And user sends a 'GET' request
    Then response status should be 204

  Scenario: 003 User validates audit log for admin.
    When user has a service named "/audit/log"
    And user has header "Content-Type":"application/json"
    And user has a raw payload from the file "Admin"
    And user sends a 'POST' request
    Then response status should be 200


