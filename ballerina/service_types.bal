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

# Attachable service type exposing the LoginService family of webhook events.
public type LoginService service object {
    # Triggered on Login success.
    # + payload - the LoginSuccessEvent webhook payload
    # + return - an error if handling the event fails
    remote function onLoginSuccess(LoginSuccessEvent payload) returns error?;

    # Triggered on Login failed.
    # + payload - the LoginFailedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onLoginFailed(LoginFailedEvent payload) returns error?;
};

# Attachable service type exposing the RegistrationService family of webhook events.
public type RegistrationService service object {
    # Triggered on Registration success.
    # + payload - the RegistrationSuccessEvent webhook payload
    # + return - an error if handling the event fails
    remote function onRegistrationSuccess(RegistrationSuccessEvent payload) returns error?;

    # Triggered on Registration failed.
    # + payload - the RegistrationFailedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onRegistrationFailed(RegistrationFailedEvent payload) returns error?;
};

# Attachable service type exposing the TokenService family of webhook events.
public type TokenService service object {
    # Triggered on Access token issued.
    # + payload - the AccessTokenIssuedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onAccessTokenIssued(AccessTokenIssuedEvent payload) returns error?;

    # Triggered on Access token revoked.
    # + payload - the AccessTokenRevokedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onAccessTokenRevoked(AccessTokenRevokedEvent payload) returns error?;
};

# Attachable service type exposing the SessionService family of webhook events.
public type SessionService service object {
    # Triggered on Session established.
    # + payload - the SessionEstablishedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onSessionEstablished(SessionEstablishedEvent payload) returns error?;

    # Triggered on Session presented.
    # + payload - the SessionPresentedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onSessionPresented(SessionPresentedEvent payload) returns error?;

    # Triggered on Session revoked.
    # + payload - the SessionRevokedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onSessionRevoked(SessionRevokedEvent payload) returns error?;
};

# Attachable service type exposing the CredentialService family of webhook events.
public type CredentialService service object {
    # Triggered on Credential updated.
    # + payload - the CredentialUpdatedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onCredentialUpdated(CredentialUpdatedEvent payload) returns error?;
};

# Attachable service type exposing the UserService family of webhook events.
public type UserService service object {
    # Triggered on User created.
    # + payload - the UserCreatedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onUserCreated(UserCreatedEvent payload) returns error?;

    # Triggered on User profile updated.
    # + payload - the UserProfileUpdatedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onUserProfileUpdated(UserProfileUpdatedEvent payload) returns error?;

    # Triggered on User disabled.
    # + payload - the UserDisabledEvent webhook payload
    # + return - an error if handling the event fails
    remote function onUserDisabled(UserDisabledEvent payload) returns error?;

    # Triggered on User enabled.
    # + payload - the UserEnabledEvent webhook payload
    # + return - an error if handling the event fails
    remote function onUserEnabled(UserEnabledEvent payload) returns error?;

    # Triggered on User account locked.
    # + payload - the UserAccountLockedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onUserAccountLocked(UserAccountLockedEvent payload) returns error?;

    # Triggered on User account unlocked.
    # + payload - the UserAccountUnlockedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onUserAccountUnlocked(UserAccountUnlockedEvent payload) returns error?;

    # Triggered on User deleted.
    # + payload - the UserDeletedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onUserDeleted(UserDeletedEvent payload) returns error?;
};

# Attachable service type exposing the ConsentService family of webhook events.
public type ConsentService service object {
    # Triggered on Consent added.
    # + payload - the ConsentAddedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onConsentAdded(ConsentAddedEvent payload) returns error?;

    # Triggered on Consent revoked.
    # + payload - the ConsentRevokedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onConsentRevoked(ConsentRevokedEvent payload) returns error?;
};

# Attachable service type exposing the ConsentPurposeService family of webhook events.
public type ConsentPurposeService service object {
    # Triggered on Purpose version added.
    # + payload - the PurposeVersionAddedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onPurposeVersionAdded(PurposeVersionAddedEvent payload) returns error?;
};

# Attachable service type exposing the RoleService family of webhook events.
public type RoleService service object {
    # Triggered on Role created.
    # + payload - the RoleCreatedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onRoleCreated(RoleCreatedEvent payload) returns error?;

    # Triggered on Role meta updated.
    # + payload - the RoleMetaUpdatedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onRoleMetaUpdated(RoleMetaUpdatedEvent payload) returns error?;

    # Triggered on Role deleted.
    # + payload - the RoleDeletedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onRoleDeleted(RoleDeletedEvent payload) returns error?;

    # Triggered on Role users updated.
    # + payload - the RoleUsersUpdatedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onRoleUsersUpdated(RoleUsersUpdatedEvent payload) returns error?;

    # Triggered on Role groups updated.
    # + payload - the RoleGroupsUpdatedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onRoleGroupsUpdated(RoleGroupsUpdatedEvent payload) returns error?;

    # Triggered on Role idp groups updated.
    # + payload - the RoleIdpGroupsUpdatedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onRoleIdpGroupsUpdated(RoleIdpGroupsUpdatedEvent payload) returns error?;

    # Triggered on Role permissions updated.
    # + payload - the RolePermissionsUpdatedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onRolePermissionsUpdated(RolePermissionsUpdatedEvent payload) returns error?;
};

# Attachable service type exposing the OrganizationService family of webhook events.
public type OrganizationService service object {
    # Triggered on Organization created.
    # + payload - the OrganizationCreatedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onOrganizationCreated(OrganizationCreatedEvent payload) returns error?;

    # Triggered on Organization updated.
    # + payload - the OrganizationUpdatedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onOrganizationUpdated(OrganizationUpdatedEvent payload) returns error?;

    # Triggered on Organization enabled.
    # + payload - the OrganizationEnabledEvent webhook payload
    # + return - an error if handling the event fails
    remote function onOrganizationEnabled(OrganizationEnabledEvent payload) returns error?;

    # Triggered on Organization disabled.
    # + payload - the OrganizationDisabledEvent webhook payload
    # + return - an error if handling the event fails
    remote function onOrganizationDisabled(OrganizationDisabledEvent payload) returns error?;

    # Triggered on Organization deleted.
    # + payload - the OrganizationDeletedEvent webhook payload
    # + return - an error if handling the event fails
    remote function onOrganizationDeleted(OrganizationDeletedEvent payload) returns error?;
};

# The union of every service type that can be attached to this listener.
public type GenericServiceType LoginService|RegistrationService|TokenService|SessionService|CredentialService|UserService|ConsentService|ConsentPurposeService|RoleService|OrganizationService;

