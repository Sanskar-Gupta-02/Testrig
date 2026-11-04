@CLM @EntityRelationShips @Regression
Feature: Entity Relationships

  Background:
    Given user login into the 'CLM' application with 'AdminUserName' user
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "Entities" on "Home"
    Then user should see ' Entities ' on 'PageHeaderTitle' on 'DSPage' page

  @Smoke
  Scenario: 001 Navigation to Add Relationship workflow from Relationship tab on Entity Landing Page. #ENG-T9174,T10767,T10766
    When user enter "Workflow Pane - Do Not Touch" text in "EntitySearchBox" field on "Entities" page
    And user press enter
    And user clicks on "EntityViewBtn" button associate with text "Workflow Pane - Do Not Touch" on "RiskOverRide"
    Then user should see ' Workflow Pane - Do Not Touch ' on 'PageHeaderTitle' on 'Common' page
    When user clicks on "EntityRelationshipTab" on "Entities" page
    And user clicks on "AddRelationshipBtn" on "EntityRelationships" page
    Then user should see ' Relationship Type ' on 'SidePanelTitle' on 'EntityRelationships' page
    And user should see 'Entity Relationships - Add' on 'SidePanelTitle' on 'Common' page
    And user should not be able to see "Archived Relationship Type" text using "RelationshipTypeSelectBox" locator on "EntityRelationships" page
    And user clicks on "RealationshipTypeSelectBox" button associate with text "API Automation Do Not Touch" on "EntityRelationships"
    When user clicks on "NextButton" button associate with text "Next" on "Common"
    Then user should see ' Target Entity ' on 'SidePanelTitle' on 'EntityRelationships' page
    When user enter "Entity For Relationship in Group Automation" text in "TargetEntitySearchBox" field on "EntityRelationships" page
    When user clicks on "SelectButton" button associate with text "Entity For Relationship in Group Automation" on "Common"
    And user clicks on "NextButton" button associate with text "Next" on "Common"
    Then user should see ' Relationship Data ' on 'SidePanelTitle' on 'EntityRelationships' page
    When user clicks on "NextButton" button associate with text "Next" on "Common"
    Then user should see ' Shared ' on 'SidePanelTitle' on 'EntityRelationships' page
    Then user should see ' Test Automation ' on 'SharedTitle' on 'EntityRelationships' page

  @Smoke
  Scenario: 002 Verify Source Entity and Target Entity names are shown as clickable links in relationship view #ENG-T9192,T10758
    When user enter "Workflow Pane - Do Not Touch" text in "EntitySearchBox" field on "Entities" page
    And user press enter
    And user clicks on "EntityViewBtn" button associate with text "Workflow Pane - Do Not Touch" on "RiskOverRide"
    And user clicks on "EntityRelationshipTab" on "Entities" page
    And user clicks on "EntityRelationshipViewBtn" button associate with text "Entity For Relationship in Group Automation" on "EntityRelationships"
    Then user should see 'View - Workflow Pane - Do Not Touch - Entity For Relationship in Group Automation' on 'EntityRelationshipNameHeader' on 'EntityRelationships' page
    And user should be able to see 'SourceEntityName' with text 'Workflow Pane - Do Not Touch' on 'EntityRelationships' page
    And user should be able to see 'TargetEntityName' with text 'Entity For Relationship in Group Automation' on 'EntityRelationships' page
    When user clicks on "RelationshipEditBtn" on "EntityRelationships" page
    Then user should able see "StartDateInputText" on "EntityRelationships" page
    And user should able see "EndDateInputText" on "EntityRelationships" page
    When user clicks on "SaveBtn" on "EntityRelationships" page
    And user clicks on "SharedEditBtn" on "EntityRelationships" page
    And user increments value in "EntityBUDataTemplateFirstInputBox4" field on "Entities" page by 1
    And user clicks on "SaveBtn" on "EntityRelationships" page
    When user enter "Test Automation" text in "WorkflowCommentBox" field on "EntityRelationships" page
    And user clicks on "OkButton" on "Common" page
    And user clicks on "SourceEntityGoToBtn" button associate with text "Workflow Pane - Do Not Touch" on "EntityRelationships"
    Then user should see ' Workflow Pane - Do Not Touch ' on 'EntityNameHeader' on 'EntityRelationships' page
    When user clicks on "EntityRelationshipTab" on "Entities" page
    And user clicks on "EntityRelationshipViewBtn" button associate with text "Entity For Relationship in Group Automation" on "EntityRelationships"
    And user clicks on "TargetEntityGoToBtn" button associate with text "Entity For Relationship in Group Automation" on "EntityRelationships"
    Then user should see ' Entity For Relationship in Group Automation ' on 'EntityPageTitle' on 'EntityRelationships' page

  @Smoke
  Scenario: 003 Verify the Creation of Entity Relationship Successfully #ENG-T10757
    When user enter "Entity for DF deletion after save and submit" text in "EntitySearchBox" field on "RiskOverRide" page
    And user press enter
    And user clicks on "ViewButton" button associate with text "Entity for DF deletion after save and submit" on "Common"
    And user clicks on "EntityRelationshipTab" on "Entities" page
    And user clicks on "AddRelationshipBtn" on "EntityRelationships" page
    Then user should see 'Entity Relationships - Add' on 'SidePanelTitle' on 'Common' page
    When user clicks on "NextButton" button associate with text "Next" on "Common"
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Relationship Type is required. |
    And user clicks on "RealationshipTypeSelectBox" button associate with text "API Automation Do Not Touch" on "EntityRelationships"
    When user clicks on "NextButton" button associate with text "Next" on "Common"
    And user enter "No such entity" text in "TargetEntitySearchBox" field on "EntityRelationships" page
    And user press enter
    Then user should able see "NoSearchResultsText" on "Common" page
    When user clears "TargetEntitySearchBox" input field on "EntityRelationships" page
    And user enter "Entity for File API Automation" text in "TargetEntitySearchBox" field on "EntityRelationships" page
    And user clicks on "SelectEntityBtn" button associate with text "Entity for File API Automation description - Do Not Touch" on "EntityRelationships"
    And user clicks on "NextButton" button associate with text "Next" on "Common"
    Then user should see ' Relationship Data ' on 'SidePanelTitle' on 'EntityRelationships' page
    When user enters date 2 days before today in "EndDateInput" field on "EntityRelationships" page
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | End date must be after start date. |
    When user enters today date in "EndDateInput" field on "EntityRelationships" page
    And user clears "StartDateInput" input field on "EntityRelationships" page
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Start Date is required. |
    When user enters today date in "StartDateInput" field on "EntityRelationships" page
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see ' Shared ' on 'SidePanelTitle' on 'EntityRelationships' page
    When user enter "50" text in "EntityBUDataTemplateFirstInputBox4" field on "Entities" page
    And user clicks on "AddBtn" button associate with text "Add" on "EntityRelationships"
    Then user should see ' Completed ' on 'CompletedPageHeader' on 'EntityRelationships' page
    # When user clicks on "ContinueBtn" on "Common" page (commented out because the archive option is not available for the created entity relationship.)