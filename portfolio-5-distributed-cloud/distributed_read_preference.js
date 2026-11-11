
require('dotenv').config();
const { MongoClient, ReadPreference } = require('mongodb');

const uri = process.env.MONGODB_URI;

const client = new MongoClient(uri, {
    readPreference: ReadPreference.secondaryPreferred
});

async function main() {
    try {
        await client.connect();

        console.log('Connected to FlexPay MongoDB Atlas.');

        const db = client.db('flexpay_nosql');

        const transactions = db.collection('replication_demo', {
            readConcern: { level: 'majority' }
        });

        console.log('\n--- READ PREFERENCE CONFIGURATION ---');
        console.log('Configured read preference: secondaryPreferred');
        console.log('Read concern: majority');

        const result = await transactions.findOne({
            transactionId: 'FP-DIST-1001'
        });

        console.log('\n--- TRANSACTION RETRIEVED ---');

        if (result) {
            console.log(JSON.stringify(result, null, 2));
            console.log('\nTransaction successfully retrieved.');
        } else {
            console.log('Transaction was not found.');
        }

        console.log('\nFlexPay read preference demonstration completed.');

    } catch (error) {
        console.error('Read preference test failed:', error.message);
        process.exitCode = 1;
    } finally {
        await client.close();
    }
}

main();
