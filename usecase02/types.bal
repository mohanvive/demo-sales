
type CaseResponse record {
    string Id;
    string|() Subject;
    string|() Status;
    string|() Priority;
    string|() Description;
};

type CaseRequest record {|
    string description;
    string contactName?;
    string contactEmail?;
|};
