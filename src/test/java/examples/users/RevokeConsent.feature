Feature: Testing RevokeConsent api

  Background:
    * configure ssl = true

  Scenario: US#09,Check with proper to Revoke the consent
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def consentId = result.consentId
    * def Token = result.Token
    * def RevokeURL =  read('testdata/URL.json')
    Given url RevokeURL.RevokeConsentUrl
    And path consentId
    And print consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    When method delete
    Then status 204
    * def GetURL =  read('testdata/URL.json')
    And url GetURL.GetConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * def ConsentAwaitingAuthorisationStatus = response.Data.Status
    And match ConsentAwaitingAuthorisationStatus == 'Revoked'


  Scenario Outline: US#08,check <name> Authorization to Revoke consents
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def consentId = result.consentId
    * def Token = result.Token
    * def RevokeURL =  read('testdata/URL.json')
    Given url RevokeURL.RevokeConsentUrl
    And path consentId
    And headers { Authorization: '<Authorization>' }
    And header x-fapi-financial-id = "open-bank"
    When method delete
    Then status 401

    Examples:
      |Authorization         |    name                      |
      |Basic YWRtaW46YWdhggtw|with invalid Charaters        |
      |   Basic $%^^##@@     |with invalid special charaters|
      |   Basic2667393       |with invalid Numbers          |
      |                      |   with Null                  |

  Scenario: US#08,check Without Authorization to Revoke consents
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def consentId = result.consentId
    * def Token = result.Token
    * def RevokeURL =  read('testdata/URL.json')
    Given url RevokeURL.RevokeConsentUrl
    And path consentId
    And header x-fapi-financial-id = "open-bank"
    When method delete
    Then status 401

  Scenario Outline: US#08,check <name> Content-Type to Revoke consents
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def consentId = result.consentId
    * def Token = result.Token
    * def RevokeURL =  read('testdata/URL.json')
    Given url RevokeURL.RevokeConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    And headers { Content-Type: '<Content-Type>' }
    When method delete
    Then status 204

    Examples:
      |Content-Type|    name                      |
      |application |with invalid                  |
      |$$#%%^^&##!$|with invalid special charaters|
      |            |   with null                  |

  Scenario: US#08,check without Content-Type to get the Revoke consents
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def consentId = result.consentId
    * def Token = result.Token
    * def RevokeURL =  read('testdata/URL.json')
    Given url RevokeURL.RevokeConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    And header x-fapi-financial-id = "open-bank"
    When method delete
    Then status 204

  Scenario Outline: US#08,check <name> x-fapi-financial-id to Revoke consents
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def consentId = result.consentId
    * def Token = result.Token
    * def RevokeURL =  read('testdata/URL.json')
    Given url RevokeURL.RevokeConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    And headers { x-fapi-financial-id: '<x-fapi-financial-id>' }
    When method delete
    Then status 204

    Examples:
      |x-fapi-financial-id|    name                                  |
      |  open-bank344     |with invalid numebrs                      |
      |open-bank$%^sjjd   |with invalid special charaters            |
      |open-bankghd       |with invalid charaters                    |
      |$%^^hhdopen-bank56 |with invalid special charaters and numbers|
      |                   |   with Null                              |

  Scenario: US#08,check without x-fapi-financial-id to Revoke consents
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def consentId = result.consentId
    * def Token = result.Token
    * def RevokeURL =  read('testdata/URL.json')
    Given url RevokeURL.RevokeConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    When method delete
    Then status 204

  Scenario: US#08,check AwaitingAuthorisation consent to Revoke
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def Token = result.Token
    * def RevokeURL =  read('testdata/URL.json')
    Given url RevokeURL.RevokeConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    And header x-fapi-financial-id = "open-bank"
    When method delete
    Then status 403

  Scenario: US#08,check Rejected consent to Revoke
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def consentId = result.consentId
    * def Token = result.Token
    * def RevokeURL =  read('testdata/URL.json')
    Given url RevokeURL.RevokeConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    And header x-fapi-financial-id = "open-bank"
    When method delete
    Then status 403

  Scenario: US#09,Check Revoke consent to Revoke it again
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def consentId = result.consentId
    * def Token = result.Token
    * def RevokeURL =  read('testdata/URL.json')
    Given url RevokeURL.RevokeConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    When method delete
    Then status 204
    * def GetURL =  read('testdata/URL.json')
    And url GetURL.GetConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * def ConsentAwaitingAuthorisationStatus = response.Data.Status
    And match ConsentAwaitingAuthorisationStatus == 'Revoked'
    And url RevokeURL.RevokeConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    When method delete
    Then status 403
