@Regression @WebBranding
Feature: Web Branding

  Background:
    Given user login into 'REFIT' application with 'HandlerUserName' user
    And user is authorized using an 'APIKEY'

  @webbranding01 @deleteOnboarding
  Scenario: 001 Verify add, edit and the web branding selected in the OT should be applicable to all section of the data collection form #ENG-T458,T459,T540,T541,T546,T548,T2818,T3615,T3616,T4713,T4715,T545
    When user navigates to the "WebBranding" page with the page title "Web Brandings"
    And user clicks on "AddNewWebBranding" on "WebBranding" page
    Then user should see 'Helvetica' selected in following font dropdowns:
      | dropdowns                            |
      | VerificationCodeHeadingFontNames     |
      | VerificationCodeDescriptionFontNames |
      | ProgressBarFontNames                 |
      | WelcomeFontNames                     |
      | SectionFontNames                     |
      | PropertyGroupFontNames               |
      | PropertyFontNames                    |
      | ConfirmationFontNames                |
      | ButtonsFontNames                     |
      | NomineeFormTableHeadersFontNames     |
      | NomineeFormFontNames                 |
    When user enter "AutoWebBranding_UKDateTimeStamp" text in "WebBrandingName" field on "WebBranding" page
    And user enter "AutoWebBrandingDescription" text in "WebBrandingDescription" field on "WebBranding" page
    And user clicks on "AddBrandingButton" on "WebBranding" page
    Then user should see success banner with message "Web Branding added successfully."
    When user clicks on edit button of 'AutoWebBranding_UKDateTimeStamp' Web Branding
    And user enter "EditAutoBranding_UKDateTimeStamp" text in "WebBrandingName" field on "WebBranding" page
    And user enters colors on following fields on 'WebBranding' page
      | color  | field                                |
      | Red    | ButtonBackground                     |
      | Pink   | VerificationCodeHeadingFontForeColor |
      | Yellow | ProgressBarFontForeColor             |
      | Orange | NomineeFormTableHeadersFontForeColor |
      | Green  | NomineeFormFontForeColor             |
    And user select option in following dropdowns on 'WebBranding' page
      | option       | dropdown                          |
      | Yes          | VerificationCodeDescriptionItalic |
      |         20px | ProgressBarFontSize               |
      | Sailec-Light | ProgressBarFont                   |
      | Yes          | PropertyFontBold                  |
    And user clicks on "UpdateBranding" on "WebBranding" page
    Then user should see success banner with message "Web Branding updated successfully."
    When user navigate to Onboarding type "AutomationWebBranding"
    Then user should see "JO - Branding,JTC,Web branding 1,New,NewColor,Logo,newbranding18-aug-2026,newnewnew,EditAutoBranding_UKDateTimeStamp" options in dropdown "WebBranding" on "OnboardingType" page
    When user select "EditAutoBranding_UKDateTimeStamp" option in "WebBranding" dropdown on "OnboardingType" page
    And user update and publish onboarding type
    And user creates an onboarding for prospect "617248" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "617248" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink"
    Then user should see the following CSS values in the elements:
      | field                       | cssValue         | expectedValue | page  |
      | VerificationCodeHeading     | font color       | Pink          | Refit |
      | VerificationCodeDescription | italic           | italic        | Refit |
      | SendVerificationCodeButton  | background color | Red           | Refit |
    When user clicks 'SendVerificationCodeButton' enter OTP received on "testautomations+AutomationWebBranding@kyc360.com" email
    Then user should see the following CSS values in the elements:
      | field                   | cssValue         | expectedValue | page  |
      | ProgressBarNotCompleted | background color | Grey          | Refit |
      | ProgressBar             | font color       | Yellow        | Refit |
      | ProgressBar             | font             | Sailec-Light  | Refit |
      | ProgressBar             | font size        |          20px | Refit |
      | Section                 | font             | Helvetica     | Refit |
    When user shares form with email "testautomations+AutomationWebBrandingN1@kyc360.com" and saves nominee on 'Refit' page
    Then user should see the following CSS values in the elements:
      | field                    | cssValue   | expectedValue | page  |
      | NomineFormTableHeader    | font color | Orange        | Refit |
      | NomineeFormTableContents | font color | Green         | Refit |
    #Revert
    When user navigate to Onboarding type "AutomationWebBranding"
    And user select "" option in "WebBranding" dropdown on "OnboardingType" page
    And user update and publish onboarding type
    And user navigates to the "WebBranding" page with the page title "Web Brandings"
    And user deletes "EditAutoBranding_UKDateTimeStamp" Web Branding

  @webbranding02 @deleteOnboarding
  Scenario: 002 Verify web branding selected in the OT should be applicable to Welcome page, KYB lookup page, Manage Prospect page #ENG-T1073,T548,T4715,T1647
    When user navigates to the "WebBranding" page with the page title "Web Brandings"
    And user clicks on "AddNewWebBranding" on "WebBranding" page
    And user enter "AutoWebBranding2_UKDateTimeStamp" text in "WebBrandingName" field on "WebBranding" page
    And user enter "AutoWebBrandingDescription" text in "WebBrandingDescription" field on "WebBranding" page
    And user enters colors on following fields on 'WebBranding' page
      | color  | field                    |
      | Violet | WelcomeMessageBackground |
      | Blue   | PropertyFontForeColor    |
      | Red    | ButtonBackground         |
      | Green  | DisplayPanelBackground   |
      | White  | ButtonsFontForeColor     |
    And user select option in following dropdowns on 'WebBranding' page
      | option        | dropdown           |
      | Sailec-Medium | WelcomeMessageFont |
    And user clicks on "AddBrandingButton" on "WebBranding" page
    Then user should see success banner with message "Web Branding added successfully."
    When user navigate to Onboarding type "AutomationWebBranding2"
    And user select "AutoWebBranding2_UKDateTimeStamp" option in "WebBranding" dropdown on "OnboardingType" page
    And user update and publish onboarding type
    And user creates an onboarding for prospect "617249" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "617249" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink"
    And user clicks 'SendVerificationCodeButton' enter OTP received on "testautomations+AutomationWebBranding2@kyc360.com" email
    Then user should see the following CSS values in the elements:
      | field                 | cssValue         | expectedValue | page  |
      | WelcomePageBackground | background color | Violet        | Refit |
      | WelcomeMessage        | font             | Sailec-Medium | Refit |
    When user clicks on "StartButton" on "Refit" page
    Then user should see the following CSS values in the elements:
      | field                | cssValue         | expectedValue | page  |
      | ManageProspectButton | background color | Red           | Refit |
      | ManageProspectButton | font color       | White         | Refit |
      | DisplayPannel        | background color | Green         | Refit |
    When user clicks on 'SummaryTab' on 'Refit' page
    Then user should see the following CSS values in the elements:
      | field               | cssValue   | expectedValue | page  |
      | ConfirmationMessage | font color | Blue          | Refit |
    When user clicks on 'ManageProspectButton' on 'Refit' page
    Then user should see the following CSS values in the elements:
      | field          | cssValue         | expectedValue | page  |
      | CreateProspect | background color | Red           | Refit |
      | CreateProspect | font color       | White         | Refit |
      | DisplayPannel  | background color | Green         | Refit |
    #Revert
    When user navigate to Onboarding type "AutomationWebBranding2"
    And user select "" option in "WebBranding" dropdown on "OnboardingType" page
    And user update and publish onboarding type
    And user navigates to the "WebBranding" page with the page title "Web Brandings"
    And user deletes "AutoWebBranding2_UKDateTimeStamp" Web Branding
