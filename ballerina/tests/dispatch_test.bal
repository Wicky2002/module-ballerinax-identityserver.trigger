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
import ballerina/http;
import ballerina/io;
import ballerina/lang.runtime;
import ballerina/test;

const TRIGGER_TEST_SECRET = "trigger-test-secret";
const TRIGGER_TEST_PORT = 9091;
const TRIGGER_PAYLOAD_DIR = "tests/resources/trigger_payloads";

isolated map<boolean> triggerFired = {};
isolated map<json> boundPayloads = {};

listener Listener triggerTestListener = check new ({webhookSecret: TRIGGER_TEST_SECRET}, TRIGGER_TEST_PORT);

final http:Client triggerClient = check new (string `http://localhost:${TRIGGER_TEST_PORT}`);

service LoginService on triggerTestListener {
    isolated remote function onLoginSuccess(LoginSuccessEvent payload) returns error? {
        lock {
            triggerFired["LoginService.onLoginSuccess"] = true;
        }
    }

    isolated remote function onLoginFailed(LoginFailedEvent payload) returns error? {
        lock {
            triggerFired["LoginService.onLoginFailed"] = true;
        }
    }
}

service RegistrationService on triggerTestListener {
    isolated remote function onRegistrationSuccess(RegistrationSuccessEvent payload) returns error? {
        lock {
            triggerFired["RegistrationService.onRegistrationSuccess"] = true;
        }
    }

    isolated remote function onRegistrationFailed(RegistrationFailedEvent payload) returns error? {
        lock {
            triggerFired["RegistrationService.onRegistrationFailed"] = true;
        }
    }
}

service TokenService on triggerTestListener {
    isolated remote function onAccessTokenIssued(AccessTokenIssuedEvent payload) returns error? {
        lock {
            triggerFired["TokenService.onAccessTokenIssued"] = true;
        }
    }

    isolated remote function onAccessTokenRevoked(AccessTokenRevokedEvent payload) returns error? {
        lock {
            triggerFired["TokenService.onAccessTokenRevoked"] = true;
        }
    }
}

service SessionService on triggerTestListener {
    isolated remote function onSessionEstablished(SessionEstablishedEvent payload) returns error? {
        lock {
            triggerFired["SessionService.onSessionEstablished"] = true;
        }
    }

    isolated remote function onSessionPresented(SessionPresentedEvent payload) returns error? {
        lock {
            triggerFired["SessionService.onSessionPresented"] = true;
        }
    }

    isolated remote function onSessionRevoked(SessionRevokedEvent payload) returns error? {
        lock {
            triggerFired["SessionService.onSessionRevoked"] = true;
        }
    }
}

service CredentialService on triggerTestListener {
    isolated remote function onCredentialUpdated(CredentialUpdatedEvent payload) returns error? {
        lock {
            triggerFired["CredentialService.onCredentialUpdated"] = true;
        }
    }
}

service UserService on triggerTestListener {
    isolated remote function onUserCreated(UserCreatedEvent payload) returns error? {
        lock {
            triggerFired["UserService.onUserCreated"] = true;
        }
    }

    isolated remote function onUserProfileUpdated(UserProfileUpdatedEvent payload) returns error? {
        lock {
            triggerFired["UserService.onUserProfileUpdated"] = true;
        }
    }

    isolated remote function onUserDisabled(UserDisabledEvent payload) returns error? {
        lock {
            triggerFired["UserService.onUserDisabled"] = true;
        }
    }

    isolated remote function onUserEnabled(UserEnabledEvent payload) returns error? {
        lock {
            triggerFired["UserService.onUserEnabled"] = true;
        }
    }

    isolated remote function onUserAccountLocked(UserAccountLockedEvent payload) returns error? {
        lock {
            triggerFired["UserService.onUserAccountLocked"] = true;
        }
    }

    isolated remote function onUserAccountUnlocked(UserAccountUnlockedEvent payload) returns error? {
        lock {
            triggerFired["UserService.onUserAccountUnlocked"] = true;
        }
    }

    isolated remote function onUserDeleted(UserDeletedEvent payload) returns error? {
        lock {
            triggerFired["UserService.onUserDeleted"] = true;
        }
    }
}

service ConsentService on triggerTestListener {
    isolated remote function onConsentAdded(ConsentAddedEvent payload) returns error? {
        lock {
            triggerFired["ConsentService.onConsentAdded"] = true;
        }
    }

    isolated remote function onConsentRevoked(ConsentRevokedEvent payload) returns error? {
        lock {
            triggerFired["ConsentService.onConsentRevoked"] = true;
        }
    }
}

service ConsentPurposeService on triggerTestListener {
    isolated remote function onPurposeVersionAdded(PurposeVersionAddedEvent payload) returns error? {
        lock {
            triggerFired["ConsentPurposeService.onPurposeVersionAdded"] = true;
        }
    }
}

service RoleService on triggerTestListener {
    isolated remote function onRoleCreated(RoleCreatedEvent payload) returns error? {
        lock {
            triggerFired["RoleService.onRoleCreated"] = true;
        }
    }

    isolated remote function onRoleMetaUpdated(RoleMetaUpdatedEvent payload) returns error? {
        lock {
            triggerFired["RoleService.onRoleMetaUpdated"] = true;
        }
    }

    isolated remote function onRoleDeleted(RoleDeletedEvent payload) returns error? {
        lock {
            triggerFired["RoleService.onRoleDeleted"] = true;
        }
    }

    isolated remote function onRoleUsersUpdated(RoleUsersUpdatedEvent payload) returns error? {
        lock {
            triggerFired["RoleService.onRoleUsersUpdated"] = true;
        }
    }

    isolated remote function onRoleGroupsUpdated(RoleGroupsUpdatedEvent payload) returns error? {
        lock {
            triggerFired["RoleService.onRoleGroupsUpdated"] = true;
        }
    }

    isolated remote function onRoleIdpGroupsUpdated(RoleIdpGroupsUpdatedEvent payload) returns error? {
        lock {
            triggerFired["RoleService.onRoleIdpGroupsUpdated"] = true;
        }
    }

    isolated remote function onRolePermissionsUpdated(RolePermissionsUpdatedEvent payload) returns error? {
        lock {
            triggerFired["RoleService.onRolePermissionsUpdated"] = true;
        }
    }
}

service OrganizationService on triggerTestListener {
    isolated remote function onOrganizationCreated(OrganizationCreatedEvent payload) returns error? {
        lock {
            triggerFired["OrganizationService.onOrganizationCreated"] = true;
        }
    }

    isolated remote function onOrganizationUpdated(OrganizationUpdatedEvent payload) returns error? {
        lock {
            triggerFired["OrganizationService.onOrganizationUpdated"] = true;
        }
    }

    isolated remote function onOrganizationEnabled(OrganizationEnabledEvent payload) returns error? {
        lock {
            triggerFired["OrganizationService.onOrganizationEnabled"] = true;
        }
    }

    isolated remote function onOrganizationDisabled(OrganizationDisabledEvent payload) returns error? {
        lock {
            triggerFired["OrganizationService.onOrganizationDisabled"] = true;
        }
    }

    isolated remote function onOrganizationDeleted(OrganizationDeletedEvent payload) returns error? {
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
}

@test:Config {}
function testVerificationHandshake() returns error? {
    http:Response response = check triggerClient->get("/?hub.mode=trigger-test-value&hub.topic=trigger-test-value&hub.challenge=trigger-test-challenge");
    test:assertEquals(response.statusCode, 200);
    test:assertEquals(check response.getTextPayload(), "trigger-test-challenge");
}

@test:Config {}
function testVerificationHandshakeNeedsEveryRequiredParameter() returns error? {
    http:Response response = check triggerClient->get("/?hub.topic=trigger-test-value&hub.challenge=trigger-test-challenge");
    test:assertEquals(response.statusCode, http:STATUS_NOT_FOUND);
}

