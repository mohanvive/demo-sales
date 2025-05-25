import ballerina/http;

service /api/salesforce on new http:Listener(9099) {
    resource function get case(string caseId) returns record {}|error {
        return {
            "Id": caseId,
            "Subject": "Test Case",
            "Status": "New",
            "Priority": "High",
            "Description": "Test Description"
        };
    }

    resource function post case/insert(@http:Payload CaseRequest caseRequest) returns record {}|error {
        return {
            "id": "5003h000001yZSCAA2",
            "success": true,
            "errors": []
        };
    }

    resource function post cases/bulk(@http:Payload CaseRequest[] caseRequests) returns record {}|error {
        return {
            "id": "751xx000000005pAAA",
            "jobId": "750xx000000005pAAA",
            "state": "Queued",
            "createdDate": "2023-09-21T11:20:32.000+0000",
            "systemModstamp": "2023-09-21T11:20:32.000+0000"
        };
    }

    resource function get case/bulk/status(string batchId, string jobId) returns json|error {
        return [
            {
                "id": "5003h000001yZSCAA2",
                "success": true,
                "created": true,
                "errors": []
            }
        ];
    }
}
