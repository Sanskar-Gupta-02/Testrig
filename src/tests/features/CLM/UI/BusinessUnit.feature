@CLM @BusinessUnit @Regression
Feature: BusinessUnit

  Background:
    Given user login into the 'CLM' application with 'AdminUserName' user
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "Business Units" on "Home"

  @Smoke @Test
  Scenario: 001 Business Unit and Business Group for Verification #ENG-T7845,T7847,T7853,T8665,T7850,T13014
    Then user should see ' Business Units ' on 'PageTitle' on 'DSPage' page
    When user clicks on "AddBTN" on "DSPage" page
    And user clicks on "AddBtn" on "BusinessUnit" page
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Name is required. |
      | Icon is required. |
    And user should able see "NameError" on "DSPage" page
    And user should able see "IconFieldError" on "DataTemplates" page
    And user should see 'Name is required.' on 'NameError' on 'DSPage' page
    And user should see 'Icon is required.' on 'IconFieldError' on 'DataTemplates' page
    When user enter "Test Business Unit" text in "NameFieldBox" field on "Common" page
    And user enter "Test Business Unit Description" text in "DescriptionFieldBox" field on "Common" page
    And user selects and add Icon
    And user clicks on "AddBtn" on "BusinessUnit" page
    Then user should see ' Completed ' on 'DataTemplatesPageHeader' on 'DataTemplates' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                           | fieldName   |
      | Test Business Unit             | Name        |
      | Test Business Unit Description | Description |
    When user clicks on "ContinueBtn" button associate with text "Continue" on "BusinessUnit"
    Then user should see ' View - Test Business Unit ' on 'ViewPageTitle' on 'Common' page
    And user should able to see next to fields on "SavedData" on "Common" page:
      | text                           | fieldName   |
      | Test Business Unit             | Name        |
      | Test Business Unit Description | Description |
    #adding Business Group to the Business Unit
    When user clicks on "AddBTN" on "DSPage" page
    And user clicks on "AddBtn" on "BusinessUnit" page
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Name is required. |
      | Icon is required. |
    And user should able see "NameError" on "DSPage" page
    And user should able see "IconFieldError" on "DataTemplates" page
    And user should see 'Name is required.' on 'NameError' on 'DSPage' page
    And user should see 'Icon is required.' on 'IconFieldError' on 'DataTemplates' page
    When user enter "Test Business Group" text in "NameFieldBox" field on "Common" page
    And user enter "Test Business Group Description" text in "DescriptionFieldBox" field on "Common" page
    And user selects and add Icon
    And user clicks on "AddBtn" on "BusinessUnit" page
    Then user should see ' Completed ' on 'DataTemplatesPageHeader' on 'DataTemplates' page
    When user clicks on "ContinueBtn" button associate with text "Continue" on "BusinessUnit"
    And user clicks on "SelectBusinessGroupCard" button associate with text "Test Business Group" on "BusinessUnit"
    And user clicks on "AddBtn" button associate with text "Add" on "Common"
    And user enter "Sajin" text in "SearchOnUsers" field on "BusinessUnit" page
    And user clicks on "AddUserPlusBtn" button associate with text "Sajin J V sajinjanjith." on "BusinessUnit"
    And user wait from 5 seconds
    Then the table column "UserFirstName" on "BusinessUnit" page should contain the following values:
      | Sajin |
    When user clicks on "BUBreadcrumb" button associate with text "Test Business Unit" on "BusinessUnit"
    Then user should see ' View - Test Business Unit ' on 'ViewPageTitle' on 'Common' page
    And user clicks on "ArchiveButton" on "Common" page
    Then user should see 'Archive Business Unit ' on 'ArchiveModalTitle' on 'Common' page
    And user should see ' To archive the Business Unit, enter the name in the box below. ' on 'ArchiveModalDescription' on 'Common' page
    And user should see 'Test Business Unit' on 'ArchiveModalText' on 'Common' page
    When user enter "Test Business Unit" text in "ArchiveModalInputBox" field on "Common" page
    And user clicks on "ArchiveModalSubmitButton" on "Common" page
    Then user should see ' Archived ' on 'ArchiveDSText' on 'Common' page
    And user should see ' This item has been archived and cannot be used in the system. ' on 'ArchiveDSWarningMSG' on 'Common' page

  @Smoke
  Scenario: 002 Search and Click on the Respective BusinessUnit Card Functionality #ENG-T7843,T7844,T7842
    Then user should see ' Business Units ' on 'PageTitle' on 'DSPage' page
    When user searches for "4 eye enable" on "SearchBox" and sees only matching results by Name or Description using "NameInCard" and "DescriptionInCard" inside "BUCard" on "BusinessUnit" page
    And user clicks View button for the first "4 Eye Enable" data type in element "NameInCard" and "ViewBtn" on "BusinessUnit" page
    Then user should see ' View - 4 Eye Enable Automation ' on 'ViewPageTitle' on 'Common' page

  @Smoke
  Scenario: 003 Verify business group displays users tab #ENG-T8651,T8661
    Then user should see ' Business Units ' on 'PageTitle' on 'DSPage' page
    When user searches for "Automation BU for Multiple Users" on "SearchBox" and sees only matching results by Name or Description using "NameInCard" and "DescriptionInCard" inside "BUCard" on "BusinessUnit" page
    And user clicks View button for the first "Automation BU for Multiple" data type in element "NameInCard" and "ViewBtn" on "BusinessUnit" page
    Then user should see ' View - Automation BU for Multiple Users ' on 'ViewPageTitle' on 'Common' page
    When user clicks on "SelectBusinessGroupCard" button associate with text "Default Business Group" on "BusinessUnit"
    And user wait from 3 seconds
    Then the table column "UserFirstName" on "BusinessUnit" page should contain the following values:
      | UserFor     |
      | Integration |
      | Maksim      |
      | Rajat       |
      | Sai         |
      | Christian   |
      | Anastasiya  |
      | Saurav      |
      | Pritee      |
      | Automation  |
      | Mike        |
    When user clicks on "AddUserBtn" on "BusinessUnit" page
    Then table "UsersTableEntries" on "BusinessUnit" page should have at least 5 entries
