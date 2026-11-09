 FlexPay Financial Technologies
Portfolio 3: Transactions and Concurrency

1. Introduction

For this part of the assignment, I worked with PostgreSQL to understand how financial transactions are handled in a database.

I used FlexPay, my fictional digital banking platform, as the case study. I focused on some of the operations that would normally take place in a banking application, including deposits, withdrawals and transfers. I also tested how PostgreSQL handles transactions that need to be cancelled and what happens when two users try to access the same account at the same time.

2. Deposit Processing

I started by testing a deposit of ₦10,000 into Chinaza Nweke's account.

I used `BEGIN` to start the transaction, then used an `UPDATE` statement to increase her account balance. After that, I inserted a record of the deposit into the transactions table.

Finally, I used `COMMIT` to save the changes.

Her balance increased from ₦450,000 to ₦460,000, and the deposit appeared in the transaction history.

One thing I wanted to ensure was that the balance update and the transaction record were handled together rather than treating them as two unrelated operations.

3. Withdrawal Processing

Next, I tested a withdrawal of ₦5,000 from the same account.

I reduced Chinaza's balance from ₦460,000 to ₦455,000 and recorded the withdrawal in the transactions table. I also included a condition in the SQL statement to check that the account had enough money before deducting the amount.

After confirming that the withdrawal was recorded correctly, I committed the transaction.

This exercise helped me understand why balance checks are important when developing a financial database.

4. Internal Fund Transfer

I then tested a transfer of ₦20,000 from Chinaza's account to Hadizat Aliu's account.

The transfer involved three main operations:

- Deducting ₦20,000 from Chinaza's account.
- Adding ₦20,000 to Hadizat's account.
- Recording the transfer, including the sender's and receiver's account identifiers.

After the transfer, Chinaza's balance was ₦435,000, while Hadizat's balance increased from ₦85,500 to ₦105,500.

I used a single database transaction for these operations and committed them after checking the transfer record.

This was particularly useful because it showed me that an internal transfer involves updating two different accounts, not just recording a transaction.

5. Testing ROLLBACK

I also wanted to see what happens when a change is made but should not be saved.

For this test, I used Oluwatomisin Banjoko's account. I temporarily increased the balance by ₦50,000, which changed it from ₦1,250,000 to ₦1,300,000.

I then executed `ROLLBACK` instead of `COMMIT`.

When I checked the account again, the balance had returned to ₦1,250,000.

This showed me that PostgreSQL can cancel changes made during an open transaction, provided they have not already been committed.

6. Concurrency and Row-Level Locking

For the concurrency exercise, I opened two separate PostgreSQL sessions connected to the same database.

In the first session, I started a transaction and used `SELECT FOR UPDATE` to lock Hadizat's account.

I then switched to the second session and attempted to deduct ₦1,000 from the same account.

The second session did not complete immediately. It waited because the first session was still holding a lock on the account.

After I committed the transaction in the first session, the second session was able to complete its update. I then used `ROLLBACK` in the second session to cancel the test deduction.

Hadizat's balance remained ₦105,500.

This was one of the more interesting parts of the exercise because I could actually see how PostgreSQL handles two operations trying to modify the same account at the same time.

7. Final Account Balances

After completing the exercises, I checked the balances of all three accounts to make sure the results were correct.

| Customer | Final balance |
|---|---:|
| Chinaza Nweke | ₦435,000.00 |
| Oluwatomisin Banjoko | ₦1,250,000.00 |
| Hadizat Aliu | ₦105,500.00 |
| **Total** | **₦1,790,500.00** |

The test deposit, withdrawal and internal transfer were reflected in the balances. The temporary changes made during the rollback and concurrency exercises were not retained.

8. What I Learned
This exercise helped me understand database transactions better, especially how they apply to a banking system.

I had used SQL to insert and update records before, but this was my first time testing how different operations could be grouped together and handled as one transaction. I now understand why COMMIT and ROLLBACK are important and when each one is used.

The concurrency test was probably the part I found most interesting. I opened two database sessions and tried to update the same account from both. I noticed that the second session had to wait until I committed the first transaction before it could continue. This made it easier for me to understand how PostgreSQL prevents two operations from interfering with each other.

I also learnt that a fund transfer involves more than simply moving money from one account to another. The sender's account has to be debited, the receiver's account credited, and the transaction properly recorded. These steps need to be handled together to avoid incorrect account balances.

Overall, the practical work helped me see how the concepts I had learnt in class actually work. It also made me appreciate why accuracy and proper transaction handling are so important when working with financial databases.

9. Tools Used

- PostgreSQL 18.6
- Postgres.app
- Visual Studio Code
- macOS Terminal

10. Evidence

Screenshots of the SQL commands and their outputs will be included to show the deposit, withdrawal, internal transfer, rollback and concurrency tests carried out during this exercise.