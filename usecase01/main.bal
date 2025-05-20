import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;

final mysql:Client dbClient = check new (
    host = dbHost,
    user = dbUser,
    password = dbPassword,
    database = dbName,
    port = dbPort
);

service /api on new http:Listener(8085) {
    resource function get customer/details(int? id = ()) returns Customer[]|error {
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
        return customers;
    }

    resource function post customer/create(@http:Payload CustomerInsert customer) returns json|error {

        sql:ExecutionResult result = check dbClient->execute(`
            INSERT INTO customers (first_name, last_name, email, address)
            VALUES (${customer.firstName}, ${customer.lastName}, ${customer.email}, ${customer.address})
        `);

        int|string? lastInsertId = result.lastInsertId;
        if lastInsertId is int {
            return {
                customerId: lastInsertId
            };
        }
        return error("Failed to retrieve the last insert ID");
    }
}
