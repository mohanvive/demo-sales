import ballerina/http;
import ballerinax/salesforce;
import ballerinax/salesforce.bulk;

listener http:Listener httpDefaultListener = http:getDefaultListener();

service /api/salesforce on httpDefaultListener {
    resource function get connect() returns string|error {
        do {
            salesforce:OrganizationMetadata salesforceOrganizationmetadata = check salesforceClient->getOrganizationMetaData();
            return "Connection is successful";
        } on fail error err {
            return error("Connection failed", err);
        }
    }

    resource function post case/insert(CaseRequest caseRequest) returns record {}|error {
        do {
            salesforce:CreationResponse salesforceCreationresponse = check salesforceClient->create("Case", caseRequest);
            return salesforceCreationresponse;
        } on fail error err {
            return error("An error occurred", err);
        }
    }

    resource function get case(string caseId) returns CaseResponse|error {
        do {
            CaseResponse caseDetail = check salesforceClient->getById("Case", caseId);
            return caseDetail;
        } on fail error err {
            return error("An error occurred", err);
        }
    }
    
    resource function post cases/bulk(CaseRequest[] caseRequests) returns bulk:BatchInfo|error? {
        do {
            bulk:BulkJob salesforceBulkjob = check salesforceBulkClient->createJob(operation = "insert", sobj = "Case", contentType = "CSV");
            string content = check convertCaseRequestsToCsv(caseRequests);
            bulk:BatchInfo batchInfo = check salesforceBulkClient->addBatch(salesforceBulkjob, content);
            return batchInfo;
        } on fail error err {
            return error("An error occurred", err);
        }
    }

    resource function get case/bulk/status(string batchId, string jobId) returns json|xml|string|bulk:Result[]|error {
        do {
            bulk:BulkJob bulkJob = {
                jobId,
                operation: "insert",
                jobDataType: "CSV"
            };
            json|xml|string|bulk:Result[] batchResult = check salesforceBulkClient->getBatchResult(bulkJob, batchId);
            return batchResult;
        } on fail error err {
            return error("An error occurred", err);
        }
    }
}
