Feature: Testing UpdateConsent api

  @tag=ConsentAuthorised
  Scenario: US#10,Check with Mandatory authorisation to Authorise the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def UpdateURL =  read('testdata/URL.json')
    Given url UpdateURL.UpdateConsentUrl
    And path consentId
    * def ConsentContentType =  read('testdata/headers.json')
    And header Content-Type = ConsentContentType.UpdateContentType
    And request { "Status":"Authorised","Accounts":["123456","654321"],"CustomerId":"100100" }
    When method put
    Then status 200
    * def ConsentAuthorisedStatus = response.Data.Status
    And match ConsentAuthorisedStatus == 'Authorised'
    * match response ==
  """
{
    "Data": {
        "ConsentId": "#string",
        "Status": "Authorised",
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

  @tag=AuthorisedDetailPermissions
  Scenario: US#10,Check Authorised the consent with DetailPermissions
    * def result = call read('CreateConsent.feature@tag=ConsentWithDetailpermissions')
    * def consentId = result.response.Data.ConsentId
    * def UpdateURL =  read('testdata/URL.json')
    Given url UpdateURL.UpdateConsentUrl
    And path consentId
    * def ConsentContentType =  read('testdata/headers.json')
    * def AccountId1 = ConsentContentType.AccountsId1
    * def CustomerId = ConsentContentType.CustomerId
    And header Content-Type = ConsentContentType.UpdateContentType
    And request ({ "Status":"Authorised","Accounts":[AccountId1],"CustomerId":CustomerId})
    When method put
    Then status 200
    And match response.Data.Status == 'Authorised'
    And match response.Data.Permissions == ["ReadAccountsDetail"]

  @tag=AuthorisedWithBasicPermissions
  Scenario: US#10,Check Authorised the consent with BasicPermissions
    * def result = call read('CreateConsent.feature@tag=ConsentWithBasicPermissions')
    * def consentId = result.response.Data.ConsentId
    * def UpdateURL =  read('testdata/URL.json')
    Given url UpdateURL.UpdateConsentUrl
    And path consentId
    * def ConsentContentType =  read('testdata/headers.json')
    * def AccountId1 = ConsentContentType.AccountsId1
    * def CustomerId = ConsentContentType.CustomerId
    And header Content-Type = ConsentContentType.UpdateContentType
    And request ({ "Status":"Authorised","Accounts":[AccountId1],"CustomerId":CustomerId})
    When method put
    Then status 200
    And match response.Data.Status == 'Authorised'
    And match response.Data.Permissions == ["ReadAccountsDetail"]


  Scenario Outline: US#10,check <name> Authorization to Authorise the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def UpdateURL =  read('testdata/URL.json')
    Given url UpdateURL.UpdateConsentUrl
    And path consentId
    * def ConsentContentType =  read('testdata/headers.json')
    And header Content-Type = ConsentContentType.UpdateContentType
    And headers { Authorization: '<Authorization>' }
    And request { "Status":"Authorised","Accounts":["123456","654321"],"CustomerId":"100100" }
    When method put
    Then status 200
    * def ConsentAuthorisedStatus = response.Data.Status
    And match ConsentAuthorisedStatus == 'Authorised'

    Examples:
      |       Authorization          |    name                      |
      |   Basic YWRtaW4667848489     |with invalid                  |
      |   Basic YWRtaW4#$$^&@#^&     |with invalid special charaters|
      |   Basic hdjkdkkhyeuwdkkd     |with invalid charaters        |
      |                              |   with Null                  |

  Scenario: US#10,check without Authorization to Authorise the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def UpdateURL =  read('testdata/URL.json')
    Given url UpdateURL.UpdateConsentUrl
    And path consentId
    * def ConsentContentType =  read('testdata/headers.json')
    And header Content-Type = ConsentContentType.UpdateContentType
    And request { "Status":"Authorised","Accounts":["123456","654321"],"CustomerId":"100100" }
    When method put
    Then status 200
    * def ConsentAuthorisedStatus = response.Data.Status
    And match ConsentAuthorisedStatus == 'Authorised'

  Scenario Outline: US#10,check <name> Content-Type to Authorise the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def UpdateURL =  read('testdata/URL.json')
    Given url UpdateURL.UpdateConsentUrl
    And path consentId
    And headers { Content-Type: '<Content-Type>' }
    And request { "Status":"Authorised","Accounts":["123456","654321"],"CustomerId":"100100" }
    When method put
    And status 400

    Examples:
      |Content-Type|    name                      |
      |application |with invalid                  |
      |$$#%%^^&##!$|with invalid special charaters|
      |            |   without                    |

  Scenario Outline: US#10,check <name> Status to Authorise the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def UpdateURL =  read('testdata/URL.json')
    Given url UpdateURL.UpdateConsentUrl
    And path consentId
    * def ConsentContentType =  read('testdata/headers.json')
    And header Content-Type = ConsentContentType.UpdateContentType
    And request { "Status": '<Authorised>',"Accounts":["123456","654321"],"CustomerId":"100100" }
    When method put
    And status 400

    Examples:
      | Authorised     |    name                      |
      |AuthorisedDhshx |with invalid                  |
      |$$#%%^^&##!$    |with invalid special charaters|
      |                |   without                    |


  Scenario Outline: US#10,check <name> Accounts Number to Authorise the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def UpdateURL =  read('testdata/URL.json')
    Given url UpdateURL.UpdateConsentUrl
    And path consentId
    * def ConsentContentType =  read('testdata/headers.json')
    And header Content-Type = ConsentContentType.UpdateContentType
    And request { "Status": "Authorised","Accounts":[<Accounts>],"CustomerId":"100100" }
    When method put
    And status 400

    Examples:
      |   Accounts     |    name                      |
      | $^t663737#$    |with invalid                  |
      |$$#%%^^&##!$    |with invalid special charaters|
      |                |   without                    |

  Scenario Outline: US#10,check <name> CustomerId to Authorise the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def UpdateURL =  read('testdata/URL.json')
    Given url UpdateURL.UpdateConsentUrl
    And path consentId
    * def ConsentContentType =  read('testdata/headers.json')
    And header Content-Type = ConsentContentType.UpdateContentType
    And request { "Status":"Authorised","Accounts":["123456","654321"],"CustomerId":'<CustomerId>' }
    When method put
    And status 400

    Examples:
      |   CustomerId   |    name                      |
      | esjd663737hk   |with invalid                  |
      | gdhhdjjdjdjh   |with invalid Charaters        |
      |$$#%%^^&##!$    |with invalid special charaters|
      |                |   without                    |

  Scenario: US#10,Check without ConsentId to Authorise the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def UpdateURL =  read('testdata/URL.json')
    Given url UpdateURL.UpdateConsentUrl
    * def ConsentContentType =  read('testdata/headers.json')
    And header Content-Type = ConsentContentType.UpdateContentType
    And request { "Status":"Authorised","Accounts":["123456","654321"],"CustomerId":"100100" }
    When method put
    And status 400

  Scenario: US#10,Check with invalid HTTP method to Authorise the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    Given url 'httppps://bacb-bitsy.uksouth.cloudapp.azure.com/account-access-consents/internal/'
    And path consentId
    * def ConsentContentType =  read('testdata/headers.json')
    And header Content-Type = ConsentContentType.UpdateContentType
    And request { "Status":"Authorised","Accounts":["123456","654321"],"CustomerId":"100100" }
    When method put
    And status 400

  @tag=ConsentRejected
  Scenario: US#10,Check with Mandatory authorisation to Reject the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def UpdateURL =  read('testdata/URL.json')
    Given url UpdateURL.UpdateConsentUrl
    And path consentId
    * def ConsentContentType =  read('testdata/headers.json')
    And header Content-Type = ConsentContentType.UpdateContentType
    And request { "Status":"Rejected","CustomerId":"100100" }
    When method put
    Then status 200
    * def ConsentRejectedStatus = response.Data.Status
    And match ConsentRejectedStatus == 'Rejected'

  Scenario Outline: US#10,check <name> Authorization to Reject the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def UpdateURL =  read('testdata/URL.json')
    Given url UpdateURL.UpdateConsentUrl
    And path consentId
    * def ConsentContentType =  read('testdata/headers.json')
    And header Content-Type = ConsentContentType.UpdateContentType
    And headers { Authorization: '<Authorization>' }
    And request { "Status":"Rejected","CustomerId":"100100" }
    When method put
    Then status 200
    * def ConsentAuthorisedStatus = response.Data.Status
    And match ConsentAuthorisedStatus == 'Rejected'

    Examples:
      |Authorization|    name                      |
      |   53738     |with invalid                  |
      |   #$%^@     |with invalid special charaters|
      |   gyjsj     |with invalid charaters        |
      |             |   without                    |


  Scenario Outline: US#10,check <name> Content-Type to Reject the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def UpdateURL =  read('testdata/URL.json')
    Given url UpdateURL.UpdateConsentUrl
    And path consentId
    And headers { Content-Type: '<Content-Type>' }
    And request { "Status":"Rejected","CustomerId":"100100" }
    When method put
    And status 400

    Examples:
      |Content-Type|    name                      |
      |application |with invalid                  |
      |$$#%%^^&##!$|with invalid special charaters|
      |            |   without                    |

  Scenario Outline: US#10,check <name> Status to Reject the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def UpdateURL =  read('testdata/URL.json')
    Given url UpdateURL.UpdateConsentUrl
    And path consentId
    * def ConsentContentType =  read('testdata/headers.json')
    And header Content-Type = ConsentContentType.UpdateContentType
    And request { "Status": '<Rejected>',"CustomerId":"100100" }
    When method put
    And status 400

    Examples:
      |   Rejected     |    name                      |
      |  RejectedDhshx |with invalid                  |
      |$$#%%^^&##!$    |with invalid special charaters|
      |                |   without                    |

  Scenario Outline: US#10,check <name> Accounts Number to Reject the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def UpdateURL =  read('testdata/URL.json')
    Given url UpdateURL.UpdateConsentUrl
    And path consentId
    * def ConsentContentType =  read('testdata/headers.json')
    And header Content-Type = ConsentContentType.UpdateContentType
    And request { "Status": "Rejected","Accounts":[<Accounts>],"CustomerId":"100100" }
    When method put
    And status 400

    Examples:
      |   Accounts      |     name                     |
      |"123456","654321"|     valid                    |
      | $^t663737#$     |with invalid                  |
      |$$#%%^^&##!$     |with invalid special charaters|

  Scenario Outline: US#10,check <name> CustomerId to Reject the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def UpdateURL =  read('testdata/URL.json')
    Given url UpdateURL.UpdateConsentUrl
    And path consentId
    * def ConsentContentType =  read('testdata/headers.json')
    And header Content-Type = ConsentContentType.UpdateContentType
    And request { "Status":"Rejected","CustomerId":'<CustomerId>' }
    When method put
    And status 400

    Examples:
      |   CustomerId   |    name                      |
      | esjd663737hk   |with invalid                  |
      | gdhhdjjdjdjh   |with invalid Charaters        |
      |$$#%%^^&##!$    |with invalid special charaters|
      |                |   without                    |

  Scenario: US#10,Check without ConsentId to Reject the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * def UpdateURL =  read('testdata/URL.json')
    Given url UpdateURL.UpdateConsentUrl
    * def ConsentContentType =  read('testdata/headers.json')
    And header Content-Type = ConsentContentType.UpdateContentType
    And request { "Status":"Rejected","CustomerId":"100100" }
    When method put
    And status 400