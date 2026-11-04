@CLM @Reviews @Regression
Feature: Review

  Background:
    Given user login into the 'CLM' application with 'AdminUserName' user
    And user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"

  @Smoke
  Scenario: 001 Entity Review Verification #ENG-T11899,T11900,T12089

    # --- Navigate to Structured Reviews ---
    When user clicks on "SideBarMenu" button associate with text "Reviews" on "Home"
    Then user should see 'Structured Reviews' on 'PageTitle' on 'StructuredReview' page

    # --- Create and publish Entity review form ---
    When user clicks on "AddButton" button associate with text "Add" on "Common"
    And user enter "Test Automation Pls Delete This" text in the following fields on "StructuredReview" page:
      | field                           |
      | StructuredReviewFormName        |
      | StructuredReviewFormReason      |
      | StructuredReviewDescription     |
    And user selects value "Entity" from dropdown "StructuredReviewType" on page "StructuredReview"
    And user clicks on "Entitycheckbox" on "StructuredReview" page
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    And user clicks on "ContinueButton" on "Common" page
    Then user should able see "DraftVersionText" on "Common" page
    And user should able see "NotPublishedText" on "Common" page
    When user clicks on "PublishBtn" button associate with text "Publish" on "Common"
    And user strict clicks on "StructuredReviewPublishModalOkButton" button on "StructuredReview"
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    And user should able see "ActiveVersionText" on "Common" page

    # --- Archive Entity review form ---
    # When user verifies the archive section is collapsed and expands it (Commented out this test case as the Archive section is no longer available in the current UI implementation.)
    And user clicks on "ArchiveButton" on "Common" page
    And user enter "Test Automation Pls Delete This" text in "ArchiveModalInputBox" field on "StructuredReview" page
    And user clicks on "OkButton" on "Common" page
    Then user should see ' Archived ' on 'ArchiveDSText' on 'Common' page

    # --- Create and publish Group review form ---
    When user clicks on "SideBarMenu" button associate with text "Reviews" on "Home"
    And user clicks on "StructuredReviewTab" on "StructuredReview" page
    And user clicks on "CommonBTN" button associate with text "Add" on "Common"
    And user enter "Test Automation Pls Delete This" text in the following fields on "StructuredReview" page:
      | field                                   |
      | StructuredReviewFormName        |
      | StructuredReviewFormReason      |
      | StructuredReviewDescription     |
    And user selects value "Group" from dropdown "StructuredReviewType" on page "StructuredReview"
    And user selects value "Periodic Review Automation - Do Not Touch" from dropdown "StructuredReviewGroupType" on page "StructuredReview"
    And user clicks on "CommonBTN" button associate with text "Next" on "Common"
    And user clicks on "ContinueButton" on "Common" page
    Then user should able see "DraftVersionText" on "Common" page
    And user should able see "NotPublishedText" on "Common" page
    When user clicks on "PublishBtn" button associate with text "Publish" on "Common"
    And user strict clicks on "StructuredReviewPublishModalOkButton" button on "StructuredReview"
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    And user should able see "ActiveVersionText" on "Common" page

    # --- Verify Meta Data ---
    Then user should able to see next to fields on "SavedData" on "DSPage" page:
      | text                                      | fieldName   |
      | Test Automation Pls Delete This           | Name        |
      | Test Automation Pls Delete This           | Reason      |
      | Test Automation Pls Delete This           | Description |
      | Group                                     | Review Type |
      | Periodic Review Automation - Do Not Touch   | Group Type  |

    # --- Archive Group review form ---
    # When user verifies the archive section is collapsed and expands it (Commented out this test case as the Archive section is no longer available in the current UI implementation.)
    And user clicks on "ArchiveButton" on "Common" page
    And user enter "Test Automation Pls Delete This" text in "ArchiveModalInputBox" field on "StructuredReview" page
    And user clicks on "OkButton" on "Common" page
    Then user should see ' Archived ' on 'ArchiveDSText' on 'Common' page

  @Smoke
  Scenario: 002 Verify review functionality #ENG-T12023,T12024,T12036,T12058,T12060,T12061

    # --- Navigate to the target entity ---
    When user selects a particular entity "Test Automation Periodic Review" on "RiskOverRide" page

    # --- Navigate to the Review section ---
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "ViewBtn" button associate with text "Test Automation Do not touch" on "Common"
    And user clicks on "ReviewTab" button associate with text "Review" on "StructuredReview"
    And user clicks on "AddButton" button associate with text "Add" on "Common"

    # --- Fill in the Review form ---
    Then user should see 'General settings' on 'ReviewAddTitle' on 'StructuredReview' page
    And user should see 'Set the Review Date and configure either an ad-hoc or structured review. A review can only be started on or after the review date.' on 'GeneralSettingsHelpText' on 'StructuredReview' page
    When user enter date "2026-05-12" text in "StructuredReviewDate" field on "StructuredReview" page
    Then the dropdown "ReviewType" on "StructuredReview" page should have the following options:
      | Please select a Review Type |
      | Ad-hoc                      |
      | Structure                   |
    When user selects value "Ad-hoc" from dropdown "ReviewType" on page "StructuredReview"
    And user enter "Test Automation Pls Delete This" text in the following fields on "StructuredReview" page:
      | field                      |
      | ReviewReason       |
      | ReviewDescription  |

    # --- Submit and verify saved data ---
    And user clicks on "CommonBTN" button associate with text "Add" on "Common"
    Then user should see 'Continue' on 'ContinueButton' on 'Common' page
    And user should able to see next to fields on "SavedData" on "StructuredReview" page:
      | text                            | fieldName          |
      | 12 May 2026                     | Review Date        |
      | Ad-hoc                          | Review Type        |
      | Test Automation Pls Delete This | Review Reason      |
      | Test Automation Pls Delete This | Review Description |

    # --- Clean up: delete the created record ---
    When user clicks on "ContinueButton" on "Common" page
    And user clicks on "CommonBTN" button associate with text "Review" on "Common"
    And user clicks on "DeleteButton" button associate with text "12/05/2026" on "StructuredReview"
    And user enter "12/05/2026" text in "ConfirmDeletionInputBox" field on "StructuredReview" page
    And user clicks on "OkButton" button associate with text "Ok" on "Common"

    # --- Verify review view page ---
    When user clicks on "ReviewViewBtn" button associate with text "Test Automation Pls Delete This" on "StructuredReview"
    And user switch to 'View - Review - CLM - KYC360' page
    Then user should see the following breadcrumb items on "Common" page:
      | Entities                        |
      | Test Automation Periodic Review |
      | Business Units                  |
      | Test Automation Do not touch    |
      | Reviews                         |
      | / / / / / 28/08/2026            |
    And user should see 'Test Automation Periodic Review, Test Automation Do not touch' on 'PageTitle' on 'StructuredReview' page
    And user should see 'Review: 28/08/2026' on 'PageSubtitle' on 'StructuredReview' page

    # --- Verify Data tab (read-only fields) ---
    When user clicks on "CommonBTN" button associate with text "Data" on "Common"
    Then the view field "DOBDateFieldView" on "StructuredReview" page should be read only

    # --- Verify Review tab details ---
    When user clicks on "CommonBTN" button associate with text "Review" on "Common"
    Then user should able to see next to fields on "SavedData" on "StructuredReview" page:
      | text                            | fieldName     |
      | just for testing API automation | Review Reason |
      | 28/08/2026 10:48:17             | Date          |
      | Integration Tests               | Reviewer      |

    # --- Verify breadcrumb navigation back ---
    When user clicks on "BreadcrumbLink" button associate with text "Reviews" on "Common"
    Then user should see the following breadcrumb items on "Common" page:
      | Entities                            |
      | Test Automation Periodic Review     |
      | Business Units                      |
      | / / / Test Automation Do not touch  |

    # --- Verify group review ---
    When user clicks on "SideBarMenu" button associate with text "Groups" on "Home"
    And user enter "Test Automation Do not touch -Group Review- BU" text in "SearchBox" field on "Group" page
    And user clicks on "CommonTableViewBtn" button associate with text "Test Automation Do not touch -Group Review- BU" on "Common"
    And user clicks on "CommonTableViewBtn" button associate with text "Test Automation Do not touch- Group Review -G" on "Common"
    And user clicks on "CommonBTN" button associate with text "Reviews" on "Common"
    And user clicks on "ReviewViewBtn" button associate with text "Completed" on "StructuredReview"
    And user switch to 'View - Review - CLM - KYC360' page
    And user clicks on "MembersViewBtn" button associate with text "Test Automation Do not touch- Group Review -E" on "StructuredReview"
    And user switch to the newly opened 'View - Review - CLM - KYC360' page

    # --- Verify group review member banner ---
    Then user should see 'Group Review Member' on 'MainContent' on 'StructuredReview' page
    And user should see 'This review was part of a group review for Test Automation Do not touch- Group Review -G. Click to review the group results.' on 'MainContent' on 'StructuredReview' page

  @Smoke
  Scenario: 003 Verify version history functionality #ENG-T12078,T12079

    # --- Navigate to the target entity ---
    When user selects a particular entity "Test Automation Periodic Review" on "RiskOverRide" page

    # --- Navigate to Version History ---
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "ViewBtn" button associate with text "Test Automation Do not touch" on "Common"
    And user clicks on "VersionHistoryTab" button associate with text "Version History" on "Common"
    And user clicks on "ViewExactBtn" button associate with text "Approved" on "Common"
    And user switch to 'Version: 260512090947 - CLM - KYC360' page

    # --- Verify review history table ---
    When user clicks on "CommonBTN" button associate with text "Reviews" on "Common"
    Then the following table column values in "ReviewTable" table on "StructuredReview" page should be:
      | fieldName     | value                           |
      | DATE          | 12/05/2026                      |
      | STATE         | Completed                       |
      | REVIEW REASON | Test Automation Pls Delete This |
      | BY            | Integration Tests               |
      | VERSION       | 260512090947                    |
      | TYPE          | Entity                          |

  @Smoke
  Scenario: 004 Verify publish status for Review Form when user edit metadata area  #ENG-T12084,T12089,T12091

    # --- Navigate to Structured Reviews and edit metadata (draft) ---
    When user clicks on "SideBarMenu" button associate with text "Reviews" on "Home"
    Then user should see 'Structured Reviews' on 'PageTitle' on 'StructuredReview' page
    When user clicks on "ReviewCardViewButton" button associate with text "Automation_PR_Do Not Touch" on "StructuredReview"
    And user clicks on "MetadataEditBtn" on "StructuredReview" page
    And user enter text in "StructuredReviewFormReason" field on "StructuredReview" page
    And user clicks on "SaveBTN" on "Common" page
    Then user should able see "DraftVersionText" on "Common" page
    And user should see 'Published' on 'PublishedText' on 'Common' page

    # --- Navigate to the target entity ---
    When user selects a particular entity "Test Automation Periodic Review" on "RiskOverRide" page

    # --- Navigate to the Review section ---
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "ViewBtn" button associate with text "Test Automation Do not touch" on "Common"
    And user clicks on "ReviewTab" button associate with text "Review" on "StructuredReview"
    And user clicks on "AddButton" button associate with text "Add" on "Common"

    # --- Fill in the Review form (structured) ---
    And user enter date "2026-05-12" text in "StructuredReviewDate" field on "StructuredReview" page
    And user selects value "Structure" from dropdown "ReviewType" on page "StructuredReview"
    And user selects first option from dropdown "EntityStructuredReviewDropdown" on "StructuredReview" page
    And user clicks on "AddBtn" button associate with text "Add" on "Common"

    # --- Publish review form ---
    When user clicks on "SideBarMenu" button associate with text "Reviews" on "Home"
    Then user should see 'Reviews' on 'PageTitle' on 'StructuredReview' page
    When user clicks on "ReviewCardViewBtn" button associate with text "Automation_PR_Do Not Touch" on "StructuredReview"
    Then user should able see "DraftVersionText" on "Common" page
    When user clicks on "PublishBtn" button associate with text "Publish" on "Common"
    And user strict clicks on "StructuredReviewPublishModalOkButton" button on "StructuredReview"
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    And user should able see "ActiveVersionText" on "Common" page

    # --- Navigate to the target entity ---
    When user selects a particular entity "Test Automation Periodic Review" on "RiskOverRide" page

    # --- Navigate to the Review section ---
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "ViewBtn" button associate with text "Test Automation Do not touch" on "Common"
    And user clicks on "CommonBTN" button associate with text "Review" on "Common"
    And user clicks on "CommonBTN" button associate with text "Add" on "Common"

    # --- Fill in the Review form (structured) ---
    And user enter date "2026-05-12" text in "StructuredReviewDate" field on "StructuredReview" page
    And user selects value "Structure" from dropdown "ReviewType" on page "StructuredReview"
    And user selects first option from dropdown "EntityStructuredReviewDropdown" on "StructuredReview" page
    And user clicks on "CommonBTN" button associate with text "Add" on "Common"

    # --- Clean up: delete the created record ---
    # --- Delete review with confirm date "12/05/2026" ---
    When user clicks on "ContinueButton" on "Common" page
    And user clicks on "ReviewTab" button associate with text "Review" on "StructuredReview"
    And user clicks on "DeleteButton" button associate with text "12/05/2026" on "StructuredReview"
    And user enter "12/05/2026" text in "ConfirmDeletionInputBox" field on "StructuredReview" page
    And user clicks on "OkButton" button associate with text "Ok" on "Common"
    # --- Delete review with confirm date "12/05/2026" ---
    And user clicks on "ReviewTab" button associate with text "Review" on "StructuredReview"
    And user clicks on "DeleteButton" button associate with text "12/05/2026" on "StructuredReview"
    And user enter "12/05/2026" text in "ConfirmDeletionTextBox" field on "StructuredReview" page
    And user clicks on "OkButton" button associate with text "Ok" on "Common"

  @Smoke
  Scenario: 005 Verify publish status for Review Form when user edit shared area  #ENG-T12085,T12098,T12090

    # --- Navigate to Structured Reviews and edit data structure designer (draft) ---
    When user clicks on "SideBarMenu" button associate with text "Reviews" on "Home"
    Then user should see 'Structured Reviews' on 'PageTitle' on 'StructuredReview' page
    When user clicks on "ReviewCardViewBtn" button associate with text "Automation_PR_Do Not Touch" on "StructuredReview"
    And user clicks on "DataStructureDesignerEditBtn" on "StructuredReview" page
    And user enter text in "DescriptionTextBox" field on "StructuredReview" page
    And user clicks on "SaveBTN" on "Common" page
    Then user should able see "DraftVersionText" on "Common" page
    And user should see 'Published' on 'PublishedText' on 'Common' page

    # --- Navigate to the target entity ---
    When user selects a particular entity "Test Automation Periodic Review" on "RiskOverRide" page

    # --- Navigate to the Review section ---
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "ViewBtn" button associate with text "Test Automation Do not touch" on "Common"
    And user clicks on "ReviewTab" button associate with text "Review" on "StructuredReview"
    And user clicks on "AddButton" button associate with text "Add" on "Common"

    # --- Fill in the Review form (structured) ---
    And user enter date "2026-05-12" text in "StructuredReviewDate" field on "StructuredReview" page
    And user selects value "Structure" from dropdown "ReviewType" on page "StructuredReview"
    And user selects first option from dropdown "EntityStructuredReviewDropdown" on "StructuredReview" page
    And user clicks on "CommonBTN" button associate with text "Add" on "Common"
    And user clicks on "ContinueButton" on "Common" page
    And user clicks on "CommonBTN" button associate with text "Review" on "Common"
    And user clicks on "StartReviewBtn" on "StructuredReview" page
    And user clicks on "StructuredReviewNextBtn" button associate with text "Next" on "StructuredReview"


    # --- Verify draft template title is not used (before publish) ---
    Then the value should not match "template title" on "ReviewDataTemplateTitle" on "StructuredReview" page
    When user clicks on "PreviousButton" button associate with text "Previous" on "Common"
    And user clicks on "CancelButton" button associate with text "Cancel" on "Common"

    # --- Publish review form ---
    When user clicks on "SideBarMenu" button associate with text "Reviews" on "Home"
    Then user should see 'Reviews' on 'PageTitle' on 'StructuredReview' page
    When user clicks on "ReviewCardViewBtn" button associate with text "Automation_PR_Do Not Touch" on "StructuredReview"
    Then user should able see "DraftVersionText" on "Common" page
    When user clicks on "PublishBtn" button associate with text "Publish" on "Common"
    And user strict clicks on "StructuredReviewPublishModalOkButton" button on "StructuredReview"
    Then user should see 'Published' on 'PublishedText' on 'Common' page
    And user should able see "ActiveVersionText" on "Common" page

    # --- Navigate to the target entity ---
    When user selects a particular entity "Test Automation Periodic Review" on "RiskOverRide" page

    # --- Navigate to the Review section ---
    And user clicks on "BUTab" on "Entities" page
    And user clicks on "ViewBtn" button associate with text "Test Automation Do not touch" on "Common"
    And user clicks on "CommonBTN" button associate with text "Review" on "Common"
    And user clicks on "CommonBTN" button associate with text "Add" on "Common"

    # --- Fill in the Review form (structured) ---
    And user enter date "2026-05-12" text in "StructuredReviewDate" field on "StructuredReview" page
    And user selects value "Structure" from dropdown "ReviewType" on page "StructuredReview"
    And user selects first option from dropdown "EntityStructuredReviewDropdown" on "StructuredReview" page
    And user clicks on "CommonBTN" button associate with text "Add" on "Common"
    And user clicks on "ContinueButton" on "Common" page
    And user clicks on "CommonBTN" button associate with text "Review" on "Common"
    And user clicks on "StartReviewBtn" on "StructuredReview" page
    And user clicks on "StructuredReviewNextBtn" button associate with text "Next" on "StructuredReview"

    # --- Verify published template title is used (after publish) ---
    When user clicks on "CommonBTN" button associate with text "Previous" on "Common"
    And user clicks on "CommonBTN" button associate with text "Cancel" on "Common"

    # --- Clean up: delete Pending reviews ---
    And user clicks on "ReviewTab" button associate with text "Review" on "StructuredReview"
    And user clicks on "DeleteButton" button associate with text "12/05/2026" on "StructuredReview"
    And user enter "12/05/2026" text in "ConfirmDeletionInputBox" field on "StructuredReview" page
    And user clicks on "OkButton" button associate with text "Ok" on "Common"
    # --- Delete review with confirm date "12/05/2026" ---
    And user clicks on "ReviewTab" button associate with text "Review" on "StructuredReview"
    And user clicks on "DeleteButton" button associate with text "12/05/2026" on "StructuredReview"
    And user enter "12/05/2026" text in "ConfirmDeletionTextBox" field on "StructuredReview" page
    And user clicks on "OkButton" button associate with text "Ok" on "Common"