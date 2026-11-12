
require('dotenv').config();
const { MongoClient } = require('mongodb');

const uri = process.env.MONGODB_URI;
const client = new MongoClient(uri);

async function main() {
    try {
        await client.connect();

        const db = client.db('flexpay_nosql');
        const transactions = db.collection('transactions');

        // Create a unique index for transaction IDs
        await transactions.createIndex(
            { transactionId: 1 },
            { unique: true }
        );

        // Sample FlexPay transaction documents
        const sampleTransactions = [
            {
                transactionId: 'FP-TXN-1001',
                type: 'DEPOSIT',
                amount: 150000,
                currency: 'NGN',
                sourceAccount: '6905837461',
                destinationAccount: null,
                status: 'SUCCESS',
                transactionDate: new Date('2026-10-01T09:00:00Z'),
                customer: {
                    customerId: 1,
                    firstName: 'Chinaza',
                    lastName: 'Nweke'
                },
                description: 'Customer cash deposit'
            },
            {
                transactionId: 'FP-TXN-1002',
                type: 'WITHDRAWAL',
                amount: 25000,
                currency: 'NGN',
                sourceAccount: '6905837461',
                destinationAccount: null,
                status: 'SUCCESS',
                transactionDate: new Date('2026-10-02T11:30:00Z'),
                customer: {
                    customerId: 1,
                    firstName: 'Chinaza',
                    lastName: 'Nweke'
                },
                description: 'ATM withdrawal'
            },
            {
                transactionId: 'FP-TXN-1003',
                type: 'TRANSFER',
                amount: 20000,
                currency: 'NGN',
                sourceAccount: '6905837461',
                destinationAccount: '0194628175',
                status: 'SUCCESS',
                transactionDate: new Date('2026-10-03T14:15:00Z'),
                customer: {
                    customerId: 1,
                    firstName: 'Chinaza',
                    lastName: 'Nweke'
                },
                description: 'Internal account transfer'
            },
            {
                transactionId: 'FP-TXN-1004',
                type: 'DEPOSIT',
                amount: 50000,
                currency: 'NGN',
                sourceAccount: '0194628175',
                destinationAccount: null,
                status: 'PENDING',
                transactionDate: new Date('2026-10-04T08:45:00Z'),
                customer: {
                    customerId: 3,
                    firstName: 'Hadizat',
                    lastName: 'Aliu'
                },
                description: 'Bank deposit awaiting confirmation'
            }
        ];

        // Insert or update sample records without creating duplicates
        await transactions.bulkWrite(
            sampleTransactions.map(document => ({
                replaceOne: {
                    filter: { transactionId: document.transactionId },
                    replacement: document,
                    upsert: true
                }
            }))
        );

        console.log('\n--- ALL FLEXPAY TRANSACTIONS ---');

        const allTransactions = await transactions
            .find({})
            .sort({ transactionDate: 1 })
            .toArray();

        console.log(JSON.stringify(allTransactions, null, 2));

        // Find successful transactions above ₦10,000
        console.log('\n--- SUCCESSFUL TRANSACTIONS ABOVE ₦10,000 ---');

        const filteredTransactions = await transactions
            .find({
                status: 'SUCCESS',
                amount: { $gt: 10000 }
            })
            .toArray();

        console.log(JSON.stringify(filteredTransactions, null, 2));

        // Aggregate transaction count and total amount by type
        console.log('\n--- TRANSACTION SUMMARY BY TYPE ---');

        const summary = await transactions.aggregate([
            {
                $group: {
                    _id: '$type',
                    transactionCount: { $sum: 1 },
                    totalAmount: { $sum: '$amount' }
                }
            },
            {
                $sort: { _id: 1 }
            }
        ]).toArray();

        console.log(JSON.stringify(summary, null, 2));

        console.log('\nFlexPay NoSQL operations completed successfully.');

    } catch (error) {
        console.error('Error:', error.message);
        process.exitCode = 1;
    } finally {
        await client.close();
    }
}

main();
