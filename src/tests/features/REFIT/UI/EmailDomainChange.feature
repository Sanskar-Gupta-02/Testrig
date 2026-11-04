@Regression @EmailDomainChange
Feature: Email Domain Change Automation

  Background:
    Given user login into 'REFIT' application with 'HandlerUserName' user

  @EmailDomainChange1
  Scenario: 001 If any data request sent for onboarding of a prospect available in Business Unit which has email setting attached, then email sent should be as per configuration of email setting / domain. #ENG-T2279,T2281
    When user selects "12" Business Unit
    And user enter SearchName:'AutocreationDomainChange',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
