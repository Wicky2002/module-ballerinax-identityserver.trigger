_Author_:  Dinuka Wickramasinghe \
_Created_: 2026-10-06 \
_Updated_: 2026-10-06 \
_Edition_: Swan Lake

# Sanitation for AsyncAPI specification

This document records how the Asgardeo trigger's AsyncAPI specification (`asyncapi.yaml`, this directory) was derived from the WSO2 Identity Platform's published webhook contract, and what the generator still needs before it can produce the package from it.

## Source

`wso2/docs-is`, `en/asgardeo/docs/references/webhooks/api/webhook-events-v1.yaml` (OpenAPI 3.1, 27 events), checked against the guides at https://is.docs.wso2.com/en/next/guides/webhooks/webhook-events-and-payloads/ and https://wso2.com/identity-platform/docs/guides/webhooks/setup-webhooks/ on 2026-10-06. The Asgardeo team confirmed in their thread that these specs are current, that one connector is enough for both products, and that Organization and Group management events are still to come.

### One spec for Asgardeo and Identity Server

The Asgardeo spec and the Identity Server `next` spec were compared after resolving every `$ref`:

| | Asgardeo | IS `next` | IS 7.3.0 | IS 7.2.0 |
|---|---|---|---|---|
| Events | 27 | 27 (identical set) | 20 | 17 |
| Payload fields | all | identical | lacks `initiatorIpAddress` on 20 events, no role events | lacks `initiatorIpAddress` on 17 events, no role or consent events |

Differences between Asgardeo and IS `next` are only: (1) Asgardeo documents the WebSub `GET` verification; IS `next` does not. (2) `rci` is required in Asgardeo's envelope, optional in IS `next`. (3) Example hostnames. The older IS versions are strict subsets: nothing exists in IS that Asgardeo lacks, and every field is optional, so this spec binds payloads from all of them.

## Changes made

1. Converted OpenAPI 3.1 to AsyncAPI 3.0.0: the nine event categories (login, registration, token, session, credential, user, consent, consentPurpose, role) are channels with `action: receive` operations, and each of the 27 events is a message.
2. Each message carries the event URI as `x-ballerina-event-type` and a readable `x-ballerina-event-label` (for example `LoginSuccess`), so handlers come out as `onLoginSuccess` rather than a name derived from the URI.
3. The OpenAPI `WebhookEvent` `oneOf` envelope was split into one payload schema per event (`LoginSuccessEvent`, ...), each with the envelope fields (`iss`, `jti`, `iat`, `rci`, `events`) and its own `EventData_*` object. A handler receives the whole delivery, as for the other triggers.
4. Declared `x-ballerina-auth` for `x-hub-signature: sha256=<hex>`, an HMAC-SHA256 of the raw body keyed with the webhook secret (setup guide).
5. The OpenAPI `GET` verification operation is described in the document description, not modelled as an operation (see below).

All other component schemas are carried over unchanged.

## What the generator still needs

Verified with `bal asyncapi http` (asyncapi-tools, `architecture-refactor` plus open PRs): with the three items below worked around in a scratch copy, all 27 events and 9 service types generate and `bal build` passes. Without them this spec cannot be generated.

1. **Event identified by a key, not a value.** Each delivery has exactly one key under `events` (`maxProperties: 1`), and that key is the event URI. The identifier extractor supports `header`, `body` and `composite`, all of which read a value at a path. The spec uses a proposed `type: body-key` with `path: events`, meaning "the key of the object at `path`". URIs contain dots, so a dot-notation path cannot address them either.
2. **Property names that are not identifiers.** The `EventData_*` records are keyed by URIs. The generator emits them verbatim (`AccessTokenIssuedPayload https://schemas.identity.wso2.org/...;`) and, because the name contains a hyphen, annotates the field `@http:Header`. The build fails with `invalid token ':'`. Needed: a sanitised field name (for example `accessTokenIssued`) carrying `@jsondata:Name {value: "<uri>"}`.
3. **WebSub verification handshake.** Before delivering, the platform sends `GET /?hub.mode=subscribe&hub.topic=...&hub.challenge=...` per subscribed event type; the endpoint must return 2xx with the exact `hub.challenge` in the body. The generated listener has no `GET` handling, so subscription would never be confirmed. Slack's `url_verification` is the same kind of problem.

## Not carried over

The `Registrations`, `User_Operations`, `Logins` and `Notifications` triggers in the `asyncapi-triggers` monorepo (11 URN events, payloads encrypted and decrypted by a native jar) use an older mechanism. They are not part of this spec; whether the old trigger is retired is a decision for the team.

## Ballerina trigger generation

Once the generator supports the items above, from the repository root:

```bash
bal asyncapi http -i docs/spec/asyncapi.yaml -o ballerina/
```
