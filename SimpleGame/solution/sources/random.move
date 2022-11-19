// SPDX-License-Identifier: Apache-2.0
// Based on: https://github.com/starcoinorg/starcoin-framework-commons/blob/main/sources/PseudoRandom.move

/// @title pseudorandom
/// @notice A pseudo random module on-chain.
/// @dev Warning: 
/// The random mechanism in smart contracts is different from 
/// that in traditional programming languages. The value generated 
/// by random is predictable to Miners, so it can only be used in 
/// simple scenarios where Miners have no incentive to cheat. If 
/// large amounts of money are involved, DO NOT USE THIS MODULE to 
/// generate random numbers; try a more secure way.
module challenge_one::random {
    use std::hash;
    use std::vector;

    use sui::bcs;
    use sui::object;
    use sui::tx_context::TxContext;
    
    const ERR_HIGH_ARG_GREATER_THAN_LOW_ARG: u64 = 101;

    fun mock_seed(num: u64, ctx: &mut TxContext): vector<u8> {
        // split the TxContext
        let ctx_bytes = bcs::new(bcs::to_bytes(ctx));
        let ctx_address = bcs::peel_address(&mut ctx_bytes);
        let ctx_digest = bcs::peel_vec_u8(&mut ctx_bytes);
        let ctx_epoch = bcs::peel_u64(&mut ctx_bytes);
        let ctx_ids_created = bcs::peel_u64(&mut ctx_bytes);
        let ids_created = ctx_ids_created + num;

        // create uid 
        let tmp: vector<u8> = vector::empty<u8>();
        vector::append<u8>(&mut tmp, ctx_digest);
        vector::append<u8>(&mut tmp, bcs::to_bytes(&ids_created));
        let tmp_uid_full: vector<u8> = hash::sha3_256(tmp);
        let tmp_uid_trucate: vector<u8> = vector::empty<u8>();
        let i = 0;
        while (i < 20){
            let tmp_bytes = vector::borrow<u8>(&tmp_uid_full, i);
            vector::push_back<u8>(&mut tmp_uid_trucate, *tmp_bytes);
            i = i + 1; 
        };
        assert!(vector::length(&tmp_uid_trucate) == 20, 1);

        // rebuild ctx_bytes
        let ctx_bytes_new: vector<u8> = vector::empty<u8>();
        vector::append<u8>(&mut ctx_bytes_new, bcs::to_bytes(&ctx_address));
        vector::append<u8>(&mut ctx_bytes_new, bcs::to_bytes(&ctx_digest));
        vector::append<u8>(&mut ctx_bytes_new, bcs::to_bytes(&ctx_epoch));
        vector::append<u8>(&mut ctx_bytes_new, bcs::to_bytes(&ids_created));

        // reuse `seed` process
        let info: vector<u8> = vector::empty<u8>();
        vector::append<u8>(&mut info, ctx_bytes_new);
        vector::append<u8>(&mut info, tmp_uid_trucate);
        let s = hash::sha3_256(info);
        s
    }

    public fun get_distance(ctx: &mut TxContext): u64 {
        let i = 0;
        while(true){
            let res = rand_u64_range(0, 100, i, ctx);
            if(res == 0){
                break
            };
            i = i + 1;
        };
        i
    }

    public fun manipulate(dist: u64, ctx: &mut TxContext){
        // update ctx with the distance
        let i = dist;
        while(i > 0){
            let id = object::new(ctx);
            object::delete(id);
            i = i - 1;
        };
    }


    fun bytes_to_u64(bytes: vector<u8>): u64 {
        let value = 0u64;
        let i = 0u64;
        while (i < 8) {
            value = value | ((*vector::borrow(&bytes, i) as u64) << ((8 * (7 - i)) as u8));
            i = i + 1;
        };
        return value
    }

    /// Generate a random u64
    fun rand_u64_with_seed(_seed: vector<u8>): u64 {
        bytes_to_u64(_seed)
    }

    /// Generate a random integer range in [low, high).
    fun rand_u64_range_with_seed(_seed: vector<u8>, low: u64, high: u64): u64 {
        assert!(high > low, ERR_HIGH_ARG_GREATER_THAN_LOW_ARG);
        let value = rand_u64_with_seed(_seed);
        (value % (high - low)) + low
    }

    /// Generate a random integer range in [low, high).
    public fun rand_u64_range(low: u64, high: u64, num: u64, ctx: &mut TxContext): u64 {
        rand_u64_range_with_seed(mock_seed(num, ctx), low, high)
    }


}
