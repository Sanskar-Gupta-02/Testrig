@CLM @DataFields @Regression
Feature: Data Fields

  Background:
    Given user login into the 'CLM' application with 'AdminUserName' user
    And user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"

  Scenario: 001 Data Fields Page Verification #ENG-T7752,T7755,T8110,T8148,T7747,T7749
    When user clicks on "SideBarMenu" button associate with text "Data Fields" on "Home"
    And user wait from 1 seconds
    Then user should see ' Data Fields ' on 'PageTitle' on 'Common' page
    And user should see the following table columns in "DSTableHeader" on "DSPage" page:
      | Name            |
      | Description     |
      | Storage Type    |
      | Definition Type |
    And the table column "DSDefinationType" on "DSPage" page Should Contain the following values:
      | Inbuilt |
      | Custom  |
    When user clicks on "DSFiltterData" on "DSPage" page
    And user Searches for "Date" on "SearchField" and sees only matching results by Name or Description using "DSTableRowNameForDate" and "DSTableRowDescriptionForDate" inside "DSTableRow" on "DSPage" page
    And user enter "shdfhs3456458s" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    Then the search result count should be "zero" the total count in element "DSFiltterData" on "DSPage" page
    When user enter "" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    And user Clicks View Button for the first "Inbuilt" data type with value "Client Internal Entity ID" in element "DSInbuiltDefinitionType1" and "DSInbuiltViewButton1" on "DSPage" page
    And user wait from 1 seconds
    Then user should able see "InBuiltDataType" on "DSPage" page
    And user should not see "EditButton" on "DSPage" page
    When user clicks on "DataFieldBreadcrumb" button associate with text "Data Fields" on "DSPage"
    And user wait from 1 seconds
    And user Clicks View Button for the first "Custom" data type with value "API Auotomation - List" in element "DSCustomDefinitionType1" and "DSCustomViewButton1" on "DSPage" page
    Then user should able see "EditButton" on "Common" page

  Scenario: 002 String Storage Type Validation #ENG-T7748,T7750,ENG-T8097,T8145,T8144,ENG-T8093,T8094,T8150,T8147,T8164,T8153,T8159,T8158,T8161,T8163,T8151,T10075,T8096,T8152,T8154,T8155
    When user clicks on "SideBarMenu" button associate with text "Data Fields" on "Home"
    And user wait from 1 seconds
    Then user should see ' Data Fields ' on 'PageTitle' on 'Common' page
    When user clicks on "AddBTN" button associate with text "Add" on "DSPage"
    Then user should see ' Details ' on 'PageHeader' on 'DSPage' page
    And user should see "Name" on "DSNameField" on "DSPage" page
    When user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Name is required.         |
      | Storage Type is required. |
    And user should able see "StorageTypeError" on "DSPage" page
    And user should see 'Storage Type is required.' on 'StorageTypeError' on 'DSPage' page
    And user should able see "NameError" on "DSPage" page
    And user should see 'Name is required.' on 'NameError' on 'DSPage' page
    And user should see 'Storage Type is required.' on 'StorageTypeError' on 'DSPage' page
    When user enter "Alexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Franklin Archibald Octavius Montgomery" text in "NameFieldBox" field on "DSPage" page
    Then the length of text entered in field "NameFieldBox" on page "DSPage" should be 150
    When user enter "AutomationDSField" text in "NameFieldBox" field on "DSPage" page
    And user enter "Alexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Franklin Archibald Octavius MontgomeryAlexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Franklin Archibald Octavius MontgomeryAlexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Franklin AAlexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Fr" text in "DescriptionFieldBox" field on "DSPage" page
    Then the length of text entered in field "DescriptionFieldBox" on page "DSPage" should be 500
    When user enter "AutomationDSField" text in "DescriptionFieldBox" field on "DSPage" page
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    And user wait from 1 seconds
    And user enter "Automation String Field" text in "NameFieldBox" field on "DSPage" page
    And user enter "Automation String Field Description" text in "DescriptionFieldBox" field on "DSPage" page
    And user select "String" option in "StorageTypeFieldBox" dropdown on "DSPage" page
    And user wait from 1 seconds
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    And user wait from 1 seconds
    And user waits for "ErrorBoxItems" field on "Common" page to be visible
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Maximum Length is required. |
    And user should see 'Maximum Length is required.' on 'StorageTypeFieldInputError1' on 'DSPage' page
    When user enter "^[a-zA-Z0-9]+$" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user enter "200" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    Then user should see ' Completed ' on 'CompletedPageHeader' on 'DSPage' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                                | fieldName      |
      | Automation String Field             | Name           |
      | Automation String Field Description | Description    |
      | String                              | Storage Type   |
      | ^[a-zA-Z0-9]+$                      | Regex Pattern  |
      |                                 200 | Maximum Length |
    When user clicks on "ContinueButton" on "Common" page
    And user clicks on "DataFieldBreadcrumb" button associate with text "Data Fields" on "DSPage"
    And user wait from 1 seconds
    And user enter "Automation String Field" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    And user Clicks View Button for the first "Custom" data type with value "Automation String Field" in element "DSDefinitionCustomType1" and "DSViewButtonCustom1" on "DSPage" page
    And user clicks on "EditButton" on "Common" page
    Then the field "EditStorageTypeFieldBox" on "DSPage" page should be "disabled"
    When user enter "Product名称更新成功✅用户输入测试用例これはテストですمرحباهذااختبار这是一个测试यह एक परीक्षण है💡🧪✔️Product名称更新成功✅用户输入测试用例これはテストですمرحبا" text in "EditNameFieldBox" field on "DSPage" page
    And user enter "This is a test description to check 500 character limit. 名称更新成功✅これはテストですمرحباهذااختبار这是一个测试यह एक परीक्षण है💡🧪✔️Testing multilingual input with Unicode characters and ensuring the field accepts long text input. 用户输入测试用例更多字符追加して最大限まで試すBonjour! Ceci est un test de champ de description contenant différents caractères et symboles pour vérifier la prise en charge de plusieurs langues. 🌍📘✅끝입니다." text in "EditDescriptionFieldBox" field on "DSPage" page
    And user enter "" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user enter "" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user clicks on "SaveButton" on "DSPage" page
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Maximum Length is required. |
    And user should see 'Maximum Length is required.' on 'StorageTypeFieldInputError1' on 'DSPage' page
    When user enter "^[a-zA-Z0-9]+$" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user enter "200" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user clicks on "SaveButton" on "DSPage" page
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                                                                                                                                                        | fieldName      |
      | Product名称更新成功✅用户输入测试用例これはテストですمرحباهذااختبار这是一个测试यह एक परीक्षण है💡🧪✔️Product名称更新成功✅用户输入测试用例これはテストですمرحبا | Name           |
      | String                                                                                                                                                      | Storage Type   |
      | ^[a-zA-Z0-9]+$                                                                                                                                              | Regex Pattern  |
      |                                                                                                                                                         200 | Maximum Length |
      # | This is a test description to check 500 character limit. 名称更新成功✅これはテストですمرحباهذااختبار这是一个测试यह एक परीक्षण है💡🧪✔️Testing multilingual input with Unicode characters and ensuring the field accepts long text input. 用户输入测试用例更多字符追加して最大限まで試すBonjour! Ceci est un test de champ de description contenant différents caractères et symboles pour vérifier la prise en charge de plusieurs langues. 🌍📘✅끝입니다. | Description    |
    When user clicks on "DataFieldBreadcrumb" button associate with text "Data Fields" on "DSPage"
    And user wait from 1 seconds
    And user enter "Product名称更新成功✅用户输入测试用例これはテストですمرحباهذااختبار这是一个测试यह एक परीक्षण है💡🧪✔️Product名称更新成功✅用户输入测试用例これはテストですمرحبا" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    And user Clicks View Button for the first "Custom" data type with value "Product名称更新成功✅用户输入测试用例これはテストですمرحباهذااختبار这是一个测试यह एक परीक्षण है💡🧪✔️Product名称更新成功✅用户输入测试用例これはテストですمرحبا" in element "DSCustomDefinitionType2" and "DSCustomViewButton2" on "DSPage" page
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                                                                                                                                                        | fieldName |
      | Product名称更新成功✅用户输入测试用例これはテストですمرحباهذااختبار这是一个测试यह एक परीक्षण है💡🧪✔️Product名称更新成功✅用户输入测试用例これはテストですمرحبا | Name      |
    # When user verifies the archive section is collapsed and expands it (Commented this test step as it is not present on the current UI)
    And user clicks on "ArchiveButton" on "Common" page
    Then user should see 'Archive Data Field' on 'ArchiveModalTitle' on 'DSPage' page
    And user should see "To archive the Data Field, enter the name in the box below." on "ArchiveModalDescription" on "DSPage" page
    And user should see "Product名称更新成功✅用户输入测试用例これはテストですمرحباهذااختبار这是一个测试यह एक परीक्षण है💡🧪✔️Product名称更新成功✅用户输入测试用例これはテストですمرحبا" on "ArchiveModalText" on "DSPage" page
    When user enter "xxxsadkjksjdfh" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitButton" on "DSPage" page
    Then user should able see "ErrorBox" on "DSPage" page
    And user should see the following validation errors for field "ArchiveErrorBoxItems" on "DSPage" page:
      | Names must match |
    When user enter "Product名称更新成功✅用户输入测试用例これはテストですمرحباهذااختبار这是一个测试यह एक परीक्षण है💡🧪✔️Product名称更新成功✅用户输入测试用例これはテストですمرحبا" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitButton" on "DSPage" page
    Then user should able see "ArchiveDSText" on "DSPage" page
    And user should see "This item has been archived and cannot be used in the system." on "ArchiveDSWarningMSG" on "DSPage" page

  Scenario: 003 Integer Storage Type Validation #ENG-T8114
    When user clicks on "SideBarMenu" button associate with text "Data Fields" on "Home"
    Then user should see ' Data Fields ' on 'PageTitle' on 'DSPage' page
    When user clicks on "AddBTN" button associate with text "Add" on "DSPage"
    Then user should see ' Details ' on 'PageHeader' on 'DSPage' page
    And user should see "Name" on "DSNameField" on "DSPage" page
    When user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Name is required.         |
      | Storage Type is required. |
    And user should able see "StorageTypeError" on "DSPage" page
    And user should see 'Storage Type is required.' on 'StorageTypeError' on 'DSPage' page
    And user should able see "NameError" on "DSPage" page
    And user should see 'Name is required.' on 'NameError' on 'DSPage' page
    When user enter "Automation Integer Field" text in "NameFieldBox" field on "DSPage" page
    And user enter "Automation Integer Field Description" text in "DescriptionFieldBox" field on "DSPage" page
    And user select "Integer" option in "StorageTypeFieldBox" dropdown on "DSPage" page
    And user wait from 1 seconds
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    And user wait from 1 seconds
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Minimum Value is required. |
      | Maximum Value is required. |
    And user should see 'Minimum Value is required.' on 'StorageTypeFieldInputError1' on 'DSPage' page
    And user should see 'Maximum Value is required.' on 'StorageTypeFieldInputError2' on 'DSPage' page
    When user enter "10" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user enter "500" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    Then user should see ' Completed ' on 'CompletedPageHeader' on 'DSPage' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                                 | fieldName     |
      | Automation Integer Field             | Name          |
      | Automation Integer Field Description | Description   |
      | Integer                              | Storage Type  |
      |                                   10 | Minimum Value |
      |                                  500 | Maximum Value |
    When user clicks on "ContinueButton" on "Common" page
    And user clicks on "DataFieldBreadcrumb" button associate with text "Data Fields" on "DSPage"
    And user enter "Automation Integer Field" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    And user Clicks View Button for the first "Custom" data type with value "Automation Integer Field" in element "DSCustomDefinitionType3" and "DSCustomViewButton3" on "DSPage" page
    And user clicks on "EditButton" on "Common" page
    Then user should able see "CancelButton" on "DSPage" page
    And user should not see "EditButton" on "DSPage" page
    When user clicks on "CancelButton" on "DSPage" page
    Then user should able see "EditButton" on "Common" page
    When user clicks on "EditButton" on "Common" page
    Then the field "EditStorageTypeFieldBox" on "DSPage" page should be "disabled"
    When user enter "Automation Updated" text in "EditNameFieldBox" field on "DSPage" page
    And user enter "" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user enter "" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user clicks on "SaveButton" on "DSPage" page
    And user wait from 1 seconds
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Minimum Value is required. |
      | Maximum Value is required. |
    And user should see 'Minimum Value is required.' on 'StorageTypeFieldInputError1' on 'DSPage' page
    And user should see 'Maximum Value is required.' on 'StorageTypeFieldInputError2' on 'DSPage' page
    When user enter "10" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user enter "500" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user clicks on "SaveButton" on "DSPage" page
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text               | fieldName     |
      | Automation Updated | Name          |
      | Integer            | Storage Type  |
      |                 10 | Minimum Value |
      |                500 | Maximum Value |
    When user clicks on "DataFieldBreadcrumb" button associate with text "Data Fields" on "DSPage"
    And user enter "Automation Updated" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    And user Clicks View Button for the first "Custom" data type with value "Automation Updated" in element "DSCustomDefinitionType4" and "DSCustomViewButton4" on "DSPage" page
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text               | fieldName |
      | Automation Updated | Name      |
    # When user verifies the archive section is collapsed and expands it (Commented this test step as it is not present on the current UI)
    And user clicks on "ArchiveButton" on "DSPage" page
    Then user should see 'Archive Data Field' on 'ArchiveModalTitle' on 'DSPage' page
    And user should see "To archive the Data Field, enter the name in the box below." on "ArchiveModalDescription" on "DSPage" page
    And user should see "Automation Updated" on "ArchiveModalText" on "DSPage" page
    When user enter "xxxsadkjksjdfh" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitButton" on "DSPage" page
    Then user should able see "ErrorBox" on "DSPage" page
    And user should see the following validation errors for field "ArchiveErrorBoxItems" on "DSPage" page:
      | Names must match |
    When user enter "Automation Updated" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitButton" on "DSPage" page
    Then user should able see "ArchiveDSText" on "DSPage" page
    And user should see "This item has been archived and cannot be used in the system." on "ArchiveDSWarningMSG" on "DSPage" page
    When user clicks on "DataFieldBreadcrumb" button associate with text "Data Fields" on "DSPage"
    And user wait from 1 seconds
    Then the search result count should be "less" the total count in element "DSFiltterData" on "DSPage" page
    And the toggle "ArchivedCheckBox" on "DSPage" page should be "off"
    And user should see " Show Archived " on "ArchiveCheckBoxText" on "DSPage" page
    When user turns on the toggle "ArchivedCheckBox" on "DSPage" page
    Then the search result count should be "equal" the total count in element "DSFiltterData" on "DSPage" page
    When user enter "Automation Updated" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    And user Clicks View Button for the first "Custom" data type with value "Automation Updated" in element "DSCustomDefinitionType5" and "DSCustomViewButton5" on "DSPage" page
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text               | fieldName |
      | Automation Updated | Name      |
    And user should able see "ArchiveDSText" on "DSPage" page
    And user should see "This item has been archived and cannot be used in the system." on "ArchiveDSWarningMSG" on "DSPage" page

  Scenario: 004 Decimal Storage Type Error Validation #ENG-T8113
    When user clicks on "SideBarMenu" button associate with text "Data Fields" on "Home"
    Then user should see ' Data Fields ' on 'PageTitle' on 'DSPage' page
    When user clicks on "AddBTN" button associate with text "Add" on "DSPage"
    Then user should see ' Details ' on 'PageHeader' on 'DSPage' page
    And user should see "Name" on "DSNameField" on "DSPage" page
    When user enter "Automation Decimal Field" text in "NameFieldBox" field on "DSPage" page
    And user enter "Automation Decimal Field Description" text in "DescriptionFieldBox" field on "DSPage" page
    And user select "Decimal" option in "StorageTypeFieldBox" dropdown on "DSPage" page
    And user wait from 1 seconds
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Minimum Value is required. |
      | Maximum Value is required. |
    And user should see 'Minimum Value is required.' on 'StorageTypeFieldInputError1' on 'DSPage' page
    And user should see 'Maximum Value is required.' on 'StorageTypeFieldInputError2' on 'DSPage' page
    When user enter "10" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user enter "500" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    Then user should see ' Completed ' on 'CompletedPageHeader' on 'DSPage' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                                 | fieldName     |
      | Automation Decimal Field             | Name          |
      | Automation Decimal Field Description | Description   |
      | Decimal                              | Storage Type  |
      |                                   10 | Minimum Value |
      |                                  500 | Maximum Value |
    When user clicks on "ContinueButton" on "Common" page
    And user clicks on "DataFieldBreadcrumb" button associate with text "Data Fields" on "DSPage"
    And user enter "Automation Decimal Field" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    And user Clicks View Button for the first "Custom" data type with value "Automation Decimal Field" in element "DSCustomDefinitionType6" and "DSCustomViewButton6" on "DSPage" page
    And user clicks on "EditButton" on "Common" page
    Then the field "EditStorageTypeFieldBox" on "DSPage" page should be "disabled"
    When user enter "" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user enter "" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user clicks on "SaveButton" on "DSPage" page
    And user wait from 1 seconds
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Minimum Value is required. |
      | Maximum Value is required. |
    And user should see 'Minimum Value is required.' on 'StorageTypeFieldInputError1' on 'DSPage' page
    And user should see 'Maximum Value is required.' on 'StorageTypeFieldInputError2' on 'DSPage' page
    When user enter "10" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user enter "500" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user clicks on "SaveButton" on "DSPage" page
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text    | fieldName     |
      | Decimal | Storage Type  |
      |      10 | Minimum Value |
      |     500 | Maximum Value |
    When user clicks on "DataFieldBreadcrumb" button associate with text "Data Fields" on "DSPage"
    And user wait from 1 seconds
    And user enter "Automation Decimal Field" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    And user Clicks View Button for the first "Custom" data type with value "Automation Decimal Field" in element "DSCustomDefinitionType6" and "DSCustomViewButton6" on "DSPage" page
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                     | fieldName |
      | Automation Decimal Field | Name      |
    # When user verifies the archive section is collapsed and expands it (Commented this test step as it is not present on the current UI)
    And user clicks on "ArchiveButton" on "DSPage" page
    Then user should see 'Archive Data Field' on 'ArchiveModalTitle' on 'DSPage' page
    And user should see "To archive the Data Field, enter the name in the box below." on "ArchiveModalDescription" on "DSPage" page
    And user should see "Automation Decimal Field" on "ArchiveModalText" on "DSPage" page
    When user enter "xxxsadkjksjdfh" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitButton" on "DSPage" page
    Then user should able see "ErrorBox" on "DSPage" page
    And user should see the following validation errors for field "ArchiveErrorBoxItems" on "DSPage" page:
      | Names must match |
    When user enter "Automation Decimal Field" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitButton" on "DSPage" page
    Then user should able see "ArchiveDSText" on "DSPage" page
    And user should see "This item has been archived and cannot be used in the system." on "ArchiveDSWarningMSG" on "DSPage" page

  Scenario: 005 Text Storage Type Error Validation #ENG-T8112
    When user clicks on "SideBarMenu" button associate with text "Data Fields" on "Home"
    Then user should see ' Data Fields ' on 'PageTitle' on 'DSPage' page
    When user clicks on "AddBTN" button associate with text "Add" on "DSPage"
    Then user should see ' Details ' on 'PageHeader' on 'DSPage' page
    And user should see "Name" on "DSNameField" on "DSPage" page
    When user enter "Automation Text Field" text in "NameFieldBox" field on "DSPage" page
    And user enter "Automation Text Field Description" text in "DescriptionFieldBox" field on "DSPage" page
    And user select "Text" option in "StorageTypeFieldBox" dropdown on "DSPage" page
    When user clicks on "AddBtn" on "Common" page
    And user wait from 2 seconds
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Maximum Length is required. |
    And user should see 'Maximum Length is required.' on 'StorageTypeFieldInputError1' on 'DSPage' page
    When user enter "^[a-zA-Z0-9]+$" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user enter "200" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    Then user should see ' Completed ' on 'CompletedPageHeader' on 'DSPage' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                              | fieldName      |
      | Automation Text Field             | Name           |
      | Automation Text Field Description | Description    |
      | Text                              | Storage Type   |
      | ^[a-zA-Z0-9]+$                    | Regex Pattern  |
      |                               200 | Maximum Length |
    When user clicks on "ContinueButton" on "Common" page
    And user clicks on "DataFieldBreadcrumb" button associate with text "Data Fields" on "DSPage"
    And user wait from 1 seconds
    And user enter "Automation Text Field" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    And user Clicks View Button for the first "Custom" data type with value "Automation Text Field" in element "DSCustomDefinitionType7" and "DSCustomViewButton7" on "DSPage" page
    And user clicks on "EditButton" on "Common" page
    Then the field "EditStorageTypeFieldBox" on "DSPage" page should be "disabled"
    When user enter "" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user enter "" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user clicks on "SaveButton" on "DSPage" page
    And user wait from 1 seconds
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Maximum Length is required. |
    And user should see 'Maximum Length is required.' on 'StorageTypeFieldInputError1' on 'DSPage' page
    When user enter "^[a-zA-Z0-9]+$" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user enter "200" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user clicks on "SaveButton" on "DSPage" page
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text           | fieldName      |
      | Text           | Storage Type   |
      | ^[a-zA-Z0-9]+$ | Regex Pattern  |
      |            200 | Maximum Length |
    When user clicks on "DataFieldBreadcrumb" button associate with text "Data Fields" on "DSPage"
    And user enter "Automation Text Field" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    And user Clicks View Button for the first "Custom" data type with value "Automation Text Field" in element "DSCustomDefinitionType7" and "DSCustomViewButton7" on "DSPage" page
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                  | fieldName |
      | Automation Text Field | Name      |
    # When user verifies the archive section is collapsed and expands it (Commented this test step as it is not present on the current UI)
    And user clicks on "ArchiveButton" on "DSPage" page
    Then user should see 'Archive Data Field' on 'ArchiveModalTitle' on 'DSPage' page
    And user should see "To archive the Data Field, enter the name in the box below." on "ArchiveModalDescription" on "DSPage" page
    And user should see "Automation Text Field" on "ArchiveModalText" on "DSPage" page
    When user enter "xxxsadkjksjdfh" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitButton" on "DSPage" page
    Then user should able see "ErrorBox" on "DSPage" page
    And user should see the following validation errors for field "ArchiveErrorBoxItems" on "DSPage" page:
      | Names must match |
    When user enter "Automation Text Field" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitButton" on "DSPage" page
    Then user should able see "ArchiveDSText" on "DSPage" page
    And user should see "This item has been archived and cannot be used in the system." on "ArchiveDSWarningMSG" on "DSPage" page

  Scenario: 006 Date Storage Type Error Validation #ENG-T8115
    When user clicks on "SideBarMenu" button associate with text "Data Fields" on "Home"
    Then user should see ' Data Fields ' on 'PageTitle' on 'DSPage' page
    When user clicks on "AddBTN" button associate with text "Add" on "DSPage"
    Then user should see ' Details ' on 'PageHeader' on 'DSPage' page
    And user should see "Name" on "DSNameField" on "DSPage" page
    When user enter "Automation Date Field" text in "NameFieldBox" field on "DSPage" page
    And user enter "Automation Date Field Description" text in "DescriptionFieldBox" field on "DSPage" page
    And user select "Date" option in "StorageTypeFieldBox" dropdown on "DSPage" page
    And user wait from 1 seconds
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    And user wait from 2 seconds
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Maximum Value is required. |
      | Minimum Value is required. |
    And user should see 'Minimum Value is required.' on 'StorageTypeFieldInputError1' on 'DSPage' page
    And user should see 'Maximum Value is required.' on 'StorageTypeFieldInputError2' on 'DSPage' page
    When user clicks on "StorageTypeFieldInput1" on "DSPage" page
    And user wait from 1 seconds
    And user enter Date "2026-07-15" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user wait from 1 seconds
    And user enter Date "2027-07-15" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user wait from 1 seconds
    When user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    Then user should see ' Completed ' on 'CompletedPageHeader' on 'DSPage' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                              | fieldName     |
      | Automation Date Field             | Name          |
      | Automation Date Field Description | Description   |
      | Date                              | Storage Type  |
      | 15/07/2027                        | Maximum Value |
      | 15/07/2026                        | Minimum Value |
    When user clicks on "ContinueButton" on "Common" page
    And user clicks on "DataFieldBreadcrumb" button associate with text "Data Fields" on "DSPage"
    And user enter "Automation Date Field" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    And user Clicks View Button for the first "Custom" data type with value "Automation Date Field" in element "DSCustomDefinitionType8" and "DSCustomViewButton8" on "DSPage" page
    And user clicks on "EditButton" on "Common" page
    Then user should able see "CancelButton" on "DSPage" page
    And user should not see "EditBTN" on "Common" page
    When user clicks on "CancelButton" on "DSPage" page
    Then user should able see "EditButton" on "Common" page
    When user clicks on "EditButton" on "Common" page
    Then the field "EditStorageTypeFieldBox" on "DSPage" page should be "disabled"
    When user clicks on "StorageTypeFieldInput1" on "DSPage" page
    And user enter Date "" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user wait from 1 seconds
    And user enter Date "" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user clicks on "SaveButton" on "DSPage" page
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Maximum Value is required. |
      | Minimum Value is required. |
    And user should see 'Minimum Value is required.' on 'StorageTypeFieldInputError1' on 'DSPage' page
    And user should see 'Maximum Value is required.' on 'StorageTypeFieldInputError2' on 'DSPage' page
    When user clicks on "StorageTypeFieldInput1" on "DSPage" page
    And user wait from 1 seconds
    And user enter Date "2026-07-15" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user wait from 1 seconds
    And user enter Date "2027-07-15" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user wait from 1 seconds
    And user clicks on "SaveButton" on "DSPage" page
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text       | fieldName     |
      | Date       | Storage Type  |
      | 15/07/2027 | Maximum Value |
      | 15/07/2026 | Minimum Value |
    When user clicks on "DataFieldBreadcrumb" button associate with text "Data Fields" on "DSPage"
    And user wait from 1 seconds
    And user enter "Automation Date Field" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    And user Clicks View Button for the first "Custom" data type with value "Automation Date Field" in element "DSCustomDefinitionType8" and "DSCustomViewButton8" on "DSPage" page
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                  | fieldName |
      | Automation Date Field | Name      |
    # When user verifies the archive section is collapsed and expands it (Commented this test step as it is not present on the current UI)
    And user clicks on "ArchiveButton" on "Common" page
    Then user should see 'Archive Data Field' on 'ArchiveModalTitle' on 'DSPage' page
    And user should see "To archive the Data Field, enter the name in the box below." on "ArchiveModalDescription" on "DSPage" page
    And user should see "Automation Date Field" on "ArchiveModalText" on "DSPage" page
    When user enter "xxxsadkjksjdfh" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitButton" on "DSPage" page
    Then user should able see "ErrorBox" on "DSPage" page
    And user should see the following validation errors for field "ArchiveErrorBoxItems" on "DSPage" page:
      | Names must match |
    When user enter "Automation Date Field" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitButton" on "DSPage" page
    Then user should able see "ArchiveDSText" on "DSPage" page
    And user should see "This item has been archived and cannot be used in the system." on "ArchiveDSWarningMSG" on "DSPage" page

  Scenario: 007 Links Storage Type Error Validation #ENG-T8993,T8980,T8979,T8984,T8987,T8982,T8991,T8990,T7745,T8976
    When user clicks on "SideBarMenu" button associate with text "Data Fields" on "Home"
    Then user should see ' Data Fields ' on 'PageTitle' on 'DSPage' page
    When user clicks on "AddBTN" button associate with text "Add" on "DSPage"
    Then user should see ' Details ' on 'PageHeader' on 'DSPage' page
    And user should see "Name" on "DSNameField" on "DSPage" page
    When user enter "Automation Links Field" text in "NameFieldBox" field on "DSPage" page
    And user enter "Automation Links Field Description" text in "DescriptionFieldBox" field on "DSPage" page
    And user select "Links" option in "StorageTypeFieldBox" dropdown on "DSPage" page
    And user wait from 1 seconds
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    And user wait from 1 seconds
    Then user should see the following validation errors for field "ErrorBoxItems" on "DSPage" page:
      | Domain Matches is required. |
      | Maximum Links is required.  |
    And user should see 'Domain Matches is required.' on 'StorageTypeFieldInputError1' on 'DSPage' page
    And user should see 'Maximum Links is required.' on 'StorageTypeFieldInputError2' on 'DSPage' page
    When user enter "abc.com" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    Then user should see "The field Domain Matches must match the regular expression '^((http|https|ftp|ftps)://[^,]{0,300})+(,(http|https|ftp|ftps)://[^,]{0,300})*$'." on 'StorageTypeFieldInputError1' on 'DSPage' page
    When user enter "https://dev-clm.kyc360.com" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user enter "5" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    Then user should see ' Completed ' on 'CompletedPageHeader' on 'DSPage' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                               | fieldName      |
      | Automation Links Field             | Name           |
      | Automation Links Field Description | Description    |
      | Links                              | Storage Type   |
      | https://dev-clm.kyc360.com         | Domain Matches |
      |                                  5 | Maximum Links  |
    When user clicks on "ContinueButton" on "Common" page
    And user clicks on "DataFieldBreadcrumb" button associate with text "Data Fields" on "DSPage"
    And user enter "Automation Links Field" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    And user Clicks View Button for the first "Custom" data type with value "Automation Links Field" in element "DSCustomDefinitionType8" and "DSCustomViewButton8" on "DSPage" page
    And user clicks on "EditButton" on "Common" page
    Then user should able see "CancelButton" on "DSPage" page
    And user should not see "EditBTN" on "Common" page
    When user clicks on "CancelButton" on "DSPage" page
    Then user should able see "EditButton" on "Common" page
    When user clicks on "EditButton" on "Common" page
    Then the field "EditStorageTypeFieldBox" on "DSPage" page should be "disabled"
    When user enter "" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user enter "" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user clicks on "SaveButton" on "DSPage" page
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Domain Matches is required. |
      | Maximum Links is required.  |
    And user should see 'Domain Matches is required.' on 'StorageTypeFieldInputError1' on 'DSPage' page
    And user should see 'Maximum Links is required.' on 'StorageTypeFieldInputError2' on 'DSPage' page
    When user enter "https://dev-clm.kyc360.com" text in "StorageTypeFieldInput1" field on "DSPage" page
    And user enter "5" text in "StorageTypeFieldInput2" field on "DSPage" page
    And user clicks on "SaveButton" on "DSPage" page
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                       | fieldName      |
      | Links                      | Storage Type   |
      | https://dev-clm.kyc360.com | Domain Matches |
      |                          5 | Maximum Links  |
    When user clicks on "DataFieldBreadcrumb" button associate with text "Data Fields" on "DSPage"
    And user enter "Automation Links Field" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    And user Clicks View Button for the first "Custom" data type with value "Automation Links Field" in element "DSCustomDefinitionType8" and "DSCustomViewButton8" on "DSPage" page
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                   | fieldName |
      | Automation Links Field | Name      |
    # When user verifies the archive section is collapsed and expands it (Commented this test step as it is not present on the current UI)
    And user clicks on "ArchiveButton" on "Common" page
    Then user should see 'Archive Data Field' on 'ArchiveModalTitle' on 'DSPage' page
    And user should see "To archive the Data Field, enter the name in the box below." on "ArchiveModalDescription" on "DSPage" page
    And user should see "Automation Links Field" on "ArchiveModalText" on "DSPage" page
    When user enter "xxxsadkjksjdfh" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitButton" on "DSPage" page
    Then user should able see "ErrorBox" on "DSPage" page
    And user should see the following validation errors for field "ArchiveErrorBoxItems" on "DSPage" page:
      | Names must match |
    When user enter "Automation Links Field" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitButton" on "DSPage" page
    Then user should able see "ArchiveDSText" on "DSPage" page
    And user should see "This item has been archived and cannot be used in the system." on "ArchiveDSWarningMSG" on "DSPage" page

  Scenario: 008 Boolean Storage Type Error Validation #ENG-T8118
    When user clicks on "SideBarMenu" button associate with text "Data Fields" on "Home"
    Then user should see ' Data Fields ' on 'PageTitle' on 'DSPage' page
    When user clicks on "AddBTN" button associate with text "Add" on "DSPage"
    Then user should see ' Details ' on 'PageHeader' on 'DSPage' page
    And user should see "Name" on "DSNameField" on "DSPage" page
    When user enter "Automation Boolean Field" text in "NameFieldBox" field on "DSPage" page
    And user enter "Automation Boolean Field Description" text in "DescriptionFieldBox" field on "DSPage" page
    And user select "Boolean" option in "StorageTypeFieldBox" dropdown on "DSPage" page
    And user wait from 1 seconds
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    Then user should see ' Completed ' on 'CompletedPageHeader' on 'DSPage' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                                 | fieldName    |
      | Automation Boolean Field             | Name         |
      | Automation Boolean Field Description | Description  |
      | Boolean                              | Storage Type |
    When user clicks on "ContinueButton" on "Common" page
    And user clicks on "DataFieldBreadcrumb" button associate with text "Data Fields" on "DSPage"
    And user enter "Automation Boolean Field" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    And user Clicks View Button for the first "Custom" data type with value "Automation Boolean Field" in element "DSCustomDefinitionType6" and "DSCustomViewButton6" on "DSPage" page
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                     | fieldName |
      | Automation Boolean Field | Name      |
    # When user verifies the archive section is collapsed and expands it (Commented this test step as it is not present on the current UI)
    And user clicks on "ArchiveButton" on "Common" page
    Then user should see 'Archive Data Field' on 'ArchiveModalTitle' on 'DSPage' page
    And user should see "To archive the Data Field, enter the name in the box below." on "ArchiveModalDescription" on "DSPage" page
    And user should see "Automation Boolean Field" on "ArchiveModalText" on "DSPage" page
    When user enter "xxxsadkjksjdfh" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitButton" on "DSPage" page
    Then user should able see "ErrorBox" on "DSPage" page
    And user should see the following validation errors for field "ArchiveErrorBoxItems" on "DSPage" page:
      | Names must match |
    When user enter "Automation Boolean Field" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitButton" on "DSPage" page
    Then user should able see "ArchiveDSText" on "DSPage" page
    And user should see "This item has been archived and cannot be used in the system." on "ArchiveDSWarningMSG" on "DSPage" page

  Scenario: 009 List Storage Type Error Validation #ENG-T11035
    When user clicks on "SideBarMenu" button associate with text "Data Fields" on "Home"
    Then user should see ' Data Fields ' on 'PageTitle' on 'DSPage' page
    When user clicks on "AddBTN" button associate with text "Add" on "DSPage"
    Then user should see ' Details ' on 'PageHeader' on 'DSPage' page
    And user should see "Name" on "DSNameField" on "DSPage" page
    When user enter "Automation List Field" text in "NameFieldBox" field on "DSPage" page
    And user enter "Automation List Field Description" text in "DescriptionFieldBox" field on "DSPage" page
    And user select "List" option in "StorageTypeFieldBox" dropdown on "DSPage" page
    And user wait from 1 seconds
    And user clicks on "AddDSField" button associate with text "Add" on "DSPage"
    Then user should see ' Completed ' on 'CompletedPageHeader' on 'DSPage' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                              | fieldName    |
      | Automation List Field             | Name         |
      | Automation List Field Description | Description  |
      | List                              | Storage Type |
    When user clicks on "ContinueButton" on "Common" page
    And user clicks on "DataFieldBreadcrumb" button associate with text "Data Fields" on "DSPage"
    And user enter "Automation List Field" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    And user Clicks View Button for the first "Custom" data type with value "Automation List Field" in element "DSCustomDefinitionType6" and "DSCustomViewButton6" on "DSPage" page
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                  | fieldName |
      | Automation List Field | Name      |
    When user adds the following list items on "DSPage" page:
      | name      | key      | nameLocator    | keyLocator    |
      | ItemName1 | ItemKey1 | ListIteamName1 | ListIteamKey1 |
      | ItemName2 | ItemKey2 | ListIteamName2 | ListIteamKey2 |
      | ItemName3 | ItemKey3 | ListIteamName3 | ListIteamKey3 |
    And user clicks on "DataFieldBreadcrumb" button associate with text "Data Fields" on "DSPage"
    And user enter "Automation List Field" text in "SearchField" field on "DSPage" page
    And user press enter
    And user wait from 1 seconds
    And user Clicks View Button for the first "Custom" data type with value "Automation List Field" in element "DSCustomDefinitionType6" and "DSCustomViewButton6" on "DSPage" page
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                  | fieldName |
      | Automation List Field | Name      |
    And user wait from 1 seconds
    And the list hash key "ListTableRowName" value "ListTableRowKey" in row "ListTableRow" on "DSPage" page should contain:
      | Name      | Key      |
      | ItemName1 | itemkey1 |
      | ItemName2 | itemkey2 |
      | ItemName3 | itemkey3 |
    # When user verifies the archive section is collapsed and expands it (Commented this test step as it is not present on the current UI)
    And user clicks on "ArchiveButton" on "Common" page
    Then user should see 'Archive Data Field' on 'ArchiveModalTitle' on 'DSPage' page
    And user should see "To archive the Data Field, enter the name in the box below." on "ArchiveModalDescription" on "DSPage" page
    And user should see "Automation List Field" on "ArchiveModalText" on "DSPage" page
    When user enter "xxxsadkjksjdfh" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitButton" on "DSPage" page
    Then user should able see "ErrorBox" on "DSPage" page
    And user should see the following validation errors for field "ArchiveErrorBoxItems" on "DSPage" page:
      | Names must match |
    When user enter "Automation List Field" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitButton" on "DSPage" page
    Then user should able see "ArchiveDSText" on "DSPage" page
    And user should see "This item has been archived and cannot be used in the system." on "ArchiveDSWarningMSG" on "DSPage" page
