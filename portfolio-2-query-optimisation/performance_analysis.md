# Portfolio 2: Query Processing and Optimisation

## 1. Introduction

This exercise examines how SQL queries are processed and how database performance can be improved through indexing and query optimisation. The FlexPay Financial Technologies database was used as the case study.

The database was implemented using PostgreSQL 18.6 on a MacBook running macOS. To provide a larger dataset for testing, 10,000 synthetic transaction records were added to the existing transactions table. These records were created for performance testing and did not represent actual customer transactions or change account balances.

## 2. SQL Queries Implemented

The following SQL operations were performed:

- **Basic retrieval:** Retrieved customer records and displayed them in an organised order.
- **Filtering:** Selected successful transactions above a specified amount.
- **Joins:** Combined the transactions, accounts and customers tables to retrieve related information.
- **Aggregation:** Used COUNT and SUM to analyse transactions by transaction type.
- **Subqueries:** Identified accounts with balances above the average account balance.

These operations demonstrated how SQL can retrieve and analyse information across related database tables.

## 3. Query Execution and Indexing

The PostgreSQL `EXPLAIN (ANALYZE, BUFFERS)` command was used to examine the execution plan of a query that retrieves transactions belonging to account ID 1 within the previous seven days.

The query was executed before and after creating a composite index on the account ID and transaction date columns.

The index was created using:

```sql
CREATE INDEX IF NOT EXISTS idx_transactions_account_date
ON transactions (account_id, transaction_date DESC);
```

### 3.1 Results Before Indexing

Before creating the index, PostgreSQL used a Sequential Scan to examine the transactions table.

- Rows returned: 70
- Rows removed by filter: 9,939
- Execution time: 2.593 ms
- Shared buffer hits: 124
- Planning time: 0.648 ms

The database scanned the table, filtered the matching records and sorted the results by transaction date.

### 3.2 Results After Indexing

After creating the composite index, PostgreSQL used a Bitmap Index Scan followed by a Bitmap Heap Scan.

- Rows returned: 70
- Execution time: 1.354 ms
- Shared buffer hits: 28
- Shared buffer reads: 2
- Planning time: 1.559 ms

The index helped PostgreSQL locate the matching records without performing a full sequential scan.

### 3.3 Performance Comparison

| Metric | Before Index | After Index |
|---|---:|---:|
| Scan method | Sequential Scan | Bitmap Index and Heap Scan |
| Rows returned | 70 | 70 |
| Execution time | 2.593 ms | 1.354 ms |
| Shared buffer hits | 124 | 28 |
| Planning time | 0.648 ms | 1.559 ms |

The execution time decreased by approximately 47.8% after indexing.

This demonstrates that an appropriate index can improve query performance. However, planning time increased slightly, and execution times can vary between runs depending on database and system conditions.

## 4. Analysis and Discussion

The results show that indexing can reduce the amount of work required to retrieve specific records. Before indexing, PostgreSQL examined the transactions table using a sequential scan. After indexing, it used the composite index to identify matching records.

The index was particularly suitable because the query filtered records using both `account_id` and `transaction_date`. Creating an index on these columns allowed PostgreSQL to use both conditions during index scanning.

The experiment also demonstrates that indexing should be applied carefully. Indexes require additional storage and can increase the work involved in INSERT, UPDATE and DELETE operations. Therefore, indexes should be created on columns frequently used in filtering, joining and sorting, rather than on every column.

## 5. Conclusion

This exercise demonstrated how SQL queries can be used to retrieve, combine and analyse financial transaction data. It also showed how PostgreSQL execution plans can help identify opportunities for database optimisation.

The composite index created on the transactions table reduced the observed query execution time from 2.593 ms to 1.354 ms, representing an improvement of approximately 47.8% in this test.

Overall, the exercise improved my understanding of query execution plans, indexing, database performance and the importance of testing optimisation techniques using actual database results.

## 6. Evidence

The following screenshots are included in the evidence folder:

1. `execution-plan-before-index.png` – execution plan before indexing.
2. `execution-plan-after-index.png` – execution plan after indexing.

Additional screenshots of query results and index verification will be included where applicable.