Feature: Testing Accounts list api

  Scenario: US#02,Check Accounts with detail permissions
    * def result = call read('UpdateConsent.feature@tag=AuthorisedDetailPermissions')
    * def AccountId = result.AccountId1
    * def AccountURL =  read('testdata/URL.json')
    Given url AccountURL.GetAccountListUrl
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    When method get
    Then status 200
    And match response.Data.Account.AccountId == AccountId

  Scenario Outline: US#02,check <name> Authorization for Detail permissions
    * def result = call read('UpdateConsent.feature@tag=AuthorisedDetailPermissions')
    * def AccountId = result.AccountId1
    * def AccountURL =  read('testdata/URL.json')
    Given url AccountURL.GetAccountListUrl
    And headers { Authorization: '<Authorization>' }
    When method get
    Then status 400

    Examples:
      |       Authorization          |    name                      |
      |   Basic YWRtaW4667848489     |with invalid                  |
      |   Basic YWRtaW4#$$^&@#^&     |with invalid special charaters|
      |   Basic hdjkdkkhyeuwdkkd     |with invalid charaters        |
      |                              |   with Null                  |

  Scenario: US#02,check without Authorization for Detail permissions
    * def result = call read('UpdateConsent.feature@tag=AuthorisedDetailPermissions')
    * def AccountId = result.AccountId1
    * def AccountURL =  read('testdata/URL.json')
    Given url AccountURL.GetAccountListUrl
    And header Content-Type = "application/json"
    When method get
    Then status 400

  Scenario: US#02,Check Accounts detail permissions with Currency,AccountType and AccountSubType
#    * def result = call read('UpdateConsent.feature@tag=AuthorisedDetailPermissions')
#    * def AccountId = result.AccountId1
    * def AccountURL =  read('testdata/URL.json')
    Given url AccountURL.GetAccountListUrl
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    When method get
    Then status 200
    * print response
    And match response.Data.Account[*].AccountId contains ["#string"]
    And match response.Data.Account[*].Currency contains ["USD","CHF","EUR"]
    And match response.Data.Account[*].AccountType contains ["Corporate"]
    And match response.Data.Account[*].AccountSubType contains ["Savings Account","Current Account"]

  Scenario: US#02,Check Accounts detail permissions with SchemeName and Identification
#    * def result = call read('UpdateConsent.feature@tag=AuthorisedDetailPermissions')
#    * def AccountId = result.AccountId1
    * def AccountURL =  read('testdata/URL.json')
    Given url AccountURL.GetAccountListUrl
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    When method get
    Then status 200
    * print response
    And match response.Data.Account[*].Account[*].SecondaryIdentification contains ["#string"]
    And match response.Data.Account[*].Account[*].Name contains ["#string"]
    And match response.Data.Account[*].Account[*].SchemeName contains ["LEGACY"]
    And match response.Data.Account[*].Account[*].Identification contains ["#string"]

  Scenario Outline: US#02,check <name> x-fapi-financial-id for detail Permissions
    * def result = call read('UpdateConsent.feature@tag=AuthorisedDetailPermissions')
    * def AccountId = result.AccountId1
    * def AccountURL =  read('testdata/URL.json')
    Given url AccountURL.GetAccountListUrl
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    And headers { x-fapi-financial-id: '<x-fapi-financial-id>' }
    When method get
    Then status 200

    Examples:
      |x-fapi-financial-id|    name                                  |
      |  open-bank344     |with invalid numebrs                      |
      |open-bank$%^sjjd   |with invalid special charaters            |
      |open-bankghd       |with invalid charaters                    |
      |                   |   without                                |

  Scenario: US#02,Check Accounts with Basic permissions
    * def result = call read('UpdateConsent.feature@tag=AuthorisedWithBasicPermissions')
    * def AccountId = result.AccountId1
    * def AccountURL =  read('testdata/URL.json')
    Given url AccountURL.GetAccountListUrl
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    When method get
    Then status 200
    And match response.Data.Account.AccountId == AccountId

  Scenario Outline: US#02,check <name> Authorization for Basic permissions
    * def result = call read('UpdateConsent.feature@tag=AuthorisedWithBasicPermissions')
    * def AccountId = result.AccountId1
    * def AccountURL =  read('testdata/URL.json')
    Given url AccountURL.GetAccountListUrl
    And headers { Authorization: '<Authorization>' }
    When method get
    Then status 400

    Examples:
      |       Authorization          |    name                      |
      |   Basic YWRtaW4667848489     |with invalid                  |
      |   Basic YWRtaW4#$$^&@#^&     |with invalid special charaters|
      |   Basic hdjkdkkhyeuwdkkd     |with invalid charaters        |
      |                              |   with Null                  |

  Scenario: US#02,check without Authorization for Basic permissions
    * def result = call read('UpdateConsent.feature@tag=AuthorisedWithBasicPermissions')
    * def AccountId = result.AccountId1
    * def AccountURL =  read('testdata/URL.json')
    Given url AccountURL.GetAccountListUrl
    And header Content-Type = "application/json"
    When method get
    Then status 400

  Scenario Outline: US#02,check <name> x-fapi-financial-id for Basic Permissions
    * def result = call read('UpdateConsent.feature@tag=AuthorisedWithBasicPermissions')
    * def AccountId = result.AccountId1
    * def AccountURL =  read('testdata/URL.json')
    Given url AccountURL.GetAccountListUrl
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    And headers { x-fapi-financial-id: '<x-fapi-financial-id>' }
    When method get
    Then status 200

    Examples:
      |x-fapi-financial-id|    name                                  |
      |  open-bank344     |with invalid numebrs                      |
      |open-bank$%^sjjd   |with invalid special charaters            |
      |open-bankghd       |with invalid charaters                    |
      |                   |   without                                |

  Scenario: US#02,Check Accounts Basic permissions with Currency,AccountType and AccountSubType
#   * def result = call read('UpdateConsent.feature@tag=AuthorisedWithBasicPermissions')
#   * def AccountId = result.AccountId1
    * def AccountURL =  read('testdata/URL.json')
    Given url AccountURL.GetAccountListUrl
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    When method get
    Then status 200
    * print response
    And match response.Data.Account[*].AccountId contains ["#string"]
    And match response.Data.Account[*].Currency contains ["USD","CHF","EUR"]
    And match response.Data.Account[*].AccountType contains ["Corporate"]
    And match response.Data.Account[*].AccountSubType contains ["Savings Account","Current Account"]

