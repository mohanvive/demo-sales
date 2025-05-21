// Response type for the upload endpoint
type UploadResponse record {|
    string status;
    string fileUrl;
|};

// Error response type
type ErrorResponse record {|
    string message;
    string code;
|};