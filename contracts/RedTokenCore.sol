pragma solidity 0.5.4;

import "./RedTokenOwnership.sol";

/*
 * @title RedTokenCore is the entry point of the contract
 * @notice RedTokenCore is the entry point and it controls the ability to set a new
 * contract address, in the case where an upgrade is required
 */
contract RedTokenCore is RedTokenOwnership{
  address public newContractAddress;

  constructor() public {
    ceoAddress = msg.sender;
    cooAddress = msg.sender;
    cfoAddress = msg.sender;
  }
  
  function setNewAddress(address _v2Address) external onlyCEO whenPaused {
    newContractAddress = _v2Address;
    emit ContractUpgrade(_v2Address);
  }

  function() external {
    assert(false);
  }

  
}