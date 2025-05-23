import ballerina/http;
import ballerinax/salesforce;
import ballerinax/salesforce.bulkv2;

listener http:Listener httpDefaultListener = http:getDefaultListener();

service /api/salesforce on httpDefaultListener {

    resource function get customer(string customerName, string customerId) returns record {}|error {
        do {
            record{} customerDetail = check salesforceClient->getById("Contact", customerId);
            return customerDetail;

        } on fail error err {
            return error("An error occurred", err);
        }
    }

    resource function post customer/insert(CustomerDetails customerDetails) returns salesforce:CreationResponse|error {
        do {
            salesforce:CreationResponse salesforceCreationresponse = check salesforceClient->create("Contact", {
                "Name": customerDetails.firstName
            });
            return salesforceCreationresponse;
        } on fail error err {
            return error("An error occurred", err);
        }
    }

    resource function post customer/bulk(@http:Payload string content) returns string|error? {
        do {
            bulkv2:BulkJob salesforceBulkjob = check salesforceBulkClient->createIngestJob({
                operation: "insert",
                'object: "Contact",
                contentType: "CSV"
            });
            check salesforceBulkClient->addBatch(salesforceBulkjob.id, content);
            return salesforceBulkjob.id;
        } on fail error err {
            return error("An error occurred", err);
        }
    }
}
