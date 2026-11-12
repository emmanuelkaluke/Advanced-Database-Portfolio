# Portfolio 4: NoSQL and Advanced Data Models

## 1. Introduction

This practical exercise explores the use of a NoSQL document database for FlexPay Financial Technologies, a fictional Nigerian fintech platform that provides digital payment services, customer accounts, deposits, withdrawals and fund transfers.

MongoDB Atlas was selected to demonstrate how a document-oriented database can store and retrieve transaction information. The implementation uses MongoDB as a complementary data model to the PostgreSQL relational database developed in the earlier portfolio activities.

## 2. Database Model and Implementation

MongoDB uses a document-oriented data model in which information is stored in BSON documents inside collections.

For this exercise, a database named `flexpay_nosql` and a collection named `transactions` were created.

Each transaction document contains:
- Transaction ID
- Transaction type
- Transaction amount
- Currency
- Source and destination account numbers
- Transaction status
- Transaction date
- Embedded customer information
- Transaction description

Customer information is embedded directly within each transaction document. This allows transaction records to be retrieved together with relevant customer details without requiring a separate database join.

Four sample transaction documents were implemented, covering deposits, withdrawals, transfers and pending transactions.

## 3. MongoDB Operations Performed

The implementation was carried out using JavaScript and the official MongoDB Node.js driver.

The following operations were demonstrated:

**a. Database connection**

A connection was established between the JavaScript application and MongoDB Atlas using a connection string stored securely in a local environment file.

**b. Document insertion and updating**

The `bulkWrite()` method with `replaceOne` and `upsert` was used to insert or update the four sample transaction documents. This also prevents duplicate transaction records when the script is executed repeatedly.

**c. Indexing**

A unique index was created on the `transactionId` field. This improves retrieval by transaction ID and prevents multiple documents from having the same transaction ID.

**d. Data retrieval and filtering**

The `find()` method was used to retrieve transaction documents. A filter was also applied to retrieve successful transactions with amounts greater than ₦10,000.

**e. Aggregation**

MongoDB's aggregation pipeline was used to group transactions by type and calculate the number of transactions and total transaction amount for each category.

## 4. Advantages of the Document Database Model

MongoDB offers several advantages for a fintech application such as FlexPay:

1. **Flexible structure:** Documents can contain different fields, making it easier to accommodate changing transaction information.
2. **Embedded information:** Related customer details can be stored alongside transaction records, reducing the need for joins when retrieving data.
3. **Scalability:** MongoDB supports horizontal scaling through sharding, allowing data to be distributed across multiple servers.
4. **Efficient retrieval:** Indexes can improve the speed of frequently executed queries.
5. **Aggregation capabilities:** The aggregation framework supports filtering, grouping and summarising large collections of records.

## 5. Limitations and Comparison with PostgreSQL

Although MongoDB provides flexibility, it also has limitations.

Unlike PostgreSQL, MongoDB does not enforce traditional relational foreign-key constraints between collections. Applications must therefore manage relationships and data consistency carefully.

Embedding customer details in transaction documents can also result in duplicated information. If customer information changes, multiple documents containing the old information may need to be updated.

PostgreSQL is more suitable for FlexPay's core financial records where structured relationships, constraints, consistency and reliable transaction processing are essential. MongoDB can complement PostgreSQL by supporting flexible transaction metadata, activity feeds and other document-oriented information.

MongoDB also supports multi-document transactions, but these require careful design and do not remove the need for appropriate financial controls.

## 6. Suitability for FlexPay

A document database can be useful for storing flexible transaction metadata, customer activity information, notifications and transaction history views.

For this project, MongoDB demonstrates an alternative way of modelling and retrieving financial transaction information.

However, it should not automatically replace the relational database responsible for the core financial ledger. PostgreSQL remains appropriate for maintaining account balances and enforcing financial integrity, while MongoDB can serve complementary application requirements.

## 7. Conclusion

This exercise provided practical experience with MongoDB Atlas, document creation, indexing, filtering and aggregation using JavaScript.

The implementation demonstrates how NoSQL databases differ from relational databases and how both models can serve different requirements within a fintech platform.

The exercise also reinforced the importance of selecting a database model based on the application's data structure, consistency requirements and operational needs.

## 8. AI Assistance Declaration

AI assistance was used to support the planning, explanation and development of the MongoDB implementation and documentation. The generated code was executed and tested against the MongoDB Atlas environment. The implementation and its outputs were reviewed during the practical exercise.