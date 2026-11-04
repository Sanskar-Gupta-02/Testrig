@Regression @AutoCreationProspect
Feature: External DCF Refit

  Background:
    Given user login into 'REFIT' application with 'HandlerUserName' user
    And user is authorized using an 'APIKEY'

  @AutoCreationProspect1 @Test @deleteOnboarding
  Scenario: 001 Autocreation of prospect should take place with 'Create prospect and onboarding from external form' setting and should get linked to correct prospect group #ENG-T362,T3686,T361,T4187,T1382,T2654
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitAutoCreationOBType(Do Not Touch)' OB type on 'OnboardingType' page
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'OBManageProspectGroup' on 'OnboardingType' page
    And user clicks on 'PropertyGroup1' on 'OnboardingType' page
    And user clicks on 'PropectAutoCreationSetting1' on 'OnboardingType' page
    Then user should see 'LastName' option selected on 'LastNameProperty' on 'OnboardingType' page
    And user should see 'FirstName' option selected on 'FirstNameProperty' on 'OnboardingType' page
    And user should see 'Email' option selected on 'EmailProperty' on 'OnboardingType' page
    And user should see 'RefitAutoCreationOBType(Do Not Touch)' option selected on 'OnboardingTypeProperty' on 'OnboardingType' page
    And user should see 'Create prospect and onboarding from external form' option selected on 'ActionDropdown' on 'OnboardingType' page
    # Create onboarding and data request, generate data collection link using API
    When user creates an onboarding for prospect "607121" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "607121" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutoCreationProspect@riskscreen.com" email
    And user enter "Auto-LastName" text in "Group1TextField" field on "Refit" page
    And user enter "Auto-FirstName" text in "Group1TextField2" field on "Refit" page
    And user enter "Auto-Email" text in "Group1TextField3" field on "Refit" page
    And user select "Director" option in "Group1DropdownField4" dropdown on "Refit" page
    And user select "AutoCreationProspectS1" option in "Group1DropdownField5" dropdown on "Refit" page
    And user wait from 5 seconds
    And user enter "13" text in "Group1Property6UBOPercentage" field on "Refit" page
    And user enter "26" text in "Group1Property7DOPercentage" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutoCreationProspectS1',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    When user clicks on Onboarding Stage Tab with text 'Auto Prospect Status' on Onboarding page
    Then user should see "Group 1" on "AutocreationProperty" on "Onboarding" page
    And user should see "Auto-LastName Auto-FirstName" on "AutocreationProspect" on "Onboarding" page
    And user should see "Created" on "AutocreationProspectStatus" on "Onboarding" page
    When user clicks on "GoBackLink" on "Onboarding" page
    And user clicks on "ProspectRelationshipsTable" on "Onboarding" page
    Then user should see 'Auto-LastName Auto-FirstN...' prospect below 'AutoCreationProspectS1' prospect in prospect group structure
    When user double clicks on 'Auto-LastName Auto-FirstN...' prospect in prospect group structure
    And user clicks on 'ViewProspectLink' on 'ManageProspectGroup' page
    And user switch to 'Prospect » KYC360 (TEST)' page
    Then user should see "OnboardingTable" table on "Prospect" page
    When user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    Then user should see "No data requests could be found." on "NoDataRequestMessage" on "Onboarding" page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutoCreationProspectS1',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    When user clicks on Onboarding Stage Tab with text 'Auto Prospect Status' on Onboarding page
    Then user should see "Created" on "AutocreationProspectStatus" on "Onboarding" page
    When user clicks on "EditDeleteLink" on "Onboarding" page
    And user clicks on "DeleteOnBoardingLink" on "Onboarding" page
    And user clicks on "OnboardingConfirmDeletionButton" on "Onboarding" page
    And user clicks on "DeleteProspectButton" on "Onboarding" page
    And user clicks on "OnboardingConfirmDeletionButton" on "Onboarding" page

  @deleteOnboarding @AutoCreationProspect2
  Scenario: 002 Create prospect, onboarding, push to screening from external form action should work from External DCF only
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'PushToScreeningOB(DoNotTouch)' OB type on 'OnboardingType' page
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'OBManageProspectGroup' on 'OnboardingType' page
    And user clicks on 'ManagePropertyGroupsName' on 'OnboardingType' page
    Then user should see "Name" on "FirstProperty" on "OnboardingType" page
    When user clicks on 'AutocreationSettings' on 'OnboardingType' page
    Then user should see 'Create prospect, onboarding and push to screening from external form' option selected on 'ActionDropdown' on 'OnboardingType' page
   # Create onboarding and data request, generate data collection link using API
    When user creates an onboarding for prospect "607127" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "607127" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutoCreationProspectS2@riskscreen.com" email
    And user enter "Nirav" text in "Group1TextField" field on "Refit" page
    And user enter "Modi" text in "Group1TextField2" field on "Refit" page
    And user enter "25" text in "Group1TextField3" field on "Refit" page
    And user enter "Auto-CustomId" text in "Group1TextField4" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for some time to autocreation prospect to get complete
    And user wait until autocreation process is complete
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'Modi',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'ScreeningLink' on 'ManageProspect' page
    And user clicks on 'RevertDataButton' on 'ManageProspect' page
    And user clicks on 'Back' on 'ManageProspect' page
    And user delete onboarding and prospect

  @deleteOnboarding @AutoCreationProspect3
  Scenario: 003 AutoCreation should take place for Create Prospect, Onboarding, data request, send data External DCF Form
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitAutoCreationS3(DoNotTouch)' OB type on 'OnboardingType' page
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'OBManageProspectGroup' on 'OnboardingType' page
    And user clicks on 'ManagePropertyGroupsName' on 'OnboardingType' page
    Then user should see "Name" on "FirstProperty" on "OnboardingType" page
    When user clicks on 'AutocreationSettings' on 'OnboardingType' page
    Then user should see 'Create prospect, onboarding, data request and send data request from external form' option selected on 'ActionDropdown' on 'OnboardingType' page
    # Create onboarding and data request, generate data collection link using API
    When user creates an onboarding for prospect "607115" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "607115" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutoCreationProspectS3@riskscreen.com" email
    And user enter "Auto-Name" text in "Group1TextField" field on "Refit" page
    And user enter "Auto-UserName3" text in "Group1TextField2" field on "Refit" page
    And user enter "25" text in "Group1TextField3" field on "Refit" page
    And user enter "Auto-Address" text in "Group1TextField4" field on "Refit" page
    And user enter "Auto-CustomId" text in "Group1TextField5" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for some time to autocreation prospect to get complete
    And user wait until autocreation process is complete
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutoCreationProspectS3',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Auto Prospect Status' on Onboarding page
    Then user should see "Group 1" on "AutocreationProperty" on "Onboarding" page
    And user should see "Auto-Name Auto-Address Auto-UserName3" on "AutocreationProspect" on "Onboarding" page
    And user should see "Created" on "AutocreationProspectStatus" on "Onboarding" page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user should see "DataCollectionTable" table on "Onboarding" page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'Auto-UserName3',selects SearchOn:'Last name' and select prospect from list
    #And user should receives email from:"" and to:"" and body should contains ""
    And user clicks on 'DeleteOnboardingButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    And user clicks on 'DeleteProspectButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page

  @deleteOnboarding @AutoCreationProspect4
  Scenario: 004 Create prospect from external form action should work from External DCF only.
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitAutoCreationS4(DoNotTouch)' OB type on 'OnboardingType' page
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'OBManageProspectGroup' on 'OnboardingType' page
    And user clicks on 'ManagePropertyGroupsName' on 'OnboardingType' page
    Then user should see "Name" on "FirstProperty" on "OnboardingType" page
    When user clicks on 'AutocreationSettings' on 'OnboardingType' page
    Then user should see 'Create prospect from external form' option selected on 'ActionDropdown' on 'OnboardingType' page
    # Create onboarding and data request, generate data collection link using API
    When user creates an onboarding for prospect "607112" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "607112" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutoCreationProspectS4@riskscreen.com" email
    And user enter "Update-Name" text in "Group1TextField" field on "Refit" page
    And user enter "Update-UserName4" text in "Group1TextField2" field on "Refit" page
    And user enter "25" text in "Group1TextField3" field on "Refit" page
    And user enter "Update-Address" text in "Group1TextField4" field on "Refit" page
    And user enter "Update-CustomId" text in "Group1TextField5" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for some time to autocreation prospect to get complete
    And user wait until autocreation process is complete
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'Update-UserName4',selects SearchOn:'Last name' and select prospect from list
    Then user should see "RefitAutoCreationS4(DoNot..." on "OnboardingTypeOnProspect" on "ManageProspect" page
    And user should see "No onboardings could be found." on "NoOnboardingMessage" on "ManageProspect" page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'Update-UserName4',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DeleteProspectButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page

  @deleteOnboarding @AutoCreationProspect5
  Scenario: 005 Autocreation of prospect with 'Create prospect, onboarding and data request from internal and external form' setting using journey of a prospect who is member of multiple groups
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitAutocreationAutomationS5(Do Not Touch)' OB type on 'OnboardingType' page
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'OBManageProspectGroup' on 'OnboardingType' page
    And user clicks on 'ManagePropertyGroupsName' on 'OnboardingType' page
    And user clicks on 'AutocreationSettings' on 'OnboardingType' page
    Then user should see 'Create prospect, onboarding and data request from internal and external form' option selected on 'ActionDropdown' on 'OnboardingType' page
    Then user should see 'property1' option selected on 'LastNameProperty' on 'OnboardingType' page
    Then user should see 'property3' option selected on 'FirstNameProperty' on 'OnboardingType' page
    Then user should see 'property2' option selected on 'EmailProperty' on 'OnboardingType' page
    Then user should see 'RefitAutocreationAutomationS5(Do Not Touch)' option selected on 'OnboardingTypeProperty' on 'OnboardingType' page
    # Create onboarding and data request, generate data collection link using API
    When user store value:'607104' with keyName:'prospectID'
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
    # Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutoCreationProspectS5@riskscreen.com" email
    And user enter "Last" text in "Group1TextField" field on "Refit" page
    And user enter "testautomations+autoProspect@riskscreen.com" text in "Group1TextField2" field on "Refit" page
    And user enter "First" text in "Group1TextField3" field on "Refit" page
    And user select "AutocreationProspectS5" option in "ParentProspectDropdown1" dropdown on 'Refit' page
    And user select "Director" option in "ProspectRelationshipRoleDropdown1" dropdown on 'Refit' page
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for some time to autocreation prospect to get complete
    And user wait until autocreation process is complete
    And user navigates to the 'ManageProspectGroup' page with the page title 'Manage Prospect Groups'
    And user enter "AutocreationGroup1" text in "SearchName" field on "ManageProspectGroup" page
    And user clicks on 'SearchProspectGroupsButton' on 'ManageProspectGroup' page
    And user wait from 3 seconds
    And user clicks on 'FirstProspectGroup' on 'ManageProspectGroup' page
    Then user should see 'First Last (Director)' prospect below 'AutocreationProspectS5' prospect in prospect group structure
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreationProspectS5',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Auto Prospect Status' on Onboarding page
    Then user should see "Created" on "AutocreationProspectStatus" on "Onboarding" page
    When user clicks on "EditDeleteLink" on "Onboarding" page
    Then user should see "RefitAutocreationAutomati..." on "OnboardingTypeOnProspect" on "ManageProspect" page
    When user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    Then user should see "DataCollectionRequest" table on "ManageProspectGroup" page
    When user clicks on "GoBackLink" on "Onboarding" page
    And user clicks on 'DeleteOnboardingButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    And user clicks on 'DeleteProspectButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    And user enter SearchName:'AutocreationProspectS5',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DeleteOnboardingButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    #And user clicks on 'CreateOnboardingLink' on 'ManageProspect' page
    #And user clicks on 'ConfirmationOnboarding' on 'ManageProspect' page
    When user store value:'607104' with keyName:'prospectID'
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
    And user refresh the page
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Auto Prospect Status' on Onboarding page
    And user select "AutocreationGroup2" option in "AutocreationProspectGroupDropdown" dropdown on 'Onboarding' page
    And user clicks on 'SaveProspectGroup' on 'Onboarding' page
    And user clicks on 'ConfirmDialogDataCollection' on 'Onboarding' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user clicks on 'SendLink' on 'ManageProspect' page
    And user clicks on 'GenerateDataCollectionLink' on 'ManageProspect' page
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutoCreationProspectS5@riskscreen.com" email
    And user enter "Last2" text in "Group1TextField" field on "Refit" page
    And user enter "testautomations+autoProspect@riskscreen.com" text in "Group1TextField2" field on "Refit" page
    And user enter "First2" text in "Group1TextField3" field on "Refit" page
    And user select "AutocreationProspectS5" option in "ParentProspectDropdown1" dropdown on 'Refit' page
    And user select "Director" option in "ProspectRelationshipRoleDropdown1" dropdown on 'Refit' page
    And user clicks on 'ContinueButton' on 'Refit' page
    When user navigates to the 'ManageProspectGroup' page with the page title 'Manage Prospect Groups'
    And user enter "AutocreationGroup2" text in "SearchName" field on "ManageProspectGroup" page
    And user clicks on 'SearchProspectGroupsButton' on 'ManageProspectGroup' page
    And user clicks on 'FirstProspectGroup' on 'ManageProspectGroup' page
    Then user should see 'First2 Last2 (Director)' prospect below 'AutocreationProspectS5' prospect in prospect group structure
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreationProspectS5',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Auto Prospect Status' on Onboarding page
    Then user should see "Created" on "AutocreationProspectStatus" on "Onboarding" page
    When user clicks on "EditDeleteLink" on "Onboarding" page
    Then user should see "RefitAutocreationAutomati..." on "OnboardingTypeOnProspect" on "ManageProspect" page
    When user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    Then user should see "DataCollectionRequest" table on "ManageProspectGroup" page
    When user clicks on "GoBackLink" on "Onboarding" page
    And user clicks on 'DeleteOnboardingButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    And user clicks on 'DeleteProspectButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page

  @deleteOnboarding @AutoCreationProspect6
  Scenario: 006 Create prospect and onboarding from internal and external form should work and auto created prospect should get assigned to prospect group
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitAutoCreationS6(DoNotTouch)' OB type on 'OnboardingType' page
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'OBManageProspectGroup' on 'OnboardingType' page
    And user clicks on 'ManagePropertyGroupsName' on 'OnboardingType' page
    Then user should see "Name" on "FirstProperty" on "OnboardingType" page
    When user clicks on 'AutocreationSettings' on 'OnboardingType' page
    Then user should see 'Create prospect and onboarding from internal and external form' option selected on 'ActionDropdown' on 'OnboardingType' page
    # Create onboarding and data request, generate data collection link using API
    When user creates an onboarding for prospect "607131" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "607131" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutoCreationProspectS6@riskscreen.com" email
    And user enter "Auto-Name" text in "Group1TextField" field on "Refit" page
    And user enter "Auto-UserName6" text in "Group1TextField2" field on "Refit" page
    And user enter "25" text in "Group1TextField3" field on "Refit" page
    And user enter "Auto-Address" text in "Group1TextField4" field on "Refit" page
    And user enter "Auto-CustomId" text in "Group1TextField5" field on "Refit" page
    And user select "AutoCreationProspectS6" option in "Group1DropdownField7" dropdown on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for some time to autocreation prospect to get complete
    And user wait until autocreation process is complete
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutoCreationProspectS6',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Auto Prospect Status' on Onboarding page
    Then user should see "Group 1" on "AutocreationProperty" on "Onboarding" page
    And user should see "Auto-Name Auto-Address Auto-UserName6" on "AutocreationProspect" on "Onboarding" page
    And user should see "Created" on "AutocreationProspectStatus" on "Onboarding" page
    When user clicks on "GoBackLink" on "Onboarding" page
    And user clicks on "ProspectRelationshipsTable" on "Onboarding" page
    Then user should see 'Auto-Name Auto-Address Au...' prospect below 'AutoCreationProspectS6' prospect in prospect group structure
    When user double clicks on 'Auto-Name Auto-Address Au...' prospect in prospect group structure
    And user clicks on 'ViewProspectLink' on 'ManageProspectGroup' page
    And user switch to 'Prospect » KYC360 (TEST)' page
    Then user should see "OnboardingTable" table on "Prospect" page
    When user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    Then user should see "No data requests could be found." on "NoDataRequestMessage" on "Onboarding" page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'Auto-UserName6',selects SearchOn:'Last name' and select prospect from list
    Then user should see "Data Collection" on "OnboardingStatus" on "ManageProspect" page
    When user clicks on "DeleteOnBoardingLink" on "Onboarding" page
    And user clicks on "OnboardingConfirmDeletionButton" on "Onboarding" page
    And user clicks on "DeleteProspectButton" on "Onboarding" page
    And user clicks on "OnboardingConfirmDeletionButton" on "Onboarding" page

  @deleteOnboarding @AutoCreationProspect7
  Scenario: 007 Create prospect, onboarding data request and send data request from internal and external' action should work as expected
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitAutoCreationS7(DoNotTouch)' OB type on 'OnboardingType' page
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'OBManageProspectGroup' on 'OnboardingType' page
    And user clicks on 'ManagePropertyGroupsName' on 'OnboardingType' page
    Then user should see "Name" on "FirstProperty" on "OnboardingType" page
    When user clicks on 'AutocreationSettings' on 'OnboardingType' page
    Then user should see 'Create prospect, onboarding, data request and send data request from internal and external form' option selected on 'ActionDropdown' on 'OnboardingType' page
    # Create onboarding and data request, generate data collection link using API
    When user creates an onboarding for prospect "607117" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "607117" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutoCreationProspectS7@riskscreen.com" email
    # Navigate to the external DCF Refit page
    And user enter "Auto-Name" text in "Group1TextField" field on "Refit" page
    And user enter "Auto-UserName7" text in "Group1TextField2" field on "Refit" page
    And user enter "25" text in "Group1TextField3" field on "Refit" page
    And user enter "Auto-Address" text in "Group1TextField4" field on "Refit" page
    And user enter "Auto-CustomId" text in "Group1TextField5" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for some time to autocreation prospect to get complete
    And user wait until autocreation process is complete
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutoCreationProspectS7',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Auto Prospect Status' on Onboarding page
    Then user should see "Group 1" on "AutocreationProperty" on "Onboarding" page
    And user should see "Auto-Name Auto-Address Auto-UserName7" on "AutocreationProspect" on "Onboarding" page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'Auto-UserName7',selects SearchOn:'Last name' and select prospect from list
    #And user should receives email from:"" and to:"" and body should contains ""
    And user clicks on 'DeleteOnboardingButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    And user clicks on 'DeleteProspectButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page

  @deleteOnboarding @AutoCreationProspect8
  Scenario: 008 Create prospect, onboarding and data request from external form should work and autocreated prospect should get assigned to prospect group
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitAutoCreationS8(DoNotTouch)' OB type on 'OnboardingType' page
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'OBManageProspectGroup' on 'OnboardingType' page
    And user clicks on 'ManagePropertyGroupsName' on 'OnboardingType' page
    Then user should see "Name" on "FirstProperty" on "OnboardingType" page
    When user clicks on 'AutocreationSettings' on 'OnboardingType' page
    Then user should see 'Create prospect, onboarding and data request from external form' option selected on 'ActionDropdown' on 'OnboardingType' page
    # Create onboarding and data request, generate data collection link using API
    And user creates an onboarding for prospect "607207" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "607207" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutoCreationProspectS8@riskscreen.com" email
    And user enter "Auto-Name" text in "Group1TextField" field on "Refit" page
    And user enter "Auto-UserName8" text in "Group1TextField2" field on "Refit" page
    And user enter "25" text in "Group1TextField3" field on "Refit" page
    And user enter "Auto-Address" text in "Group1TextField4" field on "Refit" page
    And user select "Director" option in "DropdownField5" dropdown on "Refit" page
    And user select "AutoCreationProspectS8" option in "DropdownField6" dropdown on "Refit" page
    And user enter "Auto-CustomId" text in "Group1TextField5" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for some time to autocreation prospect to get complete
    And user wait until autocreation process is complete
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutoCreationProspectS8',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Auto Prospect Status' on Onboarding page
    Then user should see "Group 1" on "AutocreationProperty" on "Onboarding" page
    And user should see "Auto-Name Auto-Address Auto-UserName8" on "AutocreationProspect" on "Onboarding" page
    And user should see "Created" on "AutocreationProspectStatus" on "Onboarding" page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    And user should able see "DataCollectionTable" on "Onboarding" page
    When user clicks on "GoBackLink" on "Onboarding" page
    And user clicks on "ProspectRelationshipsTable" on "Onboarding" page
    Then user should see 'Auto-Name Auto-Address Au...' prospect below 'AutoCreationProspectS8' prospect in prospect group structure
    When user double clicks on 'Auto-Name Auto-Address Au...' prospect in prospect group structure
    And user clicks on 'ViewProspectLink' on 'ManageProspectGroup' page
    And user switch to 'Prospect » KYC360 (TEST)' page
    Then user should see "OnboardingTable" table on "Prospect" page
    When user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    Then user should see "DataCollectionTable" table on "Onboarding" page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'Auto-UserName8',selects SearchOn:'Last name' and select prospect from list
    Then user should see "RefitAutoCreationS8(DoNot..." on "OnboardingTypeOnProspect" on "ManageProspect" page
    And user should see "Data Collection" on "OnboardingStatus" on "ManageProspect" page
    When user clicks on 'DeleteOnboardingButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    And user clicks on 'DeleteProspectButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page

  @deleteOnboarding @AutoCreationProspect9
  Scenario: 009 Create prospect from internal and external form should work and autocreated prospect should get assigned to prospect group
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitAutoCreationS9(DoNotTouch)' OB type on 'OnboardingType' page
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'OBManageProspectGroup' on 'OnboardingType' page
    And user clicks on 'ManagePropertyGroupsName' on 'OnboardingType' page
    Then user should see "Name" on "FirstProperty" on "OnboardingType" page
    When user clicks on 'AutocreationSettings' on 'OnboardingType' page
    Then user should see 'Create prospect from internal and external form' option selected on 'ActionDropdown' on 'OnboardingType' page
    # Create onboarding and data request, generate data collection link using API
    When user store value:'607217' with keyName:'prospectID'
    And user creates an onboarding for prospect "607217" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "607217" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutoCreationProspectS9@riskscreen.com" email
    And user enter "Auto-Name" text in "Group1TextField" field on "Refit" page
    And user enter "Auto-UserName9" text in "Group1TextField2" field on "Refit" page
    And user enter "25" text in "Group1TextField3" field on "Refit" page
    And user enter "Auto-Address" text in "Group1TextField4" field on "Refit" page
    And user enter "Auto-CustomId" text in "Group1TextField5" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for some time to autocreation prospect to get complete
    And user wait until autocreation process is complete
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutoCreationProspectS9',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Auto Prospect Status' on Onboarding page
    Then user should see "Group 1" on "AutocreationProperty" on "Onboarding" page
    And user should see "Auto-Name Auto-Address Auto-UserName9" on "AutocreationProspect" on "Onboarding" page
    And user should see "Created" on "AutocreationProspectStatus" on "Onboarding" page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'Auto-UserName9',selects SearchOn:'Last name' and select prospect from list
    Then user should see "RefitAutoCreationS9(DoNot..." on "OnboardingTypeOnProspect" on "ManageProspect" page
    When user clicks on 'DeleteProspectButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page

  @deleteOnboarding @AutoCreationProspect10
  Scenario: 010 Handler user should get email if the autocreated prospect is already exists
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitAutoCreationS10(DoNotTouch)' OB type on 'OnboardingType' page
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'OBManageProspectGroup' on 'OnboardingType' page
    And user clicks on 'ManagePropertyGroupsName' on 'OnboardingType' page
    Then user should see "Name" on "FirstProperty" on "OnboardingType" page
    When user clicks on 'AutocreationSettings' on 'OnboardingType' page
    Then user should see 'Create prospect, onboarding and push to screening from internal and external form' option selected on 'ActionDropdown' on 'OnboardingType' page
    # Create onboarding and data request, generate data collection link using API
    And user creates an onboarding for prospect "607228" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "607228" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutoCreationProspectS10@riskscreen.com" email
    And user enter "Auto-Name" text in "Group1TextField" field on "Refit" page
    And user enter "Auto-UserName4" text in "Group1TextField2" field on "Refit" page
    And user enter "25" text in "Group1TextField3" field on "Refit" page
    And user enter "Auto-Address" text in "Group1TextField4" field on "Refit" page
    And user enter "Auto-CustomId" text in "Group1TextField5" field on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for some time to autocreation prospect to get complete
    And user wait until autocreation process is complete
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutoCreationProspectS10',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Auto Prospect Status' on Onboarding page
    Then user should see "Group 1" on "AutocreationProperty" on "Onboarding" page
    And user should see "Auto-Name Auto-Address Auto-UserName4" on "AutocreationProspect" on "Onboarding" page
    And user should see "Not created - Match already exists" on "AutocreationProspectStatus" on "Onboarding" page

  @AutoCreationProspect11
  Scenario: 011 Create Autocreation ANP with 10 settings & prospects linked to mixed parent accounts
    # Create onboarding and data request, generate data collection link using API
    When user store value:'608693' with keyName:'prospectID'
    And user creates an onboarding for prospect "608693" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "608693" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutoCreationProspectS11@riskscreen.com" email
    And user enter "S1P1" text in "Group1Property1" field on "Refit" page
    And user enter "S1P2" text in "Group1Property2" field on "Refit" page
    And user select "AutoCreationProspectS11" option in "ParentProspectDropdown1" dropdown on "Refit" page
    And user enter "Ambani" text in "Group2Property1" field on "Refit" page
    And user enter "Neeta" text in "Group2Property2" field on "Refit" page
    And user select "AutoCreationProspectS11" option in "ParentProspectDropdown2" dropdown on "Refit" page
    And user enter "S3P5" text in "Group3Property1" field on "Refit" page
    And user enter "S3P6" text in "Group3Property2" field on "Refit" page
    And user select "AutoCreationProspectS11" option in "ParentProspectDropdown3" dropdown on "Refit" page
    And user enter "S4P7" text in "Group4Property1" field on "Refit" page
    And user enter "S4P8" text in "Group4Property2" field on "Refit" page
    And user select "AutoCreationProspectS11" option in "ParentProspectDropdown4" dropdown on "Refit" page
    And user enter "S5P9" text in "Group5Property1" field on "Refit" page
    And user enter "S5P10" text in "Group5Property2" field on "Refit" page
    And user select "AutoCreationProspectS11" option in "ParentProspectDropdown5" dropdown on "Refit" page
    And user enter "S6P11" text in "Group6Property1" field on "Refit" page
    And user enter "S6P12" text in "Group6Property2" field on "Refit" page
    And user select "AutoCreationProspect-temp" option in "ParentProspectDropdown6" dropdown on "Refit" page
    And user enter "S7P13" text in "Group7Property1" field on "Refit" page
    And user enter "S7P14" text in "Group7Property2" field on "Refit" page
    And user select "AutoCreationProspect-temp" option in "ParentProspectDropdown7" dropdown on "Refit" page
    And user enter "S8P15" text in "Group8Property1" field on "Refit" page
    And user enter "S8P16" text in "Group8Property2" field on "Refit" page
    And user select "AutoCreationProspect-temp" option in "ParentProspectDropdown8" dropdown on "Refit" page
    And user enter "S9P17" text in "Group9Property1" field on "Refit" page
    And user enter "S9P18" text in "Group9Property2" field on "Refit" page
    And user select "AutoCreationProspect-temp" option in "ParentProspectDropdown9" dropdown on "Refit" page
    When user enter "Ambani" text in "Group10Property1" field on "Refit" page
    And user enter "S10P20" text in "Group10Property2" field on "Refit" page
    And user select "AutoCreationProspect-temp" option in "ParentProspectDropdown10" dropdown on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for some time to autocreation prospect to get complete
    And user wait until autocreation process is complete
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutoCreationProspectS11',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Auto Prospect Status' on Onboarding page
    Then user should see 'Created' on all 'AllAutocreationProspectStatus' on 'Onboarding' page
    When user clicks on "GoBackLink" on "Onboarding" page
    And user clicks on "ProspectRelationshipsTable" on "Onboarding" page
    And user wait from 5 seconds
    Then user should see 'S1P1 S1P1' prospect below 'AutoCreationProspectS11' prospect in prospect group structure
    And user should see 'Neeta Ambani' prospect below 'AutoCreationProspectS11' prospect in prospect group structure
    And user should see 'S3P5 S3P5' prospect below 'AutoCreationProspectS11' prospect in prospect group structure
    And user should see 'S4P7 S4P7' prospect below 'AutoCreationProspectS11' prospect in prospect group structure
    And user should see 'S5P9 S5P9' prospect below 'AutoCreationProspectS11' prospect in prospect group structure
    And user should see 'S6P11 S6P11' prospect below 'AutoCreationProspect-temp' prospect in prospect group structure
    And user should see 'S7P13 S7P13' prospect below 'AutoCreationProspect-temp' prospect in prospect group structure
    And user should see 'S8P15 S8P15' prospect below 'AutoCreationProspect-temp' prospect in prospect group structure
    And user should see 'S9P17 S9P17' prospect below 'AutoCreationProspect-temp' prospect in prospect group structure
    And user should see 'Ambani' prospect below 'AutoCreationProspect-temp' prospect in prospect group structure
    #Action to verify 'Create prospect and onboarding from external form
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'S1P1',selects SearchOn:'Last name' and select prospect from list
    And user should able see "OnboardingTable" on "Onboarding" page
    And user clicks on "DeleteOnboardingButton" on "Onboarding" page
    And user clicks on "OnboardingConfirmDeletionButton" on "Onboarding" page
    And user clicks on "DeleteProspectButton" on "Onboarding" page
    And user clicks on "OnboardingConfirmDeletionButton" on "Onboarding" page
    #Action to verify 'Create prospect, onboarding and push to screening from external form'
    And user enter SearchName:'Ambani',selects SearchOn:'Last name' and select prospect from list
    Then user should see "Screening" on "OnboardingStatus" on "ManageProspect" page
    When user clicks on 'OnboardingTypeName' on 'ManageProspect' page
    And user clicks on 'RevertDataButton' on 'ManageProspect' page
    And user clicks on 'Back' on 'ManageProspect' page
    Then user should able see "OnboardingTable" on "ManageProspect" page
    When user clicks on 'DeleteOnboardingButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    And user clicks on 'DeleteProspectButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    #Action to verify 'Create prospect, onboarding, data request and send data request from external form'
    And user enter SearchName:'S3P5',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    Then user should able see "DataCollectionTable" on "ManageProspect" page
    And user should see "Resend" on "DataCollectionSendAction" on "ManageProspect" page
    When user clicks on "GoBackLink" on "ManageProspect" page
    Then user should able see "OnboardingTable" on "ManageProspect" page
    When user clicks on 'DeleteOnboardingButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    And user clicks on 'DeleteProspectButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    #Create prospect from external form
    And user enter SearchName:'S4P7',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DeleteProspectButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    #Create prospect, onboarding and data request from internal and external form
    And user enter SearchName:'S5P9',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DeleteOnboardingButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    And user clicks on 'DeleteProspectButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    #Create prospect and onboarding from internal and external form
    And user enter SearchName:'S6P11',selects SearchOn:'Last name' and select prospect from list
    Then user should able see "OnboardingTable" on "ManageProspect" page
    When user clicks on 'DeleteOnboardingButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    And user clicks on 'DeleteProspectButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    #Create prospect, onboarding, data request and send data request from internal and external form
    And user enter SearchName:'S7P13',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    Then user should able see "DataCollectionTable" on "ManageProspect" page
    And user should see "Resend" on "DataCollectionSendAction" on "ManageProspect" page
    When user clicks on "GoBackLink" on "ManageProspect" page
    Then user should able see "OnboardingTable" on "ManageProspect" page
    When user clicks on 'DeleteOnboardingButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    And user clicks on 'DeleteProspectButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    #Create prospect, onboarding and data request from external form
    And user enter SearchName:'S8P15',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Data Collection Requests' on Onboarding page
    Then user should able see "DataCollectionTable" on "ManageProspect" page
    When user clicks on "GoBackLink" on "ManageProspect" page
    Then user should able see "OnboardingTable" on "ManageProspect" page
    When user clicks on 'DeleteOnboardingButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    And user clicks on 'DeleteProspectButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    #Create prospect from internal and external form
    And user enter SearchName:'S9P17',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DeleteProspectButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    #Create prospect, onboarding and push to screening from internal and external form
    And user enter SearchName:'Ambani',selects SearchOn:'Last name' and select prospect from list
    Then user should see "Screening" on "OnboardingStatus" on "ManageProspect" page
    When user clicks on 'OnboardingTypeName' on 'ManageProspect' page
    And user clicks on 'RevertDataButton' on 'ManageProspect' page
    And user clicks on 'Back' on 'ManageProspect' page
    Then user should able see "OnboardingTable" on "Onboarding" page
    When user clicks on 'DeleteOnboardingButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    And user clicks on 'DeleteProspectButton' on 'ManageProspect' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page

  @AutoCreationProspect12 @deleteOnboarding
  Scenario: 012 Change the role attribute value for the ANP created prospect
    #Create onboarding and data request, generate data collection link using API
    When user creates an onboarding for prospect "608819" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "608819" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutoCreationProspectS12@riskscreen.com" email
    #Navigate to the external DCF Refit page
    And user enter "Mountains" text in "Group1Property1" field on "Refit" page
    And user enter "Mountains" text in "Group1Property2" field on "Refit" page
    And user select "Director" option in "ProspectRelationshipRoleDropdown1" dropdown on "Refit" page
    And user enter "10" text in "UBOOwnershipPercentage1" field on "Refit" page
    And user enter "20" text in "DirectOwnershipPercentage1" field on "Refit" page
    And user enter "30" text in "RoleAttribute1" field on "Refit" page
    And user enter "40" text in "RoleAttribute2" field on "Refit" page
    And user enter "50" text in "RoleAttribute3" field on "Refit" page
    And user enter "60" text in "RoleAttribute4" field on "Refit" page
    And user enter "Beach" text in "Group2Property1" field on "Refit" page
    And user enter "Beach" text in "Group2Property2" field on "Refit" page
    And user select "Shareholder" option in "ProspectRelationshipRoleDropdown2" dropdown on "Refit" page
    And user enter "10" text in "UBOOwnershipPercentage2" field on "Refit" page
    And user enter "20" text in "DirectOwnershipPercentage2" field on "Refit" page
    And user enter "30" text in "RoleAttribute1G2" field on "Refit" page
    And user enter "40" text in "RoleAttribute2G2" field on "Refit" page
    And user enter "50" text in "RoleAttribute3G2" field on "Refit" page
    And user enter "60" text in "RoleAttribute4G2" field on "Refit" page
    And user clicks on "ContinueButton" on "Refit" page
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutoCreationProspectS12',selects SearchOn:'Last name' and select prospect from list
    And user clicks on "ProspectRelationshipsTable" on "Onboarding" page
    Then user should see 'Mountains (Director)' prospect below 'AutoCreationProspectS12' prospect in prospect group structure
    And user should see 'Beach (Shareholder)' prospect below 'AutoCreationProspectS12' prospect in prospect group structure
    And user should see "Mountains (Director)" on "Prospect3" on "ManageProspectGroup" page
    When user clicks on "Prospect3" on "ManageProspectGroup" page
    And user wait from 3 seconds
    Then user should see "10" value in "UBOOwnershipPercentageStatus" field on the "ManageProspect" page
    And user should see "20" value in "DirectOwnershipPercentageStatus" field on the "ManageProspect" page
    And user should see "30.00" value in "AttributeValue1" field on the "ManageProspect" page
    And user should see "40.00" value in "AttributeValue2" field on the "ManageProspect" page
    And user should see "50.00" value in "AttributeValue3" field on the "ManageProspect" page
    And user should see "60.00" value in "AttributeValue4" field on the "ManageProspect" page
    When user clicks on "GoBackLink" on "ManageProspect" page
    Then user should see "Beach (Shareholder)" on "Prospect2" on "ManageProspectGroup" page
    When user clicks on "Prospect2" on "ManageProspectGroup" page
    And user wait from 3 seconds
    Then user should see "10" value in "UBOOwnershipPercentageStatus" field on the "ManageProspect" page
    And user should see "20" value in "DirectOwnershipPercentageStatus" field on the "ManageProspect" page
    And user should see "30.000000000" value in "AttributeValue1" field on the "ManageProspect" page
    And user should see "40.00" value in "AttributeValue2" field on the "ManageProspect" page
    And user should see "50.00" value in "AttributeValue3" field on the "ManageProspect" page
    And user should see "60.00" value in "AttributeValue4" field on the "ManageProspect" page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'Mountains',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'ViewProspectGroup' on 'Prospect' page
    When user clicks on "Prospect3" on "ManageProspectGroup" page
    And user clicks on 'DeleteProspectRelationship' on 'ManageProspectGroup' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    When user clicks on "Prospect2" on "ManageProspectGroup" page
    And user clicks on 'DeleteProspectRelationship' on 'ManageProspectGroup' page
    And user clicks on 'ConfirmDelete' on 'ManageProspect' page
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'Mountains',selects SearchOn:'Last name' and select prospect from list
    And user delete onboarding and prospect
    And user enter SearchName:'Beach',selects SearchOn:'Last name' and select prospect from list
    And user delete onboarding and prospect

  @deleteOnboarding @AutoCreationProspect13 @deleteAutocreatedOnboarding @deleteAutocreatedProspect
  Scenario: 013 Verify that the data entered in the DCF by the nominee is mapped and overwritten details of already exist prospect is displayed correctly. #ENG-T360,T363,T2105
    When user creates an onboarding for prospect "615063" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "615063" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'OnboardDataProspect',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user create a nominee with email "testautomations+OnboardDataProspectN1@riskscreen.com" with message "Test"
    And user checks Property Group or Data Document Type permission checkboxes
      | Personal Details |
    And user send data collection link to nominee with email: "testautomations+OnboardDataProspectN1@riskscreen.com" and open data collection link in new tab
    And user enter data in following fields in Refit DCF:
      | Field            | Value                          |
      | Group1TextField  | AutocreatedProspect            |
      | Group1TextField2 | KYC                            |
      | Group1TextField3 |                            360 |
      | Group1TextField4 | testautomations@riskscreen.com |
    And user clicks on 'SaveButton' on 'Refit' page
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'OnboardDataProspect',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    Then user should see Autocreated prospect with name "KYC 360 AutocreatedProspect"
    When user open Autocreated prospect with name "KYC 360 AutocreatedProspect"
    Then user should see prospect details as
      | Field           | Value                          |
      | Name            | KYC 360 AutocreatedProspect    |
      | Email           | testautomations@riskscreen.com |
      | Onboarding Type | AutocreationS13                |
      | Handler Group   | Handler Group                  |
      | Handler User    | Refit Automation               |
      | Prospect Status | Active                         |
    When user clicks on 'EditProspectLink' on 'Prospect' page
    And user update the following details and save
      | Field      | Value            |
      | Last Name  | UpdatedLastName  |
      | First Name | UpdatedFirstName |
    Then user should see prospect details as
      | Field           | Value                                |
      | Name            | UpdatedFirstName 360 UpdatedLastName |
      | Email           | testautomations@riskscreen.com       |
      | Onboarding Type | AutocreationS13                      |
      | Handler Group   | Handler Group                        |
      | Handler User    | Refit Automation                     |
      | Prospect Status | Active                               |
    When user store 'ProspectId' with keyName:'autoProspectID' from 'Prospect' page
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user store 'OnboardingId' with keyName:'autoOnboardingID' from 'Onboarding' page

  @deleteOnboarding @AutoCreationProspect14
  Scenario: 014 Verify that prospect should not be created from RS Onboard if 'Create Prospect from External Form' is chosen as the action in the ANP setting. #ENG-T711,T788
    When user creates an onboarding for prospect "615071" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "615071" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+OnboardDataProspect2@riskscreen.com" email
    And user enter data in following fields in Refit DCF:
      | Field            | Value                          |
      | Group1TextField  | AutocreatedProspectS01         |
      | Group1TextField2 | KYC                            |
      | Group1TextField3 |                            360 |
      | Group1TextField4 | testautomations@riskscreen.com |
    And user clicks on 'SaveButton' on 'Refit' page
    And user navigates to Prospect: "OnboardDataProspect2" with Search On: 'Last name' and click on 'DataCollectionLink'
    Then user should see Autocreated prospect with name "KYC 360 AutocreatedProspectS01"
    When user open Autocreated prospect with name "KYC 360 AutocreatedProspectS01"
    And user delete prospect
    And user navigates to Prospect: 'OnboardDataProspect2' with Search On: 'Last name' and click on 'DataCollectionLink'
    And user clicks on Onboarding Stage Tab with text 'Auto Prospect Status' on Onboarding page
    And user delete Prospect Autocreation Status for prospect '<prospect deleted>'
    And user enter data in following fields in internal form:
      | Field            | Value                          |
      | Group1TextField  | AutocreatedProspectS01         |
      | Group1TextField2 | KYC                            |
      | Group1TextField3 |                            360 |
      | Group1TextField4 | testautomations@riskscreen.com |
    And user clicks on 'SaveOnBoardingDataButton' on 'Onboarding' page
    Then user should not see Autocreated prospect with name "KYC 360 AutocreatedProspectS01"

  @deleteOnboarding @AutoCreationProspect15
  Scenario: 015 Verify that prospect should not be created from RS Onboard if - Create Prospect and Onboarding from External Form is chosen as the action in the ANP setting. #ENG-T1374
    When user creates an onboarding for prospect "615100" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "615100" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+OnboardDataProspect3@riskscreen.com" email
    And user enter data in following fields in Refit DCF:
      | Field            | Value                          |
      | Group1TextField  | AutocreatedProspectS15         |
      | Group1TextField2 | KYC                            |
      | Group1TextField3 |                            360 |
      | Group1TextField4 | testautomations@riskscreen.com |
    And user clicks on 'SaveButton' on 'Refit' page
    And user navigates to Prospect: "OnboardDataProspect3" with Search On: 'Last name' and click on 'DataCollectionLink'
    Then user should see Autocreated prospect with name "KYC 360 AutocreatedProspectS15"
    When user open Autocreated prospect with name "KYC 360 AutocreatedProspectS15"
    And user delete onboarding and prospect
    And user navigates to Prospect: 'OnboardDataProspect3' with Search On: 'Last name' and click on 'DataCollectionLink'
    And user enter data in following fields in internal form:
      | Field            | Value                          |
      | Group1TextField  | AutocreatedProspectS15         |
      | Group1TextField2 | KYC                            |
      | Group1TextField3 |                            360 |
      | Group1TextField4 | testautomations@riskscreen.com |
    And user clicks on 'SaveOnBoardingDataButton' on 'Onboarding' page
    Then user should not see Autocreated prospect with name "KYC 360 AutocreatedProspectS15"

  @deleteOnboarding @AutoCreationProspect16
  Scenario: 016 Verify that prospect should not be created from RS Onboard if Create Prospect, Onboarding and Data Request from External Form is chosen as the action in the ANP setting. #ENG-T1374
    When user creates an onboarding for prospect "615129" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "615129" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+OnboardDataProspect4@riskscreen.com" email
    And user enter data in following fields in Refit DCF:
      | Field            | Value                          |
      | Group1TextField  | AutocreatedProspectS16         |
      | Group1TextField2 | KYC                            |
      | Group1TextField3 |                            360 |
      | Group1TextField4 | testautomations@riskscreen.com |
    And user clicks on 'SaveButton' on 'Refit' page
    And user navigates to Prospect: "OnboardDataProspect4" with Search On: 'Last name' and click on 'DataCollectionLink'
    Then user should see Autocreated prospect with name "KYC 360 AutocreatedProspectS16"
    When user open Autocreated prospect with name "KYC 360 AutocreatedProspectS16"
    And user clicks on "DataCollectionLink" stage
    Then user should see Data Collection request
    When user clicks on 'GoBackButton' on 'Onboarding' page
    And user delete onboarding and prospect
    And user navigates to Prospect: 'OnboardDataProspect4' with Search On: 'Last name' and click on 'DataCollectionLink'
    And user enter data in following fields in internal form:
      | Field            | Value                          |
      | Group1TextField  | AutocreatedProspectS16         |
      | Group1TextField2 | KYC                            |
      | Group1TextField3 |                            360 |
      | Group1TextField4 | testautomations@riskscreen.com |
    And user clicks on 'SaveOnBoardingDataButton' on 'Onboarding' page
    Then user should not see Autocreated prospect with name "KYC 360 AutocreatedProspectS16"

  @deleteOnboarding @AutoCreationProspect17
  Scenario: 017 Verify that prospect should not be created from RS Onboard if Create Prospect, Onboarding, Data Request And Send Data Request from External Form is chosen as the action in the ANP setting. #ENG-T1374
    When user creates an onboarding for prospect "615146" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "615146" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+OnboardDataProspect5@riskscreen.com" email
    And user enter data in following fields in Refit DCF:
      | Field            | Value                          |
      | Group1TextField  | AutocreatedProspectS17         |
      | Group1TextField2 | KYC                            |
      | Group1TextField3 |                            360 |
      | Group1TextField4 | testautomations@riskscreen.com |
    And user clicks on 'SaveButton' on 'Refit' page
    Then user should receive email from:"noreply@kyc360.com" and to:"testautomations@riskscreen.com" and body should contains "AutocreationS17"
    When user navigates to Prospect: "OnboardDataProspect5" with Search On: 'Last name' and click on 'DataCollectionLink'
    Then user should see Autocreated prospect with name "KYC 360 AutocreatedProspectS17"
    When user open Autocreated prospect with name "KYC 360 AutocreatedProspectS17"
    And user clicks on "DataCollectionLink" stage
    Then user should see Data Collection request
    When user clicks on 'GoBackButton' on 'Onboarding' page
    And user delete onboarding and prospect
    And user navigates to Prospect: 'OnboardDataProspect5' with Search On: 'Last name' and click on 'DataCollectionLink'
    And user enter data in following fields in internal form:
      | Field            | Value                          |
      | Group1TextField  | AutocreatedProspectS17         |
      | Group1TextField2 | KYC                            |
      | Group1TextField3 |                            360 |
      | Group1TextField4 | testautomations@riskscreen.com |
    And user clicks on 'SaveOnBoardingDataButton' on 'Onboarding' page
    Then user should not see Autocreated prospect with name "KYC 360 AutocreatedProspectS17"

  @AutoCreationProspect18 @deleteAutocreatedOnboarding @deleteAutocreatedProspect
  Scenario: 018 User can edit the email template and action for an existing ANP setting, and a newly created prospect should receive the email and follow the updated action setting #ENG-T357,T723,T4321,T4323,T4463,T4609,T4611,T4751,T5063,T5126,T5127,T5128,T5281,T5344,T5345,T5346
    When user navigate to Onboarding type "AutocreationS18"
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'OBManageProspectGroup' on 'OnboardingType' page
    And user clicks on 'PropertyGroup1' on 'OnboardingType' page
    And user clicks on 'PropectAutoCreationSetting1' on 'OnboardingType' page
    And user select "AutocreationS18EmailTemplate" option in "EmailTemplate" dropdown on "AutocreationSetting" page
    Then user should wait until email template gets updated in message box
    When user select "Create prospect, onboarding, data request and send data request from external form" option in "ActionDropdown" dropdown on "AutocreationSetting" page
    And user clicks on 'UpdateButton' on 'AutocreationSetting' page
    Then user should see success banner with message "Prospect autocreation setting updated successfully."
    When user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user has payloads:
      """
      {
      "UpdateDataRequestedOn":"True",
      "ClientProspectID":"615089",
      "ClientOnboardingID":"351829",
      "DataRequestID":"6d6ca59b-ad5b-48d2-b0c0-0ac8d97881ad"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutocreationS18@riskscreen.com" email
    And user enter data in following fields in Refit DCF:
      | Field            | Value                          |
      | Group1TextField  | AutocreatedProspectS18         |
      | Group1TextField2 | KYC                            |
      | Group1TextField3 |                            360 |
      | Group1TextField4 | testautomations@riskscreen.com |
    And user clicks on 'SaveButton' on 'Refit' page
    Then user should receive email from:"noreply@riskscreen.com" and to:"testautomations@riskscreen.com" and body should contains "AutocreationS18"
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreationS18',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    Then user should see Autocreated prospect with name "KYC 360 AutocreatedProspectS18"
    When user delete Prospect Autocreation Status for prospect "KYC 360 AutocreatedProspectS18"
    #Cleanup
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreatedProspectS18',selects SearchOn:'Last name' and select prospect from list
    And user store 'ProspectId' with keyName:'autoProspectID' from 'Prospect' page
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user store 'OnboardingId' with keyName:'autoOnboardingID' from 'Onboarding' page
    And user navigate to Onboarding type "AutocreationS18"
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'OBManageProspectGroup' on 'OnboardingType' page
    And user clicks on 'PropertyGroup1' on 'OnboardingType' page
    And user clicks on 'PropectAutoCreationSetting1' on 'OnboardingType' page
    And user select "(None)" option in "EmailTemplate" dropdown on "AutocreationSetting" page
    Then user should wait until email template gets updated in message box
    When user select "Create prospect from external form" option in "ActionDropdown" dropdown on "AutocreationSetting" page
    And user clicks on 'UpdateButton' on 'AutocreationSetting' page
    Then user should see success banner with message "Prospect autocreation setting updated successfully."

  @deleteOnboarding @AutoCreationProspect19 @deleteAutocreatedOnboarding @deleteAutocreatedProspect
  Scenario: 019 Screening risk should be picked up based on the risk score calculated for the autocreated prospect even if the Risk assigned is different for the ANP setting #ENG-T2641
    When user creates an onboarding for prospect "615109" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "615109" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutocreationS19@riskscreen.com" email
    And user enter data in following fields in Refit DCF:
      | Field            | Value                                                 |
      | Group1TextField  | AutocreatedProspectS19                                |
      | Group1TextField2 | KYC                                                   |
      | Group1TextField3 |                                                   360 |
      | Group1TextField4 | testautomations+AutocreatedProspectS19@riskscreen.com |
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for some time to autocreation prospect to get complete
    And user wait until autocreation process is complete
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreationS19',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    Then user should see Autocreated prospect with name "KYC 360 AutocreatedProspectS19"
    When user delete Prospect Autocreation Status for prospect "KYC 360 AutocreatedProspectS19"
    #Cleanup
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreatedProspectS19',selects SearchOn:'Last name' and select prospect from list
    And user store 'ProspectId' with keyName:'autoProspectID' from 'Prospect' page
    And user clicks on 'ScreeningLink' on 'ManageProspect' page
    And user store 'OnboardingId' with keyName:'autoOnboardingID' from 'Onboarding' page
    Then user should see the Risk score:'High'

  @deleteOnboarding @AutoCreationProspect20 @deleteAutocreatedOnboarding @deleteAutocreatedProspect
  Scenario: 020 The risk assigned to the ANP setting should be assigned to the Autocreated prospect created from that particular ANP setting and used for screening if not risk score of its own is available #ENG-T2640
    When user creates an onboarding for prospect "615147" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "615147" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutocreationS20@riskscreen.com" email
    And user enter data in following fields in Refit DCF:
      | Field            | Value                                                 |
      | Group1TextField  | AutocreatedProspectS20                                |
      | Group1TextField2 | KYC                                                   |
      | Group1TextField3 |                                                   360 |
      | Group1TextField4 | testautomations+AutocreatedProspectS20@riskscreen.com |
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for some time to autocreation prospect to get complete
    And user wait until autocreation process is complete
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreationS20',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    Then user should see Autocreated prospect with name "KYC 360 AutocreatedProspectS20"
    When user delete Prospect Autocreation Status for prospect "KYC 360 AutocreatedProspectS20"
    #Cleanup
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreatedProspectS20',selects SearchOn:'Last name' and select prospect from list
    And user store 'ProspectId' with keyName:'autoProspectID' from 'Prospect' page
    And user clicks on 'ScreeningLink' on 'ManageProspect' page
    And user store 'OnboardingId' with keyName:'autoOnboardingID' from 'Onboarding' page
    Then user should see the Risk score:'Unclassified'

  @deleteOnboarding @AutoCreationProspect21 @deleteAutocreatedOnboarding @deleteAutocreatedProspect
  Scenario: 021 STP journey of autocreated prospect if there are no PM in screening and approval set to STP #ENG-T2640,T2513
    When user creates an onboarding for prospect "615159" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "615159" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutocreationS21@riskscreen.com" email
    #Using a1s1d1 as input to make sure no potential match is there in screening and the prospect goes for STP
    And user enter data in following fields in Refit DCF:
      | Field            | Value                                                 |
      | Group1TextField  | a1s1d1                                                |
      | Group1TextField2 | a1s1d1                                                |
      | Group1TextField3 | a1s1d1                                                |
      | Group1TextField4 | testautomations+AutocreatedProspectS21@riskscreen.com |
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for some time to autocreation prospect to get complete
    And user wait until autocreation process is complete
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreationS21',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    Then user should see Autocreated prospect with name "a1s1d1 a1s1d1 a1s1d1"
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'a1s1d1',selects SearchOn:'Last name' and select prospect from list
    And user store 'ProspectId' with keyName:'autoProspectID' from 'Prospect' page
    And user clicks on 'OnboardedLink' on 'ManageProspect' page
    And user store 'OnboardingId' with keyName:'autoOnboardingID' from 'Onboarding' page
    Then user should able see "ApprovedLabel" on 'Onboarding' page

  @deleteOnboarding @AutoCreationProspect22
  Scenario: 022 Auto-Creation Successfully Links Existing Prospect When Auto-Link is Set to Yes #ENG-T9773
    When user creates an onboarding for prospect "615169" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "615169" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutocreationS22@riskscreen.com" email
    And user enter data in following fields in Refit DCF:
      | Field            | Value                                           |
      | Group1TextField  | AutoLinkProspect                                |
      | Group1TextField2 | Auto                                            |
      | Group1TextField3 | Name                                            |
      | Group1TextField4 | testautomations+AutoLinkProspect@riskscreen.com |
    And user select "AutocreationS22" option in "FirstParentProspect" dropdown on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for auto-creation process to complete
    And user wait until autocreation process is complete
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreationS22',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    Then user should see Autocreated prospect with name "Auto Name AutoLinkProspect"
    And user should see 'Linked With Existing Match' on 'FirstAutocreationStatus' on 'Onboarding' page
    When user navigates to the 'ManageProspectGroup' page with the page title 'Manage Prospect Groups'
    And user enters SearchName:'AutoMappingCheck', selects SearchOn:'Name' and selects the prospect group from the list
    Then user should see 'Auto Name AutoLinkProspec...' prospect below 'AutocreationS22' prospect in prospect group structure
    When user deletes prospect relationship of the 'Auto Name AutoLinkProspec...' prospect

  @deleteOnboarding @AutoCreationProspect23 @deleteAutocreatedOnboarding @deleteAutocreatedProspect
  Scenario: 023 ANP - Data Mapping - Verify That Mapped Source Property Values Are Applied to Internal and External DCFs #ENG-T9473
    When user creates an onboarding for prospect "615170" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "615170" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutocreationS23@riskscreen.com" email
    And user enter data in following fields in Refit DCF:
      | Field            | Value                                                |
      | Group1TextField  | AutocreatedProspect23                                |
      | Group1TextField2 | Auto                                                 |
      | Group1TextField3 | Name                                                 |
      | Group1TextField4 | testautomations+AutocreatedProspect23@riskscreen.com |
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for auto-creation process to complete
    And user wait until autocreation process is complete
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreationS23',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    Then user should see Autocreated prospect with name "Auto Name AutocreatedProspect23"
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreatedProspect23',selects SearchOn:'Last name' and select prospect from list
    And user store 'ProspectId' with keyName:'autoProspectID' from 'Prospect' page
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user store 'OnboardingId' with keyName:'autoOnboardingID' from 'Onboarding' page
    Then user should see the following values in the internal DCF form:
      | Field            | Value                                                |
      | Group1TextField  | AutocreatedProspect23                                |
      | Group1TextField2 | Auto                                                 |
      | Group1TextField3 | Name                                                 |
      | Group1TextField4 | testautomations+AutocreatedProspect23@riskscreen.com |
    When user has a service named "/api/v1/client/onboardingdatarequest/add"
    And user has a payload from the file 'dataRequest'
    And user add "ExpiryDate" with tomorrow date
    And user add payload "ClientProspectID" with the stored key value "autoProspectID"
    And user add payload "ClientOnboardingID" with the stored key value "autoOnboardingID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"DataRequestID" with keyName:"dataRequestID"
    And user has a service named "/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink"
    And user has a payload from the file 'dataRequest'
    And user add payload "ClientProspectID" with the stored key value "autoProspectID"
    And user add payload "ClientOnboardingID" with the stored key value "autoOnboardingID"
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
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutocreatedProspect23@riskscreen.com" email
    Then user should see the following values in the Refit form:
      | Field            | Value                                                |
      | Group1TextField  | AutocreatedProspect23                                |
      | Group1TextField2 | Auto                                                 |
      | Group1TextField3 | Name                                                 |
      | Group1TextField4 | testautomations+AutocreatedProspect23@riskscreen.com |

  @deleteOnboarding @AutoCreationProspect24 @deleteAutocreatedOnboarding @deleteAutocreatedProspect
  Scenario: 024 ANP-Data mapping- Verify source property mapping occurs to the destination property after creation of prospect and onboarding. #ENG-T9474
    When user creates an onboarding for prospect "615175" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "615175" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutocreationS24@riskscreen.com" email
    And user enter data in following fields in Refit DCF:
      | Field            | Value                                                |
      | Group1TextField  | AutocreatedProspect24                                |
      | Group1TextField2 | Auto                                                 |
      | Group1TextField3 | Name                                                 |
      | Group1TextField4 | testautomations+AutocreatedProspect24@riskscreen.com |
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for auto-creation process to complete
    And user wait until autocreation process is complete
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreationS24',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    Then user should see Autocreated prospect with name "Auto Name AutocreatedProspect24"
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreatedProspect24',selects SearchOn:'Last name' and select prospect from list
    And user store 'ProspectId' with keyName:'autoProspectID' from 'Prospect' page
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user store 'OnboardingId' with keyName:'autoOnboardingID' from 'Onboarding' page
    Then user should see the following values in the internal DCF form:
      | Field            | Value                                                |
      | Group1TextField  | AutocreatedProspect24                                |
      | Group1TextField2 | Auto                                                 |
      | Group1TextField3 | Name                                                 |
      | Group1TextField4 | testautomations+AutocreatedProspect24@riskscreen.com |

  @deleteOnboarding @AutoCreationProspect25 @deleteAutocreatedOnboarding @deleteAutocreatedProspect
  Scenario: 025 Autocreation Should work when triggering properties are behind responsive rule
    When user creates an onboarding for prospect "615178" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "615178" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutocreationS25@riskscreen.com" email
    And user enter data in following fields in Refit DCF:
      | Field           | Value |
      | Group1Property1 |    20 |
    And user clicks on 'SaveButton' on 'Refit' page
    And user enter data in following fields in Refit DCF:
      | Field           | Value                                                |
      | Group2Property1 | AutocreatedProspect25                                |
      | Group2Property2 | Auto                                                 |
      | Group2Property3 | Name                                                 |
      | Group2Property4 | testautomations+AutocreatedProspect25@riskscreen.com |
    And user select "AutocreationS25" option in "FirstParentProspect" dropdown on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for auto-creation process to complete
    And user wait until autocreation process is complete
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreationS25',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    Then user should see Autocreated prospect with name "Auto Name AutocreatedProspect25"
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreatedProspect25',selects SearchOn:'Last name' and select prospect from list
    And user store 'ProspectId' with keyName:'autoProspectID' from 'Prospect' page
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user store 'OnboardingId' with keyName:'autoOnboardingID' from 'Onboarding' page
    Then user should see the following values in the internal DCF form:
      | Field            | Value                                                |
      | Group1TextField  | AutocreatedProspect25                                |
      | Group1TextField2 | Auto                                                 |
      | Group1TextField3 | Name                                                 |
      | Group1TextField4 | testautomations+AutocreatedProspect25@riskscreen.com |
    When user navigates to the 'ManageProspectGroup' page with the page title 'Manage Prospect Groups'
    And user enters SearchName:'AutocreationGroupS25', selects SearchOn:'Name' and selects the prospect group from the list
    Then user should see 'Auto Name AutocreatedPros...' prospect below 'AutocreationS25' prospect in prospect group structure

  @AutoCreationProspect26 @deleteAutocreatedOnboarding
  Scenario: 026 Notify handler when match found and auto-link is 'No'and Handler can manually link existing prospect via status page 'Link' option #ENG-T9774,T9775
    When user creates an onboarding for prospect "615270" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "615270" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+AutocreationS26@riskscreen.com" email
    And user enter data in following fields in Refit DCF:
      | Field            | Value                                               |
      | Group1TextField  | Prospect                                            |
      | Group1TextField2 | Already                                             |
      | Group1TextField3 | Added                                               |
      | Group1TextField4 | testautomations+AlreadyAddedProspect@riskscreen.com |
    And user select "AutocreationS26" option in "FirstParentProspect" dropdown on "Refit" page
    And user clicks on 'SaveButton' on 'Refit' page
    #Wait for auto-creation process to complete
    And user wait until autocreation process is complete
    Then user should receive email from:"noreply@riskscreen.com" and to:"testautomations+refit@riskscreen.com" and body should contains "Prospect autocreation attempt failed as last name + email address match already exists"
    When user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'AutocreationS26',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Auto Prospect Status' on Onboarding page
    Then user should see 'Not created - Match already exists' on 'FirstAutocreationStatus' on 'Onboarding' page
    When user clicks on 'Link' on 'Onboarding' page
    And user Link the prospect with following options:
      | Option                     | Value           |
      | LinkProspectRelationship   | Director        |
      | LinkProspectParentProspect | AutocreationS26 |
      | LinkCreateNewOnbparding    | Yes             |
      | LinkOboardingTypes         | MappingCheck    |
    And user navigates to the 'ManageProspectGroup' page with the page title 'Manage Prospect Groups'
    And user enters SearchName:'AutoLink2', selects SearchOn:'Name' and selects the prospect group from the list
    Then user should see 'Already Added Prospect' prospect below 'AutocreationS26' prospect in prospect group structure
    When user deletes prospect relationship of the 'Already Added Prospect' prospect
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'615267',selects SearchOn:'Client prospect identifier' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user store 'OnboardingId' with keyName:'autoOnboardingID' from 'Onboarding' page
    #Defect Raised #ENG-9685