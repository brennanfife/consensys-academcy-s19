pragma solidity ^0.5.0;

contract SimpleBank {
    mapping (address => uint) private balances; // Using 'private' to protect our users balance from other contracts
    mapping (address => bool) public enrolled; // Using 'public' to create a getter function and allow contracts to if a user is enrolled
    address public owner; // Using 'public' to make sure everyone knows who owns the bank. Use the appropriate keyword for this
    event LogEnrolled(address accountAddress);
    event LogDepositMade(address accountAddress, uint amount);
    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);

    constructor() public {
        owner = msg.sender; // Set the owner to the creator of this contract
    }

    /// @notice Get balance
    /// @return The balance of the user
    // Using 'view' to prevent function from editing state variables;
    function getBalance() public view returns (uint) {
        return balances[msg.sender]; // Get the balance of the sender of this transaction
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    function enroll() public returns (bool) {
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);
        return enrolled[msg.sender];
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    // Using 'payable' so that this function can receive ether
    function deposit() public payable returns (uint) {
          balances[msg.sender] += msg.value;
          emit LogDepositMade(msg.sender, msg.value);
          return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint) {
        require(withdrawAmount <= balances[msg.sender], "Withdrawn amount exceeds balance");
        balances[msg.sender] -= withdrawAmount;
        msg.sender.transfer(withdrawAmount);
        emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
        return balances[msg.sender];
    }

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function() external {
        revert();
    }
}
