@Regression @EmailTemplate
Feature: WLWP Disabled Email Template

  Background:
    Given user login into 'REFIT' application with 'WLWPDisabledHandlerUserName' user

    @WLWPDisabledEmailTemplate01
  Scenario: 001 Verify standard email template for verification code-staff, verification code-prospect for WLWP disabled client #ENG-T633
    When user search and open prospect with name:'EmailTemplateS01'
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user send data collection link to "Prospect" with email: "testautomations+EmailTemplateS01@riskscreen.com"
    Then user should receive an email from: 'noreply@riskscreen.com' and to: 'testautomations+EmailTemplateS01@riskscreen.com' with subject: 'Onboarding Data Request' and body containing text: 'test'
    When user open the data collection link in new tab
    And user clicks on 'SendVerificationCodeButton' on 'Refit' page
    Then user should receive an email from: 'noreply@riskscreen.com' and to: 'testautomations+EmailTemplateS01@riskscreen.com' with subject: 'Verification Code' and body containing text: 'Your one-time verification code is'
    # Defect Raised: ENG-T9131