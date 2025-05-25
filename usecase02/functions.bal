# Converts an array of CaseRequest records to CSV string format.
#
# + caseRequests - Array of CaseRequest records to convert
# + return - CSV formatted string or error
isolated function convertCaseRequestsToCsv(CaseRequest[] caseRequests) returns string|error {
    string[][] csvContent = [["Description"]];
    foreach CaseRequest caseRequest in caseRequests {
        string[] row = [
            caseRequest.description
        ];
        csvContent.push(row);
    }
    string[] csvLines = [];
    foreach string[] row in csvContent {
        csvLines.push(string:'join(",", ...row));
    }
    return string:'join("\n", ...csvLines);
}
