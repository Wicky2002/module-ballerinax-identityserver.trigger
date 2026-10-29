# Login monitor

The minimal, canonical `identityserver.trigger` use case: log every successful login, and raise a warning with the reason and IP address for each failed one.

## Run

Put the webhook's secret in a `Config.toml` in this directory:

```toml
[ballerina_example.login_monitor.config]
webhookSecret = "<the webhook secret>"
```

Then run:

```bash
bal run
```

Then follow the [Setup guide](../../ballerina/README.md#setup-guide) in the package README to
expose this listener and add a webhook subscribed to the login events.
