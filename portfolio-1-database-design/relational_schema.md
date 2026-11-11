# FlexPay Financial Technologies
## Relational Database Schema

The FlexPay database consists of three relational tables: CUSTOMERS, ACCOUNTS and TRANSACTIONS. Primary keys uniquely identify records, while foreign keys establish relationships between tables and maintain referential integrity.

### 1. Customers Table

**CUSTOMERS** (`customer_id`, first_name, last_name, email, phone, date_of_birth, created_at)

- Primary Key (PK): `customer_id`
- Unique constraints: `email`, `phone`
- Required fields: `first_name`, `last_name`, `email`, `phone`
- Phone numbers must follow the specified Nigerian 11-digit format.
- `created_at` defaults to the current timestamp.

### 2. Accounts Table

**ACCOUNTS** (`account_id`, customer_id, account_number, account_type, balance, currency, created_at)

- Primary Key (PK): `account_id`
- Foreign Key (FK): `customer_id` references `CUSTOMERS(customer_id)`.
- Unique constraint: `account_number`
- Required fields: `customer_id`, `account_number`, `account_type`
- Account numbers must contain exactly 10 digits.
- Account balance cannot be negative.
- Account type must be either `SAVINGS` or `CURRENT`.
- Default balance is `0.00`.
- Default currency is `NGN`.
- `created_at` defaults to the current timestamp.

### 3. Transactions Table

**TRANSACTIONS** (`transaction_id`, account_id, destination_account_id, transaction_type, amount, transaction_date, description, status)

- Primary Key (PK): `transaction_id`
- Foreign Key (FK): `account_id` references `ACCOUNTS(account_id)`.
- Foreign Key (FK): `destination_account_id` references `ACCOUNTS(account_id)`.
- Required fields: `account_id`, `transaction_type`, `amount`
- Transaction amount must be greater than zero.
- Transaction type must be `DEPOSIT`, `WITHDRAWAL` or `TRANSFER`.
- Transaction status must be `SUCCESS`, `FAILED` or `PENDING`.
- Default status is `SUCCESS`.
- `transaction_date` defaults to the current timestamp.
- `destination_account_id` is optional.

**Destination account rules:**

- Deposits and withdrawals must have a NULL destination account.
- Transfers may have a NULL destination account for external transfers.
- When a destination account is supplied, it must differ from the originating account.

### 4. Relationships Between Tables

1. **CUSTOMERS to ACCOUNTS:** One customer can own multiple accounts, but each account belongs to exactly one customer.
2. **ACCOUNTS to TRANSACTIONS (originating account):** One account can originate multiple transactions, but each transaction has exactly one originating account.
3. **ACCOUNTS to TRANSACTIONS (destination account):** One account can receive multiple internal transfers. A transaction can have zero or one destination account.

### 5. Referential Integrity and Data Integrity

Foreign key constraints ensure that accounts reference existing customers and transactions reference existing accounts.

Unique constraints prevent duplicate customer email addresses, phone numbers and account numbers.

Check constraints enforce valid phone numbers, account numbers, account types, non-negative balances, positive transaction amounts, valid transaction types and valid transaction statuses.

These rules help maintain the accuracy, consistency and reliability of financial records within the FlexPay database.