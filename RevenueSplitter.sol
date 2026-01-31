// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RevenueSplitter
 * @author Steve Noir
 * @notice Takes 3% commission on all agent revenue to treasury.
 *          Multi-sig treasury controlled by Jake (0xD279e...)
 *          Agents receive 97% automatically. Transparent on-chain.
 */
contract RevenueSplitter {
    
    // ========== IMMUTABLE = SECURE ===========
    address payable public immutable treasury;
    address public immutable owner;
    
    uint256 public constant COMMISSION_BPS = 300; // 3%
    uint256 public constant AGENT_BPS = 9700;   // 97%
    
    // ========== EVENTS FOR TRACKING ==========
    event Deposit(address indexed agent, uint256 total, uint256 commission, uint256 toAgent);
    event TreasuryWithdrawal(uint256 amount, address indexed to);
    event OwnerChanged(address indexed oldOwner, address indexed newOwner);
    
    // ========== CONSTRUCTOR ================
    constructor() {
        treasury = payable(msg.sender); // Jake deployed this wallet
        owner = msg.sender;
        emit OwnerChanged(address(0), owner);
    }
    
    // ========== DEPOSIT FROM AGENT ==========
    /**
     * @notice Called by agent wallets after earning revenue.
     *         Automatically splits: 3% to treasury, 97% back to agent.
     */
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be > 0");
        
        uint256 commission = (msg.value * COMMISSION_BPS) / 10000;
        uint256 toAgent = msg.value - commission;
        
        (bool sentToTreasury, ) = treasury.call{value: commission}("");
        require(sentToTreasury, "Treasury transfer failed");
        
        (bool sentToAgent, ) = msg.sender.call{value: toAgent}("");
        require(sentToAgent, "Agent transfer failed");
        
        emit Deposit(msg.sender, msg.value, commission, toAgent);
    }
    
    // ========== WITHDRAW FROM TREASURY ==========
    /**
     * @notice Jake can withdraw treasury funds.
     *         Requires multi-sig (handled off-chain).
     */
    function withdrawTreasury(uint256 amount) external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(amount > 0, "Amount must be > 0");
        require(amount <= address(treasury).balance, "Insufficient treasury balance");
        
        treasury.transfer(owner, amount);
        emit TreasuryWithdrawal(amount, msg.sender);
    }
    
    // ========== EMERGENCY FUNCTIONS ============
    /**
     * @notice Change owner (requires redeploy if compromised).
     */
    function changeOwner(address newOwner) external {
        require(msg.sender == owner, "Only owner can change owner");
        address oldOwner = owner;
        owner = newOwner;
        emit OwnerChanged(oldOwner, newOwner);
    }
    
    // ========== VIEW FUNCTIONS ==============
    
    /**
     * @notice Get current treasury balance.
     */
    function getTreasuryBalance() external view returns (uint256) {
        return address(treasury).balance;
    }
    
    /**
     * @notice Get contract configuration.
     */
    function getConfig() external view returns (
        address _treasury,
        address _owner,
        uint256 _commissionBps,
        uint256 _agentBps
    ) {
        return (treasury, owner, COMMISSION_BPS, AGENT_BPS);
    }
    
    /**
     * @notice Get deposit history for an agent (event-based).
     */
    function getAgentDeposits(address agent, uint256 fromBlock, uint256 limit) 
        external view returns (
            uint256 totalCommission,
            uint256 totalToAgent,
            uint256 count
        ) {
            // Would need event log - this is simplified view
            // In production, use The Graph or event indexer
            return (0, 0, 0); // Placeholder
        }
}
