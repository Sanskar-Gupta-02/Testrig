@CLM @RiskOverRide @Regression
Feature: Risk Override

  Background:
    Given user login into the 'CLM' application with 'AdminUserName' user
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "Entities" on "Home"

  @Smoke
  Scenario: 001 Verify that user is able to override the risk score of an entity #ENG-T11040,T11041
    Then user should see 'Entities' on 'PageTitle' on 'Common' page
    When user enter "Risk Override - Do Not Touch" text in "EntitySearchBox" field on "RiskOverRide" page
    And user clicks on "EntityViewBtn" button associate with text "Risk Override - Do Not Touch" on "RiskOverRide"
    Then user should see 'Risk Override - Do Not Touch' on 'PageTitle' on 'Common' page
    When user clicks on "BusinessUnitsTab" button associate with text "Business Units" on "Entities"
    And user clicks on "SelectBU" button associate with text "Automation Do Not Touch" on "RiskOverRide"
    And user clicks on "RiskTab" button associate with text "Risk" on "RiskOverRide"
    And user clicks on "RiskOverrideBtn" button associate with text "Risk Override" on "RiskOverRide"
    Then user should see 'Risk Overrides' on 'RiskOverRidesTitle' on 'RiskOverRide' page
    When user clicks on "AddRiskOverRideBtn" on "RiskOverRide" page
    Then user should see 'Details' on 'RiskOverRideAddPage' on 'RiskOverRide' page
    And user should see 'Select a Risk Model' on 'SelectRiskLabel' on 'RiskOverRide' page
    And user should able see "SelectRiskDropDown" on "RiskOverRide" page
    And user should see 'Start Date' on 'StartDateLabel' on 'RiskOverRide' page
    And user should able see "StartDateInputBox" on "RiskOverRide" page
    And the field "StartDateInputBox" on "RiskOverRide" page should be "readonly"
    And user should see ' End Date ' on 'EndDateLabel' on 'RiskOverRide' page
    And user should able see "EndDateInputBox" on "RiskOverRide" page
    And user should see ' Risk Override Value ' on 'RiskOverRideLabel' on 'RiskOverRide' page
    And user should able see "RiskOverRIdeInputBox" on "RiskOverRide" page
    And user should see ' Note ' on 'NoteLabel' on 'RiskOverRide' page
    And user should able see "NoteInputBox" on "RiskOverRide" page
    When user clicks on "AddButton" on "RiskOverRide" page
    Then user should able see "ErrorBox" on "Common" page
    And user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Risk Model is required.                            |
      | Please Select as a selected option is not allowed. |
      | Risk Override Value is required.                   |
    When user selects value "API Automation RT Weighted Risk - API Automation RT Weighted Risk - Do Not Touch" from dropdown "SelectRiskDropDown" on page "RiskOverRide"
    Then user should see the following table columns in "RiskLevelTableHeader" on "RiskOverRide" page:
      | Risk Level |
      | Min. Value |
      | Max. Value |
    And the table column "RiskLevelLabels" on "RiskOverRide" page should contain the following values:
      | Very High |
      | High      |
      | Medium    |
      | Low       |
    And the table column "RiskLevelMinValue" on "RiskOverRide" page should contain the following values:
      |  0 |
      | 26 |
      | 51 |
      | 76 |
    And the table column "RiskLevelMaxValue" on "RiskOverRide" page should contain the following values:
      |  25 |
      |  50 |
      |  75 |
      | 100 |
    When user enter "10" text in "RiskOverRIdeInputBox" field on "RiskOverRide" page
    And user enter "Test Automation Pls Delete This" text in "NoteInputBox" field on "RiskOverRide" page
    And user clicks on "AddButton" on "RiskOverRide" page
    Then user should able to see next to fields on "SavedData" on "Common" page:
      | text                                                                             | fieldName           |
      |                                                                               10 | Risk Override Value |
      | Test Automation Pls Delete This                                                  | Note                |
      | API Automation RT Weighted Risk - API Automation RT Weighted Risk - Do Not Touch | Risk Model          |
    When user clicks on "ContinueBtn" button associate with text "Continue" on "RiskOverRide"
    Then user should see ' Risk Overrides ' on 'RiskOverRidesTitle' on 'RiskOverRide' page
    And user should not see "NoSearchResults" on "RiskOverRide" page
    Then user should see 'API Automation RT Weighted Risk' on 'RiskOverrideListItem' on 'RiskOverRide' page
    When user clicks on "AddRiskOverRideBtn" on "RiskOverRide" page
    And user selects value "API Automation RT Weighted Risk - API Automation RT Weighted Risk - Do Not Touch" from dropdown "SelectRiskDropDown" on page "RiskOverRide"
    And user enter "10" text in "RiskOverRIdeInputBox" field on "RiskOverRide" page
    And user clicks on "AddButton" on "RiskOverRide" page
    Then user should see the following validation errors for field "ErrorBoxItems" on "Common" page:
      | Risk Override already exists. Please archive the existing one and try again. |
    And user should see ' Risk Override already exists. Please archive the existing one and try again. ' on 'SelectBUErrorBox' on 'RiskOverRide' page
    When user clicks on "CancelBTN" on "RiskOverRide" page
    And user clicks on "RiskOverrideViewBtn" button associate with text "API Automation RT Weighted Risk" on "RiskOverRide"
    Then user should see ' Risk Override - API Automation RT Weighted Risk ' on 'RiskOverRideModalHeading' on 'RiskOverRide' page
    And user should able to see next to fields on "SavedData" on "Common" page:
      | text                            | fieldName           |
      | 10                              | Risk Override Value |
      | Test Automation Pls Delete This | Note                |
      | API Automation RT Weighted Risk | Risk Model          |
    And user clicks on "ArchiveButton" on "Common" page
    Then user should see ' Archive Risk Override ' on 'ArchiveRiskOverRideTitle' on 'RiskOverRide' page
    And user should see ' To archive the Risk Override, enter the name in the box below. ' on 'ArchiveModalDescription' on 'Common' page
    And user should see 'API Automation RT Weighted Risk' on 'ArchiveModalText' on 'Common' page
    When user enter "API Automation RT Weighted Risk" text in "ArchiveModalInputBox" field on "Common" page
    And user clicks on "ArchiveModalSubmitButton" on "Common" page
    Then user should see 'Archived' on 'ArchiveDSText' on 'RiskOverRide' page
    And user should see ' This item has been archived and cannot be used in the system. ' on 'ArchiveDSWarningMSG' on 'RiskOverRide' page

  @Smoke
  Scenario: 002 Risk Graph And Risk Models #ENG-T9726,T9727,T9728
    Then user should see ' Entities ' on 'PageTitle' on 'Common' page
    When user enter "Risk Override - Do Not Touch" text in "EntitySearchBox" field on "RiskOverRide" page
    And user clicks on "EntityViewBtn" button associate with text "Risk Override - Do Not Touch" on "RiskOverRide"
    Then user should see ' Risk Override - Do Not Touch ' on 'PageTitle' on 'Common' page
    When user clicks on "CommonBTN" button associate with text "Business Units" on "Common"
    And user clicks on "SelectBU" button associate with text "Automation Do Not Touch" on "RiskOverRide"
    And user clicks on "CommonBTN" button associate with text "Risk" on "Common"
    Then user should able see "RiskGraph" on "RiskOverRide" page
    When user clicks on "GraphRiskModelsListButton" button associate with text "API Automation RT Single Highest Value Risk" on "RiskOverRide"
    And user clicks on "GraphRiskModelsListButton" button associate with text "API Automation RT Single Highest Value Risk" on "RiskOverRide"
    Then user should able see "GraphListPoint" on "RiskOverRide" page
    When user clicks on "GraphRiskModelsListButton" button associate with text "API Automation RT Single Highest Value Risk" on "RiskOverRide"
    Then user should not see "GraphListPoint" on "RiskOverRide" page
    When user clicks on "GraphRiskModelsListButton" button associate with text "API Automation RT Total Risk" on "RiskOverRide"
    Then user should able see "GraphListPoint" on "RiskOverRide" page
    When user clicks on "GraphRiskModelsListButton" button associate with text "API Automation RT Total Risk" on "RiskOverRide"
    Then user should not see "GraphListPoint" on "RiskOverRide" page
    When user clicks on "GraphRiskModelsListButton" button associate with text "API Automation RT Weighted Risk" on "RiskOverRide"
    Then user should able see "GraphListPoint" on "RiskOverRide" page
