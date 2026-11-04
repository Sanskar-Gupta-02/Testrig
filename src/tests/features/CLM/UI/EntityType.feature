@CLM @EntityType @Regression
Feature: Entity Type

  Background:
    Given user login into the 'CLM' application with 'AdminUserName' user
    And user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"

  @Smoke
  Scenario: 001 Display updated description for Data Structure Designer. #ENG-T9859,T8937
    When user navigate to "Data Structure Designer Automation" entity type with "Automation Do Not Touch" selected business unit
    Then user should see 'Add templates to the Data Structure to collect information for this Business Unit. Fields added to the Data Structure can only be read and edited by users who have been granted permission, this can be configured on the Security Permissions Tab.' on 'BUDataStructureDesignerDescription' on 'EntityType' page
    And user should see 'Security Permissions' on 'SecurityPermissionsTab' on "EntityType" page

  @Smoke
  Scenario: 002 Display associated Business Units in Entity Type card. #ENG-T10550,T10551
    When user clicks on "SideBarMenu" button associate with text "Entity Types" on "Home"
    Then user should able to see following Business Units in "Entities Automation 2 - Do Not Touch" Entity Type card:  
      | S  |
      | AT |
      | 4A |
      | DB |
    Then user should able to see "blue" circle around "4A" business unit with title "Automation Do Not Touch - Published" in "Entities Automation 2 - Do Not Touch" Entity Type card

  @Smoke
  Scenario: 003 Display associated Business Units in Entity Type card. #ENG-T10552,T10553,T10582
    When user clicks on "SideBarMenu" button associate with text "Entity Types" on "Home"
    And user enter "Published Unpublished BU" text in "EntityTypeSearchBox" field on "EntityType" page
    Then user should able to see "blue" circle around "AT" business unit with title "Automation Do Not Touch - Published" in "Published Unpublished BU" Entity Type card
    Then user should able to see "orange" circle around "4A" business unit with title "4 Eye Enable Automation - Not Published" in "Published Unpublished BU" Entity Type card
    Then user should able to see following Business Units in "Published Unpublished BU" Entity Type card:
      | AT |
      | 4A |
      | DB |

  @Smoke
  Scenario: 004 Display Business Unit with archived Status #ENG-T10585
    When user clicks on "SideBarMenu" button associate with text "Entity Types" on "Home"
    Then user Should Not See following Business Units in "Archived BU" Entity Type card:
    | EC |
    When user clicks on "ViewButton" button associate with text "Archived BU" on "EntityType"
    Then the table column "EntityTypeArchivedBUTitle" on "EntityType" page Should Contain the following values:
      | Entity Type Archived For Card |

  @Smoke
  Scenario: 005 Display Business Units on Entity Type Card #ENG-T10580
    When user clicks on "SideBarMenu" button associate with text "Entity Types" on "Home"
    Then user Should be able to see following Business Units in "Entity Type For BU Name Validation" Entity Type card:
      | LV O|
    Then user should able to see "blue" circle around "O" business unit with title "OtherBUWith4EyeEnabled - Published" in "Entity Type For BU Name Validation" Entity Type card
    Then user should able to see "orange" circle around "LV" business unit with title "Long Name For Entity Type Card Validation - Not Published" in "Entity Type For BU Name Validation" Entity Type card
    When user clicks on "ViewButton" button associate with text "Entity Type For BU Name Validation" on "EntityType"
    Then the table column "AddedBusinessUnitTitle" on "EntityType" page Should Contain the following values:
    | Long Name For Entity Type Card Validation |
    | OtherBUWith4EyeEnabled                    |

  @Smoke
  Scenario: 006 Verify permission settings are not saved until user clicks save button. #ENG-T8940,T8941,T8939,T8945,T9071,T9103
    When user navigate to "BU Permissions Add New Field Validation" entity type with "Automation Do Not Touch" selected business unit
    And user clicks on "SecurityPermissionsTab" on "EntityType" page
    Then user should able see "OverallPermissionsReadDenyResult" on "EntityType" page
    And user should able see "OverallPermissionsCreateDenyResult" on "EntityType" page
    And user should able see "OverallPermissionsUpdateDenyResult" on "EntityType" page
    And user should able see "OverallPermissionsDeleteDenyResult" on "EntityType" page
    When user clicks on "OverallPermissionsReadInheritInputBox" on "EntityType" page
    And user clicks on "OverallPermissionsCreateInheritInputBox" on "EntityType" page
    And user clicks on "OverallPermissionsUpdateInheritInputBox" on "EntityType" page
    And user clicks on "OverallPermissionsDeleteInheritInputBox" on "EntityType" page
    Then user should able see "OverallPermissionsReadGrantResult" on "EntityType" page
    And user should able see "OverallPermissionsCreateGrantResult" on "EntityType" page
    And user should able see "OverallPermissionsUpdateGrantResult" on "EntityType" page
    And user should able see "OverallPermissionsDeleteGrantResult" on "EntityType" page
    When user clicks on "SaveBtnPermissions" on "EntityType" page
    Then user should able see "PermissionsSavedToastMessage" on "EntityType" page
    When user refresh the page
    Then user should able see "OverallPermissionsReadGrantResult" on "EntityType" page
    And user should able see "OverallPermissionsCreateGrantResult" on "EntityType" page
    And user should able see "OverallPermissionsUpdateGrantResult" on "EntityType" page
    And user should able see "OverallPermissionsDeleteGrantResult" on "EntityType" page
    When user clicks on "OverallPermissionsReadGrantInputBox" on "EntityType" page
    Then user should able see "OverallPermissionsReadDenyResult" on "EntityType" page
    When user refresh the page
    Then user should able see "OverallPermissionsReadGrantResult" on "EntityType" page
    #Data Reverting Steps
    When user clicks on "OverallPermissionsReadGrantInputBox" on "EntityType" page
    And user clicks on "OverallPermissionsCreateGrantInputBox" on "EntityType" page
    And user clicks on "OverallPermissionsUpdateGrantInputBox" on "EntityType" page
    And user clicks on "OverallPermissionsDeleteGrantInputBox" on "EntityType" page
    Then user should able see "OverallPermissionsReadDenyResult" on "EntityType" page
    When user clicks on "OverallPermissionsReadDenyInputBox" on "EntityType" page
    And user clicks on "OverallPermissionsCreateDenyInputBox" on "EntityType" page
    And user clicks on "OverallPermissionsUpdateDenyInputBox" on "EntityType" page
    And user clicks on "OverallPermissionsDeleteDenyInputBox" on "EntityType" page
    And user clicks on "SaveBtnPermissions" on "EntityType" page
    Then user should able see "PermissionsSavedToastMessage" on "EntityType" page
    And user should not see "OverallPermissionsReadGrantResult" on "EntityType" page
    And user should not see "OverallPermissionsCreateGrantResult" on "EntityType" page
    And user should not see "OverallPermissionsUpdateGrantResult" on "EntityType" page
    And user should not see "OverallPermissionsDeleteGrantResult" on "EntityType" page

  @Smoke
  Scenario: 007 Verify dropdowns and table for configuring security permissions. #ENG-T8942,T8943,T8938,T9085,T9101,T9093,T9102
    When user navigate to "BU Permissions Add New Field Validation" entity type with "Automation Do Not Touch" selected business unit
    And user clicks on "SecurityPermissionsTab" on "EntityType" page
    Then user should able see "ConfigurationReadLabel" on "EntityType" page
    And user should able see "ConfigurationCreateLabel" on "EntityType" page
    And user should able see "ConfigurationEditLabel" on "EntityType" page
    And user should able see "ConfigurationDeleteLabel" on "EntityType" page
    And user should able see "ResultsReadLabel" on "EntityType" page
    And user should able see "ResultsCreateLabel" on "EntityType" page
    And user should able see "ResultsEditLabel" on "EntityType" page
    And user should able see "ResultsDeleteLabel" on "EntityType" page
    And user should able see "BUSecurityDropDown" on "EntityType" page
    And user should able see "BUGroupSecurityDropDown" on "EntityType" page
    And user should not see "OverallPermissionsReadGrantResult" on "EntityType" page
    And user should not see "OverallPermissionsCreateGrantResult" on "EntityType" page
    And user should not see "OverallPermissionsUpdateGrantResult" on "EntityType" page
    And user should not see "OverallPermissionsDeleteGrantResult" on "EntityType" page
    When user select "BUFor4EyeSingleInteger" option in "BUSecurityDropDown" dropdown on "EntityType" page
    Then user should be able to see "SelectedBUSecurityTitle" with text "BUFor4EyeSingleInteger - Default Business Group" on "EntityType" page
    And user should be able to see "SelectedBUSecurityDescription" with text "Controls business group read access within an entity type and manages field-level CRUD permissions in data structure" on "EntityType" page
    And user should able see "OverallPermissionsReadGrantResult" on "EntityType" page
    And user should able see "OverallPermissionsCreateGrantResult" on "EntityType" page
    And user should able see "OverallPermissionsUpdateGrantResult" on "EntityType" page
    And user should able see "OverallPermissionsDeleteGrantResult" on "EntityType" page

  @Smoke
  Scenario: 008 Verify Entity Type Card Information Display #ENG-T10583,T10584
    When user clicks on "SideBarMenu" button associate with text "Entity Types" on "Home"
    And user enter "ETWithNoBUAdded" text in "EntityTypeSearchBox" field on "EntityType" page
    Then user should be able to see "EntityTypeCardTitle" with text "ETWithNoBUAdded" on "EntityType" page
    And user should be able to see "EntityTypeCardDescription" with text "Test description for ET with no added BU" on "EntityType" page
    And user Should Not See following Business Units in "ETWithNoBUAdded" Entity Type card:
    | EC |

  @Smoke
  Scenario: 009 Verify Add newly created Business Unit on Entity Types Page. #ENG-T8716,T8997
    When user clicks on "SideBarMenu" button associate with text "Entity Types" on "Home"
    And user clicks on "AddButton" on "Common" page
    And user enter "Test Entity Type" text in "NameFieldBox" field on "Common" page
    And user enter "Test Entity Type Description" text in "DescriptionFieldBox" field on "Common" page
    And user selects and add Icon
    And user clicks on "AddBtn" on "Common" page
    Then user should see ' Completed ' on 'DataTemplatesPageHeader' on 'DataTemplates' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                         | fieldName   |
      | Test Entity Type             | Name        |
      | Test Entity Type Description | Description |
    When user clicks on "ContinueButton" on "Common" page
    Then user should see ' Test Entity Type ' on 'PageTitle' on 'Common' page
    When user clicks on "AddBUBtn" on "EntityType" page
    When user enter "Test Automation BU1" text in "EntityTypeBUAddSearchBox" field on "EntityType" page
    And user clicks on "AddButton" on "Common" page
    And user should be able to see "BUCardTitle" with text "Test Automation BU1 Test" on "EntityType" page
    When user clicks on "BUCardTitle" button associate with text "Test Automation BU1" on "EntityType"
    And user clicks on "EditDataStructureDesignerBtn" on "EntityType" page
    Then user should see 'Add templates to the Data Structure to collect information for this Business Unit. Fields added to the Data Structure can only be read and edited by users who have been granted permission, this can be configured on the Security Permissions Tab.' on 'BUDataStructureDesignerDescription' on 'EntityType' page
    When user clicks on "DataTemplateInDesignerAddBtn" button associate with text "Automation MetaData" on "EntityType"
    Then user should able see "BUDataStructureDesignerTitle" on "EntityType" page
    When user clicks on "SaveDataStructureDesignerBtn" on "EntityType" page
    And user clicks on "BackToEntityTypeBTN" on "EntityType" page
    # And user verifies the archive section is collapsed and expands it (Commented this test step as it is not present on the current UI)
    And user clicks on "ArchiveButton" on "Common" page
    Then user should see 'Test Entity Type' on 'ArchiveModalText' on 'Common' page
    When user enter "Test Entity Type" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "OkButton" on "Common" page
    Then user should see ' Archived ' on 'ArchiveDSText' on 'DSPage' page
    And user should see ' This item has been archived and cannot be used in the system. ' on 'ArchiveDSWarningMSG' on 'DSPage' page
