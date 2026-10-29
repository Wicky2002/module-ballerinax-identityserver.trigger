// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/crypto;
import ballerina/http;
import ballerina/io;
import ballerina/test;

// Covers the hand-written signature header fallback (docs/spec/sanitations.md): Identity Server signs in
// x-wso2-event-signature and Asgardeo in x-hub-signature, with the same value.

function sendWithHeader(string headerName, string eventIdentifier, string secret) returns http:Response|error {
    byte[] body = check io:fileReadBytes(string `${TRIGGER_PAYLOAD_DIR}/${eventIdentifier}.json`);
    string signature = (check crypto:hmacSha256(body, secret.toBytes())).toBase16();
    return triggerClient->post("/", body, {[headerName]: string `sha256=${signature}`}, "application/json");
}

@test:Config {}
function testAsgardeoSignatureHeaderIsAccepted() returns error? {
    lock {
        triggerFired.removeAll();
    }
    http:Response response = check sendWithHeader("x-hub-signature", "loginSuccess", TRIGGER_TEST_SECRET);
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertTrue(waitForDispatch("LoginService.onLoginSuccess"),
            "an event signed in x-hub-signature should be dispatched");
}

@test:Config {}
function testWrongSignatureInAsgardeoHeaderIsRejected() returns error? {
    http:Response response = check sendWithHeader("x-hub-signature", "loginSuccess", "another-secret");
    test:assertEquals(response.statusCode, http:STATUS_UNAUTHORIZED);
}

@test:Config {}
function testRequestWithoutEitherHeaderIsRejected() returns error? {
    byte[] body = check io:fileReadBytes(string `${TRIGGER_PAYLOAD_DIR}/loginSuccess.json`);
    http:Response response = check triggerClient->post("/", body, (), "application/json");
    test:assertEquals(response.statusCode, http:STATUS_UNAUTHORIZED);
}
