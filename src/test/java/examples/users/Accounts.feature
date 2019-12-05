@all

Feature: Testing Accounts list api

  Background:
    * configure ssl = true

  @Sanity
  Scenario: US#19,Check Accounts with detail permissions
   * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    * print Token
    Given url AccountURL.GetAccountListUrl
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * print response
    And match response.Data.Account[0].AccountId == "13315"

  Scenario Outline: US#19,check <name> Authorization for Detail permissions
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    * print Token
    Given url AccountURL.GetAccountListUrl
    And headers { Authorization: '<Authorization>' }
    When method get
    Then status 401

    Examples:
      |       Authorization          |    name                      |
      |   Basic YWRtaW4667848489     |with invalid                  |
      |   Basic YWRtaW4#$$^&@#^&     |with invalid special charaters|
      |   Basic hdjkdkkhyeuwdkkd     |with invalid charaters        |
      |                              |   with Null                  |

  Scenario: US#19,check without Authorization for Detail permissions
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    * print Token
    Given url AccountURL.GetAccountListUrl
    And header Content-Type = "application/json"
    When method get
    Then status 401
    * print response

  Scenario: US#19,Check Accounts detail permissions with Currency,AccountType and AccountSubType
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    * print Token
    Given url AccountURL.GetAccountListUrl
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And match response.Data.Account[0].AccountId contains "#string"
    And match response.Data.Account[0].Currency == "#regex[A-Z]{3}"
    And match response.Data.Account[*].AccountType contains any ["Business","Personal"]
    And match response.Data.Account[*].AccountSubType contains any ["ChargeCard","CreditCard","CurrentAccount","EMoney","Loan","Mortgage","PrePaidCard","Savings"]

  Scenario: US#19,Check Accounts detail permissions with SchemeName and Identification
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    * print Token
    Given url AccountURL.GetAccountListUrl
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And match response.Data.Account[*].Account[*].SchemeName contains any ["UK.OBIE.BBAN", "UK.OBIE.IBAN", "UK.OBIE.PAN", "UK.OBIE.Paym", "UK.OBIE.SortCodeAccountNumber"]
    And match response.Data.Account[*].Account[*].Identification contains ["#string"]
    And match response.Data.Account[0].Servicer ==
    """
  [
  {
    "Identification": "",
    "SchemeName": ""
  }
]
    """

  Scenario Outline: US#19,check <name> x-fapi-financial-id for detail Permissions
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    * print Token
    Given url AccountURL.GetAccountListUrl
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = "Bearer " + Token
    And headers { x-fapi-financial-id: '<x-fapi-financial-id>' }
    When method get
    Then status 200

    Examples:
      |x-fapi-financial-id|    name                                  |
      |  open-bank344     |with invalid numebrs                      |
      |open-bank$%^sjjd   |with invalid special charaters            |
      |open-bankghd       |with invalid charaters                    |
      |                   |   without                                |

  @Sanity
  Scenario: US#19,Check Accounts with Basic permissions
    * def result = call read('CreateAccessToken.feature@tag=BasicConsentAuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    Given url AccountURL.GetAccountListUrl
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And match response.Data.Account[0].AccountId == "13315"

  Scenario Outline: US#19,check <name> Authorization for Basic permissions
    * def result = call read('CreateAccessToken.feature@tag=BasicConsentAuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    Given url AccountURL.GetAccountListUrl
    And headers { Authorization: '<Authorization>' }
    When method get
    Then status 401

    Examples:
      |       Authorization          |    name                      |
      |   Basic YWRtaW4667848489     |with invalid                  |
      |   Basic YWRtaW4#$$^&@#^&     |with invalid special charaters|
      |   Basic hdjkdkkhyeuwdkkd     |with invalid charaters        |
      |                              |   with Null                  |

  Scenario: US#19,check without Authorization for Basic permissions
    * def result = call read('CreateAccessToken.feature@tag=BasicConsentAuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    Given url AccountURL.GetAccountListUrl
    And header Content-Type = "application/json"
    When method get
    Then status 401

  Scenario Outline: US#19,check <name> x-fapi-financial-id for Basic Permissions
    * def result = call read('CreateAccessToken.feature@tag=BasicConsentAuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    Given url AccountURL.GetAccountListUrl
    And header Authorization = "Bearer " + Token
    And headers { x-fapi-financial-id: '<x-fapi-financial-id>' }
    When method get
    Then status 200

    Examples:
      |x-fapi-financial-id|    name                                  |
      |  open-bank344     |with invalid numebrs                      |
      |open-bank$%^sjjd   |with invalid special charaters            |
      |open-bankghd       |with invalid charaters                    |
      |                   |   without                                |

  Scenario: US#19,Check Accounts Basic permissions with Currency,AccountType and AccountSubType
    * def result = call read('CreateAccessToken.feature@tag=BasicConsentAuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    Given url AccountURL.GetAccountListUrl
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * print response
    And match response.Data.Account[0].AccountId == "#string"
    And match response.Data.Account[0].Currency == "#regex[A-Z]{3}"
    And match response.Data.Account[*].AccountType contains any ["Business","Personal"]
    And match response.Data.Account[*].AccountSubType contains any ["Savings","CurrentAccount","ChargeCard,"CreditCard"]

