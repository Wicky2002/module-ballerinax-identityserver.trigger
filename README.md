# Ballerina Identityserver.trigger connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-identityserver.trigger/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-identityserver.trigger/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-identityserver.trigger.svg)](https://github.com/ballerina-platform/module-ballerinax-identityserver.trigger/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/identityserver.trigger.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Fidentityserver.trigger)

## Overview

The WSO2 Identity Server Trigger module allows you to listen to the webhook events of
[WSO2 Identity Server](https://wso2.com/identity-server/) and
[Asgardeo](https://wso2.com/asgardeo/): logins, registrations, tokens, sessions, credentials,
users, consents, roles and organizations.

This module receives the webhook deliveries directly - it does not call the Identity Server or
Asgardeo APIs on your behalf.

### Key features

- Receives 32 events across 10 service types, from logins and user changes to role and organization changes
- One trigger for both products: verifies the `sha256=<hex>` signature in Identity Server's `x-wso2-event-signature` or Asgardeo's `x-hub-signature`, with the webhook secret
- Answers Asgardeo's WebSub subscription check (`GET` with `hub.challenge`) itself, so activating the webhook needs no code
- Typed payload records following the Security Event Token (RFC 8417) format of the deliveries
- Acknowledges each delivery before running your handler, so a slow or failing handler doesn't cause retries
- Services can be attached on their own path, so several triggers and HTTP services can share one port
- Trigger services are listed by `bal build --export-endpoints` (Ballerina 2201.13.6 or later)

## Setup guide

Before using this trigger in your Ballerina application, you need a WSO2 Identity Server (7.2 or
later) or an Asgardeo organization where you can manage webhooks, and a Ballerina service that the
server can reach over the network to deliver events to. The two sections below cover both a quick
local test setup and a production deployment.

### Try it out locally

Use this flow to test your event handling logic on your own machine before deploying anywhere. For
Asgardeo, or an Identity Server that runs elsewhere, use [ngrok](https://ngrok.com/) to expose your
local listener to the internet. An Identity Server running on the same machine can call
`http://localhost:8090` directly.

1. Write your service (see [Quickstart](#quickstart) below) with a secret of your choice as
   `webhookSecret`, and run it with `bal run`. Note the port it's listening on (`8090` by
   default).

2. If the server can't reach your machine directly, expose the port with ngrok:

   ```bash
   ngrok http 8090
   ```

   Copy the `Forwarding` URL ngrok prints out - this is your temporary public endpoint.

   <img src="https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-identityserver.trigger/main/docs/setup/resources/ngrok-forwarding.png" alt="ngrok forwarding a public URL to localhost:8090" width="600">

3. In the Identity Server or Asgardeo Console, go to **Webhooks** and click **Add Webhook**. (The
   screenshots are from Asgardeo; the Identity Server Console has the same pages.)

   <img src="https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-identityserver.trigger/main/docs/setup/resources/webhook-settings-page.png" alt="Webhooks page in the Asgardeo Console" width="600">

4. Fill in the webhook:
   - **Name**: any descriptive name.
   - **Endpoint**: the URL from step 1 or 2.
   - **Secret**: the same value as `webhookSecret` in your service. The server signs every delivery
     with it, and the listener rejects requests that don't carry a matching signature.
   - Leave **Active** on, or turn it on later from the webhook list.

   <img src="https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-identityserver.trigger/main/docs/setup/resources/webhook-form-filled.png" alt="Add Webhook form with the name, the ngrok endpoint and the secret" width="600">

5. Under **Select Events**, tick the events your service handles, for example **Logins** for
   `LoginService` or **User account management** for `UserService`, and click **Create**.

   <img src="https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-identityserver.trigger/main/docs/setup/resources/webhook-event-selection.png" alt="Select Events list with Logins and Registrations ticked" width="600">

6. The webhook is listed as **Active**. When it's activated, Asgardeo sends a `GET` verification
   request for each subscribed event type; the listener answers it, so your service must be
   running at that point. If it wasn't, turn the webhook off and on again to resend the requests.

   <img src="https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-identityserver.trigger/main/docs/setup/resources/webhook-activated.png" alt="Webhook list showing the webhook as Active" width="600">

7. Trigger an event, for example by signing in to an application in the organization. Each request
   shows up in the ngrok console with `200 OK`, and your handler runs for each event.

   <img src="https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-identityserver.trigger/main/docs/setup/resources/webhook-confirmed.png" alt="ngrok console showing a request to the listener answered with 200 OK" width="600">

See [Set up webhooks](https://is.docs.wso2.com/en/latest/guides/webhooks/setup-webhooks/) and
[Webhook events and payloads](https://is.docs.wso2.com/en/latest/guides/webhooks/webhook-events-and-payloads/)
for the server side.

### Production / business integration

For production use, deploy your Ballerina service somewhere the server can reach over HTTPS.
Ballerina doesn't require any specific hosting platform - containers, a VM, a managed PaaS, or
anything else that gives you a stable HTTPS endpoint all work equally well.

Rather than hardcoding `webhookSecret` as shown in the Quickstart, inject it via `Config.toml` (or
your platform's equivalent configuration/secret mechanism), since it's a `configurable` value:

```toml
[<your_org>.<your_module_name>.userInput]
webhookSecret = "<your webhook secret>"
```

Then set your production URL as the webhook's **Endpoint** in the Console.

### Compatibility

|                     | Version                       |
|---------------------|-------------------------------|
| Ballerina Language  | Ballerina Swan Lake 2201.13.0 |
| WSO2 Identity Server | 7.2.0 or later               |

Identity Server 7.2 delivers 17 of the events and 7.3 delivers 20; role, consent and organization
events need newer versions. Asgardeo delivers all of them.

## Quickstart

To use the WSO2 Identity Server Trigger in your Ballerina application, update the `.bal` file as
follows:

### Step 1: Import the WSO2 Identity Server Trigger Ballerina library

```ballerina
import ballerinax/identityserver.trigger as wso2is;
```

### Step 2: Initialize the WSO2 Identity Server Listener

Initialize the trigger by providing the listener config and a port number/`http:Listener` object.

```ballerina
configurable wso2is:ListenerConfig userInput = {
    webhookSecret: "xxxxxx"
};
listener wso2is:Listener isListener = new (userInput, 8090);
```

`webhookSecret` should always be set to the secret configured on the webhook in the Console - this
is what the trigger uses to verify incoming events actually came from your server. Without it, the
listener rejects every request with `401 Unauthorized`.

If you don't provide a port it will use the default port, which is 8090.

```ballerina
listener wso2is:Listener isListener = new (userInput);
```

### Step 3: Use the correct service type to implement the service

Use the correct service type for the event category you subscribed to. For example, for **Logins**
use the `LoginService` service type. Every remote function declared on a service type must be
implemented - Ballerina requires a complete implementation, not just the ones you care about.

```ballerina
service wso2is:LoginService on isListener {

    remote function onLoginSuccess(wso2is:LoginSuccessEvent payload) returns error? {
        return;
    }

    remote function onLoginFailed(wso2is:LoginFailedEvent payload) returns error? {
        return;
    }
}
```

### Step 4: Provide remote functions corresponding to the events you're interested in

Remote functions must be implemented inside a service, on the matching service type for the event
category - for example, `wso2is:UserService` for user events.

```ballerina
import ballerina/log;

service wso2is:LoginService on isListener {

    remote function onLoginSuccess(wso2is:LoginSuccessEvent payload) returns error? {
        wso2is:LoginSuccessPayload login = payload.events.loginSuccess;
        log:printInfo("Login succeeded", userId = login.user?.id, ip = login?.initiatorIpAddress);
    }

    remote function onLoginFailed(wso2is:LoginFailedEvent payload) returns error? {
        wso2is:LoginFailedPayload login = payload.events.loginFailed;
        log:printWarn("Login failed", userId = login.user?.id, reason = login.reason?.description);
    }
}
```

### Step 5: Run the service

Use the `bal run` command to compile and run the Ballerina program.

### Step 6: Register a webhook so the server can reach your service

See [Setup guide](#setup-guide) above for the full walkthrough of exposing your service and
registering the webhook, for both local testing and production use.

## Examples

The `identityserver.trigger` module provides practical examples illustrating usage in various
scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-identityserver.trigger/tree/main/examples/),
covering common event handling use cases.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/), **2201.13.0 or later**.

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`identityserver.trigger` package](https://central.ballerina.io/ballerinax/identityserver.trigger/latest).
* If you're moving from the older `trigger.asgardeo` package, see the [migration notes](docs/migration-notes.md).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.