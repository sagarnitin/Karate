@AccountGetBalances @all
Feature: Testing of Get Balances api

  Background:
    * configure ssl = true
    * def Utils = Java.type('com.bitsy.customjavacode.Utils')

  @Sanity
  Scenario: US#21,Check Balances Api with Mandatory Authorisation
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def BalancesURL =  read('testdata/URL.json')
    * def Token = result.Token
    * print Token
    Given url BalancesURL.GetBalancesUrl
    Then path "13315/balances"
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * print response
    And match response.Data.Balance[*].AccountId == ['13315']

  Scenario Outline: US#21,check Balances Api <name> Authorization
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def BalancesURL =  read('testdata/URL.json')
    Given url BalancesURL.GetBalancesUrl
    Then path "13315/balances"
    And headers { Authorization: '<Authorization>' }
    When method get
    Then status 401

    Examples:
      |       Authorization          |    name                      |
      |   Basic YWRtaW4667848489     |with invalid                  |
      |   Basic YWRtaW4#$$^&@#^&     |with invalid special charaters|
      |   Basic hdjkdkkhyeuwdkkd     |with invalid charaters        |
      |                              |   with Null                  |

  Scenario: US#21,check Balances Api without Authorization
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def BalancesURL =  read('testdata/URL.json')
    Given url BalancesURL.GetBalancesUrl
    Then path "13315/balances"
    And header Content-Type = "application/json"
    When method get
    Then status 401

  Scenario Outline: US#21,Check Balances Api <name> AccountId
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def BalancesURL =  read('testdata/URL.json')
    * def Token = result.Token
    * print Token
    Given url BalancesURL.GetBalancesUrl
    Then path AccountId
    And header Authorization = "Bearer " + Token
    When method get
    Then status 400
    * print response

    Examples:
      |   AccountId         |    name                      |
      |133173/balances      |with invalid                  |
      |13315DRRGHJ/balances |with invalid special charaters|

  Scenario: US#21,Check Balances Api without AccountId
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def BalancesURL =  read('testdata/URL.json')
    * def Token = result.Token
    * print Token
    Given url BalancesURL.GetBalancesUrl
    Then path "balances"
    And header Authorization = "Bearer " + Token
    When method get
    Then status 404
    * print response

  Scenario: US#21,Check Balances Api response AccountId, type and DateTime
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def BalancesURL =  read('testdata/URL.json')
    * def Token = result.Token
    * print Token
    Given url BalancesURL.GetBalancesUrl
    Then path "13315/balances"
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And assert responseStatus == '200'
    And match response.Data.Balance[0].AccountId == '13315'
    And match response.Data.Balance[*].Type contains any ["ClosingAvailable","ClosingBooked","ClosingCleared","Expected","ForwardAvailable","Information","InterimAvailable","InterimBooked","InterimCleared","OpeningAvailable","OpeningBooked","OpeningCleared","PreviouslyClosedBooked"]
    And match response.Data.Balance[0].DateTime == "#string"

  Scenario: US#21,Check Balances Api response Amount and Currency
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def BalancesURL =  read('testdata/URL.json')
    * def Token = result.Token
    * print Token
    Given url BalancesURL.GetBalancesUrl
    Then path "13315/balances"
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And assert responseStatus == '200'
    And match response.Data.Balance[*].AccountId == ['13315']
    And match response.Data.Balance[*].Type == ["OpeningCleared"]
    And match response.Data.Balance[0].CreditLine[0].Amount.Amount == ""
    And match response.Data.Balance[0].CreditLine[0] ==
    """
   {
     "Included": "#boolean",
      "Amount": {
      "Amount": "",
      "Currency": ""
    },
      "Type": ""
    }
    """

  Scenario: US#21,Check Balances Api with CreditDebitIndicator
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def BalancesURL =  read('testdata/URL.json')
    * def Token = result.Token
    * print Token
    Given url BalancesURL.GetBalancesUrl
    Then path "13315/balances"
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And assert responseStatus == '200'
    * def Amount = response.Data.Balance[0].Amount.Amount
    And def Indicator = Utils.CreditDebitIndicator(Amount)
    And match response.Data.Balance[0].CreditDebitIndicator == Indicator
