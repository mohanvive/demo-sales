
type CaseDetails record {|
    string caseId;
    string subject;
    string status;
    string priority;
    string description;
|};

type CaseResponse record {|
    string description;
    string contactId;
    string contactName;
    string contactEmail;
|};

type CaseRequest record {|
    string description;
    string contactName?;
    string contactEmail?;
|};
