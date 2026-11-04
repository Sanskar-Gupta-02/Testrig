@Regression @EmailTemplate
Feature: Email Template

  Background:
    Given user login into 'REFIT' application with 'HandlerUserName' user
    And user is authorized using an 'APIKEY'

  @EmailTemplate01
  Scenario: 001 Verify that user can generate email template specific for Nominee, which will be sent to the client by selecting it in the Onboarding Type level #ENG-T1169,T1173,T1174,T1178,T1179,T1180,T1181,T1184,T4394,T4682,T5111,T5329
    When user search and open prospect with name:'EmailTemplateS01'
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'NomineesLink' on 'ManageProspect' page
    And user create a nominee with Nominee Email: 'testautomations+EmailTemplateS01N1@riskscreen.com', Email Template: 'Automation01', Allow Manage Nominee: 'Yes', Allow Manage Prospect: 'No', Notify Prospect:'No'
    And user checks Property Group or Data Document Type permission checkboxes
      | Property Group 1 |
    And user send data collection link to nominee with email: "testautomations+EmailTemplateS01N1@riskscreen.com"
    Then user should receive an email from: 'noreply@riskscreen.com' and to: 'testautomations+EmailTemplateS01N1@riskscreen.com' with subject: 'Nominee Email Template' and body containing text: 'Automation S01'
    When user navigate back
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'NomineesLink' on 'ManageProspect' page
    And user create a nominee with Nominee Email: 'testautomations+EmailTemplateS01N2@riskscreen.com', Email Template: 'Automation01WithVC', Allow Manage Nominee: 'Yes', Allow Manage Prospect: 'No', Notify Prospect:'No'
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

  @EmailTemplate02 @deleteOnboarding
  Scenario: 002 Custom eIDV email should be received by the prospect automatically on submitting the DCF if email template is chosen in the OB type. #ENG-T7302
    When user creates an onboarding for prospect "616166" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616166" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+EmailTemplateS02@riskscreen.com" email
    And user enter data in following fields in Refit DCF:
      | Field           | Value     |
      | Group1Property1 | EIDV Test |
      | Group1Property2 |        26 |
    And user clicks on 'ContinueButton' on 'Refit' page
    And user clicks on 'FormSubmissionCheckbox' on 'Refit' page
    And user clicks on 'FormSubmitButton' on 'Refit' page
    And user waits until submission process is completed
    # When user switch to 'Welcome to KYC360 (TEST)' page
    When user search and open prospect with name:'EmailTemplateS02'
    And user clicks on 'DataApprovalLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Approval' on Onboarding page
    And user clicks on 'ApproveOnboardingDataButton' on 'Onboarding' page
    Then user should receive an email on outlook from: 'noreply@riskscreen.com' and to: 'testautomations+EmailTemplateS02@riskscreen.com' with subject: 'EIDV Email' and body containing text: 'EIDV Email'
    When user clicks on 'RevertToDataCollectionButton' on 'Onboarding' page
    Then user should see success banner with message 'Onboarding stage reverted successfully.'
    #Required - #ENG-10320