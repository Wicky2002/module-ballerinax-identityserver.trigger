# Login monitor

The minimal, canonical `identityserver.trigger` use case: log every successful login, and raise a warning with the reason and IP address for each failed one.

## Run

```bash
bal run
```

Then follow the [Setup guide](../../ballerina/README.md#setup-guide) in the package README to
expose this listener and add a webhook subscribed to the login events.
