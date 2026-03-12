# Security Audit Report: Freitas ERC20 Token

## Audit Information

**Auditor:** Abbas (@abbasbukhari)
**Project:** Blokan Phase 3 - Audit #001
**Target:** Freitas ERC20 Token
**Source:** https://github.com/freitasgouvea/token-erc-20
**Date:** February 14, 2026
**Commit:** (initial audit)

---

## Executive Summary

**Audit Scope:**
- ERC20 token implementation with mint, burn, and pause features
- Access control via Ownable pattern
- Pausable functionality

**Files Audited:**
- `src/ERC20.sol`
- `src/IERC20.sol`
- `src/Ownable.sol`
- `src/Pausable.sol`

**Summary Statistics:**
- Total Issues Found: 4
- Critical: 0
- High: 0
- Medium: 1
- Low: 2
- Informational: 2

---

## Findings

### Low Severity

#### [L-01] Duplicate Event Declarations Prevent Compilation

**Location:** `src/ERC20.sol:22-27`

**Description:**
The `ERC20` contract redeclares the `Transfer` and `Approval` events that are already defined in the inherited `IERC20` interface. This creates duplicate event definitions which prevent the contract from compiling.

**Code:**
```solidity
// ERC20.sol lines 22-27
event Transfer(address indexed from, address indexed to, uint256 value);
event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
);
```

These events are already declared in `IERC20.sol` (lines 30-35) and are inherited by the `ERC20` contract.

**Impact:**
- Contract fails to compile
- Prevents deployment and testing
- Code quality issue

**Recommendation:**
Remove the duplicate event declarations from `ERC20.sol` lines 22-27. The events are inherited from the `IERC20` interface and do not need to be redeclared.

**Status:** ✅ FIXED (commented out lines 22-27)

---

#### [L-02] `approve()` Missing Zero-Address Validation for `_spender`

**Location:** `src/ERC20.sol:87-96`

**Description:**
`approve()` does not check whether `_spender` is `address(0)`. Both `transfer()` and `transferFrom()` reject `address(0)` with an explicit require, but `approve()` silently allows setting an allowance for the zero address.

**Code:**
```solidity
function approve(address _spender, uint256 _value) external override whenNotPaused returns (bool) {
    _allowed[msg.sender][_spender] = _value;  // no zero-address check
    emit Approval(msg.sender, _spender, _value);
    return true;
}
```

**Impact:**
- Inconsistent validation across the contract.
- Tokens could be approved to the zero address, which is unreachable and effectively burns spending rights.
- Proven by test: `test_Approve_ToZeroAddress_Reverts()` fails — the contract does not revert.

**Recommendation:**
Add `require(_spender != address(0), "ERC20: spender address is not valid");` at the start of `approve()`.

**Status:** Open

---

### Medium Severity

#### [M-01] `allowance()` Gated by `whenNotPaused` Modifier

**Location:** `src/ERC20.sol:136`

**Description:**
The `allowance()` view function has the `whenNotPaused` modifier applied, meaning it reverts when the contract is paused. View functions should always be readable regardless of contract state.

**Impact:**
- External integrations (DEXes, wallets, other contracts) that query allowances before executing transfers will break while the contract is paused.
- Non-standard ERC20 behavior — the ERC20 standard does not permit view functions to revert based on contract state.
- Could cause unexpected failures in protocols that rely on allowance checks.

**Recommendation:**
Remove the `whenNotPaused` modifier from `allowance()`. Read-only functions should never be gated by pause state.

**Status:** Open

---

### High Severity

*(No findings)*

---

### Critical Severity

*(No findings)*

---

## Informational / Gas Optimization

#### [I-01] `decreaseApproval()` Silently Clamps to Zero

**Location:** `src/ERC20.sol:171-173`

**Description:**
When `_subtractedValue` exceeds the current allowance, `decreaseApproval()` clamps the result to 0 instead of reverting. No error is thrown. Callers expecting a revert on underflow may be surprised by this behavior.

**Recommendation:**
Consider documenting this behavior clearly or reverting with an explicit error message when the subtracted value exceeds the current allowance.

**Status:** Open

---

#### [I-02] Duplicate Event Declarations Commented Out in `ERC20.sol`

**Location:** `src/ERC20.sol:22-27`

**Description:**
The `Transfer` and `Approval` events are declared in `IERC20.sol` and inherited by `ERC20`. The duplicate declarations in `ERC20.sol` were commented out rather than removed. Functionally fine, but confusing for code readers.

**Recommendation:**
Remove the commented-out lines entirely to improve code clarity.

**Status:** Open

---

## Test Coverage

**Status:** Complete

**Tests Written:** 21/21
**Coverage:** ~100%

### Functions Tested:
- [x] totalSupply
- [x] balanceOf
- [x] transfer
- [x] approve
- [x] allowance
- [x] transferFrom
- [x] mintTo
- [x] burn
- [x] burnFrom
- [x] pause
- [x] unpause

---

## Notes

- Contract uses Solidity 0.8.4 (has built-in overflow protection)
- Most functions use `whenNotPaused` modifier
- `mintTo` is owner-only function
- Constructor mints initial supply to deployer

---

## Next Steps

1. Final review of all findings
2. Prepare report for submission to Sherlock or Codehawks
