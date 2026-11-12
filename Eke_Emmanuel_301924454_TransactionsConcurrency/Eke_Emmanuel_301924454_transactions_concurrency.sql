-- =========================================================
-- FLEXPAY FINANCIAL TECHNOLOGIES
-- PORTFOLIO 3: TRANSACTIONS AND CONCURRENCY
-- Database: flexpay_db
-- DBMS: PostgreSQL 18.6
--
-- IMPORTANT:
-- Run Sections 1-4 individually, not as one large script.
-- Sections 5 and 6 contain separate-session exercises.
-- Sections 7 and 8 are verification queries.
--
-- Duplicate protection is included in Sections 1-3.
-- =========================================================


-- SECTION 1: DEPOSIT TRANSACTION
-- Deposit NGN 10,000 into Chinaza's account.

DO $flexpay$
DECLARE
    v_account_id INTEGER;
    v_updated_id INTEGER;
BEGIN
    SELECT account_id INTO v_account_id
    FROM accounts
    WHERE account_number = '6905837461';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Chinaza account not found';
    END IF;

    IF EXISTS (
        SELECT 1 FROM transactions
        WHERE account_id = v_account_id
          AND transaction_type = 'DEPOSIT'
          AND amount = 10000
          AND description = 'Test deposit for transaction processing'
    ) THEN
        RAISE NOTICE 'Deposit already recorded. No change made.';
    ELSE
        UPDATE accounts
        SET balance = balance + 10000
        WHERE account_id = v_account_id
        RETURNING account_id INTO v_updated_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Deposit balance update failed';
        END IF;

        INSERT INTO transactions
        (account_id, transaction_type, amount, description, status)
        VALUES (
            v_account_id,
            'DEPOSIT',
            10000,
            'Test deposit for transaction processing',
            'SUCCESS'
        );

        RAISE NOTICE 'Deposit completed successfully';
    END IF;
END;
$flexpay$;


-- SECTION 2: WITHDRAWAL TRANSACTION
-- Withdraw NGN 5,000 from Chinaza's account.
-- A withdrawal cannot proceed if funds are insufficient.

DO $flexpay$
DECLARE
    v_account_id INTEGER;
    v_updated_id INTEGER;
BEGIN
    SELECT account_id INTO v_account_id
    FROM accounts
    WHERE account_number = '6905837461';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Chinaza account not found';
    END IF;

    IF EXISTS (
        SELECT 1 FROM transactions
        WHERE account_id = v_account_id
          AND transaction_type = 'WITHDRAWAL'
          AND amount = 5000
          AND description = 'Test withdrawal for transaction processing'
    ) THEN
        RAISE NOTICE 'Withdrawal already recorded. No change made.';
    ELSE
        UPDATE accounts
        SET balance = balance - 5000
        WHERE account_id = v_account_id
          AND balance >= 5000
        RETURNING account_id INTO v_updated_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Withdrawal failed: insufficient funds';
        END IF;

        INSERT INTO transactions
        (account_id, transaction_type, amount, description, status)
        VALUES (
            v_account_id,
            'WITHDRAWAL',
            5000,
            'Test withdrawal for transaction processing',
            'SUCCESS'
        );

        RAISE NOTICE 'Withdrawal completed successfully';
    END IF;
END;
$flexpay$;


-- SECTION 3: INTERNAL TRANSFER
-- Transfer NGN 20,000 from Chinaza to Hadizat.
-- Both account updates and the transaction record
-- must succeed together.

DO $flexpay$
DECLARE
    v_sender_id INTEGER;
    v_receiver_id INTEGER;
    v_updated_id INTEGER;
BEGIN
    SELECT account_id INTO v_sender_id
    FROM accounts
    WHERE account_number = '6905837461';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Sender account not found';
    END IF;

    SELECT account_id INTO v_receiver_id
    FROM accounts
    WHERE account_number = '0194628175';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Receiver account not found';
    END IF;

    IF v_sender_id = v_receiver_id THEN
        RAISE EXCEPTION 'Sender and receiver cannot be the same';
    END IF;

    IF EXISTS (
        SELECT 1 FROM transactions
        WHERE account_id = v_sender_id
          AND destination_account_id = v_receiver_id
          AND transaction_type = 'TRANSFER'
          AND amount = 20000
          AND description = 'Internal transfer from Chinaza to Hadizat'
    ) THEN
        RAISE NOTICE 'Transfer already recorded. No change made.';
    ELSE
        -- Debit the sender.
        UPDATE accounts
        SET balance = balance - 20000
        WHERE account_id = v_sender_id
          AND balance >= 20000
        RETURNING account_id INTO v_updated_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Transfer failed: insufficient sender funds';
        END IF;

        -- Credit the receiver.
        UPDATE accounts
        SET balance = balance + 20000
        WHERE account_id = v_receiver_id
        RETURNING account_id INTO v_updated_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Transfer failed: receiver update unsuccessful';
        END IF;

        -- Record the transfer.
        INSERT INTO transactions
        (account_id, destination_account_id,
         transaction_type, amount, description, status)
        VALUES (
            v_sender_id,
            v_receiver_id,
            'TRANSFER',
            20000,
            'Internal transfer from Chinaza to Hadizat',
            'SUCCESS'
        );

        RAISE NOTICE 'Transfer completed successfully';
    END IF;
END;
$flexpay$;


-- SECTION 4: ROLLBACK DEMONSTRATION
-- Temporarily increase Oluwatomisin's balance by NGN 50,000.
-- ROLLBACK cancels the change.

BEGIN;

UPDATE accounts
SET balance = balance + 50000
WHERE account_number = '5027193846';

-- Run this separately after the UPDATE:
ROLLBACK;


-- SECTION 5: CONCURRENCY AND ROW-LEVEL LOCKING
-- IMPORTANT: Use TWO separate PostgreSQL sessions.
-- Do not run both sessions in the same terminal.


-- SESSION 1:
-- Run in the first terminal.

BEGIN;

SELECT account_number, balance
FROM accounts
WHERE account_number = '0194628175'
FOR UPDATE;

-- Leave the transaction open.
-- After Session 2 starts waiting, return here and run:
COMMIT;


-- SESSION 2:
-- Run in the second terminal while Session 1 is open.

BEGIN;

UPDATE accounts
SET balance = balance - 1000
WHERE account_number = '0194628175';

-- This update waits for Session 1 to commit.
-- After it completes, run:
ROLLBACK;


-- SECTION 6: FINAL BALANCE VERIFICATION

SELECT
    c.first_name,
    c.last_name,
    a.account_number,
    a.balance
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
ORDER BY a.account_id;


-- SECTION 7: TRANSACTION HISTORY VERIFICATION

SELECT
    t.transaction_id,
    a.account_number AS sender_account,
    d.account_number AS receiver_account,
    t.transaction_type,
    t.amount,
    t.status,
    t.description
FROM transactions t
JOIN accounts a
    ON t.account_id = a.account_id
LEFT JOIN accounts d
    ON t.destination_account_id = d.account_id
ORDER BY t.transaction_id;


-- SECTION 8: CHECK FOR NEGATIVE ACCOUNT BALANCES

SELECT account_number, balance
FROM accounts
WHERE balance < 0;