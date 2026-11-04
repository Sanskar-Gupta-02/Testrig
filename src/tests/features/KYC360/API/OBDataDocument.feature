@Sanity @Regression @OBDataDocument
Feature: Onboarding Data Document

  Background:
    Given user is authorized using an 'APIKEY_FOR_REFIT_ENABLED_CLIENT'

  Scenario: 001 Add Client Onboarding Data Document
    Given user has a service named "/api/v1/client/onboardingdatadocument/add"
    And user has header "Content-Type":"application/x-www-form-urlencoded"
    And user has payloads:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "OnboardingDataDocumentTypeID": 3627,
        "OnboardingDataDocumentTypeName": "Documentttt",
        "MediaType": "image/jpeg",
        "ActionUserID": 104,
        "ReturnFormat": "Json"
      }
      """
    And user adds "sample-clouds.jpeg" image to the payload
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                            | value       |
      | BusinessUnitID                 |          10 |
      | ClientProspectID               |      614717 |
      | ClientOnboardingID             |      351364 |
      | DataDocumentID                 |           6 |
      | OnboardingDataDocumentTypeID   |        3627 |
      | OnboardingDataDocumentTypeName | Documentttt |
      | MediaType                      | image/jpeg  |

  Scenario: 002 Get Client Onboarding Data Document
    Given user has a service named "/api/v1/client/onboardingdatadocument/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "IncludeDocumentData": true,
        "IncludeThumbnailData": true,
        "ReturnEncodedValues": false,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                            | value       |
      | BusinessUnitID                 |          10 |
      | ClientProspectID               |      614717 |
      | ClientOnboardingID             |      351364 |
      | OnboardingDataDocumentTypeID   |        3627 |
      | OnboardingDataDocumentTypeName | Documentttt |
      | MediaType                      | image/jpeg  |
    And response body should match the schema from the file "OBDataDocument"
    And response body should match the expected data from the file "OBDataDocument"

  Scenario: 003 Get Client Onboarding Data Document with Encoded Values
    Given user has a service named "/api/v1/client/onboardingdatadocument/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "IncludeDocumentData": true,
        "IncludeThumbnailData": true,
        "ReturnEncodedValues": true,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                          | value      |
      | BusinessUnitID               |         10 |
      | ClientProspectID             |     614717 |
      | ClientOnboardingID           |     351364 |
      | OnboardingDataDocumentTypeID |       3627 |
      | MediaType                    | image/jpeg |
    And response body should match the schema from the file "OBDataDocumentEncoded"
    And response body should match the expected data from the file "OBDataDocumentEncoded"

  Scenario: 004 Get Client Onboarding Data Document without Thumbnail Data
    Given user has a service named "/api/v1/client/onboardingdatadocument/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "IncludeDocumentData": true,
        "IncludeThumbnailData": false,
        "ReturnEncodedValues": false,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                   | value  |
      | BusinessUnitID        |     10 |
      | ClientProspectID      | 614717 |
      | DocumentThumbnailData | []     |

  Scenario: 005 Get Client Onboarding Data Document in XML Format
    Given user has a service named "/api/v1/client/onboardingdatadocument/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "IncludeDocumentData": false,
        "IncludeThumbnailData": false,
        "ReturnEncodedValues": false,
        "ReturnFormat": "Xml"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/xml; charset=utf-8'

  Scenario: 006 Get Client Onboarding Data Document using Default BusinessUnitID
    Given user has a service named "/api/v1/client/onboardingdatadocument/get"
    And user has query parameters:
      """
      {
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "IncludeDocumentData": false,
        "IncludeThumbnailData": false,
        "ReturnEncodedValues": false,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                   | value |
      | BusinessUnitID        |    10 |
      | DocumentData          | []    |
      | DocumentThumbnailData | []    |

  Scenario: 007 Get All Client Onboarding Data Documents
    Given user has a service named "/api/v1/client/onboardingdatadocument/getall"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "IncludeDocumentData": false,
        "IncludeThumbnailData": false,
        "ReturnEncodedValues": false,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "OBDataDocumentGetAll"
    And response body in ascending order should have index key with the contains value:
      | index | key                            | value       |
      |     1 | BusinessUnitID                 |          10 |
      |     1 | ClientProspectID               |      614717 |
      |     1 | ClientOnboardingID             |      351364 |
      |     1 | OnboardingDataDocumentTypeID   |        3627 |
      |     1 | OnboardingDataDocumentTypeName | Documentttt |
      |     1 | MediaType                      | image/jpeg  |

  Scenario: 008 Get All Client Onboarding Data Documents with Encoded Values
    Given user has a service named "/api/v1/client/onboardingdatadocument/getall"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "IncludeDocumentData": true,
        "IncludeThumbnailData": true,
        "ReturnEncodedValues": true,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "OBDataDocumentGetAll"
    And response body in ascending order should have index key with the contains value:
      | index | key              | value  |
      |     1 | BusinessUnitID   |     10 |
      |     1 | ClientProspectID | 614717 |

  Scenario: 009 Get All Client Onboarding Data Documents in XML Format
    Given user has a service named "/api/v1/client/onboardingdatadocument/getall"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "IncludeDocumentData": false,
        "IncludeThumbnailData": false,
        "ReturnEncodedValues": false,
        "ReturnFormat": "Xml"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/xml; charset=utf-8'

  Scenario: 010 Get All Client Onboarding Data Documents using Default BusinessUnitID
    Given user has a service named "/api/v1/client/onboardingdatadocument/getall"
    And user has query parameters:
      """
      {
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "IncludeDocumentData": false,
        "IncludeThumbnailData": false,
        "ReturnEncodedValues": false,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key            | value |
      |     1 | BusinessUnitID |    10 |

  Scenario: 011 Update Client Onboarding Data Document
    Given user has a service named "/api/v1/client/onboardingdatadocument/update"
    And user has header "Content-Type":"application/x-www-form-urlencoded"
    And user has payloads:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "OnboardingDataDocumentTypeID": 1,
        "OnboardingDataDocumentTypeName": "Documentttt",
        "MediaType": "image/png",
        "ActionUserID": 104,
        "DataDocumentID": 6,
        "ReturnFormat": "Json"
      }
      """
    And user adds "sample.png" image to the payload
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                          | value     |
      | BusinessUnitID               |        10 |
      | ClientProspectID             |    614717 |
      | ClientOnboardingID           |    351364 |
      | OnboardingDataDocumentTypeID |         1 |
      | MediaType                    | image/png |

  Scenario: 012 Get Client Onboarding Data Document Updated file
    Given user has a service named "/api/v1/client/onboardingdatadocument/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "IncludeDocumentData": true,
        "IncludeThumbnailData": true,
        "ReturnEncodedValues": false,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                          | value     |
      | BusinessUnitID               |        10 |
      | ClientProspectID             |    614717 |
      | ClientOnboardingID           |    351364 |
      | OnboardingDataDocumentTypeID |         1 |
      | MediaType                    | image/png |
    And response body should match the schema from the file "OBDataDocument"
    And response body should match the expected data from the file "OBDataDocumentUpdatedFile"

  Scenario: 013 Get Client Onboarding Data Document with Encoded Values
    Given user has a service named "/api/v1/client/onboardingdatadocument/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "IncludeDocumentData": true,
        "IncludeThumbnailData": true,
        "ReturnEncodedValues": true,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                          | value     |
      | BusinessUnitID               |        10 |
      | ClientProspectID             |    614717 |
      | ClientOnboardingID           |    351364 |
      | OnboardingDataDocumentTypeID |         1 |
      | MediaType                    | image/png |
    And response body should match the schema from the file "OBDataDocumentEncoded"
    And response body should match the expected data from the file "OBDataDocumentUpdatedFileEncoded"

  Scenario: 014 Delete Client Onboarding Data Document
    Given user has a service named "/api/v1/client/onboardingdatadocument/delete"
    And user has header "Content-Type":"application/x-www-form-urlencoded"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "ActionUserID": 104,
        "ReturnFormat": "Json",
        "DataDocumentID": 6
      }
      """
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                | value  |
      | BusinessUnitID     |     10 |
      | ClientProspectID   | 614717 |
      | ClientOnboardingID | 351364 |

  Scenario: 015 Delete Client Onboarding Data Document using Default BusinessUnitID
    Given user has a service named "/api/v1/client/onboardingdatadocument/add"
    And user has header "Content-Type":"application/x-www-form-urlencoded"
    And user has payloads:
      """
      {
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 7,
        "OnboardingDataDocumentTypeID": 5614,
        "OnboardingDataDocumentTypeName": "Document",
        "MediaType": "image/jpeg",
        "ActionUserID": 104,
        "ReturnFormat": "Json"
      }
      """
    And user adds "sample-clouds.jpeg" image to the payload
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key            | value |
      | BusinessUnitID |    10 |
    Given user has a service named "/api/v1/client/onboardingdatadocument/delete"
    And user has header "Content-Type":"application/x-www-form-urlencoded"
    And user has query parameters:
      """
      {
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 7,
        "ActionUserID": 104,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'DELETE' request
    Then response status should be 200
    And response body should have key with the value:
      | key            | value |
      | BusinessUnitID |    10 |

  Scenario: 016 Delete Client Onboarding Data Document in XML Format
    Given user has a service named "/api/v1/client/onboardingdatadocument/add"
    And user has header "Content-Type":"application/x-www-form-urlencoded"
    And user has payloads:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 8,
        "OnboardingDataDocumentTypeID": 3626,
        "OnboardingDataDocumentTypeName": "doc1",
        "MediaType": "application/pdf",
        "ActionUserID": 104,
        "ReturnFormat": "Json"
      }
      """
    And user adds "sample-clouds.jpeg" image to the payload
    When user sends a 'POST' request
    Then response status should be 201
    Given user has a service named "/api/v1/client/onboardingdatadocument/delete"
    And user has header "Content-Type":"application/x-www-form-urlencoded"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 8,
        "ActionUserID": 104,
        "ReturnFormat": "Xml"
      }
      """
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/xml; charset=utf-8'

  Scenario: 017 Add Client Onboarding Data Document with Invalid API Key
    When user is authorized using an 'INVALIDAPIKEY'
    And user has a service named "/api/v1/client/onboardingdatadocument/add"
    And user has header "Content-Type":"application/x-www-form-urlencoded"
    And user has payloads:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "OnboardingDataDocumentTypeID": 1,
        "OnboardingDataDocumentTypeName": "Documentttt",
        "DocumentData": "DUMMY_BASE64_DOCUMENT_DATA",
        "MediaType": "image/jpeg",
        "ActionUserID": 104,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'POST' request
    Then response status should be 401

  Scenario: 018 Get Client Onboarding Data Document with Invalid API Key
    When user is authorized using an 'INVALIDAPIKEY'
    And user has a service named "/api/v1/client/onboardingdatadocument/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "IncludeDocumentData": false,
        "IncludeThumbnailData": false,
        "ReturnEncodedValues": false,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 401

  Scenario: 019 Get All Client Onboarding Data Documents with Invalid API Key
    When user is authorized using an 'INVALIDAPIKEY'
    And user has a service named "/api/v1/client/onboardingdatadocument/getall"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "IncludeDocumentData": false,
        "IncludeThumbnailData": false,
        "ReturnEncodedValues": false,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 401

  Scenario: 020 Update Client Onboarding Data Document with Invalid API Key
    When user is authorized using an 'INVALIDAPIKEY'
    And user has a service named "/api/v1/client/onboardingdatadocument/update"
    And user has header "Content-Type":"application/x-www-form-urlencoded"
    And user has payloads:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "OnboardingDataDocumentTypeID": 1,
        "OnboardingDataDocumentTypeName": "Documentttt",
        "MediaType": "image/png",
        "ActionUserID": 104,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 401

  Scenario: 021 Delete Client Onboarding Data Document with Invalid API Key
    When user is authorized using an 'INVALIDAPIKEY'
    And user has a service named "/api/v1/client/onboardingdatadocument/delete"
    And user has header "Content-Type":"application/x-www-form-urlencoded"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "ActionUserID": 104,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'DELETE' request
    Then response status should be 401

  Scenario: 022 Get Client Onboarding Data Document with Invalid BusinessUnitID
    Given user has a service named "/api/v1/client/onboardingdatadocument/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": "abc",
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 406
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body in ascending order should have index key with the contains value:
      | index | key                       | value                                      |
      |     1 | ModelState.BusinessUnitID | The value is not valid for BusinessUnitID. |

  Scenario: 023 Get Client Onboarding Data Document without ClientProspectID
    Given user has a service named "/api/v1/client/onboardingdatadocument/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 406
    And response body in ascending order should have index key with the contains value:
      | index | key                         | value                        |
      |     1 | ModelState.ClientProspectID | Parameter value is required? |

  Scenario: 024 Get Client Onboarding Data Document without ClientOnboardingID
    Given user has a service named "/api/v1/client/onboardingdatadocument/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "DataDocumentID": 6,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 406
    And response body in ascending order should have index key with the contains value:
      | index | key                           | value                        |
      |     1 | ModelState.ClientOnboardingID | Parameter value is required? |

  Scenario: 025 Get Client Onboarding Data Document without DataDocumentID
    Given user has a service named "/api/v1/client/onboardingdatadocument/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 406
    And response body in ascending order should have index key with the contains value:
      | index | key                       | value                        |
      |     1 | ModelState.DataDocumentID | Parameter value is required? |

  Scenario: 026 Get Client Onboarding Data Document with Invalid ReturnFormat
    Given user has a service named "/api/v1/client/onboardingdatadocument/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "ReturnFormat": "pdf"
      }
      """
    When user sends a 'GET' request
    Then response status should be 406
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                                         |
      |     1 | ModelState.ReturnFormat | Parameter value should be either Json or Xml? |

  Scenario: 027 Get All Client Onboarding Data Documents without ClientProspectID
    Given user has a service named "/api/v1/client/onboardingdatadocument/getall"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientOnboardingID": 351364,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 406
    And response body in ascending order should have index key with the contains value:
      | index | key                         | value                        |
      |     1 | ModelState.ClientProspectID | Parameter value is required? |

  Scenario: 028 Get All Client Onboarding Data Documents without ClientOnboardingID
    Given user has a service named "/api/v1/client/onboardingdatadocument/getall"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 406
    And response body in ascending order should have index key with the contains value:
      | index | key                           | value                        |
      |     1 | ModelState.ClientOnboardingID | Parameter value is required? |

  Scenario: 029 Add Client Onboarding Data Document without DocumentData
    Given user has a service named "/api/v1/client/onboardingdatadocument/add"
    And user has header "Content-Type":"application/x-www-form-urlencoded"
    And user has payloads:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "OnboardingDataDocumentTypeID": 1,
        "OnboardingDataDocumentTypeName": "Documentttt",
        "MediaType": "image/jpeg",
        "ActionUserID": 104,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'POST' request
    Then response status should be 406
    And response body in ascending order should have index key with the contains value:
      | index | key                                | value                                               |
      |     1 | ModelState.Parameters#DocumentData | Parameter value must be specified but can be blank? |

  Scenario: 030 Add Client Onboarding Data Document without ActionUserID
    Given user has a service named "/api/v1/client/onboardingdatadocument/add"
    And user has header "Content-Type":"application/x-www-form-urlencoded"
    And user has payloads:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "OnboardingDataDocumentTypeID": 1,
        "OnboardingDataDocumentTypeName": "Documentttt",
        "DocumentData": "DUMMY_BASE64_DOCUMENT_DATA",
        "MediaType": "image/jpeg",
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'POST' request
    Then response status should be 406
    And response body in ascending order should have index key with the contains value:
      | index | key                                | value                                         |
      |     1 | ModelState.Parameters#ActionUserID | The ActionUserID property is required.        |
      |     2 | ModelState.Parameters#ActionUserID | Parameter value must be between 1 and 32,767? |

  Scenario: 031 Delete Client Onboarding Data Document without ActionUserID
    Given user has a service named "/api/v1/client/onboardingdatadocument/delete"
    And user has header "Content-Type":"application/x-www-form-urlencoded"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 10,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'DELETE' request
    Then response status should be 406
    And response body in ascending order should have index key with the contains value:
      | index | key                     | value                       |
      |     1 | ModelState.ActionUserID | Parameter value is required |

  Scenario: 032 Add Client Onboarding Data Document for Non-Default BusinessUnitID 11
    Given user has a service named "/api/v1/client/onboardingdatadocument/add"
    And user has header "Content-Type":"application/x-www-form-urlencoded"
    And user has payloads:
      """
      {
        "BusinessUnitID": 11,
        "ClientProspectID": 614724,
        "ClientOnboardingID": 351381,
        "DataDocumentID": 9,
        "OnboardingDataDocumentTypeID": 10394,
        "OnboardingDataDocumentTypeName": "cache cear",
        "MediaType": "image/jpeg",
        "ActionUserID": 105,
        "ReturnFormat": "Json"
      }
      """
    And user adds "sample-clouds.jpeg" image to the payload
    When user sends a 'POST' request
    Then response status should be 201
    And response body should have key with the value:
      | key            | value |
      | BusinessUnitID |    11 |

  Scenario: 033 Get Client Onboarding Data Document for Non-Default BusinessUnitID 11
    Given user has a service named "/api/v1/client/onboardingdatadocument/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 11,
        "ClientProspectID": 614724,
        "ClientOnboardingID": 351381,
        "DataDocumentID": 9,
        "IncludeDocumentData": true,
        "IncludeThumbnailData": true,
        "ReturnEncodedValues": false,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                            | value      |
      | BusinessUnitID                 |         11 |
      | ClientProspectID               |     614724 |
      | ClientOnboardingID             |     351381 |
      | OnboardingDataDocumentTypeID   |      10394 |
      | OnboardingDataDocumentTypeName | cache cear |
      | MediaType                      | image/jpeg |
    And response body should match the schema from the file "OBDataDocument"
    And response body should match the expected data from the file "OBDataDocumentNonDefaultBU"

  Scenario: 034 Update Client Onboarding Data Document for BusinessUnitID 11
    Given user has a service named "/api/v1/client/onboardingdatadocument/update"
    And user has header "Content-Type":"application/x-www-form-urlencoded"
    And user has payloads:
      """
      {
        "BusinessUnitID": 11,
        "ClientProspectID": 614724,
        "ClientOnboardingID": 351381,
        "DataDocumentID": 9,
        "OnboardingDataDocumentTypeID": 1,
        "OnboardingDataDocumentTypeName": "Documentttt",
        "MediaType": "image/png",
        "ActionUserID": 105,
        "ReturnFormat": "Json"
      }
      """
    And user adds "sample.png" image to the payload
    When user sends a 'PUT' request
    Then response status should be 200
    And response body should have key with the value:
      | key            | value |
      | BusinessUnitID |    11 |

  Scenario: 035 Get Client Onboarding Data Document for Non-Default BusinessUnitID 11
    Given user has a service named "/api/v1/client/onboardingdatadocument/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 11,
        "ClientProspectID": 614724,
        "ClientOnboardingID": 351381,
        "DataDocumentID": 9,
        "IncludeDocumentData": true,
        "IncludeThumbnailData": true,
        "ReturnEncodedValues": false,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                          | value     |
      | BusinessUnitID               |        11 |
      | ClientProspectID             |    614724 |
      | ClientOnboardingID           |    351381 |
      | OnboardingDataDocumentTypeID |         1 |
      | MediaType                    | image/png |
    And response body should match the schema from the file "OBDataDocument"
    And response body should match the expected data from the file "OBDataDocumentUpdatedFileForNonDefaultBU"

  Scenario: 036 Delete Client Onboarding Data Document for BusinessUnitID 11
    Given user has a service named "/api/v1/client/onboardingdatadocument/delete"
    And user has header "Content-Type":"application/x-www-form-urlencoded"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 11,
        "ClientProspectID": 614724,
        "ClientOnboardingID": 351381,
        "DataDocumentID": 9,
        "ActionUserID": 105,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'DELETE' request
    Then response status should be 200
    And response body should have key with the value:
      | key            | value |
      | BusinessUnitID |    11 |

  Scenario: 037 Get Client Onboarding Data Document Cross-BU Validation (BU 11 requesting BU 10 data)
    Given user has a service named "/api/v1/client/onboardingdatadocument/get"
    And user has query parameters:
      """
      {
        "BusinessUnitID": 11,
        "ClientProspectID": 614717,
        "ClientOnboardingID": 351364,
        "DataDocumentID": 6,
        "ReturnFormat": "Json"
      }
      """
    When user sends a 'GET' request
    Then response status should be 406
    And response body should have key with the value:
      | key     | value                                                                                                               |
      | Message | Unable to retrieve the Client Onboarding Document with Identifier 101 - 11 - 614717 - 351364 - 6 from the database! |
