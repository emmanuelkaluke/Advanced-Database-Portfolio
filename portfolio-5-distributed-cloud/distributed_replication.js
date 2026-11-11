
require('dotenv').config();
const { MongoClient } = require('mongodb');

const uri = process.env.MONGODB_URI;
const client = new MongoClient(uri);

async function main() {
    try {
        await client.connect();

        console.log('Connected to FlexPay MongoDB Atlas.');

        // 1. Inspect the replica set topology
        const admin = client.db('admin');
        const topology = await admin.command({ hello: 1 });

        console.log('\n--- REPLICA SET INFORMATION ---');
        console.log('Replica set name:', topology.setName);
        console.log('Primary server:', topology.primary);
        console.log('Current server is primary:', topology.isWritablePrimary);
        console.log('Known replica set members:', topology.hosts?.length);

        if (topology.hosts) {
            console.log('Replica set members:');
            topology.hosts.forEach(host => console.log('-', host));
        }

        // 2. Configure majority write concern
        const db = client.db('flexpay_nosql');
        const transactions = db.collection('replication_demo', {
            writeConcern: { w: 'majority' }
        });

        // 3. Write a sample FlexPay transaction
        const transaction = {
            transactionId: 'FP-DIST-1001',
            type: 'DEPOSIT',
            amount: 100000,
            currency: 'NGN',
            status: 'SUCCESS',
            description: 'Distributed database replication test',
            createdAt: new Date()
        };

        const writeResult = await transactions.updateOne(
            { transactionId: transaction.transactionId },
            { $set: transaction },
            { upsert: true }
        );

        console.log('\n--- MAJORITY WRITE RESULT ---');
        console.log('Acknowledged:', writeResult.acknowledged);
        console.log('Matched documents:', writeResult.matchedCount);
        console.log('Inserted new document:', writeResult.upsertedCount > 0);

        // 4. Read using majority read concern
        const consistentTransactions = db.collection(
            'replication_demo',
            { readConcern: { level: 'majority' } }
        );

        const result = await consistentTransactions.findOne({
            transactionId: 'FP-DIST-1001'
        });

        console.log('\n--- MAJORITY READ RESULT ---');
        console.log(JSON.stringify(result, null, 2));

        console.log('\nFlexPay distributed database demonstration completed.');

    } catch (error) {
        console.error('Distributed database test failed:', error.message);
        process.exitCode = 1;
    } finally {
        await client.close();
    }
}

main();
