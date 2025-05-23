import ballerina/test;
import ballerina/http;


@test:Config {}
function testGetCustomer() returns error? {
    http:Client testClient = check new ("http://localhost:9097");
    json response = check testClient->/api/salesforce/customer.get(customerName = "Test", customerId = "validId");
    test:assertEquals(response.Id, "validId");
    test:assertEquals(response.Name, "Test Account");
}

@test:Config {}
function testCreateCustomer() returns error? {
    http:Client testClient = check new ("http://localhost:9097");
    CustomerDetails payload = {};
    json response = check testClient->/api/salesforce/customer/insert.post(payload);
    test:assertEquals(response.success, true);
    test:assertEquals(response.id, "createdId");
}

@test:Config {}
function testBulkCustomer() returns error? {
    http:Client testClient = check new ("http://localhost:9097");
    string csvContent = "Name,BillingCity\nTest Account,Test City";
    json|error response = testClient->/api/salesforce/customer/bulk.post(csvContent);
    test:assertTrue(response !is error);
}
