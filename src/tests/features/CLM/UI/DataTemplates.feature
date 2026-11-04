@CLM @DATATEMPLATES @Regression
Feature: Data Templates

  Background:
    Given user login into the 'CLM' application with 'AdminUserName' user

  Scenario: 001 Data Template Page Verification ENG-T8284,T8320
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "Data Templates" on "Home"
    Then user should see ' Data Templates ' on 'PageTitle' on 'DSPage' page
    And user should see the following table columns in "DataTableHeader" on "Common" page:
      | Name            |
      | Description     |
      | Storage Type    |
      | Definition Type |
    And the table column "DataTableDTType" on "DataTemplates" page should contain the following values:
      | Custom  |
      | Inbuilt |
    And the toggle "ArchivedCheckBox" on "Common" page should be "off"
    When user turns on the toggle "ArchivedCheckBox" on "DataTemplates" page
    Then the toggle "ArchivedCheckBox" on "Common" page should be "on"
    When user enter "Updated Automation Data Template" text in "DataTemplateSearchBox" field on "DataTemplates" page
    And user press enter
    And user clicks View button for the first "Custom" data type in element "DataTableCustomDTType1" and "DTTableCustomViewBtn1" on "DataTemplates" page
    Then user should able see "ReactivateButton" on "DataTemplates" page
    And user should able see "ArchiveDSText1" on "DataTemplates" page
    And user should see "This item has been archived and cannot be used in the system." on "ArchiveDSWarningMSG1" on "DataTemplates" page
    When user clicks on "DataTemplateBreadCrumb" button associate with text "Data Templates" on "DSPage"
    Then the toggle "ArchivedCheckBox" on "Common" page should be "off"
    When user searches for "Entity" on "DataTemplateSearchBox" and sees only matching results by Name or Description using "DSTableRowName" and "DSTableRowDescription" inside "DSTableRow" on "DataTemplates" page
    And user enter "shdfhs3456458s" text in "DataTemplateSearchBox" field on "DataTemplates" page
    And user press enter
    Then user should able see "NoTableData" on "DataTemplates" page
    When user enter "" text in "DataTemplateSearchBox" field on "DataTemplates" page
    And user press enter
    And user clicks View button for the first "Inbuilt" data type in element "DataTableInbuiltDTType" and "DTTableInbuiltViewBtn" on "DataTemplates" page
    Then user should able see "DTInbuiltTitle" on "DataTemplates" page
    And user should able see "DTInbuiltDescription" on "DataTemplates" page
    And user should not see "EditBTN" on "Common" page
    And the field "DataTemplateFirstNameField" on "DataTemplates" page should be "readonly"
    And the field "DataTemplateFirstKeyField" on "DataTemplates" page should be "readonly"
    And the field "DataTemplateFirstDescriptionField" on "DataTemplates" page should be "readonly"

  Scenario: 002 Adding Data Template and Verification of All Fields #ENG-T8432,T8433,T8435,T8434,T8298,T8299,T285,T8282,T8288,T8296,T8295,T8294,T8297,T8289,T9820,T8290
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "Data Templates" on "Home"
    Then user should see ' Data Templates ' on 'PageTitle' on 'DSPage' page
    When user clicks on "AddBTN" on "DSPage" page
    Then user should see ' Details ' on 'DataTemplatesPageHeader' on 'DataTemplates' page
    And user should able see "DSNameField" on "DSPage" page
    And user should able see "DSDescriptionField" on "DSPage" page
    And user should able see "IconLable" on "DataTemplates" page
    When user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Icon is required. |
      | Name is required. |
    And user should able see "NameError" on "DSPage" page
    And user should able see "IconFieldError" on "DataTemplates" page
    And user should see 'Name is required.' on 'NameError' on 'DSPage' page
    And user should see 'Icon is required.' on 'IconFieldError' on 'DataTemplates' page
    When user enter "Alexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Franklin Archibald Octavius Montgomery" text in "NameFieldBox" field on "DSPage" page
    Then the length of text entered in field "NameFieldBox" on page "DSPage" should be 150
    When user enter "Automation Test Data Template" text in "NameFieldBox" field on "DSPage" page
    And user enter "Alexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Franklin Archibald Octavius MontgomeryAlexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Franklin Archibald Octavius MontgomeryAlexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Franklin AAlexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Fr" text in "DescriptionFieldBox" field on "DSPage" page
    Then the length of text entered in field "DescriptionFieldBox" on page "DSPage" should be 500
    When user enter "Automation Test Data Template" text in "DescriptionFieldBox" field on "DSPage" page
    And user selects and add Icon
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    Then user should see ' Completed ' on 'DataTemplatesPageHeader' on 'DataTemplates' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                          | fieldName   |
      | Automation Test Data Template | Name        |
      | Automation Test Data Template | Description |
    When user clicks on "ContinueButton" on "Common" page
    Then user should see ' View - Automation Test Data Template ' on 'ViewPageTitle' on 'Common' page
    When user drags element "Description" from "SelectDataField" and drops it on element "selectedOptions" on "DataTemplatesArea" on "DataTemplates" page
    And user enter "FirstDTF" text in "DataTemplateFirstNameField" field on "DataTemplates" page
    And user enter "firstdtf" text in "DataTemplateFirstKeyField" field on "DataTemplates" page
    And user enter "First Data Field" text in "DataTemplateFirstDescriptionInputField" field on "DataTemplates" page
    Then the toggle "DataTemplateFirstRequiredField" on "DataTemplates" page should be "off"
    When user turns on the toggle "TurnOnFirstDTFToggleButton" on "DataTemplates" page
    And user clicks on "SaveDataTemplateButton" on "DataTemplates" page
    Then user should not see "ErrorBox" on "DSPage" page
    And the field "DataTemplateFirstKeyField" on "DataTemplates" page should be "readonly"
    And the toggle "TurnOnFirstDTFToggleButton" on "DataTemplates" page should be "on"
    When user drags element "Currency" from "SelectDataField" and drops it on element "selectedOptions" on "DataTemplatesArea" on "DataTemplates" page
    Then user should able see "DataTemplateSecondNameField" on "DataTemplates" page
    When user enter "SecondDTF" text in "DataTemplateSecondNameField" field on "DataTemplates" page
    And user enter "firstdtf" text in "DataTemplateSecondKeyField" field on "DataTemplates" page
    And user clicks on "SaveDataTemplateButton" on "DataTemplates" page
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Item FirstDTF has duplicate key firstdtf.  |
      | Item SecondDTF has duplicate key firstdtf. |
    And user should able see "DataTemplateFirstKeyFieldErrorMsg" on "DataTemplates" page
    And user should able see "DataTemplateSecondKeyFieldErrorMsg" on "DataTemplates" page
    When user enter "seconddtf" text in "DataTemplateSecondKeyField" field on "DataTemplates" page
    And user clicks on "SaveDataTemplateButton" on "DataTemplates" page
    Then user should not see "ErrorBox" on "DSPage" page
    And the field "DataTemplateFirstKeyField" on "DataTemplates" page should be "readonly"
    And the field "DataTemplateSecondKeyField" on "DataTemplates" page should be "readonly"
    And the list  "DataTemplateFieldGivenName" on "DataTemplates" page should have the following values in order:
      | FirstDTF  |
      | SecondDTF |
    When user drags element "Company Name" from "SelectDataField" and drops it on element "Form_Fields_0__Form_Name" on "DataTemplateFirstNameDropField" on "DataTemplates" page
    Then user should able see "DataTemplateFirstNameField" on "DataTemplates" page
    When user enter "ThirdDTF" text in "DataTemplateFirstNameField" field on "DataTemplates" page
    And user enter "thirddtf" text in "DataTemplateFirstKeyField" field on "DataTemplates" page
    And user clicks on "SaveDataTemplateButton" on "DataTemplates" page
    Then user should not see "ErrorBox" on "DSPage" page
    And the field "DataTemplateFirstKeyField" on "DataTemplates" page should be "readonly"
    And the field "DataTemplateSecondKeyField" on "DataTemplates" page should be "readonly"
    And the field "DataTemplateThirdKeyField" on "DataTemplates" page should be "readonly"
    And the list  "DataTemplateFieldGivenName" on "DataTemplates" page should have the following values in order:
      | ThirdDTF  |
      | FirstDTF  |
      | SecondDTF |
    When user clicks on "SelectDataFieldBtn" button associate with text "Email Address" on "DataTemplates"
    Then user should able see "DataTemplateFourthNameField" on "DataTemplates" page
    And the list  "DataTemplateFieldName" on "DataTemplates" page should have the following values in order:
      | ThirdDTF      |
      | FirstDTF      |
      | SecondDTF     |
      | Email Address |
    When user clicks on "DataTemplateFieldDeleteBtn" button associate with text "Email Address" on "DataTemplates"
    Then user should able see "DataTemplateFieldDeleteMSG" on "DataTemplates" page
    When user clicks on "DataTemplateFieldDeleteConfirmBTN" on "DataTemplates" page
    Then the list  "DataTemplateFieldName" on "DataTemplates" page should have the following values in order:
      | ThirdDTF  |
      | FirstDTF  |
      | SecondDTF |
    And the field "DataTemplateFlageBox" on "DataTemplates" page should be "hidden"
    When user clicks on "DataTemplateSavedFieldDeleteBtn" on "DataTemplates" page
    Then user should able see "DataTemplateFieldDeleteMSG" on "DataTemplates" page
    When user clicks on "DataTemplateFieldDeleteConfirmBTN" on "DataTemplates" page
    Then user should able see "DataTemplateFieldFlagTitle" with text "DataTemplates" on "Flagged for Archiving" page
    And user should able see "DataTemplateFieldFlagMSG" with text "DataTemplates" on "Archiving this field will only take effect when the Data Structures that uses this Data Template are published." page
    When user clicks on "SaveDataTemplateButton" on "DataTemplates" page
    Then user should able see "DataTemplateFieldFlagTitle" with text "DataTemplates" on "Field Archived" page
    And user should able see "DataTemplateFieldFlagMSG" with text "DataTemplates" on "Archiving this field will only take effect when the Data Structures that uses this Data Template are published." page
    And the field "DataTemplateFlageBox" on "DataTemplates" page should be "Not Hidden"
    And the list  "DataTemplateFieldName" on "DataTemplates" page should have the following values in order:
      | ThirdDTF  |
      | FirstDTF  |
      | SecondDTF |
    When user clicks on "UndoButton" button associate with text "Undo" on "Common"
    Then the field "DataTemplateFlageBox" on "DataTemplates" page should be "hidden"
    When user clicks on "SaveDataTemplateButton" on "DataTemplates" page
    Then the list  "DataTemplateFieldName" on "DataTemplates" page should have the following values in order:
      | ThirdDTF  |
      | FirstDTF  |
      | SecondDTF |
    # When user verifies the archive section is collapsed and expands it (Commented out this test step as the Archive section is no longer available in the current UI implementation)
    And user clicks on "ArchiveButton" on "DSPage" page
    Then user should see 'Archive Data Template' on 'ArchiveModalTitle' on 'DataTemplates' page
    And user should see "To archive the Data Template, enter the name in the box below." on "ArchiveModalDescription" on "Common" page
    And user should see "Automation Test Data Template" on "ArchiveModalText" on "Common" page
    When user enter "xxxsadkjksjdfh" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalOkButton" on "DataTemplates" page
    Then user should able see "ErrorBox" on "DSPage" page
    And user should see the following validation errors for field "ArchiveErrorBoxItems" on "DSPage" page:
      | Names must match |
    When user enter "Automation Test Data Template" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalOkButton" on "DataTemplates" page
    Then user should able see "ArchiveDSText1" on "DataTemplates" page
    And user should see "This item has been archived and cannot be used in the system." on "ArchiveDSWarningMSG1" on "DataTemplates" page

  Scenario: 003 Data Template Edit Fields Page Verification #ENG-T8283,T8290,T8292,T8285,T8291,T8318
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "Data Templates" on "Home"
    Then user should see ' Data Templates ' on 'PageTitle' on 'DSPage' page
    When user clicks on "AddBTN" on "DSPage" page
    Then user should see ' Details ' on 'DataTemplatesPageHeader' on 'DataTemplates' page
    And user should able see "DSNameField" on "DSPage" page
    And user should able see "DSDescriptionField" on "DSPage" page
    And user should able see "IconLable" on "DataTemplates" page
    When user enter "Automation Update Test Data Template" text in "NameFieldBox" field on "DSPage" page
    And user enter "Automation Update Test Data Template" text in "DescriptionFieldBox" field on "DSPage" page
    And user selects and add Icon
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    Then user should see ' Completed ' on 'DataTemplatesPageHeader' on 'DataTemplates' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                                 | fieldName   |
      | Automation Update Test Data Template | Name        |
      | Automation Update Test Data Template | Description |
    When user clicks on "ContinueButton" on "Common" page
    Then user should see ' View - Automation Update Test Data Template ' on 'ViewPageTitle' on 'Common' page
    And user should see " Template Designer " on "DataTemplateAreaTitle" on "DataTemplates" page
    When user clicks on "UsageTab" button associate with text "Usage" on "DataTemplates"
    Then user should see "  Usage " on "DataTemplateAreaUsagesTitle" on "DataTemplates" page
    And user should see " The data template is not associated with any data structure " on "DataTemplateUsageWarning" on "DataTemplates" page
    When user clicks on "TemplateDesignerTab" button associate with text "Template Designer" on "DataTemplates"
    Then user should see " Template Designer " on "DataTemplateAreaTitle" on "DataTemplates" page
    When user drags element "Description" from "SelectDataField" and drops it on element "selectedOptions" on "DataTemplatesArea" on "DataTemplates" page
    Then user should able see "DataTemplateFirstNameField" on "DataTemplates" page
    When user enter "FirstDTF" text in "DataTemplateFirstNameField" field on "DataTemplates" page
    And user enter "firstdtf" text in "DataTemplateFirstKeyField" field on "DataTemplates" page
    And user enter "First Data Field" text in "DataTemplateFirstDescriptionInputField" field on "DataTemplates" page
    Then the toggle "DataTemplateFirstRequiredField" on "DataTemplates" page should be "off"
    When user turns on the toggle "TurnOnFirstDTFToggleButton" on "DataTemplates" page
    And user clicks on "SaveDataTemplateButton" on "DataTemplates" page
    Then the field "DataTemplateFirstKeyField" on "DataTemplates" page should be "readonly"
    And the toggle "ArchivedCheckBox" on "Common" page should be "on"
    When user clicks on "DataTemplateBackBTN" on "DataTemplates" page
    Then user should see ' Data Templates ' on 'PageTitle' on 'DSPage' page
    When user searches for "Automation Update Test Data Template" on "DataTemplateSearchBox" and sees only matching results by Name or Description using "DataFeildName" and "DataFeildDescription" inside "DataFeildConatiner" on "DataTemplates" page
    And user clicks View button for the first "Custom" data type in element "DataTableCustomDTType2" and "DTTableCustomViewBtn2" on "DataTemplates" page
    Then user should see ' View - Automation Update Test Data Template ' on 'ViewPageTitle' on 'Common' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                                 | fieldName   |
      | Automation Update Test Data Template | Name        |
      | Automation Update Test Data Template | Description |
    And user should see "FirstDTF" value in "DataTemplateFirstNameField" field on the "DataTemplates" page
    And user should see "firstdtf" value in "DataTemplateFirstKeyField" field on the "DataTemplates" page
    And the field "DataTemplateFirstKeyField" on "DataTemplates" page should be "readonly"
    And the toggle "ArchivedCheckBox" on "Common" page should be "on"
    When user clicks on "EditBTN" on "Common" page
    Then user should see ' Edit: Automation Update Test Data Template ' on 'PageHeader' on 'DataTemplates' page
    When user enter "" text in "NameInputBox" field on "Common" page
    And user clicks on "SaveBTN" on "Common" page
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Name is required. |
    When user clicks on "CancelBtn" on "Common" page
    Then user should see ' View - Automation Update Test Data Template ' on 'ViewPageTitle' on 'Common' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                                 | fieldName   |
      | Automation Update Test Data Template | Name        |
      | Automation Update Test Data Template | Description |
    When user clicks on "EditBTN" on "Common" page
    Then user should see ' Edit: Automation Update Test Data Template ' on 'PageHeader' on 'DataTemplates' page
    When user enter "Updated Automation Data Template" text in "NameInputBox" field on "Common" page
    And user enter "Updated Automation Data Template" text in "DescriptionInputBox" field on "Common" page
    And user clicks on "SaveBTN" on "Common" page
    Then user should see ' View - Updated Automation Data Template ' on 'ViewPageTitle' on 'Common' page
    When user clicks on "DataTemplateBackBTN" on "DataTemplates" page
    Then user should see ' Data Templates ' on 'PageTitle' on 'DSPage' page
    When user searches for "Updated Automation Data Template" on "DataTemplateSearchBox" and sees only matching results by Name or Description using "DataFeildName" and "DataFeildDescription" inside "DataFeildConatiner" on "DataTemplates" page
    And user clicks View button for the first "Custom" data type in element "DataTableCustomDTType3" and "DTTableCustomViewBtn3" on "DataTemplates" page
    Then user should see ' View - Updated Automation Data Template ' on 'ViewPageTitle' on 'Common' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                             | fieldName   |
      | Updated Automation Data Template | Name        |
      | Updated Automation Data Template | Description |
    When user clicks on "SelectDataFieldBtn" button associate with text "Email Address" on "DataTemplates"
    And user wait from 1 seconds
    Then user should able see "DataTemplateSecondNameField" on "DataTemplates" page
    And the list  "DataTemplateFieldName" on "DataTemplates" page should have the following values in order:
      | FirstDTF      |
      | Email Address |
    When user clicks on "SaveDataTemplateButton" on "DataTemplates" page
    And user wait from 1 seconds
    And user clicks on "SelectDataFieldBtn" button associate with text "Description" on "DataTemplates"
    And user wait from 1 seconds
    Then user should able see "DataTemplateThirdNameField" on "DataTemplates" page
    And the list  "DataTemplateFieldName" on "DataTemplates" page should have the following values in order:
      | FirstDTF      |
      | Email Address |
      | Description   |
    When user clicks on "SaveDataTemplateButton" on "DataTemplates" page
    Then the list  "DataTemplateFieldName" on "DataTemplates" page should have the following values in order:
      | FirstDTF      |
      | Email Address |
      | Description   |
    When user clicks on "DataTemplateBackBTN" on "DataTemplates" page
    Then user should see ' Data Templates ' on 'PageTitle' on 'DSPage' page
    When user searches for "Updated Automation Data Template" on "DataTemplateSearchBox" and sees only matching results by Name or Description using "DataFeildName" and "DataFeildDescription" inside "DataFeildConatiner" on "DataTemplates" page
    And user clicks View button for the first "Custom" data type in element "DataTableCustomDTType3" and "DTTableCustomViewBtn3" on "DataTemplates" page
    Then user should see ' View - Updated Automation Data Template ' on 'ViewPageTitle' on 'Common' page
    # When user verifies the archive section is collapsed and expands it (Commented out this test step as the Archive section is no longer available in the current UI implementation)
    And user clicks on "ArchiveButton" on "DSPage" page
    Then user should see 'Archive Data Template' on 'ArchiveModalTitle' on 'DataTemplates' page
    And user should see "To archive the Data Template, enter the name in the box below." on "ArchiveModalDescription" on "Common" page
    And user should see "Updated Automation Data Template" on "ArchiveModalText" on "Common" page
    When user enter "xxxsadkjksjdfh" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalOkButton" on "DataTemplates" page
    Then user should able see "ErrorBox" on "DSPage" page
    And user should see the following validation errors for field "ArchiveErrorBoxItems" on "DSPage" page:
      | Names must match |
    When user enter "Updated Automation Data Template" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalOkButton" on "DataTemplates" page
    Then user should able see "ArchiveDSText1" on "DataTemplates" page
    And user should see "This item has been archived and cannot be used in the system." on "ArchiveDSWarningMSG1" on "DataTemplates" page
