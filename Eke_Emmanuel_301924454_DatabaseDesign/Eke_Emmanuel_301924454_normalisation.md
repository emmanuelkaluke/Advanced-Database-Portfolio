# FlexPay Financial Technologies
## Database Normalisation

### 1. Introduction

Database normalisation is the process of organising data into related tables to reduce unnecessary duplication, prevent data inconsistencies and improve data integrity.

For FlexPay, normalisation is important because the system stores customer details, bank account information and financial transactions. Keeping these records properly organised helps ensure that updates to customer or account information do not create inconsistencies in transaction records.

### 2. First Normal Form (1NF)

A table is in First Normal Form when:

- Each column contains a single, indivisible value.
- Each record can be uniquely identified.
- There are no repeating groups or multiple values stored in one field.

**Application to FlexPay:**

Each customer has a separate record in the CUSTOMERS table. Each account is stored as an individual record in ACCOUNTS, while each financial transaction is stored separately in TRANSACTIONS.

For example, customer names, phone numbers and email addresses are stored in separate columns rather than combined into one field. Transaction amounts and transaction types are also stored separately.

The primary keys uniquely identify each record.

### 3. Second Normal Form (2NF)

A table is in Second Normal Form when:

- It is already in First Normal Form.
- Every non-key attribute depends on the whole primary key, not just part of it.

**Application to FlexPay:**

The FlexPay tables use single-column primary keys:

- `customer_id` in CUSTOMERS.
- `account_id` in ACCOUNTS.
- `transaction_id` in TRANSACTIONS.

Because each table uses a single-column primary key, there can be no partial dependency on only part of a composite primary key.

### 4. Third Normal Form (3NF)

A table is in Third Normal Form when:

- It is already in Second Normal Form.
- Non-key attributes depend on the primary key, the whole key and nothing but the key.
- There are no transitive dependencies between non-key attributes.

**Application to FlexPay:**

Customer information is stored in CUSTOMERS rather than repeated in the ACCOUNTS or TRANSACTIONS tables.

Account information is stored in ACCOUNTS, while TRANSACTIONS stores the account identifiers needed to connect financial activities to the relevant accounts.

For example, a customer's name is not repeatedly stored in every transaction record. Instead, the transaction references an account, and the account references the customer.

This reduces unnecessary duplication and makes updates easier to manage.

### 5. Benefits of Normalisation in FlexPay

Normalisation provides several benefits to the FlexPay database:

1. **Reduced data duplication:** Customer and account details are stored in their respective tables instead of being repeatedly entered into transaction records.
2. **Improved data consistency:** Updating a customer's details in one place reduces the risk of conflicting information.
3. **Better data integrity:** Primary keys, foreign keys and constraints help prevent invalid relationships and records.
4. **Simpler maintenance:** The separate tables make it easier to manage customers, accounts and transactions.
5. **Reliable financial records:** Properly structured data reduces the risk of inconsistencies when retrieving or updating financial information.

### 6. Conclusion

The FlexPay database structure follows the principles of 1NF, 2NF and 3NF. Separating customers, accounts and transactions into related tables reduces redundancy and supports data integrity. This structure provides a suitable foundation for a digital financial services platform.