import ballerina/test;
import ballerina/http;

@test:Config {}
function testGetCase() returns error? {
    http:Client testClient = check new ("http://localhost:9099/api/salesforce");
    record {}|error response = check testClient->/case(caseId = "5003h000001yZSCAA2");
    test:assertTrue(response is record {});
}

@test:Config {}
function testInsertCase() returns error? {
    http:Client testClient = check new ("http://localhost:9099/api/salesforce");
    CaseRequest payload = {
        description: "Test Case"
    };
    record {}|error response = check testClient->/case/insert.post(payload);
    test:assertTrue(response is record {});
}

@test:Config {}
function testBulkInsertCases() returns error? {
    http:Client testClient = check new ("http://localhost:9099/api/salesforce");
    CaseRequest[] payload = [
        {
            description: "Test Case 1"
        },
        {
            description: "Test Case 2"
        }
    ];
    record {}|error response = check testClient->/cases/bulk.post(payload);
    test:assertTrue(response is record {});
}

@test:Config {}
function testGetBulkStatus() returns error? {
    http:Client testClient = check new ("http://localhost:9099/api/salesforce");
    json|error response = check testClient->/case/bulk/status(
        jobId = "750xx000000005pAAA",
        batchId = "751xx000000005pAAA"
    );
    test:assertTrue(response is json);
}
