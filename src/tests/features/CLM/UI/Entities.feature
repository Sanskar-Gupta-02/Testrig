@CLM @Entities @Regression
Feature: Entities

  Background:
    Given user login into the 'CLM' application with 'AdminUserName' user
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "Entities" on "Home"

  @Smoke
  Scenario: 001 Verify all data fields in the form store values correctly #ENG-T11029,T8645,T8739,T8742,T8638,T8654,T8640,T8607,T8655
    Then user should see ' Entities ' on 'PageTitle' on 'DSPage' page
    And table "EntitiesTableRowHeader" on "Entities" page should have 10 entries
    When user clicks on "CommonBTN" button associate with text "Add" on "Common"
    Then user should see ' Entity Type ' on 'WizardEntityTypeTitle' on 'Entities' page
    When user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Entity type is required |
    When user clicks on "EntityTypeSelectBox" button associate with text "Entity Automation - Do Not Touch" on "Entities"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see ' Entity Shared Inbuilt ' on 'EntityDataTemplateTitle1' on 'Entities' page
    When user clicks on "SubmitBTN" on "Common" page
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Entity Name is required                                                |
      | Entity Role is required                                                |
      | Decimal is required                                                    |
      | Integer is required                                                    |
      | Complex field requires at least 1 item(s) to be added to field Complex |
      | String is required                                                     |
    When user enter "Automation Test Entity Shared" text in "EntityDataTemplateFirstInputBox1" field on "Entities" page
    And user select "End Client" option in "EntityRoleDropDown" dropdown on "Entities" page
    And user turns on the toggle "EntityDataTemplateSecondInputBox1" on "Entities" page
    Then the toggle "EntityDataTemplateSecondInputBox1" on "Entities" page should be "on"
    When user enter date "2026-06-15" text in "EntityDataTemplateSecondInputBox2" field on "Entities" page
    And user clicks on "EntityDataTemplateSecondAddLinksButton" on "Entities" page
    And user select "item1" option in "EntityDataTemplateListDropDown" dropdown on "Entities" page
    And user enter "AutomationString" text in "EntityDataTemplateSecondInputBox7" field on "Entities" page
    And user clicks on "EntityDataTemplateSecondComplexFieldButton" on "Entities" page
    And user enter "20" text in "EntityDataTemplateSecondComplexFieldInputBox1" field on "Entities" page
    And user upload "Dummy.txt" file on "EntityDataTemplateSecondFileDropZone" on "Entities" page
    Then user should see "Complete" on "EntityDataTemplateSecondFileCompleteStatus" on "Entities" page
    When user enter "Dummy Test String" text in "EntityDataTemplateSecondInputBox10" field on "Entities" page
    And user enter "49.99" text in "EntityDataTemplateSecondInputBox3" field on "Entities" page
    And user enter "50" text in "EntityDataTemplateSecondInputBox4" field on "Entities" page
    When user clicks on "AddLinkBtn" on "Entities" page
    And user enter "https://www.kyc360.com/a280a652-932e-4aca-a03e-bced07739bdc/clm/Entity/Add" text in "AddLinkTextBox" field on "Entities" page
    And user clicks on "SubmitBTN" button associate with text "Add" on "Common"
    Then user should see ' Completed ' on 'CompletedTitleOnEntityPage' on 'Entities' page
    And user should able to see next to fields on "SavedData" on "Common" page:
      | text                             | fieldName   |
      | Entity Automation - Do Not Touch | Entity Type |
    When user clicks on "ContinueBtn" on "Entities" page
    Then user should see ' Automation Test Entity Shared ' on 'PageTitle' on 'Common' page
    And user should see " Automation Test Entity Shared " on "EntityNameOnSharedMetaData" on "Entities" page
    And user should see " 15/06/2026 " on "EntityFirstDataTemplateDateField" on "Entities" page
    And user should see " 49.99 " on "EntitySharedFirstDataTemplateDecimalField" on "Entities" page
    And user should see " 50 " on "EntitySharedFirstDataTemplateIntegerField" on "Entities" page
    And user should see " https://www.kyc360.com/a280a652-932e-4aca-a03e-bced07739bdc/clm/Entity/Add " on "AddedLinkOnEntityPage" on "Entities" page
    And user should see " item1 " on "EntityFirstDataTemplateListField" on "Entities" page
    And user should see " Entity - Do Not Touch " on "EntityFirstDataTemplateComplexDataTemplateLabel" on "Entities" page
    And user should see " 20" on "EntityFirstDataTemplateComplexDataTemplateIntegerValue" on "Entities" page
    And user should see "Dummy.txt" on "EntityFirstDataTemplateFileName" on "Entities" page
    And user should see " Dummy Test String " on "EntitySharedFirstDataTemplateStringField" on "Entities" page

  @Smoke
  Scenario: 002 Verify All data fields are in form are storing values correctly in Business Unit #ENG-T11029,T11031,T8911,T9291,T9290
    Then user should see ' Entities ' on 'PageTitle' on 'DSPage' page
    When user clicks on "CommonBTN" button associate with text "Add" on "Common"
    Then user should see ' Entity Type ' on 'WizardEntityTypeTitle' on 'Entities' page
    When user clicks on "EntityTypeSelectBox" button associate with text "Entity Automation - Do Not Touch" on "Entities"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    When user enter "Automation Entity Shared" text in "EntityDataTemplateFirstInputBox1" field on "Entities" page
    And user select "End Client" option in "EntityRoleDropDown" dropdown on "Entities" page
    And user turns on the toggle "EntityDataTemplateSecondInputBox1" on "Entities" page
    Then the toggle "EntityDataTemplateSecondInputBox1" on "Entities" page should be "on"
    When user enter "49.99" text in "EntityDataTemplateSecondInputBox3" field on "Entities" page
    And user enter "50" text in "EntityDataTemplateSecondInputBox4" field on "Entities" page
    And user enter "AutomationString" text in "EntityDataTemplateSecondInputBox7" field on "Entities" page
    And user clicks on "EntityDataTemplateSecondComplexFieldButton" on "Entities" page
    And user enter "20" text in "EntityDataTemplateSecondComplexFieldInputBox1" field on "Entities" page
    And user enter "Dummy Test String" text in "EntityDataTemplateSecondInputBox10" field on "Entities" page
    And user clicks on "SubmitBTN" button associate with text "Add" on "Common"
    Then user should see ' Completed ' on 'WizardCompleteTitle' on 'Entities' page
    And user should able to see next to fields on "SavedData" on "Common" page:
      | text                             | fieldName   | 
      | Entity Automation - Do Not Touch | Entity Type |
    When user clicks on "ContinueBtn" on "Entities" page
    Then user should see ' Automation Entity Shared ' on 'PageTitle' on 'Common' page
    When user clicks on "BUTab" on "Entities" page
    Then user should see " Business Units " on "BUTabTitle" on "Entities" page
    And user should see "No business units found" on "NOBUResult" on "Entities" page
    When user clicks on "BUModalButton" on "Entities" page
    Then the table column "BUBoxTableItemTitle" on "EntityType" page should contain the following values:
      | 4 Eye Enable Automation |
      | Automation Do Not Touch |
    When user clicks on "BUBoxTableItemAddBtn" button associate with text "Automation Do Not Touch" on "Entities"
    Then the table column "AddedBUTitle" on "Entities" page should contain the following values:
      | Automation Do Not Touch |
    When user clicks on "AddedBUViewBTN" button associate with text "Automation Do Not Touch" on "EntityType"
    Then user should see ' Automation Do Not Touch ' on 'BUPageTitleForAutomationDoNotTouch' on 'Entities' page
    When user enter "49.99" text in "EntityBUDataTemplateFirstInputBox3" field on "Entities" page
    And user enter "50" text in "EntityBUDataTemplateFirstInputBox4" field on "Entities" page
    And user clicks on "EntityDataTemplateSecondComplexFieldButton" on "Entities" page
    And user enter "20" text in "BUDataTemplateSecondComplexFieldInputBox2" field on "Entities" page
    And user enter "Dummy Test String" text in "EntityBUDataTemplateFirstInputBox9" field on "Entities" page
    And user clicks on "SaveBTN" on "Common" page
    Then user should able see "WorkFlowModal" on "Entities" page
    And user should see " Workflow action comment " on "WorkFlowModalTitle" on "Entities" page
    And user should see " To confirm saving, enter the workflow comment. " on "WorkFlowModalDescription" on "Entities" page
    When user enter "Test Comment" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    And user clicks on "DiscardButton" on "Entities" page
    And user clicks on "DiscardConfirmOkButton" on "Entities" page
    Then user should see " No Approved Data " on "DataStructureWarningModal" on "Entities" page
    And user should see " No data has been added to this entity. Click the Edit button to add data. " on "DataStructureWarningModal" on "Entities" page
    When user clicks on "EditBTN" on "Common" page
    And user clicks on "SaveAndSubmitBTN" on "Common" page
    Then user should able see "WorkFlowModal" on "Entities" page
    And user should see " Workflow action comment " on "WorkFlowModalTitle" on "Entities" page
    And user should see " To confirm saving, enter the workflow comment. " on "WorkFlowModalDescription" on "Entities" page
    When user enter "Test Comment" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    Then user should see " Confirm Submit " on "WorkFlowModalTitle2" on "Entities" page
    And user should see " Please confirm you wish to submit this form. " on "WorkFlowModalDescription2" on "Entities" page
    When user clicks on "ConfirmBtn" on "Entities" page
    Then user should able see "WorkFlowPanelTitle" with text "Entities" on "  Show Workflow pane " page
    And user should see " 49.99 " on "EntityFirstDataTemplateDecimalField" on "Entities" page
    And user should see " 50 " on "EntityFirstDataTemplateIntegerField" on "Entities" page
    And user should see " 20 " on "BUFirstDataTemplateComplexDataTemplateIntegerValue" on "Entities" page
    And user should see " Dummy Test String " on "EntityFirstDataTemplateStringField" on "Entities" page

  @Smoke
  Scenario: 003 Verify Approval Operation for Entity #ENG-T11031
    Then user should see ' Entities ' on 'PageTitle' on 'DSPage' page
    When user clicks on "CommonBTN" button associate with text "Add" on "Common"
    Then user should see ' Entity Type ' on 'WizardEntityTypeTitle' on 'Entities' page
    When user clicks on "EntityTypeSelectBox" button associate with text "Entity Automation - Do Not Touch" on "Entities"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    And user enter "Automation Entity Shared 4 Eye" text in "EntityDataTemplateFirstInputBox1" field on "Entities" page
    And user select "End Client" option in "EntityRoleDropDown" dropdown on "Entities" page
    And user turns on the toggle "EntityDataTemplateSecondInputBox1" on "Entities" page
    Then the toggle "EntityDataTemplateSecondInputBox1" on "Entities" page should be "on"
    When user enter "49.99" text in "EntityDataTemplateSecondInputBox3" field on "Entities" page
    And user enter "50" text in "EntityDataTemplateSecondInputBox4" field on "Entities" page
    And user enter "AutomationString" text in "EntityDataTemplateSecondInputBox7" field on "Entities" page
    And user clicks on "EntityDataTemplateSecondComplexFieldButton" on "Entities" page
    And user enter "20" text in "EntityDataTemplateSecondComplexFieldInputBox1" field on "Entities" page
    And user enter "Dummy Test String" text in "EntityDataTemplateSecondInputBox10" field on "Entities" page
    And user clicks on "SubmitBTN" button associate with text "Add" on "Common"
    Then user should see ' Completed ' on 'WizardCompleteTitle' on 'Entities' page
    And user should able to see next to fields on "SavedData" on "Common" page:
      | text                             | fieldName   |
      | Entity Automation - Do Not Touch | Entity Type |
    When user clicks on "ContinueBtn" on "Entities" page
    Then user should see ' Automation Entity Shared 4 Eye ' on 'EntityPageTitle' on 'Entities' page
    When user clicks on "BUTab" on "Entities" page
    Then user should see " Business Units " on "BUTabTitle" on "Entities" page
    And user should see "No business units found" on "NOBUResult" on "Entities" page
    When user clicks on "BUModalButton" on "Entities" page
    Then the table column "BUBoxTableItemTitle" on "EntityType" page should contain the following values:
      | 4 Eye Enable Automation |
      | Automation Do Not Touch |
    When user clicks on "BUBoxTableItemAddBtn" button associate with text "4 Eye Enable Automation" on "Entities"
    Then the table column "AddedBUTitle" on "Entities" page should contain the following values:
      | 4 Eye Enable Automation |
    When user clicks on "AddedBUViewBTN" button associate with text "4 Eye Enable Automation" on "EntityType" 
    Then user should see ' 4 Eye Enable Automation ' on 'BUPageTitleFor4EyeEnableAutomation' on 'Entities' page
    When user enter "49.99" text in "EntityBUDataTemplateFirstInputBox3" field on "Entities" page
    And user enter "50" text in "EntityBUDataTemplateFirstInputBox4" field on "Entities" page
    And user clicks on "EntityDataTemplateSecondComplexFieldButton" on "Entities" page
    And user enter "20" text in "BUDataTemplateSecondComplexFieldInputBox2" field on "Entities" page
    And user enter "Dummy Test String" text in "EntityBUDataTemplateFirstInputBox9" field on "Entities" page
    And user clicks on "SaveAndSubmitBTN" on "Common" page
    Then user should able see "WorkFlowModal" on "Entities" page
    And user should see " Workflow action comment " on "WorkFlowModalTitle" on "Entities" page
    And user should see " To confirm saving, enter the workflow comment. " on "WorkFlowModalDescription" on "Entities" page
    When user enter "Test Comment" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    Then user should see " Confirm Submit " on "WorkFlowModalTitle2" on "Entities" page
    And user should see " Please confirm you wish to submit this form. " on "WorkFlowModalDescription2" on "Entities" page
    When user clicks on "ConfirmBtn" on "Entities" page
    Then user should able see "DataStructureWarningModal" on "Entities" page
    When user opens a new browser context, logs in as "UserForApproval", searches for entity "Automation Entity Shared 4 Eye" in Requires Review and performs "Approve" action
    Then user should able see "DataStructureHeading" on "Entities" page

  @Smoke
  Scenario: 004 Verify Rejection Operation for Entity #ENG-T11031,T8726
    Then user should see ' Entities ' on 'PageTitle' on 'DSPage' page
    When user clicks on "CommonBTN" button associate with text "Add" on "Common"
    Then user should see ' Entity Type ' on 'WizardEntityTypeTitle' on 'Entities' page
    When user clicks on "EntityTypeSelectBox" button associate with text "Entity Automation - Do Not Touch" on "Entities"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    And user enter "Automation Entity Shared 4 Eye Reject" text in "EntityDataTemplateFirstInputBox1" field on "Entities" page
    And user select "End Client" option in "EntityRoleDropDown" dropdown on "Entities" page
    And user turns on the toggle "EntityDataTemplateSecondInputBox1" on "Entities" page
    Then the toggle "EntityDataTemplateSecondInputBox1" on "Entities" page should be "on"
    When user enter "49.99" text in "EntityDataTemplateSecondInputBox3" field on "Entities" page
    And user enter "50" text in "EntityDataTemplateSecondInputBox4" field on "Entities" page
    And user enter "AutomationString" text in "EntityDataTemplateSecondInputBox7" field on "Entities" page
    And user clicks on "EntityDataTemplateSecondComplexFieldButton" on "Entities" page
    And user enter "20" text in "EntityDataTemplateSecondComplexFieldInputBox1" field on "Entities" page
    And user enter "Dummy Test String" text in "EntityDataTemplateSecondInputBox10" field on "Entities" page
    And user clicks on "SubmitBTN" button associate with text "Add" on "Common"
    Then user should see ' Completed ' on 'WizardCompleteTitle' on 'Entities' page
    And user should able to see next to fields on "SavedData" on "Common" page:
      | text                             | fieldName   |
      | Entity Automation - Do Not Touch | Entity Type |
    When user clicks on "ContinueBtn" on "Entities" page
    Then user should see ' Automation Entity Shared 4 Eye Reject ' on 'EntityPageTitle' on 'Entities' page
    And user should see "Entity Type: Entity Automation - Do Not Touch" text in "EntityTypeNameOnEntityPage" field on "Entities" page
    When user clicks on "BUTab" on "Entities" page
    Then user should see " Business Units " on "BUTabTitle" on "Entities" page
    And user should see "No business units found" on "NOBUResult" on "Entities" page
    When user clicks on "BUModalButton" on "Entities" page
    Then the table column "BUBoxTableItemTitle" on "EntityType" page should contain the following values:
      | 4 Eye Enable Automation |
      | Automation Do Not Touch |
    When user clicks on "BUBoxTableItemAddBtn" button associate with text "4 Eye Enable Automation" on "Entities"
    Then the table column "AddedBUTitle" on "Entities" page should contain the following values:
      | 4 Eye Enable Automation |
    When user clicks on "AddedBUViewBTN" button associate with text "4 Eye Enable Automation" on "EntityType"
    Then user should see ' 4 Eye Enable Automation ' on 'BusinessUnitPageTitle' on 'Entities' page
    When user enter "49.99" text in "EntityBUDataTemplateFirstInputBox3" field on "Entities" page
    And user enter "50" text in "EntityBUDataTemplateFirstInputBox4" field on "Entities" page
    And user clicks on "EntityDataTemplateSecondComplexFieldButton" on "Entities" page
    And user enter "20" text in "BUDataTemplateSecondComplexFieldInputBox2" field on "Entities" page
    And user enter "Dummy Test String" text in "EntityBUDataTemplateFirstInputBox9" field on "Entities" page
    And user clicks on "SaveAndSubmitBTN" on "Common" page
    Then user should able see "WorkFlowModal" on "Entities" page
    And user should see " Workflow action comment " on "WorkFlowModalTitle" on "Entities" page
    And user should see " To confirm saving, enter the workflow comment. " on "WorkFlowModalDescription" on "Entities" page
    When user enter "Test Comment" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    Then user should see " Confirm Submit " on "WorkFlowModalTitle2" on "Entities" page
    And user should see " Please confirm you wish to submit this form. " on "WorkFlowModalDescription2" on "Entities" page
    When user clicks on "ConfirmBtn" on "Entities" page
    Then user should able see "DataStructureWarningModal" on "Entities" page
    When user opens a new browser context, logs in as "UserForApproval", searches for entity "Automation Entity Shared 4 Eye Reject" in Requires Review and performs "Reject" action
    Then user should see " No Approved Data " on "DataStructureWarningModal" on "Entities" page
    And user should see " No data has been added to this entity. Click the Edit button to add data. " on "DataStructureWarningModal" on "Entities" page

  @Smoke
  Scenario: 005 Verify Change Request Rejection Operation for Entity #ENG-T11031,T9753,T9764,T8748,T9627,T9629,T8741,T8743,T8917,T8912
    Then user should see ' Entities ' on 'PageTitle' on 'DSPage' page
    When user enter "Reject Change Request - Do Not Touch" text in "EntitySearchBox" field on "RiskOverRide" page
    And user clicks on "EntityViewBtn" button associate with text "Reject Change Request - Do Not Touch" on "RiskOverRide"
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "4 Eye Enable Automation" on "EntityType"
    And user clicks on "EditBTN" on "Common" page
    And user enter "50" text in "EntityBUDataTemplateFirstInputBox4" field on "Entities" page
    And user clicks on "SaveAndSubmitBTN" on "Common" page
    Then user should able see "WorkFlowModal" on "Entities" page
    And user should see " Workflow action comment " on "WorkFlowModalTitle" on "Entities" page
    And user should see " To confirm saving, enter the workflow comment. " on "WorkFlowModalDescription" on "Entities" page
    When user enter "Test Comment" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    Then user should see " Confirm Submit " on "WorkFlowModalTitle2" on "Entities" page
    And user should see " Please confirm you wish to submit this form. " on "WorkFlowModalDescription2" on "Entities" page
    When user clicks on "ConfirmBtn" on "Entities" page
    And user clicks on "CommonBTN" button associate with text "Pending Approval" on "Common"
    When user strict clicks on "RequestChangesBtn" button on "Entities"
    Then user should able see "RequestChangesWorkFlowModal" on "Entities" page
    And user should see " Request Changes " on "RequestChangesWorkFlowModalTitle" on "Entities" page
    And user should see " Detail the changes that need to be made. " on "RequestChangesWorkFlowModalDescription" on "Entities" page
    When user enter "Request Changes " text in "RequestChangesWorkFlowModalInputBox" field on "Entities" page
    And user clicks on "RequestChangesWorkFlowModalSubmitButton" on "Entities" page
    Then user should able see "RequestChangesToastMessage" with text "Entities" on "Changes requested" page
    When user clicks on "CommonBTN" button associate with text "View Published" on "Common"
    Then user should see "10" on "EntityFirstDataTemplateIntegerField" on "Entities" page
    And user should able see "AmendSubmissionBtn" on "Entities" page
    When user clicks on "AmendSubmissionBtn" button associate with text "Amend Submission" on "Entities"
    And user clicks on "CommonBTN" button associate with text "Reject" on "Common"
    Then user should able see "RejectWorkFlowModal" on "Entities" page
    And user should see " Reject " on "RejectWorkFlowModalTitle" on "Entities" page
    And user should see " Enter a comment and confirm that you want to reject the changes. " on "RejectWorkFlowModalDescription" on "Entities" page
    When user enter "Rejected" text in "RejectWorkFlowModalInputBox" field on "Entities" page
    And user clicks on "RejectWorkFlowModalSubmitButton" on "Entities" page
    Then user should able see "RejectedToastMessage" with text "Entities" on "Submission rejected" page
    When user clicks on "CommonBTN" button associate with text "View Published" on "Common"
    Then user should see "10" on "EntityFirstDataTemplateIntegerField" on "Entities" page
    And user should able see "EditBTN" on "Common" page

  @Smoke
  Scenario: 006 Verify Change Request Save Operation for Entity #ENG-T11031
    Then user should see ' Entities ' on 'PageTitle' on 'DSPage' page
    When user enter "Save Change Request - Do Not Touch" text in "EntitySearchBox" field on "RiskOverRide" page
    And user clicks on "EntityViewBtn" button associate with text "Save Change Request - Do Not Touch" on "RiskOverRide"
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "4 Eye Enable Automation" on "EntityType"
    And user clicks on "EditBTN" on "Common" page
    And user enter "51" text in "EntityBUDataTemplateFirstInputBox4" field on "Entities" page
    And user clicks on "SaveAndSubmitBTN" on "Common" page
    Then user should able see "WorkFlowModal" on "Entities" page
    And user should see " Workflow action comment " on "WorkFlowModalTitle" on "Entities" page
    And user should see " To confirm saving, enter the workflow comment. " on "WorkFlowModalDescription" on "Entities" page
    When user enter "Test Comment" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    Then user should see " Confirm Submit " on "WorkFlowModalTitle2" on "Entities" page
    And user should see " Please confirm you wish to submit this form. " on "WorkFlowModalDescription2" on "Entities" page
    When user clicks on "ConfirmBtn" on "Entities" page
    And user clicks on "CommonBTN" button associate with text "Pending Approval" on "Common"
    When user strict clicks on "RequestChangesBtn" button on "Entities"
    Then user should able see "RequestChangesWorkFlowModal" on "Entities" page
    And user should see " Request Changes " on "RequestChangesWorkFlowModalTitle" on "Entities" page
    And user should see " Detail the changes that need to be made. " on "RequestChangesWorkFlowModalDescription" on "Entities" page
    When user enter "Request Changes " text in "RequestChangesWorkFlowModalInputBox" field on "Entities" page
    And user clicks on "RequestChangesWorkFlowModalSubmitButton" on "Entities" page
    Then user should able see "RequestChangesToastMessage" with text "Entities" on "Changes requested" page
    When user clicks on "CommonBTN" button associate with text "View Published" on "Common"
    Then user should see "10" on "ComplexIntegerNumber" on "Entities" page
    And user should able see "AmendSubmissionBtn" on "Entities" page
    When user clicks on "AmendSubmissionBtn" button associate with text "Amend Submission" on "Entities"
    And user clicks on "CommonBTN" button associate with text "Save" on "Common"
    Then user should able see "SaveWorkFlowModal" on "Entities" page
    And user should see " Save Data Structure " on "SaveWorkFlowModalTitle" on "Entities" page
    And user should see " Please enter a workflow comment " on "SaveWorkFlowModalDescription" on "Entities" page
    When user enter "Saved" text in "SaveWorkFlowModalInputBox" field on "Entities" page
    And user clicks on "SaveWorkFlowModalSubmitButton" on "Entities" page
    Then user should able see "SavedToastMessage" with text "Entities" on "Data saved" page
    When user clicks on "RejectButton" on "Entities" page
    Then user should able see "RejectWorkFlowModal" on "Entities" page
    And user should see " Reject " on "RejectWorkFlowModalTitle" on "Entities" page
    And user should see " Enter a comment and confirm that you want to reject the changes. " on "RejectWorkFlowModalDescription" on "Entities" page
    When user enter "Rejectd" text in "RejectWorkFlowModalInputBox" field on "Entities" page
    And user clicks on "RejectWorkFlowModalSubmitButton" on "Entities" page
    Then user should able see "RejectedToastMessage" with text "Entities" on "Submission rejected" page
    When user clicks on "CommonBTN" button associate with text "View Published" on "Common"
    Then user should see "10" on "ComplexIntegerNumber" on "Entities" page
    And user should able see "EditBTN" on "Common" page

  @Smoke
  Scenario: 007 Verify Change Request Submit Operation for Entity #ENG-T11031
    Then user should see ' Entities ' on 'PageTitle' on 'DSPage' page
    When user enter "Submit Change Request - Do Not Touch" text in "EntitySearchBox" field on "RiskOverRide" page
    And user clicks on "EntityViewBtn" button associate with text "Submit Change Request - Do Not Touch" on "RiskOverRide"
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "4 Eye Enable Automation" on "EntityType"
    And user clicks on "EditBTN" on "Common" page
    And user enter "50" text in "EntityBUDataTemplateFirstInputBox4" field on "Entities" page
    And user clicks on "SaveAndSubmitBTN" on "Common" page
    Then user should able see "WorkFlowModal" on "Entities" page
    And user should see " Workflow action comment " on "WorkFlowModalTitle" on "Entities" page
    And user should see " To confirm saving, enter the workflow comment. " on "WorkFlowModalDescription" on "Entities" page
    When user enter "Test Comment" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    Then user should see " Confirm Submit " on "WorkFlowModalTitle2" on "Entities" page
    And user should see " Please confirm you wish to submit this form. " on "WorkFlowModalDescription2" on "Entities" page
    When user clicks on "ConfirmBtn" on "Entities" page
    And user clicks on "CommonBTN" button associate with text "Pending Approval" on "Common"
    When user strict clicks on "RequestChangesBtn" button on "Entities"
    Then user should able see "RequestChangesWorkFlowModal" on "Entities" page
    And user should see " Request Changes " on "RequestChangesWorkFlowModalTitle" on "Entities" page
    And user should see " Detail the changes that need to be made. " on "RequestChangesWorkFlowModalDescription" on "Entities" page
    When user enter "Request Changes " text in "RequestChangesWorkFlowModalInputBox" field on "Entities" page
    And user clicks on "RequestChangesWorkFlowModalSubmitButton" on "Entities" page
    Then user should able see "RequestChangesToastMessage" with text "Entities" on "Changes requested" page
    When user clicks on "CommonBTN" button associate with text "View Published" on "Common"
    Then user should see "10" on "EntityFirstDataTemplateIntegerField" on "Entities" page
    And user should able see "AmendSubmissionBtn" on "Entities" page
    When user clicks on "AmendSubmissionBtn" on "Entities" page
    And user clicks on "CommonBTN" button associate with text "Submit Changes" on "Common"
    Then user should able see "SubmitWorkFlowModal" on "Entities" page
    And user should see " Submit Data Structure " on "SubmitWorkFlowModalTitle" on "Entities" page
    And user should see " Please enter a workflow comment and confirm submission " on "SubmitWorkFlowModalDescription" on "Entities" page
    When user enter "Submit" text in "SubmitWorkFlowModalInputBox" field on "Entities" page
    And user clicks on "SubmitWorkFlowModalSubmitButton" on "Entities" page
    Then user should able see "SubmitToastMessage" with text "Entities" on "Data saved" page
    When user clicks on "ConfirmSubmitChangesBtn" on "Entities" page
    And user clicks on "CommonBTN" button associate with text "Pending Approval" on "Common"
    And user opens a new browser context, logs in as "UserForApproval", searches for entity "Submit Change Request - Do Not Touch" in Requires Review and performs "Approve" action
    And user clicks on "EditBTN" on "Common" page
    And user enter "10" text in "EntityBUDataTemplateFirstInputBox4" field on "Entities" page
    And user clicks on "SaveAndSubmitBTN" on "Common" page
    Then user should able see "WorkFlowModal" on "Entities" page
    And user should see " Workflow action comment " on "WorkFlowModalTitle" on "Entities" page
    And user should see " To confirm saving, enter the workflow comment. " on "WorkFlowModalDescription" on "Entities" page
    When user enter "Test Comment" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    Then user should see " Confirm Submit " on "WorkFlowModalTitle2" on "Entities" page
    And user should see " Please confirm you wish to submit this form. " on "WorkFlowModalDescription2" on "Entities" page
    When user clicks on "ConfirmBtn" on "Entities" page
    And user clicks on "CommonBTN" button associate with text "Pending Approval" on "Common"
    And user opens a new browser context, logs in as "UserForApproval", searches for entity "Submit Change Request - Do Not Touch" in Requires Review and performs "Approve" action
    Then user should able see "EditBTN" on "Common" page

  @Smoke
  Scenario: 008 Verify Display changes toggle is on/off #ENG-T10848
    Then user should see ' Entities ' on 'PageTitle' on 'DSPage' page
    When user clicks on "CommonBTN" button associate with text "Add" on "Common"
    Then user should see ' Entity Type ' on 'WizardEntityTypeTitle' on 'Entities' page
    When user clicks on "EntityTypeSelectBox" button associate with text "Entity Automation - Do Not Touch" on "Entities"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    And user enter "Automation Data Change" text in "EntityDataTemplateFirstInputBox1" field on "Entities" page
    And user select "End Client" option in "EntityRoleDropDown" dropdown on "Entities" page
    And user turns on the toggle "EntityDataTemplateSecondInputBox1" on "Entities" page
    Then the toggle "EntityDataTemplateSecondInputBox1" on "Entities" page should be "on"
    And user enter "AutomationString" text in "EntityDataTemplateSecondInputBox7" field on "Entities" page
    And user clicks on "EntityDataTemplateSecondComplexFieldButton" on "Entities" page
    And user enter "20" text in "EntityDataTemplateSecondComplexFieldInputBox1" field on "Entities" page
    And user enter "Dummy Test String" text in "EntityDataTemplateSecondInputBox10" field on "Entities" page
    When user enter "49.99" text in "EntityDataTemplateSecondInputBox3" field on "Entities" page
    And user enter "50" text in "EntityDataTemplateSecondInputBox4" field on "Entities" page
    And user clicks on "SubmitBTN" button associate with text "Add" on "Common"
    Then user should see ' Completed ' on 'WizardCompleteTitle' on 'Entities' page
    When user clicks on "ContinueBtn" on "Entities" page
    Then user should see ' Automation Data Change ' on 'PageTitle' on 'Common' page
    When user clicks on "BUTab" on "Entities" page
    And user clicks on "BUModalButton" on "Entities" page
    And user clicks on "BUBoxTableItemAddBtn" button associate with text "4 Eye Enable Automation" on "Entities"
    Then the table column "AddedBUTitle" on "Entities" page should contain the following values:
      | 4 Eye Enable Automation |
    When user clicks on "AddedBUViewBTN" button associate with text "4 Eye Enable Automation" on "EntityType"
    Then user should see ' 4 Eye Enable Automation ' on 'BusinessUnitPageTitle' on 'Entities' page
    When user enter "49.99" text in "EntityBUDataTemplateFirstInputBox3" field on "Entities" page
    And user enter "50" text in "EntityBUDataTemplateFirstInputBox4" field on "Entities" page
    And user clicks on "EntityDataTemplateSecondComplexFieldButton" on "Entities" page
    And user enter "20" text in "BUDataTemplateSecondComplexFieldInputBox2" field on "Entities" page
    And user enter "Dummy Test String" text in "EntityBUDataTemplateFirstInputBox9" field on "Entities" page
    And user clicks on "SaveAndSubmitBTN" on "Common" page
    Then user should able see "WorkFlowModal" on "Entities" page
    And user should see " Workflow action comment " on "WorkFlowModalTitle" on "Entities" page
    And user should see " To confirm saving, enter the workflow comment. " on "WorkFlowModalDescription" on "Entities" page
    When user enter "Test Comment" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    Then user should see " Confirm Submit " on "WorkFlowModalTitle2" on "Entities" page
    And user should see " Please confirm you wish to submit this form. " on "WorkFlowModalDescription2" on "Entities" page
    When user clicks on "ConfirmBtn" on "Entities" page
    Then user should able see "DataStructureWarningModal" on "Entities" page
    When user clicks on "CommonBTN" button associate with text "Pending Approval" on "Common"
    Then user should see "Previous value" on "PreviousValueLabel" on "Entities" page
    And user should able see "EntityBUCompareBooleanLabel" on "Entities" page
    And user should able see "EntityBUCompareBooleanValuesNew" on "Entities" page
    And user should able see "EntityBUCompareBooleanValuesPrev" on "Entities" page
    And user should able see "EntityBUCompareDateLabel" on "Entities" page
    And user should able see "EntityBUCompareDateValuesNew" on "Entities" page
    And user should able see "EntityBUCompareDateValuesPrev" on "Entities" page
    And user should able see "EntityBUCompareDecimalLabel" on "Entities" page
    And user should able see "EntityBUCompareDecimalValuesNew" on "Entities" page
    And user should able see "EntityBUCompareDecimalValuesPrev" on "Entities" page
    And user should able see "EntityBUCompareIntegerLabel" on "Entities" page
    And user should able see "EntityBUCompareIntegerValuesNew" on "Entities" page
    And user should able see "EntityBUCompareIntegerValuesPrev" on "Entities" page
    And user should able see "EntityBUCompareLinksLabel" on "Entities" page
    And user should able see "EntityBUCompareListLabel" on "Entities" page
    And user should able see "EntityBUCompareListValuesNew" on "Entities" page
    And user should able see "EntityBUCompareListValuesPrev" on "Entities" page
    And user should able see "EntityBUCompareStringLabel" on "Entities" page
    And user should able see "EntityBUCompareStringValuesNew" on "Entities" page
    And user should able see "EntityBUCompareStringValuesPrev" on "Entities" page
    And user should able see "EntityBUCompareTextLabel" on "Entities" page
    And user should able see "EntityBUCompareTextValuesNew" on "Entities" page
    And user should able see "EntityBUCompareTextValuesPrev" on "Entities" page
    And user should able see "EntityBUCompareFileLabel" on "Entities" page
    And user should able see "EntityBUCompareFileValuesNew" on "Entities" page
    And user should able see "EntityBUCompareFileValuesPrev" on "Entities" page
    And user should able see "EntityBUCompareComplexLabel" on "Entities" page
    And user should able see "EntityBUCompareComplexValuesNew" on "Entities" page
    And user should able see "EntityBUCompareComplexValuesPrev" on "Entities" page
    And user should see "Display only changed" on "DataChangeToggleText" on "Entities" page
    When user turns on the toggle "DataChangeToggle" on "Entities" page
    Then user should able see "EntityBUCompareDecimalLabel" on "Entities" page
    And user should able see "EntityBUCompareDecimalValuesNew" on "Entities" page
    And user should able see "EntityBUCompareDecimalValuesPrev" on "Entities" page
    And user should able see "EntityBUCompareIntegerLabel" on "Entities" page
    And user should able see "EntityBUCompareIntegerValuesNew" on "Entities" page
    And user should able see "EntityBUCompareIntegerValuesPrev" on "Entities" page
    And user should able see "EntityBUCompareStringLabel" on "Entities" page
    And user should able see "EntityBUCompareStringValuesNew" on "Entities" page
    And user should able see "EntityBUCompareStringValuesPrev" on "Entities" page
    And user should able see "EntityBUCompareComplexLabel" on "Entities" page
    And user should able see "EntityBUCompareComplexValuesNew" on "Entities" page
    And user should able see "EntityBUCompareComplexValuesPrev" on "Entities" page
    And user should able see "EntityBUCompareComplexLabel" on "Entities" page
    And user should able see "EntityBUCompareComplexValuesNew" on "Entities" page
    And user should able see "EntityBUCompareComplexValuesPrev" on "Entities" page
    And user should not see "EntityBUCompareBooleanLabel" on "Entities" page
    And user should not see "EntityBUCompareBooleanValuesNew" on "Entities" page
    And user should not see "EntityBUCompareBooleanValuesPrev" on "Entities" page
    And user should not see "EntityBUCompareDateLabel" on "Entities" page
    And user should not see "EntityBUCompareDateValuesNew" on "Entities" page
    And user should not see "EntityBUCompareDateValuesPrev" on "Entities" page
    And user should not see "EntityBUCompareLinksLabel" on "Entities" page
    And user should not see "EntityBUCompareListLabel" on "Entities" page
    And user should not see "EntityBUCompareListValuesNew" on "Entities" page
    And user should not see "EntityBUCompareListValuesPrev" on "Entities" page
    And user should not see "EntityBUCompareTextLabel" on "Entities" page
    And user should not see "EntityBUCompareTextValuesNew" on "Entities" page
    And user should not see "EntityBUCompareTextValuesPrev" on "Entities" page
    And user should not see "EntityBUCompareFileLabel" on "Entities" page
    And user should not see "EntityBUCompareFileValuesNew" on "Entities" page
    And user should not see "EntityBUCompareFileValuesPrev" on "Entities" page

  @Smoke
  Scenario: 009 Verify workflow toggle is on/off #ENG-T10848,T9551,T9288
    Then user should see ' Entities ' on 'PageTitle' on 'DSPage' page
    When user enter "Workflow Pane - Do Not Touch" text in "EntitySearchBox" field on "RiskOverRide" page
    And user clicks on "EntityViewBtn" button associate with text "Workflow Pane - Do Not Touch" on "RiskOverRide"
    When user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "4 Eye Enable Automation" on "EntityType"
    Then user should not see "WorkFlowPanel" on "Entities" page
    And user should not see "WorkFlowPanelTitle" on "Entities" page
    When user turns on the toggle "ShowWorkFlowPaneToggle" on "Entities" page
    Then user should see " Workflow " on "WorkFlowPanelTitle" on "Entities" page
    And the list  "WorkFlowActionName" on "Entities" page should have the following values in order:
      | INFO: 4 Eyes required - Approved   |
      | approved.                          |
      | INFO: 4 Eyes required - Submitting |
      | another comment                    |
    And the list  "WorkFlowActionStatus" on "Entities" page should have the following values in order:
      | Approved  |
      | Approved  |
      | Submitted |
      | Draft     |

  @Smoke
  Scenario: 010 Verify User permissions for different tabs and buttons on Entities page
    When user logs out and logs in with "UserWithoutPermission" username
    And user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "Entities" on "Home"
    Then user should see ' Entities ' on 'PageTitle' on 'DSPage' page
    When user enter "Entity Check User Permissions" text in "EntitySearchBox" field on "RiskOverRide" page
    And user clicks on "EntityViewBtn" button associate with text "Entity Check User Permissions" on "RiskOverRide"
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "Automation Do Not Touch" on "Entities"
    Then user should not see "PeriodicReviewTab" on "Entities" page
    And user should see "Automation Do Not Touch - Entity Check User Permissions" on 'BUEntityHeaderName' on 'Entities' page
    And user should see "Entity Type: Entity Type for Tabs Verification" on 'BusinessUnitEntityTypeName' on 'Entities' page
    When user clicks on "RiskTab" button associate with text "Risk" on "Entities"
    Then user should not see "RiskOverrideBtn" on "Entities" page

  @Smoke
  Scenario: 011 Verify User permissions for other different tabs and buttons on Entities page
    When user logs out and logs in with "SecondUserWithoutPermission" username
    And user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "Entities" on "Home"
    Then user should see ' Entities ' on 'PageTitle' on 'DSPage' page
    When user enter "Entity Check User Permissions" text in "EntitySearchBox" field on "RiskOverRide" page
    And user clicks on "EntityViewBtn" button associate with text "Entity Check User Permissions" on "RiskOverRide"
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "Automation Do Not Touch" on "Entities"
    Then user should able see "ReviewTab" on "StructuredReview" page
    And user should be able to see "BUEntityHeader" with text "Automation Do Not Touch - Entity Check User Permissions" on "Entities" page
    When user clicks on "CommonBTN" button associate with text "Risk" on "Common"
    Then user should able see "RiskOverrideBtn" on "Entities" page

  @Smoke
  Scenario: 012 Verify that Removing the First Complex Field Does Not Delete All Complex Fields After Save and Submit #ENG-T9552,T9553,T9484,T9488
    Then user should see ' Entities ' on 'PageTitle' on 'DSPage' page
    When user enter "Entity for DF deletion after save and submit" text in "EntitySearchBox" field on "RiskOverRide" page
    And user clicks on "EntityViewBtn" button associate with text "Entity for DF deletion after save and submit" on "RiskOverRide"
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "Automation Do Not Touch" on "EntityType"
    And user clicks on "EditBTN" on "Common" page
    And user clicks on "ComplexFieldRemoveBtn" button associate with text "DataTemplateForComplex" on "Entities"
    And user wait from 1 seconds
    Then user should see "Confirm that you want to remove this template from this field." on "RemoveTemplateModalDescription" on "Entities" page
    When user clicks on "RemoveTemplateOkBtn" on "Entities" page
    And user clicks on "SaveAndSubmitBTN" on "Common" page
    Then user should able see "WorkFlowModal" on "Entities" page
    And user should see " Workflow action comment " on "WorkFlowModalTitle" on "Entities" page
    And user should see " To confirm saving, enter the workflow comment. " on "WorkFlowModalDescription" on "Entities" page
    When user enter "Test Comment" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    Then user should see " Confirm Submit " on "WorkFlowModalTitle2" on "Entities" page
    And user should see " Please confirm you wish to submit this form. " on "WorkFlowModalDescription2" on "Entities" page
    When user clicks on "ConfirmBtn" on "Entities" page
    Then user should not see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Complex field requires at least 1 item(s) to be added to field Complex DF Automation - Do Not Touch |
    #ForDataRevert
    And user should able see "ShowWorkFlowPaneToggle" on "Entities" page
    When user clicks on "EditBTN" on "Common" page
    And user clicks on "ComplexFieldAddBtn" button associate with text "DataTemplateForComplex" on "Entities"
    And user clicks on "SaveAndSubmitBTN" on "Common" page
    Then user should able see "WorkFlowModal" on "Entities" page
    And user should see " Workflow action comment " on "WorkFlowModalTitle" on "Entities" page
    And user should see " To confirm saving, enter the workflow comment. " on "WorkFlowModalDescription" on "Entities" page
    When user enter "Test Comment" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    Then user should see " Confirm Submit " on "WorkFlowModalTitle2" on "Entities" page
    And user should see " Please confirm you wish to submit this form. " on "WorkFlowModalDescription2" on "Entities" page
    When user clicks on "ConfirmBtn" on "Entities" page

  @Smoke
  Scenario: 013 View specific version of Business Unit Data structure. #ENG-T9293,T9294,T9263,T9262,T9295
    When user selects a particular entity "Test Automation Periodic Review" on "RiskOverRide" page
    # --- Navigate to Version History ---
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "Test Automation Do not touch" on "Entities"
    And user clicks on "CommonBTN" button associate with text "Version History" on "Common"
    Then the table column "VersionHistoryTableRowHeader" on "Entities" page should contain the following values:
      | Version |
      | Created |
      | Author  |
      | Status  |
      |         |
    And user should not see "LoadMoreBtn" on "Entities" page
    When user clicks on "ViewBtnOnVersionHistory" button associate with text "260512090947" on "Entities"
    And user switch to 'Version: 260512090947 - CLM - KYC360' page
    Then user should see 'Version: 260512090947 - Test Automation Do not touch' on 'BUPageTitle' on 'Entities' page
    And user should see "Entities" on "FirstBreadCrumb" on "Entities" page
    And user should see "Test Automation Periodic Review" on "SecondBreadCrumb" on "Entities" page
    And user should see "Business Units" on "ThirdBreadCrumb" on "Entities" page
    And user should see "Test Automation Do not touch" on "FourthBreadCrumb" on "Entities" page
    And user should see "Version: 260512090947" on "LastBreadCrumb" on "Entities" page
    When user clicks on "DataStructureTabInVersion" on "Entities" page

  @Smoke
  Scenario: 014 Verify Audit Log Tab on the Entity Business Unit Page is displayed #ENG-T9143
    Then user should see ' Entities ' on 'PageTitle' on 'DSPage' page
    When user enter "Entity for DF deletion after save and submit" text in "EntitySearchBox" field on "RiskOverRide" page
    And user clicks on "EntityViewBtn" button associate with text "Entity for DF deletion after save and submit" on "RiskOverRide"
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "Automation Do Not Touch" on "Entities"
    Then user should able see "AuditLogsTab" on "Entities" page
    When user clicks on "AuditLogsTab" on "Entities" page
    Then user should see "Audit Logs" text in "AuditLogsHeader" field on "Entities" page
    And user should able see "AuditLogsRecordsTable" on "Entities" page
    And user should see the following table columns in "AuditLogsTableHeader" on "Entities" page:
      | Date    |
      | Message |
      | Author  |

  @Smoke
  Scenario: 015 Prevent duplicate Business Unit addition to Entity for editor user. #ENG-T8910,T8745,T8747,T8909,T8907
    Then user should see ' Entities ' on 'PageTitle' on 'DSPage' page
    When user enter "some random text" text in "EntitySearchBox" field on "RiskOverRide" page
    Then user should able see "NoSearchResultsText" on "Common" page
    When user enter "Entity for DF deletion after save and submit" text in "EntitySearchBox" field on "RiskOverRide" page
    And user clicks on "EntityViewBtn" button associate with text "Entity for DF deletion after save and submit" on "RiskOverRide"
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "BUModalButton" on "Entities" page
    Then the table column "BUBoxTableItemTitle" on "EntityType" page should contain the following values:
      | Automation Do Not Touch |
    And the field "BUAddDisabledBtn" on "Entities" page should be "disabled"

  @Smoke
  Scenario: 016 Verify the Display (Load More) bar when more than 10 records are returned in Versions history tab. #ENG-T9266,T9265,T9287,T9261,T8727,T8728,T8729,T8657
    When user selects a particular entity "EntitiyForVersionHistory" on "RiskOverRide" page
    Then user should able see "SharedTab" on "Entities" page
    When user clicks on "SharedTabEditBtn" on "Entities" page
    And user clicks on "SharedTabSaveBtn" on "Entities" page
    When user enter "Test Automation" text in "WorkflowActionCommentBox" field on "Entities" page
    When user clicks on "OkButton" on "Common" page
    # --- Navigate to Version History ---
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "AddedBUViewBTN" button associate with text "Automation Do Not Touch" on "Entities"
    And user clicks on "CommonBTN" button associate with text "Version History" on "Common"
    Then the table column "VersionHistoryTableRowHeader" on "Entities" page should contain the following values:
      | Version |
      | Created |
      | Author  |
      | Status  |
      |         |
    And table "VersionHistoryTableRow" on "Entities" page should have 10 entries
    When user clicks on "LoadMoreBtn" on "Entities" page
    Then user should able see "VersionHistoryTableHeaderName" on "Entities" page
    And table "VersionHistoryTableRow" on "Entities" page should have 20 entries
    And versions should be listed in descending order by created date using "VersionHistoryCreatedColumn" on "Entities" page

  @Smoke
  Scenario: 017 Verify that Validation Errors Appear for Incorrect Metadata Form Submission #ENG-T8641,T8653,T8656
    Then user should see ' Entities ' on 'PageTitle' on 'DSPage' page
    When user clicks on "CommonBTN" button associate with text "Add" on "Common"
    Then user should see ' Entity Type ' on 'WizardEntityTypeTitle' on 'Entities' page
    When user clicks on "EntityTypeSelectBox" button associate with text "Entity Automation - Do Not Touch" on "Entities"
    And user clicks on "CommonBTN" button associate with text "Cancel" on "Common"
    Then user should see ' Entities ' on 'PageTitle' on 'DSPage' page
    And table "EntitiesTableRowHeader" on "Entities" page should have 10 entries
    When user clicks on "CommonBTN" button associate with text "Add" on "Common"
    Then user should see ' Entity Type ' on 'WizardEntityTypeTitle' on 'Entities' page
    When user clicks on "EntityTypeSelectBox" button associate with text "Entity Automation - Do Not Touch" on "Entities"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    Then user should see ' Entity Shared Inbuilt ' on 'EntityDataTemplateTitle1' on 'Entities' page
    When user enter "Automation Test Entity Shared" text in "EntityDataTemplateFirstInputBox1" field on "Entities" page
    And user select "End Client" option in "EntityRoleDropDown" dropdown on "Entities" page
    And user turns on the toggle "EntityDataTemplateSecondInputBox1" on "Entities" page
    And user enter "9.99" text in "EntityDataTemplateSecondInputBox3" field on "Entities" page
    And user enter "1" text in "EntityDataTemplateSecondInputBox4" field on "Entities" page
    And user clicks on "SubmitBTN" on "Common" page
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Decimal must be at least 10                                            |
      | Integer must be at least 2                                             |
      | Complex field requires at least 1 item(s) to be added to field Complex |
      | String is required                                                     |

  @Smoke
  Scenario: 018 Verify that Log entry- when Save and Submit/ Save action performed. #ENG-T9168,T9300
    When user selects a particular entity "EntityForLogsVerification" on "RiskOverRide" page
    And user edits business unit "Automation Do Not Touch" and increments "EntityBUDataTemplateFirstInputBox4" on "Entities" page
    And user clicks on "SaveBTN" on "Common" page
    And user enter "Test Comment" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    And user clicks on "AuditLogsTab" on "Entities" page
    And user refresh the page
    Then user should see "Audit Logs" text in "AuditLogsHeader" field on "Entities" page
    And user should see "Action: Save Data Structure." text in "FirstEntryInMessageAuditLogs" field on "Entities" page
    When user clicks on "DataStructureTabInVersion" on "Entities" page
    And user clicks on "EditBTN" on "Common" page
    And user increments value in "EntityBUDataTemplateFirstInputBox4" field on "Entities" page by 1
    And user clicks on "SaveAndSubmitButton" button associate with text "Save and Submit" on "Common"
    And user enter "Test Comment" text in "WorkFlowModalInputBox" field on "Entities" page
    And user clicks on "WorkFlowSubmitButton" on "Entities" page
    And user clicks on "ConfirmBtn" on "Entities" page
    And user clicks on "AuditLogsTab" on "Entities" page
    And user refresh the page
    Then user should see "Audit Logs" text in "AuditLogsHeader" field on "Entities" page
    And user should see "moved from Draft to Approved" text in "FirstEntryInMessageAuditLogs" field on "Entities" page
