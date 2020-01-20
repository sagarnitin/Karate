@CreateAccessTokenAndAuthorization @NotRun

Feature: Create access token for accounts,balance and transactions

  Background:
    * configure ssl = true
    * def Utils = Java.type('com.bitsy.customjavacode.Utils')
    * def jsonRequestObjectToBeEncoded = read('testdata/Base64Encoder.json')

  @tag=AuthorizationToken
  Scenario: US#10,Check with Mandatory authorisation to Authorise the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def consentId = result.consentId
    * print consentId
    * set jsonRequestObjectToBeEncoded.claims.userinfo.openbanking_intent_id.value = consentId
    * set jsonRequestObjectToBeEncoded.claims.id_token.openbanking_intent_id.value = consentId
    * string requestObjToBeEncodedAsString = jsonRequestObjectToBeEncoded
    * print requestObjToBeEncodedAsString
    Given def result = Utils.getBase64EncodedString(requestObjToBeEncodedAsString)
      When def ws2 = "https://bacb-apim.uksouth.cloudapp.azure.com/authorize?response_type=code&client_id=RZbFa3EfrMUMQuiCsJit5U7fpzca&redirect_uri=http://localhost:3000&request_object="+result
    * print ws2
    And def ConsentAuthorizedCode = Utils.launchChromeBrowser(ws2,100260,13315)
    And print ConsentAuthorizedCode
    Given url 'https://bacb-apim.uksouth.cloudapp.azure.com'
    * path '/token'
    * def TokenCreationData =  read('testdata/Tokengeneration.json')
    * form field username = TokenCreationData.Username
    * form field password = TokenCreationData.Password
    *  form field grant_type = "authorization_code"
    * form field redirect_uri = "http://localhost:3000"
    * form field code = ConsentAuthorizedCode
    * header Authorization = TokenCreationData.TokenAuthorization
    * header Content-Type = TokenCreationData['Content-Type']
    When method post
    And status 200
    * def Token = response.access_token
    * print Token

  @tag=BasicConsentAuthorizationToken
  Scenario: US#10,Check with Mandatory authorisation to Authorise the consent with Basic
    * def result = call read('CreateConsent.feature@tag=ConsentWithBasicPermissions')
    * print result
    * def consentId = result.consentId
    * print consentId
    * set jsonRequestObjectToBeEncoded.claims.userinfo.openbanking_intent_id.value = consentId
    * set jsonRequestObjectToBeEncoded.claims.id_token.openbanking_intent_id.value = consentId
    * string requestObjToBeEncodedAsString = jsonRequestObjectToBeEncoded
    * print requestObjToBeEncodedAsString
    Given def result = Utils.getBase64EncodedString(requestObjToBeEncodedAsString)
    And print result
    When def ws2 = "https://bacb-apim.uksouth.cloudapp.azure.com/authorize?response_type=code&client_id=RZbFa3EfrMUMQuiCsJit5U7fpzca&redirect_uri=http://localhost:3000&request_object="+result
    * print ws2
    And def ConsentAuthorizedCode = Utils.launchChromeBrowser(ws2,100260,13315)
    And print ConsentAuthorizedCode
    Given url 'https://bacb-apim.uksouth.cloudapp.azure.com'
    * path '/token'
    * def TokenCreationData =  read('testdata/Tokengeneration.json')
    * form field username = TokenCreationData.Username
    * form field password = TokenCreationData.Password
    *  form field grant_type = "authorization_code"
    * form field redirect_uri = "http://localhost:3000"
    * form field code = ConsentAuthorizedCode
    * header Authorization = TokenCreationData.TokenAuthorization
    *  header Content-Type = TokenCreationData['Content-Type']
    When method post
    And status 200
    * def Token = response.access_token
    * print Token

  @tag=ReadTransactionsBasicAuthorizationToken
  Scenario: US#10,Check with Mandatory authorisation to Authorise the consent with ReadTransactionsBasic
    * def result = call read('CreateConsent.feature@tag=ReadTransactionsBasic')
    * print result
    * def consentId = result.consentId
    * print consentId
    * set jsonRequestObjectToBeEncoded.claims.userinfo.openbanking_intent_id.value = consentId
    * set jsonRequestObjectToBeEncoded.claims.id_token.openbanking_intent_id.value = consentId
    * string requestObjToBeEncodedAsString = jsonRequestObjectToBeEncoded
    * print requestObjToBeEncodedAsString
    Given def result = Utils.getBase64EncodedString(requestObjToBeEncodedAsString)
    And print result
    When def ws2 = "https://bacb-apim.uksouth.cloudapp.azure.com/authorize?response_type=code&client_id=RZbFa3EfrMUMQuiCsJit5U7fpzca&redirect_uri=http://localhost:3000&request_object="+result
    * print ws2
    And def ConsentAuthorizedCode = Utils.launchChromeBrowser(ws2,100260,13315)
    And print ConsentAuthorizedCode
    Given url 'https://bacb-apim.uksouth.cloudapp.azure.com'
    * path '/token'
    * def TokenCreationData =  read('testdata/Tokengeneration.json')
    * form field username = TokenCreationData.Username
    * form field password = TokenCreationData.Password
    *  form field grant_type = "authorization_code"
    * form field redirect_uri = "http://localhost:3000"
    * form field code = ConsentAuthorizedCode
    * header Authorization = TokenCreationData.TokenAuthorization
    *  header Content-Type = TokenCreationData['Content-Type']
    When method post
    And status 200
    * def Token = response.access_token
    * print Token

  @tag=ReadTransactionsDetailAuthorizationToken
  Scenario: US#10,Check with Mandatory authorisation to Authorise the consent with ReadTransactionsDetail
    * def result = call read('CreateConsent.feature@tag=ReadTransactionsDetail')
    * print result
    * def consentId = result.consentId
    * print consentId
    * set jsonRequestObjectToBeEncoded.claims.userinfo.openbanking_intent_id.value = consentId
    * set jsonRequestObjectToBeEncoded.claims.id_token.openbanking_intent_id.value = consentId
    * string requestObjToBeEncodedAsString = jsonRequestObjectToBeEncoded
    * print requestObjToBeEncodedAsString
    Given def result = Utils.getBase64EncodedString(requestObjToBeEncodedAsString)
    And print result
    When def ws2 = "https://bacb-apim.uksouth.cloudapp.azure.com/authorize?response_type=code&client_id=RZbFa3EfrMUMQuiCsJit5U7fpzca&redirect_uri=http://localhost:3000&request_object="+result
    * print ws2
    And def ConsentAuthorizedCode = Utils.launchChromeBrowser(ws2,100260,13315)
    And print ConsentAuthorizedCode
    Given url 'https://bacb-apim.uksouth.cloudapp.azure.com'
    * path '/token'
    * def TokenCreationData =  read('testdata/Tokengeneration.json')
    * form field username = TokenCreationData.Username
    * form field password = TokenCreationData.Password
    *  form field grant_type = "authorization_code"
    * form field redirect_uri = "http://localhost:3000"
    * form field code = ConsentAuthorizedCode
    * header Authorization = TokenCreationData.TokenAuthorization
    *  header Content-Type = TokenCreationData['Content-Type']
    When method post
    And status 200
    * def Token = response.access_token
    * print Token

  @tag=ReadTransactionsCreditsAuthorizationToken
  Scenario: US#10,Check with Mandatory authorisation to Authorise the consent with ReadTransactionsCredits
    * def result = call read('CreateConsent.feature@tag=ReadTransactionsCredits')
    * print result
    * def consentId = result.consentId
    * print consentId
    * set jsonRequestObjectToBeEncoded.claims.userinfo.openbanking_intent_id.value = consentId
    * set jsonRequestObjectToBeEncoded.claims.id_token.openbanking_intent_id.value = consentId
    * string requestObjToBeEncodedAsString = jsonRequestObjectToBeEncoded
    * print requestObjToBeEncodedAsString
    Given def result = Utils.getBase64EncodedString(requestObjToBeEncodedAsString)
    And print result
    When def ws2 = "https://bacb-apim.uksouth.cloudapp.azure.com/authorize?response_type=code&client_id=RZbFa3EfrMUMQuiCsJit5U7fpzca&redirect_uri=http://localhost:3000&request_object="+result
    * print ws2
    And def ConsentAuthorizedCode = Utils.launchChromeBrowser(ws2,100260,13315)
    And print ConsentAuthorizedCode
    Given url 'https://bacb-apim.uksouth.cloudapp.azure.com'
    * path '/token'
    * def TokenCreationData =  read('testdata/Tokengeneration.json')
    * form field username = TokenCreationData.Username
    * form field password = TokenCreationData.Password
    *  form field grant_type = "authorization_code"
    * form field redirect_uri = "http://localhost:3000"
    * form field code = ConsentAuthorizedCode
    * header Authorization = TokenCreationData.TokenAuthorization
    *  header Content-Type = TokenCreationData['Content-Type']
    When method post
    And status 200
    * def Token = response.access_token
    * print Token

  @tag=ReadTransactionsDebitsAuthorizationToken
  Scenario: US#10,Check with Mandatory authorisation to Authorise the consent with ReadTransactionsDebits
    * def result = call read('CreateConsent.feature@tag=ReadTransactionsDebits')
    * print result
    * def consentId = result.consentId
    * print consentId
    * set jsonRequestObjectToBeEncoded.claims.userinfo.openbanking_intent_id.value = consentId
    * set jsonRequestObjectToBeEncoded.claims.id_token.openbanking_intent_id.value = consentId
    * string requestObjToBeEncodedAsString = jsonRequestObjectToBeEncoded
    * print requestObjToBeEncodedAsString
    Given def result = Utils.getBase64EncodedString(requestObjToBeEncodedAsString)
    And print result
    When def ws2 = "https://bacb-apim.uksouth.cloudapp.azure.com/authorize?response_type=code&client_id=RZbFa3EfrMUMQuiCsJit5U7fpzca&redirect_uri=http://localhost:3000&request_object="+result
    * print ws2
    And def ConsentAuthorizedCode = Utils.launchChromeBrowser(ws2,100260,13315)
    And print ConsentAuthorizedCode
    Given url 'https://bacb-apim.uksouth.cloudapp.azure.com'
    * path '/token'
    * def TokenCreationData =  read('testdata/Tokengeneration.json')
    * form field username = TokenCreationData.Username
    * form field password = TokenCreationData.Password
    *  form field grant_type = "authorization_code"
    * form field redirect_uri = "http://localhost:3000"
    * form field code = ConsentAuthorizedCode
    * header Authorization = TokenCreationData.TokenAuthorization
    *  header Content-Type = TokenCreationData['Content-Type']
    When method post
    And status 200
    * def Token = response.access_token
    * print Token

  @tag=ReadTransactionsWithOutTransactionFromDateTime
  Scenario: US#10,Check with Mandatory authorisation to Authorise the consent WithOut TransactionFromDateTime
    * def result = call read('CreateConsent.feature@tag=ConsentWithOutTransactionFromDateTime')
    * print result
    * def consentId = result.consentId
    * print consentId
    * set jsonRequestObjectToBeEncoded.claims.userinfo.openbanking_intent_id.value = consentId
    * set jsonRequestObjectToBeEncoded.claims.id_token.openbanking_intent_id.value = consentId
    * string requestObjToBeEncodedAsString = jsonRequestObjectToBeEncoded
    * print requestObjToBeEncodedAsString
    Given def result = Utils.getBase64EncodedString(requestObjToBeEncodedAsString)
    And print result
    When def ws2 = "https://bacb-apim.uksouth.cloudapp.azure.com/authorize?response_type=code&client_id=RZbFa3EfrMUMQuiCsJit5U7fpzca&redirect_uri=http://localhost:3000&request_object="+result
    * print ws2
    And def ConsentAuthorizedCode = Utils.launchChromeBrowser(ws2,100260,13315)
    And print ConsentAuthorizedCode
    Given url 'https://bacb-apim.uksouth.cloudapp.azure.com'
    * path '/token'
    * def TokenCreationData =  read('testdata/Tokengeneration.json')
    * form field username = TokenCreationData.Username
    * form field password = TokenCreationData.Password
    *  form field grant_type = "authorization_code"
    * form field redirect_uri = "http://localhost:3000"
    * form field code = ConsentAuthorizedCode
    * header Authorization = TokenCreationData.TokenAuthorization
    *  header Content-Type = TokenCreationData['Content-Type']
    When method post
    And status 200
    * def Token = response.access_token
    * print Token

  @tag=ReadTransactionsWithOutTransactionToDateTime
  Scenario: US#10,Check with Mandatory authorisation to Authorise the consent WithOut TransactionToDateTime
    * def result = call read('CreateConsent.feature@tag=ConsentWithOutTransactionToDateTime')
    * print result
    * def consentId = result.consentId
    * print consentId
    * set jsonRequestObjectToBeEncoded.claims.userinfo.openbanking_intent_id.value = consentId
    * set jsonRequestObjectToBeEncoded.claims.id_token.openbanking_intent_id.value = consentId
    * string requestObjToBeEncodedAsString = jsonRequestObjectToBeEncoded
    * print requestObjToBeEncodedAsString
    Given def result = Utils.getBase64EncodedString(requestObjToBeEncodedAsString)
    And print result
    When def ws2 = "https://bacb-apim.uksouth.cloudapp.azure.com/authorize?response_type=code&client_id=RZbFa3EfrMUMQuiCsJit5U7fpzca&redirect_uri=http://localhost:3000&request_object="+result
    * print ws2
    And def ConsentAuthorizedCode = Utils.launchChromeBrowser(ws2,100260,13315)
    And print ConsentAuthorizedCode
    Given url 'https://bacb-apim.uksouth.cloudapp.azure.com'
    * path '/token'
    * def TokenCreationData =  read('testdata/Tokengeneration.json')
    * form field username = TokenCreationData.Username
    * form field password = TokenCreationData.Password
    *  form field grant_type = "authorization_code"
    * form field redirect_uri = "http://localhost:3000"
    * form field code = ConsentAuthorizedCode
    * header Authorization = TokenCreationData.TokenAuthorization
    *  header Content-Type = TokenCreationData['Content-Type']
    When method post
    And status 200
    * def Token = response.access_token
    * print Token

  @tag=ConsentAuthorisedWithOutTransactionDateTime
  Scenario: US#10,Check with Mandatory authorisation to Authorise the consent WithOut TransactionDateTime
    * def result = call read('CreateConsent.feature@tag=ConsentWithOutTransactionDateTime')
    * print result
    * def consentId = result.consentId
    * print consentId
    * set jsonRequestObjectToBeEncoded.claims.userinfo.openbanking_intent_id.value = consentId
    * set jsonRequestObjectToBeEncoded.claims.id_token.openbanking_intent_id.value = consentId
    * string requestObjToBeEncodedAsString = jsonRequestObjectToBeEncoded
    * print requestObjToBeEncodedAsString
    Given def result = Utils.getBase64EncodedString(requestObjToBeEncodedAsString)
    And print result
    When def ws2 = "https://bacb-apim.uksouth.cloudapp.azure.com/authorize?response_type=code&client_id=RZbFa3EfrMUMQuiCsJit5U7fpzca&redirect_uri=http://localhost:3000&request_object="+result
    * print ws2
    And def ConsentAuthorizedCode = Utils.launchChromeBrowser(ws2,100260,13315)
    And print ConsentAuthorizedCode
    Given url 'https://bacb-apim.uksouth.cloudapp.azure.com'
    * path '/token'
    * def TokenCreationData =  read('testdata/Tokengeneration.json')
    * form field username = TokenCreationData.Username
    * form field password = TokenCreationData.Password
    *  form field grant_type = "authorization_code"
    * form field redirect_uri = "http://localhost:3000"
    * form field code = ConsentAuthorizedCode
    * header Authorization = TokenCreationData.TokenAuthorization
    *  header Content-Type = TokenCreationData['Content-Type']
    When method post
    And status 200
    * def Token = response.access_token
    * print Token