module sui_homework::sui_homework;

use sui::clock;
use sui::event;
use sui::object;
use sui::transfer;
use sui::tx_context;

public struct Counter has key {
    id: UID,
    owner: address,
    value: u64,
    timestamp: u64,
}

public struct CounterCreated has copy, drop {
    owner: address,
    counter_id: object::ID,
    timestamp: u64,
}

public struct CounterIncremented has copy, drop {
    owner: address,
    counter_id: object::ID,
    new_value: u64,
}

public fun create_counter(clock: &clock::Clock, ctx: &mut TxContext) {
    let time = clock::timestamp_ms(clock);
    let counter = Counter {
        id: object::new(ctx),
        owner: ctx.sender(),
        value: 0,
        timestamp: time,
    };

    event::emit(CounterCreated {
        owner: ctx.sender(),
        counter_id: object::id(&counter),
        timestamp: time,
    });
    transfer::transfer(counter, ctx.sender())
}

public fun increment(counter: &mut Counter, ctx: &mut TxContext) {
    let sender = tx_context::sender(ctx);
    assert!(sender == counter.owner, 0);
    counter.value = counter.value + 1;

    event::emit(CounterIncremented {
        owner: ctx.sender(),
        counter_id: object::id(counter),
        new_value: counter.value,
    })
}

public fun get_value(counter: &Counter): u64 {
    counter.value
}
