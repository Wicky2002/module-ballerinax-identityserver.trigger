// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/crypto;
import ballerina/data.jsondata;
import ballerina/http;
import ballerina/io;
import ballerina/lang.runtime;
import ballerina/test;

const TRIGGER_TEST_SECRET = "trigger-test-secret";
const TRIGGER_TEST_PORT = 9091;
const TRIGGER_PAYLOAD_DIR = "tests/resources/trigger_payloads";

isolated map<boolean> triggerFired = {};
isolated map<json> boundPayloads = {};
isolated map<json> boundJson = {};

listener Listener triggerTestListener = check new ({webhookSecret: TRIGGER_TEST_SECRET}, TRIGGER_TEST_PORT);

final http:Client triggerClient = check new (string `http://localhost:${TRIGGER_TEST_PORT}`);

service LoginService on triggerTestListener {
    isolated remote function onLoginSuccess(LoginSuccessEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["LoginService.onLoginSuccess"] = received;
        }
        lock {
            triggerFired["LoginService.onLoginSuccess"] = true;
        }
    }

    isolated remote function onLoginFailed(LoginFailedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["LoginService.onLoginFailed"] = received;
        }
        lock {
            triggerFired["LoginService.onLoginFailed"] = true;
        }
    }
}

service RegistrationService on triggerTestListener {
    isolated remote function onRegistrationSuccess(RegistrationSuccessEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["RegistrationService.onRegistrationSuccess"] = received;
        }
        lock {
            triggerFired["RegistrationService.onRegistrationSuccess"] = true;
        }
    }

    isolated remote function onRegistrationFailed(RegistrationFailedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["RegistrationService.onRegistrationFailed"] = received;
        }
        lock {
            triggerFired["RegistrationService.onRegistrationFailed"] = true;
        }
    }
}

service TokenService on triggerTestListener {
    isolated remote function onAccessTokenIssued(AccessTokenIssuedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["TokenService.onAccessTokenIssued"] = received;
        }
        lock {
            triggerFired["TokenService.onAccessTokenIssued"] = true;
        }
    }

    isolated remote function onAccessTokenRevoked(AccessTokenRevokedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["TokenService.onAccessTokenRevoked"] = received;
        }
        lock {
            triggerFired["TokenService.onAccessTokenRevoked"] = true;
        }
    }
}

service SessionService on triggerTestListener {
    isolated remote function onSessionEstablished(SessionEstablishedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["SessionService.onSessionEstablished"] = received;
        }
        lock {
            triggerFired["SessionService.onSessionEstablished"] = true;
        }
    }

    isolated remote function onSessionPresented(SessionPresentedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["SessionService.onSessionPresented"] = received;
        }
        lock {
            triggerFired["SessionService.onSessionPresented"] = true;
        }
    }

    isolated remote function onSessionRevoked(SessionRevokedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["SessionService.onSessionRevoked"] = received;
        }
        lock {
            triggerFired["SessionService.onSessionRevoked"] = true;
        }
    }
}

service CredentialService on triggerTestListener {
    isolated remote function onCredentialUpdated(CredentialUpdatedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["CredentialService.onCredentialUpdated"] = received;
        }
        lock {
            triggerFired["CredentialService.onCredentialUpdated"] = true;
        }
    }
}

service UserService on triggerTestListener {
    isolated remote function onUserCreated(UserCreatedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["UserService.onUserCreated"] = received;
        }
        lock {
            triggerFired["UserService.onUserCreated"] = true;
        }
    }

    isolated remote function onUserProfileUpdated(UserProfileUpdatedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["UserService.onUserProfileUpdated"] = received;
        }
        lock {
            triggerFired["UserService.onUserProfileUpdated"] = true;
        }
    }

    isolated remote function onUserDisabled(UserDisabledEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["UserService.onUserDisabled"] = received;
        }
        lock {
            triggerFired["UserService.onUserDisabled"] = true;
        }
    }

    isolated remote function onUserEnabled(UserEnabledEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["UserService.onUserEnabled"] = received;
        }
        lock {
            triggerFired["UserService.onUserEnabled"] = true;
        }
    }

    isolated remote function onUserAccountLocked(UserAccountLockedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["UserService.onUserAccountLocked"] = received;
        }
        lock {
            triggerFired["UserService.onUserAccountLocked"] = true;
        }
    }

    isolated remote function onUserAccountUnlocked(UserAccountUnlockedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["UserService.onUserAccountUnlocked"] = received;
        }
        lock {
            triggerFired["UserService.onUserAccountUnlocked"] = true;
        }
    }

    isolated remote function onUserDeleted(UserDeletedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["UserService.onUserDeleted"] = received;
        }
        lock {
            triggerFired["UserService.onUserDeleted"] = true;
        }
    }
}

service ConsentService on triggerTestListener {
    isolated remote function onConsentAdded(ConsentAddedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["ConsentService.onConsentAdded"] = received;
        }
        lock {
            triggerFired["ConsentService.onConsentAdded"] = true;
        }
    }

    isolated remote function onConsentRevoked(ConsentRevokedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["ConsentService.onConsentRevoked"] = received;
        }
        lock {
            triggerFired["ConsentService.onConsentRevoked"] = true;
        }
    }
}

service ConsentPurposeService on triggerTestListener {
    isolated remote function onPurposeVersionAdded(PurposeVersionAddedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["ConsentPurposeService.onPurposeVersionAdded"] = received;
        }
        lock {
            triggerFired["ConsentPurposeService.onPurposeVersionAdded"] = true;
        }
    }
}

service RoleService on triggerTestListener {
    isolated remote function onRoleCreated(RoleCreatedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["RoleService.onRoleCreated"] = received;
        }
        lock {
            triggerFired["RoleService.onRoleCreated"] = true;
        }
    }

    isolated remote function onRoleMetaUpdated(RoleMetaUpdatedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["RoleService.onRoleMetaUpdated"] = received;
        }
        lock {
            triggerFired["RoleService.onRoleMetaUpdated"] = true;
        }
    }

    isolated remote function onRoleDeleted(RoleDeletedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["RoleService.onRoleDeleted"] = received;
        }
        lock {
            triggerFired["RoleService.onRoleDeleted"] = true;
        }
    }

    isolated remote function onRoleUsersUpdated(RoleUsersUpdatedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["RoleService.onRoleUsersUpdated"] = received;
        }
        lock {
            triggerFired["RoleService.onRoleUsersUpdated"] = true;
        }
    }

    isolated remote function onRoleGroupsUpdated(RoleGroupsUpdatedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["RoleService.onRoleGroupsUpdated"] = received;
        }
        lock {
            triggerFired["RoleService.onRoleGroupsUpdated"] = true;
        }
    }

    isolated remote function onRoleIdpGroupsUpdated(RoleIdpGroupsUpdatedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["RoleService.onRoleIdpGroupsUpdated"] = received;
        }
        lock {
            triggerFired["RoleService.onRoleIdpGroupsUpdated"] = true;
        }
    }

    isolated remote function onRolePermissionsUpdated(RolePermissionsUpdatedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["RoleService.onRolePermissionsUpdated"] = received;
        }
        lock {
            triggerFired["RoleService.onRolePermissionsUpdated"] = true;
        }
    }
}

service OrganizationService on triggerTestListener {
    isolated remote function onOrganizationCreated(OrganizationCreatedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["OrganizationService.onOrganizationCreated"] = received;
        }
        lock {
            triggerFired["OrganizationService.onOrganizationCreated"] = true;
        }
    }

    isolated remote function onOrganizationUpdated(OrganizationUpdatedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["OrganizationService.onOrganizationUpdated"] = received;
        }
        lock {
            triggerFired["OrganizationService.onOrganizationUpdated"] = true;
        }
    }

    isolated remote function onOrganizationEnabled(OrganizationEnabledEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["OrganizationService.onOrganizationEnabled"] = received;
        }
        lock {
            triggerFired["OrganizationService.onOrganizationEnabled"] = true;
        }
    }

    isolated remote function onOrganizationDisabled(OrganizationDisabledEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["OrganizationService.onOrganizationDisabled"] = received;
        }
        lock {
            triggerFired["OrganizationService.onOrganizationDisabled"] = true;
        }
    }

    isolated remote function onOrganizationDeleted(OrganizationDeletedEvent payload) returns error? {
        readonly & json received = jsondata:toJson(payload).cloneReadOnly();
        lock {
            boundJson["OrganizationService.onOrganizationDeleted"] = received;
        }
        lock {
            triggerFired["OrganizationService.onOrganizationDeleted"] = true;
        }
    }
}

isolated function sendSignedTriggerWebhook(string eventIdentifier) returns http:Response|error {
    byte[] body = check io:fileReadBytes(string `${TRIGGER_PAYLOAD_DIR}/${eventIdentifier}.json`);
    string bodyText = check string:fromBytes(body);
    string payloadToHash = string `${bodyText}`;
    byte[] computedDigest = check crypto:hmacSha256(payloadToHash.toBytes(), TRIGGER_TEST_SECRET.toBytes());
    string computedSignature = computedDigest.toBase16();
    map<string> headers = {
        "x-wso2-event-signature": string `sha256=${computedSignature}`
    };
    return triggerClient->post("/", body, headers, "application/json");
}

function waitForDispatch(string trackerKey) returns boolean {
    foreach int i in 0 ..< 20 {
        lock {
            if triggerFired[trackerKey] ?: false {
                return true;
            }
        }
        runtime:sleep(0.05);
    }
    return false;
}

function boundJsonOf(string trackerKey) returns json {
    lock {
        return boundJson[trackerKey].clone();
    }
}

function deliveredEvent(json bound, json fixture) returns json {
    return fixture is json[] && fixture.length() == 1 && bound is map<json>
        ? fixture[0] : fixture;
}

function assertBindsFixture(json bound, json fixture, string at) {
    if fixture is map<json> {
        test:assertTrue(bound is map<json>, string `${at} should have bound to an object`);
        if bound is map<json> {
            foreach [string, json] [key, value] in fixture.entries() {
                assertBindsFixture(bound[key], value, string `${at}.${key}`);
            }
        }
    } else if fixture is json[] {
        test:assertTrue(bound is json[] && bound.length() == fixture.length(),
                string `${at} should have bound to an array of ${fixture.length()}`);
        if bound is json[] && bound.length() == fixture.length() {
            foreach int i in 0 ..< fixture.length() {
                assertBindsFixture(bound[i], fixture[i], string `${at}[${i}]`);
            }
        }
    } else if fixture is int|float|decimal && bound is int|float|decimal {
        test:assertEquals(<decimal>bound, <decimal>fixture,
                string `${at} should have bound unchanged`);
    } else {
        test:assertEquals(bound, fixture,
                string `${at} should have bound unchanged`);
    }
}

function boundPayloadOf(string trackerKey) returns map<json> {
    lock {
        json payload = boundPayloads[trackerKey] ?: {};
        return payload is map<json> ? payload.clone() : {};
    }
}

@test:Config {}
function testLoginSuccessDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("loginSuccess");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("LoginService.onLoginSuccess"), "LoginService.onLoginSuccess should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["LoginService.onLoginSuccess"], "Only LoginService.onLoginSuccess should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/loginSuccess.json`);
    json received = boundJsonOf("LoginService.onLoginSuccess");
    assertBindsFixture(received, deliveredEvent(received, fixture), "LoginSuccessEvent");
}

@test:Config {}
function testLoginFailedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("loginFailed");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("LoginService.onLoginFailed"), "LoginService.onLoginFailed should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["LoginService.onLoginFailed"], "Only LoginService.onLoginFailed should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/loginFailed.json`);
    json received = boundJsonOf("LoginService.onLoginFailed");
    assertBindsFixture(received, deliveredEvent(received, fixture), "LoginFailedEvent");
}

@test:Config {}
function testRegistrationSuccessDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("registrationSuccess");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("RegistrationService.onRegistrationSuccess"), "RegistrationService.onRegistrationSuccess should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["RegistrationService.onRegistrationSuccess"], "Only RegistrationService.onRegistrationSuccess should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/registrationSuccess.json`);
    json received = boundJsonOf("RegistrationService.onRegistrationSuccess");
    assertBindsFixture(received, deliveredEvent(received, fixture), "RegistrationSuccessEvent");
}

@test:Config {}
function testRegistrationFailedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("registrationFailed");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("RegistrationService.onRegistrationFailed"), "RegistrationService.onRegistrationFailed should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["RegistrationService.onRegistrationFailed"], "Only RegistrationService.onRegistrationFailed should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/registrationFailed.json`);
    json received = boundJsonOf("RegistrationService.onRegistrationFailed");
    assertBindsFixture(received, deliveredEvent(received, fixture), "RegistrationFailedEvent");
}

@test:Config {}
function testAccessTokenIssuedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("accessTokenIssued");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("TokenService.onAccessTokenIssued"), "TokenService.onAccessTokenIssued should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["TokenService.onAccessTokenIssued"], "Only TokenService.onAccessTokenIssued should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/accessTokenIssued.json`);
    json received = boundJsonOf("TokenService.onAccessTokenIssued");
    assertBindsFixture(received, deliveredEvent(received, fixture), "AccessTokenIssuedEvent");
}

@test:Config {}
function testAccessTokenRevokedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("accessTokenRevoked");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("TokenService.onAccessTokenRevoked"), "TokenService.onAccessTokenRevoked should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["TokenService.onAccessTokenRevoked"], "Only TokenService.onAccessTokenRevoked should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/accessTokenRevoked.json`);
    json received = boundJsonOf("TokenService.onAccessTokenRevoked");
    assertBindsFixture(received, deliveredEvent(received, fixture), "AccessTokenRevokedEvent");
}

@test:Config {}
function testSessionEstablishedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("sessionEstablished");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("SessionService.onSessionEstablished"), "SessionService.onSessionEstablished should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["SessionService.onSessionEstablished"], "Only SessionService.onSessionEstablished should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/sessionEstablished.json`);
    json received = boundJsonOf("SessionService.onSessionEstablished");
    assertBindsFixture(received, deliveredEvent(received, fixture), "SessionEstablishedEvent");
}

@test:Config {}
function testSessionPresentedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("sessionPresented");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("SessionService.onSessionPresented"), "SessionService.onSessionPresented should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["SessionService.onSessionPresented"], "Only SessionService.onSessionPresented should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/sessionPresented.json`);
    json received = boundJsonOf("SessionService.onSessionPresented");
    assertBindsFixture(received, deliveredEvent(received, fixture), "SessionPresentedEvent");
}

@test:Config {}
function testSessionRevokedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("sessionRevoked");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("SessionService.onSessionRevoked"), "SessionService.onSessionRevoked should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["SessionService.onSessionRevoked"], "Only SessionService.onSessionRevoked should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/sessionRevoked.json`);
    json received = boundJsonOf("SessionService.onSessionRevoked");
    assertBindsFixture(received, deliveredEvent(received, fixture), "SessionRevokedEvent");
}

@test:Config {}
function testCredentialUpdatedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("credentialUpdated");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("CredentialService.onCredentialUpdated"), "CredentialService.onCredentialUpdated should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["CredentialService.onCredentialUpdated"], "Only CredentialService.onCredentialUpdated should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/credentialUpdated.json`);
    json received = boundJsonOf("CredentialService.onCredentialUpdated");
    assertBindsFixture(received, deliveredEvent(received, fixture), "CredentialUpdatedEvent");
}

@test:Config {}
function testUserCreatedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("userCreated");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("UserService.onUserCreated"), "UserService.onUserCreated should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["UserService.onUserCreated"], "Only UserService.onUserCreated should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/userCreated.json`);
    json received = boundJsonOf("UserService.onUserCreated");
    assertBindsFixture(received, deliveredEvent(received, fixture), "UserCreatedEvent");
}

@test:Config {}
function testUserProfileUpdatedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("userProfileUpdated");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("UserService.onUserProfileUpdated"), "UserService.onUserProfileUpdated should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["UserService.onUserProfileUpdated"], "Only UserService.onUserProfileUpdated should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/userProfileUpdated.json`);
    json received = boundJsonOf("UserService.onUserProfileUpdated");
    assertBindsFixture(received, deliveredEvent(received, fixture), "UserProfileUpdatedEvent");
}

@test:Config {}
function testUserDisabledDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("userDisabled");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("UserService.onUserDisabled"), "UserService.onUserDisabled should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["UserService.onUserDisabled"], "Only UserService.onUserDisabled should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/userDisabled.json`);
    json received = boundJsonOf("UserService.onUserDisabled");
    assertBindsFixture(received, deliveredEvent(received, fixture), "UserDisabledEvent");
}

@test:Config {}
function testUserEnabledDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("userEnabled");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("UserService.onUserEnabled"), "UserService.onUserEnabled should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["UserService.onUserEnabled"], "Only UserService.onUserEnabled should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/userEnabled.json`);
    json received = boundJsonOf("UserService.onUserEnabled");
    assertBindsFixture(received, deliveredEvent(received, fixture), "UserEnabledEvent");
}

@test:Config {}
function testUserAccountLockedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("userAccountLocked");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("UserService.onUserAccountLocked"), "UserService.onUserAccountLocked should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["UserService.onUserAccountLocked"], "Only UserService.onUserAccountLocked should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/userAccountLocked.json`);
    json received = boundJsonOf("UserService.onUserAccountLocked");
    assertBindsFixture(received, deliveredEvent(received, fixture), "UserAccountLockedEvent");
}

@test:Config {}
function testUserAccountUnlockedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("userAccountUnlocked");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("UserService.onUserAccountUnlocked"), "UserService.onUserAccountUnlocked should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["UserService.onUserAccountUnlocked"], "Only UserService.onUserAccountUnlocked should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/userAccountUnlocked.json`);
    json received = boundJsonOf("UserService.onUserAccountUnlocked");
    assertBindsFixture(received, deliveredEvent(received, fixture), "UserAccountUnlockedEvent");
}

@test:Config {}
function testUserDeletedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("userDeleted");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("UserService.onUserDeleted"), "UserService.onUserDeleted should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["UserService.onUserDeleted"], "Only UserService.onUserDeleted should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/userDeleted.json`);
    json received = boundJsonOf("UserService.onUserDeleted");
    assertBindsFixture(received, deliveredEvent(received, fixture), "UserDeletedEvent");
}

@test:Config {}
function testConsentAddedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("consentAdded");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("ConsentService.onConsentAdded"), "ConsentService.onConsentAdded should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["ConsentService.onConsentAdded"], "Only ConsentService.onConsentAdded should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/consentAdded.json`);
    json received = boundJsonOf("ConsentService.onConsentAdded");
    assertBindsFixture(received, deliveredEvent(received, fixture), "ConsentAddedEvent");
}

@test:Config {}
function testConsentRevokedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("consentRevoked");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("ConsentService.onConsentRevoked"), "ConsentService.onConsentRevoked should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["ConsentService.onConsentRevoked"], "Only ConsentService.onConsentRevoked should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/consentRevoked.json`);
    json received = boundJsonOf("ConsentService.onConsentRevoked");
    assertBindsFixture(received, deliveredEvent(received, fixture), "ConsentRevokedEvent");
}

@test:Config {}
function testPurposeVersionAddedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("purposeVersionAdded");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("ConsentPurposeService.onPurposeVersionAdded"), "ConsentPurposeService.onPurposeVersionAdded should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["ConsentPurposeService.onPurposeVersionAdded"], "Only ConsentPurposeService.onPurposeVersionAdded should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/purposeVersionAdded.json`);
    json received = boundJsonOf("ConsentPurposeService.onPurposeVersionAdded");
    assertBindsFixture(received, deliveredEvent(received, fixture), "PurposeVersionAddedEvent");
}

@test:Config {}
function testRoleCreatedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("roleCreated");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("RoleService.onRoleCreated"), "RoleService.onRoleCreated should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["RoleService.onRoleCreated"], "Only RoleService.onRoleCreated should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/roleCreated.json`);
    json received = boundJsonOf("RoleService.onRoleCreated");
    assertBindsFixture(received, deliveredEvent(received, fixture), "RoleCreatedEvent");
}

@test:Config {}
function testRoleMetaUpdatedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("roleMetaUpdated");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("RoleService.onRoleMetaUpdated"), "RoleService.onRoleMetaUpdated should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["RoleService.onRoleMetaUpdated"], "Only RoleService.onRoleMetaUpdated should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/roleMetaUpdated.json`);
    json received = boundJsonOf("RoleService.onRoleMetaUpdated");
    assertBindsFixture(received, deliveredEvent(received, fixture), "RoleMetaUpdatedEvent");
}

@test:Config {}
function testRoleDeletedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("roleDeleted");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("RoleService.onRoleDeleted"), "RoleService.onRoleDeleted should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["RoleService.onRoleDeleted"], "Only RoleService.onRoleDeleted should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/roleDeleted.json`);
    json received = boundJsonOf("RoleService.onRoleDeleted");
    assertBindsFixture(received, deliveredEvent(received, fixture), "RoleDeletedEvent");
}

@test:Config {}
function testRoleUsersUpdatedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("roleUsersUpdated");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("RoleService.onRoleUsersUpdated"), "RoleService.onRoleUsersUpdated should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["RoleService.onRoleUsersUpdated"], "Only RoleService.onRoleUsersUpdated should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/roleUsersUpdated.json`);
    json received = boundJsonOf("RoleService.onRoleUsersUpdated");
    assertBindsFixture(received, deliveredEvent(received, fixture), "RoleUsersUpdatedEvent");
}

@test:Config {}
function testRoleGroupsUpdatedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("roleGroupsUpdated");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("RoleService.onRoleGroupsUpdated"), "RoleService.onRoleGroupsUpdated should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["RoleService.onRoleGroupsUpdated"], "Only RoleService.onRoleGroupsUpdated should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/roleGroupsUpdated.json`);
    json received = boundJsonOf("RoleService.onRoleGroupsUpdated");
    assertBindsFixture(received, deliveredEvent(received, fixture), "RoleGroupsUpdatedEvent");
}

@test:Config {}
function testRoleIdpGroupsUpdatedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("roleIdpGroupsUpdated");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("RoleService.onRoleIdpGroupsUpdated"), "RoleService.onRoleIdpGroupsUpdated should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["RoleService.onRoleIdpGroupsUpdated"], "Only RoleService.onRoleIdpGroupsUpdated should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/roleIdpGroupsUpdated.json`);
    json received = boundJsonOf("RoleService.onRoleIdpGroupsUpdated");
    assertBindsFixture(received, deliveredEvent(received, fixture), "RoleIdpGroupsUpdatedEvent");
}

@test:Config {}
function testRolePermissionsUpdatedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("rolePermissionsUpdated");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("RoleService.onRolePermissionsUpdated"), "RoleService.onRolePermissionsUpdated should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["RoleService.onRolePermissionsUpdated"], "Only RoleService.onRolePermissionsUpdated should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/rolePermissionsUpdated.json`);
    json received = boundJsonOf("RoleService.onRolePermissionsUpdated");
    assertBindsFixture(received, deliveredEvent(received, fixture), "RolePermissionsUpdatedEvent");
}

@test:Config {}
function testOrganizationCreatedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("organizationCreated");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("OrganizationService.onOrganizationCreated"), "OrganizationService.onOrganizationCreated should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["OrganizationService.onOrganizationCreated"], "Only OrganizationService.onOrganizationCreated should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/organizationCreated.json`);
    json received = boundJsonOf("OrganizationService.onOrganizationCreated");
    assertBindsFixture(received, deliveredEvent(received, fixture), "OrganizationCreatedEvent");
}

@test:Config {}
function testOrganizationUpdatedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("organizationUpdated");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("OrganizationService.onOrganizationUpdated"), "OrganizationService.onOrganizationUpdated should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["OrganizationService.onOrganizationUpdated"], "Only OrganizationService.onOrganizationUpdated should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/organizationUpdated.json`);
    json received = boundJsonOf("OrganizationService.onOrganizationUpdated");
    assertBindsFixture(received, deliveredEvent(received, fixture), "OrganizationUpdatedEvent");
}

@test:Config {}
function testOrganizationEnabledDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("organizationEnabled");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("OrganizationService.onOrganizationEnabled"), "OrganizationService.onOrganizationEnabled should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["OrganizationService.onOrganizationEnabled"], "Only OrganizationService.onOrganizationEnabled should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/organizationEnabled.json`);
    json received = boundJsonOf("OrganizationService.onOrganizationEnabled");
    assertBindsFixture(received, deliveredEvent(received, fixture), "OrganizationEnabledEvent");
}

@test:Config {}
function testOrganizationDisabledDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("organizationDisabled");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("OrganizationService.onOrganizationDisabled"), "OrganizationService.onOrganizationDisabled should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["OrganizationService.onOrganizationDisabled"], "Only OrganizationService.onOrganizationDisabled should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/organizationDisabled.json`);
    json received = boundJsonOf("OrganizationService.onOrganizationDisabled");
    assertBindsFixture(received, deliveredEvent(received, fixture), "OrganizationDisabledEvent");
}

@test:Config {}
function testOrganizationDeletedDispatch() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendSignedTriggerWebhook("organizationDeleted");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("OrganizationService.onOrganizationDeleted"), "OrganizationService.onOrganizationDeleted should have fired");
    lock {
        test:assertEquals(triggerFired.keys(), ["OrganizationService.onOrganizationDeleted"], "Only OrganizationService.onOrganizationDeleted should have fired");
    }
    json fixture = check io:fileReadJson(string `${TRIGGER_PAYLOAD_DIR}/organizationDeleted.json`);
    json received = boundJsonOf("OrganizationService.onOrganizationDeleted");
    assertBindsFixture(received, deliveredEvent(received, fixture), "OrganizationDeletedEvent");
}

@test:Config {}
function testVerificationHandshake() returns error? {
    http:Response response = check triggerClient->get("/?hub.mode=subscribe&hub.topic=trigger-test-value&hub.challenge=trigger-test-challenge");
    test:assertEquals(response.statusCode, 200);
    test:assertEquals(check response.getTextPayload(), "trigger-test-challenge");
}

@test:Config {}
function testVerificationHandshakeIsNotConfirmedForOtherRequests() returns error? {
    http:Response response = check triggerClient->get("/?hub.mode=not-subscribe&hub.topic=trigger-test-value&hub.challenge=trigger-test-challenge");
    test:assertEquals(response.statusCode, http:STATUS_NOT_FOUND);
}

@test:Config {}
function testVerificationHandshakeNeedsEveryRequiredParameter() returns error? {
    http:Response response = check triggerClient->get("/?hub.mode=subscribe&hub.challenge=trigger-test-challenge");
    test:assertEquals(response.statusCode, http:STATUS_NOT_FOUND);
}

