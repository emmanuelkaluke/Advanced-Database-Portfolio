# FlexPay Financial Technologies
## Entity Relationship Diagram (ERD)

```mermaid
erDiagram
    CUSTOMERS ||--o{ ACCOUNTS : owns
    ACCOUNTS ||--o{ TRANSACTIONS : records
    ACCOUNTS o|--o{ TRANSACTIONS : receives

    CUSTOMERS {
        integer customer_id PK
        varchar first_name
        varchar last_name
        varchar email UK
        varchar phone UK
        date date_of_birth
        timestamp created_at
    }

    ACCOUNTS {
        integer account_id PK
        integer customer_id FK
        varchar account_number UK
        varchar account_type
        numeric balance
        varchar currency
        timestamp created_at
    }

    TRANSACTIONS {
        integer transaction_id PK
        integer account_id FK
        integer destination_account_id FK
        varchar transaction_type
        numeric amount
        timestamp transaction_date
        text description
        varchar status
    }
```

## Relationship Explanation

1. **Customers and Accounts:** One customer can own multiple accounts, but each account belongs to one customer.
2. **Accounts and Transactions:** One account can originate many transactions, but each transaction has one originating account.
3. **Destination Accounts:** An account can receive many transfers. Each transaction may have zero or one destination account. External transfers and deposits or withdrawals do not require a destination account.