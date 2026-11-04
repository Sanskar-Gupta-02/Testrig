@CLM @SystemGroup @Regression
Feature: System Group

  Scenario: 001 Verify No Save Button is Displayed for Everyone System Group Permissions #ENG-T9016,T8780,T9015
    Given user login into the 'CLM' application with 'AdminUserName' user
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "System Groups" on "Home"
    And user clicks on "ViewBtnOnCard" button associate with text "Everyone" on "SystemGroups"
    Then user should be able to see "Name" with text "Everyone" on "SystemGroups" page
    And user should be able to see "Description" with text "All users of the platform are a member of this group. They have restricted access rights." on "SystemGroups" page
    When user clicks on "SystemGroupAuthorizationTab" on "SystemGroups" page
    Then user should not see "SaveBtn" on "SystemGroups" page
    And user should able see "PermissionsLockedText" on "SystemGroups" page
    And user should able see "PermissionLockedDescription" on "SystemGroups" page

  Scenario: 002 Verify No Save Button is Displayed for Administrator System Group Permissions #ENG-T9014,T9013,T8759,T9017
    Given user login into the 'CLM' application with 'AdminUserName' user
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "System Groups" on "Home"
    And user clicks on "ViewBtnOnCard" button associate with text "Administrators" on "SystemGroups"
    Then user should be able to see "Name" with text "Administrators" on "SystemGroups" page
    And user should be able to see "Description" with text "Administrators have full access to all system functions. They cannot see data." on "SystemGroups" page
    When user clicks on "SystemGroupAuthorizationTab" on "SystemGroups" page
    Then user should not see "SaveBtn" on "SystemGroups" page
    And user should able see "PermissionsLockedText" on "SystemGroups" page
    And user should able see "PermissionLockedDescription" on "SystemGroups" page

  Scenario: 003 Verify Permissions for Everyone System Group #ENG-T9018,T9117
    Given user login into the 'CLM' application with 'UserForEveryoneSystemGroups' user
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenuBtn" on "Home" page
    Then user should able see "SearchOnSideBar" on "Home" page
    And user should not see "SideBarDashboardItem" on "Home" page
    And user should not see "SideBarEntitiesItem" on "Home" page
    And user should not see "SideBarMyAreaItem" on "Home" page
    And user should not see "SideBarConfigurationItem" on "Home" page

  Scenario: 004 Verify security permissions and configuration options are displayed #ENG-T8762,T11133,T9116,T9038,T9030
    Given user login into the 'CLM' application with 'AdminUserName' user
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "System Groups" on "Home"
    And user clicks on "ViewBtnOnCard" button associate with text "Test System Group for Automation" on "SystemGroups"
    And user clicks on "SystemGroupAuthorizationTab" on "SystemGroups" page
    Then user should see the following permission headers and descriptions on "SystemGroups" page
      | name                        | description                                             |
      | Overall Permissions         | Overall control for sub-options.                        |
      | Entities                    | Can view and manage Entities.                           |
      | Entity Relationships        | Manage relationships assigned to an entity.             |
      | Groups                      | Can view and manage groups                              |
      | Group Types                 | Can view and manage group types                         |
      | Structured Reviews          | Can manage Structured Reviews                  |
      | Risk Models                 | Can view and manage Risk models.                        |
      | Entity Types                | Can manage entity types.                                |
      | Screening                   | Can view and manage Screening settings                  |
      | Data Fields                 | Can view and manage data fields.                        |
      | Data Templates              | Can view and manage data templates.                     |
      | Relationship Types          | Can view and manage relationship types.                 |
      | Users                       | Can manage users in the tenant.                         |
      | Business Units              | Can view and manage Business Units and Business Groups. |
      | System Groups               | Manage system groups.                                   |
      | Import/Export               | Can view and execute Import and Export.                 |
      | Audit Log                   | View and search audit logs.                             |
      | KYC Models                  | Can view and manage KYC models.                         |
      | Reporting                   | Can view and manage Reports                             |
      | Dashboard                   | Controls access to the dashboard                        |
      | KYC                         | Controls access to the KYC Tab                          |
      | Reviews                     | Controls access to the Reviews Tab             |
      | Risk                        | Controls access to the Risk Tab                         |
      | Settings                    | Can view and manage platform settings.                  |
      | API Management              | Manage API connections and access keys.                 |
      | Outreach Branding           | Access and manage Outreach Portal branding settings.    |
    When user clicks on "SideBarMenuBtn" on "Home" page
    Then user should able see "Dashboard" on "SideBar" page
    And user should able see "Entities" on "SideBar" page
    And user should able see "MyArea" on "SideBar" page
    And user should able see "Configuration" on "SideBar" page

  Scenario: 005 Verify permission settings are saved correctly #ENG-T8766,T8770,T8767
    Given user login into the 'CLM' application with 'AdminUserName' user
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "System Groups" on "Home"
    And user clicks on "ViewBtnOnCard" button associate with text "Test System Group for Automation" on "SystemGroups"
    And user clicks on "SystemGroupAuthorizationTab" on "SystemGroups" page
    Then user should able see "EntitiesReadPermissionIsChecked" on "SystemGroups" page
    When user clicks on "EntitiesCreateCheckBox" on "SystemGroups" page
    Then user should able see "EntitiesCreateGrantResult" on "SystemGroups" page
    And user wait from 1 seconds
    When user clicks on "SaveBtn" on "SystemGroups" page
    Then user should able see "PermissionsSavedToastMessage" on "SystemGroups" page
    When user refresh the page
    Then user should able see "EntitiesCreateGrantResult" on "SystemGroups" page
    When user clicks on "EntityRelationshipsReadInheritInputBox" on "SystemGroups" page
    Then user should able see "EntityRelationshipsReadGrantResult" on "SystemGroups" page
    When user refresh the page
    Then user should not see "EntityRelationshipsReadGrantInputBox" on "SystemGroups" page
    And user should not see "EntityRelationshipsReadGrantResult" on "SystemGroups" page
    # --- Data reverting steps ---
    When user clicks on "EntitiesCreateUnCheckBox" on "SystemGroups" page
    When user clicks on "EntitiesCreateUnCheckConfirmBox" on "SystemGroups" page
    And user should able see "EntitiesCreateCheckBox" on "SystemGroups" page
    And user clicks on "SaveBtn" on "SystemGroups" page
    Then user should able see "PermissionsSavedToastMessage" on "SystemGroups" page

  Scenario: 006 Verify results update based on configuration #ENG-T8765,T8995
    Given user login into the 'CLM' application with 'AdminUserName' user
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "System Groups" on "Home"
    And user clicks on "ViewBtnOnCard" button associate with text "Test System Group for Automation" on "SystemGroups"
    And user clicks on "SystemGroupAuthorizationTab" on "SystemGroups" page
    Then user should not see "APIManagementReadGrantResult" on "SystemGroups" page
    And user clicks on "APIManagementReadDenyInputBox" on "SystemGroups" page
    When user clicks on "APIManagementReadInheritInputCheckBox" on "SystemGroups" page
    And user clicks on "APIManagementReadGrantInputBox" on "SystemGroups" page
    Then user should able see "APIManagementReadDenyResult" on "SystemGroups" page
    Then user should able see "APIManagementCreateDenyResult" on "SystemGroups" page
    When user clicks on "SaveBtn" on "SystemGroups" page
    Then user should able see "PermissionsSavedToastMessage" on "SystemGroups" page
    When user logs out and logs in with "UserWithSpecificPermission" username
    And user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "Settings" on "Home"
    Then user should be able to see "DisablePermissionTextForAPIManagement" with text "You don't have permission to access this module. Ask your administrator to grant access." on "Settings" page
    And user should able see "CardTitleForAPIManagement" on "Settings" page
    And user should not see "APIManagementCardOpenBtn" on "Settings" page
    # --- Data reverting steps ---
    When user logs out and logs in with "AdminUserName" username
    And user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "System Groups" on "Home"
    And user clicks on "ViewBtnOnCard" button associate with text "Test System Group for Automation" on "SystemGroups"
    And user clicks on "SystemGroupAuthorizationTab" on "SystemGroups" page
    And user should able see "APIManagementReadDenyResult" on "SystemGroups" page
    And user should able see "APIManagementCreateDenyResult" on "SystemGroups" page
    When user clicks on "SaveBtn" on "SystemGroups" page
    Then user should able see "PermissionsSavedToastMessage" on "SystemGroups" page

  Scenario: 007 Verify user can change all permissions by using Overall Permissions checkboxes #ENG-T8768,T9070
    Given user login into the 'CLM' application with 'AdminUserName' user
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "System Groups" on "Home"
    And user clicks on "ViewBtnOnCard" button associate with text "Test System Group for Automation" on "SystemGroups"
    And user clicks on "SystemGroupAuthorizationTab" on "SystemGroups" page
    Then user should able see "OverallPermissionsReadDenyResult" on "SystemGroups" page
    When user clicks on "OverallPermissionsReadInheritInputBox" on "SystemGroups" page
    Then user should able see "OverallPermissionsReadGrantResult" on "SystemGroups" page
    When user clicks on "OverallPermissionsCreateInheritInputBox" on "SystemGroups" page
    Then user should able see "OverallPermissionsCreateGrantResult" on "SystemGroups" page
    When user clicks on "OverallPermissionsDeleteInheritInputBox" on "SystemGroups" page
    Then user should able see "OverallPermissionsDeleteGrantResult" on "SystemGroups" page
    When user clicks on "OverallPermissionsUpdateInheritInputBox" on "SystemGroups" page
    Then user should able see "OverallPermissionsUpdateGrantResult" on "SystemGroups" page
    When user clicks on "SaveBtn" on "SystemGroups" page
    Then user should able see "PermissionsSavedToastMessage" on "SystemGroups" page
    When user refresh the page
    Then user should able see "OverallPermissionsReadGrantResult" on "SystemGroups" page
    # --- Data reverting steps ---
    When user clicks on "OverallPermissionsReadGrantInputBox" on "SystemGroups" page
    And user clicks on "OverallPermissionsCreateGrantInputBox" on "SystemGroups" page
    And user clicks on "OverallPermissionsDeleteGrantInputBox" on "SystemGroups" page
    And user clicks on "OverallPermissionsUpdateGrantInputBox" on "SystemGroups" page
    And user clicks on "OverallPermissionsReadDenyInputBox" on "SystemGroups" page
    And user clicks on "OverallPermissionsUpdateDenyInputBox" on "SystemGroups" page
    And user clicks on "OverallPermissionsCreateDenyInputBox" on "SystemGroups" page
    And user clicks on "OverallPermissionsDeleteDenyInputBox" on "SystemGroups" page
    And user clicks on "SaveBtn" on "SystemGroups" page
    Then user should able see "PermissionsSavedToastMessage" on "SystemGroups" page

  Scenario: 008 User should be allowed or denied access based on system group permission #ENG-T9118
    Given user login into the 'CLM' application with 'AdminUserName' user
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "System Groups" on "Home"
    And user clicks on "ViewBtnOnCard" button associate with text "Test System Group for Automation" on "SystemGroups"
    And user clicks on "SystemGroupAuthorizationTab" on "SystemGroups" page
    Then user should able see "EntityTypesReadDenyResult" on "SystemGroups" page
    And user should able see "EntityTypesCreateResultDeny" on "SystemGroups" page
    When user clicks on "EntityTypesReadDenyInputBox" on "SystemGroups" page
    When user clicks on "EntityTypesReadInheritInputBox" on "SystemGroups" page
    And user clicks on "EntityTypesCreateDenyInputBox" on "SystemGroups" page
    And user clicks on "EntityTypesCreateInheritInputBox" on "SystemGroups" page
    Then user should able see "EntityTypesReadGrantResult" on "SystemGroups" page
    And user should able see "EntityTypesCreateResultGrant" on "SystemGroups" page
    When user clicks on "SaveBtn" on "SystemGroups" page
    Then user should able see "PermissionsSavedToastMessage" on "SystemGroups" page
    When user logs out and logs in with "UserWithSpecificPermission" username
    And user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenuBtn" on "Home" page
    Then user should able see "Entities" on "SideBar" page
    And user should able see "EntityTypes" on "SideBar" page
    # --- Data reverting steps ---
    When user logs out and logs in with "AdminUserName" username
    And user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "System Groups" on "Home"
    And user clicks on "ViewBtnOnCard" button associate with text "Test System Group for Automation" on "SystemGroups"
    And user clicks on "SystemGroupAuthorizationTab" on "SystemGroups" page
    And user clicks on "EntityTypesReadGrantInputBox" on "SystemGroups" page
    And user clicks on "EntityTypesCreateGrantInputBox" on "SystemGroups" page
    And user clicks on "SaveBtn" on "SystemGroups" page
    Then user should able see "PermissionsSavedToastMessage" on "SystemGroups" page

  Scenario: 009 Verify Add button is not displayed in Risk Models and Risk List module if user doesn't have create access #ENG-T11135
    Given user login into the 'CLM' application with 'AdminUserName' user
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "System Groups" on "Home"
    And user clicks on "ViewBtnOnCard" button associate with text "Test System Group for Automation" on "SystemGroups"
    And user clicks on "SystemGroupAuthorizationTab" on "SystemGroups" page
    And user clicks on "RiskModelsReadInheritInputBox" on "SystemGroups" page
    And user clicks on "RiskModelsCreateInheritInputBox" on "SystemGroups" page
    And user clicks on "RiskModelsCreateGrantInputCheckBox" on "SystemGroups" page
    And user clicks on "SaveBtn" on "SystemGroups" page
    Then user should able see "PermissionsSavedToastMessage" on "SystemGroups" page
    When user logs out and logs in with "UserWithSpecificPermission" username
    And user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenuBtnForRiskModels" button associate with text "Risk Models" on "Home"
    Then user should see ' Risk Models ' on 'PageTitle' on 'DSPage' page
    And user should not see "AddNewBtn" on "RiskModels" page
    When user clicks on "RiskListsBtn" on "RiskModels" page
    Then user should see ' Risk Lists ' on 'PageTitle' on 'DSPage' page
    And user should not see "RiskListsAddNewBtn" on "RiskModels" page
    # --- Data reverting steps ---
    When user logs out and logs in with "AdminUserName" username
    And user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "System Groups" on "Home"
    And user clicks on "ViewBtnOnCard" button associate with text "Test System Group for Automation" on "SystemGroups"
    And user clicks on "SystemGroupAuthorizationTab" on "SystemGroups" page
    And user clicks on "RiskModelsReadGrantInputBox" on "SystemGroups" page
    And user clicks on "RiskModelsReadDenyInputBox" on "SystemGroups" page
    And user clicks on "RiskModelsCreateDenyInputBox" on "SystemGroups" page
    And user clicks on "RiskModelsCreateInheritInputBox" on "SystemGroups" page
    And user clicks on "SaveBtn" on "SystemGroups" page
    Then user should able see "PermissionsSavedToastMessage" on "SystemGroups" page

  Scenario: 010 Verify Add button is displayed on Relationship Type, Risk Model, Risk Lists page when user has create access permission #ENG-T11136,T11134,T9028
    Given user login into the 'CLM' application with 'AdminUserName' user
    When user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "System Groups" on "Home"
    And user clicks on "ViewBtnOnCard" button associate with text "Test System Group for Automation" on "SystemGroups"
    And user clicks on "SystemGroupAuthorizationTab" on "SystemGroups" page
    And user clicks on "RiskModelsReadInheritInputBox" on "SystemGroups" page
    Then user should able see "RiskModelsReadGrantResult" on "SystemGroups" page
    Then user should able see "RiskModelsCreateGrantResult" on "SystemGroups" page
    And user should able see "RelationshipTypesCreateDenyResult" on "SystemGroups" page
    And user clicks on "RelationshipTypesReadDenyInputBox" on "SystemGroups" page
    And user clicks on "RelationshipTypesReadInheritInputBox" on "SystemGroups" page
    And user clicks on "RelationshipTypesCreateDenyInputBox" on "SystemGroups" page
    And user clicks on "RelationshipTypesCreateInheritInputBox" on "SystemGroups" page
    And user clicks on "RelationshipTypesCreateGrantInputBox" on "SystemGroups" page
    And user clicks on "SaveBtn" on "SystemGroups" page
    Then user should able see "PermissionsSavedToastMessage" on "SystemGroups" page
    When user logs out and logs in with "UserWithSpecificPermission" username
    And user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "Risk Models" on "Home"
    Then user should see ' Risk Models ' on 'PageTitle' on 'DSPage' page
    And user should able see "AddNewBtn" on "RiskModels" page
    When user clicks on "RiskListsBtn" on "RiskModels" page
    Then user should see ' Risk Lists ' on 'PageTitle' on 'DSPage' page
    And user should able see "RiskListsAddNewBtn" on "RiskModels" page
    And user clicks on "SideBarMenuBtn" on "Home" page
    When user clicks on "SideBarMenu" button associate with text "Relationship Types" on "Home"
    Then user should see ' Relationship Types ' on 'PageTitle' on 'DSPage' page
    And user should not see "AddNewBtn" on "RelationshipTypes" page
    # --- Data reverting steps ---
    When user logs out and logs in with "AdminUserName" username
    And user clicks on "TenantButton" button associate with text "TEST AUTOMATION TENANT - DO NOT TOUCH" on "Home"
    And user clicks on "SideBarMenu" button associate with text "System Groups" on "Home"
    And user clicks on "ViewBtnOnCard" button associate with text "Test System Group for Automation" on "SystemGroups"
    And user clicks on "SystemGroupAuthorizationTab" on "SystemGroups" page
    And user clicks on "RiskModelsReadGrantInputBox" on "SystemGroups" page
    And user clicks on "RiskModelsReadDenyInputBox" on "SystemGroups" page
    And user clicks on "RiskModelsCreateGrantInputBox" on "SystemGroups" page
    And user clicks on "RiskModelsCreateDenyInputBox" on "SystemGroups" page
    And user clicks on "RelationshipTypesReadGrantInputBox" on "SystemGroups" page
    And user clicks on "SaveBtn" on "SystemGroups" page
    Then user should able see "PermissionsSavedToastMessage" on "SystemGroups" page
