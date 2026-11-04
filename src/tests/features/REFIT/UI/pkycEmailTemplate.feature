@Regression @EmailTemplate
Feature: Email Template

  Background:
    Given user login into 'REFIT' application with 'PkycHandlerUserName' user
    And user is authorized using an 'PKYCAPIKEY'

  @deleteAutocreatedOnboarding @deleteAutocreatedProspect
  Scenario: 001 Verify Email Template selected while configuring ANP setting should be received by the auto created prospect #ENG-T4942,T4940,T3922,T3924,T4063,T4877,T4941
    When user navigate to Onboarding type "AutomationS01"
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'PropertyGroup1' on 'OnboardingType' page
    And user clicks on 'PropectAutoCreationSetting1' on 'OnboardingType' page
    And user select "Automation01" option in "EmailTemplate" dropdown on "AutocreationSetting" page
    Then user should wait until email template gets updated in message box
    When user select "Create prospect, onboarding, data request and send data request from external form" option in "ActionDropdown" dropdown on "AutocreationSetting" page
    And user clicks on 'UpdateButton' on 'AutocreationSetting' page
    Then user should see success banner with message "Prospect autocreation setting updated successfully."
    When user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'pkycdataRequest'
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True",
      "ClientProspectID":"616254",
      "ClientOnboardingID":"354526",
      "DataRequestID":"5b91affb-7bf1-4ed7-9208-a1e3a06c7abb"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+Automation01@riskscreen.com" email
    And user enter data in following fields in Refit DCF:
      | Field            | Value                          |
      | Group1TextField  | AutocreatedProspectS01         |
      | Group1TextField2 | KYC                            |
      | Group1TextField3 |                            360 |
      | Group1TextField4 | testautomations@riskscreen.com |
    And user clicks on 'SaveButton' on 'Refit' page
    Then user should receive email from:"noreply@riskscreen.com" and to:"testautomations@riskscreen.com" and body should contains "AutocreationS01"
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'Automation01',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    Then user should see Autocreated prospect with name "KYC 360 AutocreatedProspectS01"
    When user delete Prospect Autocreation Status for prospect "KYC 360 AutocreatedProspectS01"
    #Cleanup
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreatedProspectS01',selects SearchOn:'Last name' and select prospect from list
    And user store 'ProspectId' with keyName:'autoProspectID' from 'Prospect' page
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user store 'OnboardingId' with keyName:'autoOnboardingID' from 'Onboarding' page
    And user navigate to Onboarding type "AutomationS01"
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'OBManageProspectGroup' on 'OnboardingType' page
    And user clicks on 'PropertyGroup1' on 'OnboardingType' page
    And user clicks on 'PropectAutoCreationSetting1' on 'OnboardingType' page
    And user select "(None)" option in "EmailTemplate" dropdown on "AutocreationSetting" page
    Then user should wait until email template gets updated in message box
    When user select "Create prospect from external form" option in "ActionDropdown" dropdown on "AutocreationSetting" page
    And user clicks on 'UpdateButton' on 'AutocreationSetting' page
    Then user should see success banner with message "Prospect autocreation setting updated successfully."

  @pkycEmailTemplate02
  Scenario: 002 Verify that user can generate email template specific for Nominee, which will be sent to the client by selecting it in the Onboarding Type level #ENG-T3995,T4925
    When user search and open prospect with name:'EmailTemplateS01'
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'NomineesLink' on 'ManageProspect' page
    And user create a nominee with Nominee Email: 'testautomations+EmailTemplateS01N1@riskscreen.com', Email Template: 'EmailTemplate02', Allow Manage Nominee: 'Yes', Allow Manage Prospect: 'No', Notify Prospect:'No'
    And user checks Property Group or Data Document Type permission checkboxes
      | Property Group 1 |
    And user send data collection link to nominee with email: "testautomations+EmailTemplateS01N1@riskscreen.com"
    Then user should receive an email from: 'noreply@riskscreen.com' and to: 'testautomations+EmailTemplateS01N1@riskscreen.com' with subject: 'Nominee Email Template' and body containing text: 'Automation S01'
    When user navigate back
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'NomineesLink' on 'ManageProspect' page
    And user create a nominee with Nominee Email: 'testautomations+EmailTemplateS01N2@riskscreen.com', Email Template: 'EmailTemplate02WithVC', Allow Manage Nominee: 'Yes', Allow Manage Prospect: 'No', Notify Prospect:'No'
    And user checks Property Group or Data Document Type permission checkboxes
      | Property Group 2 |
    And user send data collection link to nominee with email: "testautomations+EmailTemplateS01N2@riskscreen.com"
    Then user should receive an email from: 'noreply@riskscreen.com' and to: 'testautomations+EmailTemplateS01N2@riskscreen.com' with subject: 'Nominee Email Template with VC' and body containing text: 'Nominee Email Template with VC'
    When user open the data collection link in new tab
    And user clicks on 'SendVerificationCodeButton' on 'Refit' page
    Then user should receive an email from: 'noreply@riskscreen.com' and to: 'testautomations+EmailTemplateS01N2@riskscreen.com' with subject: 'Verification Code' and body containing text: 'Nominee VC'
    #Revert
    When user switch to 'Data Request Nominees' page
    And user delete nominee with email: 'testautomations+EmailTemplateS01N1@riskscreen.com'
    And user delete nominee with email: 'testautomations+EmailTemplateS01N2@riskscreen.com'
    # Defect Raised: ENG-T9131