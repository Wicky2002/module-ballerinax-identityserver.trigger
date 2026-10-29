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

import ballerina/data.jsondata;

# Configuration for the webhook listener, including the secret used to verify incoming requests.
public type ListenerConfig record {
    # The secret used to verify incoming webhook signatures.
    string webhookSecret?;
};

# Indicates the persona who initiates the identity flow.
public type InitiatorType string?;

# Indicates the related identity flow.
public type Action string?;

# Indicates the IP address of the initiator that triggered the event.
public type InitiatorIpAddress string?;

public type Claim record {
    # Local claim uri name. E.g., http://wso2.org/claims/username
    string uri;
    # Claim value. Either a single value or an array of values for multi-valued claims.
    Value value;
};

public type Value string|string[];

# Information of the user interacting in the related event.
public type User record {
    # Unique identifier of the user.
    string id?;
    # Claim values of the user.
    Claim[] claims?;
    # The organization the user belongs to (the user's resident organization).
    anydata organization?;
    # SCIM 2.0 resource URL for the user.
    string ref?;
};

# Contains information about the user whose profile updated.
public type ProfileUpdatedUser record {
    # Unique identifier of the user.
    string id?;
    # The organization the user belongs to (the user's resident organization).
    anydata organization?;
    # Claims added to the user's profile during the update.
    Claim[] addedClaims?;
    # Claims whose values changed during the update.
    Claim[] updatedClaims?;
    # Claims removed from the user's profile during the update.
    RemovedClaimsItem[] removedClaims?;
    # SCIM 2.0 resource URL for the user.
    string ref?;
};

public type RemovedClaimsItem record {
    # Local claim uri name. E.g., http://wso2.org/claims/username
    string uri?;
};

# Root organization (tenant).
public type Tenant record {
    # The unique numeric identifier of the tenant.
    string id?;
    # The domain name of the tenant.
    string name?;
};

# The organization under which the event is processed.
public type Organization record {
    # Unique identifier of the organization.
    string id?;
    # Name of the organization.
    string name?;
    # Unique, human-readable handle of the organization.
    string orgHandle?;
    # The depth of the organization in the hierarchy.
    int depth?;
};

# User store managing the user's data.
public type UserStore record {
    # The unique identifier for the user store.
    string id?;
    # User store name used to identify the user store in configuration settings, user interfaces, and administrative
    # tasks.
    string name?;
};

# Information about an application.
public type Application record {
    # Unique identifier of the application.
    string id?;
    # Name of the application.
    string name?;
};

# Information about the session.
public type Session record {
    # Unique identifier for the session
    string id?;
    # Timestamp when the session originally started.
    int loginTime?;
    # Array of applications associated with this session.
    Application[] applications?;
};

# Details about the issued token.
public type AccessToken record {
    # e.g. `Opaque` or `jwt`.
    string tokenType?;
    # Token issued at timestamp.
    string iat?;
    # OAuth2 grant type used for token issuance (e.g., `authorization_code`)
    string grantType?;
};

# Context information for the failure.
public type Reason record {
    # Human-readable explanation of the failure.
    string description?;
    # Details about the failure point in the related identity flow.
    Context context?;
};

# Details about the failure step in the authentication flow.
public type FailedStep record {
    # Step number where the failure occurred
    int step?;
    # Identity Provider (IdP) involved in the failure
    string idp?;
    # Authenticator used.
    string authenticator?;
};

# Details about the failure point in the related identity flow.
public type Context record {
    # Details about the failure step in the authentication flow.
    FailedStep failedStep?;
};

# Contains details about the consent.
public type Consent record {
    # Unique identifier for the consent record.
    string id?;
    # Username of the user to whom the consent applies.
    string subjectId?;
    # Current state of the consent.
    string state?;
    # The service or application for which the consent is granted.
    string serviceId?;
    # Details of the consent purpose.
    Purpose purpose?;
};

public type ElementsItem record {
    string name?;
};

# Details of the consent purpose.
public type Purpose record {
    # Unique identifier of the consent purpose.
    string id?;
    # Human-readable name of the consent purpose.
    string name?;
    # The UUID of the specific purpose version the user consented to.
    string 'version?;
    # Array of PII categories covered by the consent, each with a name.
    ElementsItem[] elements?;
};

# Contains details about the updated consent purpose.
public type PurposeVersion record {
    # Unique identifier for the consent purpose.
    string id?;
    # Human-readable name of the consent purpose.
    string name?;
    # Details of the newly added version.
    'version 'version?;
};

public type PurposeVersionElementsItem record {
    string name?;
    boolean mandatory?;
};

# Details of the newly added version.
public type 'version record {
    # The version number of the new version.
    string 'version?;
    # Whether this version becomes the active version for new consents.
    boolean setAsLatest?;
    # Array of attributes (elements) included in this version, each with a name and mandatory flag.
    PurposeVersionElementsItem[] elements?;
};

# Login success
public type EventDataLoginSuccess record {
    # The login success event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/login/event-type/loginSuccess"}
    LoginSuccessPayload loginSuccess;
};

# Login failed
public type EventDataLoginFailed record {
    # The login failed event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/login/event-type/loginFailed"}
    LoginFailedPayload loginFailed;
};

# Registration success
public type EventDataRegistrationSuccess record {
    # The registration success event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/registration/event-type/registrationSuccess"}
    RegistrationSuccessPayload registrationSuccess;
};

# Registration failed
public type EventDataRegistrationFailed record {
    # The registration failed event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/registration/event-type/registrationFailed"}
    RegistrationFailedPayload registrationFailed;
};

# Access token issued
public type EventDataAccessTokenIssued record {
    # The access token issued event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/token/event-type/accessTokenIssued"}
    AccessTokenIssuedPayload accessTokenIssued;
};

# Access token revoked
public type EventDataAccessTokenRevoked record {
    # The access token revoked event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/token/event-type/accessTokenRevoked"}
    AccessTokenRevokedPayload accessTokenRevoked;
};

# Session established
public type EventDataSessionEstablished record {
    # The session established event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/session/event-type/sessionEstablished"}
    SessionEstablishedPayload sessionEstablished;
};

# Session presented
public type EventDataSessionPresented record {
    # The session presented event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/session/event-type/sessionPresented"}
    SessionPresentedPayload sessionPresented;
};

# Session revoked
public type EventDataSessionRevoked record {
    # The session revoked event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/session/event-type/sessionRevoked"}
    SessionRevokedPayload sessionRevoked;
};

# Credential updated
public type EventDataCredentialUpdated record {
    # The credential updated event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/credential/event-type/credentialUpdated"}
    CredentialUpdatedPayload credentialUpdated;
};

# User created
public type EventDataUserCreated record {
    # The user created event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/user/event-type/userCreated"}
    UserCreatedPayload userCreated;
};

# User profile updated
public type EventDataUserProfileUpdated record {
    # The user profile updated event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/user/event-type/userProfileUpdated"}
    UserProfileUpdatedPayload userProfileUpdated;
};

# User disabled
public type EventDataUserDisabled record {
    # The user disabled event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/user/event-type/userDisabled"}
    UserDisabledPayload userDisabled;
};

# User enabled
public type EventDataUserEnabled record {
    # The user enabled event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/user/event-type/userEnabled"}
    UserEnabledPayload userEnabled;
};

# User account locked
public type EventDataUserAccountLocked record {
    # The user account locked event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/user/event-type/userAccountLocked"}
    UserAccountLockedPayload userAccountLocked;
};

# User account unlocked
public type EventDataUserAccountUnlocked record {
    # The user account unlocked event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/user/event-type/userAccountUnlocked"}
    UserAccountUnlockedPayload userAccountUnlocked;
};

# User deleted
public type EventDataUserDeleted record {
    # The user deleted event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/user/event-type/userDeleted"}
    UserDeletedPayload userDeleted;
};

# Consent added
public type EventDataConsentAdded record {
    # The consent added event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/consent/event-type/consentAdded"}
    ConsentAddedPayload consentAdded;
};

# Consent revoked
public type EventDataConsentRevoked record {
    # The consent revoked event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/consent/event-type/consentRevoked"}
    ConsentRevokedPayload consentRevoked;
};

# Purpose version added
public type EventDataPurposeVersionAdded record {
    # The purpose version added event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/consent-purpose/event-type/purposeVersionAdded"}
    PurposeVersionAddedPayload purposeVersionAdded;
};

# The audience the role is scoped to.
public type RoleAudience record {
    # The audience type. Either `organization` or `application`.
    string 'type?;
    # Identifier of the audience. The organization id for an organization-scoped role, or the application id for an
    # application-scoped role.
    string value?;
    # Display name of the audience. The organization name for an organization-scoped role, or the application name for
    # an application-scoped role.
    string display?;
};

# A user assigned to or unassigned from the role.
public type RoleUser record {
    # Unique identifier of the user.
    string id?;
    # The user store domain the user belongs to.
    string userStoreDomain?;
    # Claim values of the user.
    Claim[] claims?;
};

# A local group assigned to or unassigned from the role.
public type RoleGroup record {
    # Unique identifier of the group.
    string id?;
    # Name of the group.
    string groupName?;
    # The user store domain the group belongs to.
    string userStoreDomain?;
};

# A federated identity provider (IdP) group assigned to or unassigned from the role.
public type RoleIdpGroup record {
    # Unique identifier of the IdP group.
    string groupId?;
    # Name of the IdP group.
    string groupName?;
    # Unique identifier of the identity provider.
    string idpId?;
    # Name of the identity provider.
    string idpName?;
};

# Role created
public type EventDataRoleCreated record {
    # The role created event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/role/event-type/roleCreated"}
    RoleCreatedPayload roleCreated;
};

# Role metadata updated
public type EventDataRoleMetaUpdated record {
    # The role metadata updated event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/role/event-type/roleMetaUpdated"}
    RoleMetaUpdatedPayload roleMetaUpdated;
};

# Role deleted
public type EventDataRoleDeleted record {
    # The role deleted event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/role/event-type/roleDeleted"}
    RoleDeletedPayload roleDeleted;
};

# Role users updated
public type EventDataRoleUsersUpdated record {
    # The role users updated event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/role/event-type/roleUsersUpdated"}
    RoleUsersUpdatedPayload roleUsersUpdated;
};

# Role groups updated
public type EventDataRoleGroupsUpdated record {
    # The role groups updated event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/role/event-type/roleGroupsUpdated"}
    RoleGroupsUpdatedPayload roleGroupsUpdated;
};

# Role IdP groups updated
public type EventDataRoleIdpGroupsUpdated record {
    # The role IdP groups updated event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/role/event-type/roleIdpGroupsUpdated"}
    RoleIdpGroupsUpdatedPayload roleIdpGroupsUpdated;
};

# Role permissions updated
public type EventDataRolePermissionsUpdated record {
    # The role permissions updated event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/role/event-type/rolePermissionsUpdated"}
    RolePermissionsUpdatedPayload rolePermissionsUpdated;
};

public type LoginSuccessPayload record {
    # Indicates the persona who initiates the identity flow. E.g., `USER`
    string initiatorType?;
    # Indicates the related identity flow. E.g., `LOGIN`
    string action?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
    # Information about the application that initiated the login.
    anydata application?;
    # An array of authentication methods used for the successful login (for example `BasicAuthenticator`).
    string[] authenticationMethods?;
};

public type LoginFailedPayload record {
    # Indicates the persona who initiates the identity flow. E.g., `USER`
    string initiatorType?;
    # Indicates the related identity flow. E.g., `LOGIN`
    string action?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
    # Information about the application that initiated the login.
    anydata application?;
    # Context information for the failure.
    Reason reason?;
};

public type RegistrationSuccessPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
    # Indicates the related identity flow.
    Action action?;
};

public type RegistrationFailedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # Indicates the related identity flow.
    Action action?;
    # Context information for the failure.
    Reason reason?;
};

public type AccessTokenIssuedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the related identity flow.
    Action action?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
    # Information about the application that requested the token.
    AccessTokenIssuedPayloadApplication application?;
    # Details about the issued token.
    AccessToken accessToken?;
};

# Information about the application that requested the token.
public type AccessTokenIssuedPayloadApplication record {
    # Name of the application.
    string name?;
    # Consumer key of the application.
    string consumerKey?;
};

public type AccessTokenRevokedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the related identity flow.
    Action action?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
    # Applications associated with the revoked token.
    ApplicationsItem[] applications?;
};

public type ApplicationsItem record {
    # Unique identifier of the application.
    string id?;
    # Name of the application.
    string name?;
    # Consumer key of the application.
    string consumerKey?;
};

public type SessionEstablishedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the related identity flow.
    Action action?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
    # Information about the application through which the session gets established.
    anydata application?;
    # Information about the session.
    Session session?;
};

public type SessionPresentedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the related identity flow.
    Action action?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
    # Information about the application that requested the session presentation.
    anydata application?;
    # Information about the session.
    Session session?;
};

public type SessionRevokedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the related identity flow.
    Action action?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
    # Array of revoked sessions.
    Session[] sessions?;
};

public type CredentialUpdatedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
    # Indicates which credential the user updates (e.g., `PASSWORD`).
    string credentialType?;
    # Indicates the related identity flow.
    Action action?;
};

public type UserCreatedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
    # Indicates the related identity flow.
    Action action?;
};

public type UserProfileUpdatedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Contains information about the user whose profile updated.
    ProfileUpdatedUser user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
    # Indicates the related identity flow.
    Action action?;
};

public type UserDisabledPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
    # Indicates the related identity flow.
    Action action?;
};

public type UserEnabledPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
    # Indicates the related identity flow.
    Action action?;
};

public type UserAccountLockedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the related identity flow.
    Action action?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
};

public type UserAccountUnlockedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the related identity flow.
    Action action?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
};

public type UserDeletedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
    # Indicates the related identity flow.
    Action action?;
};

public type ConsentAddedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
    # Indicates the related identity flow.
    Action action?;
    # Contains details about the consent.
    Consent consent?;
};

public type ConsentRevokedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Information of the user interacting in the related event.
    User user?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # User store managing the user's data.
    UserStore userStore?;
    # Indicates the related identity flow.
    Action action?;
    # Contains details about the consent.
    Consent consent?;
};

public type PurposeVersionAddedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # Indicates the related identity flow.
    Action action?;
    # Contains details about the updated consent purpose.
    PurposeVersion purpose?;
};

public type RoleCreatedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # Indicates the related identity flow.
    Action action?;
    # Contains details about the created role.
    Role role?;
};

# Contains details about the created role.
public type Role record {
    # Unique identifier of the role.
    string id?;
    # Display name of the role.
    string name?;
    # The audience the role is scoped to.
    RoleAudience audience?;
    # SCIM v2 reference URL for the role.
    string ref?;
    # Users assigned to the role at creation. Present only when the role is created with users.
    RoleUser[] users?;
    # Local groups assigned to the role at creation. Present only when the role is created with groups.
    RoleGroup[] groups?;
    # Permission names granted to the role at creation. Present only when the role is created with permissions.
    string[] permissions?;
};

public type RoleMetaUpdatedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # Indicates the related identity flow.
    Action action?;
    # Contains details about the updated role.
    RoleMetaUpdatedPayloadRole role?;
};

# Contains details about the updated role.
public type RoleMetaUpdatedPayloadRole record {
    # Unique identifier of the role.
    string id?;
    # Display name of the role.
    string name?;
    # The audience the role is scoped to.
    RoleAudience audience?;
    # SCIM v2 reference URL for the role.
    string ref?;
};

public type RoleDeletedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # Indicates the related identity flow.
    Action action?;
    # Contains details about the deleted role.
    RoleDeletedPayloadRole role?;
};

# Contains details about the deleted role.
public type RoleDeletedPayloadRole record {
    # Unique identifier of the role.
    string id?;
    # Display name of the role.
    string name?;
    # The audience the role is scoped to.
    RoleAudience audience?;
};

public type RoleUsersUpdatedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # Indicates the related identity flow.
    Action action?;
    # Contains details about the role whose user assignments got updated.
    RoleUsersUpdatedPayloadRole role?;
};

# Contains details about the role whose user assignments got updated.
public type RoleUsersUpdatedPayloadRole record {
    # Unique identifier of the role.
    string id?;
    # Display name of the role.
    string name?;
    # The audience the role is scoped to.
    RoleAudience audience?;
    # SCIM v2 reference URL for the role.
    string ref?;
    # Users assigned to the role in this update.
    RoleUser[] addedUsers?;
    # Users unassigned from the role in this update.
    RoleUser[] removedUsers?;
};

public type RoleGroupsUpdatedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # Indicates the related identity flow.
    Action action?;
    # Contains details about the role whose group assignments got updated.
    RoleGroupsUpdatedPayloadRole role?;
};

# Contains details about the role whose group assignments got updated.
public type RoleGroupsUpdatedPayloadRole record {
    # Unique identifier of the role.
    string id?;
    # Display name of the role.
    string name?;
    # The audience the role is scoped to.
    RoleAudience audience?;
    # SCIM v2 reference URL for the role.
    string ref?;
    # Local groups assigned to the role in this update.
    RoleGroup[] addedGroups?;
    # Local groups unassigned from the role in this update.
    RoleGroup[] removedGroups?;
};

public type RoleIdpGroupsUpdatedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # Indicates the related identity flow.
    Action action?;
    # Contains details about the role whose IdP group assignments got updated.
    RoleIdpGroupsUpdatedPayloadRole role?;
};

# Contains details about the role whose IdP group assignments got updated.
public type RoleIdpGroupsUpdatedPayloadRole record {
    # Unique identifier of the role.
    string id?;
    # Display name of the role.
    string name?;
    # The audience the role is scoped to.
    RoleAudience audience?;
    # SCIM v2 reference URL for the role.
    string ref?;
    # Federated IdP groups assigned to the role in this update.
    RoleIdpGroup[] addedIdpGroups?;
    # Federated IdP groups unassigned from the role in this update.
    RoleIdpGroup[] removedIdpGroups?;
};

public type RolePermissionsUpdatedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # Indicates the related identity flow.
    Action action?;
    # Contains details about the role whose permissions got updated.
    RolePermissionsUpdatedPayloadRole role?;
};

# Contains details about the role whose permissions got updated.
public type RolePermissionsUpdatedPayloadRole record {
    # Unique identifier of the role.
    string id?;
    # Display name of the role.
    string name?;
    # The audience the role is scoped to.
    RoleAudience audience?;
    # SCIM v2 reference URL for the role.
    string ref?;
    # Permission names granted to the role in this update.
    string[] addedPermissions?;
    # Permission names revoked from the role in this update.
    string[] removedPermissions?;
};

# Login success event. The payload is a Security Event Token (RFC 8417) claim set.
public type LoginSuccessEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataLoginSuccess events;
};

# Login failed event. The payload is a Security Event Token (RFC 8417) claim set.
public type LoginFailedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataLoginFailed events;
};

# Registration success event. The payload is a Security Event Token (RFC 8417) claim set.
public type RegistrationSuccessEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataRegistrationSuccess events;
};

# Registration failed event. The payload is a Security Event Token (RFC 8417) claim set.
public type RegistrationFailedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataRegistrationFailed events;
};

# Access token issued event. The payload is a Security Event Token (RFC 8417) claim set.
public type AccessTokenIssuedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataAccessTokenIssued events;
};

# Access token revoked event. The payload is a Security Event Token (RFC 8417) claim set.
public type AccessTokenRevokedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataAccessTokenRevoked events;
};

# Session established event. The payload is a Security Event Token (RFC 8417) claim set.
public type SessionEstablishedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataSessionEstablished events;
};

# Session presented event. The payload is a Security Event Token (RFC 8417) claim set.
public type SessionPresentedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataSessionPresented events;
};

# Session revoked event. The payload is a Security Event Token (RFC 8417) claim set.
public type SessionRevokedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataSessionRevoked events;
};

# Credential updated event. The payload is a Security Event Token (RFC 8417) claim set.
public type CredentialUpdatedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataCredentialUpdated events;
};

# User created event. The payload is a Security Event Token (RFC 8417) claim set.
public type UserCreatedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataUserCreated events;
};

# User profile updated event. The payload is a Security Event Token (RFC 8417) claim set.
public type UserProfileUpdatedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataUserProfileUpdated events;
};

# User disabled event. The payload is a Security Event Token (RFC 8417) claim set.
public type UserDisabledEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataUserDisabled events;
};

# User enabled event. The payload is a Security Event Token (RFC 8417) claim set.
public type UserEnabledEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataUserEnabled events;
};

# User account locked event. The payload is a Security Event Token (RFC 8417) claim set.
public type UserAccountLockedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataUserAccountLocked events;
};

# User account unlocked event. The payload is a Security Event Token (RFC 8417) claim set.
public type UserAccountUnlockedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataUserAccountUnlocked events;
};

# User deleted event. The payload is a Security Event Token (RFC 8417) claim set.
public type UserDeletedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataUserDeleted events;
};

# Consent added event. The payload is a Security Event Token (RFC 8417) claim set.
public type ConsentAddedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataConsentAdded events;
};

# Consent revoked event. The payload is a Security Event Token (RFC 8417) claim set.
public type ConsentRevokedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataConsentRevoked events;
};

# Purpose version added event. The payload is a Security Event Token (RFC 8417) claim set.
public type PurposeVersionAddedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataPurposeVersionAdded events;
};

# Role created event. The payload is a Security Event Token (RFC 8417) claim set.
public type RoleCreatedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataRoleCreated events;
};

# Role metadata updated event. The payload is a Security Event Token (RFC 8417) claim set.
public type RoleMetaUpdatedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataRoleMetaUpdated events;
};

# Role deleted event. The payload is a Security Event Token (RFC 8417) claim set.
public type RoleDeletedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataRoleDeleted events;
};

# Role users updated event. The payload is a Security Event Token (RFC 8417) claim set.
public type RoleUsersUpdatedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataRoleUsersUpdated events;
};

# Role groups updated event. The payload is a Security Event Token (RFC 8417) claim set.
public type RoleGroupsUpdatedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataRoleGroupsUpdated events;
};

# Role IdP groups updated event. The payload is a Security Event Token (RFC 8417) claim set.
public type RoleIdpGroupsUpdatedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataRoleIdpGroupsUpdated events;
};

# Role permissions updated event. The payload is a Security Event Token (RFC 8417) claim set.
public type RolePermissionsUpdatedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataRolePermissionsUpdated events;
};

# A custom attribute of an organization.
public type OrganizationAttribute record {
    # Name of the attribute.
    string name;
    # Value of the attribute. Absent for a removed attribute.
    string value?;
};

# Attributes added, removed or updated by the operation.
public type OrganizationAttributeChanges record {
    # Attributes added by the operation.
    OrganizationAttribute[] added?;
    # Attributes removed by the operation.
    OrganizationAttribute[] removed?;
    # Attributes updated by the operation.
    OrganizationAttribute[] updated?;
};

# The organization the operation acted on.
public type TargetOrganization record {
    # Unique identifier of the organization.
    string id?;
    # Name of the organization.
    string name?;
    # Unique, human-readable handle of the organization.
    string orgHandle?;
    # The depth of the organization in the hierarchy.
    int depth?;
    # Organization management API reference URL for the organization. Absent once it is deleted.
    string ref?;
};

# The organization that was created.
public type CreatedTargetOrganization record {
    # Unique identifier of the organization.
    string id?;
    # Name of the organization.
    string name?;
    # Unique, human-readable handle of the organization.
    string orgHandle?;
    # The depth of the organization in the hierarchy.
    int depth?;
    # Organization management API reference URL for the organization.
    string ref?;
    # Attributes added, removed or updated by the operation.
    OrganizationAttributeChanges attributes?;
};

# The values the update set. Only the changed values are present.
public type OrganizationUpdatedValues record {
    # The new name of the organization.
    string name?;
    # The new description of the organization.
    string description?;
    # Attributes added, removed or updated by the operation.
    OrganizationAttributeChanges attributes?;
};

# The organization that was updated.
public type UpdatedTargetOrganization record {
    # Unique identifier of the organization.
    string id?;
    # Name of the organization.
    string name?;
    # Unique, human-readable handle of the organization.
    string orgHandle?;
    # The depth of the organization in the hierarchy.
    int depth?;
    # Organization management API reference URL for the organization.
    string ref?;
    # The values the update set. Only the changed values are present.
    OrganizationUpdatedValues updatedValues?;
};

public type OrganizationCreatedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # Indicates the related identity flow.
    Action action?;
    # The organization that was created.
    CreatedTargetOrganization targetOrganization?;
};

# Organization created
public type EventDataOrganizationCreated record {
    # The organization created event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/organization/event-type/organizationCreated"}
    OrganizationCreatedPayload organizationCreated;
};

# Organization created event. The payload is a Security Event Token (RFC 8417) claim set.
public type OrganizationCreatedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataOrganizationCreated events;
};

public type OrganizationUpdatedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # Indicates the related identity flow.
    Action action?;
    # The organization that was updated.
    UpdatedTargetOrganization targetOrganization?;
};

# Organization updated
public type EventDataOrganizationUpdated record {
    # The organization updated event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/organization/event-type/organizationUpdated"}
    OrganizationUpdatedPayload organizationUpdated;
};

# Organization updated event. The payload is a Security Event Token (RFC 8417) claim set.
public type OrganizationUpdatedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataOrganizationUpdated events;
};

public type OrganizationEnabledPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # Indicates the related identity flow.
    Action action?;
    # The organization the operation acted on.
    TargetOrganization targetOrganization?;
};

# Organization enabled
public type EventDataOrganizationEnabled record {
    # The organization enabled event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/organization/event-type/organizationEnabled"}
    OrganizationEnabledPayload organizationEnabled;
};

# Organization enabled event. The payload is a Security Event Token (RFC 8417) claim set.
public type OrganizationEnabledEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataOrganizationEnabled events;
};

public type OrganizationDisabledPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # Indicates the related identity flow.
    Action action?;
    # The organization the operation acted on.
    TargetOrganization targetOrganization?;
};

# Organization disabled
public type EventDataOrganizationDisabled record {
    # The organization disabled event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/organization/event-type/organizationDisabled"}
    OrganizationDisabledPayload organizationDisabled;
};

# Organization disabled event. The payload is a Security Event Token (RFC 8417) claim set.
public type OrganizationDisabledEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataOrganizationDisabled events;
};

public type OrganizationDeletedPayload record {
    # Indicates the persona who initiates the identity flow.
    InitiatorType initiatorType?;
    # Indicates the IP address of the initiator that triggered the event.
    InitiatorIpAddress initiatorIpAddress?;
    # Root organization (tenant).
    Tenant tenant?;
    # The organization under which the event is processed.
    Organization organization?;
    # Indicates the related identity flow.
    Action action?;
    # The organization the operation acted on.
    TargetOrganization targetOrganization?;
};

# Organization deleted
public type EventDataOrganizationDeleted record {
    # The organization deleted event data.
    @jsondata:Name {value: "https://schemas.identity.wso2.org/events/organization/event-type/organizationDeleted"}
    OrganizationDeletedPayload organizationDeleted;
};

# Organization deleted event. The payload is a Security Event Token (RFC 8417) claim set.
public type OrganizationDeletedEvent record {
    # Identifies the WSO2 Identity Server instance that issued the event.
    string iss;
    # A unique identifier for the event.
    string jti;
    # Timestamp showing when WSO2 Identity Server issues the event. Epoch milliseconds.
    int iat;
    # A unique identifier that correlates the event with the original request that triggered it.
    string rci;
    # The event, keyed by its event type URI.
    EventDataOrganizationDeleted events;
};
