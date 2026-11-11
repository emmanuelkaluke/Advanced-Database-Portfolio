-- FLEXPAY FINANCIAL TECHNOLOGIES
-- Portfolio 1: Database Design and Modelling
-- Database: flexpay_db

-- 1. CUSTOMERS TABLE
CREATE TABLE customers (
    customer_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(11) UNIQUE NOT NULL,
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_phone_format
        CHECK (phone ~ '^0[789][01][0-9]{8}$')
);


-- 2. ACCOUNTS TABLE
CREATE TABLE accounts (
    account_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    account_number VARCHAR(10) UNIQUE NOT NULL,
    account_type VARCHAR(20) NOT NULL,
    balance NUMERIC(15,2) DEFAULT 0.00,
    currency VARCHAR(3) DEFAULT 'NGN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT chk_balance
        CHECK (balance >= 0),

    CONSTRAINT chk_account_number_length
        CHECK (account_number ~ '^[0-9]{10}$'),

    CONSTRAINT chk_account_type
        CHECK (account_type IN ('SAVINGS', 'CURRENT'))
);


-- 3. TRANSACTIONS TABLE
CREATE TABLE transactions (
    transaction_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_id INTEGER NOT NULL,
    destination_account_id INTEGER,
    transaction_type VARCHAR(20) NOT NULL,
    amount NUMERIC(15,2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    status VARCHAR(20) DEFAULT 'SUCCESS',

    CONSTRAINT fk_transaction_account
        FOREIGN KEY (account_id)
        REFERENCES accounts(account_id),

    CONSTRAINT transactions_destination_account_id_fkey
        FOREIGN KEY (destination_account_id)
        REFERENCES accounts(account_id),

    CONSTRAINT chk_transaction_type
        CHECK (transaction_type IN ('DEPOSIT', 'WITHDRAWAL', 'TRANSFER')),

    CONSTRAINT chk_transaction_amount
        CHECK (amount > 0),

    CONSTRAINT chk_transaction_status
        CHECK (status IN ('SUCCESS', 'FAILED', 'PENDING')),

    CONSTRAINT chk_transfer_destination
        CHECK (
            (
                transaction_type = 'TRANSFER'
                AND (
                    destination_account_id IS NULL
                    OR destination_account_id <> account_id
                )
            )
            OR
            (
                transaction_type IN ('DEPOSIT', 'WITHDRAWAL')
                AND destination_account_id IS NULL
            )
        )
);