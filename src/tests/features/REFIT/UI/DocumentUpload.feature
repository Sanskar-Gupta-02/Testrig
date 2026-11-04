@Regression @DocumentUpload
Feature: Document upload Automation

  Background:
    Given user login into 'REFIT' application with 'HandlerUserName' user
    And user is authorized using an 'APIKEY'

  @DocumentUpload1 @deleteDataRequest
  Scenario: 001 Should be able to upload document with valid size and format
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitDocumentUploadS1(DoNotTouch)' OB type on 'OnboardingType' page
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'ManageDocumentType' on 'OnboardingType' page
    Then user should see "Doc 1" on "DocTypeName1" on "OnboardingType" page
    And user should see "Doc 2" on "DocTypeName2" on "OnboardingType" page
    # Create onboarding and data request, generate data collection link using API
    When user store value:'607344' with keyName:'prospectID'
    And user store value:'349275' with keyName:'onboardingID'
    And user creates a data request and collection link for prospect "607344" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "AutomationTest+DocumentUploadS1@riskscreen.com" email
    Then user should see 'Group 1' on 'SideMenuGroup1' on 'Refit' page
    And user should see 'Documents' on 'SidemenuDocument' on 'Refit' page
    When user enter "Auto-Name" text in "Group1TextField" field on "Refit" page
    And user enter "Auto-UserName" text in "Group1TextField2" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    Then user should see '(Optional)' on 'Document2Status' on 'Refit' page
    When user upload 'AutomationDocument_50MB.pdf' file on 'Document1UploadButton' on 'Refit' page
    #Then user should see alert with message "File size exceeds the maximum allowed size of 40.00 MB. Your file is 51.01 MB."
    When user refresh the page
    And user wait from 2 seconds
    And user upload 'AutomationTesting.csv' file on 'Document1UploadButton' on 'Refit' page
    Then user should see alert with message "Invalid file extension. Allowed extensions are: .jpeg, .jpg, .png, .pdf"
    When user upload 'AutomationDocument.jpg' file on 'Document1UploadButton' on 'Refit' page
    Then user should see "AutomationDocument.jpg" on "UploadedDocument" on "Refit" page
    When user wait from 5 seconds
    And user clicks on 'ContinueButton' on 'Refit' page
    And user clicks on 'FormSubmissionCheckbox' on 'Refit' page
    And user clicks on 'Submitbutton' on 'Refit' page
    And user waits until submission process is completed
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'DocumentUploadS1',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataApprovalLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Documents' on Onboarding page
    Then user should able see "DocumentsTableName" on "Onboarding" page
    When user clicks on Onboarding Stage Tab with text 'Data Approval' on Onboarding page
    And user clicks on 'RejectOnboardingButton' on 'ManageProspect' page

  @deleteOnboarding @DocumentUpload2
  Scenario: 002 User should be able to upload multiple documents in one document section along with hidden document and delete document scenario
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitDocumentUploadS2(DoNotTouch)' OB type on 'OnboardingType' page
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'ManageDocumentType' on 'OnboardingType' page
    Then user should see "Doc 1" on "DocTypeName1" on "OnboardingType" page
    And user should see "Doc 2" on "DocTypeName2" on "OnboardingType" page
    And user should see "No" on "Doc1HiddenExternalStatus" on "OnboardingType" page
    And user should see "Yes" on "Doc2HiddenExternalStatus" on "OnboardingType" page
    # Create onboarding and data request, generate data collection link using API
    When user store value:'607383' with keyName:'prospectID'
    When user creates an onboarding for prospect "607383" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "607383" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+DocumentUploadS2@riskscreen.com" email
    Then user should see 'Group 1' on 'SideMenuGroup1' on 'Refit' page
    And user should see 'Documents' on 'SidemenuDocument' on 'Refit' page
    When user enter "Auto-Name" text in "Group1TextField" field on "Refit" page
    And user enter "Auto-UserName" text in "Group1TextField2" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    Then user should not see 'Document2Header' on 'Refit' page
    When user upload 'AutomationDocument.jpg' file on 'DocumentUploadButton' on 'Refit' page
    And user wait from 5 seconds
    And user clicks on 'DocumentExpandButton' on 'Refit' page
    And user enter "Auto-Document1" text in "DocumentRenameTextField" field on "Refit" page
    And user wait from 3 seconds
    And user clicks on 'DocumentSaveButton' on 'Refit' page
    Then user should see 'Auto-Document1' on 'Document1Name' on 'Refit' page
    When user upload 'AutomationDocument2.png' file on 'DocumentUploadButton' on 'Refit' page
    Then user should see 'AutomationDocument2.png' on 'Document2Name' on 'Refit' page
    And user upload 'AutomationDocument3.pdf' file on 'DocumentUploadButton' on 'Refit' page
    Then user should see 'AutomationDocument3.pdf' on 'Document3Name' on 'Refit' page
    When user wait from 5 seconds
    And user clicks on 'DocumentDeleteButton' on 'Refit' page
    And user wait from 2 seconds
    And user clicks on 'OkayButton' on 'Refit' page
    Then user should not see "Document3Name" on "Refit" page
    When user clicks on 'DocumentDeleteButton' on 'Refit' page
    And user wait from 2 seconds
    And user clicks on 'OkayButton' on 'Refit' page
    Then user should not see "Document2Name" on "Refit" page
    When user clicks on 'DocumentDeleteButton' on 'Refit' page
    And user wait from 2 seconds
    And user clicks on 'OkayButton' on 'Refit' page
    Then user should not see "Document1Name" on "Refit" page

  @deleteOnboarding @DocumentUpload3
  Scenario: 003 User should be able to replace the document
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitDocumentUploadS3(DoNotTouch)' OB type on 'OnboardingType' page
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'ManageDocumentType' on 'OnboardingType' page
    Then user should see "Doc 1" on "DocTypeName1" on "OnboardingType" page
    And user should see "Doc 2" on "DocTypeName2" on "OnboardingType" page
    # Create onboarding and data request, generate data collection link using API
    When user creates an onboarding for prospect "607392" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "607392" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+DocumentUploadS3@riskscreen.com" email
    Then user should see 'Group 1' on 'SideMenuGroup1' on 'Refit' page
    And user should see 'Documents' on 'SidemenuDocument' on 'Refit' page
    When user enter "Auto-Name" text in "Group1TextField" field on "Refit" page
    And user enter "Auto-UserName" text in "Group1TextField2" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user upload 'AutomationDocument.jpg' file on 'Document1UploadButton' on 'Refit' page
    And user wait from 3 seconds
    Then user should see 'AutomationDocument.jpg' on 'Document1Name' on 'Refit' page
    When user upload 'AutomationDocument2.png' file on 'ReplaceButton' on 'Refit' page
    And user wait from 2 seconds
    Then user should see 'AutomationDocument2.png' on 'Document1Name' on 'Refit' page

  @deleteOnboarding @DocumentUpload4
  Scenario: 004 Error box should appear if mandatory document is skipped
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitDocumentUploadS4(DoNotTouch)' OB type on 'OnboardingType' page
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'ManageDocumentType' on 'OnboardingType' page
    Then user should see "Doc 1" on "DocTypeName1" on "OnboardingType" page
    And user should see "Doc 2" on "DocTypeName2" on "OnboardingType" page
    # Create onboarding and data request, generate data collection link using API
    When user creates an onboarding for prospect "607425" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "607425" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+DocumentUploadS4@riskscreen.com" email
    Then user should see 'Group 1' on 'SideMenuGroup1' on 'Refit' page
    And user should see 'Documents' on 'SidemenuDocument' on 'Refit' page
    When user enter "Auto-Name" text in "Group1TextField" field on "Refit" page
    And user enter "Auto-UserName" text in "Group1TextField2" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    Then user should not see "Document1Status(optional)" on "Refit" page
    When user wait from 2 seconds
    And user upload "AutomationDocument.jpg" file on "Document2UploadButton" on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    Then user should see 'At least one document is required for Doc 1' on 'DocErrorMessage' on 'Refit' page
    When user clicks on 'SidemenuDocument' on 'Refit' page
    And user upload "AutomationDocument.jpg" file on "Document1UploadButton" on "Refit" page
    And user wait from 5 seconds
    And user click the "AutomationDocument.jpg" view button on the "Refit" page new tab opens and validate the image and return to the dcf
    And user clicks on 'ContinueButton' on 'Refit' page
    And user wait from 3 seconds
    Then user should see 'Completed' on 'DocumentStatus' on 'Refit' page

  @deleteOnboarding @DocumentUpload5
  Scenario: 005 User Should be able to change note to name and description
    When user navigates to the 'OnboardingType' page with the page title 'Onboarding Types'
    And user clicks on 'RefitDocumentUploadS5(DoNotTouch)' OB type on 'OnboardingType' page
    And user clicks on 'ManageStageDataCollection' on 'OnboardingType' page
    And user clicks on 'ManageDocumentType' on 'OnboardingType' page
    Then user should see "Doc 1" on "DocTypeName1" on "OnboardingType" page
    And user should see "Doc 2" on "DocTypeName2" on "OnboardingType" page
    # Create onboarding and data request, generate data collection link using API
    # When user store value:'607473' with keyName:'prospectID'
    When user creates an onboarding for prospect "607473" and store the response body keyData:"ClientOnboardingID" with keyName:"onboardingID"
    And user creates a data request and collection link for prospect "607473" and stored onboarding "onboardingID" and store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+DocumentUploadS5@riskscreen.com" email
    When user enter "Auto-Name" text in "Group1TextField" field on "Refit" page
    And user enter "Auto-UserName" text in "Group1TextField2" field on "Refit" page
    And user clicks on 'ContinueButton' on 'Refit' page
    And user upload 'AutomationDocument.jpg' file on 'Document1UploadButton' on 'Refit' page
    And user wait from 5 seconds
    And user clicks on 'DocumentExpandButton' on 'Refit' page
    And user enter "Auto-Name" text in "DocumentUserFileName" field on "Refit" page
    And user enter "Auto-Desc" text in "DocumentDescription" field on "Refit" page
    And user clicks on "DocumentSaveButton" on "Refit" page
    And user wait from 3 seconds
    And user clicks on 'DocumentExpandButton' on 'Refit' page
    And user enter "Auto-Name-Update" text in "DocumentUserFileName" field on "Refit" page
    And user enter "Auto-Desc-Update" text in "DocumentDescription" field on "Refit" page
    And user clicks on "DocumentSaveButton" on "Refit" page
    And user navigates to the 'ManageProspect' page with the page title 'Manage Prospects'
    And user enter SearchName:'DocumentUploadS5',selects SearchOn:'Last name' and select prospect from list
    And user clicks on 'DataCollectionLink' on 'ManageProspect' page
    And user clicks on Onboarding Stage Tab with text 'Documents' on Onboarding page
    Then user should see 'Auto-Name-Update' on 'DocumentsTableName' on 'Onboarding' page
    And user should see 'Auto-Desc-Update' on 'DocumentsTableDesc' on 'Onboarding' page
    And user click the "AutomationDocument.jpg" view button on the "Onboarding" page new tab opens and validate the image
