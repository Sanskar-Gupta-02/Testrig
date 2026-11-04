@CLM @MyArea @Regression
Feature: My Area

  Background:
    Given user login into the 'CLM' application with 'AdminUserName' user
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"

  @Smoke
  Scenario: 001 Verify that each record shows Index, User Name, Entity Type, Business Unit, and a View link #ENG-T10192,T10223,T10561
    When user clicks on "SideBarMenu" button associate with text "Entities" on "Home"
    When user selects a particular entity "RequireAmendenmentTestEntity" on "RiskOverRide" page
    And user clicks on "BUTab" on "Entities" page
    And user clicks View on business unit card "4 Eye Enable Automation" for My Area
    And user clicks on "CommonBTN" button associate with text "Pending Approval" on "Common"
    And user requests changes with comment "Request Changes" on "Entities" page
    Then user should able see "RequestChangesToastMessage" with text "Entities" on "Changes requested" page
    When user clicks on "SideBarMenu" button associate with text "My Area" on "Home"
    Then user should see 'My Area' on 'PageTitle' on 'DSPage' page
    When user clicks on "RequiresAmendmentTab" on "MyArea" page
    Then user should see 'Requires Amendment' on 'RequiresAmendmentHeader' on 'MyArea' page
    And the table column "RequiresAmendmentTableRowRecordDetails" on "MyArea" page should contain the following values:
      | RequireAmendenmentTestEntity |
      | ETForRequireAmendment        |
      |      4 Eye Enable Automation |
      | View                         |
    When user clicks on "CommonTableViewBtn" button associate with text "RequireAmendenmentTestEntity" on "Common"
    And user submits changes with workflow comment "Submit" on "Entities" page
    And user clicks on "CommonBTN" button associate with text "Pending Approval" on "Common"
    And user clicks on "breadcrumb" on "Common" page
    And user clicks on "RequiresAmendmentTab" on "MyArea" page
    And user searches "RequireAmendenmentTestEntity" in "RequiresAmendmentSearchBox" field on My Area page
    Then user should able see "NoSearchResultsOnRequiresAmendment" on "MyArea" page

  @Smoke
  Scenario: 002 Entity record should disappear from Review tab when Approval action is taken. #ENG-T10210,T8918
    When user selects a particular entity "ReviewAutomation-Do Not Touch" on "RiskOverRide" page
    And user edits business unit "4 Eye Enable Automation" and increments "EntityBUDataTemplateFirstInputBox1" for My Area on "Entities" page
    And user saves and submits changes with comment "Test Comment" on "Entities" page
    And user clicks on "CommonBTN" button associate with text "Pending Approval" on "Common"
    And user opens a new My Area browser context, logs in as "UserForApproval", searches for entity "ReviewAutomation" in Requires Review and performs "Approve" action
    And user opens "My Area" from sidebar and navigates to "RequiresReviewTab" tab on "MyArea" page
    Then user should see 'Requires Review' on 'RequiresReviewHeader' on 'MyArea' page
    When user searches "ReviewAutomation" in "RequiresReviewSearchBox" field on My Area page
    Then user should able see "NoSearchResultsOnRequiresReview" on "MyArea" page

  @Smoke
  Scenario: 003 Verify Require amendments Change request in multiple BU for single entity #ENG-T10216
    When user selects a particular entity "RequireAmendenmentTestMultipleBU" on "RiskOverRide" page
    And user edits business unit "OtherBUWith4EyeEnabled" and increments "EntityBUDataTemplateFirstInputBox5" for My Area on "Entities" page
    And user saves and submits changes with comment "Test Comment" on "Entities" page
    And user clicks on "CommonBTN" button associate with text "Pending Approval" on "Common"
    And user requests changes with comment "Request Changes" on "Entities" page
    And user clicks on "BackToEntityTypeBTN" on "EntityType" page
    And user edits business unit "BUFor4EyeSingleInteger" and increments "EntityBUDataTemplateFirstInputBox5" for My Area on "Entities" page
    And user saves and submits changes with comment "Test Comment" on "Entities" page
    And user clicks on "CommonBTN" button associate with text "Pending Approval" on "Common"
    And user requests changes with comment "Request Changes" on "Entities" page
    And user opens "My Area" from sidebar and navigates to "RequiresAmendmentTab" tab on "MyArea" page
    And user searches "RequireAmendenmentTestMultipleBU" in "RequiresAmendmentSearchBox" field on My Area page
    Then the table column "DataTemplateListViewButton2" on "DataTemplates" page should contain the following values:
      | OtherBUWith4EyeEnabled |
      | BUFor4EyeSingleInteger |
    When user clicks on "CommonTableViewBtn" button associate with text "OtherBUWith4EyeEnabled" on "Common"
    And user submits changes with comment "Submit", selects "Pending Approval", on "Entities" page
    And user opens a new My Area browser context, logs in as "UserForApproval", searches for entity "RequireAmendenmentTestMultipleBU" in Requires Review and performs "Approve" action
    And user opens "My Area" from sidebar and navigates to "RequiresAmendmentTab" tab on "MyArea" page
    When user clicks on "CommonTableViewBtn" button associate with text "BUFor4EyeSingleInteger" on "Common"
    And user submits changes with comment "Submit", selects "Pending Approval", on "Entities" page
    And user opens a new My Area browser context, logs in as "UserForApproval", searches for entity "RequireAmendenmentTestMultipleBU" in Requires Review and performs "Approve" action
