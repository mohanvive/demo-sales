import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;
import ballerina/log;

final mysql:Client dbClient = check new (
    host = dbHost,
    user = dbUser,
    password = dbPassword,
    database = dbName,
    port = dbPort
);

service /api on new http:Listener(8085) {
    resource function get customer/details(int? id = ()) returns Customer[]|error {
        log:printInfo("Received request to fetch customer details");
        Customer[] customers = [];
        stream<CustomerDB, error?> resultStream;
        if id is () {
            resultStream = dbClient->query(
            `SELECT id, first_name, last_name, email, address FROM customers`
            );
        } else {
            resultStream = dbClient->query(
            `SELECT id, first_name, last_name, email, address FROM customers WHERE id = ${id}`
            );
        }
        check from CustomerDB customer in resultStream
            do {
                Customer transformedCustomer = transformCustomer(customer);
                customers.push(transformedCustomer);
            };
        log:printInfo("Customer details fetched successfully");
        return customers;
    }

    resource function post customer/create(@http:Payload CustomerInsert customer) returns CustomerOutput|error {
        log:printInfo("Received request to create a new customer");

        // Validate firstName
        if customer.firstName.trim().length() == 0 {
            return error("First name cannot be empty");
        }

        // Validate lastName
        if customer.lastName.trim().length() == 0 {
            return error("Last name cannot be empty");
        }

        // Validate email
        if !isValidEmail(customer.email) {
            return error("Invalid email format");
        }

        // Validate address
        if customer.address.trim().length() == 0 {
            return error("Address cannot be empty");
        }

        sql:ExecutionResult result = check dbClient->execute(`
            INSERT INTO customers (first_name, last_name, email, address)
            VALUES (${customer.firstName}, ${customer.lastName}, ${customer.email}, ${customer.address})
        `);

        int|string? lastInsertId = result.lastInsertId;
        if lastInsertId is int {
            log:printInfo("Customer created successfully with ID: " + lastInsertId.toString());
            return {
                customerId: lastInsertId
            };
        }
        log:printError("Failed to retrieve the last insert ID");
        return error("Failed to retrieve the last insert ID");
    }
}

// Helper function to validate email format
function isValidEmail(string email) returns boolean {
    if email.trim().length() == 0 {
        return false;
    }

    // Basic email format validation using string operations
    if !email.includes("@") {
        return false;
    }

    string[] parts = re `@`.split(email);
    if parts.length() != 2 {
        return false;
    }

    // Check local part and domain part are not empty
    if parts[0].trim().length() == 0 || parts[1].trim().length() == 0 {
        return false;
    }

    // Check domain has at least one dot
    if !parts[1].includes(".") {
        return false;
    }

    return true;
}
