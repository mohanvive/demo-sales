import ballerina/http;
import ballerina/mime;
import ballerina/time;
import ballerina/io;
import ballerinax/'aws.s3 as s3;
import ballerina/log;

// Initialize S3 client
final s3:Client s3Client = check new (
    config = {
        accessKeyId: accessKeyId,
        secretAccessKey: secretAccessKey,
        region: region
    }
);

service /api/storage on new http:Listener(8090) {
    resource function post upload(http:Request request) returns UploadResponse|error {
        log:printInfo("File upload request is received");
        mime:Entity[] bodyParts = check request.getBodyParts();
        if bodyParts.length() == 0 {
            return error("No file content found");
        }

        mime:Entity filePart = bodyParts[0];
        byte[] fileContent = check filePart.getByteArray();

        time:Utc currentUtc = time:utcNow();
        string fileName = "file-" + currentUtc[0].toString() + ".pdf";

        // Upload to S3
        check s3Client->createObject(
            bucketName = bucketName,
            objectName = fileName,
            payload = fileContent
        );
        log:printInfo("File uploaded successfully to S3");
        // Construct the file URL
        string fileUrl = string `https://${bucketName}.s3.${region}.amazonaws.com/${fileName}`;

        // Return response
        return {
            status: "uploaded",
            fileUrl: fileUrl
        };
    }

    resource function get download/[string fileName]() returns http:Response|error {
        log:printInfo("File download request is received for file: " + fileName);
        http:Response response = new;

        // Get object from S3
        stream<byte[], io:Error?> fileStream = check s3Client->getObject(
            bucketName = bucketName,
            objectName = fileName
        );
        log:printInfo("File retrieved from S3 Bucket");

        // Read the byte stream
        byte[] fileContent = [];
        check from byte[] chunk in fileStream
            do {
                fileContent.push(...chunk);
            };

        // Set response headers
        response.setHeader("Content-Type", "application/pdf");
        // response.setHeader("Content-Type", "application/octet-stream");

        response.setHeader("Content-Disposition", string `attachment; filename=${fileName}`);
        response.setBinaryPayload(fileContent);

        return response;
    }
}
