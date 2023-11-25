// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract OurTokenTest is StdCheats, Test {
    OurToken public ourToken;
    DeployOurToken public deployer;
    address public alice;
    address public bob;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();
        alice = address(this);
        bob = address(0x123); // Replace with an actual address for testing
    }

    function testInitialSupply() public {
        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(ourToken)).mint(alice, 1);
    }

    function testTransfer() public {
        ourToken.transfer(bob, 100);
        assertEq(ourToken.balanceOf(bob), 100);
        assertEq(ourToken.balanceOf(alice), deployer.INITIAL_SUPPLY() - 100);
    }

    function testTransferFrom() public {
        ourToken.approve(alice, 50);
        ourToken.transferFrom(address(this), bob, 50);
        assertEq(ourToken.balanceOf(bob), 50);
        assertEq(ourToken.balanceOf(alice), deployer.INITIAL_SUPPLY() - 50);
        assertEq(ourToken.allowance(address(this), alice), 0);
    }

    /*    function testIncreaseAllowance() public {
        ourToken.increaseAllowance(alice, 50);
        assertEq(ourToken.allowance(address(this), alice), 50);
    }
 */
    /*     function testDecreaseAllowance() public {
        ourToken.approve(alice, 100);
        ourToken.decreaseAllowance(alice, 50);
        assertEq(ourToken.allowance(address(this), alice), 50);
    }
 */
    function testBurn() public {
        ourToken.burn(50);
        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY() - 50);
        assertEq(
            ourToken.balanceOf(address(this)),
            deployer.INITIAL_SUPPLY() - 50
        );
    }
}
