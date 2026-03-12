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
        token.transfer(alice, 100e18);
        assertEq(
            token.balanceOf(alice),
            100e18,
            "Alice should receive 100 tokens"
        );
        assertEq(
            token.balanceOf(owner),
            900e18,
            "Owner should have 900 tokens left"
        );
    }

    // ============================================
    // APPROVE & ALLOWANCE TESTS
    // ============================================

    // TODO: Add approve tests here

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
