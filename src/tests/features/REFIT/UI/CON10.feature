@Regression @CON10
Feature: CON10 Refit

  Background:
    Given user login into 'REFIT' application with 'HandlerUserName' user
    And user is authorized using an 'APIKEY'

  @deleteDataRequest
  Scenario: 001 CON 10 - 06b - External User should not be able to add prospect from DCF if permission is set to NO by HBU while creating the Data collection request. #ENG-T1000,T999
    When user search and open prospect with name:'DCFPermissionProspect'
    When user clicks on 'EditProspectLink' on 'Prospect' page
    And user select "Yes" option in "AllowManageProspects" dropdown on "Prospect" page
    And user clicks on 'UpdateButton' on 'Prospect' page
    Then user should see success banner with message "Prospect has been updated."
    When user store value:'616336' with keyName:'prospectID'
    When user store value:'354808' with keyName:'onboardingID'
    When user creates a data request and collection link for prospect "616336" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+DCFPermissionProspect@riskscreen.com" email
    And user should able see 'ManageProspectButton' on 'Refit' page
    When user search and open prospect with name:'DCFPermissionProspect'
    When user clicks on 'EditProspectLink' on 'Prospect' page
    And user select "No" option in "AllowManageProspects" dropdown on "Prospect" page
    And user clicks on 'UpdateButton' on 'Prospect' page
    Then user should see success banner with message "Prospect has been updated."

  @deleteOnboarding @CON102
  Scenario: 002 CON 10 Child prospect of same prospect associated with two different group should not be present in each others group #ENG-T1025,T4314,T1001,T1002,T4309,T4310
    When user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user store value:'616392' with keyName:'prospectID'
    And user has payloads:
      """
      {
      "ClientProspectGroupID":"1436"
      }
      """
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616392" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+DualGroupLead@riskscreen.com" email
    And user clicks on 'ManageProspectButton' on 'Refit' page
    And user clicks on 'CreateProspect' on 'Refit' page
    And user clicks on "DefaultEmailCheckbox" on "Refit" page
    And user enter data in following fields in Refit DCF:
      | field             | value                 |
      | FamilyName        | DualGroupChild1<Date> |
      | ProspectReference | AutoTestS21           |
    And user selects data in following fields in Refit DCF:
      | field                | value                  |
      | ProspectRelationship | Director               |
      | OnboardingType       | Automation(DoNotTouch) |
      | ParentProspect       | DualGroupLead          |
    And user clicks on 'CreateProspectButton' on 'Refit' page
    Then user should see 'DualGroupChild1' prospect below 'DualGroupLead' prospect
    When user delete onboarding with stored key value 'onboardingID'
    And user has a service named "/api/v1/client/onboarding/add"
    And user has a payload from the file 'onboarding'
    And user has payloads:
      """
      {
      "ClientProspectGroupID":"1437"
      }
      """
    And user add payload "ClientProspectID" with the stored key value "prospectID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "616392" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+DualGroupLead@riskscreen.com" email
    And user clicks on 'ManageProspectButton' on 'Refit' page
    Then user should not see 'DualGroupChild1' prospect below 'DualGroupLead' prospect
    When user clicks on 'CreateProspect' on 'Refit' page
    And user clicks on "DefaultEmailCheckbox" on "Refit" page
    And user enter data in following fields in Refit DCF:
      | field             | value                 |
      | FamilyName        | DualGroupChild2<Date> |
      | ProspectReference | AutoTestS22           |
    And user selects data in following fields in Refit DCF:
      | field                | value                  |
      | ProspectRelationship | Director               |
      | OnboardingType       | Automation(DoNotTouch) |
      | ParentProspect       | DualGroupLead          |
    And user clicks on 'CreateProspectButton' on 'Refit' page
    Then user should see 'DualGroupChild2' prospect below 'DualGroupLead' prospect
    When user search and open prospect with name:'DualGroupChild1'
    And user delete onboarding and prospect
    And user search and open prospect with name:'DualGroupChild2'
    And user delete onboarding and prospect

  @CON103 @deleteDataRequest
  Scenario: 003 CON 10 - Edit/Delete actions are displayed only for Prospects created by the user & deleting prospect only deletes the link to the Prospect Group #ENG-T1029,T1030,T4315,T1031
    When user store value:'616419' with keyName:'prospectID'
    And user store value:'354964' with keyName:'onboardingID'
    And user creates a data request and collection link for prospect "616419" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+LeadProspect@riskscreen.com" email
    And user clicks on 'ManageProspectButton' on 'Refit' page
    And user clicks on 'CreateProspect' on 'Refit' page
    And user clicks on "DefaultEmailCheckbox" on "Refit" page
    And user enter data in following fields in Refit DCF:
      | field             | value                    |
      | FamilyName        | NotDeletedProspect<Date> |
      | ProspectReference | AutomationRef<Date>      |
    And user selects data in following fields in Refit DCF:
      | field                | value                  |
      | ProspectRelationship | Director               |
      | OnboardingType       | Automation(DoNotTouch) |
      | ParentProspect       | LeadProspect           |
    And user clicks on 'CreateProspectButton' on 'Refit' page
    And user wait from 5 seconds
    Then user should see 'NotDeletedProspect' prospect below 'LeadProspect' prospect
    And user should see 'EditProspectButton' button for 'NotDeletedProspect' prospect
    When user clicks on 'EditProspectButton' button for 'NotDeletedProspect' prospect
    And user should see 'DeleteProspect' button for 'NotDeletedProspect' prospect
    When user clicks on 'DeleteProspect' button for 'NotDeletedProspect' prospect
    And user clicks on 'ConfirmButton' on 'Refit' page
    And user clicks on 'ManageProspectButton' on 'Refit' page
    Then user should not see 'NotDeletedProspect' prospect below 'LeadProspect' prospect
    When user search and open prospect with name:'NotDeletedProspect'
    And user delete onboarding and prospect

  @CON104
  Scenario: 004 CON 10 - 03c - 'Parent Prospect' dropdown should display same prospect at multiple roles while adding new prospect/existing prospect. #ENG-T1093,T4323
    When user search and open prospect with name:'LeadProspectMultiple'
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text "Data Collection Requests" on Onboarding page
    And user generates data collection link and open
    And user enter OTP received on "testautomations+LeadProspectMultiple@riskscreen.com"
    And user clicks on 'ManageProspectButton' on 'Refit' page
    And user clicks on 'CreateProspect' on 'Refit' page
    Then user should see "LeadProspectMultiple,ChildMultiple (Director),ChildMultiple (NewRelationship1)" options in dropdown "ParentProspect" on "Refit" page
    When user clicks on 'ManageProspectButton' on 'Refit' page
    And user clicks on 'AddExistingProspectButton' on 'Refit' page
    And user search Name : 'ChildMultiple', SearchOn : 'Last name', MatchType : 'Starts with' and ProspectStatus : 'All' on 'Refit' page
    And user wait until "ProspectSearchTable" process on "Refit" page is complete
    And user clicks on 'AddSearchedExistingProspectButton' button for 'ChildMultiple' prospect
    Then user should see "LeadProspectMultiple,ChildMultiple (Director),ChildMultiple (NewRelationship1)" options in dropdown "ParentProspect" on "Refit" page

  @CON105
  Scenario: 005 CON 10 - 03c - Adding the existing prospect with different role under same parent prospect should be allowed. #ENG-T1039,T4316
    When user search and open prospect with name:'MultipleRoleLead'
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text "Data Collection Requests" on Onboarding page
    And user generates data collection link and open
    And user enter OTP received on "testautomations+MultipleRoleLead@riskscreen.com"
    And user clicks on 'ManageProspectButton' on 'Refit' page
    And user clicks on 'AddExistingProspectButton' on 'Refit' page
    And user search Name : 'ChildMultipleRole', SearchOn : 'Last name', MatchType : 'Starts with' and ProspectStatus : 'All' on 'Refit' page
    And user wait until "ProspectSearchTable" process on "Refit" page is complete
    And user clicks on 'AddSearchedExistingProspectButton' button for 'ChildMultipleRole' prospect
    And user selects data in following fields in Refit DCF:
      | field                | value            |
      | ProspectRelationship | Shareholder      |
      | ParentProspect       | MultipleRoleLead |
    And user clicks on 'SaveProspectToGroupButton' on 'Refit' page
    Then user should see 'ChildMultipleRole (Director)' prospect below 'MultipleRoleLead' prospect
    And user should see 'ChildMultipleRole (Shareholder)' prospect below 'MultipleRoleLead' prospect
    When user clicks on 'AddExistingProspectButton' on 'Refit' page
    And user search Name : 'ChildMultipleRole', SearchOn : 'Last name', MatchType : 'Starts with' and ProspectStatus : 'All' on 'Refit' page
    And user wait until "ProspectSearchTable" process on "Refit" page is complete
    And user clicks on 'AddSearchedExistingProspectButton' button for 'ChildMultipleRole' prospect
    And user selects data in following fields in Refit DCF:
      | field                | value            |
      | ProspectRelationship | NewRelationship1 |
      | ParentProspect       | MultipleRoleLead |
    And user clicks on 'SaveProspectToGroupButton' on 'Refit' page
    Then user should see 'ChildMultipleRole (Director)' prospect below 'MultipleRoleLead' prospect
    And user should see 'ChildMultipleRole (Shareholder)' prospect below 'MultipleRoleLead' prospect
    And user should see 'ChildMultipleRole (NewRelationship1)' prospect below 'MultipleRoleLead' prospect
    When user clicks on 'EditProspectButton' button for 'ChildMultipleRole (Shareholder)' prospect
    When user clicks on 'DeleteProspect' button for 'ChildMultipleRole (Shareholder)' prospect
    And user clicks on 'ConfirmButton' on 'Refit' page
    When user clicks on 'EditProspectButton' button for 'ChildMultipleRole (NewRelationship1)' prospect
    When user clicks on 'DeleteProspect' button for 'ChildMultipleRole (NewRelationship1)' prospect
    And user clicks on 'ConfirmButton' on 'Refit' page
    Then user should not see 'ChildMultipleRole (Shareholder)' prospect below 'MultipleRoleLead' prospect
    And user should not see 'ChildMultipleRole (NewRelationship1)' prospect below 'MultipleRoleLead' prospect

  @CON106
  Scenario: 006 CON 10 - 02c - Prospect table in external DCF should display the prospect added by another user / prospect, linked to the prospect group already and are uneditable. #ENG-T1023
    When user search and open prospect with name:'PermissionLead'
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text "Data Collection Requests" on Onboarding page
    And user generates data collection link and open
    And user enter OTP received on "testautomations+PermissionLead@riskscreen.com"
    And user clicks on 'ManageProspectButton' on 'Refit' page
    And user clicks on 'CreateProspect' on 'Refit' page
    And user clicks on "DefaultEmailCheckbox" on "Refit" page
    And user enter data in following fields in Refit DCF:
      | field      | value                  |
      | FamilyName | PermissionChild2<Date> |
    And user selects data in following fields in Refit DCF:
      | field                | value                  |
      | ProspectRelationship | Director               |
      | OnboardingType       | Automation(DoNotTouch) |
      | ParentProspect       | PermissionLead         |
    And user clicks on 'CreateProspectButton' on 'Refit' page
    Then user should see 'PermissionChild2' prospect below 'PermissionLead' prospect
    And user should not see 'EditProspect' button for 'PermissionChild1' prospect
    And user should see 'EditProspect' button for 'PermissionChild2' prospect
    When user search and open prospect with name:'PermissionChild1'
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text "Data Collection Requests" on Onboarding page
    And user generates data collection link and open
    And user enter OTP received on "testautomations+PermissionChild1@riskscreen.com"
    And user clicks on 'ManageProspectButton' on 'Refit' page
    And user clicks on 'CreateProspect' on 'Refit' page
    And user clicks on "DefaultEmailCheckbox" on "Refit" page
    And user enter data in following fields in Refit DCF:
      | field      | value                  |
      | FamilyName | PermissionChild3<Date> |
    And user selects data in following fields in Refit DCF:
      | field                | value                  |
      | ProspectRelationship | Director               |
      | OnboardingType       | Automation(DoNotTouch) |
      | ParentProspect       | PermissionLead         |
    And user clicks on 'CreateProspectButton' on 'Refit' page
    Then user should see 'PermissionChild3' prospect below 'PermissionLead' prospect
    And user should not see 'EditProspect' button for 'PermissionChild1' prospect
    And user should not see 'EditProspect' button for 'PermissionChild2' prospect
    And user should see 'EditProspect' button for 'PermissionChild3' prospect
    When user search and open prospect with name:'PermissionChild2'
    And user delete onboarding and prospect
    When user search and open prospect with name:'PermissionChild3'
    And user delete onboarding and prospect

  @CON107
  Scenario: 007 CON10 Externally added prospect would not receive an auto send mail if email template is not configured  and should receive email if email template is configured in OB type #ENG-T4362,T1131,T1132,T1050,T4319
    When user search and open prospect with name:'NoEmailConfiguredProspect'
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text "Data Collection Requests" on Onboarding page
    And user generates data collection link and open
    And user enter OTP received on "testautomations+NoEmailConfiguredProspect@riskscreen.com"
    And user clicks on 'ManageProspectButton' on 'Refit' page
    And user clicks on 'CreateProspect' on 'Refit' page
    Then user should see following properties mandatory:
      | Property                      |
      | Family name or corporate name |
      | Email address                 |
      | Relationship                  |
      | Onboarding type               |
      | Parent prospect               |
    When user enter data in following fields in Refit DCF:
      | field      | value                                                 |
      | FamilyName | NoEmailConfiguredChild<Date>                          |
      | Email      | testautomations+NoEmailConfiguredChild@riskscreen.com |
    And user selects data in following fields in Refit DCF:
      | field                | value                     |
      | ProspectRelationship | Director                  |
      | OnboardingType       | NoEmailConfigured         |
      | ParentProspect       | NoEmailConfiguredProspect |
    And user clicks on 'CreateProspectButton' on 'Refit' page
    Then user should see 'EmailConfiguredChild' prospect below 'NoEmailConfiguredProspect' prospect
    And user should not receive email on 'testautomations+EmailConfiguredChild@riskscreen.com' email
    When user search and open prospect with name:'EmailConfiguredProspect'
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text "Data Collection Requests" on Onboarding page
    And user generates data collection link and open
    And user enter OTP received on "testautomations+EmailConfiguredProspect@riskscreen.com"
    And user clicks on 'ManageProspectButton' on 'Refit' page
    And user clicks on 'CreateProspect' on 'Refit' page
    And user enter data in following fields in Refit DCF:
      | field      | value                                               |
      | FamilyName | EmailConfiguredChild<Date>                          |
      | Email      | testautomations+EmailConfiguredChild@riskscreen.com |
    And user selects data in following fields in Refit DCF:
      | field                | value                   |
      | ProspectRelationship | Director                |
      | OnboardingType       | EmailConfigured         |
      | ParentProspect       | EmailConfiguredProspect |
    And user clicks on 'CreateProspectButton' on 'Refit' page
    Then user should see 'EmailConfiguredChild' prospect below 'EmailConfiguredProspect' prospect
    Then user should receive email from:'noreply@riskscreen.com' and to:'testautomations+EmailConfiguredChild@riskscreen.com' and body should contains 'Email Configured'
    When user search and open prospect with name:'NoEmailConfiguredChild'
    And user delete onboarding and prospect
    When user search and open prospect with name:'EmailConfiguredChild'
    And user delete onboarding and prospect

  @CON108
  Scenario: 008 CON10  User should not be allowed to create new prospect with the SAME INTERFACE REFERENCE ID and correct error message should be displayed #ENG-T2272
    When user search and open prospect with name:'SameRefIdProspect'
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text "Data Collection Requests" on Onboarding page
    And user generates data collection link and open
    And user enter OTP received on "testautomations+SameRefIdProspect@riskscreen.com"
    And user clicks on 'ManageProspectButton' on 'Refit' page
    And user clicks on 'CreateProspect' on 'Refit' page
    And user enter data in following fields in Refit DCF:
      | field             | value                                                 |
      | FamilyName        | SameRefIdProspectChild<Date>                          |
      | Email             | testautomations+SameRefIdProspectChild@riskscreen.com |
      | ProspectReference | SimilarRefId                                          |
    And user selects data in following fields in Refit DCF:
      | field                | value                  |
      | ProspectRelationship | Director               |
      | OnboardingType       | Automation(DoNotTouch) |
      | ParentProspect       | SameRefIdProspect      |
    And user clicks on 'CreateProspectButton' on 'Refit' page
    Then user should see 'Interface Reference SimilarRefId is already associated with an existing Client Prospect' text in 'TopErrorMessage' field on 'Refit' page

  @CON109
  Scenario: 009 CON10 DE In the case of Multiple Lead prospect in group due to KYB Lookup, the email address of the manually added lead prospect in the group should be carried further. #ENG-T1566,T4375
    When user search and open prospect with name:'MultipleLeadProspect'
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text "Data Collection Requests" on Onboarding page
    And user generates data collection link and open
    And user enter OTP received on "testautomations+MultipleLeadProspect@riskscreen.com"
    And user clicks on 'ManageProspectButton' on 'Refit' page
    And user clicks on 'CreateProspect' on 'Refit' page
    And user enter data in following fields in Refit DCF:
      | field      | value        |
      | FamilyName | CON10Test009 |
    And user selects data in following fields in Refit DCF:
      | field                | value                  |
      | ProspectRelationship | (None)                 |
      | OnboardingType       | Automation(DoNotTouch) |
      | ParentProspect       | MultipleLeadProspect   |
    And user clicks on "DefaultEmailCheckbox" on "Refit" page
    And user clicks on 'CreateProspectButton' on 'Refit' page
    When user clicks edit button of '' prospect on refit page
    Then user should see "testautomations+MultipleLeadProspect@riskscreen.com" value in "Email" field on "Refit" page
    When user search and open prospect with name:'CON10Test009'
    And user delete onboarding and prospect
