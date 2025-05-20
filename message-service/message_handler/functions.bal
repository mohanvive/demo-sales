import ballerinax/twilio;

function handleSmsRequest(string body) returns error? {
    SmsRequest smsRequest = check body.cloneWithType();
    if !smsRequest.recipientNumber.startsWith("+") {
        return error("Invalid phone number format. Must be in E.164 format (e.g., +1234567890)");
    }
    ClaimData? claimData = claimDatabase.filter(
        claim => claim.claimId == smsRequest.claimId && claim.customerPhone == smsRequest.recipientNumber
    )[0];
    if claimData is () {
        return error("No claim found for the given claim ID and phone number");
    }
    if !claimData.isEligible {
        return error(string `Claim ${smsRequest.claimId} is not eligible for processing`);
    }
    string messageBody = string `Your claim ${smsRequest.claimId} is ${claimData.status}. ` +
        string `Claim amount: ${claimData.claimAmount.toString()}`;
    twilio:CreateMessageRequest messageRequest = {
        To: smsRequest.recipientNumber,
        Body: messageBody,
        From: phoneNumber
    };
    _ = check twilioClient->createMessage(messageRequest);
}
