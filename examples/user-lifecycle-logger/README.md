# User lifecycle logger

Log each change in a user's lifecycle (created, profile updated, disabled, enabled, locked, unlocked and deleted) and the kind of actor that made it (user, admin, application or system; the events don't name the person). A starting point for keeping a downstream directory or HR system in sync.

## Run

Put the webhook's secret in a `Config.toml` in this directory:

```toml
[ballerina_example.user_lifecycle_logger.config]
webhookSecret = "<the webhook secret>"
```

Then run:

```bash
bal run
```

Then follow the [Setup guide](../../ballerina/README.md#setup-guide) in the package README to
expose this listener and add a webhook subscribed to the user events.
