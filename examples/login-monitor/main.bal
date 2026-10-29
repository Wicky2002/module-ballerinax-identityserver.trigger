import ballerina/log;
import ballerinax/identityserver.trigger as wso2is;

// webhookSecret is the secret set on the webhook in the Console, read from Config.toml.
configurable wso2is:ListenerConfig config = ?;

listener wso2is:Listener isListener = new (config, 8090);

// Logs successful logins and raises a warning with the reason for each failed one.
service wso2is:LoginService on isListener {

    remote function onLoginSuccess(wso2is:LoginSuccessEvent payload) returns error? {
        wso2is:LoginSuccessPayload login = payload.events.loginSuccess;
        log:printInfo("Login succeeded", userId = login.user?.id, organization = login.organization?.name,
                ip = login?.initiatorIpAddress, methods = login.authenticationMethods);
    }

    remote function onLoginFailed(wso2is:LoginFailedEvent payload) returns error? {
        wso2is:LoginFailedPayload login = payload.events.loginFailed;
        log:printWarn("Login failed", userId = login.user?.id, organization = login.organization?.name,
                ip = login?.initiatorIpAddress, reason = login.reason?.description);
    }
}