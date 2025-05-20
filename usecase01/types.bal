type CustomerDB record {|
    int id;
    string first_name;
    string last_name;
    string email;
    string phone_number?;
    string address;
|};

type Customer record {|
    int customerId;
    string firstName;
    string lastName;
    string email;
    string phoneNumber?;
    string address;
|};

type CustomerInsert record {|
    string firstName;
    string lastName;
    string email;
    string phoneNumber;
    string address;
|};

type CustomerOutput record {|
    int customerId;
|};