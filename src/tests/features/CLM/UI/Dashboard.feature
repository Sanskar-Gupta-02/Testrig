@CLM @Dashboard @Regression
Feature: Dashboard

  Background:
    Given user login into the 'CLM' application with 'AdminUserName' user

  @Smoke
  Scenario: 001 Dashboard  Page Verification #ENG-T11154,T12285,T10232
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "Dashboard" on "Home"
    Then user should see ' Dashboard ' on 'PageTitle' on 'Common' page
    And user should able see "BURiskGraph" on "Dashboard" page
    And user should able see "TenantGraph" on "Dashboard" page
    And user should able see "EntityTypeRiskGraph" on "Dashboard" page
    And user should able see "RiskModelAggregatedGraph" on "Dashboard" page
    And user should see ' Business Unit Risk ' on 'BURiskGraphTitle' on 'Dashboard' page
    And user should see ' TEST AUTOMATION TENANT - DO NOT TOUCH Risk ' on 'TenantGraphTitle' on 'Dashboard' page
    And user should see ' Entity Type Risk ' on 'EntityTypeRiskGraphTitle' on 'Dashboard' page
    And user should see ' Risk Model Aggregated ' on 'RiskModelAggregatedGraphTitle' on 'Dashboard' page
    When user clicks on "ReviewBtn" button associate with text "Review" on "Common"
    Then user should able see "ReviewType" on "Dashboard" page
    When user clicks on "KYCtab" on "Dashboard" page
    Then user should see 'Context: Tenant Range: last 7 days' on 'ContextRangeTitle' on 'Dashboard' page
    And user should able see "ModelsText" on "Dashboard" page
    And user should able see "GroupByRule" on "Dashboard" page
    And user should able see "GroupByModel" on "Dashboard" page
