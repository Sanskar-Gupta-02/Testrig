@ResponsiveAndRiskRule @Regression
Feature: External DCF Refit

  Background:
    Given user login to kyc360 with 'HandlerUserName' user
    And user is authorized using an 'APIKEY'

  @deleteOnboarding @ResponsiveAndRiskRule1
  Scenario: 001 Verify visibility behaviors with Show/Hide Initially and Responsive Rule triggers within a section. #ENG-T10587
    #User Linked Prospect with Hide Initially to Group 1 Property2 and Show Initially to Group 2 Property 2 
    When user store value:'608883' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    When user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+ResponsiveRuleS1@riskscreen.com" email
    Then user should see "Group 1" text in "PageTitle" field on "Refit" page
    And user should able see "Group1TextField" on "Refit" page
    And user should not see "Group1TextField2" on "Refit" page
    When user enter "18" text in "Group1TextField" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should able see "Group1TextField2" on "Refit" page
    And user should see "Group 2" text in "PageTitle2" field on "Refit" page
    And user should able see "Group2Property2" on "Refit" page
    When user enter "India" text in "Group2Property1" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should not see "Group2Property2" on "Refit" page

  @deleteOnboarding @ResponsiveAndRiskRule2
  Scenario: 002 Verify Property Group with only responsive properties should fully toggle visibility based on responsive trigger and hide Document.#ENG-T10590
    When user store value:'608893' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    When user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+RefitResponsiveRuleS2@riskscreen.com" email
    Then user should see "Group 1" text in "PageTitle" field on "Refit" page
    And user should see "Group 1" text in "SummaryTabPG1" field on "Refit" page
    And user should not be able to see "Group 2" text in "SummaryTabPG2" field on "Refit" page
    And user should see "Group 3" text in "SummaryTabPG2" field on "Refit" page
    And user should see "Documents" text in "SummaryTabPG3" field on "Refit" page
    And user should see "Summary" text in "SummaryTabPG4" field on "Refit" page
    When user select "Yes" option in "DropdownField" dropdown on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should see "Group 2" text in "SummaryTabPG2" field on "Refit" page
    And user should see "Group 3" text in "SummaryTabPG3" field on "Refit" page
    And user should see "Documents" text in "SummaryTabPG4" field on "Refit" page
    When user clicks on "ContinueButton" on "Refit" page
    Then user should see "Group 2" text in "PageTitle" field on "Refit" page
    When user select "No" option in "DropdownField" dropdown on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user enter "2001-02-02" text in "Group2DateField2" field on 'Refit' page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should see "Group 1" text in "SummaryTabPG1" field on "Refit" page
    And user should see "Group 2" text in "SummaryTabPG2" field on "Refit" page
    And user should not be able to see "Group 3" text in "SummaryTabPG3" field on "Refit" page
    And user should not be able to see "Documents" text in "SummaryTabPG3" field on "Refit" page
    And user should see "Summary" text in "SummaryTabPG3" field on "Refit" page

  @deleteOnboarding @ResponsiveAndRiskRule3
  Scenario: 003 Verify Responsive rule for multiple set of Conditions. #ENG-T10609
    When user store value:'609056' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    When user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    #OBType = ResponsiveRuleS3(DoNotTouch)
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+ztrail@riskscreen.com" email
    Then user should see "Group 1 Integer" text in "GroupTitle1" field on "Refit" page
    And user should able see "Group1Property1" on "Refit" page
    And user should able see "Group1Property2" on "Refit" page
    And user should not see "Result1" on "Refit" page
    When user enter "10" text in "Group1Property1" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user enter "5" text in "Group1Property2" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should able see "Result1" on "Refit" page
    And user should see "Group 2 Text" text in "GroupTitle2" field on "Refit" page
    And user should able see "Group2Property1" on "Refit" page
    And user should able see "Group2Property2" on "Refit" page
    And user should not see "Result2" on "Refit" page
    When user enter "#" text in "Group2Property1" field on "Refit" page
    And user enter "10#" text in "Group2Property2" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should able see "Result2" on "Refit" page
    And user should see "Group 3 Decimal" text in "GroupTitle3" field on "Refit" page
    And user should able see "Group3Property1" on "Refit" page
    And user should able see "Group3Property2" on "Refit" page
    And user should not see "Result3" on "Refit" page
    When user enter "5" text in "Group3Property1" field on "Refit" page
    And user enter "3" text in "Group3Property2" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should able see "Result3" on "Refit" page
    And user should see "Group 4 List" text in "GroupTitle4" field on "Refit" page
    And user should able see "Group4Property1" on "Refit" page
    And user should able see "Group4Property2" on "Refit" page
    And user should not see "Result4" on "Refit" page
    When user select "Yes" option in "Group4Property1" dropdown on "Refit" page
    And user select "Yes" option in "Group4Property2" dropdown on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should able see "Result4" on "Refit" page
    And user should see "Group 5 Date" text in "GroupTitle5" field on "Refit" page
    And user should able see "Group5Property1" on "Refit" page
    And user should not see "Result5" on "Refit" page
    And user should see "Group 1 Integer" text in "GroupTitle1" field on "Refit" page
    When user enters a date "2000-06-02" text in "Group5Property1" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should able see "Result5" on "Refit" page

  @ResponsiveAndRiskRule4 @deleteOnboarding
  Scenario: 004 Validate for property group and it's property visibility for hide initially, and progress bar update on responsive trigger. #ENG-T10633
    #OBType:ResponsiveRuleS4(DoNotTouch)
    When user store value:'609128' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    When user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+ResponsiveRuleS4@riskscreen.com" email
    Then user should see "Group 1" text in "SummaryTabPG1" field on "Refit" page
    And user should not be able to see "Group 3" text in "SummaryTabPG2" field on "Refit" page
    And user should see "0% complete" text in "FormProgressPercentage" field on "Refit" page
    And user should see "Group 1" text in "GroupTitle1" field on "Refit" page
    And user should not see "GroupTitle2" on "Refit" page
    And user should not see "Group2Property1" on "Refit" page
    And user should see "If you enter Yes Property Group 2 will be Displayed in same Section." text in "Group1Property1Label" field on "Refit" page
    When user enter "No" text in "Group1Property1" field on "Refit" page
    And user enter "No" text in "Group1Property2" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on "ContinueButton" on "Refit" page
    Then user should see "95% complete" text in "FormProgressPercentage" field on "Refit" page
    When user wait from 3 seconds
    And user clicks on "SummaryTabPG1" on "Refit" page
    And user enter "Yes" text in "Group1Property1" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should see "0% complete" text in "FormProgressPercentage" field on "Refit" page
    And user should see "Group 2" text in "GroupTitle2" field on "Refit" page
    And user should able see "Group2Property1" on "Refit" page
    And user should not see "Group2Property2" on "Refit" page
    When user enter "Hello-Automation" text in "Group2Property1" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should see "If you enter Yes Property Group 3 will be Displayed in different Section." text in "Group1Property2Label" field on "Refit" page
    When user enter "Yes" text in "Group1Property2" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should see "Group 3" text in "SummaryTabPG2" field on "Refit" page
    When user clicks on "ContinueButton" on "Refit" page
    Then user should see "50% complete" text in "FormProgressPercentage" field on "Refit" page
    When user enter "Hello-Automation2" text in "Group3TextField1" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should see "50% complete" text in "FormProgressPercentage" field on "Refit" page
    When user clicks on "ContinueButton" on "Refit" page
    Then user should see "50% complete" text in "FormProgressPercentage" field on "Refit" page

  @ResponsiveAndRiskRule5
  Scenario: 005 SHV risk model type should calculate risk score correctly when risk is assigned to single or multiple properties. #ENG-T9218
    #OBType:RefitResponsiveAndRiskRuleS5(DoNotTouch)
    When user store value:'609137' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    When user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+RefitResponsiveAndRiskRuleS5@riskscreen.com" email
    Then user should see "Group 1" text in "PageTitle" field on "Refit" page
    When user enter "20" text in "Group1Property1" field on "Refit" page
    And user enter "50.00" text in "Group1Property2" field on "Refit" page
    And user enter "20" text in "Group2Property1" field on "Refit" page
    And user clicks on "ContinueButton" on "Refit" page
    And user clicks on "FormSubmissionCheckbox" on "Refit" page
    And user clicks on "FormSubmitButton" on "Refit" page
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ResponsiveAndRiskRuleS5',selects SearchOn:'Last name' and select prospect from list
    And user clicks on "DataApprovalLink" on "ManageProspect" page
    And user clicks on Onboarding Stage Tab with text "Risk Assessment" on Onboarding page
    Then user should see "Low" text in "Property1RiskScore" field on "Onboarding" page
    And user should see "Standard" text in "Property2RiskScore" field on "Onboarding" page
    And user should see "Low" text in "G2Property3RiskScore" field on "Onboarding" page
    And user should see "Standard" text in "AutomatedRiskScore" field on "Onboarding" page
    When user clicks on Onboarding Stage Tab with text "Data Approval" on Onboarding page
    And user clicks on "RejectOnboardingData" on "Onboarding" page
    When user clicks on Onboarding Stage Tab with text "Data Collection Requests" on Onboarding page
    And user clicks on "SendLink" on "ManageProspect" page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+RefitResponsiveAndRiskRuleS5@riskscreen.com" email
    And user enter "40" text in "Group1Property1" field on "Refit" page
    And user enter "90.00" text in "Group1Property2" field on "Refit" page
    And user enter "75" text in "Group2Property1" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user wait until autocreation process is complete
    And user clicks on "ContinueButton" on "Refit" page
    And user clicks on "FormSubmissionCheckbox" on "Refit" page
    And user clicks on "FormSubmitButton" on "Refit" page
    And user wait from 5 seconds
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ResponsiveAndRiskRuleS5',selects SearchOn:'Last name' and select prospect from list
    And user clicks on "DataApprovalLink" on "ManageProspect" page
    And user clicks on Onboarding Stage Tab with text "Risk Assessment" on Onboarding page
    Then user should see "Very High" text in "AutomatedRiskScore" field on "Onboarding" page
    And user should see "Standard" text in "Property1RiskScore" field on "Onboarding" page
    And user should see "Very High" text in "Property2RiskScore" field on "Onboarding" page
    And user should see "High" text in "G2Property3RiskScore" field on "Onboarding" page

  @deleteOnboarding @ResponsiveAndRiskRule6
  Scenario: 006 Verify risk calculation for each data type including Date, Decimal, List, and Integer. #ENG-T9224
    #OBType:RefitResponsiveAndRiskRuleS6(DoNotTouch)
    When user store value:'609145' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+ResponsiveAndRiskRuleS6@riskscreen.com" email
    Then user should see "Group 1" text in "PageTitle" field on "Refit" page
    When user enter "20" text in "Group1Property1" field on "Refit" page
    And user enter "50.00" text in "Group1Property2" field on "Refit" page
    And user clicks on "DropdownProperty4" on "Refit" page
    And user select "Yes" option in "DropdownProperty4" dropdown on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user enters a date "2020-12-12" text in "Group1Property3" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on "ContinueButton" on "Refit" page
    And user clicks on "FormSubmissionCheckbox" on "Refit" page
    And user clicks on "FormSubmitButton" on "Refit" page
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ResponsiveAndRiskRuleS6',selects SearchOn:'Last name' and select prospect from list
    And user clicks on "DataApprovalLink" on "ManageProspect" page
    And user clicks on Onboarding Stage Tab with text "Risk Assessment" on Onboarding page
    Then user should see "Standard" text in "Property1RiskScore" field on "Onboarding" page
    And user should see "Standard" text in "Property2RiskScore" field on "Onboarding" page
    And user should see "Standard" text in "Property3RiskScore" field on "Onboarding" page
    And user should see "Low" text in "Property4RiskScore" field on "Onboarding" page
    And user should see "Standard" text in "AutomatedRiskScore" field on "Onboarding" page
    And user clicks on Onboarding Stage Tab with text "Data Approval" on Onboarding page
    When user clicks on "RejectOnboardingData" on "Onboarding" page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+ResponsiveAndRiskRuleS6@riskscreen.com" email
    And user enter "75" text in "Group1Property1" field on "Refit" page
    And user enter "95.00" text in "Group1Property2" field on "Refit" page
    And user select "No" option in "DropdownProperty4" dropdown on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user enters a date "1999-11-22" text in "Group1Property3" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on "ContinueButton" on "Refit" page
    And user clicks on "FormSubmissionCheckbox" on "Refit" page
    And user clicks on "FormSubmitButton" on "Refit" page
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ResponsiveAndRiskRuleS6',selects SearchOn:'Last name' and select prospect from list
    And user clicks on "DataApprovalLink" on "ManageProspect" page
    And user clicks on Onboarding Stage Tab with text "Risk Assessment" on Onboarding page
    Then user should see "High" text in "Property1RiskScore" field on "Onboarding" page
    And user should see "High" text in "Property2RiskScore" field on "Onboarding" page
    And user should see "High" text in "Property3RiskScore" field on "Onboarding" page
    And user should see "Standard" text in "Property4RiskScore" field on "Onboarding" page
    And user should see "High" text in "AutomatedRiskScore" field on "Onboarding" page

  @deleteOnboarding @ResponsiveAndRiskRule7
  Scenario: 007 WRM risk model in the onboarding journey should correctly calculate the risk score when assigned to one or more properties.#ENG-T9218
    #OBType:RefitResponsiveAndRiskRuleS7
    When user store value:'609193' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+RefitResponsiveAndRiskRuleS7@riskscreen.com" email
    Then user should see "Group 1" text in "PageTitle" field on "Refit" page
    When user enter "70" text in "Group1Property1" field on "Refit" page
    And user enter "50.00" text in "Group1Property2" field on "Refit" page
    And user enter "75.00" text in "Group1Property3" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on "ContinueButton" on "Refit" page
    And user clicks on "FormSubmissionCheckbox" on "Refit" page
    And user clicks on "FormSubmitButton" on "Refit" page
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'RefitResponsiveAndRiskRuleS7',selects SearchOn:'Last name' and select prospect from list
    And user clicks on "DataApprovalLink" on "ManageProspect" page
    And user clicks on Onboarding Stage Tab with text "Notes" on Onboarding page
    And user select "Weighted Risk Score" option in "RiskModelType" dropdown on "Onboarding" page
    And user clicks on "SaveRiskModelButton" on "Onboarding" page
    And user clicks on Onboarding Stage Tab with text "Risk Assessment" on Onboarding page
    Then user should see "High" text in "AutomatedRiskScore" field on "Onboarding" page
    And user should see "20" text in "WRMProperty1RiskScore" field on "Onboarding" page
    And user should see "10" text in "WRMProperty1WeightedRiskScore" field on "Onboarding" page
    And user should see "50" text in "WRMProperty2RiskScore" field on "Onboarding" page
    And user should see "25" text in "WRMProperty2WeightedRiskScore" field on "Onboarding" page
    And user should see "75" text in "WRMProperty3RiskScore" field on "Onboarding" page
    And user should see "56.3" text in "WRMProperty3WeightedRiskScore" field on "Onboarding" page
    And user should see "91.3" text in "WRMTotalRiskScore" field on "Onboarding" page
    And user should see "175" text in "WRMTotalPossibleRiskScore" field on "Onboarding" page
    And user should see "52%" text in "WRMNormalisedRiskScore" field on "Onboarding" page
    And user should see "High" text in "WRMNormalisedRiskScoreBand" field on "Onboarding" page
    And user clicks on Onboarding Stage Tab with text "Data Approval" on Onboarding page
    When user clicks on "RejectOnboardingData" on "Onboarding" page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+RefitResponsiveAndRiskRuleS7@riskscreen.com" email
    And user enter "20" text in "Group1Property1" field on "Refit" page
    And user enter "25.00" text in "Group1Property2" field on "Refit" page
    And user enter "30.00" text in "Group1Property3" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on "ContinueButton" on "Refit" page
    And user clicks on "FormSubmissionCheckbox" on "Refit" page
    And user clicks on "FormSubmitButton" on "Refit" page
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'RefitResponsiveAndRiskRuleS7',selects SearchOn:'Last name' and select prospect from list
    And user clicks on "DataApprovalLink" on "ManageProspect" page
    And user clicks on Onboarding Stage Tab with text "Risk Assessment" on Onboarding page
    Then user should see "Standard" text in "AutomatedRiskScore" field on "Onboarding" page
    And user should see "10" text in "WRMProperty1RiskScore" field on "Onboarding" page
    And user should see "5" text in "WRMProperty1WeightedRiskScore" field on "Onboarding" page
    And user should see "25" text in "WRMProperty2RiskScore" field on "Onboarding" page
    And user should see "12.5" text in "WRMProperty2WeightedRiskScore" field on "Onboarding" page
    And user should see "50" text in "WRMProperty3RiskScore" field on "Onboarding" page
    And user should see "37.5" text in "WRMProperty3WeightedRiskScore" field on "Onboarding" page
    And user should see "55" text in "WRMTotalRiskScore" field on "Onboarding" page
    And user should see "175" text in "WRMTotalPossibleRiskScore" field on "Onboarding" page
    And user should see "31%" text in "WRMNormalisedRiskScore" field on "Onboarding" page
    And user should see "Standard" text in "WRMNormalisedRiskScoreBand" field on "Onboarding" page

  @deleteOnboarding @ResponsiveAndRiskRule8
  Scenario: 008 User should receive default risk score when SVM risk model is configured. #ENG-T10747
   #OBType:RefitResponsiveAndRiskRuleS8
    When user store value:'609199' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+RefitResponsiveAndRiskRuleS8@riskscreen.com" email
    Then user should see "Group 1" text in "PageTitle" field on "Refit" page
    When user enter "20" text in "Group1Property1" field on "Refit" page
    And user enter "25" text in "Group1Property2" field on "Refit" page
    And user enter "30.00" text in "Group1Property3" field on "Refit" page
    And user enter "45.00" text in "Group1Property4" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on "ContinueButton" on "Refit" page
    And user clicks on "FormSubmissionCheckbox" on "Refit" page
    And user clicks on "FormSubmitButton" on "Refit" page
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'RefitResponsiveAndRiskRuleS8',selects SearchOn:'Last name' and select prospect from list
    Then user should see "High" text in "OnboardingRiskScore" field on "Prospect" page
    When user clicks on "DataApprovalLink" on "ManageProspect" page
    And user clicks on Onboarding Stage Tab with text "Risk Assessment" on Onboarding page
    Then user should see "Low" text in "Property1RiskScore" field on "Onboarding" page
    And user should see "Standard" text in "Property2RiskScore" field on "Onboarding" page
    And user should see "default risk score" text in "Property2RiskScoreAttribute" field on "Onboarding" page
    And user should see "Standard" text in "Property3RiskScore" field on "Onboarding" page
    And user should see "Very High" text in "Property4RiskScore" field on "Onboarding" page
    And user should see "default risk score" text in "Property4RiskScoreAttribute" field on "Onboarding" page
    And user should see "Very High" text in "AutomatedRiskScore" field on "Onboarding" page
    And user clicks on Onboarding Stage Tab with text "Data Approval" on Onboarding page
    When user clicks on "RejectOnboardingData" on "Onboarding" page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+RefitResponsiveAndRiskRuleS8@riskscreen.com" email
    And user enter "75" text in "Group1Property1" field on "Refit" page
    And user enter "65" text in "Group1Property2" field on "Refit" page
    And user enter "25.00" text in "Group1Property3" field on "Refit" page
    And user enter "35.00" text in "Group1Property4" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on "ContinueButton" on "Refit" page
    And user clicks on "FormSubmissionCheckbox" on "Refit" page
    And user clicks on "FormSubmitButton" on "Refit" page
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'RefitResponsiveAndRiskRuleS8',selects SearchOn:'Last name' and select prospect from list
    Then user should see "High" text in "OnboardingRiskScore" field on "Prospect" page
    When user clicks on "DataApprovalLink" on "ManageProspect" page
    And user clicks on Onboarding Stage Tab with text "Risk Assessment" on Onboarding page
    Then user should see "Low" text in "Property1RiskScore" field on "Onboarding" page
    And user should see "default risk score" text in "Property1RiskScoreAttribute" field on "Onboarding" page
    And user should see "High" text in "Property2RiskScore" field on "Onboarding" page
    And user should see "High" text in "Property3RiskScore" field on "Onboarding" page
    And user should see "default risk score" text in "Property3RiskScoreAttribute" field on "Onboarding" page
    And user should see "Standard" text in "Property4RiskScore" field on "Onboarding" page
    And user should see "High" text in "AutomatedRiskScore" field on "Onboarding" page

  @deleteOnboarding @ResponsiveAndRiskRule9
  Scenario: 009 User should receive default risk score when WRM risk model is configured.#ENG-T10753
   #OBType:RefitResponsiveAndRiskRuleS9
    When user store value:'609209' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+RefitResponsiveAndRiskRuleS9@riskscreen.com" email
    Then user should see "Group 1" text in "PageTitle" field on "Refit" page
    When user enter "23" text in "Group1Property1" field on "Refit" page
    And user enter "38" text in "Group1Property2" field on "Refit" page
    And user enter "65" text in "Group1Property3" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on "ContinueButton" on "Refit" page
    And user clicks on "FormSubmissionCheckbox" on "Refit" page
    And user clicks on "FormSubmitButton" on "Refit" page
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'RefitResponsiveAndRiskRuleS9',selects SearchOn:'Last name' and select prospect from list
    Then user should see "High" text in "OnboardingRiskScore" field on "Prospect" page
    When user clicks on "DataApprovalLink" on "ManageProspect" page
    And user clicks on Onboarding Stage Tab with text "Notes" on Onboarding page
    And user select "Weighted Risk Score" option in "RiskModelType" dropdown on "Onboarding" page
    And user clicks on "SaveRiskModelButton" on "Onboarding" page
    And user clicks on Onboarding Stage Tab with text "Risk Assessment" on Onboarding page
    Then user should see "High" text in "AutomatedRiskScore" field on "Onboarding" page
    And user should see "50" text in "WRMProperty1RiskScore" field on "Onboarding" page
    And user should see "default risk score" text in "Property1RiskScoreAttribute" field on "Onboarding" page
    And user should see "37.5" text in "WRMProperty1WeightedRiskScore" field on "Onboarding" page
    And user should see "60" text in "WRMProperty2RiskScore" field on "Onboarding" page
    And user should see "default risk score" text in "Property2RiskScoreAttribute" field on "Onboarding" page
    And user should see "36" text in "WRMProperty2WeightedRiskScore" field on "Onboarding" page
    And user should see "75" text in "WRMProperty3RiskScore" field on "Onboarding" page
    And user should see "default risk score" text in "Property3RiskScoreAttribute" field on "Onboarding" page
    And user should see "75" text in "WRMProperty3WeightedRiskScore" field on "Onboarding" page
    And user should see "148.5" text in "WRMTotalRiskScore" field on "Onboarding" page
    And user should see "235" text in "WRMTotalPossibleRiskScore" field on "Onboarding" page
    And user should see "63%" text in "WRMNormalisedRiskScore" field on "Onboarding" page
    And user should see "High" text in "WRMNormalisedRiskScoreBand" field on "Onboarding" page
    When user clicks on Onboarding Stage Tab with text "Notes" on Onboarding page
    And user select "Weighted Risk Score" option in "RiskModelType" dropdown on "Onboarding" page
    And user clicks on "SaveRiskModelButton" on "Onboarding" page
    And user clicks on Onboarding Stage Tab with text "Data Approval" on Onboarding page
    And user clicks on "RejectOnboardingData" on "Onboarding" page
    # And user get the data link and open
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+RefitResponsiveAndRiskRuleS9@riskscreen.com" email
    And user enter "15" text in "Group1Property1" field on "Refit" page
    And user enter "30" text in "Group1Property2" field on "Refit" page
    And user enter "50" text in "Group1Property3" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user clicks on "ContinueButton" on "Refit" page
    And user clicks on "FormSubmissionCheckbox" on "Refit" page
    And user clicks on "FormSubmitButton" on "Refit" page
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'RefitResponsiveAndRiskRuleS9',selects SearchOn:'Last name' and select prospect from list
    Then user should see "Low" text in "OnboardingRiskScore" field on "Prospect" page
    When user clicks on "DataApprovalLink" on "ManageProspect" page
    And user clicks on Onboarding Stage Tab with text "Risk Assessment" on Onboarding page
    Then user should see "Low" text in "AutomatedRiskScore" field on "Onboarding" page
    And user should see "10" text in "WRMProperty1RiskScore" field on "Onboarding" page
    And user should not see "Property1RiskScoreAttribute" on "Onboarding" page
    And user should see "7.5" text in "WRMProperty1WeightedRiskScore" field on "Onboarding" page
    And user should see "20" text in "WRMProperty2RiskScore" field on "Onboarding" page
    And user should not see "Property1RiskScoreAttribute" on "Onboarding" page
    And user should see "12" text in "WRMProperty2WeightedRiskScore" field on "Onboarding" page
    And user should see "30" text in "WRMProperty3RiskScore" field on "Onboarding" page
    And user should not see "Property1RiskScoreAttribute" on "Onboarding" page
    And user should see "30" text in "WRMProperty3WeightedRiskScore" field on "Onboarding" page
    And user should see "49.5" text in "WRMTotalRiskScore" field on "Onboarding" page
    And user should see "235" text in "WRMTotalPossibleRiskScore" field on "Onboarding" page
    And user should see "21%" text in "WRMNormalisedRiskScore" field on "Onboarding" page
    And user should see "Low" text in "WRMNormalisedRiskScoreBand" field on "Onboarding" page

  @deleteOnboarding @ResponsiveAndRiskRule10
  Scenario: 010 User should be able get Responsive and Risk Rule triggered correctly when configured with Single Highest Value. #ENG-T10754
    #OBType:RefitResponsiveAndRiskRuleS10
    When user store value:'609929' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    When user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+RefitResponsiveAndRiskRuleS10@riskscreen.com" email
    And user should see "Group 1" text in "SummaryTabPG1" field on "Refit" page
    And user should not be able to see "Group 2" text in "SummaryTabPG2" field on "Refit" page
    And user should see "Summary" text in "SummaryTabPG2" field on "Refit" page
    When user selects data in following fields in Refit DCF:
      | Field           | Value       |
      | Group1Property1 | Afghanistan |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should see "Group 2" text in "SummaryTabPG2" field on "Refit" page
    When user clicks on "ContinueButton" on "Refit" page
    Then user should able see "Group2TextField1" on "Refit" page
    And user should able see "Group2TextField2" on "Refit" page
    And user enter data in following fields in Refit DCF:
      | Field            | Value |
      | Group2TextField1 | Hide  |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should not see "Group2TextField2" on "Refit" page

  @deleteOnboarding @ResponsiveAndRiskRule11
  Scenario: 011 Responsive Rule should work as expected on Property Group with Show Initially and Hide Initially #ENG-T9170,T9171
    #Trigger Group Property = 20 Show Property Group 1, Trigger Group Property > 30 Hide Property Group 2
    When user store value:'615337' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+ResponsiveRuleS11@riskscreen.com" email
    And user navigate to 'Property Group 2' section on refit DCF
    Then user should not be able to see "Property Group 1" text in "FormContainer" field on "Refit" page
    When user navigate to 'Trigger Group' section on refit DCF
    And user enter data in following fields in Refit DCF:
      | Field           | Value |
      | Group1Property1 |    20 |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    And user navigate to 'Property Group 1' section on refit DCF
    Then user should see "Property Group 1" text in "FormContainer" field on "Refit" page
    And user should see "Property Group 2" text in "FormContainer" field on "Refit" page
    When user navigate to 'Trigger Group' section on refit DCF
    And user enter data in following fields in Refit DCF:
      | Field           | Value |
      | Group1Property1 |    40 |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should not see 'Property Group 1' section on refit DCF
    And user should not see 'Property Group 2' section on refit DCF

  @deleteOnboarding @ResponsiveAndRiskRule12
  Scenario: 012 Responsive Rule should work as expected on Property with Show Initially and Hide Initially #ENG-T9172,T9173
    #Trigger Group Property = 20 Show Hidden Initially, Trigger Group Property < 10 Hide Shown Initially
    When user store value:'615361' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+ResponsiveRuleS12@riskscreen.com" email
    And user navigate to 'Trigger Group' section on refit DCF
    Then user should see "Shown Initially" text in "PropertyField2Name" field on "Refit" page
    When user enter data in following fields in Refit DCF:
      | Field           | Value |
      | Group1Property1 |    20 |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should see "Hidden Initially" text in "PropertyField2Name" field on "Refit" page
    And user should see "Shown Initially" text in "PropertyField3Name" field on "Refit" page
    When user enter data in following fields in Refit DCF:
      | Field           | Value |
      | Group1Property1 |     2 |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should not see "PropertyField2Name" on "Refit" page
    And user should not see "PropertyField3Name" on "Refit" page

  @deleteOnboarding @ResponsiveAndRiskRule13
  Scenario: 013 Responsive Rule should work as expected on Property Group with Show Initially and Hide Initially. #ENG-T9172,T9173
    When user store value:'615392' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+ResponsiveRuleS13@riskscreen.com" email
    And user navigate to 'Trigger Group' section on refit DCF
    When user selects data in following fields in Refit DCF:
      | Field           | Value |
      | Group1Property1 |     4 |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should see following Property Groups:
      | Property Groups  |
      | Trigger Group    |
      | Property Group 1 |
      | Property Group 2 |
      | Property Group 3 |
      | Property Group 4 |
    When user selects data in following fields in Refit DCF:
      | Field           | Value |
      | Group1Property1 |     4 |
      | Group4Property4 | Yes   |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should able see "Group4Property4" on "Refit" page
    When user selects data in following fields in Refit DCF:
      | Field           | Value |
      | Group1Property1 |       |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should not see following Property Groups:
      | Property Groups  |
      | Property Group 2 |
      | Property Group 3 |
      | Property Group 4 |
    Then user should not see "Group4Property4" on "Refit" page
    When user selects data in following fields in Refit DCF:
      | Field           | Value |
      | Group1Property1 |     4 |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should able see "Group4Property4" on "Refit" page

  @deleteOnboarding @ResponsiveAndRiskRule14
  Scenario: 014 Responsive Rule should work as expected on Property with linking of multiple Groups in same section. #ENG-T13687
    When user store value:'615412' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+ResponsiveRuleS14@riskscreen.com" email
    And user navigate to 'Property Group 1' section on refit DCF
    And user selects data in following fields in Refit DCF:
      | Field           | Value |
      | Group1Property1 |     1 |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should see following Property Groups:
      | Property Groups  |
      | Property Group 1 |
      | Property Group 2 |
    And user should not see following Property Groups:
      | Property Groups  |
      | Property Group 3 |
      | Property Group 4 |
    When user selects data in following fields in Refit DCF:
      | Field           | Value |
      | Group2Property1 | Yes   |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should see following Property Groups:
      | Property Groups  |
      | Property Group 1 |
      | Property Group 2 |
      | Property Group 3 |
    And user should not see following Property Groups:
      | Property Groups  |
      | Property Group 4 |
    When user selects data in following fields in Refit DCF:
      | Field           | Value |
      | Group3Property1 | Yes   |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should see following Property Groups:
      | Property Groups  |
      | Property Group 1 |
      | Property Group 2 |
      | Property Group 3 |
      | Property Group 4 |
    And user should able see "Group4Property1" on "Refit" page
    When user selects data in following fields in Refit DCF:
      | Field           | Value |
      | Group3Property1 |       |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should not see following Property Groups:
      | Property Groups  |
      | Property Group 4 |
    And user should not see "Group4Property1" on "Refit" page
    When user selects data in following fields in Refit DCF:
      | Field           | Value |
      | Group2Property1 |       |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should not see following Property Groups:
      | Property Groups  |
      | Property Group 4 |
      | Property Group 3 |
    And user should not see "Group4Property1" on "Refit" page
    When user selects data in following fields in Refit DCF:
      | Field           | Value |
      | Group1Property1 |       |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should not see following Property Groups:
      | Property Groups  |
      | Property Group 2 |
      | Property Group 3 |
      | Property Group 4 |

  @deleteOnboarding @ResponsiveAndRiskRule15
  Scenario: 015 Responsive Rule should work as expected with Not equal to condition. #ENG-T13686
    When user store value:'615415' with keyName:'prospectID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user add payload "ClientOnboardingID" with the stored key value "onboardingID"
    And user add payload "DataRequestID" with the stored key value "dataRequestID"
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+ResponsiveRuleS15@riskscreen.com" email
    Then user should see following Property Groups:
      | Property Groups  |
      | Trigger Group    |
      | Property Group 1 |
    When user selects data in following fields in Refit DCF:
      | Field           | Value |
      | Group1Property1 | b     |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should not see following Property Groups:
      | Property Groups  |
      | Property Group 1 |
    When user enter data in following fields in Refit DCF:
      | Field           | Value |
      | Group1Property2 |    10 |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should see following Property Groups:
      | Property Groups  |
      | Trigger Group    |
      | Property Group 2 |
    When user enter data in following fields in Refit DCF:
      | Field           | Value |
      | Group1Property2 |    20 |
    And user clicks on 'SaveButton' on 'Refit' page
    And user waits until the saving process is completed
    Then user should not see following Property Groups:
      | Property Groups  |
      | Property Group 2 |
