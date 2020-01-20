@NotRun

Feature: Testing UpdateConsent api

  Background:
    * configure ssl = true
    * def Utils = Java.type('com.bitsy.customjavacode.Utils')
    * def jsonRequestObjectToBeEncoded = read('testdata/Base64Encoder.json')

  @tag=ConsentAuthorised
  Scenario: US#10,Check with Mandatory authorisation to Authorise the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def AuToken = result.AutoToken
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

  @tag=BasicPermissionConsentAuthorised
  Scenario: US#10,Check with Mandatory authorisation to Authorise the consent with Basic permission
    * def result = call read('CreateConsent.feature@tag=ConsentWithBasicPermissions')
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


  @tag=BasicPermissionConsentAuthorised
  Scenario: US#10,Check with Mandatory authorisation to Authorise the consent with Basic permission
    * def result = call read('CreateConsent.feature@tag=ConsentWithBasicPermissions')
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

  @tag=ConsentRejected
  Scenario: US#10,Check with Mandatory authorisation to reject the consent
    * def result = call read('CreateConsent.feature@tag=ConsentCreated')
    * def Token = result.AutoToken
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
    And def ConsentAuthorizedCode = Utils.RejectConsent(ws2,100260,13315)
