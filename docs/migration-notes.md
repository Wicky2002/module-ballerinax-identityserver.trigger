# Migration notes: from `trigger.asgardeo` to `identityserver.trigger`

`ballerinax/identityserver.trigger` replaces `ballerinax/trigger.asgardeo` (0.8.0 in the
`asyncapi-triggers` monorepo). The `ballerina/` source is generated from `docs/spec/asyncapi.yaml`
with the `asyncapi-tools` generator, plus one hand edit that is recorded, with how to re-apply it,
in [`docs/spec/sanitations.md`](spec/sanitations.md).

This is a replacement more than an upgrade: `trigger.asgardeo` used Asgardeo's older event
mechanism, and this package uses the webhooks that WSO2 Identity Server and Asgardeo offer today.

## Breaking change: package name and import

```ballerina
// before
import ballerinax/trigger.asgardeo;

// after
import ballerinax/identityserver.trigger as wso2is;
```

## Breaking change: configuration

`trigger.asgardeo` subscribed itself to Asgardeo's hub with an OAuth client and decrypted each
payload with a key it fetched from Asgardeo, so its listener needed
`clientId`, `clientSecret`, `organization`, `tokenEndpointHost`, `callbackURL`, `hubURL` and
`keyServiceURL`.

The webhooks this package receives are created in the Console (**Webhooks > Add Webhook**), arrive
unencrypted, and are signed with a secret you choose there. The listener needs only that secret:

```ballerina
// before
listener asgardeo:Listener asgardeoListener = new ({
    clientId: "...", clientSecret: "...", organization: "...", tokenEndpointHost: "...",
    callbackURL: "...", hubURL: "...", keyServiceURL: "..."
});

// after
listener wso2is:Listener isListener = new ({webhookSecret: "<webhook secret>"}, 8090);
```

## Breaking change: events and handlers

The events are different, so handlers have to be rewritten. The closest equivalents:

| `trigger.asgardeo` | `identityserver.trigger` |
|--------------------|--------------------------|
| `LoginService.onLoginSuccess` | `LoginService.onLoginSuccess` |
| `LoginService.onLoginFailed` | `LoginService.onLoginFailed` |
| `RegistrationService.onAddUser` | `UserService.onUserCreated` |
| `RegistrationService.onConfirmSelfSignup` | `RegistrationService.onRegistrationSuccess` |
| `UserOperationService.onLockUser` | `UserService.onUserAccountLocked` |
| `UserOperationService.onUnlockUser` | `UserService.onUserAccountUnlocked` |
| `UserOperationService.onUpdateUserCredentials` | `CredentialService.onCredentialUpdated` |
| `UserOperationService.onDeleteUser` | `UserService.onUserDeleted` |
| `RegistrationService.onAcceptUserInvite` | no equivalent event |
| `UserOperationService.onUpdateUserGroup` | no equivalent event yet (group events are planned) |
| `NotificationService.onSmsOtp` | no equivalent event |

Even where the names match, the payloads differ: each delivery is now a Security Event Token
(RFC 8417) with `iss`, `jti`, `iat`, `rci` and an `events` object keyed by the event's URI, for
example `payload.events.loginSuccess`.

## New events

Registration failures, access tokens, sessions, user profile, enable and disable, consents,
consent purposes, roles and organizations are new. See the
[Webhook events and payloads](https://is.docs.wso2.com/en/latest/guides/webhooks/webhook-events-and-payloads/)
guide for when each is sent.

## Test suite

`ballerina/tests` sends each of the 32 events, using the example payload from the Identity Server
event guide, as a signed request to a test listener and checks the right remote function runs. It
also checks the WebSub subscription check and the `x-hub-signature` fallback. `bal test`: 37/37
passing.
