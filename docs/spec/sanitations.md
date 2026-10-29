_Author_:  Dinuka Wickramasinghe \
_Created_: 2026-10-06 \
_Updated_: 2026-10-29 \
_Edition_: Swan Lake

# Sanitation for AsyncAPI specification

This document records how the Identity Server trigger's AsyncAPI specification (`asyncapi.yaml`, this directory) was derived from the published webhook contract, and the one hand edit the generated code needs.

## Source

`wso2/docs-is`, `en/identity-server/next/docs/references/webhooks/api/webhook-events-v1.yaml` (OpenAPI 3.1), checked against the setup and event guides at https://is.docs.wso2.com/en/next/guides/webhooks/ on 2026-10-26. The same contract is published for Asgardeo (`en/asgardeo/...`); the Identity Server and Asgardeo teams confirmed that one trigger is meant to serve both products.

### One spec for Identity Server and Asgardeo

The two contracts were compared after resolving every `$ref`. They have the same events and payloads; the differences are:

1. **Signature header.** Both send `sha256=<hex>`, an HMAC-SHA256 of the raw body keyed with the webhook secret, but Identity Server puts it in `x-wso2-event-signature` and Asgardeo in `x-hub-signature`. The Identity Server team confirmed this is intentional: Asgardeo delivers through a WebSub hub, and WebSub requires `X-Hub-Signature`; Identity Server delivers with its own publisher. See [Hand edit](#hand-edit) for how the trigger accepts both.
2. **WebSub verification.** Asgardeo's contract documents a `GET` that verifies the subscription before delivering; Identity Server's does not. The listener answers it either way.
3. `rci` is required in Asgardeo's envelope and optional in Identity Server's; example hostnames differ.

Older Identity Server versions are strict subsets (7.3.0 has 20 events, 7.2.0 has 17, and both lack `initiatorIpAddress`). Every field they lack is optional here, so this spec binds payloads from all of them.

## Changes made

1. Converted OpenAPI 3.1 to AsyncAPI 3.0.0. The ten event categories (login, registration, token, session, credential, user, consent, consent purpose, role, organization) are channels with `action: receive` operations, and each of the 32 events is a message.
2. Each message carries the event URI as `x-ballerina-event-type` and a readable `x-ballerina-event-label` (for example `LoginSuccess`), so handlers come out as `onLoginSuccess` rather than a name derived from the URI.
3. The event is identified by the single key under `events`, which is the event URI: `x-ballerina-event-identifier: {type: body-key, path: events}` (ballerina-library#9259).
4. The OpenAPI `WebhookEvent` `oneOf` envelope was split into one payload schema per event (`LoginSuccessEvent`, ...), each with the envelope fields (`iss`, `jti`, `iat`, `rci`, `events`) and its own `EventData_*` object. The URI-named keys of `EventData_*` become fields such as `loginSuccess` with `@jsondata:Name` (ballerina-library#9260).
5. The WebSub subscription check is a `receive` operation with a `reply` on `GET`: the listener answers `GET /?hub.mode=...&hub.topic=...&hub.challenge=...` by echoing `hub.challenge`. `hub.mode` is `subscribe` or `unsubscribe`.
6. Added the five organization events (`organizationCreated`, `organizationUpdated`, `organizationEnabled`, `organizationDisabled`, `organizationDeleted`) from the Identity Server event guide, with their payload schemas. They are newer than the published `webhook-events-v1.yaml`, which does not list them yet (checked 2026-10-29); the Identity Server team said the contract will be updated. Re-check these schemas against it when it is.
7. Declared `x-ballerina-auth` with `x-wso2-event-signature` as the header.
8. Wording changed from "WSO2 Identity Platform" to "WSO2 Identity Server", and every field has a description, so the generated records are fully documented.

All other component schemas are carried over unchanged.

## Hand edit

`x-ballerina-auth` takes a single header; a list of headers is not supported (released tool versions silently drop signature verification when given one). So the spec declares Identity Server's `x-wso2-event-signature`, and `ballerina/dispatcher_service.bal` is edited by hand to fall back to Asgardeo's `x-hub-signature`.

**Re-apply this after every regeneration.** In `verifyWebhookSignature`, replace:

```ballerina
        if !request.hasHeader("x-wso2-event-signature") {
            return error("Unauthorized: Missing Signature Header");
        }
        string receivedHeader = check request.getHeader("x-wso2-event-signature");
```

with:

```ballerina
        // Hand-written, re-apply after regenerating (docs/spec/sanitations.md): Asgardeo sends the signature in x-hub-signature.
        string signatureHeader = request.hasHeader("x-wso2-event-signature") ? "x-wso2-event-signature" : "x-hub-signature";
        if !request.hasHeader(signatureHeader) {
            return error("Unauthorized: Missing Signature Header");
        }
        string receivedHeader = check request.getHeader(signatureHeader);
```

`ballerina/tests/signature_header_test.bal` (hand-written, not generated) checks the edit: a delivery signed in `x-hub-signature` is dispatched, a wrong signature in it is rejected, and a request with neither header is rejected. If the edit is lost in a regeneration, these tests fail.

## Test payloads

The 32 files under `ballerina/tests/resources/trigger_payloads` are the example payloads from the Identity Server event guide, one per event, with the guide's placeholders filled in: `{{server_url}}` and `{{host_url}}` as `https://localhost:9443/t/myorg.com`, `{{tenant_domain}}` as `myorg.com` and `{{userstore_domain}}` as `PRIMARY`. Each was checked against its schema in this spec with no mismatches. The `registrationFailed` example in the guide has a trailing comma, which was removed.

## Not carried over

The `Registrations`, `User_Operations`, `Logins` and `Notifications` triggers of the `asyncapi-triggers` monorepo (`trigger.asgardeo`, 11 URN events whose payloads were encrypted and decrypted by a native jar) use an older Asgardeo mechanism. They are not part of this spec.

## Ballerina trigger generation

From the repository root:

```bash
bal asyncapi docs/spec/asyncapi.yaml --protocol http --with-tests -o ballerina/
```

Then re-apply the [hand edit](#hand-edit) and run `bal test` in `ballerina/`.
