@GetConsent

Feature: Testing GetConsent api

  Background:
    * configure ssl = true

  Scenario: US#08,Check with Mandatory authorisation to get the AwaitingAuthorisation consents
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * print result
    * def Token = result.Token
    * print Token
    * def GetURL =  read('testdata/URL.json')
    Given url GetURL.GetConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * def ConsentAwaitingAuthorisationStatus = response.Data.Status
    And match ConsentAwaitingAuthorisationStatus == 'AwaitingAuthorisation'

  Scenario Outline: US#08,check <name> Authorization to get the AwaitingAuthorisation consents
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def GetURL =  read('testdata/URL.json')
    Given url GetURL.GetConsentUrl
    And path consentId
    And headers { Authorization: '<Authorization>' }
    And header x-fapi-financial-id = "open-bank"
    When method get
    Then status 401

    Examples:
      |Authorization         |    name                      |
      |Basic YWRtaW46YWdhggtw|with invalid                  |
      |   Basic              |with invalid special charaters|
      |   Basic2667393       |with invalid                  |
      |                      |   with Null                  |

  Scenario: US#08,check Without Authorization to get the AwaitingAuthorisation consents
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def GetURL =  read('testdata/URL.json')
    Given url GetURL.GetConsentUrl
    And path consentId
    And header x-fapi-financial-id = "open-bank"
    When method get
    Then status 401

  Scenario Outline: US#08,check <name> Content-Type to get the AwaitingAuthorisation consents
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def GetURL =  read('testdata/URL.json')
    * def Token = result.Token
    Given url GetURL.GetConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    And header x-fapi-financial-id = "open-bank"
    And headers { Content-Type: '<Content-Type>' }
    When method get
    Then status 200
    * def ConsentAwaitingAuthorisationStatus = response.Data.Status
    And match ConsentAwaitingAuthorisationStatus == 'AwaitingAuthorisation'

    Examples:
      |Content-Type|    name                      |
      |application |with invalid                  |
      |$$#%%^^&##!$|with invalid special charaters|
      |            |   with null                  |

  Scenario: US#08,check without Content-Type to get the AwaitingAuthorisation consents
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def GetURL =  read('testdata/URL.json')
    * def Token = result.Token
    Given url GetURL.GetConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    And header x-fapi-financial-id = "open-bank"
    When method get
    Then status 200
    * def ConsentAwaitingAuthorisationStatus = response.Data.Status
    And match ConsentAwaitingAuthorisationStatus == 'AwaitingAuthorisation'

  Scenario Outline: US#08,check <name> x-fapi-financial-id to get the AwaitingAuthorisation consents
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def GetURL =  read('testdata/URL.json')
    * def Token = result.Token
    Given url GetURL.GetConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    And headers { x-fapi-financial-id: '<x-fapi-financial-id>' }
    When method get
    Then status 200
    * def ConsentAwaitingAuthorisationStatus = response.Data.Status
    And match ConsentAwaitingAuthorisationStatus == 'AwaitingAuthorisation'

    Examples:
      |x-fapi-financial-id|    name                                  |
      |  open-bank344     |with invalid numebrs                      |
      |open-bank$%^sjjd   |with invalid special charaters            |
      |open-bankghd       |with invalid charaters                    |
      |$%^^hhdopen-bank56 |with invalid special charaters and numbers|
      |                   |   without                                |

  Scenario: US#08,check without x-fapi-financial-id to get the AwaitingAuthorisation consents
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def GetURL =  read('testdata/URL.json')
    * def Token = result.Token
    Given url GetURL.GetConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * def ConsentAwaitingAuthorisationStatus = response.Data.Status
    And match ConsentAwaitingAuthorisationStatus == 'AwaitingAuthorisation'

  Scenario Outline: US#08,Check with <name> ConsentId to get the AwaitingAuthorisation consents
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def GetURL =  read('testdata/URL.json')
    * def Token = result.Token
    Given url GetURL.GetConsentUrl
    And path consentId: consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    And header x-fapi-financial-id = "open-bank"
    When method get
    Then status 400

    Examples:
      |      consentId         | name  |
      |5db153a3600b2700016746  |invalid|
      |hhiwgfsruwieoodlnxrttey |invalid|
      | 6747482778397432414368 |invalid|

  Scenario: US#08,Check without ConsentId to get the AwaitingAuthorisation consents
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def GetURL =  read('testdata/URL.json')
    * def Token = result.Token
    Given url GetURL.GetConsentUrl
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    And header x-fapi-financial-id = "open-bank"
    When method get
    Then status 404

  Scenario: US#08,Check with Mandatory authorisation to get the Authorised consents
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def consentId = result.consentId
    * def AuToken = result.AuToken
    * def GetURL =  read('testdata/URL.json')
    Given url GetURL.GetConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + AuToken
    When method get
    Then status 200
    * def ConsentAwaitingAuthorisationStatus = response.Data.Status
    And match ConsentAwaitingAuthorisationStatus == 'Authorised'

  Scenario Outline: US#08,check <name> Authorization to get the Authorised consents
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def consentId = result.consentId
    * def GetURL =  read('testdata/URL.json')
    Given url GetURL.GetConsentUrl
    And path consentId
    And headers { Authorization: '<Authorization>' }
    And header x-fapi-financial-id = "open-bank"
    When method get
    Then status 401

    Examples:
      |Authorization         |    name                      |
      |Basic YWRtaW46YWdhggtw|with invalid                  |
      |   Basic $%^^##@@     |with invalid special charaters|
      |   Basic2667393       |with invalid                  |
      |                      |   with Null                  |

  Scenario: US#08,check Without Authorization to get the Authorised consents
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def consentId = result.consentId
    * def GetURL =  read('testdata/URL.json')
    Given url GetURL.GetConsentUrl
    And path consentId
    And header x-fapi-financial-id = "open-bank"
    When method get
    Then status 401

  Scenario Outline: US#08,check <name> Content-Type to get the Authorised consents
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def consentId = result.consentId
    * def AuToken = result.AuToken
    * def GetURL =  read('testdata/URL.json')
    Given url GetURL.GetConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + AuToken
    And header x-fapi-financial-id = "open-bank"
    And headers { Content-Type: '<Content-Type>' }
    When method get
    Then status 200
    * def ConsentAwaitingAuthorisationStatus = response.Data.Status
    And match ConsentAwaitingAuthorisationStatus == 'Authorised'

    Examples:
      |Content-Type|    name                      |
      |application |with invalid                  |
      |$$#%%^^&##!$|with invalid special charaters|
      |            |   with null                  |

  Scenario: US#08,check without Content-Type to get the Authorised consents
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def consentId = result.consentId
    * def AuToken = result.AuToken
    * def GetURL =  read('testdata/URL.json')
    Given url GetURL.GetConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + AuToken
    And header x-fapi-financial-id = "open-bank"
    When method get
    Then status 200
    * def ConsentAwaitingAuthorisationStatus = response.Data.Status
    And match ConsentAwaitingAuthorisationStatus == 'Authorised'

  Scenario Outline: US#08,check <name> x-fapi-financial-id to get the Authorised consents
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def consentId = result.consentId
    * def AuToken = result.AuToken
    * def GetURL =  read('testdata/URL.json')
    Given url GetURL.GetConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + AuToken
    And headers { x-fapi-financial-id: '<x-fapi-financial-id>' }
    When method get
    Then status 200
    * def ConsentAwaitingAuthorisationStatus = response.Data.Status
    And match ConsentAwaitingAuthorisationStatus == 'Authorised'

    Examples:
      |x-fapi-financial-id|    name                                  |
      |  open-bank344     |with invalid numebrs                      |
      |open-bank$%^sjjd   |with invalid special charaters            |
      |open-bankghd       |with invalid charaters                    |
      |$%^^hhdopen-bank56 |with invalid special charaters and numbers|
      |                   |   without                                |

  Scenario: US#08,check without x-fapi-financial-id to get the Authorised consents
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def consentId = result.consentId
    * def AuToken = result.AuToken
    * def GetURL =  read('testdata/URL.json')
    Given url GetURL.GetConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + AuToken
    When method get
    Then status 200
    * def ConsentAwaitingAuthorisationStatus = response.Data.Status
    And match ConsentAwaitingAuthorisationStatus == 'Authorised'

  Scenario Outline: US#08,Check with <name> ConsentId to get the Authorised consents
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def GetURL =  read('testdata/URL.json')
    * def AuToken = result.AuToken
    Given url GetURL.GetConsentUrl
    And path consentId: consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + AuToken
    And header x-fapi-financial-id = "open-bank"
    When method get
    Then status 400

    Examples:
      |      consentId         | name  |
      |5db153a3600b2700016746  |invalid|
      |hhiwgfsruwieoodlnxrttey |invalid|
      | 6747482778397432414368 |invalid|

  Scenario: US#08,Check without ConsentId to get the Authorised consents
    * def result = call read('WebUpdateConsent.feature@tag=ConsentAuthorised')
    * def GetURL =  read('testdata/URL.json')
    * def AuToken = result.AuToken
    Given url GetURL.GetConsentUrl
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + AuToken
    And header x-fapi-financial-id = "open-bank"
    When method get
    Then status 404

  Scenario: US#08,Check with Mandatory authorisation to get the Rejected consents
    * def result = call read('UpdateConsent.feature@tag=ConsentRejected')
    * def consentId = result.consentId
    * def GetURL =  read('testdata/URL.json')
    * def Token = result.Token
    Given url GetURL.GetConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * def ConsentAwaitingAuthorisationStatus = response.Data.Status
    And match ConsentAwaitingAuthorisationStatus == 'Rejected'
    * match response ==

  """
{
    "Data": {
        "ConsentId": "#string",
        "Status": "Rejected",
        "ExpirationDateTime": "#ignore",
        "CreationDateTime": "#ignore",
        "StatusUpdateDateTime": "#ignore",
        "TransactionFromDateTime": "#ignore",
        "TransactionToDateTime": "#ignore",
        "Permissions": [
            "ReadAccountsDetail",
            "ReadBalances",
            "ReadTransactionsDetail"
        ]
    },
    "Risk": {
        "description": "#ignore"
    },
    "Meta": {
        "TotalPages": 1
    },
    "Links": {
        "Self": "#ignore"
    }
}
"""

  Scenario: US#08,check Without Authorization to get the Rejected consents
    * def result = call read('UpdateConsent.feature@tag=ConsentRejected')
    * def consentId = result.consentId
    * def GetURL =  read('testdata/URL.json')
    Given url GetURL.GetConsentUrl
    And path consentId
    And header x-fapi-financial-id = "open-bank"
    When method get
    Then status 400

  Scenario Outline: US#08,check <name> Content-Type to get the Rejected consents
    * def result = call read('UpdateConsent.feature@tag=ConsentRejected')
    * def consentId = result.consentId
    * def GetURL =  read('testdata/URL.json')
    * def Token = result.Token
    Given url GetURL.GetConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    And header x-fapi-financial-id = "open-bank"
    And headers { Content-Type: '<Content-Type>' }
    When method get
    Then status 200
    * def ConsentAwaitingAuthorisationStatus = response.Data.Status
    And match ConsentAwaitingAuthorisationStatus == 'Rejected'

    Examples:
      |Content-Type|    name                      |
      |application |with invalid                  |
      |$$#%%^^&##!$|with invalid special charaters|
      |            |   with null                  |

  Scenario: US#08,check without Content-Type to get the Rejected consents
    * def result = call read('UpdateConsent.feature@tag=ConsentRejected')
    * def consentId = result.consentId
    * def GetURL =  read('testdata/URL.json')
    * def Token = result.Token
    Given url GetURL.GetConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    And header x-fapi-financial-id = "open-bank"
    When method get
    Then status 200
    * def ConsentAwaitingAuthorisationStatus = response.Data.Status
    And match ConsentAwaitingAuthorisationStatus == 'Rejected'

  Scenario Outline: US#08,check <name> x-fapi-financial-id to get the Rejected consents
    * def result = call read('UpdateConsent.feature@tag=ConsentRejected')
    * def consentId = result.consentId
    * def GetURL =  read('testdata/URL.json')
    * def Token = result.Token
    Given url GetURL.GetConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    And headers { x-fapi-financial-id: '<x-fapi-financial-id>' }
    When method get
    Then status 200
    * def ConsentAwaitingAuthorisationStatus = response.Data.Status
    And match ConsentAwaitingAuthorisationStatus == 'Rejected'

    Examples:
      |x-fapi-financial-id|    name                                  |
      |  open-bank344     |with invalid numebrs                      |
      |open-bank$%^sjjd   |with invalid special charaters            |
      |open-bankghd       |with invalid charaters                    |
      |$%^^hhdopen-bank56 |with invalid special charaters and numbers|
      |                   |   without                                |

  Scenario: US#08,check without x-fapi-financial-id to get the Rejected consents
    * def result = call read('UpdateConsent.feature@tag=ConsentRejected')
    * def consentId = result.consentId
    * def GetURL =  read('testdata/URL.json')
    * def Token = result.Token
    Given url GetURL.GetConsentUrl
    And path consentId
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * def ConsentAwaitingAuthorisationStatus = response.Data.Status
    And match ConsentAwaitingAuthorisationStatus == 'Rejected'

  Scenario Outline: US#08,Check with <name> ConsentId to get the Rejected consents
    * def result = call read('UpdateConsent.feature@tag=ConsentRejected')
    * def consentId = result.consentId
    * def GetURL =  read('testdata/URL.json')
    * def Token = result.Token
    Given url GetURL.GetConsentUrl
    And path {consentId: '<consentId>'}
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    And header x-fapi-financial-id = "open-bank"
    When method get
    Then status 400

    Examples:
      |      consentId         | name  |
      |5db153a3600b2700016746  |invalid|
      |hhiwgfsruwieoodlnxrttey |invalid|
      | 6747482778397432414368 |invalid|

  Scenario: US#08,Check without ConsentId to get the Rejected consents
    * def result = call read('UpdateConsent.feature@tag=ConsentRejected')
    * def consentId = result.consentId
    * def GetURL =  read('testdata/URL.json')
    * def Token = result.Token
    Given url GetURL.GetConsentUrl
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    And header x-fapi-financial-id = "open-bank"
    When method get
    Then status 400
