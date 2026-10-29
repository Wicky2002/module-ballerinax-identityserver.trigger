import ballerina/log;
import ballerinax/identityserver.trigger as wso2is;

// webhookSecret is the secret set on the webhook in the Console, read from Config.toml.
configurable wso2is:ListenerConfig config = ?;

listener wso2is:Listener isListener = new (config, 8090);

// Writes one audit line per role change: which role, the kind of actor, and what was added or removed.
service wso2is:RoleService on isListener {

    remote function onRoleCreated(wso2is:RoleCreatedEvent payload) returns error? {
        wso2is:RoleCreatedPayload event = payload.events.roleCreated;
        audit("created", event.role?.id, event.role?.name, event?.initiatorType, payload.iat);
    }

    remote function onRoleMetaUpdated(wso2is:RoleMetaUpdatedEvent payload) returns error? {
        wso2is:RoleMetaUpdatedPayload event = payload.events.roleMetaUpdated;
        audit("renamed or updated", event.role?.id, event.role?.name, event?.initiatorType, payload.iat);
    }

    remote function onRoleDeleted(wso2is:RoleDeletedEvent payload) returns error? {
        wso2is:RoleDeletedPayload event = payload.events.roleDeleted;
        audit("deleted", event.role?.id, event.role?.name, event?.initiatorType, payload.iat);
    }

    remote function onRoleUsersUpdated(wso2is:RoleUsersUpdatedEvent payload) returns error? {
        wso2is:RoleUsersUpdatedPayload event = payload.events.roleUsersUpdated;
        audit("users changed", event.role?.id, event.role?.name, event?.initiatorType, payload.iat,
                added = (event.role?.addedUsers ?: []).length(), removed = (event.role?.removedUsers ?: []).length());
    }

    remote function onRoleGroupsUpdated(wso2is:RoleGroupsUpdatedEvent payload) returns error? {
        wso2is:RoleGroupsUpdatedPayload event = payload.events.roleGroupsUpdated;
        audit("groups changed", event.role?.id, event.role?.name, event?.initiatorType, payload.iat,
                added = (event.role?.addedGroups ?: []).length(), removed = (event.role?.removedGroups ?: []).length());
    }

    remote function onRoleIdpGroupsUpdated(wso2is:RoleIdpGroupsUpdatedEvent payload) returns error? {
        wso2is:RoleIdpGroupsUpdatedPayload event = payload.events.roleIdpGroupsUpdated;
        audit("identity provider groups changed", event.role?.id, event.role?.name, event?.initiatorType, payload.iat,
                added = (event.role?.addedIdpGroups ?: []).length(),
                removed = (event.role?.removedIdpGroups ?: []).length());
    }

    remote function onRolePermissionsUpdated(wso2is:RolePermissionsUpdatedEvent payload) returns error? {
        wso2is:RolePermissionsUpdatedPayload event = payload.events.rolePermissionsUpdated;
        audit("permissions changed", event.role?.id, event.role?.name, event?.initiatorType, payload.iat,
                added = (event.role?.addedPermissions ?: []).length(),
                removed = (event.role?.removedPermissions ?: []).length());
    }
}

function audit(string change, string? roleId, string? roleName, wso2is:InitiatorType initiator, int at, int added = 0,
        int removed = 0) {
    log:printInfo("Role audit", change = change, roleId = roleId, roleName = roleName, initiator = initiator, at = at,
            added = added, removed = removed);
}