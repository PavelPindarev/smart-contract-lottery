// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {HelperConfig, CodeConstants} from "script/HelperConfig.s.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "script/Interactions.s.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract InteractionsTest is Test, CodeConstants {
    //CreateSubscription
    function testCreateSubscriptionUsingLocalConfig() public {
        // Arrange
        CreateSubscription createSubscription = new CreateSubscription();
        // Act
        (uint256 subscriptionId, address vrfCoordinator) = createSubscription
            .createSubscriptionUsingConfig();

        assert(subscriptionId != 0);
        assert(vrfCoordinator != address(0));
    }

    //FundSubscription
    function testCreateAndFundSubscription() public {
        // Arrange

        // First CreateSubscription
        CreateSubscription createSubscription = new CreateSubscription();
        (uint256 subscriptionId, address vrfCoordinator) = createSubscription
            .createSubscriptionUsingConfig();

        // Second FundSubscription
        FundSubscription fundSubscription = new FundSubscription();
        HelperConfig helperConfig = new HelperConfig();
        address linkToken = helperConfig.getConfig().link;
        address account = helperConfig.getConfig().account;

        (uint96 startingBalance, , , , ) = VRFCoordinatorV2_5Mock(
            vrfCoordinator
        ).getSubscription(subscriptionId);

        console.log("Starting Balance: ", startingBalance);

        // Act
        fundSubscription.fundSubscription(
            vrfCoordinator,
            subscriptionId,
            linkToken,
            account
        );

        // Assert
        (uint96 endingBalance, , , , ) = VRFCoordinatorV2_5Mock(vrfCoordinator)
            .getSubscription(subscriptionId);

        console.log("Ending Balance: ", endingBalance);

        assert(endingBalance > startingBalance);
    }

    // AddConsusmer

    // function testAddConsumer() public {
    //     // Arrange
    //     vm.deal(address(this), 1 ether);

    //     // First CreateSubscription
    //     CreateSubscription createSubscription = new CreateSubscription();
    //     (uint256 subscriptionId, address vrfCoordinator) = createSubscription
    //         .createSubscriptionUsingConfig();

    //     // Second FundSubscription
    //     FundSubscription fundSubscription = new FundSubscription();
    //     HelperConfig helperConfig = new HelperConfig();
    //     address linkToken = helperConfig.getConfig().link;
    //     address account = helperConfig.getConfig().account;

    //     (, , , , address[] memory startingConsumers) = VRFCoordinatorV2_5Mock(
    //         vrfCoordinator
    //     ).getSubscription(subscriptionId);

    //     console.log("Starting Consumers: START ");
    //     for (uint256 i = 0; i < startingConsumers.length; i++) {
    //         if (startingConsumers[i] != address(0)) {
    //             console.log(startingConsumers[i]);
    //         } else {
    //             console.log("There is not any consumer!");
    //         }
    //     }
    //     console.log("Starting Consumers: END ");

    //     // Act
    //     fundSubscription.fundSubscription(
    //         vrfCoordinator,
    //         subscriptionId,
    //         linkToken,
    //         account
    //     );

    //     //Third AddConsumer
    //     AddConsumer addConsumer = new AddConsumer();

    //     address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
    //         "Raffle",
    //         block.chainid
    //     );

    //     // Assert
    //     addConsumer.addConsumerUsingConfig(mostRecentlyDeployed);
    //     (, , , , address[] memory endingConsumers) = VRFCoordinatorV2_5Mock(
    //         vrfCoordinator
    //     ).getSubscription(subscriptionId);
    //     console.log("Ending Consumers: START ");
    //     for (uint256 i = 0; i < endingConsumers.length; i++) {
    //         if (endingConsumers[i] != address(0)) {
    //             console.log(endingConsumers[i]);
    //         } else {
    //             console.log("There is not any consumer!");
    //         }
    //     }
    //     console.log("Ending Consumers: END ");

    //     assert(endingConsumers.length > startingConsumers.length);
    //     assert(endingConsumers[0] != address(0));
    // }
}
