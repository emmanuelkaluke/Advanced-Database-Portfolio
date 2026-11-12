-- =========================================================
-- FLEXPAY FINANCIAL TECHNOLOGIES
-- PORTFOLIO 2: QUERY PROCESSING AND OPTIMISATION
-- PostgreSQL
-- =========================================================


-- SECTION 1: GENERATE TEST DATA
-- Generate 10,000 synthetic transactions.
-- These records are for performance testing only.
-- They do not modify customer account balances.

INSERT INTO transactions (
    account_id,
    transaction_type,
    amount,
    transaction_date,
    description,
    status,
    destination_account_id
)
SELECT
    test_data.account_id,
    test_data.transaction_type,
    1000 + (test_data.gs % 50000),
    CURRENT_TIMESTAMP - ((test_data.gs % 365) * INTERVAL '1 day'),
    'PERFORMANCE TEST DATA #' || test_data.gs,
    CASE
        WHEN test_data.gs % 20 = 0 THEN 'FAILED'
        ELSE 'SUCCESS'
    END,
    CASE
        WHEN test_data.transaction_type = 'TRANSFER'
             AND test_data.account_id = 1 THEN 2
        WHEN test_data.transaction_type = 'TRANSFER'
             AND test_data.account_id = 2 THEN 3
        WHEN test_data.transaction_type = 'TRANSFER'
             AND test_data.account_id = 3 THEN 1
        ELSE NULL
    END
FROM (
    SELECT
        gs,
        ((gs - 1) % 3) + 1 AS account_id,
        CASE
            WHEN gs % 3 = 0 THEN 'DEPOSIT'
            WHEN gs % 3 = 1 THEN 'WITHDRAWAL'
            ELSE 'TRANSFER'
        END AS transaction_type
    FROM generate_series(1, 10000) AS gs
) AS test_data
WHERE NOT EXISTS (
    SELECT 1
    FROM transactions existing
    WHERE existing.description =
          'PERFORMANCE TEST DATA #' || test_data.gs
);

ANALYZE transactions;


-- SECTION 2: BASIC DATA RETRIEVAL

SELECT *
FROM customers
ORDER BY customer_id;


-- SECTION 3: FILTERING
-- Find successful transactions above ₦10,000.

SELECT
    transaction_id,
    account_id,
    amount,
    transaction_date
FROM transactions
WHERE status = 'SUCCESS'
  AND amount > 10000
ORDER BY transaction_date DESC
LIMIT 20;


-- SECTION 4: JOIN
-- Retrieve transaction information with customer names.

SELECT
    t.transaction_id,
    c.first_name,
    c.last_name,
    t.transaction_type,
    t.amount,
    t.status
FROM transactions t
JOIN accounts a
    ON t.account_id = a.account_id
JOIN customers c
    ON a.customer_id = c.customer_id
ORDER BY t.transaction_date DESC
LIMIT 20;


-- SECTION 5: AGGREGATION
-- Calculate transaction count and total amount by type.

SELECT
    transaction_type,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_amount
FROM transactions
GROUP BY transaction_type
ORDER BY total_amount DESC;


-- SECTION 6: SUBQUERY
-- Find accounts with balances above the average balance.

SELECT
    account_number,
    account_type,
    balance
FROM accounts
WHERE balance > (
    SELECT AVG(balance)
    FROM accounts
);


-- SECTION 7: QUERY PLAN BEFORE INDEXING

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    transaction_id,
    account_id,
    amount,
    transaction_date
FROM transactions
WHERE account_id = 1
  AND transaction_date >=
      CURRENT_TIMESTAMP - INTERVAL '7 days'
ORDER BY transaction_date DESC;


-- SECTION 8: CREATE INDEX
-- Composite B-tree index for account and date searches.

CREATE INDEX IF NOT EXISTS
    idx_transactions_account_date
ON transactions (account_id, transaction_date DESC);

ANALYZE transactions;


-- SECTION 9: QUERY PLAN AFTER INDEXING

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    transaction_id,
    account_id,
    amount,
    transaction_date
FROM transactions
WHERE account_id = 1
  AND transaction_date >=
      CURRENT_TIMESTAMP - INTERVAL '7 days'
ORDER BY transaction_date DESC;


-- SECTION 10: VERIFY INDEX

SELECT
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'transactions'
ORDER BY indexname;


-- SECTION 11: VERIFY TEST DATA COUNT

SELECT
    COUNT(*) AS performance_test_transactions
FROM transactions
WHERE description LIKE 'PERFORMANCE TEST DATA #%';