import ballerinax/twilio;

final twilio:Client twilioClient = check new ({
    auth: {
        accountSid,
        authToken
    }
});
