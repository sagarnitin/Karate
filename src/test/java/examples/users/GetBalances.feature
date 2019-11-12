Feature: Testing of Get Balances api

  Scenario: US#02,Check Balances Api with Mandatory Authorisation
#    * def result = call read('UpdateConsent.feature@tag=ConsentAuthorised')
#    * def AccountId = result.AccountId1
    * def BalancesURL =  read('testdata/URL.json')
    Given url BalancesURL.GetBalancesUrl
    Then path "13315/balances"
#    Then path AccountId
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    When method get
    Then status 200
    And match response.Data.Balance[*].AccountId == ['13315']

  Scenario Outline: US#02,check Balances Api <name> Authorization
#    * def result = call read('UpdateConsent.feature@tag=AuthorisedDetailPermissions')
#    * def AccountId = result.AccountId1
    * def BalancesURL =  read('testdata/URL.json')
    Given url BalancesURL.GetBalancesUrl
    Then path "13315/balances"
#    Then path AccountId
    And headers { Authorization: '<Authorization>' }
    When method get
    Then status 400

    Examples:
      |       Authorization          |    name                      |
      |   Basic YWRtaW4667848489     |with invalid                  |
      |   Basic YWRtaW4#$$^&@#^&     |with invalid special charaters|
      |   Basic hdjkdkkhyeuwdkkd     |with invalid charaters        |
      |                              |   with Null                  |

  Scenario: US#02,check Balances Api without Authorization
#    * def result = call read('UpdateConsent.feature@tag=AuthorisedDetailPermissions')
#    * def AccountId = result.AccountId1
    * def BalancesURL =  read('testdata/URL.json')
    Given url BalancesURL.GetBalancesUrl
    Then path "13315/balances"
#    Then path AccountId
    And header Content-Type = "application/json"
    When method get
    Then status 400

  Scenario Outline: US#02,Check Balances Api <name> AccountId
 #  * def result = call read('UpdateConsent.feature@tag=AuthorisedDetailPermissions')
    * def BalancesURL =  read('testdata/URL.json')
    Given url BalancesURL.GetBalancesUrl
    Then path AccountId
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    When method get
    Then status 400

    Examples:
      |   AccountId         |    name                      |
      |133173/balances      |with invalid                  |
      |13315#$%^&&/balances |with invalid special charaters|
      |13315DRRGHJ/balances |with invalid special charaters|

  Scenario: US#02,Check Balances Api without AccountId
 #  * def result = call read('UpdateConsent.feature@tag=AuthorisedDetailPermissions')
    * def BalancesURL =  read('testdata/URL.json')
    Given url BalancesURL.GetBalancesUrl
    Then path "balances"
    * def AccountHeaderAuth =  read('testdata/headers.json')
    And header Authorization = AccountHeaderAuth.AccountAuth
    When method get
    Then status 400

  Scenario: US#02,Check Balances Api with CreditDebitIndicator
#    * def result = call read('UpdateConsent.feature@tag=ConsentAuthorised')
#    * def AccountId = result.AccountId1
    * def BalancesURL =  read('testdata/URL.json')
    * def AccountHeaderAuth =  read('testdata/headers.json')
    Given url BalancesURL.GetBalancesUrl
    Then path AccountHeaderAuth.AccountsId1 + '/balances'
#    Then path "13315/balances"
#    Then path AccountId
    And header Authorization = AccountHeaderAuth.AccountAuth
    When method get
    Then status 200
    And assert responseStatus == '200'
    And assert response.Data.Balance[0].Amount.Amount >= ['0']
    * def CreditDebitIndicator =  response.Data.Balance[0].CreditDebitIndicator
    And  match CreditDebitIndicator == "CREDIT"
    And if response.Data.Balance[0].Amount.Amount >= ['0'] then match CreditDebitIndicator == "DEBIT"
    Then match CreditDebitIndicator == "CREDIT"
    And if response.Data.Balance[0].Amount.Amount <= ['0']
    Then match CreditDebitIndicator == "DEBIT"

    And match response ==
  """
  {
  "Data": {
  "Balance": [
  {
  "AccountId": "#number'",
  "Amount": {
  "Amount": "52945.78",
  "Currency": "USD"
  },
  "CreditDebitIndicator": "CREDIT",
  "Type": "WORKING.BALANCE",
  "DateTime": "#ignore",
  "CreditLine": [
  {
  "Included": true,
  "Amount": {
  "Amount": "",
  "Currency": ""
  },
  "Type": ""
  }
  ]
  }
  ]
  },
  "Links": {
  "Self": "#ignore"
  },
  "Risk": #ignore,
  "Meta": {
  "TotalPages": 1
  }
  }
"""
