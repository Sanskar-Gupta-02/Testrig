@CLM @KYCModel @Regression
Feature: KYC Models

  Background:
    Given user login into the 'CLM' application with 'AdminUserName' user
    And user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"

  @Smoke
  Scenario: 001 KYC Model Verification #ENG-T11463,T11464,T11487,T11490,T11492,T11494,T11493,T11495

    # --- Navigate to KYC Models Page ---
    When user clicks on "SideBarMenu" button associate with text "KYC Models" on "Home"
    Then user should see ' KYC Models ' on 'PageTitle' on 'DSPage' page
    And user should able see "KYCModelsSearchBox" on "KYCModel" page
    And user should able see "KYCModelsShowArchivedToggle" on "KYCModel" page
    And user should able see "KYCModelsAddBtn" on "KYCModel" page

    # --- Archive if exists, then create KYC Model ---
    When user archives KYC model "Automation Test KYC Model" if it exists on the list
    And user clicks on "KYCModelsAddBtn" on "KYCModel" page
    Then user should see ' Entity Type ' on 'WizardEntityTypeTitle' on 'KYCModel' page
    And user should see 'KYC Model - Add' on 'SidePanelTitle' on 'Common' page
    And the list  "WizardSteps" on "KYCModel" page should have the following values in order:
      | Entity Type          |
      | Business Unit        |
      | Risk Level Targeting |
      | Details              |
      | Completed            |

    # --- Entity Type validation and selection ---
    When user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Entity type is required |
    When user clicks on "SelectItem" button associate with text "ET_KYCMODEL- Automation Do Not Touch" on "KYCModel"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see ' Business Unit ' on 'WizardBusinessUnitTitle' on 'KYCModel' page

    # --- Business Unit validation and selection ---
    When user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Business Unit is required |
    When user clicks on "SelectItem" button associate with text "BU_KYCMODEL- Automation Do Not Touch" on "KYCModel"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see ' Risk Level Targeting ' on 'WizardRiskLevelTargetingTitle' on 'KYCModel' page

    # --- Risk Level Targeting ---
    When user selects value "RM_KYCModel- Automation Do Not Touch" from dropdown "RiskModelDropDown" on page "KYCModel"
    And user checks checkbox associate with label "Medium" on "KYCModel" page
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see ' Details ' on 'WizardDetailsTitle' on 'KYCModel' page
    And user should see 'Details' on 'WizardActiveStepDetails' on 'KYCModel' page

    # --- Details validation and field limits ---
    Then user should able see "NameFieldBox" on "Common" page
    And user should able see "DescriptionFieldBox" on "Common" page
    And user should able see "AddIconButton" on "Common" page
    When user clicks on "AddBtn" on "KYCModel" page
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Name is required. |
    When user enter "Alexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Franklin Archibald Octavius Montgomery" text in "NameFieldBox" field on "Common" page
    Then the length of text entered in field "NameFieldBox" on page "Common" should be 150
    When user enter "Automation Test KYC Model" text in "NameFieldBox" field on "Common" page
    And user enter "Alexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Franklin Archibald Octavius MontgomeryAlexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Franklin Archibald Octavius MontgomeryAlexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Franklin AAlexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Fr" text in "DescriptionFieldBox" field on "Common" page
    Then the length of text entered in field "DescriptionFieldBox" on page "Common" should be 500
    When user enter "Automation Test KYC Model Description" text in "DescriptionFieldBox" field on "Common" page
    And user selects and add Icon
    And user clicks on "AddBtn" on "KYCModel" page
    Then user should see ' Completed ' on 'WizardCompletedTitle' on 'KYCModel' page
    And user should see 'Completed' on 'WizardActiveStepCompleted' on 'KYCModel' page

    # --- Verify saved data ---
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                                  | fieldName     |
      | Automation Test KYC Model             | Name          |
      | Automation Test KYC Model Description | Description   |
      | ET_KYCMODEL- Automation Do Not Touch  | Entity Type   |
      | BU_KYCMODEL- Automation Do Not Touch  | Business Unit |
    When user clicks on "ContinueBtn" on "KYCModel" page

    # --- Cancel archive KYC Model ---
  # And user verifies the archive section is collapsed and expands it ---> The archive section is not collapsed, so this step is not needed
    And user clicks on "ArchiveButton" on "Common" page
    Then user should able see "ArchiveModalTitle" on "KYCModel" page
    When user enter "Automation TEST KYC Model" text in "ArchiveModalInputBox" field on "KYCModel" page
    And user clicks on "ArchiveModalSubmitBtn" on "KYCModel" page
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Names must match |
    When user clicks on "ArchiveModalCancelBtn" on "KYCModel" page
    Then user should not see "ArchiveModalTitle" on "KYCModel" page

    # --- Cleanup: archive KYC Model ---
    When user clicks on "ArchiveButton" on "Common" page
    And user enter "Automation Test KYC Model" text in "ArchiveModalInputBox" field on "KYCModel" page
    And user clicks on "ArchiveModalSubmitBtn" on "KYCModel" page
    Then user should see ' Archived ' on 'ArchiveDSText' on 'Common' page
    And user should see ' This item has been archived and cannot be used in the system. ' on 'ArchiveDSWarningMSG' on 'Common' page

  @Smoke
  Scenario: 002 Verify duplicate ET×BU KYC Model create, list search, and archive #ENG-T11466,T11488,T11489,T11491,T11492

    # --- Navigate to KYC Models Page ---
    When user clicks on "SideBarMenu" button associate with text "KYC Models" on "Home"

    # --- Clean up orphan models from other scenarios before list search tests ---
    When user archives KYC model "Automation Test KYC Model 003" if it exists on the list
    And user archives KYC model "Automation Test KYC Model 004" if it exists on the list
    And user archives KYC model "Automation Test KYC Model 005" if it exists on the list

    # --- Show Archived ON: archived rows appear (RecordState 2 in data-item) ---
    And user turns on the toggle "KYCModelsShowArchivedToggle" on "KYCModel" page
    Then the toggle "KYCModelsShowArchivedToggle" on "KYCModel" page should be "on"
    And table "KYCModelsTableArchivedRow" on "KYCModel" page should have at least 1 entries

    # --- Show Archived OFF: archived rows hidden from list ---
    When user turns off the toggle "KYCModelsShowArchivedToggle" on "KYCModel" page
    Then the toggle "KYCModelsShowArchivedToggle" on "KYCModel" page should be "off"
    And table "KYCModelsTableArchivedRow" on "KYCModel" page should have 0 entries

    # --- Full model name search ---
    And User searches for "Automation Test KYC Model" on "KYCModelsSearchBox" and sees only matching results by Name or Description using "KYCModelsTableRowName" and "KYCModelsTableRowDescription" inside "KYCModelsTableRow" on "KYCModel" Page

    # --- Partial model name search ---
    And User searches for "Automation" on "KYCModelsSearchBox" and sees only matching results by Name or Description using "KYCModelsTableRowName" and "KYCModelsTableRowDescription" inside "KYCModelsTableRow" on "KYCModel" Page

    # --- Non-matching search shows no results ---
    And User searches for "xyz-nonexistent-kyc-model-999" on "KYCModelsSearchBox" and sees only matching results by Name or Description using "KYCModelsTableRowName" and "KYCModelsTableRowDescription" inside "KYCModelsTableRow" on "KYCModel" Page
    Then table "KYCModelsTableRow" on "KYCModel" page should have 0 entries

    # --- Create KYC Model with same Entity Type x Business Unit: archive if exists, then run Add wizard ---
    When user archives KYC model "Automation Test KYC Model 002" if it exists on the list
    And user creates KYC model with name "Automation Test KYC Model 002", description "Automation Test KYC Model 002 Description", entity type "ET_KYCMODEL- Automation Do Not Touch", business unit "BU_KYCMODEL- Automation Do Not Touch", risk model "RM_KYCModel- Automation Do Not Touch" and risk level "Medium"

    # --- Verify new model appears as separate entry on list ---
    And user clicks on "SideBarMenu" button associate with text "KYC Models" on "Home"
    And user turns on the toggle "KYCModelsShowArchivedToggle" on "KYCModel" page
    And User searches for "Automation Test KYC Model" on "KYCModelsSearchBox" and sees only matching results by Name or Description using "KYCModelsTableRowName" and "KYCModelsTableRowDescription" inside "KYCModelsTableRow" on "KYCModel" Page
    And User searches for "Automation Test KYC Model 002" on "KYCModelsSearchBox" and sees only matching results by Name or Description using "KYCModelsTableRowName" and "KYCModelsTableRowDescription" inside "KYCModelsTableRow" on "KYCModel" Page
    And user clears "KYCModelsSearchBox" input field on "KYCModel" page
    And user press enter
    Then table "KYCModelsTableRowByEntityTypeAndBU" on "KYCModel" page should have at least 2 entries

    # --- Cleanup: archive KYC Model 002 ---
    When user clicks on "CommonTableViewBtn" button associate with text "Automation Test KYC Model 002" on "Common"
    Then user should able see "ArchiveButton" on "Common" page
    # When user verifies the archive section is collapsed and expands it
    And user clicks on "ArchiveButton" on "Common" page
    And user enter "Automation Test KYC Model 002" text in "ArchiveModalInputBox" field on "KYCModel" page
    And user clicks on "ArchiveModalSubmitBtn" on "KYCModel" page
    Then user should see ' Archived ' on 'ArchiveDSText' on 'Common' page
    And user should see ' This item has been archived and cannot be used in the system. ' on 'ArchiveDSWarningMSG' on 'Common' page

  @Smoke
  Scenario: 003 Verify KYC Model view mode, edit fields, and save #ENG-T11465,T11982,T11923

    # --- Navigate to KYC Models Page ---
    When user clicks on "SideBarMenu" button associate with text "KYC Models" on "Home"
    Then user should see ' KYC Models ' on 'PageTitle' on 'DSPage' page
    And table "KYCModelsTableRow" on "KYCModel" page should have at least 1 entries

    # --- Create KYC Model: archive if exists, then run Add wizard ---
     And user archives KYC model "Automation Test KYC Model 003" if it exists on the list
     And user creates KYC model with name "Automation Test KYC Model 003", description "Automation Test KYC Model 003 Description", entity type "ET_KYCMODEL- Automation Do Not Touch", business unit "BU_KYCMODEL- Automation Do Not Touch", risk model "RM_KYCModel- Automation Do Not Touch" and risk level "Medium"

    # --- Open KYC Model view mode ---
    And user clicks on "SideBarMenu" button associate with text "KYC Models" on "Home"
    And User searches for "Automation Test KYC Model 003" on "KYCModelsSearchBox" and sees only matching results by Name or Description using "KYCModelsTableRowName" and "KYCModelsTableRowDescription" inside "KYCModelsTableRow" on "KYCModel" Page
    And user clicks on "CommonTableViewBtn" button associate with text "Automation Test KYC Model 003" on "Common"

    # --- Verify saved data ---
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                                           | fieldName     |
      | Automation Test KYC Model 003                  | Name          |
      | Automation Test KYC Model 003 Description      | Description   |
      | ET_KYCMODEL- Automation Do Not Touch           | Entity Type   |
      | BU_KYCMODEL- Automation Do Not Touch           | Business Unit |

    # --- Draft: Name and Description editable; ET and BU read-only (T11923) ---
    And user should able see "DraftVersionText" on "Common" page
    And user should able see "KYCRuleEditBtn" on "KYCModel" page
    When user clicks on "KYCRuleEditBtn" on "KYCModel" page
    Then user should not see "EntityTypeEditLabel" on "KYCModel" page
    And user should not see "BusinessUnitEditLabel" on "KYCModel" page
    And the field "RiskModelDropDown" on "KYCModel" page should be "disabled"
    And the field "NameInputBox" on "KYCModel" page should be "enabled"
    And the field "KYCRuleDescriptionField" on "KYCModel" page should be "enabled"

    # --- Edit Name and Description ---
    When user enter "Automation Test KYC Model 003 Updated" text in "NameInputBox" field on "KYCModel" page
    And user enter "Automation Test KYC Model 003 Updated Description" text in "KYCRuleDescriptionField" field on "KYCModel" page
    And user clicks on "KYCRuleSaveBtn" on "KYCModel" page

    # --- Verify saved data ---
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                                              | fieldName     |
      | Automation Test KYC Model 003 Updated             | Name          |
      | Automation Test KYC Model 003 Updated Description | Description   |
      | ET_KYCMODEL- Automation Do Not Touch              | Entity Type   |
      | BU_KYCMODEL- Automation Do Not Touch              | Business Unit |

    # --- Cleanup: archive model ---
    #When user verifies the archive section is collapsed and expands it --> The archive section is not collapsed, so this step is not needed
    And user clicks on "ArchiveButton" on "Common" page
    And user enter "Automation Test KYC Model 003 Updated" text in "ArchiveModalInputBox" field on "KYCModel" page
    And user clicks on "ArchiveModalSubmitBtn" on "KYCModel" page
    Then user should see ' Archived ' on 'ArchiveDSText' on 'Common' page
    And user should see ' This item has been archived and cannot be used in the system. ' on 'ArchiveDSWarningMSG' on 'Common' page
    And user should not see "KYCRuleEditBtn" on "KYCModel" page

  @Smoke
  Scenario: 004 Verify KYC rule card field and operator behaviour #ENG-T11914,T11919,T11912,T11922,T12062,T12063,T12064,T12077,T12080,T12120,T12119,T12118,T12075,T12065,T12076,T11924

    # --- Navigate to KYC Models Page ---
    When user clicks on "SideBarMenu" button associate with text "KYC Models" on "Home"
    Then user should see ' KYC Models ' on 'PageTitle' on 'DSPage' page

    # --- Create KYC Model: archive if exists, then run Add wizard ---
    When user archives KYC model "Automation Test KYC Model 004" if it exists on the list
    And user creates KYC model with name "Automation Test KYC Model 004", description "Automation Test KYC Model 004 Description", entity type "KYC_Model_Automation -Do Not Touch", business unit "BU_KYCMODEL- Automation Do Not Touch", risk model "KYC_Model_RM- Automation Do Not Touch" and risk level "Medium"

    # --- KYC Model Designer ---
    Then user should able see "KYCModelDesignerEditBtn" on "KYCModel" page
    When user clicks on "KYCModelDesignerEditBtn" on "KYCModel" page
    Then user should able see "KYCModelDesignerAddRuleBtn" on "KYCModel" page
    When user clicks on "KYCModelDesignerAddRuleBtn" on "KYCModel" page

    # --- Evaluation result: rule card visible; Pass/Fail selection and persistence (single-field) ---
    Then table "KycRuleCard" on "KYCModel" page should have 1 entries
    And user should able see "FirstKycRuleEvaluationResultLabel" on "KYCModel" page
    And user should able see "FirstKycRuleEvaluationResultDropDown" on "KYCModel" page
    And the dropdown "FirstKycRuleEvaluationResultDropDown" on "KYCModel" page should have the following options:
      |      |
      | Pass |
      | Fail |
    When user select "Fail" option in "FirstKycRuleEvaluationResultDropDown" dropdown on "KYCModel" page
    Then user should see "Fail" option selected on "FirstKycRuleEvaluationResultDropDown" on "KYCModel" page

    # --- Rule condition field and operator ---
    And user should see the following table columns in "FirstKycRuleConditionHeaders" on "KYCModel" page:
      | Operator             |
      | Data Structure Field |
      | Is                   |
      | Value                |
    And user should able see "FirstKycRuleAddConditionBtn" on "KYCModel" page
    When user clicks on "FirstKycRuleAddConditionBtn" on "KYCModel" page
    Then user should able see "FirstKycRuleConditionFieldDropDown" on "KYCModel" page
    And the select dropdown should not be present in "FirstKycRuleConditionOperatorCell" on "KYCModel" page

    # --- Boolean field: Is Null / Not Null operators must not appear ---
    When user select "API Auotomation - Boolean (Boolean)" option in "FirstKycRuleConditionFieldDropDown" dropdown on "KYCModel" page
    Then the field "FirstKycRuleConditionOperatorDropDown" on "KYCModel" page should be "enabled"
    And the dropdown "FirstKycRuleConditionOperatorDropDown" on "KYCModel" page should not have the following options:
      | Not Null |
      | Is Null  |

    # --- List field operators ---
    When user select "API Auotomation - List (List)" option in "FirstKycRuleConditionFieldDropDown" dropdown on "KYCModel" page
    And user wait from 1 seconds
    Then the field "FirstKycRuleConditionOperatorDropDown" on "KYCModel" page should be "enabled"
    And the dropdown "FirstKycRuleConditionOperatorDropDown" on "KYCModel" page should have the following options:
      |                       |
      | Equal To ( = )        |
      | Not Equal To ( != )   |
      | Not Null              |
      | Is Null               |

    # --- Decimal field operators ---
    When user select "API Auotomation - Decimal (Decimal)" option in "FirstKycRuleConditionFieldDropDown" dropdown on "KYCModel" page
    And user wait from 1 seconds
    Then the field "FirstKycRuleConditionOperatorDropDown" on "KYCModel" page should be "enabled"
    And the dropdown "FirstKycRuleConditionOperatorDropDown" on "KYCModel" page should have the following options:
      |                               |
      | Less Than ( < )               |
      | Equal To ( = )                |
      | Greater Than ( > )            |
      | Not Equal To ( != )           |
      | Greater Than or Equal To ( >= ) |
      | Less Than or Equal To ( <= )    |
      | Not Null                        |
      | Is Null                         |
    When user select "Less Than ( < )" option in "FirstKycRuleConditionOperatorDropDown" dropdown on "KYCModel" page
    Then user should able see "FirstKycRuleConditionValueInput" on "KYCModel" page
    When user enter "12" text in "FirstKycRuleConditionValueInput" field on "KYCModel" page

    # --- Field change resets operator ---
    And user select "DateOfBirth (Date)" option in "FirstKycRuleConditionFieldDropDown" dropdown on "KYCModel" page
    And user wait from 1 seconds
    Then user should verify "Please select" is selected in dropdown "FirstKycRuleConditionOperatorDropDown" on "KYCModel" page
    And the select dropdown should not be present in "FirstKycRuleConditionOperatorCell" on "KYCModel" page
    And the dropdown "FirstKycRuleConditionOperatorDropDown" on "KYCModel" page should have the following options:
      |                       |
      | Date Within days      |
      | Date Not Within days  |
      | Not Null              |
      | Is Null               |
    When user select "Date Within days" option in "FirstKycRuleConditionOperatorDropDown" dropdown on "KYCModel" page
    And user wait from 1 seconds
    And user clears "FirstKycRuleConditionValueInput" input field on "KYCModel" page

    # --- Rule condition validation: empty integer days (N days) value ---
    And user strict clicks on "KYCModelDesignerSaveBtn" button on "KYCModel"
    Then user should able see "ErrorBox" on "Common" page
    And user should see 'Please fix the following issues:' on 'ErrorBoxTitle' on 'Common' page
    And user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Number of days is required for date-based conditions |

    And user should able see "KYCModelDesignerAddRuleBtn" on "KYCModel" page
    When user enter "5" text in "FirstKycRuleConditionValueInput" field on "KYCModel" page
    And user strict clicks on "KYCModelDesignerSaveBtn" button on "KYCModel"
    And user clicks on "KYCModelDesignerEditBtn" on "KYCModel" page
    Then user should see "Fail" option selected on "FirstKycRuleEvaluationResultDropDown" on "KYCModel" page
    When user clicks on "KYCModelDesignerAddRuleBtn" on "KYCModel" page
    Then user should able see "SecondKycRuleEvaluationResultDropDown" on "KYCModel" page
    And the dropdown "SecondKycRuleEvaluationResultDropDown" on "KYCModel" page should have the following options:
      |      |
      | Pass |
      | Fail |
    When user select "Pass" option in "SecondKycRuleEvaluationResultDropDown" dropdown on "KYCModel" page
    Then user should see "Pass" option selected on "SecondKycRuleEvaluationResultDropDown" on "KYCModel" page
    When user clicks on "SecondKycRuleAddConditionBtn" on "KYCModel" page
    And user wait from 1 seconds
    And user select "API Auotomation - Decimal (Decimal)" option in "SecondKycRuleConditionFieldDropDown" dropdown on "KYCModel" page
    And user select "Less Than ( < )" option in "SecondKycRuleConditionOperatorDropDown" dropdown on "KYCModel" page
    Then user should able see "SecondKycRuleConditionValueInput" on "KYCModel" page
    When user enter "50" text in "SecondKycRuleConditionValueInput" field on "KYCModel" page
    And user clicks on "KYCModelDesignerSaveBtn" on "KYCModel" page

    # --- Publish KYC Model ---
    Then user should able see "NotPublishedText" on "Common" page
    And user should able see "DraftVersionText" on "Common" page
    When user clicks on "PublishBtn" on "KYCModel" page
    Then user should see 'Are you sure want to publish this Kyc Model?' on 'KYCPublishModalDescription' on 'KYCModel' page
    And user should able see "KYCPublishModal" on "KYCModel" page
    And user should see 'Publish' on 'KYCPublishModalTitle' on 'KYCModel' page
    When user strict clicks on "KYCPublishModalOkButton" button on "KYCModel"
    Then user should be able to see "SuccessToastMessage" with text "Publish was successful." on "Common" page
    And user should see 'Published' on 'PublishedText' on 'Common' page
    And user should able see "ActiveVersionText" on "Common" page

    # --- KYC Model Designer ---
    Then user should able see "KYCModelDesignerEditBtn" on "KYCModel" page
    When user clicks on "KYCModelDesignerEditBtn" on "KYCModel" page
    Then user should able see "KYCModelDesignerAddRuleBtn" on "KYCModel" page

    # --- Rule card name max length validation ---
    Then user should able see "FirstRuleCardNameEditBtn" on "KYCModel" page
    When user clicks on "FirstRuleCardNameEditBtn" on "KYCModel" page
    And user enter "Alexander Maximilian Christopher Jonathan Benedict Nathaniel Montgomery Fitzgerald Harrison Wellington Emmanuel Leonardo Sebastian Theodore Franklin Archibald Octavius Montgomery" text in "FirstRuleCardNameField" field on "KYCModel" page
    And user clicks on "KYCModelDesignerSaveBtn" on "KYCModel" page
    Then user should able see "ErrorBox" on "Common" page
    And user should see "The field Name must be a string or array type with a maximum length of '150'." on "ErrorBox" on "Common" page

    # --- Rule card name required validation ---
    And user should able see "FirstRuleCardNameEditBtn" on "KYCModel" page
    When user clicks on "FirstRuleCardNameEditBtn" on "KYCModel" page
    And user clears "FirstRuleCardNameField" input field on "KYCModel" page
    And user clicks on "KYCModelDesignerSaveBtn" on "KYCModel" page
    Then user should able see "ErrorBox" on "Common" page
    And user should see 'The Name field is required.' on 'ErrorBox' on 'Common' page

    # --- Duplicate rule card validation ---
    And user should able see "FirstRuleCardNameEditBtn" on "KYCModel" page
    When user clicks on "FirstRuleCardNameEditBtn" on "KYCModel" page
    And user enter "Rule 2" text in "FirstRuleCardNameField" field on "KYCModel" page
    And user clicks on "KYCModelDesignerSaveBtn" on "KYCModel" page
    Then user should able see "ErrorBox" on "Common" page
    And user should see 'Rule Name must be unique.' on 'ErrorBox' on 'Common' page

    # --- Restore rule 1 name before delete ---
    When user clicks on "FirstRuleCardNameEditBtn" on "KYCModel" page
    And user enter "Rule 1" text in "FirstRuleCardNameField" field on "KYCModel" page
    And user clicks on "KYCModelDesignerSaveBtn" on "KYCModel" page

    # --- Delete rule card: Remove icon, confirmation dialog, and delete ---
    Then user should able see "KYCModelDesignerEditBtn" on "KYCModel" page
    When user clicks on "KYCModelDesignerEditBtn" on "KYCModel" page
    Then table "KycRuleCard" on "KYCModel" page should have 2 entries
    And user should able see "SecondRuleCardDeleteBtn" on "KYCModel" page
    When user clicks on "SecondRuleCardDeleteBtn" on "KYCModel" page
    Then user should able see "KycRuleDeleteModalTitle" on "KYCModel" page
    When user clicks on "KycRuleDeleteConfirmBtn" on "KYCModel" page
    Then table "KycRuleCard" on "KYCModel" page should have 1 entries
    And user should not see "KycRuleDeleteModalTitle" on "KYCModel" page
    And user should able see "FirstRuleCardDeleteBtn" on "KYCModel" page
    When user clicks on "FirstRuleCardDeleteBtn" on "KYCModel" page
    Then user should able see "KycRuleDeleteModalTitle" on "KYCModel" page
    When user clicks on "KycRuleDeleteConfirmBtn" on "KYCModel" page
    Then table "KycRuleCard" on "KYCModel" page should have 0 entries
    And user should not see "KycRuleDeleteModalTitle" on "KYCModel" page
    When user clicks on "KYCModelDesignerSaveBtn" on "KYCModel" page
    Then user should able see "DraftVersionText" on "Common" page
    And user should able see "ErrorBox" on "Common" page
    And user should see 'KYC Model must have at least one rule.' on 'ErrorBox' on 'Common' page

    # --- Cleanup: archive KYC Model 004 ---
    #When user verifies the archive section is collapsed and expands it --> The archive section is not collapsed, so this step is not needed
    And user clicks on "ArchiveButton" on "Common" page
    And user enter "Automation Test KYC Model 004" text in "ArchiveModalInputBox" field on "KYCModel" page
    And user clicks on "ArchiveModalSubmitBtn" on "KYCModel" page
    Then user should see ' Archived ' on 'ArchiveDSText' on 'Common' page

  @Smoke
  Scenario: 005 Verify Risk Level Targeting wizard behaviour #ENG-T12883,T12884,T12885,T12886,T12898

    # --- Navigate to KYC Models Page ---
    When user clicks on "SideBarMenu" button associate with text "KYC Models" on "Home"
    Then user should see ' KYC Models ' on 'PageTitle' on 'DSPage' page
    And user should able see "KYCModelsSearchBox" on "KYCModel" page

    # --- Add wizard: Entity Type and Business Unit ---
    When user archives KYC model "Automation Test KYC Model 005" if it exists on the list
    And user clicks on "KYCModelsAddBtn" on "KYCModel" page
    And user clicks on "SelectItem" button associate with text "ET_KYCMODEL- Automation Do Not Touch" on "KYCModel"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    And user clicks on "SelectItem" button associate with text "BU_KYCMODEL- Automation Do Not Touch" on "KYCModel"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see ' Risk Level Targeting ' on 'WizardRiskLevelTargetingTitle' on 'KYCModel' page

    # --- Risk Model dropdown visible and loaded for selected Entity Type x Business Unit ---
    And user should able see "RiskModelDropDown" on "KYCModel" page
    And user should see 'Risk Model (Optional)' on 'RiskModelDropDownLabel' on 'KYCModel' page
    And user should see 'Select a risk model to only apply this KYC model to entities at specific risk levels. If no risk model is selected, this KYC model will apply to all entities.' on 'RiskLevelTargetingInfoBanner' on 'KYCModel' page
    And the dropdown "RiskModelDropDown" on "KYCModel" page should have the following options:
      | None                 |
      | KYC_Model_Risk_Model |

    # --- No risk model selected: step skips without validation ---
    And user should not able see "RiskLevelCheckboxMedium" on "KYCModel" page
    When user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see ' Details ' on 'WizardDetailsTitle' on 'KYCModel' page
    And user should not see "ErrorBox" on "Common" page

    # --- Single-select: only one risk model can be selected ---
    When user enter "Automation Test KYC Model 005" text in "NameFieldBox" field on "Common" page
    And user enter "Automation Test KYC Model 005 Description" text in "DescriptionFieldBox" field on "Common" page
    And user selects and add Icon
    And user clicks on "AddBtn" on "KYCModel" page
    Then user should see ' Completed ' on 'WizardCompletedTitle' on 'KYCModel' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text | fieldName   |
      | —    | Risk Model  |
      | —    | Risk Levels |
    When user clicks on "ContinueBtn" on "KYCModel" page

    # --- Second pass: risk model and risk levels selected ---
    And user clicks on "SideBarMenu" button associate with text "KYC Models" on "Home"
    And user archives KYC model "Automation Test KYC Model 005" if it exists on the list
    And user clicks on "KYCModelsAddBtn" on "KYCModel" page
    And user clicks on "SelectItem" button associate with text "ET_KYCMODEL- Automation Do Not Touch" on "KYCModel"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    And user clicks on "SelectItem" button associate with text "BU_KYCMODEL- Automation Do Not Touch" on "KYCModel"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see ' Risk Level Targeting ' on 'WizardRiskLevelTargetingTitle' on 'KYCModel' page
    When user selects value "KYC_Model_Risk_Model" from dropdown "RiskModelDropDown" on page "KYCModel"
    Then user should see "KYC_Model_Risk_Model" option selected on "RiskModelDropDown" on "KYCModel" page

    # --- Selecting a risk model displays associated risk levels as checkboxes ---
    And user should able see "RiskLevelCheckboxMedium" on "KYCModel" page
    And user should able see "RiskLevelCheckboxLow" on "KYCModel" page
    When user checks checkbox associate with label "Medium" on "KYCModel" page
    And user checks checkbox associate with label "Low" on "KYCModel" page

    # --- Complete wizard with risk model and risk level for persistence ---
    And user should see ' Risk Level Targeting ' on 'WizardRiskLevelTargetingTitle' on 'KYCModel' page
    When user clicks on "CommonBTN" button associate with text "Next" on "Common"
    And user enter "Automation Test KYC Model 005" text in "NameFieldBox" field on "Common" page
    And user enter "Automation Test KYC Model 005 Description" text in "DescriptionFieldBox" field on "Common" page
    And user selects and add Icon
    And user clicks on "AddBtn" on "KYCModel" page
    Then user should see ' Completed ' on 'WizardCompletedTitle' on 'KYCModel' page
    And user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                 | fieldName   |
      | KYC_Model_Risk_Model | Risk Model  |
      | Low, Medium          | Risk Levels |
    When user clicks on "ContinueBtn" on "KYCModel" page

    # --- List page: Risk Model and comma-separated Risk Levels (ENG-T12884) ---
    And user clicks on "SideBarMenu" button associate with text "KYC Models" on "Home"
    And User searches for "Automation Test KYC Model 005" on "KYCModelsSearchBox" and sees only matching results by Name or Description using "KYCModelsTableRowName" and "KYCModelsTableRowDescription" inside "KYCModelsTableRow" on "KYCModel" Page

    # --- Risk model persists on KYC model detail (read-only in edit mode) ---
    When user clicks on "CommonTableViewBtn" button associate with text "Automation Test KYC Model 005" on "Common"
    And user wait from 1 seconds
    And user clicks on "KYCRuleEditBtn" on "KYCModel" page
    Then user should verify "KYC_Model_Risk_Model" is selected in dropdown "RiskModelDropDown" on "KYCModel" page
    And the field "RiskModelDropDown" on "KYCModel" page should be "disabled"

    # --- Cleanup: archive KYC Model 005 ---
   # When user verifies the archive section is collapsed and expands it--> The archive section is not collapsed, so this step is not needed
    And user clicks on "ArchiveButton" on "Common" page
    And user enter "Automation Test KYC Model 005" text in "ArchiveModalInputBox" field on "KYCModel" page
    And user clicks on "ArchiveModalSubmitBtn" on "KYCModel" page
    Then user should see ' Archived ' on 'ArchiveDSText' on 'Common' page

  @Smoke
  Scenario: 006 Verify KYC checks over time chart on entity #ENG-T12159,T12160,T12161,T12162,T12163,T12164,T12165,T12351

    # --- Navigate to entity BU data structure ---
    When user selects a particular entity "KYC_Model_2_Automation_E" on "RiskOverRide" page
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "BU_KYCMODEL- Automation Do Not Touch" on "EntityType"

    # --- Fill fields: DOB and Integer per KYC model rules ---
    And user clicks on "EditBTN" on "Common" page
    And user enter "Automation" text in "EntityBUDataTemplateFirstInputBox2" field on "Entities" page
    And user enter "Test" text in "EntityBUDataTemplateFirstInputBox5" field on "Entities" page
    And user enter date "1996-12-12" text in "EntityBUDataTemplateFirstInputBox3" field on "Entities" page
    And user enter "25" text in "EntityBUDataTemplateFirstInputBox4" field on "Entities" page
    And user clicks on "Save&SubmitBtn" button associate with text "Save and Submit" on "KYCModel"
    Then user should able see "WorkFlowModalInputBox" on "Entities" page
    And user should see " Workflow action comment " on "WorkFlowModalTitle" on "Entities" page
    And user should see " To confirm saving, enter the workflow comment. " on "WorkFlowModalDescription" on "Entities" page
    When user enter "KYC chart automation" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    Then user should see " Confirm Submit " on "WorkFlowModalTitle2" on "Entities" page
    And user should see " Please confirm you wish to submit this form. " on "WorkFlowModalDescription2" on "Entities" page
    When user clicks on "ConfirmBtn" on "Entities" page

    # --- Open KYC tab and verify checks over time chart ---
    And user clicks on "KYCtab" on "KYCModel" page
    Then user should able see "KycChecksOverTimeChart" on "KYCModel" page
    And user should see 'KYC checks over time' on 'KycChecksOverTimeChartTitle' on 'KYCModel' page

    # --- Chart axes, bars, and legend (ENG-T12160) ---
    And user should able see "KycChecksOverTimeChartSvg" on "KYCModel" page
    And user should able see "KycChecksOverTimeChartYAxisDomain" on "KYCModel" page
    And KYC checks over time chart Y-axis should have at least 2 numeric result count labels on KYCModel page
    And KYC checks over time chart should have at least 2 bars on KYCModel page
    And KYC checks over time chart X-axis should have at least 1 day labels on KYCModel page
    And KYC checks over time chart should have at least 1 bar in color "green" on KYCModel page
    And KYC checks over time chart should have at least 1 bar in color "red" on KYCModel page
    And user should able see "KycChecksOverTimeChartFirstBar" on "KYCModel" page
    And user should able see "KycChecksOverTimeChartLegendPass" on "KYCModel" page
    And user should able see "KycChecksOverTimeChartLegendFail" on "KYCModel" page

    # --- Models filter list beside chart ---
    And user should able see "KycChecksOverTimeChartModelsList" on "KYCModel" page
    And KYC checks over time chart models list should have at least 1 models on KYCModel page
    And user should see 'KYC_Model_KYC_Automation' on 'KycChecksOverTimeChartModelsList' on 'KYCModel' page

    # --- Select model filter and verify chart updates for that model only ---
    When user clicks on "KycChecksOverTimeChartModelFilterByName" button associate with text "KYC_Model_KYC_Automation" on "KYCModel"
    And user wait from 2 seconds
    Then KYC checks over time chart should have at least 1 bars on KYCModel page
    And user should able see "KycChecksOverTimeChartFirstBar" on "KYCModel" page

    # --- Bar click: tooltip with date, pass count, fail count over the bars (ENG-T12163, T12164, T12165) ---
    When user force clicks largest visible bar on KYC checks over time chart on KYCModel page
    Then user should able see "KycChecksOverTimeChartBarTooltip" on "KYCModel" page
    And KYC checks over time chart bar tooltip should include a date on KYCModel page
    And KYC checks over time chart bar tooltip should include "Pass" count of at least 1 on KYCModel page
    And KYC checks over time chart bar tooltip should include "Fail" count of at least 1 on KYCModel page


  @Smoke
  Scenario: 007 Verify KYC model with High risk level targeting applies to entity with High risk and shows evaluation results #ENG-T13025,T13045,T12321,T12324

    # --- Create and publish KYC model with High risk level targeting ---
    When user clicks on "SideBarMenu" button associate with text "KYC Models" on "Home"
    Then user should see ' KYC Models ' on 'PageTitle' on 'DSPage' page
    When user creates KYC model with name "KYC_Model1_Automation_ETRL -Do Not Touch", description "Automation", entity type "KYC_Model_Automation_ETRL -Do Not Touch", business unit "KYC_Model_Automation_BU -Do Not Touch", risk model "RM_Automation_ETRL -Do Not Touch" and risk level "High"
    And user clicks on "KYCModelDesignerEditBtn" on "KYCModel" page
    And user clicks on "KYCModelDesignerAddRuleBtn" on "KYCModel" page
    And user clicks on "FirstKycRuleAddConditionBtn" on "KYCModel" page
    And user select "KYC_Model_Automation_DF (List)" option in "FirstKycRuleConditionFieldDropDown" dropdown on "KYCModel" page
    Then user should verify "KYC_Model_Automation_DF (List)" is selected in dropdown "FirstKycRuleConditionFieldDropDown" on "KYCModel" page
    And the field "FirstKycRuleConditionOperatorDropDown" on "KYCModel" page should be "enabled"
    And user select "Not Null" option in "FirstKycRuleConditionOperatorDropDown" dropdown on "KYCModel" page
    And user should verify "Not Null" is selected in dropdown "FirstKycRuleConditionOperatorDropDown" on "KYCModel" page
    And user clicks on "KYCModelDesignerSaveBtn" on "KYCModel" page
    When user clicks on "PublishBtn" on "KYCModel" page
    Then user should see 'Are you sure want to publish this Kyc Model?' on 'KYCPublishModalDescription' on 'KYCModel' page
    When user strict clicks on "KYCPublishModalOkButton" button on "KYCModel"
    Then user should be able to see "SuccessToastMessage" with text "Publish was successful." on "Common" page
    And user should see 'Published' on 'PublishedText' on 'Common' page

    # --- Entity exists with risk level High ---
    When user selects a particular entity "KYC_Model_Automation_ET" on "RiskOverRide" page
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "KYC_Model_Automation_BU -Do Not Touch" on "EntityType"

    # --- Trigger KYC evaluation via KYC tab on entity ---
    And user clicks on "EditBTN" on "Common" page
    And user select "Nigeria" option in "EntityBUKycModelAutomationDFDropDown" dropdown on "Entities" page
    And user clicks on "Save&SubmitBtn" button associate with text "Save and Submit" on "KYCModel"
    Then user should see " Workflow action comment " on "WorkFlowModalTitle" on "Entities" page
    Then user should able see "WorkFlowModalInputBox" on "Entities" page
    When user enter "KYC ETRL automation" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    Then user should see " Confirm Submit " on "WorkFlowModalTitle2" on "Entities" page
    When user clicks on "ConfirmBtn" on "Entities" page
    And user clicks on "KYCtab" on "KYCModel" page

    # --- KYC model applied to entity and evaluation results visible on UI ---
    Then user should able see "KycChecksOverTimeChart" on "KYCModel" page
    And user should see 'KYC checks over time' on 'KycChecksOverTimeChartTitle' on 'KYCModel' page
    And user should see 'KYC_Model1_Automation_ETRL -Do Not Touch' on 'KycChecksOverTimeChartModelsList' on 'KYCModel' page
    And user should able see "KycChecksOverTimeChartLegendPass" on "KYCModel" page
    And user should able see "KycEvaluationDonutChart" on "KYCModel" page
    And user should able see "KycEvaluationDonutChartSvg" on "KYCModel" page

    # --- Entity exists with Low risk level ---
    When user selects a particular entity "KYC_Model_Automation_ET_001" on "RiskOverRide" page
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "KYC_Model_Automation_BU -Do Not Touch" on "EntityType"

    # --- Trigger KYC evaluation via KYC tab on entity ---
    And user clicks on "EditBTN" on "Common" page
    And user select "United Kingdom" option in "EntityBUKycModelAutomationDFDropDown" dropdown on "Entities" page
    And user clicks on "Save&SubmitBtn" button associate with text "Save and Submit" on "KYCModel"
    Then user should able see "WorkFlowModalInputBox" on "Entities" page
    When user enter "Low Risk" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    Then user should see " Confirm Submit " on "WorkFlowModalTitle2" on "Entities" page
    When user clicks on "ConfirmBtn" on "Entities" page
    And user clicks on "KYCtab" on "KYCModel" page

    # --- KYC tab shows no evaluations for Low risk entity ---
    And user clicks on "KYCtab" on "KYCModel" page
    And user refresh the page
    Then user should able see "KycChecksOverTimeChart" on "KYCModel" page
    And user should able see "KycEvaluationDonutChart" on "KYCModel" page
    And user should see 'No evaluations for this period of time.' on 'KycChecksOverTimeChartNoEvaluationsMessage' on 'KYCModel' page
    And user should see 'No evaluations for this day.' on 'KycEvaluationDonutChartNoEvaluationsMessage' on 'KYCModel' page
    And user should not able see "KycChecksOverTimeChartLegendPass" on "KYCModel" page
    And user should not able see "KycEvaluationDonutChartSvg" on "KYCModel" page

    # --- Entity exists with risk level High ---
    When user selects a particular entity "KYC_Model_Automation_ET_002" on "RiskOverRide" page
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "KYC_Model_Automation_BU -Do Not Touch" on "EntityType"

    # --- Trigger KYC evaluation via KYC tab on entity ---
    And user clicks on "EditBTN" on "Common" page
    And user select "Nigeria" option in "EntityBUKycModelAutomationDFDropDown" dropdown on "Entities" page
    And user clicks on "Save&SubmitBtn" button associate with text "Save and Submit" on "KYCModel"
    Then user should able see "WorkFlowModalInputBox" on "Entities" page
    When user enter "High Risk" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    Then user should see " Confirm Submit " on "WorkFlowModalTitle2" on "Entities" page
    When user clicks on "ConfirmBtn" on "Entities" page
    And user clicks on "KYCtab" on "KYCModel" page

    # --- KYC model applied to entity and evaluation results visible on UI ---
    Then user should able see "KycChecksOverTimeChart" on "KYCModel" page
    And user should see 'KYC checks over time' on 'KycChecksOverTimeChartTitle' on 'KYCModel' page
    And user should see 'KYC_Model1_Automation_ETRL -Do Not Touch' on 'KycChecksOverTimeChartModelsList' on 'KYCModel' page
    And user should able see "KycChecksOverTimeChartLegendPass" on "KYCModel" page
    And user should able see "KycEvaluationDonutChart" on "KYCModel" page
    And user should able see "KycEvaluationDonutChartSvg" on "KYCModel" page

    # --- Edit data structure: change country to United Kingdom ---
    When user clicks on "DataStructureTabInVersion" on "Entities" page
    And user clicks on "EditBTN" on "Common" page
    And user select "United Kingdom" option in "EntityBUKycModelAutomationDFDropDown" dropdown on "Entities" page
    And user clicks on "Save&SubmitBtn" button associate with text "Save and Submit" on "KYCModel"
    Then user should able see "WorkFlowModalInputBox" on "Entities" page
    When user enter "Low Risk" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    Then user should see " Confirm Submit " on "WorkFlowModalTitle2" on "Entities" page
    When user clicks on "ConfirmBtn" on "Entities" page
    And user clicks on "KYCtab" on "KYCModel" page

    # --- KYC tab shows no evaluations for Low risk entity ---
    And user clicks on "KYCtab" on "KYCModel" page
    And user refresh the page
    Then user should able see "KycChecksOverTimeChart" on "KYCModel" page
    And user should able see "KycEvaluationDonutChart" on "KYCModel" page
    And user should see 'No evaluations for this period of time.' on 'KycChecksOverTimeChartNoEvaluationsMessage' on 'KYCModel' page
    And user should see 'No evaluations for this day.' on 'KycEvaluationDonutChartNoEvaluationsMessage' on 'KYCModel' page
    And user should not able see "KycChecksOverTimeChartLegendPass" on "KYCModel" page
    And user should not able see "KycEvaluationDonutChartSvg" on "KYCModel" page

    # --- Cleanup: archive KYC Model ---
    When user clicks on "SideBarMenu" button associate with text "KYC Models" on "Home"
    And User searches for "KYC_Model1_Automation_ETRL -Do Not Touch" on "KYCModelsSearchBox" and sees only matching results by Name or Description using "KYCModelsTableRowName" and "KYCModelsTableRowDescription" inside "KYCModelsTableRow" on "KYCModel" Page
    And user clicks on "CommonTableViewBtn" button associate with text "KYC_Model1_Automation_ETRL -Do Not Touch" on "Common"
    Then user should see ' KYC_Model1_Automation_ETRL -Do Not Touch ' on 'PageTitle' on 'Common' page
   # And user verifies the archive section is collapsed and expands it--> The archive section is not collapsed, so this step is not needed
    And user clicks on "ArchiveButton" on "Common" page
    And user enter "KYC_Model1_Automation_ETRL -Do Not Touch" text in "ArchiveModalInputBox" field on "KYCModel" page
    And user clicks on "ArchiveModalSubmitBtn" on "KYCModel" page
    Then user should see ' Archived ' on 'ArchiveDSText' on 'Common' page

  @Smoke
  Scenario: 008 Verify Medium risk KYC Model with no risk value shows no KYC evaluations on KYC tab #ENG-T13050,T13046,T13016


    # --- Attempt to archive Risk Model referenced by published KYC Model ---
    When user clicks on "SideBarMenu" button associate with text "Risk Models" on "Home"
    Then user should see ' Risk Models ' on 'PageTitle' on 'DSPage' page
    When user enter "KYC_Model_RM_Automation" text in "RiskModelsSearchBox" field on "RiskModels" page
    And user clicks on "RiskModelViewBTN" button associate with text "KYC_Model_RM_Automation" on "RiskModels"
    Then user should see ' View - KYC_Model_RM_Automation ' on 'PageTitle' on 'Common' page
  # And user verifies the archive section is collapsed and expands it--> The archive section is not collapsed, so this step is not needed
    And user clicks on "ArchiveButton" on "Common" page
    And user enter "KYC_Model_RM_Automation" text in "ArchiveModalInputBox" field on "DSPage" page
    And user clicks on "ArchiveModalSubmitBtn" on "RiskModels" page

    # --- Archive prevented: Configuration Consistency modal lists linked KYC Models ---
    And user should able see "ConfigurationConsistencyModal" on "RiskModels" page
    And user should see 'Configuration Consistency' on 'ConfigurationConsistencyModal' on 'RiskModels' page
    And user should see 'The action cannot be completed because of a consistency issue.' on 'ConfigurationConsistencyModal' on 'RiskModels' page
    And the table column "ConfigurationConsistencyModalTypeColumn" on "RiskModels" page should contain the following values:
      | KYC Model |
    When user clicks on "ConfigurationConsistencyModalCloseBtn" on "RiskModels" page

    # --- Medium risk entity with matching BU ---
    When user selects a particular entity "KYC_Model_Automation -Do Not Touch_E_Medium_Risk" on "RiskOverRide" page
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "KYC_Model_Automation -Do Not Touch_BU_Medium_Risk" on "EntityType"

    # --- Submit data structure with India selected ---
    And user clicks on "EditBTN" on "Common" page
    And user select "India" option in "EntityBUKycModelAutomationDFDropDown" dropdown on "Entities" page
    And user clicks on "Save&SubmitBtn" button associate with text "Save and Submit" on "KYCModel"
    Then user should able see "WorkFlowModalInputBox" on "Entities" page
    When user enter "No Risk Value" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    Then user should see " Confirm Submit " on "WorkFlowModalTitle2" on "Entities" page
    When user clicks on "ConfirmBtn" on "Entities" page

    # --- KYC tab shows no evaluations ---
    And user clicks on "KYCtab" on "KYCModel" page
    And user refresh the page
    Then user should able see "KycChecksOverTimeChart" on "KYCModel" page
    And user should able see "KycEvaluationDonutChart" on "KYCModel" page
    And user should see 'No evaluations for this period of time.' on 'KycChecksOverTimeChartNoEvaluationsMessage' on 'KYCModel' page
    And user should see 'No evaluations for this day.' on 'KycEvaluationDonutChartNoEvaluationsMessage' on 'KYCModel' page
    And user should not able see "KycChecksOverTimeChartLegendPass" on "KYCModel" page
    And user should not able see "KycEvaluationDonutChartSvg" on "KYCModel" page

  @Smoke
  Scenario: 009 Verify Medium risk level targeting applies KYC model to Medium entity only #ENG-T12322,T12325,T13049

    
    # --- Medium entities have no KYC models configured ---
    When user selects a particular entity "KYC_Model_Automation -Do Not Touch_E_001_Medium_Risk" on "RiskOverRide" page
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "KYC_Model_Automation -Do Not Touch_BU_001" on "EntityType"
    And user clicks on "KYCtab" on "KYCModel" page
    Then user should see 'No KYC Models' on 'KycNoModelsConfiguredTitle' on 'KYCModel' page
    And user should see 'No KYC Models have been configured.' on 'KycNoModelsConfiguredMessage' on 'KYCModel' page

    # --- High risk entity has no KYC models configured ---
    When user selects a particular entity "KYC_Model_Automation -Do Not Touch_E_001_High_Risk" on "RiskOverRide" page
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "KYC_Model_Automation -Do Not Touch_BU_001" on "EntityType"
    And user clicks on "KYCtab" on "KYCModel" page
    Then user should see 'No KYC Models' on 'KycNoModelsConfiguredTitle' on 'KYCModel' page
    And user should see 'No KYC Models have been configured.' on 'KycNoModelsConfiguredMessage' on 'KYCModel' page

    # --- Create and publish KYC model with Medium risk level targeting ---
    When user clicks on "SideBarMenu" button associate with text "KYC Models" on "Home"
    Then user should see ' KYC Models ' on 'PageTitle' on 'DSPage' page
    When user creates KYC model with name "KYC_Model_Automation -Do Not Touch_KYC_Medium risk 001", description "KYC_Model_Automation -Do Not Touch_KYC_Medium risk 001", entity type "KYC_Model_Automation -Do Not Touch_ET_001", business unit "KYC_Model_Automation -Do Not Touch_BU_001", risk model "KYC_Model_Automation -Do Not Touch_RM_001" and risk level "Medium"
    And user clicks on "KYCModelDesignerEditBtn" on "KYCModel" page
    And user clicks on "KYCModelDesignerAddRuleBtn" on "KYCModel" page
    And user clicks on "FirstKycRuleAddConditionBtn" on "KYCModel" page
    And user select "KYC_Model_Automation -Do Not Touch_DF (List)" option in "FirstKycRuleConditionFieldDropDown" dropdown on "KYCModel" page
    Then user should verify "KYC_Model_Automation -Do Not Touch_DF (List)" is selected in dropdown "FirstKycRuleConditionFieldDropDown" on "KYCModel" page
    And the field "FirstKycRuleConditionOperatorDropDown" on "KYCModel" page should be "enabled"
    And user select "Not Null" option in "FirstKycRuleConditionOperatorDropDown" dropdown on "KYCModel" page
    And user should verify "Not Null" is selected in dropdown "FirstKycRuleConditionOperatorDropDown" on "KYCModel" page
    And user clicks on "KYCModelDesignerSaveBtn" on "KYCModel" page
    When user clicks on "PublishBtn" on "KYCModel" page
    Then user should see 'Are you sure want to publish this Kyc Model?' on 'KYCPublishModalDescription' on 'KYCModel' page
    When user strict clicks on "KYCPublishModalOkButton" button on "KYCModel"
    Then user should be able to see "SuccessToastMessage" with text "Publish was successful." on "Common" page
    And user should see 'Published' on 'PublishedText' on 'Common' page

    # --- Evaluation does not run for non-matching Entity BUs ---
    When user selects a particular entity "KYC_Model_Automation_E_002_No_KYC_Model" on "RiskOverRide" page
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "Test Automation Do not touch" on "EntityType"
    And user clicks on "KYCtab" on "KYCModel" page
    Then user should see 'No KYC Models' on 'KycNoModelsConfiguredTitle' on 'KYCModel' page
    And user should see 'No KYC Models have been configured.' on 'KycNoModelsConfiguredMessage' on 'KYCModel' page

    # --- KYC model applied to Medium risk Entity A ---
    When user selects a particular entity "KYC_Model_Automation -Do Not Touch_E_001_Medium_Risk" on "RiskOverRide" page
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "KYC_Model_Automation -Do Not Touch_BU_001" on "EntityType"
    And user clicks on "KYCtab" on "KYCModel" page
    And user refresh the page
    Then user should not see "KycNoModelsConfiguredMessage" on "KYCModel" page
    And user should able see "KycChecksOverTimeChart" on "KYCModel" page
    And user should see 'KYC checks over time' on 'KycChecksOverTimeChartTitle' on 'KYCModel' page
    And user should see 'KYC_Model_Automation -Do Not Touch_KYC_Medium risk 001' on 'KycChecksOverTimeChartModelsList' on 'KYCModel' page

    # --- KYC model not applied to High risk Entity B ---
    When user selects a particular entity "KYC_Model_Automation -Do Not Touch_E_001_High_Risk" on "RiskOverRide" page
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "KYC_Model_Automation -Do Not Touch_BU_001" on "EntityType"
    And user clicks on "KYCtab" on "KYCModel" page
    And user refresh the page
    Then user should not see "KycNoModelsConfiguredMessage" on "KYCModel" page
    And user should able see "KycChecksOverTimeChart" on "KYCModel" page
    And user should able see "KycEvaluationDonutChart" on "KYCModel" page
    And user should see 'No evaluations for this period of time.' on 'KycChecksOverTimeChartNoEvaluationsMessage' on 'KYCModel' page
    And user should see 'No evaluations for this day.' on 'KycEvaluationDonutChartNoEvaluationsMessage' on 'KYCModel' page
    And user should not able see "KycChecksOverTimeChartLegendPass" on "KYCModel" page
    And user should not able see "KycEvaluationDonutChartSvg" on "KYCModel" page

    # --- Cleanup: archive KYC Model ---
    When user clicks on "SideBarMenu" button associate with text "KYC Models" on "Home"
    And User searches for "KYC_Model_Automation -Do Not Touch_KYC_Medium risk 001" on "KYCModelsSearchBox" and sees only matching results by Name or Description using "KYCModelsTableRowName" and "KYCModelsTableRowDescription" inside "KYCModelsTableRow" on "KYCModel" Page
    And user clicks on "CommonTableViewBtn" button associate with text "KYC_Model_Automation -Do Not Touch_KYC_Medium risk 001" on "Common"
    Then user should see ' KYC_Model_Automation -Do Not Touch_KYC_Medium risk 001 ' on 'PageTitle' on 'Common' page
    #And user verifies the archive section is collapsed and expands it--> The archive section is not collapsed, so this step is not needed
    And user clicks on "ArchiveButton" on "Common" page
    And user enter "KYC_Model_Automation -Do Not Touch_KYC_Medium risk 001" text in "ArchiveModalInputBox" field on "KYCModel" page
    And user clicks on "ArchiveModalSubmitBtn" on "KYCModel" page
    Then user should see ' Archived ' on 'ArchiveDSText' on 'Common' page

    
