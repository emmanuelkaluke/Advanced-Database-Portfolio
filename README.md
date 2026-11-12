# MIT 8103 – Advanced Database Systems
## Individual Practical Database Portfolio (2026/2027 First Semester)

**Case Study:** FlexPay Financial Technologies  
**Database Technologies:** PostgreSQL and MongoDB

---

## 1. Introduction

This repository contains the practical work I completed for my Advanced Database Systems course.

For the project, I created a fictional fintech company called **FlexPay Financial Technologies**, based in Nigeria. The company provides digital financial services such as customer account management, deposits, withdrawals, transfers and transaction processing.

I used FlexPay as the case study throughout the five portfolio activities. This made it possible to apply the different database concepts to one business scenario rather than treating each exercise as an unrelated task.

The project gave me an opportunity to work with relational databases, SQL queries, transactions, NoSQL databases and distributed database systems.

## 2. Tools and Technologies

The following tools were used during the project:

| Technology | How I used it |
|---|---|
| PostgreSQL 18 | Creating and managing the relational database |
| MongoDB Atlas | Working with a cloud-based NoSQL database |
| JavaScript / Node.js | Running MongoDB operations and simulations |
| Visual Studio Code | Writing and editing scripts and documentation |
| Git and GitHub | Tracking changes and storing my project files |
| Mermaid | Creating the database relationship diagram |

## 3. Portfolio Activities

The project is divided into five activities, with each one focusing on a different area of database management.

### Portfolio 1 – Database Design and Modelling
Folder: `portfolio-1-database-design`

This was where I started building the FlexPay database. I identified the main information the company would need to store and organised it into three related tables: customers, accounts and transactions.

The work covered:
- Identifying the entities and their relationships.
- Creating an Entity Relationship Diagram (ERD).
- Designing the relational schema.
- Defining primary keys and foreign keys.
- Applying constraints to maintain data accuracy.
- Normalising the database up to Third Normal Form (3NF).

### Portfolio 2 – Query Processing and Optimisation
Folder: `portfolio-2-query-optimisation`

In this activity, I worked with SQL queries to retrieve and analyse information from the FlexPay database.

I practised using SELECT statements, filtering, sorting, joins, aggregate functions and subqueries. I also explored how indexes can improve query performance.

One of the practical exercises involved comparing a query before and after creating an index on `account_id` and `transaction_date`.

The execution time decreased from 2.593 ms to 1.354 ms after the index was created. This helped me understand how indexing can make data retrieval more efficient.

### Portfolio 3 – Transactions and Concurrency
Folder: `portfolio-3-transactions-concurrency`

This activity focused on how databases handle operations that need to be completed reliably, especially in a financial environment.

I used FlexPay account deposits, withdrawals and transfers to practise transaction management.

The exercises included:
- Using COMMIT and ROLLBACK.
- Carrying out deposits, withdrawals and transfers.
- Testing what happens when a transaction is rolled back.
- Using row-level locking with `SELECT FOR UPDATE`.
- Observing how PostgreSQL handles simultaneous updates.

The concurrency exercise helped me understand why transaction control is important when multiple users or processes try to access the same account.

### Portfolio 4 – NoSQL and Advanced Data Models
Folder: `portfolio-4-nosql`

For this activity, I worked with MongoDB Atlas to explore how a NoSQL database stores and manages information.

Unlike the relational structure used in PostgreSQL, MongoDB stores information as documents. I used this approach to create and manage sample FlexPay transaction records.

The practical work included:
- Connecting to MongoDB Atlas.
- Creating and updating transaction documents.
- Filtering records.
- Performing aggregation operations.
- Creating a unique index.
- Exploring the advantages of document-based storage.

This exercise helped me understand where a NoSQL database can be useful alongside a traditional relational database.

### Portfolio 5 – Distributed and Cloud Database Exercise
Folder: `portfolio-5-distributed-cloud`

The final activity focused on distributed databases and cloud-based database services.

Using my MongoDB Atlas cluster, I examined its replica set configuration and carried out practical tests involving majority write concern, majority read concern and read preferences.

I also wrote a JavaScript simulation to demonstrate how transactions could be divided across three logical shards.

The work covered:
- Inspecting the MongoDB Atlas replica set.
- Testing majority write and read operations.
- Configuring secondary-preferred reads.
- Simulating horizontal partitioning (sharding).
- Exploring database availability, consistency and scalability.

One important distinction is that my Atlas cluster used a three-member replica set. It was not an actual sharded cluster. The sharding exercise was therefore implemented as a JavaScript simulation.

## 4. Database Structure

The main relational database is named `flexpay_db` and contains three tables:

- `customers` – stores customer details.
- `accounts` – stores account information and balances.
- `transactions` – keeps records of deposits, withdrawals and transfers.

For the NoSQL exercises, I also created a MongoDB database named `flexpay_nosql`, with a `transactions` collection.

## 5. Project Organisation

Each portfolio activity has its own folder containing the relevant implementation files and documentation.

I also included an `evidence` folder in each activity where applicable. This contains screenshots of the work carried out, including database structures, query execution plans, transaction tests and MongoDB outputs.

The aim was to keep the project organised so that the implementation and the evidence supporting it could be easily reviewed.

## 6. Running the Project

### PostgreSQL

PostgreSQL is required to run the relational database scripts.

After installing PostgreSQL, create a database named `flexpay_db` and execute the relevant SQL scripts.

For example:

```bash
psql -d flexpay_db -f portfolio-1-database-design/schema.sql
```

The schema script creates the database tables. It should not be executed again against a database where those tables already exist.

### MongoDB

Node.js is required to run the MongoDB JavaScript files.

Install the project dependencies using:

```bash
npm install
```

A local `.env` file containing the MongoDB Atlas connection string is also required.

Database credentials and connection strings should remain private and must not be uploaded to GitHub.

## 7. What I Learned

Working through these activities helped me understand how database concepts are applied in practical situations.

I gained experience designing relational databases, writing SQL queries, improving query performance and managing transactions. I also had the opportunity to work with MongoDB and explore how cloud databases handle replication and read operations.

One of the things I found particularly useful was comparing PostgreSQL and MongoDB. It helped me understand that different database technologies have different strengths and that the choice depends on the type of application and the data being handled.

I also became more comfortable using the Terminal, VS Code, Git and GitHub to manage a technical project.

## 8. Conclusion

Overall, this project gave me the opportunity to put several Advanced Database Systems concepts into practice using one case study.

Building the FlexPay database helped me understand how relational databases can organise financial information, while the MongoDB exercises introduced me to document-based storage and distributed database concepts.

The practical exercises also showed me why data integrity, performance, availability and scalability are important when designing systems that handle financial transactions.

## 9. AI Assistance Declaration

AI tools were used to assist with understanding database concepts, troubleshooting, reviewing code and preparing some of the project documentation.

I executed the practical scripts and database operations in my development environment and reviewed the results. I also used the assistance to improve my understanding of the different exercises.

The final implementation, explanations and results were reviewed against the practical work carried out during the project.