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
import ballerina/log;
import ballerinax/asyncapi.native.handler;

service class DispatcherService {
    *http:Service;
    private map<GenericServiceType> services = {};
    private handler:NativeHandler nativeHandler = new ();
    private string? webhookSecret;

    isolated function init(string? webhookSecret) {
        self.webhookSecret = webhookSecret;
    }

    isolated function addServiceRef(string serviceType, GenericServiceType genericService) returns error? {
        if (self.services.hasKey(serviceType)) {
            return error(string `Service of type ${serviceType} has already been attached`);
        }
        self.services[serviceType] = genericService;
    }

    isolated function removeServiceRef(string serviceType) returns error? {
        if (!self.services.hasKey(serviceType)) {
            return error(string `Cannot detach the service of type ${serviceType}. Service has not been attached to the listener before`);
        }
        _ = self.services.remove(serviceType);
    }

    resource function post .(http:Caller caller, http:Request request) returns error? {
        error? verifyResult = self.verifyWebhookSignature(request, self.webhookSecret);
        if verifyResult is error {
            string reason = verifyResult.message().startsWith("Unauthorized:") ? verifyResult.message() : "Unauthorized: Malformed Request";
            log:printWarn("WEBHOOK_SIGNATURE_REJECTED", reason = reason, path = request.rawPath);
            http:Response r = new;
            r.statusCode = http:STATUS_UNAUTHORIZED;
            check caller->respond(r);
            return;
        }
        json payload = check request.getJsonPayload();
        json|error keyedEvents = payload.events;
        if keyedEvents !is map<json> || keyedEvents.length() != 1 {
            http:Response badRequest = new;
            badRequest.statusCode = http:STATUS_BAD_REQUEST;
            check caller->respond(badRequest);
            return;
        }
        string eventType = keyedEvents.keys()[0];
        http:Response ackResponse = new;
        ackResponse.statusCode = http:STATUS_OK;
        check caller->respond(ackResponse);
        boolean|error dispatchResult = self.matchRemoteFunc(payload, eventType);
        if dispatchResult is error {
            log:printError("DISPATCH_FAILED", dispatchResult);
        } else if !dispatchResult {
            log:printWarn("NO_HANDLER_FOR_EVENT", eventIdentifier = eventType);
        }
    }

    resource function get .(http:Caller caller, http:Request request) returns error? {
        http:Response handshakeResponse = new;
        if request.getQueryParamValue("hub.mode") is () || request.getQueryParamValue("hub.topic") is () {
            handshakeResponse.statusCode = http:STATUS_NOT_FOUND;
        } else {
            string? challenge = request.getQueryParamValue("hub.challenge");
            if challenge is string {
                handshakeResponse.setTextPayload(challenge);
            } else {
                handshakeResponse.statusCode = http:STATUS_BAD_REQUEST;
            }
        }
        check caller->respond(handshakeResponse);
    }

    private isolated function verifyWebhookSignature(http:Request request, string? webhookSecret) returns error? {
        if webhookSecret is () || webhookSecret.trim() == "" {
            return error("Unauthorized: Webhook Secret Not Configured");
        }
        // Hand-written, re-apply after regenerating (docs/spec/sanitations.md): Asgardeo sends the signature in x-hub-signature.
        string signatureHeader = request.hasHeader("x-wso2-event-signature") ? "x-wso2-event-signature" : "x-hub-signature";
        if !request.hasHeader(signatureHeader) {
            return error("Unauthorized: Missing Signature Header");
        }
        string receivedHeader = check request.getHeader(signatureHeader);
        map<string> extractedHeaderValues = {};
        int headerCursor = 0;
        if !receivedHeader.substring(headerCursor).startsWith("sha256=") {
            return error("Unauthorized: Malformed Signature Header");
        }
        headerCursor += 7;
        extractedHeaderValues["signature"] = receivedHeader.substring(headerCursor);
        headerCursor = receivedHeader.length();
        if !extractedHeaderValues.hasKey("signature") {
            return error("Unauthorized: Missing Header Component: signature");
        }
        string payloadToHash = string `${check request.getTextPayload()}`;
        byte[] computedDigest = check crypto:hmacSha256(payloadToHash.toBytes(), webhookSecret.toBytes());
        string computedSignature = computedDigest.toBase16();
        string expectedHeader = string `sha256=${computedSignature}`;
        if !crypto:equalConstantTime(receivedHeader.toBytes(), expectedHeader.toBytes()) {
            return error("Unauthorized: Signature Mismatch");
        }
    }

    private isolated function matchRemoteFunc(json payload, string eventType) returns boolean|error {
        if check self.matchRemoteFuncForLogin(payload, eventType) {
            return true;
        }
        if check self.matchRemoteFuncForRegistration(payload, eventType) {
            return true;
        }
        if check self.matchRemoteFuncForToken(payload, eventType) {
            return true;
        }
        if check self.matchRemoteFuncForSession(payload, eventType) {
            return true;
        }
        if check self.matchRemoteFuncForCredential(payload, eventType) {
            return true;
        }
        if check self.matchRemoteFuncForUser(payload, eventType) {
            return true;
        }
        if check self.matchRemoteFuncForConsent(payload, eventType) {
            return true;
        }
        if check self.matchRemoteFuncForConsentPurpose(payload, eventType) {
            return true;
        }
        if check self.matchRemoteFuncForRole(payload, eventType) {
            return true;
        }
        if check self.matchRemoteFuncForOrganization(payload, eventType) {
            return true;
        }
        return false;
    }

    private isolated function matchRemoteFuncForLogin(json payload, string eventIdentifier) returns boolean|error {
        match eventIdentifier {
            "https://schemas.identity.wso2.org/events/login/event-type/loginSuccess" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/login/event-type/loginSuccess", "LoginService", "onLoginSuccess");
                return true;
            }
            "https://schemas.identity.wso2.org/events/login/event-type/loginFailed" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/login/event-type/loginFailed", "LoginService", "onLoginFailed");
                return true;
            }
        }
        return false;
    }

    private isolated function matchRemoteFuncForRegistration(json payload, string eventIdentifier) returns boolean|error {
        match eventIdentifier {
            "https://schemas.identity.wso2.org/events/registration/event-type/registrationSuccess" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/registration/event-type/registrationSuccess", "RegistrationService", "onRegistrationSuccess");
                return true;
            }
            "https://schemas.identity.wso2.org/events/registration/event-type/registrationFailed" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/registration/event-type/registrationFailed", "RegistrationService", "onRegistrationFailed");
                return true;
            }
        }
        return false;
    }

    private isolated function matchRemoteFuncForToken(json payload, string eventIdentifier) returns boolean|error {
        match eventIdentifier {
            "https://schemas.identity.wso2.org/events/token/event-type/accessTokenIssued" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/token/event-type/accessTokenIssued", "TokenService", "onAccessTokenIssued");
                return true;
            }
            "https://schemas.identity.wso2.org/events/token/event-type/accessTokenRevoked" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/token/event-type/accessTokenRevoked", "TokenService", "onAccessTokenRevoked");
                return true;
            }
        }
        return false;
    }

    private isolated function matchRemoteFuncForSession(json payload, string eventIdentifier) returns boolean|error {
        match eventIdentifier {
            "https://schemas.identity.wso2.org/events/session/event-type/sessionEstablished" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/session/event-type/sessionEstablished", "SessionService", "onSessionEstablished");
                return true;
            }
            "https://schemas.identity.wso2.org/events/session/event-type/sessionPresented" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/session/event-type/sessionPresented", "SessionService", "onSessionPresented");
                return true;
            }
            "https://schemas.identity.wso2.org/events/session/event-type/sessionRevoked" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/session/event-type/sessionRevoked", "SessionService", "onSessionRevoked");
                return true;
            }
        }
        return false;
    }

    private isolated function matchRemoteFuncForCredential(json payload, string eventIdentifier) returns boolean|error {
        match eventIdentifier {
            "https://schemas.identity.wso2.org/events/credential/event-type/credentialUpdated" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/credential/event-type/credentialUpdated", "CredentialService", "onCredentialUpdated");
                return true;
            }
        }
        return false;
    }

    private isolated function matchRemoteFuncForUser(json payload, string eventIdentifier) returns boolean|error {
        match eventIdentifier {
            "https://schemas.identity.wso2.org/events/user/event-type/userCreated" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/user/event-type/userCreated", "UserService", "onUserCreated");
                return true;
            }
            "https://schemas.identity.wso2.org/events/user/event-type/userProfileUpdated" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/user/event-type/userProfileUpdated", "UserService", "onUserProfileUpdated");
                return true;
            }
            "https://schemas.identity.wso2.org/events/user/event-type/userDisabled" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/user/event-type/userDisabled", "UserService", "onUserDisabled");
                return true;
            }
            "https://schemas.identity.wso2.org/events/user/event-type/userEnabled" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/user/event-type/userEnabled", "UserService", "onUserEnabled");
                return true;
            }
            "https://schemas.identity.wso2.org/events/user/event-type/userAccountLocked" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/user/event-type/userAccountLocked", "UserService", "onUserAccountLocked");
                return true;
            }
            "https://schemas.identity.wso2.org/events/user/event-type/userAccountUnlocked" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/user/event-type/userAccountUnlocked", "UserService", "onUserAccountUnlocked");
                return true;
            }
            "https://schemas.identity.wso2.org/events/user/event-type/userDeleted" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/user/event-type/userDeleted", "UserService", "onUserDeleted");
                return true;
            }
        }
        return false;
    }

    private isolated function matchRemoteFuncForConsent(json payload, string eventIdentifier) returns boolean|error {
        match eventIdentifier {
            "https://schemas.identity.wso2.org/events/consent/event-type/consentAdded" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/consent/event-type/consentAdded", "ConsentService", "onConsentAdded");
                return true;
            }
            "https://schemas.identity.wso2.org/events/consent/event-type/consentRevoked" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/consent/event-type/consentRevoked", "ConsentService", "onConsentRevoked");
                return true;
            }
        }
        return false;
    }

    private isolated function matchRemoteFuncForConsentPurpose(json payload, string eventIdentifier) returns boolean|error {
        match eventIdentifier {
            "https://schemas.identity.wso2.org/events/consent-purpose/event-type/purposeVersionAdded" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/consent-purpose/event-type/purposeVersionAdded", "ConsentPurposeService", "onPurposeVersionAdded");
                return true;
            }
        }
        return false;
    }

    private isolated function matchRemoteFuncForRole(json payload, string eventIdentifier) returns boolean|error {
        match eventIdentifier {
            "https://schemas.identity.wso2.org/events/role/event-type/roleCreated" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/role/event-type/roleCreated", "RoleService", "onRoleCreated");
                return true;
            }
            "https://schemas.identity.wso2.org/events/role/event-type/roleMetaUpdated" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/role/event-type/roleMetaUpdated", "RoleService", "onRoleMetaUpdated");
                return true;
            }
            "https://schemas.identity.wso2.org/events/role/event-type/roleDeleted" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/role/event-type/roleDeleted", "RoleService", "onRoleDeleted");
                return true;
            }
            "https://schemas.identity.wso2.org/events/role/event-type/roleUsersUpdated" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/role/event-type/roleUsersUpdated", "RoleService", "onRoleUsersUpdated");
                return true;
            }
            "https://schemas.identity.wso2.org/events/role/event-type/roleGroupsUpdated" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/role/event-type/roleGroupsUpdated", "RoleService", "onRoleGroupsUpdated");
                return true;
            }
            "https://schemas.identity.wso2.org/events/role/event-type/roleIdpGroupsUpdated" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/role/event-type/roleIdpGroupsUpdated", "RoleService", "onRoleIdpGroupsUpdated");
                return true;
            }
            "https://schemas.identity.wso2.org/events/role/event-type/rolePermissionsUpdated" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/role/event-type/rolePermissionsUpdated", "RoleService", "onRolePermissionsUpdated");
                return true;
            }
        }
        return false;
    }

    private isolated function matchRemoteFuncForOrganization(json payload, string eventIdentifier) returns boolean|error {
        match eventIdentifier {
            "https://schemas.identity.wso2.org/events/organization/event-type/organizationCreated" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/organization/event-type/organizationCreated", "OrganizationService", "onOrganizationCreated");
                return true;
            }
            "https://schemas.identity.wso2.org/events/organization/event-type/organizationUpdated" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/organization/event-type/organizationUpdated", "OrganizationService", "onOrganizationUpdated");
                return true;
            }
            "https://schemas.identity.wso2.org/events/organization/event-type/organizationEnabled" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/organization/event-type/organizationEnabled", "OrganizationService", "onOrganizationEnabled");
                return true;
            }
            "https://schemas.identity.wso2.org/events/organization/event-type/organizationDisabled" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/organization/event-type/organizationDisabled", "OrganizationService", "onOrganizationDisabled");
                return true;
            }
            "https://schemas.identity.wso2.org/events/organization/event-type/organizationDeleted" => {
                check self.executeRemoteFunc(payload, "https://schemas.identity.wso2.org/events/organization/event-type/organizationDeleted", "OrganizationService", "onOrganizationDeleted");
                return true;
            }
        }
        return false;
    }

    private isolated function executeRemoteFunc(json payload, string eventName, string serviceTypeStr, string eventFunction) returns error? {
        GenericServiceType? genericService = self.services[serviceTypeStr];
        if genericService is GenericServiceType {
            any boundEvent = check self.nativeHandler.bindEventPayload(genericService, eventFunction, payload);
            check self.nativeHandler.invokeRemoteFunction(boundEvent, eventName, eventFunction, genericService);
        } else {
            log:printDebug("SERVICE_NOT_ATTACHED", serviceType = serviceTypeStr, eventName = eventName);
        }
    }
}
