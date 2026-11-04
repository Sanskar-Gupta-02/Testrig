@Regression @welcomeRefit
Feature: External DCF Refit

  Background:
    Given user login into 'REFIT' application with 'HandlerUserName' user

  @welcomeRefit1
  Scenario: 001 Prospect should be navigating to the welcome page anytime on clicking on the Welcome Page tab in the side panel
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'Automation-Refit2' OB type on 'OnboardingType' page
    Then user should see 'Welcome message' on 'DataCollectionWelcomeMessage' on 'OnboardingType' page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'RefitTrailAutomation2',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text "Data Collection Requests" on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user clicks "SendVerificationCodeButton" enter OTP received on "testautomations+RefitTrailAutomation2@riskscreen.com" email
    Then user should see 'Welcome' on 'WelcomeText' on 'Refit' page
    And user should see 'Welcome message' on 'WelcomeMessage' on 'Refit' page
    When user clicks on 'StartButton' on 'Refit' page
    Then user should see 'Group 1' on 'PropertyGropuName1' on 'Refit' page
    When user clicks on 'SideMenuWelcome' on 'Refit' page
    And user wait from 2 seconds
    Then user should see 'Welcome' on 'WelcomeText' on 'Refit' page
    And user should see 'Welcome message' on 'WelcomeMessage' on 'Refit' page

  @welcomeRefit2
  Scenario: 002 Welcome page if configured should be displayed to Nominee
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'Automation-Refit2' OB type on 'OnboardingType' page
    Then user should see 'Welcome message' on 'DataCollectionWelcomeMessage' on 'OnboardingType' page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'RefitTrailAutomation2',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text "Data Collection Requests" on Onboarding page
    And user clicks on 'NomineesLink' on 'ManageProspect' page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user clicks "SendVerificationCodeButton" enter OTP received on "testautomations+RefitTrailAutomation2Nominee@riskscreen.com" email
    Then user should see 'Welcome' on 'WelcomeText' on 'Refit' page
    And user should see 'Welcome message' on 'WelcomeMessage' on 'Refit' page
    When user clicks on 'StartButton' on 'Refit' page
    Then user should see 'Group 1' on 'PropertyGropuName1' on 'Refit' page
    When user clicks on 'PerviousButton' on 'Refit' page
    And user wait from 2 seconds
    Then user should see 'Welcome' on 'WelcomeText' on 'Refit' page
    And user should see 'Welcome message' on 'WelcomeMessage' on 'Refit' page