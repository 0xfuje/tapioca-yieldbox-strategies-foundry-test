// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/src/Test.sol";

contract ForkAddresses is Test {
    // ------------------ BINANCE ------------------ 
    address BINANCE_WALLET_ADDRESS = vm.envAddress("BINANCE_WALLET_ADDRESS");
    address ARB_BINANCE_WALLET_ADDRESS = vm.envAddress("ARB_BINANCE_WALLET_ADDRESS");

    // ------------------ TOKENS ------------------ 
    address WETH_ADDRESS  = vm.envAddress("WETH_ADDRESS"); 
    address USDC_ADDRESS  = vm.envAddress("USDC_ADDRESS");
    address WBTC_ADDRESS  = vm.envAddress("WBTC_ADDRESS");
    address USDT_ADDRESS  = vm.envAddress("USDT_ADDRESS");
    address CRV_ADDRESS  = vm.envAddress("CRV_ADDRESS"); 

    // ------------------ UNISWAP ------------------
    address UNISWAP_V3_ROUTER = vm.envAddress("UNISWAP_V3_ROUTER");
    address UNISWAP_V3_ROUTER02 = vm.envAddress("UNISWAP_V3_ROUTER02");
    address UNISWAP_V3_FACTORY = vm.envAddress("UNISWAP_V3_FACTORY");
    address UNISWAP_V2_ROUTER = vm.envAddress("UNISWAP_V2_ROUTER");
    address UNISWAP_V2_FACTORY = vm.envAddress("UNISWAP_V2_FACTORY");
    address SUSHI_ROUTER = vm.envAddress("SUSHI_ROUTER");

    // ------------------ AAVE ------------------ 
    address AAVE_TOKEN = vm.envAddress("AAVE_TOKEN");
    address AAVE_LENDING_POOL = vm.envAddress("AAVE_LENDING_POOL");
    address AAVE_INCENTIVES_CONTROLLER = vm.envAddress("AAVE_INCENTIVES_CONTROLLER");
    address AAVE_RECEIPT_TOKEN = vm.envAddress("AAVE_RECEIPT_TOKEN");
    address AAVE_STK = vm.envAddress("AAVE_STK");

    // ------------------ YEARN ------------------ 
    address YEARN_ETH_VAULT = vm.envAddress("YEARN_ETH_VAULT");

    // ------------------ STARGATE ------------------ 
    address STARGATE_ROUTER_ETH = vm.envAddress("STARGATE_ROUTER_ETH");
    address STARGATE_LP_STAKING = vm.envAddress("STARGATE_LP_STAKING");
    address STARGATE_LP_TOKEN = vm.envAddress("STARGATE_LP_TOKEN");
    address STARGATE_UNISWAPV3_POOL = vm.envAddress("STARGATE_UNISWAPV3_POOL");

    // ------------------ Tricrypto ------------------ 
    address TRICRYPTO_LIQUIDITY_POOL = vm.envAddress("TRICRYPTO_LIQUIDITY_POOL");
    address TRICRYPTO_LP_GAUGE = vm.envAddress("TRICRYPTO_LP_GAUGE");
    address TRICRYPTO_MINTER = vm.envAddress("TRICRYPTO_MINTER");

    // ------------------ LIDO ------------------ 
    address LIDO_STETH = vm.envAddress("LIDO_STETH");
    address CURVE_STETH_POOL = vm.envAddress("CURVE_STETH_POOL");

    // ------------------ COMPOUND ------------------ 
    address COMPOUND_ETH = vm.envAddress("COMPOUND_ETH");

    // ------------------ BALANCER ------------------ 
    address BALANCER_POOL = vm.envAddress("BALANCER_POOL");
    bytes32 BALANCER_POOL_ID = vm.envBytes32("BALANCER_POOL_ID");
    address BALANCER_TOKEN = vm.envAddress("BALANCER_TOKEN");
    address BALANCER_BAL_ETH_VAULT = vm.envAddress("BALANCER_BAL_ETH_VAULT");
    address BALANCER_BAL_ETH_GAUGE = vm.envAddress("BALANCER_BAL_ETH_GAUGE");
    address BALANCER_HELPERS = vm.envAddress("BALANCER_HELPERS");

    // ------------------ CONVEX TRICRYPTO ------------------ 
    address CONVEX_BOOSTER = vm.envAddress("CONVEX_BOOSTER");
    address CONVEX_ZAP = vm.envAddress("CONVEX_ZAP");
    address CONVEX_TRICRYPTO_REWARD_POOL = vm.envAddress("CONVEX_TRICRYPTO_REWARD_POOL");

    // ------------------ ARBITRUM ------------------
    // ------------------ TOKENS ------------------
    address ARB_WETH_ADDRESS = vm.envAddress("ARB_WETH_ADDRESS");

    // ------------------ GMX ------------------
    address ARB_GLP_REWARD_ROUTER = vm.envAddress("ARB_GLP_REWARD_ROUTER");
    address ARB_GMX_REWARD_ROUTER = vm.envAddress("ARB_GMX_REWARD_ROUTER");
    address ARB_GMX_VAULT = vm.envAddress("ARB_GMX_VAULT");
    address ARB_STAKED_GLP = vm.envAddress("ARB_STAKED_GLP");
}


    