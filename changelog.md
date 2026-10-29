# Changelog
This file contains all the notable changes done to the Ballerina WSO2 Identity Server trigger through the releases.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- The `identityserver.trigger` package for the webhooks of WSO2 Identity Server and Asgardeo, replacing `trigger.asgardeo` from the `asyncapi-triggers` monorepo. It is generated from the AsyncAPI definition in `docs/spec` with the Ballerina AsyncAPI tool and covers 32 events. See the [migration notes](docs/migration-notes.md) for what changed from `trigger.asgardeo`.
- Signature verification of every delivery (`sha256=<hex>`, HMAC-SHA256 with the webhook secret) in Identity Server's `x-wso2-event-signature` or Asgardeo's `x-hub-signature`. Accepting the second header is a hand edit to the generated code, recorded in `docs/spec/sanitations.md`.
- The listener answers Asgardeo's WebSub subscription check (`GET` with `hub.challenge`) itself.
- Services on the trigger listener are listed by `bal build --export-endpoints`, through a compiler plugin packaged with the trigger. Endpoint export needs Ballerina 2201.13.6 or later.
- Trigger metadata and icons under `metadata/` for low-code tooling.
