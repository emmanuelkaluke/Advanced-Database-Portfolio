
const transactions = [
    { transactionId: 'FP-001', accountId: 101, amount: 50000 },
    { transactionId: 'FP-002', accountId: 1200, amount: 25000 },
    { transactionId: 'FP-003', accountId: 2500, amount: 100000 },
    { transactionId: 'FP-004', accountId: 450, amount: 75000 },
    { transactionId: 'FP-005', accountId: 1800, amount: 30000 },
    { transactionId: 'FP-006', accountId: 2900, amount: 15000 },
    { transactionId: 'FP-007', accountId: 750, amount: 90000 },
    { transactionId: 'FP-008', accountId: 1500, amount: 40000 },
    { transactionId: 'FP-009', accountId: 2200, amount: 60000 }
];

// Simulate three logical database shards
const shards = {
    shard1: [],
    shard2: [],
    shard3: []
};

// Distribute transactions using account ID ranges
for (const transaction of transactions) {
    if (transaction.accountId <= 1000) {
        shards.shard1.push(transaction);
    } else if (transaction.accountId <= 2000) {
        shards.shard2.push(transaction);
    } else {
        shards.shard3.push(transaction);
    }
}

console.log('--- FLEXPAY SHARDING SIMULATION ---');

for (const [shardName, records] of Object.entries(shards)) {
    console.log(`\n${shardName.toUpperCase()}`);
    console.log('Number of transactions:', records.length);
    console.log(JSON.stringify(records, null, 2));
}

console.log('\n--- DISTRIBUTION SUMMARY ---');

for (const [shardName, records] of Object.entries(shards)) {
    console.log(`${shardName}: ${records.length} transactions`);
}

console.log('\nTotal transactions distributed:',
    Object.values(shards).reduce((total, records) => total + records.length, 0)
);

console.log('\nFlexPay sharding simulation completed.');
