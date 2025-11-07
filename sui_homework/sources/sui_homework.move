/// Module: sui_homework
/// Author: Thomas Hill
/// Description:
/// A simple on-chain counter allowing users to create, own, and increment

module sui_homework::sui_homework;

use sui::clock;
use sui::event;
use sui::object;
use sui::transfer;
use sui::tx_context;

// Main Counter object
public struct Counter has key {
    id: UID,
    owner: address,
    value: u64,
    timestamp: u64,
}

// Event emitted when a new counter is created
public struct CounterCreated has copy, drop {
    owner: address,
    counter_id: object::ID,
    timestamp: u64,
}

// Event emitted when a counter is incremented
public struct CounterIncremented has copy, drop {
    owner: address,
    counter_id: object::ID,
    new_value: u64,
}

// Creates a new counter object for the caller of the function
// uses 'sui::clock' to record time of creation
// Created Counter is transferred to sender's address
public fun create_counter(clock: &clock::Clock, ctx: &mut TxContext) {
    let time = clock::timestamp_ms(clock);

    // Construct new counter object
    let counter = Counter {
        id: object::new(ctx),
        owner: ctx.sender(),
        value: 0,
        timestamp: time,
    };

    // Emitted event for logging
    event::emit(CounterCreated {
        owner: ctx.sender(),
        counter_id: object::id(&counter),
        timestamp: time,
    });
    // Ownership transfer to sender
    transfer::transfer(counter, ctx.sender())
}

// Increments the counter by 1
// Ensures only the counter's owner can increment using 'assert!'
public fun increment(counter: &mut Counter, ctx: &mut TxContext) {
    let sender = tx_context::sender(ctx);
    assert!(sender == counter.owner, 0);
    counter.value = counter.value + 1;

    // Event emitted for logging
    event::emit(CounterIncremented {
        owner: ctx.sender(),
        counter_id: object::id(counter),
        new_value: counter.value,
    })
}

// Returns counter value as read only
public fun get_value(counter: &Counter): u64 {
    counter.value
}
