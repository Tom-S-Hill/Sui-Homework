module sui_homework::sui_homework;

use sui::clock::{Self, Clock};
use sui::object;
use sui::transfer;
use sui::tx_context::{Self, TxContext};

public struct Counter has key {
    id: UID,
    owner: address,
    value: u64,
    timestamp: u64,
}

public fun create_counter(clock: &Clock, ctx: &mut TxContext) {
    let time = Clock::now_ms(clock);
    let counter = Counter {
        id: object::new(ctx),
        owner: ctx.sender(),
        value: 0,
        timestamp: time,
    };
    transfer::transfer(counter, ctx.sender())
}

public fun increment(counter: &mut Counter, ctx: &mut TxContext) {
    counter.value = counter.value + 1;
}

public fun get_value(counter: &Counter): u64 {
    counter.value
}
