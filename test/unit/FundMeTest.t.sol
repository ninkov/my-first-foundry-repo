// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user"); // make fake user address
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether; // we give 10 ETH, of the fake user to start testing using cheat code.
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306); // This is how we can deploy a contract in a test

        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run(); // This is how we can deploy a contract using
        vm.deal(USER, STARTING_BALANCE); // (deal)Give the USER address fake money
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    //What can we do to work with addresses outside our system?
    // 1. Unit
    //  - Testing a specific part of our code
    // 2. Integration
    //  - Testing how our code works with other parts of our code
    // 3. Forked
    //  - Testing our code on a simulated real environment
    // 4. Staging
    //  - Testing our code ina real environment that is not prod

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    //Modular deployments

    //Modular testing

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert(); // hey, the next line, should revert!
        //assert (This tx fails/reverts)
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // The next TX will be sent by USER
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER); // The next TX will be sent by USER
        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER); // The next TX will be sent by USER
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        // vm.prank(USER); // The next TX will be sent by USER
        // fundMe.fund{value: SEND_VALUE}();

        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        //Arrange

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act

        // uint256 gasStart = gasleft(); //1000
        // vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner()); //200
        fundMe.withdraw(); // should have spent gas ?

        // uint256 gasEnd = gasleft(); // 800
        // uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        // console.log("Gas used: ", gasUsed);

        //Assert

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithDrawFromMultipleFunders() public funded {
        //Arrange
        uint160 numberOfFunders = 10; // work with address as uint160
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            // vm.prank new address
            // vm.deal new address
            // we can combine these two above line in a single line with  --> hoax(address,SEND_VALUE)
            // address() if we wont to work with address the uint must be a --> uint160

            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
            // fund the fundMe
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // Assert

        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
    }

    function testWithDrawFromMultipleFundersCheaper() public funded {
        //Arrange
        uint160 numberOfFunders = 10; // work with address as uint160
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            // vm.prank new address
            // vm.deal new address
            // we can combine these two above line in a single line with  --> hoax(address,SEND_VALUE)
            // address() if we wont to work with address the uint must be a --> uint160

            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
            // fund the fundMe
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert

        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
    }
}
