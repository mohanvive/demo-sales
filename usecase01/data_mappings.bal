function transformCustomer(CustomerDB customerFromDB) returns Customer => {
    customerId: customerFromDB.id,
    firstName: customerFromDB.first_name,
    lastName: customerFromDB.last_name,
    email: customerFromDB.email,
    address: customerFromDB.address
};