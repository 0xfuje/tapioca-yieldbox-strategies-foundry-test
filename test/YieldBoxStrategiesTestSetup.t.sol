// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/src/Test.sol";
import "./utils/ForkAddresses.sol";

import { YieldBox } from "@YieldBox/YieldBox.sol";
import { TokenType } from "@YieldBox/enums/YieldBoxTokenType.sol";
import { IStrategy } from "@YieldBox/interfaces/IStrategy.sol";
import { YieldBoxURIBuilder } from "@YieldBox/YieldBoxURIBuilder.sol";
import { IWrappedNative } from "@YieldBox/interfaces/IWrappedNative.sol";
import { IERC20 } from "@openzeppelin/token/ERC20/IERC20.sol";
import "@boringcrypto/boring-solidity/contracts/BoringOwnable.sol";

import { YearnStrategy, IYearnVault, IYieldBox } from "tapioca-yieldbox-strategies/contracts/yearn/YearnStrategy.sol";
import { CompoundStrategy, ICToken } from "tapioca-yieldbox-strategies/contracts/compound/CompoundStrategy.sol";
import { LidoEthStrategy, ICurveEthStEthPool, IStEth } from "tapioca-yieldbox-strategies/contracts/lido/LidoEthStrategy.sol";
import { AaveStrategy, ILendingPool } from "tapioca-yieldbox-strategies/contracts/aave/AaveStrategy.sol";
import { BalancerStrategy } from "tapioca-yieldbox-strategies/contracts/balancer/BalancerStrategy.sol";
import { IBalancerVault } from "tapioca-yieldbox-strategies/contracts/balancer/interfaces/IBalancerVault.sol";
import { StargateStrategy } from "tapioca-yieldbox-strategies/contracts/stargate/StargateStrategy.sol";
import { TricryptoLPGetter } from "tapioca-yieldbox-strategies/contracts/curve/TricryptoLPGetter.sol";
import { TricryptoLPStrategy } from "tapioca-yieldbox-strategies/contracts/curve/TricryptoLPStrategy.sol";
import { TricryptoNativeStrategy } from "tapioca-yieldbox-strategies/contracts/curve/TricryptoNativeStrategy.sol";
import { ConvexTricryptoStrategy } from "tapioca-yieldbox-strategies/contracts/convex/ConvexTricryptoStrategy.sol";



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
    uint256 TRICRYPTO_LP_STRAT_YB_ID;
    uint256 TRICRYPTO_NATIVE_STRAT_YB_ID;
    uint256 CONVEX_STRAT_YB_ID;


    IWrappedNative weth;
    ForkAddresses forkAddr;
    YieldBoxURIBuilder ybURI;
    YieldBox YB;

    YearnStrategy yearnStrat;
    IYearnVault yearnVault;

    ICurveEthStEthPool lidoCurveEthStEthPool;
    IStEth lidoStEth;
    LidoEthStrategy lidoStrat;

    ICToken cEther;
    CompoundStrategy compoundStrat;

    ILendingPool aaveLendingPool;
    AaveStrategy aaveStrat;

    BalancerStrategy balancerStrat;
    IBalancerVault balancerVault;

    StargateStrategy stargateStrat;

    TricryptoLPGetter tricryptoLPGetter;
    TricryptoLPStrategy tricryptoLPStrat;
    TricryptoNativeStrategy tricryptoNativeStrat;

    ConvexTricryptoStrategy convexTricryptoStrat;

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

        aaveStrat = new AaveStrategy(IYieldBox(address(YB)), address(weth), AAVE_LENDING_POOL, AAVE_INCENTIVES_CONTROLLER, AAVE_RECEIPT_TOKEN, address(1));
        YB.registerAsset(TokenType.ERC20, address(weth), IStrategy(address(aaveStrat)), 0);
        AAVE_STRAT_YB_ID = 4;

        balancerVault = IBalancerVault(BALANCER_BAL_ETH_VAULT);
        balancerStrat = new BalancerStrategy(IYieldBox(address(YB)), address(weth), BALANCER_BAL_ETH_VAULT, BALANCER_POOL_ID, BALANCER_TOKEN, BALANCER_HELPERS);
        YB.registerAsset(TokenType.ERC20, address(weth), IStrategy(address(balancerStrat)), 0);
        BALANCER_STRAT_YB_ID = 5;

        stargateStrat = new StargateStrategy(IYieldBox(address(YB)), address(weth), STARGATE_ROUTER_ETH, STARGATE_LP_STAKING, 2, STARGATE_LP_TOKEN, address(1), STARGATE_UNISWAPV3_POOL);
        YB.registerAsset(TokenType.ERC20, address(weth), IStrategy(address(stargateStrat)), 0);
        STARGATE_STRAT_YB_ID = 6;

        tricryptoLPGetter = new TricryptoLPGetter(TRICRYPTO_LIQUIDITY_POOL, USDT_ADDRESS, WBTC_ADDRESS, WETH_ADDRESS);
        
        tricryptoLPStrat = new TricryptoLPStrategy(IYieldBox(address(YB)), address(weth), TRICRYPTO_LP_GAUGE, address(tricryptoLPGetter), TRICRYPTO_MINTER, address(1));
        YB.registerAsset(TokenType.ERC20, address(tricryptoLPGetter.lpToken()), IStrategy(address(tricryptoLPStrat)), 0);
        TRICRYPTO_LP_STRAT_YB_ID = 7;

        tricryptoNativeStrat = new TricryptoNativeStrategy(IYieldBox(address(YB)), address(weth), TRICRYPTO_LP_GAUGE, address(tricryptoLPGetter), TRICRYPTO_MINTER, address(1));
        YB.registerAsset(TokenType.ERC20, address(weth), IStrategy(address(tricryptoNativeStrat)), 0);
        TRICRYPTO_NATIVE_STRAT_YB_ID = 8;

        convexTricryptoStrat = new ConvexTricryptoStrategy(IYieldBox(address(YB)), address(weth), CONVEX_TRICRYPTO_REWARD_POOL, CONVEX_BOOSTER, CONVEX_ZAP, address(tricryptoLPGetter), address(1));
        YB.registerAsset(TokenType.ERC20, address(weth), IStrategy(address(convexTricryptoStrat)), 0);
        CONVEX_STRAT_YB_ID = 9;
    }

    function depositEthToStrategy(address addr, uint256 amount, uint256 id) internal {
        deal(addr, amount);
        vm.prank(addr);
        YB.depositETHAsset{value: amount}(id, user, amount);
    }

    function depositAssetToStrategy(address asset, address addr, uint256 amount, uint256 id) internal {
        deal(asset, addr, amount);
        vm.startPrank(addr);
        IERC20(asset).approve(address(YB), amount);
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


    /*    function selectStrategy(uint256 id) internal view returns (IYBStrategy strat) {
        if (id == YEARN_STRAT_YB_ID) { return IYBStrategy(address(yearnStrat)); 
        } else if (id == LIDO_STRAT_YB_ID) { return IYBStrategy(address(lidoStrat));
        } else if (id == COMPOUND_STRAT_YB_ID) { return IYBStrategy(address(compoundStrat));
        } else if (id == AAVE_STRAT_YB_ID) { return IYBStrategy(address(aaveStrat));
        } else if (id == BALANCER_STRAT_YB_ID) { return IYBStrategy(address(balancerStrat));
        } else if (id == STARGATE_STRAT_YB_ID) { return IYBStrategy(address(stargateStrat));
        } else if (id == TRICRYPTO_LP_STRAT_YB_ID) { return IYBStrategy(address(tricryptoLPStrat));
        } else if (id == TRICRYPTO_NATIVE_STRAT_YB_ID) { return IYBStrategy(address(tricryptoNativeStrat));
        } else if (id == CONVEX_STRAT_YB_ID) { return IYBStrategy(address(convexTricryptoStrat));
        }
    } */ 
}

/* interface IYBStrategy {
    function emergencyWithdraw() external returns (uint256 result);
    function setDepositThreshold(uint256 amount) external;
} */