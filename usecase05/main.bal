import ballerina/http;
import ballerina/mime;
import ballerina/time;
import ballerinax/'aws.s3 as s3;

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
        mime:Entity[] bodyParts = check request.getBodyParts();
        if bodyParts.length() == 0 {
            return error("No file content found");
        }

        mime:Entity filePart = bodyParts[0];
        byte[] fileContent = check filePart.getByteArray();

        string fileName = "file-" + time:utcNow().toString();

        // Upload to S3
        check s3Client->createObject(
            bucketName = bucketName,
            objectName = fileName,
            payload = fileContent
        );

        // Construct the file URL
        string fileUrl = string `https://${bucketName}.s3.${region}.amazonaws.com/${fileName}`;

        // Return response
        return {
            status: "uploaded",
            fileUrl: fileUrl
        };
    }
}