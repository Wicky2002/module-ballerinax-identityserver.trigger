# Examples

The `ballerinax/identityserver.trigger` connector provides practical examples illustrating usage in various scenarios.

1. [Login monitor](https://github.com/ballerina-platform/module-ballerinax-identityserver.trigger/tree/main/examples/login-monitor) - Log logins and warn on each failed one with its reason.
2. [User lifecycle logger](https://github.com/ballerina-platform/module-ballerinax-identityserver.trigger/tree/main/examples/user-lifecycle-logger) - Log users being created, changed, locked and deleted.
3. [Role change audit](https://github.com/ballerina-platform/module-ballerinax-identityserver.trigger/tree/main/examples/role-change-audit) - One audit line per role change.

## Prerequisites

Add a webhook in the WSO2 Identity Server or Asgardeo Console with the same secret as the example's `webhookSecret`, pointing at the running example, as described in the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-identityserver.trigger/blob/main/ballerina/README.md#setup-guide).

## Running an example

Execute the following commands from an example's directory (for example `cd login-monitor`) to build it from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
