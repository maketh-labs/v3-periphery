// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.26;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";

/// @title Provides functions for deriving a pool address from the factory, tokens, and the fee
library PoolAddress {
    /// @dev POOL_INIT_CODE_HASH for actual deployment, not from 0.8
    bytes32 internal constant POOL_INIT_CODE_HASH = 0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;

    /// @notice The identifying key of the pool
    struct PoolKey {
        address token0;
        address token1;
        uint24 fee;
    }

    /// @notice Returns PoolKey: the ordered tokens with the matched fee levels
    /// @param tokenA The first token of a pool, unsorted
    /// @param tokenB The second token of a pool, unsorted
    /// @param fee The fee level of the pool
    /// @return Poolkey The pool details with ordered token0 and token1 assignments
    function getPoolKey(address tokenA, address tokenB, uint24 fee) internal pure returns (PoolKey memory) {
        if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
        return PoolKey({token0: tokenA, token1: tokenB, fee: fee});
    }

    /// @notice Deterministically computes the pool address given the factory and PoolKey
    /// @param factory The Uniswap V3 factory contract address
    /// @param key The PoolKey
    /// @return pool The contract address of the V3 pool
    /// TODO: revert to original before deployment
    function computeAddress(address factory, PoolKey memory key) internal view returns (address pool) {
        require(key.token0 < key.token1);
        pool = IUniswapV3Factory(factory).getPool(key.token0, key.token1, key.fee);
        //pool = address(
        //    uint160(
        //        uint256(
        //            keccak256(
        //                abi.encodePacked(
        //                    hex"ff",
        //                    factory,
        //                    keccak256(abi.encode(key.token0, key.token1, key.fee)),
        //                    POOL_INIT_CODE_HASH
        //                )
        //            )
        //        )
        //    )
        //);
    }
}
