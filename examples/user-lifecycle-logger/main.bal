import ballerina/log;
import ballerinax/identityserver.trigger as wso2is;

configurable wso2is:ListenerConfig config = {
    webhookSecret: "xxxxxx"
};

listener wso2is:Listener isListener = new (config, 8090);

// Logs each change in a user's lifecycle, a starting point for keeping a downstream directory in sync.
service wso2is:UserService on isListener {

    remote function onUserCreated(wso2is:UserCreatedEvent payload) returns error? {
        logUserChange("created", payload.events.userCreated.user?.id, payload.events.userCreated?.initiatorType);
    }

    remote function onUserProfileUpdated(wso2is:UserProfileUpdatedEvent payload) returns error? {
        logUserChange("profile updated", payload.events.userProfileUpdated.user?.id,
                payload.events.userProfileUpdated?.initiatorType);
    }

    remote function onUserDisabled(wso2is:UserDisabledEvent payload) returns error? {
        logUserChange("disabled", payload.events.userDisabled.user?.id, payload.events.userDisabled?.initiatorType);
    }

    remote function onUserEnabled(wso2is:UserEnabledEvent payload) returns error? {
        logUserChange("enabled", payload.events.userEnabled.user?.id, payload.events.userEnabled?.initiatorType);
    }

    remote function onUserAccountLocked(wso2is:UserAccountLockedEvent payload) returns error? {
        logUserChange("locked", payload.events.userAccountLocked.user?.id, payload.events.userAccountLocked?.initiatorType);
    }

    remote function onUserAccountUnlocked(wso2is:UserAccountUnlockedEvent payload) returns error? {
        logUserChange("unlocked", payload.events.userAccountUnlocked.user?.id,
                payload.events.userAccountUnlocked?.initiatorType);
    }

    remote function onUserDeleted(wso2is:UserDeletedEvent payload) returns error? {
        logUserChange("deleted", payload.events.userDeleted.user?.id, payload.events.userDeleted?.initiatorType);
    }
}

function logUserChange(string change, string? userId, wso2is:InitiatorType initiatorType) {
    log:printInfo("User " + change, userId = userId, initiator = initiatorType);
}