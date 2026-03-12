// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13 <0.9.0;

import "forge-std/Test.sol";
import "../src/ERC20.sol";

contract ERC20Test is Test {
    ERC20 token;
    address owner = address(this);
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address charlie = makeAddr("charlie");

    function setUp() public {
        token = new ERC20("Test Token", "TEST", 18, 1000e18);
    }

    // ============================================
    // TOTAL SUPPLY TESTS
    // ============================================

    function test_TotalSupply_InitialSupply() public view {
        assertEq(
            token.totalSupply(),
            1000e18,
            "Total supply should match initial supply"
        );
    }

    // ============================================
    // BALANCE OF TESTS
    // ============================================

    function test_BalanceOf_OwnerHasInitialSupply() public view {
        assertEq(
            token.balanceOf(owner),
            1000e18,
            "Owner should have all initial tokens"
        );
    }

    function test_BalanceOf_NewAddressHasZero() public view {
        assertEq(
            token.balanceOf(alice),
            0,
            "New address should have zero balance"
        );
    }

    // ============================================
    // TRANSFER TESTS
    // ============================================

    function test_Transfer_Success() public {
        token.transfer(alice, 1000e18);
        uint256 aliceBefore = token.balanceOf(alice);
        uint256 bobBefore = token.balanceOf(bob);

        vm.prank(alice);
        token.transfer(bob, 100e18);
        uint256 aliceAfter = token.balanceOf(alice);
        uint256 bobAfter = token.balanceOf(bob);
        assertEq(
            aliceAfter,
            aliceBefore - 100e18,
            "Alice's balance should decrease by 100 tokens"
        );
        assertEq(
            bobAfter,
            bobBefore + 100e18,
            "Bob's balance should increase by 100 tokens"
        );
    }

    function test_Transfer_ToZeroAddress_Reverts() public {
        vm.expectRevert("ERC20: to address is not valid");
        token.transfer(address(0), 100e18);
    }

    function test_Transfer_InsufficientBalance_Reverts() public {
        vm.expectRevert("ERC20: insufficient balance");
        vm.prank(alice);
        token.transfer(bob, 100e18);
    }

    // ============================================
    // APPROVE & ALLOWANCE TESTS
    // ============================================

    function test_Approve_Success() public {
        token.approve(bob, 500e18);
        uint256 allowed = token.allowance(owner, bob);
        assertEq(allowed, 500e18, "Allowance should be set to approved amount");
    }

    function test_Approve_ToZeroAddress_Reverts() public {
        vm.expectRevert();
        token.approve(address(0), 100e18);
    }

    // ============================================
    // TRANSFER FROM TESTS
    // ============================================

    // TODO: Add transferFrom tests here

    // ============================================
    // MINT TESTS
    // ============================================

    // TODO: Add mintTo tests here

    // ============================================
    // BURN TESTS
    // ============================================

    // TODO: Add burn tests here

    // ============================================
    // PAUSE TESTS
    // ============================================

    // TODO: Add pause/unpause tests here
}
