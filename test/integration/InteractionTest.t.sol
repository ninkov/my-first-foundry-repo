// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user"); // make fake user address
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether; // we give 10 ETH, of the fake user to start testing using cheat code.
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, STARTING_BALANCE); // Give USER a starting balance
    }

    function testUserCanFundInteractions() public {
        // Arrange
        console.log("Owner:", fundMe.getOwner());
        FundFundMe fundFundMe = new FundFundMe();
        vm.deal(address(fundFundMe), 1 ether); // Give ETH to funder contract
        fundFundMe.fundFundMe(address(fundMe)); // Fund the FundMe contract

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();

        // 👇 Act as the actual FundMe owner
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        // withdrawFundMe.withdrawFundMe(address(fundMe)); // This will now succeed

        // Assert
        assert(address(fundMe).balance == 0);
    }
}
