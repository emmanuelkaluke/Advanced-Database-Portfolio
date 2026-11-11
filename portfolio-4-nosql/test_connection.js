
require('dotenv').config();
const { MongoClient } = require('mongodb');

const uri = process.env.MONGODB_URI;

if (!uri) {
    throw new Error('MONGODB_URI is missing from the .env file');
}

const client = new MongoClient(uri);

async function main() {
    try {
        await client.connect();

        console.log('Successfully connected to MongoDB Atlas!');

        const db = client.db('flexpay_nosql');
        const result = await db.command({ ping: 1 });

        console.log('Database ping successful:', result);
    } catch (error) {
        console.error('MongoDB connection failed:', error.message);
    } finally {
        await client.close();
    }
}

main();
