# Role change audit

Write one audit line per role change: which role, what kind of change, the kind of actor that made it (the events carry `initiatorType`, not the person), and how many users, groups or permissions were added or removed.

## Run

Put the webhook's secret in a `Config.toml` in this directory:

```toml
[ballerina_example.role_change_audit.config]
webhookSecret = "<the webhook secret>"
```

Then run:

```bash
bal run
```

Then follow the [Setup guide](../../ballerina/README.md#setup-guide) in the package README to
expose this listener and add a webhook subscribed to the role events.
