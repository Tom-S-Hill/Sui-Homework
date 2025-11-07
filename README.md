# Sui Bootcamp Homework – On-Chain Counter

### Overview

This is a simple on-chain counter built for the Sui Bootcamp homework.  
Each user can create their own counter object, check its current value, and increment it directly on the blockchain.

---

### How it works

The module defines a `Counter` object that stores:

- The owner’s address
- The current count value (starts at 0)
- The timestamp of when it was created

Two extra structs (`CounterCreated` and `CounterIncremented`) are used to emit events whenever something happens on-chain.

The timestamp comes from the Sui **Clock object** at address `0x6`, which holds the network time.

---

### Functions

- **`create_counter(clock, ctx)`** – creates a new counter owned by the sender, records the current time, and emits a creation event.
- **`increment(counter, ctx)`** – increases the counter by 1. Only the owner can call this, otherwise the transaction aborts.
- **`get_value(counter)`** – returns the current count (read-only).

Basic error handling is done with:

```move
assert!(sender == counter.owner, 0);
```

so no one else can increment your counter.

---

### Deployment info

**Package ID:** `0xb1e823e6b9ce2185cef9cd9cbbacaaa8620ec8ab1e59335740fc835f41842719`  
**Network:** Sui Testnet

To publish:

```bash
sui client publish --gas-budget 20000000
```

---

### How to use it

**1. Create a counter**

The Clock object lives at `0x6`, so it’s passed as an argument:

```bash
sui client call   --package 0xb1e823e6b9ce2185cef9cd9cbbacaaa8620ec8ab1e59335740fc835f41842719   --module sui_homework   --function create_counter   --args 0x6   --gas-budget 20000000
```

You’ll get a `CounterCreated` event with your new counter’s ID.

---

**2. Increment your counter**

```bash
sui client call   --package 0xb1e823e6b9ce2185cef9cd9cbbacaaa8620ec8ab1e59335740fc835f41842719   --module sui_homework   --function increment   --args <your_counter_id>   --gas-budget 10000000
```

You’ll see a `CounterIncremented` event showing the updated value.

---

**3. Check your counter**

```bash
sui client object <your_counter_id>
```

The output will include the `value` field and the timestamp.

### Summary

- Uses on-chain objects (`has key`)
- Stores owner, count, and creation time
- Emits events for create/increment
- Handles ownership errors safely

---

**Author:** Thomas Hill  
Sui Bootcamp – Simple Counter DApp
