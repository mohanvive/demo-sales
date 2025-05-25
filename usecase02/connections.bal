import ballerinax/salesforce;
import ballerinax/salesforce.bulk;

final salesforce:Client salesforceClient = check new ({
    baseUrl,
    auth: {
        clientId,
        clientSecret,
        refreshToken,
        refreshUrl
    }
});

final bulk:Client salesforceBulkClient = check new ({
    baseUrl,
    auth: {
        clientId,
        clientSecret,
        refreshToken,
        refreshUrl
    }
});
