@Regression @ManageNominee
Feature: Manage Nominee Automation

  Background:
    Given user login into 'REFIT' application with 'HandlerUserName' user
    And user is authorized using an 'APIKEY'

  @ManageNominee1 @deleteDataRequest
  Scenario: 001 User Should be able to create nominee and assigning property groups should work. #ENG-T9846,T7875
    When user store value:'607525' with keyName:'prospectID'
    And user store value:'341718' with keyName:'onboardingID'
    And user creates a data request and collection link for prospect "607525" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+ManageNomineeS1@riskscreen.com" email
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    When user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS1@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    Then user should see "What do you want to share?" on "EditPermissionHeader" on "Refit" page
    And user should see "testautomations+ManageNomineeS1@riskscreen.com" on "NomineeEmail" on "Refit" page
    And user should see "Group 1" on "SectionGroup1" on "Refit" page
    And user should see "Group 2" on "SectionGroup2" on "Refit" page
    And user should see "Group 3" on "SectionGroup3" on "Refit" page
    When user clicks on "Group1CheckBox" on "Refit" page
    And user clicks on "Group2CheckBox" on "Refit" page
    And user enter "Hello Automation" text in "EmailMessageBox" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    And user should able see "NomineePlacard" on "Refit" page
    And user should see "testautomations+ManageNomineeS1@riskscreen.com" on "NomineePlacardEmail" on "Refit" page
    And user should see "Edit" on "NomineePlacardEditButton" on "Refit" page
    And user should see "Send request" on "NomineePlacardSendRequestButton" on "Refit" page
    And user clicks on 'NomineePlacardDeleteButton' on 'Refit' page
    And user clicks on "ConfirmOkayButton" on "Refit" page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    And user should not see "NomineePlacard" on "Refit" page

  @ManageNominee2
  Scenario: 002 User should be able to add multiple nominee with same email address. #ENG-T9882
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS2',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS2@riskscreen.com"
    And user enter "Auto-Name" text in "Property1" field on "Refit" page
    And user enter "119" text in "Property2" field on "Refit" page
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    And user should able see "NomineePlacard" on "Refit" page
    And user should see "testautomations+ManageNomineeS2Nominee1@riskscreen.com" on "NomineePlacardEmail" on "Refit" page
    When user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS2Nominee1@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    Then user should see "What do you want to share?" on "EditPermissionHeader" on "Refit" page
    And user should see "testautomations+ManageNomineeS2Nominee1@riskscreen.com" on "NomineeEmail" on "Refit" page
    When user clicks on "Group1CheckBox" on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    And user should see "testautomations+ManageNomineeS2Nominee1@riskscreen.com" on "NomineePlacardEmail" on "Refit" page
    And user should see "testautomations+ManageNomineeS2Nominee1@riskscreen.com" on "NomineePlacardEmail2" on "Refit" page
    #Data Revert Back 
    When user clicks on "NomineePlacardEditButton2" on "Refit" page
    And user clicks on "NomineeDeleteButton" on "Refit" page
    And user clicks on "ConfirmOkayButton" on "Refit" page
    Then user should not see "NomineePlacard2" on "Refit" page

  @ManageNominee3
  Scenario: 003 Nominee should not edit their own permissions disable Edit, Send, Delete buttons and self-selection in 'Assign All' dropdown. #ENG-T10056,T281
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS3',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS3@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    When user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS3Nominee1@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    Then user should see "What do you want to share?" on "EditPermissionHeader" on "Refit" page
    When user clicks on 'AllowManageNomineesCheckbox' on 'Refit' page
    And user clicks on 'AllowManageProspectsCheckbox' on 'Refit' page
    And user clicks on "Group1CheckBox" on "Refit" page
    And user enter "Hello Automation" text in "EmailMessageBox" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    When user clicks on 'AddPeopleButton' on 'Refit' page
    And user enter "testautomations+ManageNomineeS3Nominee2@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    And user enter "Hello Automation" text in "EmailMessageBox" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    Then user should able see "NomineePlacard" on "Refit" page
    And user should able see "NomineePlacard2" on "Refit" page
    When user wait from 2 seconds
    #Unable to receive email from qa Environment therefore using internal system to access nominee DCF
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS3',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'NomineesLink' on 'ManageProspect' page
    And user clicks on "NomineeSendLink1" on "ManageProspect" page
    And user enter "Hello Automation" text in "MessageBox" field on "ManageProspect" page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS3Nominee1@riskscreen.com"
    Then user should able see "ManageProspectButton" on "Refit" page
    When user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "testautomations+ManageNomineeS3Nominee1@riskscreen.com" on "NomineePlacardEmail" on "Refit" page
    And user should not see "NomineePlacardEditButton" on "Refit" page
    And user should not see "NomineePlacardSendRequestButton" on "Refit" page
    And user should not see "NomineePlacardDeleteButton" on "Refit" page
    And user should see "Edit" on "NomineePlacardEditButton2" on "Refit" page
    And user should see "Send request" on "NomineePlacardSendRequestButton2" on "Refit" page
    And user should see "Delete" on "NomineePlacardDeleteButton2" on "Refit" page
    #Unable to receive email from qa Environment therefore using internal system to access nominee DCF
    #Data Revert Back 
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS3',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS3@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    And user clicks on 'NomineePlacardDeleteButton' on 'Refit' page
    And user clicks on "ConfirmOkayButton" on "Refit" page
    And user clicks on 'NomineePlacardDeleteButton' on 'Refit' page
    And user clicks on "ConfirmOkayButton" on "Refit" page

  @ManageNominee4
  Scenario: 004 Nominee should only see property groups and Documents assigned to it. #ENG-T8923,T304,T5358,T5357,T7396
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS4',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS4@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    When user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS3Nominee1@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    Then user should see "What do you want to share?" on "EditPermissionHeader" on "Refit" page
    And user should see "testautomations+ManageNomineeS3Nominee1@riskscreen.com" on "NomineeEmail" on "Refit" page
    When user clicks on 'Group1CheckBox' on 'Refit' page
    And user clicks on 'Group3CheckBox' on 'Refit' page
    And user clicks on 'Doc1CheckBox' on 'Refit' page
    And user clicks on 'Doc3CheckBox' on 'Refit' page
    And user enter "Hello Automation" text in "EmailMessageBox" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    And user should able see "NomineePlacard" on "Refit" page
    When user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS3Nominee2@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    Then user should see "What do you want to share?" on "EditPermissionHeader" on "Refit" page
    And user should see "testautomations+ManageNomineeS3Nominee2@riskscreen.com" on "NomineeEmail" on "Refit" page
    When user clicks on 'Group2CheckBox' on 'Refit' page
    And user clicks on 'Group4CheckBox' on 'Refit' page
    And user clicks on 'Doc2CheckBox' on 'Refit' page
    And user clicks on 'Doc4CheckBox' on 'Refit' page
    And user enter "Hello Automation" text in "EmailMessageBox" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    And user should able see "NomineePlacard2" on "Refit" page
    And user should see "4 sections assigned" on "NomineePlacardAssignGroup" on "Refit" page
    And user should see "4 sections assigned" on "NomineePlacardAssignGroup2" on "Refit" page
    When user wait from 5 seconds
    #Unable to receive email from qa Environment therefore using internal system to access nominee DCF
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS4',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'NomineesLink' on 'ManageProspect' page
    And user clicks on "NomineeSendLink1" on "ManageProspect" page
    And user enter "Hello Automation" text in "MessageBox" field on "ManageProspect" page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS3Nominee1@riskscreen.com"
    Then user should see "Group 1" on "SideMenuGroup1" on "Refit" page
    And user should see "Group 3" on "SideMenuGroup3" on "Refit" page
    And user should not see "SideMenuGroup2" on "Refit" page
    And user should not see "SideMenuGroup4" on "Refit" page
    When user clicks on "SidemenuDocument" on "Refit" page
    Then user should see "Doc 1" on "DocumentsList1" on "Refit" page
    And user should see "Doc 3" on "DocumentsList2" on "Refit" page
    And user should not see "DocumentsList3" on "Refit" page
    And user should not see "DocumentsList4" on "Refit" page
    When user wait from 5 seconds
    #Unable to receive email from qa Environment therefore using internal system to access nominee DCF
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS4',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'NomineesLink' on 'ManageProspect' page
    And user clicks on "NomineeSendLink2" on "ManageProspect" page
    And user enter "Hello Automation" text in "MessageBox" field on "ManageProspect" page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS3Nominee2@riskscreen.com"
    Then user should see "Group 2" on "SideMenuGroup2" on "Refit" page
    And user should see "Group 4" on "SideMenuGroup4" on "Refit" page
    And user should not see "SideMenuGroup1" on "Refit" page
    And user should not see "SideMenuGroup3" on "Refit" page
    When user clicks on "SidemenuDocument" on "Refit" page
    Then user should see "Doc 2" on "DocumentsList1" on "Refit" page
    And user should see "Doc 4" on "DocumentsList2" on "Refit" page
    And user should not see "DocumentsList3" on "Refit" page
    And user should not see "DocumentsList4" on "Refit" page
    When user wait from 5 seconds
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS4',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS4@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    And user clicks on 'NomineePlacardEditButton' on 'Refit' page
    Then user should see "What do you want to share?" on "EditPermissionHeader" on "Refit" page
    When user clicks on 'Group2CheckBox' on 'Refit' page
    And user clicks on 'Group4CheckBox' on 'Refit' page
    And user clicks on 'Doc2CheckBox' on 'Refit' page
    And user clicks on 'Doc4CheckBox' on 'Refit' page
    And user clicks on "SaveChanges" on "Refit" page
    Then user should see "8 sections assigned" on "NomineePlacardAssignGroup" on "Refit" page
    And user should see "0 sections assigned" on "NomineePlacardAssignGroup2" on "Refit" page
    #Data Revert Back 
    And user clicks on 'NomineePlacardDeleteButton' on 'Refit' page
    And user clicks on "ConfirmOkayButton" on "Refit" page
    And user clicks on 'NomineePlacardDeleteButton' on 'Refit' page
    And user clicks on "ConfirmOkayButton" on "Refit" page

  @ManageNominee5
  Scenario: 005 Status of nominees should get updated properly. #ENG-T9928
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS5',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS5@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    When user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS5Nominee1@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    Then user should see "What do you want to share?" on "EditPermissionHeader" on "Refit" page
    And user should see "testautomations+ManageNomineeS5Nominee1@riskscreen.com" on "NomineeEmail" on "Refit" page
    When user clicks on 'Group1CheckBox' on 'Refit' page
    And user clicks on 'Group2CheckBox' on 'Refit' page
    And user clicks on 'Doc1CheckBox' on 'Refit' page
    And user clicks on 'Doc2CheckBox' on 'Refit' page
    And user enter "Hello Automation" text in "EmailMessageBody" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    And user should able see "NomineePlacard" on "Refit" page
    When user clicks on 'AddPeopleButton' on 'Refit' page
    And user enter "testautomations+ManageNomineeS5Nominee2@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    Then user should see "What do you want to share?" on "EditPermissionHeader" on "Refit" page
    And user should see "testautomations+ManageNomineeS5Nominee2@riskscreen.com" on "NomineeEmail" on "Refit" page
    When user clicks on 'Group3CheckBox' on 'Refit' page
    And user clicks on 'Group4CheckBox' on 'Refit' page
    And user clicks on 'Doc3CheckBox' on 'Refit' page
    And user clicks on 'Doc4CheckBox' on 'Refit' page
    And user enter "Hello Automation" text in "EmailMessageBody" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    Then user should able see "NomineePlacard2" on "Refit" page
    When user clicks on "NomineePlacardSendRequestButton" on "Refit" page
    Then user should see "Send email" on "SendEmailHeader" on "Refit" page
    And user should see "testautomations+ManageNomineeS5Nominee1@riskscreen.com" on "SendDataRequestTo" on "Refit" page
    When user select "testautomations+ManageNomineeS5Nominee1@riskscreen.com" option in "SendLinkto" dropdown on "Refit" page
    And user enter "Hello Automation" text in "EmailMessageBody" field on "Refit" page
    And user clicks on "SendEmailButton" on "Refit" page
    Then user should receive an email from: 'noreply@riskscreen.com' and to: 'testautomations+ManageNomineeS5Nominee1@riskscreen.com' with subject: 'Dcf onboarding email' and body containing text: 'Hello Automation'
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS5',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'NomineesLink' on 'ManageProspect' page
    And user clicks on "NomineeSendLink1" on "ManageProspect" page
    And user enter "Hello Automation" text in "MessageBox" field on "ManageProspect" page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS5Nominee1@riskscreen.com"
    And user enter "Auto-UserName" text in "Property1" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS5',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS5@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Started" on "NomineePlacardStatus" on "Refit" page
    And user should see "Not Started" on "NomineePlacardStatus2" on "Refit" page
    And user should see "Resend request" on "NomineePlacardSendRequestButton" on "Refit" page
    And user should see "Send request" on "NomineePlacardSendRequestButton2" on "Refit" page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS5',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'NomineesLink' on 'ManageProspect' page
    And user clicks on "NomineeSendLink1" on "ManageProspect" page
    And user enter "Hello Automation" text in "MessageBox" field on "ManageProspect" page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
   And user enter OTP received on "testautomations+ManageNomineeS5Nominee1@riskscreen.com"
    And user clicks on "SummaryTab" on "Refit" page
    And user clicks on "CheckBox" on "Refit" page
    And user clicks on "SubmitButtons" on "Refit" page
    And user wait from 5 seconds
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS5',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS5@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Completed" on "NomineePlacardStatus" on "Refit" page
    #Data Revert Back 
    And user clicks on 'NomineePlacardDeleteButton' on 'Refit' page
    And user clicks on "ConfirmOkayButton" on "Refit" page
    And user clicks on 'NomineePlacardDeleteButton' on 'Refit' page
    And user clicks on "ConfirmOkayButton" on "Refit" page

  @ManageNominee6
  Scenario: 006 Assign all sections to nominee button should work properly. #ENG-T9987,T7395
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS6',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS6@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "testautomations+ManageNomineeS6Nominee1@riskscreen.com,testautomations+ManageNomineeS6Nominee2@riskscreen.com" options in dropdown "AssignAllDropdown" on "Refit" page
    When user select "testautomations+ManageNomineeS6Nominee2@riskscreen.com" option in "AssignAllDropdown" dropdown on "Refit" page
    And user clicks on "AssignAllButton" on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    Then user should see 'testautomations+ManageNomineeS6Nominee2@riskscreen.com' in all 'SectionDropdowns' dropdowns on 'Refit' page
    When user wait from 2 seconds
    And user clicks on 'NomineePlacardEditButton' on 'Refit' page
    And user wait from 2 seconds
    And user clicks on "ShareWholeFormButton" on "Refit" page
    And user wait from 2 seconds
    And user clicks on "SaveChanges" on "Refit" page
    And user clicks on 'NomineePlacardEditButton' on 'Refit' page
    Then user should see all see checkbox on 'PermissionSectionCheckBox' checked on 'Refit' page
    When user clicks on "SaveChanges" on "Refit" page
    Then user should see "8 sections assigned" on "NomineePlacardAssignGroup" on "Refit" page
    When user clicks on 'NomineePlacardEditButton' on 'Refit' page
    And user wait from 2 seconds
    And user clicks on "UnshareWholeFormButton" on "Refit" page
    And user wait from 2 seconds
    And user clicks on "SaveChanges" on "Refit" page
    Then user should see "0 sections assigned" on "NomineePlacardAssignGroup" on "Refit" page

  @ManageNominee7
  Scenario: 007 Nominee email body should populate in email box. #ENG-T9927
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS7',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS7@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    When user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS7Nominee1@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    And user enter "Hello Automation" text in "EmailMessageBody" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    And user should able see "NomineePlacard" on "Refit" page
    When user clicks on "NomineePlacardSendRequestButton" on "Refit" page
    And user select "testautomations+ManageNomineeS7Nominee1@riskscreen.com" option in "SendLinkto" dropdown on "Refit" page
    And user select "Automation Nominee Template" option in "EmailTemplate" dropdown on "Refit" page
    Then user should see "Auto email template" on "EmailMessageBody" on "Refit" page
    #Data Revert Back 
    When user clicks on 'ShareThisFormButton' on 'Refit' page
    And user clicks on 'NomineePlacardDeleteButton' on 'Refit' page
    And user clicks on "ConfirmOkayButton" on "Refit" page

  @ManageNominee8
  Scenario: 008 Error should be shown when trying to send email to nominee or editing a nominee. #ENG-T10056
  #Bug is Live and Waiting for Developer to fix
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS8',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS8@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    When user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS8Nominee1@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    And user wait from 5 seconds
    And user clicks on "SaveChanges" on "Refit" page
    And user wait from 5 seconds
    And user should able see "EmailErrorMessageBox" on "Refit" page
    Then user should see "Please enter an email body." on "EmailErrorMessage" on "Refit" page
    When user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    When user clicks on "NomineePlacardSendRequestButton" on "Refit" page
    And user clicks on "SendEmailButton" on "Refit" page
    Then user should see "'Send Link To' must not be empty." on "SendLinkToErrorBox" on "Refit" page
    And user should able see "EmailErrorMessageBox" on "Refit" page
    When user clicks on 'ShareThisFormButton' on 'Refit' page
    #Data Revert Back 
    And user clicks on "NomineePlacardDeleteButton" on "Refit" page
    And user clicks on "ConfirmOkayButton" on "Refit" page

  @ManageNominee9
  Scenario: 009 User should be able to add more than 20 nominees. #ENG-T10057
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS9',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS9@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    When user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS9Nominee21@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    And user enter "Hello Automation" text in "EmailMessageBody" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    Then user should able see "NomineePlacard21" on "Refit" page
    #Data Revert Back 
    When user clicks on "NomineePlacardEditButton21" on "Refit" page
    And user clicks on "NomineeDeleteButton" on "Refit" page
    And user clicks on "ConfirmOkayButton" on "Refit" page

  @ManageNominee10
  Scenario: 010 User should be able to move the nominees ordering. #ENG-T10214 ,T8906
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS10',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS10@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    And user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS10Nominee1@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    And user enter "Nominee1" text in "EmailMessageBody" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    Then user should able see "NomineePlacard" on "Refit" page
    When user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS10Nominee2@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    And user enter "Nominee2" text in "EmailMessageBody" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    Then user should able see "NomineePlacard2" on "Refit" page
    When user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS10Nominee3@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    And user enter "Nominee3" text in "EmailMessageBody" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    Then user should able see "NomineePlacard3" on "Refit" page
    When user clicks on "MoveDownButton" on "Refit" page
    And user clicks on "MoveDownButton2" on "Refit" page
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS10',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on "NomineesLink" on "ManageProspect" page
    Then user should see "testautomations+ManageNomineeS10Nominee2@riskscreen.com" on "NomineeEmail" on "ManageProspect" page
    And user should see "testautomations+ManageNomineeS10Nominee3@riskscreen.com" on "NomineeEmail2" on "ManageProspect" page
    And user should see "testautomations+ManageNomineeS10Nominee1@riskscreen.com" on "NomineeEmail3" on "ManageProspect" page
    #Data Revert Back 
    When user clicks on "GoBackLink" on "Onboarding" page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS10@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    #Data Revert Back 
    And user clicks on 'NomineePlacardDeleteButton' on 'Refit' page
    And user clicks on "ConfirmOkayButton" on "Refit" page
    And user clicks on 'NomineePlacardDeleteButton' on 'Refit' page
    And user clicks on "ConfirmOkayButton" on "Refit" page
    And user clicks on 'NomineePlacardDeleteButton' on 'Refit' page
    And user clicks on "ConfirmOkayButton" on "Refit" page

  @ManageNominee11
  Scenario: 011 When parallel is selected nominee data collection type all nominees should be able to start and complete the form independently. #ENG-T10212
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitManageNomineeS11(DoNotTouch)' OB type on 'OnboardingType' page
    And user clicks on 'DataCollectionLink' on 'OnboardingType' page
    Then user should see "Parallel" option selected on "NomineeDataCollectionType" on "OnboardingType" page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS11',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS11@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    When user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS11Nominee1@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    And user clicks on "Group1CheckBox" on "Refit" page
    And user clicks on "Group2CheckBox" on "Refit" page
    And user enter "Nominee 1" text in "EmailMessageBody" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    And user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS11Nominee2@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    And user clicks on "Group3CheckBox" on "Refit" page
    And user clicks on "Group4CheckBox" on "Refit" page
    And user enter "Nominee 2" text in "EmailMessageBody" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    And user wait from 2 seconds
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS11',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'NomineesLink' on 'ManageProspect' page
    And user clicks on "NomineeSendLink1" on "ManageProspect" page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS11Nominee1@riskscreen.com"
    Then user should see "Group 1" on "PageTitle" on "Refit" page
    When user enter "Auto-Name" text in "Group1TextField" field on "Refit" page
    And user enter "21" text in "Group1IntegerField" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user wait from 2 seconds
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS11',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'NomineesLink' on 'ManageProspect' page
    Then user should see "Started" on "NomineeEmailStatus" on "ManageProspect" page
    And user should see "Not Started" on "NomineeEmailStatus2" on "ManageProspect" page
    When user clicks on "NomineeSendLink2" on "ManageProspect" page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS11Nominee2@riskscreen.com"
    Then user should see "Group 3" on "PageTitle" on "Refit" page
    When user enter "Auto-Name" text in "Group1TextField" field on "Refit" page
    And user enter "21" text in "Group1IntegerField" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user wait from 2 seconds
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS11',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'NomineesLink' on 'ManageProspect' page
    Then user should see "Started" on "NomineeEmailStatus" on "ManageProspect" page
    And user should see "Started" on "NomineeEmailStatus2" on "ManageProspect" page
    #Data Revert Back 
    When user clicks on "NomineeDelete2" on "ManageProspect" page
    And user clicks on "ConfirmationDelete" on "ManageProspect" page
    And user clicks on "NomineeDelete" on "ManageProspect" page
    And user clicks on "ConfirmationDelete" on "ManageProspect" page

  @ManageNominee12
  Scenario: 012 When Sequential is selected nominee data collection type user should not be able to send DCF request to second nominee. #ENG-T10215,T271,T273,T4181,T559,T302
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitManageNomineeS12(DoNotTouch)' OB type on 'OnboardingType' page
    And user clicks on 'DataCollectionLink' on 'OnboardingType' page
    Then user should see "Sequential" option selected on "NomineeDataCollectionType" on "OnboardingType" page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS12',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "AutomationTest+ManageNomineeS12@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    When user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS12Nominee1@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    And user clicks on "Group1CheckBox" on "Refit" page
    And user clicks on "Group2CheckBox" on "Refit" page
    And user enter "Nominee 1" text in "EmailMessageBody" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    And user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS12Nominee2@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    And user clicks on "Group3CheckBox" on "Refit" page
    And user clicks on "Group4CheckBox" on "Refit" page
    And user enter "Nominee 2" text in "EmailMessageBody" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    And user wait from 2 seconds
    Then user should not be able to navigate after clicking on Send Request Button on 2nd Placard
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS12',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'NomineesLink' on 'ManageProspect' page
    And user clicks on "NomineeSendLink1" on "ManageProspect" page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS12Nominee1@riskscreen.com"
    Then user should see "Group 1" on "PageTitle" on "Refit" page
    When user enter "Auto-Name" text in "Group1TextField" field on "Refit" page
    And user enter "21" text in "Group1IntegerField" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user enter "Auto-Name2" text in "Group2TextField1" field on "Refit" page
    And user enter "Auto-Name3" text in "Group2TextField2" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user clicks on 'CheckBox' on 'Refit' page
    And user clicks on 'SubmitButtons' on 'Refit' page
    And user wait from 2 seconds
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS12',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "AutomationTest+ManageNomineeS12@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should not be able to navigate after clicking on Send Request Button on 2nd Placard
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS12',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'NomineesLink' on 'ManageProspect' page
    Then user should see "Complete" on "NomineeEmailStatus" on "ManageProspect" page
    And user should see "Not Started" on "NomineeEmailStatus2" on "ManageProspect" page
    #Data Revert Back 
    When user clicks on "NomineeDelete2" on "ManageProspect" page
    And user clicks on "ConfirmationDelete" on "ManageProspect" page
    And user clicks on "NomineeDelete" on "ManageProspect" page
    And user clicks on "ConfirmationDelete" on "ManageProspect" page

  @ManageNominee13
  Scenario: 013 User Should be able to share whole form with Nominees and unassign them in External DCF.
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'ManageNomineeS13',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user get the data link and open
    And user enter OTP received on "testautomations+ManageNomineeS13@riskscreen.com"
    And user clicks on 'ShareThisFormButton' on 'Refit' page
    Then user should see "Share part or all of this form" on "ShareThisFormHeader" on "Refit" page
    When user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS13Nominee1@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    And user enter "Nominee 1" text in "EmailMessageBody" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    And user clicks on 'AddPeopleButton' on 'Refit' page
    Then user should able see "AddUserPanel" on "Refit" page
    When user enter "testautomations+ManageNomineeS13Nominee2@riskscreen.com" text in "EmailTextField" field on "Refit" page
    And user clicks on "NewNomineeSaveButton" on "Refit" page
    And user enter "Nominee 2" text in "EmailMessageBody" field on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    And user wait from 2 seconds
    Then user should see "0 sections assigned" on "NomineePlacardAssignGroup" on "Refit" page
    And user should see "-- Unassigned --" option selected on "AssignAllDropdown" on "Refit" page
    And user should see "-- Unassigned --" option selected on "NomineeGroupIDDropdown" on "Refit" page
    And user should see "-- Unassigned --" option selected on "NomineeGroupIDDropdown2" on "Refit" page
    When user select "testautomations+ManageNomineeS13Nominee1@riskscreen.com" option in "AssignAllDropdown" dropdown on "Refit" page
    And user clicks on "ShareWholeForm" on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    Then user should see "2 sections assigned" on "NomineePlacardAssignGroup" on "Refit" page
    And user should see "testautomations+ManageNomineeS13Nominee1@riskscreen.com" option selected on "NomineeGroupIDDropdown" on "Refit" page
    And user should see "testautomations+ManageNomineeS13Nominee1@riskscreen.com" option selected on "NomineeGroupIDDropdown2" on "Refit" page
    When user select "testautomations+ManageNomineeS13Nominee2@riskscreen.com" option in "NomineeGroupIDDropdown2" dropdown on "Refit" page
    And user clicks on "SaveChanges" on "Refit" page
    Then user should see "1 sections assigned" on "NomineePlacardAssignGroup" on "Refit" page
    And user should see "1 sections assigned" on "NomineePlacardAssignGroup2" on "Refit" page
    #Data Revert Back 
    When user clicks on 'NomineePlacardDeleteButton' on 'Refit' page
    And user clicks on "ConfirmOkayButton" on "Refit" page
    And user clicks on 'NomineePlacardDeleteButton' on 'Refit' page
    And user clicks on "ConfirmOkayButton" on "Refit" page
