import ballerina/http;
import ballerina/test;
import ballerinax/mysql;

// Define client endpoint
final http:Client clientEp = check new ("http://localhost:8085");

// Define test database client
final mysql:Client testDbClient = check new (
    host = dbHost,
    user = dbUser,
    password = dbPassword,
    database = dbName,
    port = dbPort
);

@test:BeforeSuite
function setupTestData() returns error? {
    // Setup test data if needed
}

// Cleanup after each test
@test:AfterEach
function cleanupTestData() returns error? {
    _ = check testDbClient->execute(`DELETE FROM customers`);
    // Reset auto-increment counter
    _ = check testDbClient->execute(`ALTER TABLE customers AUTO_INCREMENT = 1`);
}

// Test Scenario 1.1: Get all customers
@test:Config {}
function testGetAllCustomers() returns error? {
    // First insert test data
    CustomerInsert customer1 = {
        firstName: "John",
        lastName: "Doe",
        email: "john@example.com",
        phoneNumber: "+1234567890",
        address: "123 Main St"
    };
    CustomerInsert customer2 = {
        firstName: "Jane",
        lastName: "Smith",
        email: "jane@example.com",
        phoneNumber: "+9876543210",
        address: "456 Oak St"
    };

    json response = check clientEp->/api/customer/create.post(customer1);
    response = check clientEp->/api/customer/create.post(customer2);

    // Send GET request without query parameter
    Customer[] customers = check clientEp->/api/customer/details();

    // Validate response
    test:assertEquals(customers.length(), 2, "Expected 2 customers in response");
    test:assertEquals(customers[0].firstName, "John", "First customer firstName mismatch");
    test:assertEquals(customers[0].phoneNumber, "+1234567890", "First customer phoneNumber mismatch");
    test:assertEquals(customers[1].firstName, "Jane", "Second customer firstName mismatch");
    test:assertEquals(customers[1].phoneNumber, "+9876543210", "Second customer phoneNumber mismatch");
}

// Test Scenario 1.2: Get single customer by ID
@test:Config {}
function testGetCustomerById() returns error? {
    // First insert test data
    CustomerInsert customer = {
        firstName: "John",
        lastName: "Doe",
        email: "john@example.com",
        phoneNumber: "+1234567890",
        address: "123 Main St"
    };

    json createResponse = check clientEp->/api/customer/create.post(customer);
    int customerId = check createResponse.customerId;

    // Send GET request with ID parameter
    Customer[] customers = check clientEp->/api/customer/details(id = customerId);

    // Validate response
    test:assertEquals(customers.length(), 1, "Expected single customer in response");
    test:assertEquals(customers[0].customerId, customerId, "Customer ID mismatch");
    test:assertEquals(customers[0].firstName, "John", "Customer firstName mismatch");
    test:assertEquals(customers[0].phoneNumber, "+1234567890", "Customer phoneNumber mismatch");
}

// Test Scenario 2.1: Create customer
@test:Config {}
function testCreateCustomer() returns error? {
    // Prepare test data
    CustomerInsert newCustomer = {
        firstName: "Alice",
        lastName: "Johnson",
        email: "alice@example.com",
        phoneNumber: "+1122334455",
        address: "789 Pine Rd"
    };

    // Send POST request
    CustomerOutput response = check clientEp->/api/customer/create.post(newCustomer);
    int customerId = check response.customerId;

    test:assertTrue(customerId is int, "customerId should be an integer");
}

// Test Scenario 2.2: Create customer error case
@test:Config {}
function testCreateCustomerError() returns error? {
    // Test with invalid customer data
    CustomerInsert invalidCustomer = {
        firstName: "",
        lastName: "",
        email: "",
        phoneNumber: "",
        address: ""
    };

    // Send POST request and expect error
    json|error response = clientEp->/api/customer/create.post(invalidCustomer);

    if response is error {
        test:assertTrue(response.message().includes("Failed to retrieve the last insert ID"), 
            "Expected error message not found");
    } else {
        test:assertFail("Expected error response but received success");
    }
}