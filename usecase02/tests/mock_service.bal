import ballerina/http;

listener http:Listener httpListener = new (9097);

service /api/salesforce on httpListener {

    resource function get customer(string customerName, string customerId) returns json|error {
        if customerId == "validId" {
            return {
                "Id": "validId",
                "Name": "Test Account"
            };
        }
        return error("Invalid customer ID");
    }

    resource function post customer/insert(@http:Payload CustomerDetails customerDetails) returns json|error {
        return {
            "success": true,
            "id": "createdId"
        };
    }

    resource function post customer/bulk(@http:Payload string content) returns json|error {
        if content == "Name,BillingCity\nTest Account,Test City" {
            return {
                "success": true,
                "jobId": "mockJobId"
            };
        }
        return error("Invalid CSV content");
    }
}
