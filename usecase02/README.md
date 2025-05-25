# Salesforce API Integration

This project demonstrates the Salesforce API integration with Ballerina, including the following cases:

- Testing Salesforce connection
- Retrieving case details
- Creating new cases
- Bulk case creation operations
- Check bulk operation status

## Build and Test the APIs

### API Endpoints

The following REST APIs have been implemented:

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/salesforce/connect | Test connection to Salesforce |
| GET | /api/salesforce/case | Retrieve case details by ID |
| POST | /api/salesforce/case/insert | Create a new case |
| POST | /api/salesforce/cases/bulk | Create multiple cases using Bulk API |
| GET | /api/salesforce/case/bulk/status | Get bulk operation status |

## Getting Started

### Running the Project

You can run the Ballerina project directly using the run button in your IDE and use the Try It feature to test the APIs.

## Testing the APIs

Use the Try It feature to test each API.

### Test Connection API

To test the `/api/salesforce/connect` endpoint, simply make a GET request.

```http
GET /api/salesforce/connect
```

### Create Case API

To test the `/api/salesforce/case/insert` endpoint, use the following JSON payload:

```json
{
  "description": "Issue with the Product"
}
```

### Get Case Details API

To test the `/api/salesforce/case` endpoint, use the id you get as a response from running the create case API.

### Bulk Create Cases API

To test the `/api/salesforce/cases/bulk` endpoint, use the following JSON payload.

```json
[
  {
    "description": "Issue with the Product A"
  },
  {
    "description": "Issue with the Product B"
  },
  {
    "description": "Issue with the Product C"
  }
]
```

### Bulk Status API

To test the `/api/salesforce/case/bulk/status` endpoint, use the `id` as the `batchId` and the `jobId` you get from running the bulk create cases API.

```http
GET /api/salesforce/case/bulk/status?batchId=XXXXX&jobId=XXXXX
```

## Configuration

Before running the project, ensure you have configured the following Salesforce connection parameters in your configuration file:

```toml
baseUrl = "add-base-url"
clientId = "add-client-id"
clientSecret = "add-client-secret"
refreshToken = "add-refresh-token"
refreshUrl = "add-refresh-url"
```

### Running Tests

Test cases are located in the tests directory and can be executed with:

```bash
bal test
```

## Additional Information

- For testing purposes, use valid Salesforce case IDs from your Salesforce org
- The bulk API operations are asynchronous and require polling the status endpoint to check completion
- Ensure proper authentication and authorization before making API calls
