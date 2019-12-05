@AccountDetail @all

Feature: Testing of Accounts Details api

 Background:
   * configure ssl = true
   * def AccountDetailURL =  read('testdata/URL.json')
   * def Accountheader =  read('testdata/headers.json')
   * url AccountDetailURL['AccountDetailsUrl/T24']

  @Sanity
  Scenario: US#15,Check Accounts details with detail permissions
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    Then path Accountheader.AccountsId1
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And match response.Data.Account[0].AccountId == Accountheader.AccountsId1

  Scenario Outline: US#15,check Accounts details <name> Authorization for Detail permissions
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    Then path Accountheader.AccountsId1
    And headers { Authorization: '<Authorization>' }
    When method get
    Then status 401

    Examples:
      |       Authorization          |    name                      |
      |   Basic YWRtaW4667848489     |with invalid                  |
      |   Basic YWRtaW4#$$^&@#^&     |with invalid special charaters|
      |   Basic hdjkdkkhyeuwdkkd     |with invalid charaters        |
      |                              |   with Null                  |

  Scenario: US#15,check Accounts details without Authorization for Detail permissions
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    Then path Accountheader.AccountsId1
    And header Content-Type = "application/json"
    When method get
    Then status 401

  Scenario Outline: US#15,Check Accounts details <name> AccountId for detail permissions
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    Then path AccountNo
    And header Authorization = "Bearer " + Token
    When method get
    Then status 400
    * print response
    And match response.Code == "Bad Request"
#    And match response.Message == ["#string"]
    And match response.Errors[*].ErrorCode contains any ["UK.OBIE.Field.Expected","UK.OBIE.Field.Invalid","UK.OBIE.Field.InvalidDate","UK.OBIE.Field.Missing","UK.OBIE.Field.Unexpected","UK.OBIE.Header.Invalid","UK.OBIE.Header.Missing","UK.OBIE.Reauthenticate","UK.OBIE.Resource.ConsentMismatch","UK.OBIE.Resource.InvalidConsentStatus","UK.OBIE.Resource.InvalidFormat","UK.OBIE.Resource.NotFound","UK.OBIE.Rules.AfterCutOffDateTime","UK.OBIE.Rules.DuplicateReference","UK.OBIE.Signature.Invalid","UK.OBIE.Signature.InvalidClaim", "UK.OBIE.Signature.Malformed", "UK.OBIE.Signature.Missing", "UK.OBIE.Signature.MissingClaim", "UK.OBIE.Signature.Unexpected", "UK.OBIE.UnexpectedError", "UK.OBIE.Unsupported.AccountIdentifier", "UK.OBIE.Unsupported.AccountSecondaryIdentifier", "UK.OBIE.Unsupported.Currency", "UK.OBIE.Unsupported.Frequency", "UK.OBIE.Unsupported.LocalInstrument", "UK.OBIE.Unsupported.Scheme"]
    And match response.Errors[0].Message == "Provided account number is Invalid"


    Examples:
      |      AccountNo    |    name                      |
      |   13315738833     |with invalid                  |
#      |   13315GFDYJK     |with invalid special charaters|

  Scenario: US#15,Check Accounts details Api with detail permissions of Currency,AccountType and AccountSubType
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    Then path Accountheader.AccountsId1
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And match response.Data.Account[0].AccountId contains "#string"
    And print response
    And match response.Data.Account[0].Currency == "#regex[A-Z]{3}"
    And match response.Data.Account[*].AccountType contains any ["Business","Personal"]
    And match response.Data.Account[*].AccountSubType contains any ["ChargeCard","CreditCard","CurrentAccount","EMoney","Loan","Mortgage","PrePaidCard","Savings"]

  Scenario: US#15,Check Accounts details Api with detail permissions of SchemeName and Identification
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    Then path Accountheader.AccountsId1
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

  @Sanity
  Scenario: US#15,Check Accounts details Api with Basic permissions
    * def result = call read('CreateAccessToken.feature@tag=BasicConsentAuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    Then path Accountheader.AccountsId1
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And match response.Data.Account[0].AccountId == Accountheader.AccountsId1

  Scenario Outline: US#15,check Accounts details Api <name> Authorization for Basic permissions
    * def result = call read('CreateAccessToken.feature@tag=BasicConsentAuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    Then path Accountheader.AccountsId1
    Then path Accountheader.AccountsId1
    And headers { Authorization: '<Authorization>' }
    When method get
    Then status 404

    Examples:
      |       Authorization          |    name                      |
      |   Basic YWRtaW4667848489     |with invalid                  |
      |   Basic YWRtaW4#$$^&@#^&     |with invalid special charaters|
      |   Basic hdjkdkkhyeuwdkkd     |with invalid charaters        |
      |                              |   with Null                  |

  Scenario: US#15,check Accounts details Api without Authorization for Basic permissions
    * def result = call read('CreateAccessToken.feature@tag=BasicConsentAuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    Then path Accountheader.AccountsId1
    And header Content-Type = "application/json"
    When method get
    Then status 401

  Scenario Outline: US#15,Check Accounts details Api <name> AccountId for Basic permissions
    * def result = call read('CreateAccessToken.feature@tag=BasicConsentAuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    Then path AccountNo
    And header Authorization = "Bearer " + Token
    When method get
    Then status 400

    Examples:
      |      AccountNo    |    name                      |
      |   13315738833     |with invalid                  |
      |   13315DFGHUYDX   |with invalid charaters        |

  Scenario: US#15,Check Accounts details Api with Basic permissions of Currency,AccountType and AccountSubType
    * def result = call read('CreateAccessToken.feature@tag=BasicConsentAuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    Then path Accountheader.AccountsId1
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * print response
    And match response.Data.Account[*].AccountId contains ["#string"]
    And match response.Data.Account[*].Currency == ["#regex[A-Z]{3}"]
    And match response.Data.Account[*].AccountType contains any ["Business","Personal"]
    And match response.Data.Account[*].AccountSubType contains any ["Savings","CurrentAccount","ChargeCard,"CreditCard"]

  Scenario: US#15,Check Accounts details Api response with Basic permissions
    * def result = call read('CreateAccessToken.feature@tag=BasicConsentAuthorizationToken')
    * def AccountURL =  read('testdata/URL.json')
    * def Token = result.Token
    Then path Accountheader.AccountsId1
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * print response
    And match response ==
    """
    {
    "Data": {
        "Account": [
            {
                "AccountId": "#string",
                "Status": "#string",
                "StatusUpdateDateTime": "#string",
                "Currency": "#string",
                "AccountType": "#string",
                "AccountSubType": "#string",
                "Nickname": "",
                "Description": ""
            }
        ]
    },
    "Meta": {
        "TotalPages": 1
    },
    "Links": {
        "Self": "#ignore",
        "First": "",
        "Prev": "",
        "Next": "",
        "Last": ""
    }
}
    """

