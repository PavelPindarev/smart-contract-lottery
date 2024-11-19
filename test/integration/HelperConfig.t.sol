// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {HelperConfig, CodeConstants} from "script/HelperConfig.s.sol";

contract HelperConfigTest is Test, CodeConstants {
    function testConfigByChainId() public {
        // Arrange
        HelperConfig helperConfig = new HelperConfig();

        // Act

        HelperConfig.NetworkConfig memory localNetworkConfig = helperConfig
            .getConfigByChainId(LOCAL_CHAIN_ID);

        HelperConfig.NetworkConfig memory sepoliaNetworkConfig = helperConfig
            .getConfigByChainId(ETH_SEPOLIA_CHAIN_ID);

        // Assert

        assertEq(LOCAL_CHAIN_PUBLIC_KEY, localNetworkConfig.account);
        assertEq(ETH_SEPOLIA_PUBLIC_KEY, sepoliaNetworkConfig.account);
    }

    function testConfigByInvalidChainId() public {
        // Arrange
        HelperConfig helperConfig = new HelperConfig();

        // Act / Assert
        vm.expectRevert(HelperConfig.HelperConfig__InvalidChainId.selector);

        helperConfig.getConfigByChainId(1);
    }

    modifier skipFork() {
        if (block.chainid != LOCAL_CHAIN_ID) {
            return;
        }
        _;
    }

    function testGetOrCreateAnvilEthConfig() public skipFork {
        // Arrange
        HelperConfig helperConfig = new HelperConfig();

        // Act
        HelperConfig.NetworkConfig memory localNetwork = helperConfig
            .getOrCreateAnvilEthConfig();

        // Assert
        assert(localNetwork.vrfCoordinator != address(0));
        assert(localNetwork.account == LOCAL_CHAIN_PUBLIC_KEY);
    }
}
