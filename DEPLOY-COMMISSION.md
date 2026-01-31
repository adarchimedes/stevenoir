# COMMISSION WALLET DEPLOYMENT GUIDE

**Treasury Address:** 0xD279eEE9Fd4FF514897ec8cb1540B9642087F89b
**Network:** Base Chain (testnet first, then mainnet)
**Split:** 3% to treasury, 97% back to agent

---

## STEP 1: DEPLOY SMART CONTRACT

### Option A: Remix (Easiest)
1. Go to: https://remix.ethereum.org
2. Create new file: `RevenueSplitter.sol`
3. Paste contract code
4. Compile (Ctrl+S)
5. Deploy & Run tab
   - Environment: Base Sepolia (testnet) FIRST
   - Deployer: Injected Provider (MetaMask)
6. Copy deployed address
7. Test with small amount ($0.01 ETH)

### Option B: Hardhat (For pros)
```bash
npm init -y
npm install --save-dev @openzeppelin/contracts @nomicfoundation/hardhat-ethers
npx hardhat compile
npx hardhat deploy --network baseSepolia scripts/deploy.ts
```

---

## STEP 2: TEST ON TESTNET

1. Switch MetaMask to Base Sepolia
2. Send small test amount ($0.01 ETH)
3. Call `deposit()` from agent wallet
4. Verify split:
   - Treasury gets 0.0003 ETH (3%)
   - Agent gets 0.0097 ETH (97%)
5. Check Etherscan Base Sepolia for events
6. Verify `getConfig()` returns correct values

---

## STEP 3: DEPLOY TO BASE MAINNET

1. Switch to Base Mainnet (chain ID: 0x2105)
2. Re-deploy contract on mainnet
3. Verify on BaseScan: https://basescan.org
4. Copy mainnet address
5. Update agent configs to use mainnet address

---

## STEP 4: CONFIGURE AGENT WALLETS

### Example Agent Configuration
```json
{
  "agentName": "DegenSteve",
  "walletAddress": "0x[AGENT_WALLET]",
  "commissionContract": "0x[MAINNET_ADDRESS]",
  "splitRatio": "97/3",
  "depositFrequency": "manual", // or "daily", "weekly"
  "autoDeposit": false, // Set true when ready
  "treasuryAddress": "0xD279eEE9Fd4FF514897ec8cb1540B9642087F89b"
}
```

---

## STEP 5: INTEGRATE WITH AGENT WORKFLOW

### When Agent Earns Revenue
```
1. Agent completes sale/trade
2. Agent wallet has revenue (e.g., $100 ETH)
3. Agent calls deposit() with full amount
4. Contract automatically splits:
   - 3% → Treasury
   - 97% → Agent wallet
5. Treasury accumulates for Jake
6. Jake can withdraw when needed (multi-sig)
```

### Withdrawal Flow (Jake)
```
1. Jake initiates multi-sig transaction
2. Call withdrawTreasury(amount)
3. Funds sent to Jake's vault
4. Event logged on-chain for audit
```

---

## SECURITY CHECKLIST

### Pre-Deployment
- [ ] Contract audited (optional but recommended)
- [ ] Testnet tested with multiple scenarios
- [ ] Multi-sig keys secured in secure hardware wallet
- [ ] Gas optimization review
- [ ] Emergency ownership transfer tested

### Post-Deployment
- [ ] Verify contract on BaseScan
- [ ] Add BaseScan monitoring
- [ ] Set up Treasury dashboard (read balance, withdrawals)
- [ ] Create multi-sig UI (easy withdrawal)
- [ ] Document agent onboarding flow
- [ ] Set up withdrawal limits (daily/monthly)

---

## GAS OPTIMIZATION

### Base Chain (Cheap!)
- Average block: 2s
- Gas price: ~0.1-1 gwei
- Deposit cost: ~150,000 gas = ~$0.02
- Withdraw cost: ~50,000 gas = ~$0.007

### Estimated Monthly Gas (With 100 agents doing 10 deposits each)
- 1000 deposits × $0.02 = $20/month
- Negligible at scale

---

## REVENUE PROJECTION

### Conservative (100 agents, $100/month average)
```
Monthly Revenue: $10,000
Commission (3%): $300
Treasury Growth: $300/month
Year 1 Treasury: $3,600
Year 2 Treasury: $7,200
Year 3 Treasury: $10,800
```

### Aggressive (1000 agents, $100/month average)
```
Monthly Revenue: $100,000
Commission (3%): $3,000
Treasury Growth: $3,000/month
Year 1 Treasury: $36,000
Year 5 Treasury: $180,000
```

---

## NEXT STEPS FOR TODAY

1. ✅ Jake deploys RevenueSplitter.sol to Base Sepolia
2. ✅ Tests deposit with small amount
3. ✅ Deploys to Base Mainnet
4. ✅ Steve updates agent configs
5. ✅ Steve deploys Treasury Dashboard (simple UI)

---

## AGENT CONFIG UPDATE

Once deployed, update each agent's config to include:
```json
{
  "walletAddress": "0x[AGENT_WALLET]",
  "commissionContract": "0x[MAINNET_ADDRESS]",
  "autoDeposit": false
}
```

Agents call `deposit()` when they earn:
```javascript
// Agent workflow
const contract = new ethers.Contract(ADDRESS, ABI);
const tx = await contract.deposit({value: ethers.parseEther("100")});
await tx.wait(); // 97% returned automatically
```

---

💀 **THIS IS THE SCALE ARCHITECTURE. 3% PASSIVE INCOME FROM 1000+ AGENTS.**
