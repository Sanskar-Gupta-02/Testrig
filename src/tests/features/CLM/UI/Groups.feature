@CLM @Groups @Regression
Feature: Groups

  Background:
    Given user login into the 'CLM' application with 'AdminUserName' user
    And user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"

  @Smoke
  Scenario: 001 Validating Add Entity Above/Below a Member #ENG-T10153
    When user clicks on "SideBarMenu" button associate with text "Groups" on "Home"
    Then user should see ' Groups ' on 'PageTitle' on 'DSPage' page
    When user clicks on "CommonTableViewBtn" button associate with text "Automation Do Not Touch" on "Common"
    And user enter "Entity Automation Do Not Touch" text in "SearchBox" field on "Groups" page
    And user clicks on "GroupViewBtn" button associate with text "Entity Automation Do Not Touch" on "Groups"
    Then user should see ' View - Entity Automation Do Not Touch ' on 'ViewPageTitle' on 'Common' page
    And user should see ' Members ' on 'MemberTabTitle' on 'Groups' page
    When user turns on the toggle "MemberToggleBtn" on "Groups" page
    And user clicks on "AddAboveBtn" button associate with text "Primary Entity Member" on "Groups"
    Then user should see ' Add Group Member ' on 'MemberModal' on 'Groups' page
    When user clicks on "SearchEntity" on "Groups" page
    And user enter "Add Above Member" text in "EntitySearchBox" field on "Groups" page
    And user clicks on "SelectEntityBtn" button associate with text "Add Above Member" on "Groups"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    And user clicks on "SelectItem" button associate with text "Automation Do Not Touch" on "Common"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                    | fieldName     |
      | Add Above Member        | Entity        |
      | Automation Do Not Touch | Business Unit |
    When user clicks on "MemberModalContinueBtn" on "Groups" page
    Then user should able see "AbovePosition" with text "Groups" on "Add Above Member" page
    When user clicks on "AddBelowBtn" button associate with text "Primary Entity Member" on "Groups"
    Then user should see ' Add Group Member ' on 'MemberModal' on 'Groups' page
    When user clicks on "SearchEntity" on "Groups" page
    And user enter "Add Below Member" text in "EntitySearchBox" field on "Groups" page
    And user clicks on "SelectEntityBtn" button associate with text "Add Below Member" on "Groups"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    And user clicks on "SelectItem" button associate with text "Automation Do Not Touch" on "Common"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                    | fieldName     |
      | Add Below Member        | Entity        |
      | Automation Do Not Touch | Business Unit |
    When user clicks on "MemberModalContinueBtn" on "Groups" page
    Then user should able see "BelowPosition" with text "Groups" on "Add Below Member" page
