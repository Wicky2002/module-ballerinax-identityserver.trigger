# User lifecycle logger

Log each change in a user's lifecycle (created, profile updated, disabled, enabled, locked, unlocked and deleted) with who made it. A starting point for keeping a downstream directory or HR system in sync.

## Run

```bash
bal run
```

Then follow the [Setup guide](../../ballerina/README.md#setup-guide) in the package README to
expose this listener and add a webhook subscribed to the user events.
