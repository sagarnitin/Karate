Feature: Testing of Accounts Details api

  Scenario: US#02,Check Accounts details with detail permissions
#    * def result = call read('UpdateConsent.feature@tag=AuthorisedDetailPermissions')
#    * def AccountId = result.AccountId1
    * def AccountDetailURL =  read('testdata/URL.json')
    Given url AccountDetailURL.AccountDetailsUrl
#   Then path AccountId
    Then path 13315
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    When method get
    Then status 200
    And match response.Data.Account.AccountId == AccountId

  Scenario Outline: US#02,check Accounts details <name> Authorization for Detail permissions
#    * def result = call read('UpdateConsent.feature@tag=AuthorisedDetailPermissions')
#    * def AccountId = result.AccountId1
    * def AccountDetailURL =  read('testdata/URL.json')
    Given url AccountDetailURL.AccountDetailsUrl
#    Then path AccountId
    Then path 13315
    And headers { Authorization: '<Authorization>' }
    When method get
    Then status 400

    Examples:
      |       Authorization          |    name                      |
      |   Basic YWRtaW4667848489     |with invalid                  |
      |   Basic YWRtaW4#$$^&@#^&     |with invalid special charaters|
      |   Basic hdjkdkkhyeuwdkkd     |with invalid charaters        |
      |                              |   with Null                  |

  Scenario: US#02,check Accounts details without Authorization for Detail permissions
#    * def result = call read('UpdateConsent.feature@tag=AuthorisedDetailPermissions')
#    * def AccountId = result.AccountId1
    * def AccountDetailURL =  read('testdata/URL.json')
    Given url AccountDetailURL.AccountDetailsUrl
    Then path 13315
#    Then path AccountId
    And header Content-Type = "application/json"
    When method get
    Then status 400

  Scenario Outline: US#02,Check Accounts details <name> AccountId for detail permissions
 #   * def result = call read('UpdateConsent.feature@tag=AuthorisedDetailPermissions')
    * def AccountDetailURL =  read('testdata/URL.json')
    Given url AccountDetailURL.AccountDetailsUrl
   Then path <AccountId>
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    When method get
    Then status 400

    Examples:
      |      AccountId    |    name                      |
      |   13315738833     |with invalid                  |
      |   13315#$%^&&     |with invalid special charaters|

  Scenario: US#02,Check Accounts details Api with detail permissions of Currency,AccountType and AccountSubType
#    * def result = call read('UpdateConsent.feature@tag=AuthorisedDetailPermissions')
#    * def AccountId = result.AccountId1
    * def AccountDetailURL =  read('testdata/URL.json')
    Given url AccountDetailURL.AccountDetailsUrl
    Then path 13315
#    Then path AccountId
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    When method get
    Then status 200
    And match response.Data.Account[*].AccountId contains ["#string"]
    And print response
    And match response.Data.Account[*].Currency contains ["USD"]
    And match response.Data.Account[*].AccountType contains ["Corporate"]
    And match response.Data.Account[*].AccountSubType contains ["Savings Account"]

  Scenario: US#02,Check Accounts details Api with detail permissions of SchemeName and Identification
#    * def result = call read('UpdateConsent.feature@tag=AuthorisedDetailPermissions')
#    * def AccountId = result.AccountId1
    * def AccountDetailURL =  read('testdata/URL.json')
    Given url AccountDetailURL.AccountDetailsUrl
    Then path 13315
#    Then path AccountId
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    When method get
    Then status 200
    And match response.Data.Account[*].Account[*].SecondaryIdentification contains ["#string"]
    And match response.Data.Account[*].Account[*].Name contains ["#string"]
    And match response.Data.Account[*].Account[*].SchemeName contains ["LEGACY"]
    And match response.Data.Account[*].Account[*].Identification contains ["#string"]

  Scenario: US#02,Check Accounts details Api with Basic permissions
    * def result = call read('UpdateConsent.feature@tag=AuthorisedWithBasicPermissions')
    * def AccountId = result.AccountId1
    * def AccountDetailURL =  read('testdata/URL.json')
    Given url AccountDetailURL.AccountDetailsUrl
    Then path AccountId
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    When method get
    Then status 200
    And match response.Data.Account.AccountId == AccountId

  Scenario Outline: US#02,check Accounts details Api <name> Authorization for Basic permissions
    * def result = call read('UpdateConsent.feature@tag=AuthorisedWithBasicPermissions')
    * def AccountId = result.AccountId1
    * def AccountDetailURL =  read('testdata/URL.json')
    Given url AccountDetailURL.AccountDetailsUrl
    Then path AccountId
    And headers { Authorization: '<Authorization>' }
    When method get
    Then status 400

    Examples:
      |       Authorization          |    name                      |
      |   Basic YWRtaW4667848489     |with invalid                  |
      |   Basic YWRtaW4#$$^&@#^&     |with invalid special charaters|
      |   Basic hdjkdkkhyeuwdkkd     |with invalid charaters        |
      |                              |   with Null                  |

  Scenario: US#02,check Accounts details Api without Authorization for Basic permissions
    * def result = call read('UpdateConsent.feature@tag=AuthorisedWithBasicPermissions')
    * def AccountId = result.AccountId1
    * def AccountDetailURL =  read('testdata/URL.json')
    Given url AccountDetailURL.AccountDetailsUrl
    Then path AccountId
    And header Content-Type = "application/json"
    When method get
    Then status 400

  Scenario Outline: US#02,Check Accounts details Api <name> AccountId for Basic permissions
    * def result = call read('UpdateConsent.feature@tag=AuthorisedWithBasicPermissions')
    * def AccountDetailURL =  read('testdata/URL.json')
    Given url AccountDetailURL.AccountDetailsUrl
    Then path <AccountId>
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    When method get
    Then status 400

    Examples:
      |      AccountId    |    name                      |
      |   13315738833     |with invalid                  |
      |   13315#$%^&&     |with invalid special charaters|
      |   13315DFGHUYDX   |with invalid charaters        |
      |                   |   withOut                    |

  Scenario: US#02,Check Accounts details Api with Basic permissions of Currency,AccountType and AccountSubType
    * def result = call read('UpdateConsent.feature@tag=AuthorisedWithBasicPermissions')
    * def AccountId = result.AccountId1
    * def AccountDetailURL =  read('testdata/URL.json')
    Given url AccountDetailURL.AccountDetailsUrl
    Then path AccountId
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    When method get
    Then status 200
    And match response.Data.Account[*].AccountId contains ["#string"]
    And match response.Data.Account[*].Currency contains ["USD","CHF","EUR"]
    And match response.Data.Account[*].AccountType contains ["Corporate"]
    And match response.Data.Account[*].AccountSubType contains ["Savings Account","Current Account"]

  Scenario: US#02,Check Accounts details Api with Basic permissions of SchemeName and Identification
    * def result = call read('UpdateConsent.feature@tag=AuthorisedWithBasicPermissions')
    * def AccountId = result.AccountId1
    * def AccountDetailURL =  read('testdata/URL.json')
    Given url AccountDetailURL.AccountDetailsUrl
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    When method get
    Then status 200
    And match response.Data.Account[*].Account[*].SecondaryIdentification contains ["#string"]
    And match response.Data.Account[*].Account[*].Name contains ["#string"]
    And match response.Data.Account[*].Account[*].SchemeName contains ["LEGACY"]
    And match response.Data.Account[*].Account[*].Identification contains ["#string"]

