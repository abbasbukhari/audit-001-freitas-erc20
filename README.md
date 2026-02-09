# Audit #001: Freitas ERC20 Token

**Date Started:** February 10, 2026  
**Auditor:** Abbas (Blokan)  
**Source:** https://github.com/freitasgouvea/token-erc-20

---

## Contract Overview

**Type:** ERC20 Token with mint, burn, pause features  
**Solidity Version:** 0.8.4  
**Complexity:** Basic + Ownable + Pausable

---

## Functions to Test

**ERC20 Core:**

- [ ] totalSupply
- [ ] balanceOf
- [ ] transfer
- [ ] approve
- [ ] allowance
- [ ] transferFrom

**Extended Features:**

- [ ] mintTo (owner-only)
- [ ] burn
- [ ] burnFrom
- [ ] pause (owner-only)
- [ ] unpause (owner-only)

---

## Progress

**Tests Written:** 0/25  
**Coverage:** 0%  
**Bugs Found:** 0

---

## Notes

[Add notes as you work]

```

---

## **✅ FINAL FOLDER STRUCTURE:**
```

phase-3/
└── audit-001-freitas-erc20/
├── src/
│ ├── ERC20.sol ✅ Copied from their repo
│ ├── Ownable.sol ✅ Copied from their repo
│ ├── Pausable.sol ✅ Copied from their repo
│ └── IERC20.sol ✅ Copied from their repo
│
├── test/
│ └── ERC20Test.t.sol ✅ YOUR tests (empty for now)
│
├── foundry.toml ✅ Foundry config
├── README.md ✅ Your audit notes
└── .gitignore ✅ Foundry default
