// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/src/Test.sol";
import "./utils/ForkAddresses.sol";

import { YieldBox } from "@YieldBox/YieldBox.sol";
import { TokenType } from "@YieldBox/enums/YieldBoxTokenType.sol";
import { IStrategy } from "@YieldBox/interfaces/IStrategy.sol";
import { YieldBoxURIBuilder } from "@YieldBox/YieldBoxURIBuilder.sol";
import { IWrappedNative } from "@YieldBox/interfaces/IWrappedNative.sol";

import { YearnStrategy, IYearnVault, IYieldBox } from "tapioca-yieldbox-strategies/contracts/yearn/YearnStrategy.sol";
import { CompoundStrategy, ICToken } from "tapioca-yieldbox-strategies/contracts/compound/CompoundStrategy.sol";
import { LidoEthStrategy, ICurveEthStEthPool, IStEth } from "tapioca-yieldbox-strategies/contracts/lido/LidoEthStrategy.sol";
import { AaveStrategy, ILendingPool } from "tapioca-yieldbox-strategies/contracts/aave/AaveStrategy.sol";
import { BalancerStrategy } from "tapioca-yieldbox-strategies/contracts/balancer/BalancerStrategy.sol";
import { IBalancerVault } from "tapioca-yieldbox-strategies/contracts/balancer/interfaces/IBalancerVault.sol";
import { StargateStrategy } from "tapioca-yieldbox-strategies/contracts/stargate/StargateStrategy.sol";


contract YieldBoxStrategiesTestSetup is Test, ForkAddresses {
    uint256 mainnetFork;
    uint256 arbitrumFork;

    string ETH_MAINNET_API_KEY = vm.envString("ETH_MAINNET_API_KEY");
    string ARB_MAINNET_API_KEY = vm.envString("ARB_MAINNET_API_KEY");

    address owner = vm.addr(0xbabe);
    address user = vm.addr(12345);
    address user2 = vm.addr(2222);
    address user3 = vm.addr(3333);
    address haxor = vm.addr(4444);

    uint256 YEARN_STRAT_YB_ID;
    uint256 LIDO_STRAT_YB_ID;
    uint256 COMPOUND_STRAT_YB_ID;
    uint256 AAVE_STRAT_YB_ID;
    uint256 BALANCER_STRAT_YB_ID;
    uint256 STARGATE_STRAT_YB_ID;


    IWrappedNative weth;
    ForkAddresses forkAddr;
    YieldBoxURIBuilder ybURI;
    YieldBox YB;

    YearnStrategy yearnStrat;
    IYearnVault yearnVault;

    ILendingPool aaveLendingPool;
    AaveStrategy aaveStrat;

    BalancerStrategy balancerStrat;
    IBalancerVault balancerVault;

    StargateStrategy stargateStrat;

    ICToken cEther;
    CompoundStrategy compoundStrat;

    ICurveEthStEthPool lidoCurveEthStEthPool;
    IStEth lidoStEth;
    LidoEthStrategy lidoStrat;

    function setUp() public {
        mainnetFork = vm.createFork(ETH_MAINNET_API_KEY);
        arbitrumFork = vm.createFork(ARB_MAINNET_API_KEY);
        vm.selectFork(mainnetFork);
        
        vm.startPrank(owner);
        testSetUpMainnet();
        testSetUpStrategies();
        vm.stopPrank();
    }

    function testSetUpMainnet() public {
        weth = IWrappedNative(WETH_ADDRESS);
        ybURI = new YieldBoxURIBuilder();
        YB = new YieldBox(IWrappedNative(address(weth)), ybURI);
    }

    function testSetUpStrategies() public {
        yearnVault = IYearnVault(YEARN_ETH_VAULT);
        yearnStrat = new YearnStrategy(IYieldBox(address(YB)), address(weth), YEARN_ETH_VAULT);
        YB.registerAsset(TokenType.ERC20, address(weth), IStrategy(address(yearnStrat)), 0);
        YEARN_STRAT_YB_ID = 1;

        lidoCurveEthStEthPool = ICurveEthStEthPool(CURVE_STETH_POOL);
        lidoStEth = IStEth(LIDO_STETH);
        lidoStrat = new LidoEthStrategy(IYieldBox(address(YB)), address(weth), LIDO_STETH, CURVE_STETH_POOL);
        YB.registerAsset(TokenType.ERC20, address(weth), IStrategy(address(lidoStrat)), 0);
        LIDO_STRAT_YB_ID = 2;

        cEther = ICToken(COMPOUND_ETH);
        compoundStrat = new CompoundStrategy(IYieldBox(address(YB)), address(weth), COMPOUND_ETH);
        YB.registerAsset(TokenType.ERC20, address(weth), IStrategy(address(compoundStrat)), 0);
        COMPOUND_STRAT_YB_ID = 3;

        aaveStrat = new AaveStrategy(IYieldBox(address(YB)), AAVE_TOKEN, AAVE_LENDING_POOL, AAVE_INCENTIVES_CONTROLLER, AAVE_RECEIPT_TOKEN, address(1));
        AAVE_STRAT_YB_ID = 4;

        balancerVault = IBalancerVault(BALANCER_BAL_ETH_VAULT);
        balancerStrat = new BalancerStrategy(IYieldBox(address(YB)), BALANCER_TOKEN, BALANCER_BAL_ETH_VAULT, BALANCER_POOL_ID, address(1), BALANCER_HELPERS);
        BALANCER_STRAT_YB_ID = 5;

        stargateStrat = new StargateStrategy(IYieldBox(address(YB)), WETH_ADDRESS, STARGATE_ROUTER_ETH, STARGATE_LP_STAKING, 2, STARGATE_LP_TOKEN, address(1), STARGATE_UNISWAPV3_POOL);
        STARGATE_STRAT_YB_ID = 6;
    }

    function depositEthToStrategy(address addr, uint256 amount, uint256 id) internal {
        deal(addr, amount);
        vm.prank(addr);
        YB.depositETHAsset{value: amount}(id, user, amount);
    }

    function depositAssetToStrategy(address addr, uint256 amount, uint256 id) internal {
        deal(WETH_ADDRESS, addr, amount);
        vm.startPrank(addr);
        weth.approve(address(YB), amount);
        YB.depositAsset(id, addr, addr, amount, 0);
        vm.stopPrank();
    }

    function withdrawFromStrategy(address addr, uint256 amount, uint256 id) internal {
        vm.prank(addr);
        YB.withdraw(id, user, user, amount, 0);
    }

    function testDepositYB() public {
        depositEthToStrategy(user, 1e18, 3);
    }
}
