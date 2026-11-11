# Portfolio 5: Distributed and Cloud Database Exercise

## 1. Introduction

This exercise explores distributed database concepts using FlexPay Financial Technologies, a fictional Nigerian fintech platform that provides digital financial services, including deposits, withdrawals, transfers and payment processing.

MongoDB Atlas was used to demonstrate cloud database deployment, replication, read preferences and consistency. A JavaScript simulation was also developed to demonstrate horizontal partitioning (sharding).

The purpose of this exercise was to understand how distributed database technologies support data availability, reliability, scalability and efficient access to information.

## 2. Cloud Database Deployment

MongoDB Atlas was selected as the cloud database platform. A free-tier cluster named `FlexPayCluster` was deployed on Amazon Web Services (AWS) in the France region.

A database named `flexpay_nosql` was used for the practical implementation.

The application connected to the cloud database through the MongoDB Node.js driver. Connection credentials were stored in a local environment file rather than being included directly in the application code.

Using a managed cloud database reduces the need to maintain database servers manually and provides access to managed infrastructure and database administration features.

## 3. Database Replication

Database replication involves maintaining copies of data across multiple database servers. It helps improve data availability and provides resilience against individual server failures.

The FlexPay MongoDB Atlas cluster was confirmed to use a replica set containing three members.

The practical test returned the following results:

- Replica set name: `atlas-d4rfs0-shard-0`
- Number of replica set members: 3
- Primary server: `ac-n6uuaze-shard-00-02.ogyjfbl.mongodb.net:27017`
- Primary server status: Writable primary.

The replica set members were successfully identified using MongoDB's `hello` command.

A sample transaction with ID `FP-DIST-1001` and an amount of ₦100,000 was written to the database.

The write operation returned `Acknowledged: true`, confirming that the database acknowledged the operation using majority write concern.

This demonstrated the use of replication and acknowledged writes in a cloud database environment.

## 4. Consistency and Read Preferences

Consistency is important in financial applications because customers must receive reliable information about their transactions and account activities.

The implementation used the following MongoDB settings:

**Majority write concern**

`writeConcern: { w: 'majority' }`

This requires acknowledgement from a majority of the eligible replica set voting members before the write is considered successful.

**Majority read concern**

`readConcern: { level: 'majority' }`

This allows the application to read data that has been acknowledged by a majority of the replica set members.

The transaction was successfully retrieved using majority read concern.

A second test used the `secondaryPreferred` read preference. This instructs MongoDB to prefer secondary members for read operations, falling back to the primary when a suitable secondary is unavailable.

The test successfully retrieved transaction `FP-DIST-1001`.

These settings demonstrate how MongoDB provides different options for balancing consistency and read workload distribution.

## 5. Database Availability and Fault Tolerance

Availability refers to the ability of a database system to remain accessible when individual components fail.

MongoDB replica sets support automatic primary election. If the current primary becomes unavailable, eligible secondary members can participate in electing a replacement primary.

This reduces dependence on a single database server and helps applications recover from certain server failures.

For FlexPay, this capability is important because customers may need access to transaction information and financial services throughout the day.

The three-member replica set was inspected successfully. However, an actual primary failure and automatic election were not deliberately triggered during this exercise. The failover behaviour is therefore explained based on MongoDB's replica set architecture rather than presented as a tested result.

## 6. Horizontal Partitioning (Sharding)

Sharding is a distributed database technique that divides a large dataset into smaller portions called shards. These portions can be distributed across multiple servers to improve scalability and support larger workloads.

For FlexPay, transactions could be distributed using account identifiers as a shard key.

A JavaScript simulation was developed to demonstrate this concept using three logical shards:

- Shard 1: Account IDs from 1 to 1,000.
- Shard 2: Account IDs from 1,001 to 2,000.
- Shard 3: Account IDs above 2,000.

Nine sample transactions were distributed across the three logical shards.

The simulation produced the following results:

| Shard | Transactions |
|---|---:|
| Shard 1 | 3 |
| Shard 2 | 3 |
| Shard 3 | 3 |
| Total | 9 |

The results confirmed that all nine transactions were distributed successfully.

This was a conceptual JavaScript simulation rather than an actual MongoDB sharded deployment. The free-tier Atlas cluster used for this exercise was a replica set, not a sharded cluster.

## 7. Benefits and Limitations of Distributed Cloud Databases

### Benefits

1. **High availability:** Replica sets provide redundancy and support automatic primary election.
2. **Data resilience:** Replication maintains copies of data across multiple database members.
3. **Scalability:** Sharding can distribute large datasets and workloads across multiple servers.
4. **Flexible access:** Read preferences allow applications to control which replica members serve read operations.
5. **Reduced infrastructure management:** Managed cloud platforms such as MongoDB Atlas handle much of the underlying database infrastructure.

### Limitations

1. **Network dependency:** Cloud database access depends on a reliable internet connection.
2. **Operational costs:** Higher-capacity clusters and additional cloud resources can increase costs.
3. **Consistency considerations:** Applications must select suitable read and write concerns for their requirements.
4. **Configuration complexity:** Distributed systems require careful management of replication, access control and network security.
5. **Sharding complexity:** Selecting an appropriate shard key is important because poor distribution can create uneven workloads.

## 8. Application to FlexPay

A distributed database architecture could help FlexPay support increasing transaction volumes and maintain access to application data.

Replication could improve resilience, while suitable read preferences could distribute some read workloads across replica members.

Sharding could become useful as transaction records grow significantly, allowing data to be distributed across multiple database servers.

However, financial transaction processing requires strong integrity controls. FlexPay should continue to use an appropriately designed relational database such as PostgreSQL for its core financial ledger, while distributed NoSQL services can support complementary workloads.

The choice of consistency settings, backup strategy, security controls and recovery procedures would be important when deploying such an architecture in production.

## 9. Conclusion

This exercise provided practical experience with distributed database concepts using MongoDB Atlas and JavaScript.

The implementation successfully identified a three-member replica set, performed a majority-acknowledged write, retrieved data using majority read concern and demonstrated secondary-preferred reads.

A separate JavaScript simulation demonstrated how horizontal partitioning could distribute FlexPay transactions across three logical shards.

The exercise improved my understanding of replication, consistency, availability, cloud database deployment and scalability. It also demonstrated the importance of selecting an appropriate database architecture for the operational requirements of a financial technology platform.

## 10. AI Assistance Declaration

AI assistance was used to support the planning, explanation, coding and documentation of this exercise. The JavaScript implementations were executed against the MongoDB Atlas environment, and their outputs were reviewed during the practical work. The sharding exercise was implemented as a simulation rather than a live sharded database deployment.