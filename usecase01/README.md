# Customer Management API

A RESTful API service for managing customer information in a healthcare organization. This API provides endpoints for creating and retrieving customer details with phone number support and comprehensive validation.

## Table of Contents
- [API Endpoints](#api-endpoints)
- [Data Models](#data-models)
- [Validation Rules](#validation-rules)
- [Error Handling](#error-handling)
- [Example Usage](#example-usage)

## API Endpoints

### 1. Get Customer Details

Retrieves customer information. Can fetch either all customers or a specific customer by ID.

**Endpoint:** `GET /api/customer/details`

**Query Parameters:**
- `id` (optional): Customer ID to fetch specific customer

**Response:** Array of Customer objects or error

```json
[
    {
        "customerId": 1,
        "firstName": "John",
        "lastName": "Doe",
        "email": "john@example.com",
        "phoneNumber": "+1234567890",
        "address": "123 Main St"
    }
]
```

### 2. Create Customer

Creates a new customer record with comprehensive validation.

**Endpoint:** `POST /api/customer/create`

**Request Body:** CustomerInsert object
```json
{
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "phoneNumber": "+1234567890",
    "address": "123 Main St"
}
```

**Response:** CustomerOutput object
```json
{
    "customerId": 1
}
```

## Data Models

### CustomerInsert
```ballerina
type CustomerInsert record {|
    string firstName;
    string lastName;
    string email;
    string phoneNumber;
    string address;
|};
```

### Customer
```ballerina
type Customer record {|
    int customerId;
    string firstName;
    string lastName;
    string email;
    string phoneNumber;
    string address;
|};
```

### CustomerOutput
```ballerina
type CustomerOutput record {|
    int customerId;
|};
```

## Validation Rules

### 1. First Name
- Cannot be empty or whitespace-only
- Trimmed before validation
- Error: "First name cannot be empty"

### 2. Last Name
- Cannot be empty or whitespace-only
- Trimmed before validation
- Error: "Last name cannot be empty"

### 3. Email
- Cannot be empty
- Must contain '@' symbol
- Must have valid local and domain parts
- Domain must contain at least one dot
- Error: "Invalid email format"

### 4. Phone Number
- Minimum length of 10 characters
- Optional '+' prefix allowed
- Only digits and spaces allowed after prefix
- Cannot be empty or whitespace-only
- Error: "Invalid phone number format"

### 5. Address
- Cannot be empty or whitespace-only
- Trimmed before validation
- Error: "Address cannot be empty"

## Error Handling

The API returns errors in the following format:
```json
{
    "message": "Error message describing the validation failure"
}
```

Common error scenarios:
1. Validation failures (see Validation Rules section)
2. Database connection errors
3. Query execution errors
4. Insert failures ("Failed to retrieve the last insert ID")

## Example Usage

### Fetch All Customers
```bash
curl -X GET http://localhost:8085/api/customer/details
```

### Fetch Specific Customer
```bash
curl -X GET http://localhost:8085/api/customer/details?id=1
```

### Create New Customer
```bash
curl -X POST http://localhost:8085/api/customer/create \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "phoneNumber": "+1234567890",
    "address": "123 Main St"
  }'
```

## Data Transformation

The API uses a data transformation function to map between database and API models:

```ballerina
function transformCustomer(CustomerDB customerFromDB) returns Customer => {
    customerId: customerFromDB.id,
    firstName: customerFromDB.first_name,
    lastName: customerFromDB.last_name,
    email: customerFromDB.email,
    phoneNumber: customerFromDB.phone_number,
    address: customerFromDB.address
};
```

This ensures consistent data format between the database and API responses.
```

This documentation has been updated to include:
1. Phone number field in all data models
2. Phone number validation rules
3. Updated example requests and responses
4. Data transformation details
5. More detailed validation rules section

The documentation provides developers with all necessary information to understand and integrate with the Customer API.