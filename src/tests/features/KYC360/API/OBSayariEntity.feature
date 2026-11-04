@Regression @OBSayariEntity
Feature: OB Sayari Entity API

  Background:
    Given user is authorized using an 'APIKEY'

  Scenario: 001 Should be able to add sayari entity
    Given user has a service named "/api/v1/client/prospectgroup/add"
    And user has a payload from the file "prospectGroup" with selected keys "BusinessUnitID,Description,ActionUserID,ReturnFormat"
    And user store the unique value for key:
      | key  |
      | name |
    And user add payload key with stored key value:
      | payloadKey | storedkey |
      | Name       | name      |
    When user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"ClientProspectGroupID" with keyName:"prospectGroupID"
    And user has a service named "/api/v1/client/onboardingsayarientity/add"
    And user has a payload from the file 'sayariEntity'
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                         | value                   |
      | BusinessUnitID              |                      10 |
      | SayariEntityName            | SWIGGY SERVICES PTY LTD |
      | SayariEntityUniqueReference | b7TylwOWydiLZEgAFoXJtg  |
      | SayariEntityTypeID          |                       1 |
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should match the schema from the file "sayariEntity"
    When user store the response body keyData:"SayariEntityID" with keyName:"sayariEntityID"

  Scenario: 002 Should be able to get sayari entity details
    Given user has a service named "/api/v1/client/onboardingsayarientity/get"
    And user has a query params from the file 'sayariEntity' with selected keys 'BusinessUnitID,ReturnFormat'
    And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
    And user add query parameter 'SayariEntityID' with the stored key value 'sayariEntityID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "sayariEntity"
    And response body should have key with the value:
      | key                         | value                   |
      | BusinessUnitID              |                      10 |
      | SayariEntityName            | SWIGGY SERVICES PTY LTD |
      | SayariEntityUniqueReference | b7TylwOWydiLZEgAFoXJtg  |
      | SayariEntityTypeID          |                       1 |
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should have key "SayariEntityID" with the stored key value "sayariEntityID"

  Scenario: 003 Should be able to update sayari entity
    Given user has a service named "/api/v1/client/onboardingsayarientity/update"
    And user has a payload from the file 'sayariEntity'
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And user add payload "SayariEntityID" with the stored key value "sayariEntityID"
    And user has payloads:
      """
      {
          "SayariEntityName":"SWIGGY SERVICES PTY LTD - Update",
          "SayariEntityTypeID":"2"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                         | value                            |
      | BusinessUnitID              |                               10 |
      | SayariEntityName            | SWIGGY SERVICES PTY LTD - Update |
      | SayariEntityUniqueReference | b7TylwOWydiLZEgAFoXJtg           |
      | SayariEntityTypeID          |                                2 |
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should have key "SayariEntityID" with the stored key value "sayariEntityID"
    And response body should match the schema from the file "sayariEntity"

  Scenario: 004 Should be able to get all sayari entity details #ENG-T2920,T2917
    Given user has a service named "/api/v1/client/onboardingsayarientity/add"
    And user has a payload from the file 'sayariEntity'
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And user has payloads:
      """
      {
          "SayariEntityName": "SCI SWIGGY",
          "SayariEntityUniqueReference": "vzn3knQvlimJUcCpcoO8Qw"
      }
      """
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"SayariEntityID" with keyName:"secondSayariEntityID"
    And user has a service named "/api/v1/client/onboardingsayarientity/getall"
    And user has a query params from the file 'sayariEntity' with selected keys 'BusinessUnitID,ReturnFormat'
    And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "sayariEntityGetAll"
    And response body should have index key with the value:
      | index | key                         | value                            |
      |     1 | BusinessUnitID              |                               10 |
      |     1 | SayariEntityName            | SWIGGY SERVICES PTY LTD - Update |
      |     1 | SayariEntityUniqueReference | b7TylwOWydiLZEgAFoXJtg           |
      |     1 | SayariEntityTypeID          |                                2 |
      |     2 | BusinessUnitID              |                               10 |
      |     2 | SayariEntityName            | SCI SWIGGY                       |
      |     2 | SayariEntityUniqueReference | vzn3knQvlimJUcCpcoO8Qw           |
      |     2 | SayariEntityTypeID          |                                1 |
    And response body should have index key with the stored key value:
      | index | key                   | storedKey            |
      |     1 | ClientProspectGroupID | prospectGroupID      |
      |     1 | SayariEntityID        | sayariEntityID       |
      |     2 | ClientProspectGroupID | prospectGroupID      |
      |     2 | SayariEntityID        | secondSayariEntityID |

  Scenario: 005 Should be able to add sayari entity attribute
    Given user has a service named "/api/v1/client/onboardingsayarientityattribute/add"
    And user has a payload from the file 'sayariEntityAttribute'
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And user add payload "SayariEntityID" with the stored key value "sayariEntityID"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                         | value                          |
      | BusinessUnitID              |                             10 |
      | SayariEntityAttributeTypeID |                             10 |
      | Name                        | Auto-Address                   |
      | Value                       | 88 WIGRAM ST, Sydney, AU, 2150 |
      | Type                        | Address                        |
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should have key "SayariEntityID" with the stored key value "sayariEntityID"
    And response body should match the schema from the file "sayariEntityAttribute"
    When user store the response body keyData:"AttributeID" with keyName:"attributeID"

  Scenario: 006 Should be able to get sayari entity attribute details
    Given user has a service named "/api/v1/client/onboardingsayarientityattribute/get"
    And user has a query params from the file 'sayariEntityAttribute' with selected keys 'BusinessUnitID,ReturnFormat'
    And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
    And user add query parameter 'SayariEntityID' with the stored key value 'sayariEntityID'
    And user add query parameter 'AttributeID' with the stored key value 'attributeID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "sayariEntityAttribute"
    And response body should have key with the value:
      | key                         | value                          |
      | BusinessUnitID              |                             10 |
      | SayariEntityAttributeTypeID |                             10 |
      | Name                        | Auto-Address                   |
      | Value                       | 88 WIGRAM ST, Sydney, AU, 2150 |
      | Type                        | Address                        |
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should have key "SayariEntityID" with the stored key value "sayariEntityID"
    And response body should have key "AttributeID" with the stored key value "attributeID"

  Scenario: 007 Should be able to update sayari entity attribute
    Given user has a service named "/api/v1/client/onboardingsayarientityattribute/update"
    And user has a payload from the file 'sayariEntityAttribute'
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And user add payload "SayariEntityID" with the stored key value "sayariEntityID"
    And user add payload "AttributeID" with the stored key value "attributeID"
    And user has payloads:
      """
      {
          "Name":"Auto-Address - Update",
          "Value":"88 WIGRAM ST, Sydney, AU, 2151",
          "Type":"Address"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                         | value                          |
      | BusinessUnitID              |                             10 |
      | SayariEntityAttributeTypeID |                             10 |
      | Name                        | Auto-Address - Update          |
      | Value                       | 88 WIGRAM ST, Sydney, AU, 2151 |
      | Type                        | Address                        |
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should have key "SayariEntityID" with the stored key value "sayariEntityID"
    And response body should have key "AttributeID" with the stored key value "attributeID"
    And response body should match the schema from the file "sayariEntityAttribute"

  Scenario: 008 Should be able to get all sayari entity attribute details
    Given user has a service named "/api/v1/client/onboardingsayarientityattribute/add"
    And user has a payload from the file 'sayariEntityAttribute'
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And user add payload "SayariEntityID" with the stored key value "sayariEntityID"
    And user has payloads:
      """
      {
          "SayariEntityAttributeTypeID": "11",
          "Name": "Auto-Identifier",
          "Value": "abcd12345",
          "Type": "Identifier"
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"AttributeID" with keyName:"secondAttributeID"
    And user has a service named "/api/v1/client/onboardingsayarientityattribute/getall"
    And user has a query params from the file 'sayariEntityAttribute' with selected keys 'BusinessUnitID,ReturnFormat'
    And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
    And user add query parameter 'SayariEntityID' with the stored key value 'sayariEntityID'
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "sayariEntityAttributeGetAll"
    And response body should have index key with the value:
      | index | key                         | value                          |
      |     1 | BusinessUnitID              |                             10 |
      |     1 | SayariEntityAttributeTypeID |                             10 |
      |     1 | Name                        | Auto-Address - Update          |
      |     1 | Value                       | 88 WIGRAM ST, Sydney, AU, 2151 |
      |     1 | Type                        | Address                        |
      |     2 | BusinessUnitID              |                             10 |
      |     2 | SayariEntityAttributeTypeID |                             11 |
      |     2 | Name                        | Auto-Identifier                |
      |     2 | Value                       | abcd12345                      |
      |     2 | Type                        | Identifier                     |
    And response body should have index key with the stored key value:
      | index | key                   | storedKey         |
      |     1 | ClientProspectGroupID | prospectGroupID   |
      |     1 | SayariEntityID        | sayariEntityID    |
      |     1 | AttributeID           | attributeID       |
      |     2 | ClientProspectGroupID | prospectGroupID   |
      |     2 | SayariEntityID        | sayariEntityID    |
      |     2 | AttributeID           | secondAttributeID |

  Scenario: 009 Should be able to add sayari entity relationship
    Given user has a service named "/api/v1/client/onboardingsayarientityrelationship/add"
    And user has a payload from the file 'sayariEntityRelationship'
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And user add payload "SayariEntityID" with the stored key value "sayariEntityID"
    And user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                            | value                   |
      | BusinessUnitID                 |                      10 |
      | SayariEntityRelationshipTypeID |                      10 |
      | Title                          | Mr                      |
      | LastName                       | SWIGGY SERVICES PTY LTD |
      | Position                       | QA                      |
      | Address                        | abv                     |
      | IsFormer                       | false                   |
      | IsCorporate                    | true                    |
      | SayariEntityUniqueReference    | b7TylwOWydiLZEgAFoXJtg  |
      | Deleted                        | false                   |
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should have key "SayariEntityID" with the stored key value "sayariEntityID"
    And response body should match the schema from the file "sayariEntityRelationship"
    When user store the response body keyData:"RelationshipID" with keyName:"relationshipID"

  Scenario: 010 Should be able to get sayari entity relationship details
    Given user has a service named "/api/v1/client/onboardingsayarientityrelationship/get"
    And user has a query params from the file 'sayariEntityRelationship' with selected keys 'BusinessUnitID,ReturnFormat'
    And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
    And user add query parameter 'SayariEntityID' with the stored key value 'sayariEntityID'
    And user add query parameter 'RelationshipID' with the stored key value 'relationshipID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "sayariEntityRelationship"
    And response body should have key with the value:
      | key                            | value                   |
      | BusinessUnitID                 |                      10 |
      | SayariEntityRelationshipTypeID |                      10 |
      | Title                          | Mr                      |
      | LastName                       | SWIGGY SERVICES PTY LTD |
      | Position                       | QA                      |
      | Address                        | abv                     |
      | IsFormer                       | false                   |
      | IsCorporate                    | true                    |
      | SayariEntityUniqueReference    | b7TylwOWydiLZEgAFoXJtg  |
      | Deleted                        | false                   |
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should have key "SayariEntityID" with the stored key value "sayariEntityID"
    And response body should have key "RelationshipID" with the stored key value "relationshipID"

  Scenario: 011 Should be able to update sayari entity relationship
    Given user has a service named "/api/v1/client/onboardingsayarientityrelationship/update"
    And user has a payload from the file 'sayariEntityRelationship'
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And user add payload "SayariEntityID" with the stored key value "sayariEntityID"
    And user add payload "RelationshipID" with the stored key value "relationshipID"
    And user has payloads:
      """
      {
          "Position":"Dev",
          "Address":"def"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                            | value                   |
      | BusinessUnitID                 |                      10 |
      | SayariEntityRelationshipTypeID |                      10 |
      | Title                          | Mr                      |
      | LastName                       | SWIGGY SERVICES PTY LTD |
      | Position                       | Dev                     |
      | Address                        | def                     |
      | IsFormer                       | false                   |
      | IsCorporate                    | true                    |
      | SayariEntityUniqueReference    | b7TylwOWydiLZEgAFoXJtg  |
      | Deleted                        | false                   |
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should have key "SayariEntityID" with the stored key value "sayariEntityID"
    And response body should have key "RelationshipID" with the stored key value "relationshipID"
    And response body should match the schema from the file "sayariEntityRelationship"

  Scenario: 012 Should be able to get all sayari entity relationship details
    Given user has a service named "/api/v1/client/onboardingsayarientityrelationship/add"
    And user has a payload from the file 'sayariEntityRelationship'
    And user has payloads:
      """
      {
          "SayariEntityRelationshipTypeID": "11",
          "Position": "Lead",
          "Address": "pqr"
      }
      """
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And user add payload "SayariEntityID" with the stored key value "sayariEntityID"
    And user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"RelationshipID" with keyName:"secondRelationshipID"
    And user has a service named "/api/v1/client/onboardingsayarientityrelationship/getall"
    And user has a query params from the file 'sayariEntityRelationship' with selected keys 'BusinessUnitID,ReturnFormat'
    And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
    And user add query parameter 'SayariEntityID' with the stored key value 'sayariEntityID'
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "sayariEntityRelationshipGetAll"
    And response body should have index key with the value:
      | index | key                            | value                   |
      |     1 | BusinessUnitID                 |                      10 |
      |     1 | SayariEntityRelationshipTypeID |                      10 |
      |     1 | Title                          | Mr                      |
      |     1 | LastName                       | SWIGGY SERVICES PTY LTD |
      |     1 | Position                       | Dev                     |
      |     1 | Address                        | def                     |
      |     1 | IsFormer                       | false                   |
      |     1 | IsCorporate                    | true                    |
      |     1 | SayariEntityUniqueReference    | b7TylwOWydiLZEgAFoXJtg  |
      |     1 | Deleted                        | false                   |
      |     2 | BusinessUnitID                 |                      10 |
      |     2 | SayariEntityRelationshipTypeID |                      11 |
      |     2 | Title                          | Mr                      |
      |     2 | LastName                       | SWIGGY SERVICES PTY LTD |
      |     2 | Position                       | Lead                    |
      |     2 | Address                        | pqr                     |
      |     2 | IsFormer                       | false                   |
      |     2 | IsCorporate                    | true                    |
      |     2 | SayariEntityUniqueReference    | b7TylwOWydiLZEgAFoXJtg  |
      |     2 | Deleted                        | false                   |
    And response body should have index key with the stored key value:
      | index | key                   | storedKey            |
      |     1 | ClientProspectGroupID | prospectGroupID      |
      |     1 | SayariEntityID        | sayariEntityID       |
      |     1 | RelationshipID        | relationshipID       |
      |     2 | ClientProspectGroupID | prospectGroupID      |
      |     2 | SayariEntityID        | sayariEntityID       |
      |     2 | RelationshipID        | secondRelationshipID |

  Scenario: 013 Should be able to add sayari source
    Given user has a service named "/api/v1/client/onboardingsayarisource/add"
    And user has a payload from the file 'sayariSource'
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And user add payload "SayariEntityID" with the stored key value "sayariEntityID"
    When user sends a 'POST' request
    Then response status should be 201
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                         | value                                                    |
      | BusinessUnitID              |                                                       10 |
      | SayariRecordUniqueReference | d487bf88d1cca767534a0c9022ae606f/637619571/1735603200000 |
      | Name                        | Company Record from Australia ASIC Company Dataset       |
      | Url                         | https://data.gov.au/data/dataset/asic-companies          |
      | PublicationDate             |                                               2024-12-31 |
      | AcquisitionDate             |                                               2024-12-31 |
      | SayariSourceTypeID          |                                                        1 |
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should have key "SayariEntityID" with the stored key value "sayariEntityID"
    And response body should match the schema from the file "sayariSource"
    When user store the response body keyData:"SourceID" with keyName:"sourceID"

  Scenario: 014 Should be able to get sayari source
    Given user has a service named "/api/v1/client/onboardingsayarisource/get"
    And user has a query params from the file 'sayariSource' with selected keys 'BusinessUnitID,ReturnFormat,RelationshipID'
    And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
    And user add query parameter 'SayariEntityID' with the stored key value 'sayariEntityID'
    And user add query parameter 'SayariSourceID' with the stored key value 'sourceID'
    When user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "sayariSource"
    And response body should have key with the value:
      | key                         | value                                                    |
      | BusinessUnitID              |                                                       10 |
      | SayariRecordUniqueReference | d487bf88d1cca767534a0c9022ae606f/637619571/1735603200000 |
      | Name                        | Company Record from Australia ASIC Company Dataset       |
      | Url                         | https://data.gov.au/data/dataset/asic-companies          |
      | PublicationDate             |                                               2024-12-31 |
      | AcquisitionDate             |                                               2024-12-31 |
      | SayariSourceTypeID          |                                                        1 |
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should have key "SayariEntityID" with the stored key value "sayariEntityID"
    And response body should have key "SourceID" with the stored key value "sourceID"

  Scenario: 015 Should be able to update sayari source
    Given user has a service named "/api/v1/client/onboardingsayarisource/update"
    And user has a payload from the file 'sayariSource'
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And user add payload "SayariEntityID" with the stored key value "sayariEntityID"
    And user add payload "SourceID" with the stored key value "sourceID"
    And user has payloads:
      """
      {
          "Name":"Company Record from Australia ASIC Company Dataset - Update",
          "SayariSourceTypeID":"2"
      }
      """
    When user sends a 'PUT' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should have key with the value:
      | key                         | value                                                       |
      | BusinessUnitID              |                                                          10 |
      | SayariRecordUniqueReference | d487bf88d1cca767534a0c9022ae606f/637619571/1735603200000    |
      | Name                        | Company Record from Australia ASIC Company Dataset - Update |
      | Url                         | https://data.gov.au/data/dataset/asic-companies             |
      | PublicationDate             |                                                  2024-12-31 |
      | AcquisitionDate             |                                                  2024-12-31 |
      | SayariSourceTypeID          |                                                           2 |
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should have key "SayariEntityID" with the stored key value "sayariEntityID"
    And response body should have key "SourceID" with the stored key value "sourceID"
    And response body should match the schema from the file "sayariSource"

  Scenario: 016 Should be able to get all sayari source
    Given user has a service named "/api/v1/client/onboardingsayarisource/add"
    And user has a payload from the file 'sayariSource'
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And user add payload "SayariEntityID" with the stored key value "sayariEntityID"
    And user has payloads:
      """
      {
          "Name": "Company Record from India ASIC Company Dataset",
          "SayariRecordUniqueReference": "d487bf88d1cca767534a0c9022ae606f/637619571/1735603201111",
          "Url": "https://data.gov.au/data/dataset/asic-companies",
          "SayariSourceTypeID": "2"
      }
      """
    When user sends a 'POST' request
    Then response status should be 201
    When user store the response body keyData:"SourceID" with keyName:"secondSourceID"
    And user has a service named "/api/v1/client/onboardingsayarisource/getall"
    And user has a query params from the file 'sayariSource' with selected keys 'BusinessUnitID,ReturnFormat'
    And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
    And user add query parameter 'SayariEntityID' with the stored key value 'sayariEntityID'
    And user sends a 'GET' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "sayariSourceGetAll"
    And response body should have index key with the value:
      | index | key                         | value                                                       |
      |     1 | BusinessUnitID              |                                                          10 |
      |     1 | SayariRecordUniqueReference | d487bf88d1cca767534a0c9022ae606f/637619571/1735603200000    |
      |     1 | Name                        | Company Record from Australia ASIC Company Dataset - Update |
      |     1 | Url                         | https://data.gov.au/data/dataset/asic-companies             |
      |     1 | PublicationDate             |                                                  2024-12-31 |
      |     1 | AcquisitionDate             |                                                  2024-12-31 |
      |     1 | SayariSourceTypeID          |                                                           2 |
      |     2 | BusinessUnitID              |                                                          10 |
      |     2 | SayariRecordUniqueReference | d487bf88d1cca767534a0c9022ae606f/637619571/1735603201111    |
      |     2 | Name                        | Company Record from India ASIC Company Dataset              |
      |     2 | Url                         | https://data.gov.au/data/dataset/asic-companies             |
      |     2 | PublicationDate             |                                                  2024-12-31 |
      |     2 | AcquisitionDate             |                                                  2024-12-31 |
      |     2 | SayariSourceTypeID          |                                                           2 |
    And response body should have index key with the stored key value:
      | index | key                   | storedKey       |
      |     1 | ClientProspectGroupID | prospectGroupID |
      |     1 | SayariEntityID        | sayariEntityID  |
      |     1 | SourceID              | sourceID        |
      |     2 | ClientProspectGroupID | prospectGroupID |
      |     2 | SayariEntityID        | sayariEntityID  |
      |     2 | SourceID              | secondSourceID  |

   Scenario: 017 Should be able to delete sayari source
     Given user has a service named "/api/v1/client/onboardingsayarisource/delete"
     And user has a query params from the file 'sayariSource' with selected keys 'BusinessUnitID,ActionUserID,ReturnFormat,RelationshipID'
     And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
     And user add query parameter 'SayariEntityID' with the stored key value 'sayariEntityID'
     And user add query parameter 'SayariSourceID' with the stored key value 'sourceID'
     When user sends a 'DELETE' request
     Then response status should be 200
     And response header should be 'content-type':'application/json; charset=utf-8'
     And response body should match the schema from the file "sayariSource"
     And response body should have key with the value:
       | key                         | value                                                       |
       | BusinessUnitID              |                                                          10 |
       | SayariRecordUniqueReference | d487bf88d1cca767534a0c9022ae606f/637619571/1735603200000    |
       | Name                        | Company Record from Australia ASIC Company Dataset - Update |
       | Url                         | https://data.gov.au/data/dataset/asic-companies             |
       | PublicationDate             |                                                  2024-12-31 |
       | AcquisitionDate             |                                                  2024-12-31 |
       | SayariSourceTypeID          |                                                           1 |
     And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
     And response body should have key "SayariEntityID" with the stored key value "sayariEntityID"
     And response body should have key "SourceID" with the stored key value "sourceID"

  Scenario: 018 Should be able to delete sayari entity relationship details
    Given user has a service named "/api/v1/client/onboardingsayarientityrelationship/delete"
    And user has a query params from the file 'sayariEntityAttribute' with selected keys 'BusinessUnitID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
    And user add query parameter 'SayariEntityID' with the stored key value 'sayariEntityID'
    And user add query parameter 'RelationshipID' with the stored key value 'relationshipID'
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "sayariEntityRelationship"
    And response body should have key with the value:
      | key                            | value                   |
      | BusinessUnitID                 |                      10 |
      | SayariEntityRelationshipTypeID |                      10 |
      | Title                          | Mr                      |
      | LastName                       | SWIGGY SERVICES PTY LTD |
      | Position                       | Dev                     |
      | Address                        | def                     |
      | IsFormer                       | false                   |
      | IsCorporate                    | true                    |
      | SayariEntityUniqueReference    | b7TylwOWydiLZEgAFoXJtg  |
      | Deleted                        | false                   |
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should have key "SayariEntityID" with the stored key value "sayariEntityID"
    And response body should have key "RelationshipID" with the stored key value "relationshipID"

  Scenario: 019 Should be able to delete sayari entity attribute details
    Given user has a service named "/api/v1/client/onboardingsayarientityattribute/delete"
    And user has a query params from the file 'sayariEntityAttribute' with selected keys 'BusinessUnitID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
    And user add query parameter 'SayariEntityID' with the stored key value 'sayariEntityID'
    And user add query parameter 'AttributeID' with the stored key value 'attributeID'
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "sayariEntityAttribute"
    And response body should have key with the value:
      | key                         | value                          |
      | BusinessUnitID              |                             10 |
      | SayariEntityAttributeTypeID |                             10 |
      | Name                        | Auto-Address - Update          |
      | Value                       | 88 WIGRAM ST, Sydney, AU, 2151 |
      | Type                        | Address                        |
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should have key "SayariEntityID" with the stored key value "sayariEntityID"
    And response body should have key "AttributeID" with the stored key value "attributeID"

  Scenario: 020 Should be able to delete sayari entity details
    Given user has a service named "/api/v1/client/onboardingsayarientity/delete"
    And user has a query params from the file 'sayariEntity' with selected keys 'BusinessUnitID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
    And user add query parameter 'SayariEntityID' with the stored key value 'sayariEntityID'
    When user sends a 'DELETE' request
    Then response status should be 200
    And response header should be 'content-type':'application/json; charset=utf-8'
    And response body should match the schema from the file "sayariEntity"
    And response body should have key with the value:
      | key                         | value                            |
      | BusinessUnitID              |                               10 |
      | SayariEntityName            | SWIGGY SERVICES PTY LTD - Update |
      | SayariEntityUniqueReference | b7TylwOWydiLZEgAFoXJtg           |
      | SayariEntityTypeID          |                                2 |
    And response body should have key "ClientProspectGroupID" with the stored key value "prospectGroupID"
    And response body should have key "SayariEntityID" with the stored key value "sayariEntityID"
    When user has a service named "/api/v1/client/onboardingsayarientity/delete"
    And user has a query params from the file 'sayariEntity' with selected keys 'BusinessUnitID,ActionUserID,ReturnFormat'
    And user add query parameter 'ClientProspectGroupID' with the stored key value 'prospectGroupID'
    And user add query parameter 'SayariEntityID' with the stored key value 'secondSayariEntityID'
    And user sends a 'DELETE' request
    Then response status should be 200

  Scenario: 021 Should be able to delete a prospect group
    Given user has a service named "/api/v1/client/prospectgroup/delete"
    And user has a payload from the file "prospectGroup" with selected keys "BusinessUnitID,ActionUserID,ReturnFormat"
    And user add payload "ClientProspectGroupID" with the stored key value "prospectGroupID"
    When user sends a 'DELETE' request
    Then response status should be 200
