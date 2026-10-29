# Role change audit

Write one audit line per role change: which role, what kind of change, who made it, and how many users, groups or permissions were added or removed.

## Run

```bash
bal run
```

Then follow the [Setup guide](../../ballerina/README.md#setup-guide) in the package README to
expose this listener and add a webhook subscribed to the role events.
