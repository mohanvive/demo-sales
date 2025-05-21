# Customer Management API

A RESTful API service for managing customer information in a healthcare organization. This API provides endpoints for creating and retrieving customer details.

## Table of Contents
- [API Endpoints](#api-endpoints)
- [Data Models](#data-models)
- [Error Handling](#error-handling)
- [Example Usage](#example-usage)

## API Endpoints

### 1. Get Customer Details

Retrieves customer information. Can fetch either all customers or a specific customer by ID.

**Endpoint:** `GET /api/customer/details`

**Query Parameters:**
- `id` (optional): Customer ID to fetch specific customer

**Response:** Array of Customer objects or error

```ballerina
// Response format for all customers
[
    {
        "customerId": 1,
        "firstName": "John",
        "lastName": "Doe",
        "email": "john@example.com",
        "address": "123 Main St"
    },
    ...
]
```

### 2. Create Customer

Creates a new customer record with validation.

**Endpoint:** `POST /api/customer/create`

**Request Body:** CustomerInsert object
```ballerina
{
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "address": "123 Main St"
}
```

**Response:** CustomerOutput object or error
```ballerina
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
    string address;
|};
```

### CustomerOutput
```ballerina
type CustomerOutput record {|
    int customerId;
|};
```

## Error Handling

The API performs the following validations:

1. **First Name Validation**
   - Cannot be empty or whitespace
   - Returns error: "First name cannot be empty"

2. **Last Name Validation**
   - Cannot be empty or whitespace
   - Returns error: "Last name cannot be empty"

3. **Email Validation**
   - Must contain '@' symbol
   - Must have valid local and domain parts
   - Domain must contain at least one dot
   - Returns error: "Invalid email format"

4. **Address Validation**
   - Cannot be empty or whitespace
   - Returns error: "Address cannot be empty"

5. **Database Errors**
   - Returns error: "Failed to retrieve the last insert ID" for insert failures

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
    "address": "123 Main St"
  }'
```

```