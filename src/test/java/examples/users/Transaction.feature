@AccountTransaction

Feature: Testing of Transaction Account api

  Background:
    * configure ssl = true
    * def TransactionUrl =  read('testdata/URL.json')
    * def Transactiondata =  read('testdata/headers.json')
    * url TransactionUrl['AccountTransactionUrl/T24']

  @Sanity
  Scenario: US#20,Check Transaction Api with Mandatory Authorisation
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param fromBookingDateTime = Transactiondata.TransactionfromBookingDateTime
    And param toBookingDateTime =  Transactiondata.TransactiontoBookingDateTime
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * print response
    And match response.Data.Transactions[0].AccountId == Transactiondata.AccountsId1

  Scenario Outline: US#20,check Transaction Api <name> Authorization
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param fromBookingDateTime = Transactiondata.TransactionfromBookingDateTime
    And param toBookingDateTime =  Transactiondata.TransactiontoBookingDateTime
    And headers { Authorization: '<Authorization>' }
    When method get
    Then status 401

    Examples:
      |       Authorization          |    name                      |
      |   Basic YWRtaW4667848489     |with invalid                  |
      |   Basic YWRtaW4#$$^&@#^&     |with invalid special charaters|
      |   Basic hdjkdkkhyeuwdkkd     |with invalid charaters        |
      |                              |   with Null                  |

  Scenario: US#20,check Transaction Api without Authorization
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param fromBookingDateTime = Transactiondata.TransactionfromBookingDateTime
    And param toBookingDateTime =  Transactiondata.TransactiontoBookingDateTime
    And header Content-Type = "application/json"
    When method get
    Then status 401

  Scenario: US#20,check Transaction Api without fromBookingDateTime and without passing any dates in consent
    * def result = call read('CreateAccessToken.feature@tag=ConsentAuthorisedWithOutTransactionDateTime')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param toBookingDateTime =  "2014-04-08T00:00:00"
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * print response
    And match response.Data.Transactions[0].AccountId == Transactiondata.AccountsId1

  Scenario: US#20,check Transaction Api without toBookingDateTime and without passing any dates in consent
    * def result = call read('CreateAccessToken.feature@tag=ConsentAuthorisedWithOutTransactionDateTime')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param fromBookingDateTime = Transactiondata.TransactionfromBookingDateTime
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And match response.Data.Transactions[0].AccountId == Transactiondata.AccountsId1
#    And match response.Data.Transactions == []

  Scenario: US#20,check Transaction Api without toBookingDateTime and fromBookingDateTime and without passing any dates in consent
    * def result = call read('CreateAccessToken.feature@tag=ConsentAuthorisedWithOutTransactionDateTime')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * print response
#   And match response.Data.Transactions[0].AccountId == Transactiondata.AccountsId1
    And match response.Data.Transactions == []

  Scenario: US#20,check with only fromBookingDateTime in Transaction Api and with toBookingDateTime in consent
    * def result = call read('CreateAccessToken.feature@tag=ReadTransactionsWithOutTransactionFromDateTime')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param fromBookingDateTime = Transactiondata.TransactionfromBookingDateTime
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And match response.Data.Transactions[0].AccountId == Transactiondata.AccountsId1

  Scenario: US#20,check with only toBookingDateTime in Transaction Api and with fromBookingDateTime in consent
    * def result = call read('CreateAccessToken.feature@tag=ReadTransactionsWithOutTransactionToDateTime')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param toBookingDateTime =  Transactiondata.TransactiontoBookingDateTime
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And match response.Data.Transactions[0].AccountId == Transactiondata.AccountsId1

  Scenario: US#20,check with only toBookingDateTime in Transaction Api and with toBookingDateTime in consent
    * def result = call read('CreateAccessToken.feature@tag=ReadTransactionsWithOutTransactionFromDateTime')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param toBookingDateTime =  Transactiondata.TransactiontoBookingDateTime
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And match response.Data.Transactions[0].AccountId == Transactiondata.AccountsId1

  Scenario: US#20,check with only fromBookingDateTime in Transaction Api and with FromBookingDateTime in consent
    * def result = call read('CreateAccessToken.feature@tag=ReadTransactionsWithOutTransactionToDateTime')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param fromBookingDateTime = Transactiondata.TransactionfromBookingDateTime
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And match response.Data.Transactions[0].AccountId == Transactiondata.AccountsId1

  Scenario: US#20,check withOut any dates in Transaction Api and with fromBookingDateTime in consent
    * def result = call read('CreateAccessToken.feature@tag=ReadTransactionsWithOutTransactionToDateTime')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And match response.Data.Transactions[0].AccountId == Transactiondata.AccountsId1

  Scenario: US#20,check withOut any dates in Transaction Api and with toBookingDateTime in consent
    * def result = call read('CreateAccessToken.feature@tag=ReadTransactionsWithOutTransactionFromDateTime')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And match response.Data.Transactions[0].AccountId == Transactiondata.AccountsId1

  Scenario: US#20,check without toBookingDateTime and fromBookingDateTime in Transaction Api and with passing both the dates in consent
    * def result = call read('CreateAccessToken.feature@tag=ConsentAuthorisedWithBothTransactionDateTime')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * print response
#   And match response.Data.Transactions[0].AccountId == Transactiondata.AccountsId1
    And match response.Data.Transactions == []

  Scenario: US#20,check with toBookingDateTime and fromBookingDateTime in Transaction Api and withOut any dates in Consent
    * def result = call read('CreateAccessToken.feature@tag=ConsentAuthorisedWithOutTransactionDateTime')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param fromBookingDateTime = Transactiondata.TransactionfromBookingDateTime
    And param toBookingDateTime =  Transactiondata.TransactiontoBookingDateTime
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * print response
#   And match response.Data.Transactions[0].AccountId == Transactiondata.AccountsId1
    And match response.Data.Transactions == []

  Scenario: US#20,check with toBookingDateTime and fromBookingDateTime in Transaction Api and with passing both the dates in consent
    * def result = call read('CreateAccessToken.feature@tag=ConsentAuthorisedWithBothTransactionDateTime')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param fromBookingDateTime = Transactiondata.TransactionfromBookingDateTime
    And param toBookingDateTime =  Transactiondata.TransactiontoBookingDateTime
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * print response
#   And match response.Data.Transactions[0].AccountId == Transactiondata.AccountsId1
    And match response.Data.Transactions == []

  Scenario Outline: US#20,check Transaction Api with Transaction period more than 6+ months
    * def result = call read('CreateAccessToken.feature@tag=ConsentAuthorisedWithOutTransactionDateTime')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param fromBookingDateTime = fromBookingDateTime
    And param toBookingDateTime =  toBookingDateTime
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And match response.Data.Transactions == []
    And match response.Data.Transactions[0].AccountId == Transactiondata.AccountsId1

    Examples:
      |     fromBookingDateTime    |    toBookingDateTime     |
      |    2014-01-22T04:28:12     |   2014-07-24T04:28:12    |
      |    2014-04-22T04:28:12     |   2014-11-24T04:28:12    |
      |    2014-11-22T04:28:12     |   2015-06-24T04:28:12    |

  Scenario Outline: US#20,check Transaction Api <name> AccountId
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def Token = result.Token
    * print Token
    Given path AccountsId + '/transactions'
    And param fromBookingDateTime = Transactiondata.TransactionfromBookingDateTime
    And param toBookingDateTime =  Transactiondata.TransactiontoBookingDateTime
    And header Authorization = "Bearer " + Token
    When method get
    Then status 400

    Examples:
      |AccountsId|   name              |
      |  13314   |with invalid         |
      |  13749   |with invalid         |
      |  13DGH   |with invalid charaters|

  Scenario: US#20,check Transaction Api without AccountId
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def Token = result.Token
    * print Token
    Given path '/transactions'
    And param fromBookingDateTime = Transactiondata.TransactionfromBookingDateTime
    And param toBookingDateTime =  Transactiondata.TransactiontoBookingDateTime
    And header Authorization = "Bearer " + Token
    When method get
    Then status 404
#    And match response.error == "Not Found"

  Scenario: US#20,Check Transaction Api with Mandatory response parameters
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param fromBookingDateTime = Transactiondata.TransactionfromBookingDateTime
    And param toBookingDateTime =  Transactiondata.TransactiontoBookingDateTime
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And match response.Data.Transactions[0].AccountId == '#ignore'
    And match response.Data.Transactions[0].CreditDebitIndicator == 'CREDIT'
    And match response.Data.Transactions[0].Status == 'Enabled'
    And match response.Data.Transactions[0].BookingDateTime == '#string'
    And match response.Data.Transactions[0].Amount ==
    """
    {
       "Amount": "#ignore",
       "Currency": "#ignore"
    }
    """
    And match response.Data.Transactions[0].ChargeAmount ==
    """
 {
  "Amount": {
    "Amount": "#ignore",
    "Currency": "#ignore"
  }
}
    """

  Scenario: US#20,Check Transaction Api with proper response parameters
    * def result = call read('CreateAccessToken.feature@tag=AuthorizationToken')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param fromBookingDateTime = Transactiondata.TransactionfromBookingDateTime
    And param toBookingDateTime =  Transactiondata.TransactiontoBookingDateTime
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    And match response.Data.Transactions[0].CurrencyExchange.SourceCurrency == '#ignore'
    And match response.Data.Transactions[0].CurrencyExchange.ExchangeRate == '#ignore'
    And match response.Data.Transactions[0].CurrencyExchange.InstructedAmount ==
    """
    {
    "Amount": "#ignore",
    "Currency": "#string"
}
    """

  Scenario: US#20,Check Transaction Api with ReadTransactionsBasic Permissions
    * def result = call read('CreateAccessToken.feature@tag=ReadTransactionsBasicAuthorizationToken')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param fromBookingDateTime = Transactiondata.TransactionfromBookingDateTime
    And param toBookingDateTime =  Transactiondata.TransactiontoBookingDateTime
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * print response
    * def Amount = response.Data.Transactions[0].Amount.Amount
    * def store = response.Data.Transactions[0].CreditDebitIndicator
    * print store
    And assert  response.Data.Transactions[0].Amount.Amount <= [0]
    * def result = response.Data.Transactions[0].Amount.Amount <= [0]

  Scenario: US#20,Check Transaction Api with ReadTransactionsDetail Permissions
    * def result = call read('CreateAccessToken.feature@tag=ReadTransactionsDetailAuthorizationToken')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param fromBookingDateTime = Transactiondata.TransactionfromBookingDateTime
    And param toBookingDateTime =  Transactiondata.TransactiontoBookingDateTime
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * print response

  Scenario: US#20,Check Transaction Api with ReadTransactionsCredits Permissions
    * def result = call read('CreateAccessToken.feature@tag=ReadTransactionsCreditsAuthorizationToken')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param fromBookingDateTime = Transactiondata.TransactionfromBookingDateTime
    And param toBookingDateTime =  Transactiondata.TransactiontoBookingDateTime
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * print response

  Scenario: US#20,Check Transaction Api with ReadTransactionsDebits Permissions
    * def result = call read('CreateAccessToken.feature@tag=ReadTransactionsDebitsAuthorizationToken')
    * def Token = result.Token
    * print Token
    Given path Transactiondata.AccountsId1 +'/transactions'
    And param fromBookingDateTime = Transactiondata.TransactionfromBookingDateTime
    And param toBookingDateTime =  Transactiondata.TransactiontoBookingDateTime
    And header Authorization = "Bearer " + Token
    When method get
    Then status 200
    * print response










