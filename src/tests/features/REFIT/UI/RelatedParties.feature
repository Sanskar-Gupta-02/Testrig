@RelatedParties
Feature: External DCF Refit

  Background:
    Given user login to kyc360 with 'HandlerUserName' user
    And user is authorized using an 'APIKEY'

  Scenario: 001 Multi-tab maintain independent session.#ENG-T12911
    When user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user has payloads:
      """
      {
      "ClientProspectID":"615452",
      "ClientOnboardingID":"352551",
      "DataRequestID":"a11eff96-5008-42a2-80c0-54fccf631d35",
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    And user navigates to URL with the stored key value "dataRequestLink"
    #And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+RelatedParty1@riskscreen.com" email
    Then user should see 'RelatedParty1' on 'ProspectName' on 'Refit' page
    When user has a service named '/api/v1/client/onboardingdatarequest/GenerateDataCollectionLink'
    And user has a payload from the file 'dataRequest'
    And user has payloads:
      """
      {
      "ClientProspectID":"615453",
      "ClientOnboardingID":"352553",
      "DataRequestID":"de46233e-6e94-4b40-8900-a777127753a8",
      "UpdateDataRequestedOn":"True"
      }
      """
    And user sends a 'POST' request
    Then response status should be 200
    When user store the response body keyData:"DataRequestLink" with keyName:"dataRequestLink"
    #Navigate to the external DCF Refit page
    And user opens new tab
    And user navigates to URL with the stored key value "dataRequestLink"
    #And user navigates to URL with the stored key value "dataRequestLink" and enter OTP received on "testautomations+RelatedParty1@riskscreen.com" email
    Then user should see 'party1' on 'ProspectName' on 'Refit' page
    When user switches back to first tab
    Then user should see 'RelatedParty1' on 'ProspectName' on 'Refit' page
