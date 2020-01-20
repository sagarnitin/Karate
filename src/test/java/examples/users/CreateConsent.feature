@ConsentCreate
Feature: Testing consent api

  Background:
    * url 'https://bacb-apim.uksouth.cloudapp.azure.com'
    * path '/token'
    * configure ssl = true
    * def TokenCreationData =  read('testdata/Tokengeneration.json')
    * form field username = TokenCreationData.Username
    * form field password = TokenCreationData.Password
    *  form field grant_type = TokenCreationData['grant_type']
    * header Authorization = TokenCreationData.TokenAuthorization
    *  header Content-Type = TokenCreationData['Content-Type']
    * method post
    * status 200
    * print response
    * def Token = response.access_token

  @tag=ConsentCreated  @Sanity
  Scenario: US#02,Check with Mandatory authorisation
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    * def ConsentURL =  read('testdata/URL.json')
    * configure ssl = true
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request read('testdata/cons.json')
    When method post
    Then status 201
    * print response
    * def Status = response.Data.Status
    And match Status == 'AwaitingAuthorisation'
    * def consentId = response.Data.ConsentId
    * def permission = response.Data.Permissions
    * def AutoToken = Token
    * print AutoToken
    And match permission contains ["ReadAccountsDetail","ReadBalances"]

  Scenario Outline: US#02,check <name> Authorization
    * def ConsentURL =  read('testdata/URL.json')
    Given url ConsentURL.CreateConsentUrl
    And headers { Authorization: '<Authorization>' }
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request read('testdata/cons.json')
    When method post
    Then status 401
    * print response

    Examples:
      | Authorization          | name                           |
      | Basic YWRtaW4667848489 | with invalid                   |
      | Basic YWRtaW4#$$^&@#^& | with invalid special charaters |
      | Basic hdjkdkkhyeuwdkkd | with invalid charaters         |
      |                        | with Null                      |

  Scenario: US#02,check without Authorization
    * def ConsentURL =  read('testdata/URL.json')
    Given url ConsentURL.CreateConsentUrl
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request read('testdata/cons.json')
    When method post
    Then status 401
   * print response

  Scenario Outline: US#02, check <name> Content-Type
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And headers { Content-Type: '<Content-Type>' }
    And header x-fapi-financial-id = "open-bank"
    And request read('testdata/cons.json')
    When method post
    Then status 415

    Examples:
      | Content-Type | name                           |
      | application  | with invalid                   |
      | $$#%%^^&##!$ | with invalid special charaters |
      |              | with NULL                      |

  Scenario: US#02, check without Content-Type
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = " "
    And header x-fapi-financial-id = "open-bank"
    And request read('testdata/cons.json')
    When method post
    Then status 415

  Scenario Outline: US#02, check <name> x-fapi-financial-id
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And headers { x-fapi-financial-id: '<x-fapi-financial-id>' }
    And request read('testdata/cons.json')
    When method post
    Then status 201

    Examples:
      | x-fapi-financial-id | name                                       |
      | open-bank344        | with invalid numebrs                       |
      | 56738djjdndjd       | with invalid alphanumaric charaters        |
      |                     | without                                    |

  Scenario Outline: US#02, check <name> x-client-id
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And headers { x-client-id: '<x-client-id>' }
    And header x-fapi-financial-id = "open-bank"
    And request read('testdata/cons.json')
    When method post
    Then status 201

    Examples:
      | x-client-id | name                           |
      | 232674      | with invalid numbers           |
      | hjdjde      | with invalid charaters         |
      | ##$%%^      | with invalid special charaters |
      |             | without                        |

  Scenario Outline: US#02, check with invalid header parameters
    * def ConsentURL =  read('testdata/URL.json')
    Given url ConsentURL.CreateConsentUrl
    And headers { Authorization: '<Authorization>' }
    And headers { Content-Type: '<Content-Type>' }
    And headers { x-client-id: '<x-client-id>' }
    And headers { x-fapi-financial-id: '<x-fapi-financial-id>' }
    And request read('testdata/cons.json')
    When method post
    Then status 401

    Examples:
      | Authorization            | Content-Type | x-client-id | x-fapi-financial-id |
      | Basic YWR6373aW4673gdgjd | application  | hjdjde      | open-bankghd        |

  Scenario: US#02,Check Permissions and Risk
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request read('testdata/cons.json')
    When method post
    Then status 201
    * def permission = response.Data.Permissions
    And match permission contains ["ReadAccountsDetail","ReadBalances","ReadTransactionsDetail"]
    * match response.Risk ==
    """
    {
    "Description": null
   }
    """

  Scenario: US#02,Check without Permissions
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionFromDateTime": "2017-05-03T00:00:00+00:00","TransactionToDateTime": "2017-12-03T00:00:00+00:00"},"Risk": {}}
    When method post
    Then status 400

  Scenario: US#02,Check with invalid risk
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadAccountsDetail","ReadBalances","ReadTransactionsDetail"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionFromDateTime": "2017-05-03T00:00:00+00:00","TransactionToDateTime": "2017-12-03T00:00:00+00:00"},"iRisk": {"description":"fdffds"}}
    When method post
    Then status 400
    * print response

  Scenario: US#02,Check with invalid ISO format ExpirationDateTime
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadAccountsDetail","ReadBalances","ReadTransactionsDetail"],"ExpirationDateTime": "03-12-2017","TransactionFromDateTime": "2017-05-03T00:00:00+00:00","TransactionToDateTime": "2017-12-03T00:00:00+00:00"},"Risk": {"description":"fdffds"}}
    When method post
    Then status 400

  Scenario: US#02,Check without ExpirationDateTime
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadAccountsDetail","ReadBalances","ReadTransactionsDetail"],"TransactionFromDateTime": "2017-05-03T00:00:00+00:00","TransactionToDateTime": "2017-12-03T00:00:00+00:00"},"Risk": {}}
    When method post
    Then status 201
    * print response

  Scenario: US#02,Check with invalid ISO format TransactionFromDateTime
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadAccountsDetail","ReadBalances","ReadTransactionsDetail"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionFromDateTime": "2017-05-03","TransactionToDateTime": "2017-12-03T00:00:00+00:00"},"Risk": {"description":"fdffds"}}
    When method post
    Then status 400

  @tag=ConsentWithOutTransactionFromDateTime
  Scenario: US#02,Check without TransactionFromDateTime
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadAccountsDetail","ReadBalances","ReadTransactionsDetail"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionToDateTime": "2017-12-03T00:00:00+00:00"},"Risk": {}}
    When method post
    Then status 201
    * print response
    * def consentId = response.Data.ConsentId

  Scenario: US#02,Check with invalid ISO format TransactionToDateTime
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadAccountsDetail","ReadBalances","ReadTransactionsDetail"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionFromDateTime": "2017-05-03T00:00:00+00:00","TransactionToDateTime": "2017-12-03"},"Risk": {"description":"fdffds"}}
    When method post
    Then status 400

  @tag=ConsentWithOutTransactionToDateTime
  Scenario: US#02,Check without TransactionToDateTime
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadAccountsDetail","ReadBalances","ReadTransactionsDetail"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionFromDateTime": "2017-05-03T00:00:00+00:00"},"Risk": {}}
    When method post
    Then status 201
    * print response
    * def consentId = response.Data.ConsentId

  @tag=ConsentWithOutTransactionDateTime
  Scenario: US#02,Check without TransactionToDateTime and TransactionFromDateTime
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadAccountsDetail","ReadBalances","ReadTransactionsDetail"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00"},"Risk": {}}
    When method post
    Then status 201
    * print response
    * def consentId = response.Data.ConsentId

  Scenario: US#02,Check without Risk
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadAccountsDetail","ReadBalances","ReadTransactionsDetail"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionFromDateTime": "2017-05-03T00:00:00+00:00","TransactionToDateTime": "2017-12-03T00:00:00+00:00"}}
    When method post
    Then status 400

  @tag=ConsentWithDetailpermissions
  Scenario: US#02,Check  create Consent only with ReadAccountsDetails permissions
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    * print Authorization
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadAccountsDetail"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionFromDateTime": "2017-05-03T00:00:00+00:00","TransactionToDateTime": "2017-12-03T00:00:00+00:00"},"Risk": {"description":"fdffds"}}
    When method post
    Then status 201
    And assert responseStatus == '201'
    * def Status = response.Data.Status
    And match Status == 'AwaitingAuthorisation'
    * def permission = response.Data.Permissions
    And match permission == ["ReadAccountsDetail"]

  @tag=ConsentWithReadBalances
  Scenario: US#02,Check  create Consent only with ReadBalances permissions
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    * print Authorization
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadBalances"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionFromDateTime": "2017-05-03T00:00:00+00:00","TransactionToDateTime": "2017-12-03T00:00:00+00:00"},"Risk": {"description":"fdffds"}}
    When method post
    Then status 400

  @tag=ConsentWithBasicPermissions
  Scenario: US#02,Check  create Consent only with ReadAccountsBasic permissions
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadAccountsBasic"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionFromDateTime": "2017-05-03T00:00:00+00:00","TransactionToDateTime": "2017-12-03T00:00:00+00:00"},"Risk": {"description":"fdffds"}}
    When method post
    Then status 201
    And assert responseStatus == '201'
    * def Status = response.Data.Status
    And match Status == 'AwaitingAuthorisation'
    * def permission = response.Data.Permissions
    And match permission == ["ReadAccountsBasic"]
    * print response
    * def consentId = response.Data.ConsentId

  @tag=ReadTransactionsBasic
  Scenario: US#02,Check to Create Consent only with ReadTransactionsBasic permissions
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadTransactionsBasic","ReadAccountsBasic"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionFromDateTime": "2017-05-03T00:00:00+00:00","TransactionToDateTime": "2017-12-03T00:00:00+00:00"},"Risk": {"description":"fdffds"}}
    When method post
    Then status 201
    And assert responseStatus == '201'
    * def Status = response.Data.Status
    And match Status == 'AwaitingAuthorisation'
    * def permission = response.Data.Permissions
    And match permission == ["ReadTransactionsBasic","ReadAccountsBasic"]
    * print response
    * def consentId = response.Data.ConsentId

  @tag=ReadTransactionsDetail
  Scenario: US#02,Check to Create Consent only with ReadTransactionsDetail permissions
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadTransactionsDetail"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionFromDateTime": "2017-05-03T00:00:00+00:00","TransactionToDateTime": "2017-12-03T00:00:00+00:00"},"Risk": {"description":"fdffds"}}
    When method post
    Then status 201
    And assert responseStatus == '201'
    * def Status = response.Data.Status
    And match Status == 'AwaitingAuthorisation'
    * def permission = response.Data.Permissions
    And match permission == ["ReadTransactionsDetail"]
    * print response
    * def consentId = response.Data.ConsentId

  Scenario: US#02,Check to Create Consent only with ReadTransactionsCredits permissions
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadTransactionsCredits"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionFromDateTime": "2017-05-03T00:00:00+00:00","TransactionToDateTime": "2017-12-03T00:00:00+00:00"},"Risk": {"description":"fdffds"}}
    When method post
    Then status 400

  @tag=ReadTransactionsCreditsWithBasic
  Scenario: US#02,Check to Create Consent with ReadTransactionsCredits and ReadTransactionsBasic permissions
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadTransactionsCredits","ReadTransactionsBasic"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionFromDateTime": "2017-05-03T00:00:00+00:00","TransactionToDateTime": "2017-12-03T00:00:00+00:00"},"Risk": {"description":"fdffds"}}
    When method post
    Then status 201
    And assert responseStatus == '201'
    * def Status = response.Data.Status
    And match Status == 'AwaitingAuthorisation'
    * def permission = response.Data.Permissions
    And match permission == ["ReadTransactionsCredits","ReadTransactionsBasic"]
    * print response
    * def consentId = response.Data.ConsentId

  @tag=ReadTransactionsCredits
  Scenario: US#02,Check to Create Consent with ReadTransactionsCredits and ReadTransactionsDetail permissions
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadTransactionsCredits","ReadTransactionsDetail"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionFromDateTime": "2017-05-03T00:00:00+00:00","TransactionToDateTime": "2017-12-03T00:00:00+00:00"},"Risk": {"description":"fdffds"}}
    When method post
    Then status 201
    And assert responseStatus == '201'
    * def Status = response.Data.Status
    And match Status == 'AwaitingAuthorisation'
    * def permission = response.Data.Permissions
    And match permission == ["ReadTransactionsCredits","ReadTransactionsDetail"]
    * print response
    * def consentId = response.Data.ConsentId

  Scenario: US#02,Check to Create Consent only with ReadTransactionsDebits permissions
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadTransactionsDebits"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionFromDateTime": "2017-05-03T00:00:00+00:00","TransactionToDateTime": "2017-12-03T00:00:00+00:00"},"Risk": {"description":"fdffds"}}
    When method post
    Then status 400

  @tag=ReadTransactionsDebits
  Scenario: US#02,Check to Create Consent with ReadTransactionsDebits and ReadTransactionsDetail permissions
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadTransactionsDebits","ReadTransactionsDetail"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionFromDateTime": "2017-05-03T00:00:00+00:00","TransactionToDateTime": "2017-12-03T00:00:00+00:00"},"Risk": {"description":"fdffds"}}
    When method post
    Then status 201
    And assert responseStatus == '201'
    * def Status = response.Data.Status
    And match Status == 'AwaitingAuthorisation'
    * def permission = response.Data.Permissions
    And match permission == ["ReadTransactionsDebits","ReadTransactionsDetail"]
    * print response
    * def consentId = response.Data.ConsentId

  @tag=ReadTransactionsDebitsWithBasic
  Scenario: US#02,Check to Create Consent with ReadTransactionsDebits and ReadTransactionsBasic permissions
    * def ConsentURL =  read('testdata/URL.json')
    * def ConsentHeaderAuth =  read('testdata/headers.json')
    Given url ConsentURL.CreateConsentUrl
    And header Authorization = "Bearer " + Token
    And header Content-Type = "application/json"
    And header x-fapi-financial-id = "open-bank"
    And request {"Data": {"Permissions": ["ReadTransactionsDebits","ReadTransactionsBasic"],"ExpirationDateTime": "2020-01-01T00:00:00+00:00","TransactionFromDateTime": "2017-05-03T00:00:00+00:00","TransactionToDateTime": "2017-12-03T00:00:00+00:00"},"Risk": {"description":"fdffds"}}
    When method post
    Then status 201
    And assert responseStatus == '201'
    * def Status = response.Data.Status
    And match Status == 'AwaitingAuthorisation'
    * def permission = response.Data.Permissions
    And match permission == ["ReadTransactionsDebits","ReadTransactionsBasic"]
    * print response
    * def consentId = response.Data.ConsentId