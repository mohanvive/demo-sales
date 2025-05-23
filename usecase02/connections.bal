import ballerinax/salesforce;
import ballerinax/salesforce.bulkv2;

final salesforce:Client salesforceClient = check new ({
    baseUrl,
    auth: {
        clientId,
        clientSecret,
        refreshToken,
        refreshUrl
    }
});

final bulkv2:Client salesforceBulkClient = check new ({
    baseUrl,
    auth: {
        clientId,
        clientSecret,
        refreshToken,
        refreshUrl
    }
});
