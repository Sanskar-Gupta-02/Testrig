@CLM @RiskModels @Regression
Feature: Risk Models

  Background:
    Given user login into the 'CLM' application with 'AdminUserName' user
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "Risk Models" on "Home"

  @Smoke
  Scenario: 001 Validating Risk Models Create Update and Archive Workflow #ENG-T9642
    Then user should see ' Risk Models ' on 'PageTitle' on 'RiskModels' page
    When user clicks on "CommonBTN" button associate with text "Add" on "Common"
    Then user should see ' Entity Type ' on 'PageTitle' on 'RiskModels' page
    And user should see 'Risk Model - Add' on 'SidePanelTitle' on 'Common' page
    When user clicks on "SelectItem" button associate with text "API Test Automaion - Do Not Touch" on "Common"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see ' Business Unit ' on 'PageTitle' on 'RiskModels' page
    When user clicks on "SelectItem" button associate with text "Automation Do Not Touch" on "Common"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see ' Details ' on 'PageTitle' on 'RiskModels' page
    And user should able see "NameFieldBoxLabel" on "Common" page
    And user should able see "NameFieldBox" on "Common" page
    And user should able see "DescriptionBoxLabel" on "Common" page
    And user should able see "DescriptionFieldBox" on "Common" page
    And user should able see "RiskTypeDropDownLabel" on "RiskModels" page
    And user should able see "RiskTypeDropDown" on "RiskModels" page
    When user clicks on "AddBtn" on "RiskModels" page
    Then user should able see "ErrorBox" on "Common" page
    And user waits for "ErrorBoxItems" field on "Common" page to be visible
    And user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Name is required.                 |
      | You must select a value for Icon. |
      | Risk Type must be set.            |
    And user should see 'Name is required.' on 'NameFieldError' on 'Common' page
    And user should see 'Risk Type must be set.' on 'RiskTypeDropDownErrorBox' on 'RiskModels' page
    When user enter "Automation Test Risk Model" text in "NameFieldBox" field on "Common" page
    And user enter "Automation Test  Description" text in "DescriptionFieldBox" field on "Common" page
    And user clicks on "AddBtn" on "RiskModels" page
    Then user should able see "ErrorBox" on "Common" page
    And user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Risk Type must be set. |
    And user should see 'Risk Type must be set.' on 'RiskTypeDropDownErrorBox' on 'RiskModels' page
    When user selects value "Weighted Risk" from dropdown "RiskTypeDropDown" on page "RiskModels"
    And user selects and add Icon
    And user clicks on "AddBtn" on "RiskModels" page
    Then user should see ' Completed ' on 'PageTitle' on 'RiskModels' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                              | fieldName     |
      | Automation Test Risk Model        | Name          |
      | Automation Test  Description      | Description   |
      | API Test Automaion - Do Not Touch | Entity Type   |
      | Automation Do Not Touch           | Business Unit |
      | Weighted Risk                     | Risk          |
    When user clicks on "CommonBTN" button associate with text "Continue" on "Common"
    Then user should see ' View - Automation Test Risk Model ' on 'PageTitle' on 'Common' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                              | fieldName     |
      | Automation Test Risk Model        | Name          |
      | Automation Test  Description      | Description   |
      | API Test Automaion - Do Not Touch | Entity Type   |
      | Automation Do Not Touch           | Business Unit |
      | Weighted Risk                     | Risk          |
    When user clicks on "RiskLevelDropDown" on "RiskModels" page
    Then user should see the following table columns in "RiskLevelTableHeader" on "RiskModels" page:
      | Name       |
      | Risk Level |
      | Min. Value |
      | Max. Value |
    And the table column "RiskLevelLabels" on "RiskModels" page should contain the following values:
      | Very High |
      | High      |
      | Medium    |
      | Low       |
    And the table column "RiskLevelMinValue" on "RiskModels" page should contain the following values:
      |  0 |
      | 26 |
      | 51 |
      | 76 |
    And the table column "RiskLevelMaxValue" on "RiskModels" page should contain the following values:
      |  25 |
      |  50 |
      |  75 |
      | 100 |
    When user clicks on "EditBTN" button associate with text "Continue" on "Common"
    Then the field "EditRiskTypeDropDown" on "RiskModels" page should be "disabled"
    When user enter "10" text in "FirstRiskLevelMin" field on "RiskModels" page
    And user enter "20" text in "FirstRiskLevelMax" field on "RiskModels" page
    And user enter "30" text in "SecondRiskLevelMin" field on "RiskModels" page
    And user enter "40" text in "SecondRiskLevelMax" field on "RiskModels" page
    And user enter "50" text in "ThirdRiskLevelMin" field on "RiskModels" page
    And user enter "60" text in "ThirdRiskLevelMax" field on "RiskModels" page
    And user enter "70" text in "FourthRiskLevelMin" field on "RiskModels" page
    And user enter "80" text in "FourthRiskLevelMax" field on "RiskModels" page
    And user clicks on "SaveBTN" button associate with text "Continue" on "Common"
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Risk Level Low: Max Value must be immediately before Risk Level Medium: Min Value.     |
      | Risk Level Medium: Max Value must be immediately before Risk Level High: Min Value.    |
      | Risk Level High: Max Value must be immediately before Risk Level Very High: Min Value. |
    When user enter "10" text in "FirstRiskLevelMin" field on "RiskModels" page
    And user enter "20" text in "FirstRiskLevelMax" field on "RiskModels" page
    And user enter "21" text in "SecondRiskLevelMin" field on "RiskModels" page
    And user enter "40" text in "SecondRiskLevelMax" field on "RiskModels" page
    And user enter "41" text in "ThirdRiskLevelMin" field on "RiskModels" page
    And user enter "60" text in "ThirdRiskLevelMax" field on "RiskModels" page
    And user enter "61" text in "FourthRiskLevelMin" field on "RiskModels" page
    And user enter "80" text in "FourthRiskLevelMax" field on "RiskModels" page
    And user clicks on "SaveBTN" button associate with text "Continue" on "Common"
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                              | fieldName     |
      | Automation Test Risk Model        | Name          |
      | Automation Test  Description      | Description   |
      | API Test Automaion - Do Not Touch | Entity Type   |
      | Automation Do Not Touch           | Business Unit |
      | Weighted Risk                     | Risk          |
    When user clicks on "RiskLevelDropDown" on "RiskModels" page
    Then user should see the following table columns in "RiskLevelTableHeader" on "RiskModels" page:
      | Name       |
      | Risk Level |
      | Min. Value |
      | Max. Value |
    And the table column "RiskLevelLabels" on "RiskModels" page should contain the following values:
      | Very High |
      | High      |
      | Medium    |
      | Low       |
    And the table column "RiskLevelMinValue" on "RiskModels" page should contain the following values:
      | 10 |
      | 21 |
      | 41 |
      | 61 |
    And the table column "RiskLevelMaxValue" on "RiskModels" page should contain the following values:
      | 20 |
      | 40 |
      | 60 |
      | 80 |
    # When user verifies the archive section is collapsed and expands it(Commented out this test step as the Archive section is no longer available in the current UI implementation.)
    And user clicks on "ArchiveButton" on "Common" page
    Then user should able see "ArchiveModalTitle" on "RiskModels" page
    And user should see ' To archive the Risk Model, enter the name in the box below. ' on 'ArchiveModalDescription' on 'RiskModels' page
    And user should see 'Automation Test Risk Model' on 'ArchiveModalText' on 'Common' page
    When user enter "Automation Test Risk Model" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitBtn" on "RiskModels" page
    Then user should see ' Archived ' on 'ArchiveDSText' on 'Common' page
    And user should see ' This item has been archived and cannot be used in the system. ' on 'ArchiveDSWarningMSG' on 'Common' page

  @Smoke
  Scenario: 002 Risk Models Congratulations Verification #ENG-T9576,T9576,T9588,T9578
    Then user should see ' Risk Models ' on 'PageTitle' on 'RiskModels' page
    When user clicks on "CommonBTN" button associate with text "Add" on "Common"
    Then user should see ' Entity Type ' on 'PageTitle' on 'RiskModels' page
    And user should see 'Risk Model - Add' on 'SidePanelTitle' on 'Common' page
    When user clicks on "SelectItem" button associate with text "API Test Automaion - Do Not Touch" on "Common"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see ' Business Unit ' on 'PageTitle' on 'RiskModels' page
    When user clicks on "SelectItem" button associate with text "Automation Do Not Touch" on "Common"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see ' Details ' on 'PageTitle' on 'RiskModels' page
    When user enter "Automation Test" text in "NameFieldBox" field on "Common" page
    And user enter "Automation Test  Description" text in "DescriptionFieldBox" field on "Common" page
    And user selects value "Weighted Risk" from dropdown "RiskTypeDropDown" on page "RiskModels"
    And user selects and add Icon
    And user clicks on "AddBtn" on "RiskModels" page
    Then user should see ' Completed ' on 'PageTitle' on 'RiskModels' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                              | fieldName     |
      | Automation Test                   | Name          |
      | Automation Test  Description      | Description   |
      | API Test Automaion - Do Not Touch | Entity Type   |
      | Automation Do Not Touch           | Business Unit |
      | Weighted Risk                     | Risk          |
    When user clicks on "CommonBTN" button associate with text "Continue" on "Common"
    Then user should see ' View - Automation Test ' on 'PageTitle' on 'Common' page
    When user clicks on "breadcrumb" on "Common" page
    And user enter "Automation Test" text in "RiskModelsSearchBox" field on "RiskModels" page
    And user clicks on "RiskModelViewBTN" button associate with text "Automation Test" on "RiskModels"
    Then user should see ' View - Automation Test ' on 'PageTitle' on 'Common' page
    And user should able see "DraftVersionText" on "Common" page
    And user should able see "NotPublishedText" on "Common" page
    When user clicks on "EditDesignerBtn" on "RiskModels" page
    And user clicks on "RiskGroupAddBtn" on "RiskModels" page
    Then user should see 'Risk Group' on 'RiskGroupBtn' on 'RiskModels' page
    When user drags element "Risk Rule Integer" from "RiskRules" and drops it on element "riskRuleDropContainer" on "RiskGroupOneContainerBox" on "RiskModels" page
    Then user should see "Risk Rule Integer" on "FirstRiskRuleTitle" on "RiskModels" page
    And user should see "Data Structure Field" on "FirstRiskRuleDataStructureLabel" on "RiskModels" page
    And user should see the following table columns in "FirstRiskRuleConditionHeaders" on "RiskModels" page:
      | Operator             |
      | Data Structure Field |
      | Is                   |
      | Value                |
    And user selects value "integer data (Integer)" from dropdown "FirstRiskRuleDataStructureDropDown" on page "RiskModels"
    And user should see the following table columns in "FirstRiskRuleConditionHeaders" on "RiskModels" page:
      | Start Value |
      | End Value   |
      | Risk Value  |
    When user clicks on "CommonBTN" button associate with text "Add Risk Value" on "Common"
    Then user should able see "SecondRiskStartValue" on "RiskModels" page
    When user clicks on "CommonBTN" button associate with text "Add Risk Value" on "Common"
    Then user should able see "ThirdRiskStartValue" on "RiskModels" page
    When user clicks on "SaveDesignerBtn" on "RiskModels" page
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Start Value is required.,End Value is required.,Risk Value is required.,Start Value is required.,End Value is required.,Risk Value is required.,Start Value is required.,End Value is required.,Risk Value is required. |
    When user enter "1" text in "FirstRiskStartValue" field on "RiskModels" page
    And user enter "10" text in "FirstRiskEndValue" field on "RiskModels" page
    And user enter "10" text in "FirstRiskValue" field on "RiskModels" page
    And user enter "11" text in "SecondRiskStartValue" field on "RiskModels" page
    And user enter "20" text in "SecondRiskEndValue" field on "RiskModels" page
    And user enter "20" text in "SecondRiskValue" field on "RiskModels" page
    And user enter "21" text in "ThirdRiskStartValue" field on "RiskModels" page
    And user enter "30" text in "ThirdRiskEndValue" field on "RiskModels" page
    And user enter "30" text in "ThirdRiskValue" field on "RiskModels" page
    And user clicks on "SaveDesignerBtn" on "RiskModels" page
    And user publishes the Risk Model after saving
    Then user should able see "PublishedModal" on "Common" page
    And user should see 'Publish' on 'PublishedModalTitle' on 'Common' page
    And user should see 'Are you sure you want to publish Risk Model ?' on 'PublishedModalDescription' on 'Common' page
    When user clicks on "PublishedModalOkButton" on "Common" page
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    And user should able see "ActiveVersionText" on "Common" page
    When user clicks on "EditDesignerBtn" on "RiskModels" page
    And user clicks on "FirstRiskGroupDeleteBtn" on "RiskModels" page
    And user clicks on "RiskGroupDeleteConfirmBTN" on "RiskModels" page
    Then user should not see "RiskGroupBtn" on "RiskModels" page
    When user clicks on "SaveDesignerBtn" on "RiskModels" page
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    And user should able see "DraftVersionText" on "Common" page
    # When user verifies the archive section is collapsed and expands it(Commented out this test step as the Archive section is no longer available in the current UI implementation.)
    And user clicks on "ArchiveButton" on "Common" page
    Then user should able see "ArchiveModalTitle" on "RiskModels" page
    And user should see ' To archive the Risk Model, enter the name in the box below. ' on 'ArchiveModalDescription' on 'RiskModels' page
    And user should see 'Automation Test' on 'ArchiveModalText' on 'Common' page
    When user enter "Automation Test" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitBtn" on "RiskModels" page
    Then user should see ' Archived ' on 'ArchiveDSText' on 'Common' page
    And user should see ' This item has been archived and cannot be used in the system. ' on 'ArchiveDSWarningMSG' on 'Common' page

  @Smoke
  Scenario: 003 Risk Lists Usages Verification #ENG-T11131
    Then user should see ' Risk Models ' on 'PageTitle' on 'RiskModels' page
    When user clicks on "CommonBTN" button associate with text "Risk Lists" on "Common"
    Then user should see ' Risk Lists ' on 'PageTitle' on 'RiskModels' page
    When user clicks View button for the first "Automation Risk List" data type in element "RiskListsTableNameKey" and "RiskListsTableViewBtn" on "RiskModels" page
    Then user should see ' Automation Risk List ' on 'PageTitle' on 'Common' page
    When user clicks on "CommonBTN" button associate with text "Usage" on "Common"
    And user waits for "RiskListUsageNameKey" field on "RiskModels" page to be visible
    And the table column "RiskListUsageNameKey" on "RiskModels" page should contain the following values:
      | API Automation RT Single Highest Value Risk |
      | API Automation RT Total Risk                |
      | API Automation RT Weighted Risk             |

  @Smoke
  Scenario: 004 Risk Lists Rule Configuration Verification #ENG-T9587
    Then user should see ' Risk Models ' on 'PageTitle' on 'RiskModels' page
    When user enter "Risk Rule Configuration Automation Do Not Touch" text in "RiskModelsSearchBox" field on "RiskModels" page
    And user clicks on "RiskModelViewBTN" button associate with text "Risk Rule Configuration Automation Do Not Touch" on "RiskModels"
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    When user clicks on "EditDesignerBtn" on "RiskModels" page
    Then user should see 'Risk Model Designer' on 'RiskModelDesignerTitle' on 'RiskModels' page
    And user should see 'Add' on 'RiskGroupAddBtn' on 'RiskModels' page
    And user removes the existing Risk Groups in the Risk Model designer if present
    And user clicks on "RiskGroupAddBtn" on "RiskModels" page
    Then user should see 'Risk Group' on 'RiskGroupBtn' on 'RiskModels' page
    When user drags element "Risk Rule List" from "RiskRules" and drops it on element "riskRuleDropContainer" on "RiskGroupOneContainerBox" on "RiskModels" page
    Then user should see "Risk Rule List" on "FirstRiskRuleTitle" on "RiskModels" page
    And user should see the following table columns in "FirstRiskRuleConditionHeaders" on "RiskModels" page:
      | Operator             |
      | Data Structure Field |
      | Is                   |
      | Value                |
    And user should see "Data Structure Field" on "FirstRiskRuleDataStructureLabel" on "RiskModels" page
    When user selects value "list data (List)" from dropdown "FirstRiskRuleDataStructureDropDown" on page "RiskModels"
    Then user should see "Published Risk List (Optional)" on "FirstRiskRulePublishedListLabel" on "RiskModels" page
    And user should see "Weighted Value" on "FirstRiskRuleWeightedLabel" on "RiskModels" page
    And user should see "100" value in "FirstRiskRuleWeightedInputBox" field on "RiskModels" page
    When user clicks on "CommonBTN" button associate with text "Add Condition" on "Common"
    Then user should see " And " on "RiskRuleFirstConditionOperator" on "RiskModels" page
    When user selects value "number (Integer) Archived" from dropdown "RiskRuleFirstConditionOn" on page "RiskModels"
    And user selects value "Less Than ( < )" from dropdown "RiskRuleFirstConditionIs" on page "RiskModels"
    And user enter "50" text in "RiskRuleFirstConditionValue" field on "RiskModels" page
    When user clicks on "SaveDesignerBtn" on "RiskModels" page
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | The selected Data Structure Field is archived and cannot be used. |
    When user clicks on "RiskRuleFirstConditionDelete" on "RiskModels" page
    And user clicks on "RiskGroupDeleteConfirmBTN" on "RiskModels" page
    And user clicks on "CommonBTN" button associate with text "Add Condition" on "Common"
    Then user should see " And " on "RiskRuleFirstConditionOperator" on "RiskModels" page
    When user selects value "integer data (Integer)" from dropdown "RiskRuleFirstConditionOn" on page "RiskModels"
    And user selects value "Less Than ( < )" from dropdown "RiskRuleFirstConditionIs" on page "RiskModels"
    And user enter "50" text in "RiskRuleFirstConditionValue" field on "RiskModels" page
    When user clicks on "SaveDesignerBtn" on "RiskModels" page
    And user publishes the Risk Model after saving
    Then user should able see "PublishedModal" on "Common" page
    When user clicks on "PublishedModalOkButton" on "Common" page
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    And user should able see "ActiveVersionText" on "Common" page
    When user clicks on "EditDesignerBtn" on "RiskModels" page
    And user clicks on "FirstRiskGroupDeleteBtn" on "RiskModels" page
    And user clicks on "RiskGroupDeleteConfirmBTN" on "RiskModels" page
    Then user should not see "RiskGroupBtn" on "RiskModels" page
    When user clicks on "SaveDesignerBtn" on "RiskModels" page
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    And user should able see "DraftVersionText" on "Common" page

  @Smoke
  Scenario: 005 Explicit Risk Rule Configuration Verification #ENG-T9608
    Then user should see ' Risk Models ' on 'PageTitle' on 'RiskModels' page
    When user enter "Explicit Risk Rule Do Not Touch" text in "RiskModelsSearchBox" field on "RiskModels" page
    And user clicks on "RiskModelViewBTN" button associate with text "Explicit Risk Rule Do Not Touch" on "RiskModels"
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    And user clicks on "EditDesignerBtn" on "RiskModels" page
    Then user should see 'Risk Model Designer' on 'RiskModelDesignerTitle' on 'RiskModels' page
    And user should see 'Add' on 'RiskGroupAddBtn' on 'RiskModels' page
    And user removes the existing Risk Groups in the Risk Model designer if present
    When user clicks on "RiskGroupAddBtn" on "RiskModels" page
    Then user should see 'Risk Group' on 'RiskGroupBtn' on 'RiskModels' page
    When user drags element "Risk Rule Explicit" from "RiskRules" and drops it on element "riskRuleDropContainer" on "RiskGroupOneContainerBox" on "RiskModels" page
    Then user should see "Risk Rule Explicit" on "FirstRiskRuleTitle" on "RiskModels" page
    And user should see the following table columns in "FirstRiskRuleConditionHeaders" on "RiskModels" page:
      | Operator             |
      | Data Structure Field |
      | Is                   |
      | Value                |
    And the dropdown "RiskRuleFirstConditionOn" on "RiskModels" page should have the following options:
      | Please select             |
      | boolean data (Boolean)    |
      | date data (Date)          |
      | decimal data (Decimal)    |
      | integer data (Integer)    |
      | list data (List)          |
      | date of birth data (Date) |
      | number (Integer) Archived |
    And user should see "Weighted Value" on "FirstRiskRuleWeightedLabel" on "RiskModels" page
    And user should see "Risk Value" on "RiskRuleRiskValueLabel" on "RiskModels" page
    And user should see "100" value in "FirstRiskRuleWeightedInputBox" field on "RiskModels" page
    And user should see "0" value in "RiskRuleRiskValueInputBox" field on "RiskModels" page
    And user should see " And " on "RiskRuleFirstConditionOperator" on "RiskModels" page
    When user selects value "number (Integer) Archived" from dropdown "RiskRuleFirstConditionOn" on page "RiskModels"
    And user selects risk rule condition value "Less Than ( < )" from dropdown "RiskRuleFirstConditionIs" on page "RiskModels"
    And user enter "50" text in "RiskRuleFirstConditionValue1" field on "RiskModels" page
    And user clicks on "SaveDesignerBtn" on "RiskModels" page
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | The selected Data Structure Field is archived and cannot be used. |
    When user clicks on "RiskRuleFirstConditionDelete" on "RiskModels" page
    And user clicks on "RiskGroupDeleteConfirmBTN" on "RiskModels" page
    And user clicks on "CommonBTN" button associate with text "Add Condition" on "Common"
    Then user should see " And " on "RiskRuleFirstConditionOperator" on "RiskModels" page
    When user selects value "integer data (Integer)" from dropdown "RiskRuleFirstConditionOn" on page "RiskModels"
    And user selects risk rule condition value "Less Than ( < )" from dropdown "RiskRuleFirstConditionIs" on page "RiskModels"
    And user enter "50" text in "RiskRuleFirstConditionValue1" field on "RiskModels" page
    And user clicks on "SaveDesignerBtn" on "RiskModels" page
    And user publishes the Risk Model after saving
    Then user should able see "PublishedModal" on "Common" page
    When user clicks on "PublishedModalOkButton" on "Common" page
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    And user should able see "ActiveVersionText" on "Common" page
    When user clicks on "EditDesignerBtn" on "RiskModels" page
    And user clicks on "FirstRiskGroupDeleteBtn" on "RiskModels" page
    And user clicks on "RiskGroupDeleteConfirmBTN" on "RiskModels" page
    Then user should not see "RiskGroupBtn" on "RiskModels" page
    When user clicks on "SaveDesignerBtn" on "RiskModels" page
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    And user should able see "DraftVersionText" on "Common" page

  @Smoke
  Scenario: 006 Risk Rule Decimal Configuration Verification #ENG-T9606
    Then user should see ' Risk Models ' on 'PageTitle' on 'RiskModels' page
    When user enter "Decimal Risk Rule Configuration Do Not Touch" text in "RiskModelsSearchBox" field on "RiskModels" page
    And user clicks on "RiskModelViewBTN" button associate with text "Decimal Risk Rule Configuration Do Not Touch" on "RiskModels"
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    When user clicks on "EditDesignerBtn" on "RiskModels" page
    Then user should see 'Risk Model Designer' on 'RiskModelDesignerTitle' on 'RiskModels' page
    And user should see 'Add' on 'RiskGroupAddBtn' on 'RiskModels' page
    And user removes the existing Risk Groups in the Risk Model designer if present
    And user clicks on "RiskGroupAddBtn" on "RiskModels" page
    Then user should see 'Risk Group' on 'RiskGroupBtn' on 'RiskModels' page
    When user drags element "Risk Rule Decimal" from "RiskRules" and drops it on element "riskRuleDropContainer" on "RiskGroupOneContainerBox" on "RiskModels" page
    Then user should see "Risk Rule Decimal" on "FirstRiskRuleTitle" on "RiskModels" page
    And user should see the following table columns in "FirstRiskRuleConditionHeaders" on "RiskModels" page:
      | Operator             |
      | Data Structure Field |
      | Is                   |
      | Value                |
    When user clicks on "CommonBTN" button associate with text "Add Condition" on "Common"
    Then the dropdown "RiskRuleFirstConditionOn" on "RiskModels" page should have the following options:
      | Please select             |
      | boolean data (Boolean)    |
      | date data (Date)          |
      | decimal data (Decimal)    |
      | integer data (Integer)    |
      | list data (List)          |
      | date of birth data (Date) |
      | number (Integer) Archived |
    And user should see "Data Structure Field" on "FirstRiskRuleDataStructureLabel" on "RiskModels" page
    When user selects value "decimal data (Decimal)" from dropdown "FirstRiskRuleDataStructureDropDown" on page "RiskModels"
    Then user should see "Weighted Value" on "FirstRiskRuleWeightedLabel" on "RiskModels" page
    And user should see "100" value in "FirstRiskRuleWeightedInputBox" field on "RiskModels" page
    When user enter "1.99" text in "FirstDecimalRiskStartValue" field on "RiskModels" page
    And user enter "100.99" text in "FirstDecimalRiskEndValue" field on "RiskModels" page
    And user enter "100" text in "FirstDecimalRiskValue" field on "RiskModels" page
    Then user should see " And " on "RiskRuleFirstConditionOperator" on "RiskModels" page
    When user selects value "number (Integer) Archived" from dropdown "RiskRuleFirstConditionOn" on page "RiskModels"
    And user selects risk rule condition value "Less Than ( < )" from dropdown "RiskRuleFirstConditionIs" on page "RiskModels"
    And user enter "50" text in "RiskRuleFirstConditionValue1" field on "RiskModels" page
    And user clicks on "SaveDesignerBtn" on "RiskModels" page
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | The selected Data Structure Field is archived and cannot be used. |
    When user clicks on "RiskRuleFirstConditionDelete" on "RiskModels" page
    And user clicks on "RiskGroupDeleteConfirmBTN" on "RiskModels" page
    And user clicks on "CommonBTN" button associate with text "Add Condition" on "Common"
    Then user should see " And " on "RiskRuleFirstConditionOperator" on "RiskModels" page
    When user selects value "integer data (Integer)" from dropdown "RiskRuleFirstConditionOn" on page "RiskModels"
    And user selects risk rule condition value "Less Than ( < )" from dropdown "RiskRuleFirstConditionIs" on page "RiskModels"
    And user clicks on "SaveDesignerBtn" on "RiskModels" page
    And user publishes the Risk Model after saving
    Then user should able see "PublishedModal" on "Common" page
    When user clicks on "PublishedModalOkButton" on "Common" page
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    And user should able see "ActiveVersionText" on "Common" page
    When user clicks on "EditDesignerBtn" on "RiskModels" page
    And user clicks on "FirstRiskGroupDeleteBtn" on "RiskModels" page
    And user clicks on "RiskGroupDeleteConfirmBTN" on "RiskModels" page
    Then user should not see "RiskGroupBtn" on "RiskModels" page
    When user clicks on "SaveDesignerBtn" on "RiskModels" page
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    And user should able see "DraftVersionText" on "Common" page

  @Smoke
  Scenario: 007 Risk Rule Always True Configuration Verification #ENG-T9607
    Then user should see ' Risk Models ' on 'PageTitle' on 'RiskModels' page
    When user enter "Risk Rule Always True Configuration Do Not Touch" text in "RiskModelsSearchBox" field on "RiskModels" page
    And user clicks on "RiskModelViewBTN" button associate with text "Risk Rule Always True Configuration Do Not Touch" on "RiskModels"
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    When user clicks on "EditDesignerBtn" on "RiskModels" page
    Then user should see 'Risk Model Designer' on 'RiskModelDesignerTitle' on 'RiskModels' page
    And user should see 'Add' on 'RiskGroupAddBtn' on 'RiskModels' page
    And user removes the existing Risk Groups in the Risk Model designer if present
    And user clicks on "RiskGroupAddBtn" on "RiskModels" page
    Then user should see 'Risk Group' on 'RiskGroupBtn' on 'RiskModels' page
    When user drags element "Risk Rule Always True" from "RiskRules" and drops it on element "riskRuleDropContainer" on "RiskGroupOneContainerBox" on "RiskModels" page
    Then user should see "Risk Rule Always True" on "FirstRiskRuleTitle" on "RiskModels" page
    And user should see "Weighted Value" on "FirstRiskRuleWeightedLabel" on "RiskModels" page
    And user should see "100" value in "FirstRiskRuleWeightedInputBox" field on "RiskModels" page
    And user should see "0" value in "RiskRuleRiskValueInputBox" field on "RiskModels" page
    When user clicks on "SaveDesignerBtn" on "RiskModels" page
    And user publishes the Risk Model after saving
    Then user should able see "PublishedModal" on "Common" page
    When user clicks on "PublishedModalOkButton" on "Common" page
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    And user should able see "ActiveVersionText" on "Common" page
    When user clicks on "EditDesignerBtn" on "RiskModels" page
    And user clicks on "FirstRiskGroupDeleteBtn" on "RiskModels" page
    And user clicks on "RiskGroupDeleteConfirmBTN" on "RiskModels" page
    Then user should not see "RiskGroupBtn" on "RiskModels" page
    When user clicks on "SaveDesignerBtn" on "RiskModels" page
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    And user should able see "DraftVersionText" on "Common" page

  @Smoke
  Scenario: 008 Validating Complex Risk Configuration #ENG-T11746,T11754,T11762,T11765,T11766,T11767,T11813,T11815,T11816,T11818,T12365,T11949,T12368,T12375
    Then user should see ' Risk Models ' on 'PageTitle' on 'RiskModels' page
    # --- Trigger validation errors on empty form ---
    When user clicks on "ComplexRiskConfigurations" on "RiskModels" page
    And user clicks on "CommonBTN" button associate with text "Add" on "Common"
    And user clicks on "AddBTN" on "ComplexRiskConfiguration" page
    Then user should able see "ErrorBox" on "Common" page
    And user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Name is required.          |
      | Risk Type must be set.     |
      | Complex Field is required. |
    # --- Verify inline field-level errors on empty form ---
    And user should see 'Complex Field is required.' on 'ComplexFieldError' on 'ComplexRiskConfiguration' page
    And user should see 'Name is required.' on 'NameFieldError' on 'Common' page
    And user should see 'Risk Type must be set.' on 'RiskTypeDropDownErrorBox' on 'RiskModels' page
    # --- Cancel and return to complex risk configurations list ---
    When user clicks on "CommonBTN" button associate with text "Cancel" on "Common"
    Then user should see 'Complex Risk Configurations' on 'ComplexRiskConfigurationPageHeader' on 'ComplexRiskConfiguration' page
    # --- Fill in the form details ---
    When user clicks on "CommonBTN" button associate with text "Add" on "Common"
    And user selects dropdown option by text "Complex Risk Automation DF - Do Not Touch" in "ComplexFieldDropDown" on page "ComplexRiskConfiguration"
    And user enter "Alexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Franklin Archibald Octavius Montgomery" text in "NameFieldBox" field on "Common" page
    Then the length of text entered in field "NameFieldBox" on page "Common" should be 150
    When user enter "Automation Test - Complex Risk" text in "NameFieldBox" field on "Common" page
    And user enter "Alexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Franklin Archibald Octavius MontgomeryAlexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Franklin Archibald Octavius MontgomeryAlexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Franklin AAlexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Fr" text in "DescriptionFieldBox" field on "Common" page
    Then the length of text entered in field "DescriptionFieldBox" on page "Common" should be 500
    When user enter "Automation Test Description" text in "DescriptionFieldBox" field on "Common" page
    # --- Verify Risk Type dropdown options ---
    Then the dropdown "RiskTypeDropDown" on "RiskModels" page should have the following options:
      |                           |
      | Not Set                   |
      | Weighted Risk             |
      | Total Risk                |
      | Single Highest Value Risk |
    When user selects dropdown option by text "Weighted Risk" in "RiskTypeDropDown" on page "RiskModels"
    # --- Submit the form and verify saved data ---
    And user clicks on "AddBTN" on "ComplexRiskConfiguration" page
    Then user should see ' Completed ' on 'PageTitle' on 'RiskModels' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                                      | fieldName     |
      | Complex Risk Automation DF - Do Not Touch | Complex Field |
      | Automation Test - Complex Risk            | Name          |
      | Automation Test Description               | Description   |
      | Weighted Risk                             | Risk Type     |
    # --- Navigate back to the list and verify archive toggle ---
    When user clicks on "ComplexRiskConfigBackBTN" on "DataTemplates" page
    Then user should see ' Complex Risk Configurations ' on 'PageTitle' on 'Common' page
    # --- Verify archive toggle on complex risk configurations list ---
    And the toggle "ArchivedCheckBox" on "RiskModels" page should be "off"
    And the search result count should be "less" the total count in element "DSFiltterData" on "DSPage" page
    And user should see " Show Archived " on "ArchiveCheckBoxText" on "DSPage" page
    When user turns on the toggle "ArchivedCheckBox" on "RiskModels" page
    Then the search result count should be "equal" the total count in element "DSFiltterData" on "DSPage" page
    And user should see the following table columns in "DSTableHeader" on "DSPage" page:
      | Name          |
      | Description   |
      | Complex Field |
      | Risk Type     |
      | Status        |
    And status badge "Published" on "DSPage" page should have style "green"
    And status badge "Draft" on "DSPage" page should have style "purple"
    And status badge "Archived" on "DSPage" page should have style "yellow"
    # --- Search and open the newly created record ---
    When user enter "automation test - complex risk" text in "SearchField" field on "ComplexRiskConfiguration" page
    And user clicks on "ComplexRiskConfigurationViewBTN" button associate with text "Automation Test - Complex Risk" on "ComplexRiskConfiguration"
    Then user should see ' View - Automation Test - Complex Risk ' on 'PageTitle' on 'Common' page
    And user should able see "PublishBtn" on "RiskModels" page
    And user should able see "DraftVersionText" on "Common" page
    And user should able see "NotPublishedText" on "Common" page
    # --- Designer: edit mode and palette ---
    When user clicks on "CommonBTN" button associate with text "Complex Risk Configuration Designer" on "Common"
    And user clicks on "EditDesignerBtn" on "ComplexRiskConfiguration" page
    Then user should able see "NewRiskGroupBlock" on "ComplexRiskConfiguration" page
    And user should able see "RiskGroupPaletteItem" on "ComplexRiskConfiguration" page
    And user should able see "RiskRuleExplicitPaletteItem" on "ComplexRiskConfiguration" page
    And user should able see "RiskRuleAlwaysTruePaletteItem" on "ComplexRiskConfiguration" page
    And user should able see "RiskRuleListPaletteItem" on "ComplexRiskConfiguration" page
    And user should able see "RiskRuleDecimalPaletteItem" on "ComplexRiskConfiguration" page
    And user should able see "RiskRuleIntegerPaletteItem" on "ComplexRiskConfiguration" page
    # --- Add risk rules and rule group, verify OTHERWISE and PLUS ---
    When user clicks on "AddRiskRuleBtn" on "ComplexRiskConfiguration" page
    And user selects dropdown option by text "Integer" in "AddRiskRuleTypeDropDown" on page "ComplexRiskConfiguration"
    And user clicks on "AddRiskRuleConfirmBtn" on "ComplexRiskConfiguration" page
    And user clicks on "AddRiskRuleBtn" on "ComplexRiskConfiguration" page
    And user selects dropdown option by text "Decimal" in "AddRiskRuleTypeDropDown" on page "ComplexRiskConfiguration"
    And user clicks on "AddRiskRuleConfirmBtn" on "ComplexRiskConfiguration" page
    Then user should see "OTHERWISE" on "OtherwiseConnector" on "ComplexRiskConfiguration" page
    When user clicks on "AddRuleGroupBtn" on "ComplexRiskConfiguration" page
    Then user should see "PLUS" on "RuleGroupPlusConnector" on "ComplexRiskConfiguration" page
    And user should see 'New Risk Group' on 'NewRiskGroupBlock' on 'ComplexRiskConfiguration' page
    And user should able see "RiskGroupReorderUpBtn" on "ComplexRiskConfiguration" page
    And user should see "RiskGroupDeleteBtn" button clickable:"true" on "ComplexRiskConfiguration" page
    # --- Usage tab ---
    When user clicks on "CommonBTN" button associate with text "Usage" on "Common"
    Then user should see " The Complex Risk Configuration is not associated with any Risk Model " on "UsageWarning" on "ComplexRiskConfiguration" page
    # --- Verify disabled fields in edit mode ---
    When user clicks on "EditHeaderBtn" on "ComplexRiskConfiguration" page
    Then the field "DisabledComplexFieldDropDown" on "ComplexRiskConfiguration" page should be "disabled"
    And the field "RiskTypeDropDown" on "ComplexRiskConfiguration" page should be "disabled"
    # --- Archive created record (cleanup for rerun) ---
    # When user verifies the archive section is collapsed and expands it((Commented out this test step as the Archive section is no longer available in the current UI implementation.)
    And user clicks on "ArchiveButton" on "Common" page
    Then user should see 'Automation Test - Complex Risk' on 'ArchiveModalText' on 'Common' page
    When user enter "Automation Test - Complex Risk" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitBtn" on "RiskModels" page
    Then user should see ' Archived ' on 'ArchiveDSText' on 'Common' page
    And user should see ' This item has been archived and cannot be used in the system. ' on 'ArchiveDSWarningMSG' on 'Common' page

  @Smoke
  Scenario: 009 Verify the Validation and warning messages for Entity Type and Business Unit selection #ENG-T9643
    Then user should see ' Risk Models ' on 'PageTitle' on 'RiskModels' page
    When user clicks on "CommonBTN" button associate with text "Add" on "Common"
    Then user should see ' Entity Type ' on 'PageTitle' on 'RiskModels' page
    And user should see 'Risk Model - Add' on 'SidePanelTitle' on 'Common' page
    When user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Entity type is required |
    When user clicks on "EntityTypeSelectBox" button associate with text "ETWithNoBUAdded" on "Entities"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see ' Business Unit ' on 'PageTitle' on 'RiskModels' page
    And user should see 'No business units available' on 'ErrorMessageForNoBU' on 'RiskModels' page
    When user clicks on "CommonBTN" button associate with text "Previous" on "Common"
    And user clicks on "EntityTypeSelectBox" button associate with text "API Test Automaion - Do Not Touch" on "Entities"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see ' Business Unit ' on 'PageTitle' on 'RiskModels' page
    When user clicks on "CommonBTN" button associate with text "Next" on "Common"
    And user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Business Unit is required |
