pragma solidity 0.5.7;

import "./RedTokenOwnership.sol";

/*
 * @title RedTokenCore is the entry point of the contract
 * @notice RedTokenCore is the entry point and it controls the ability to set a new
 * contract address, in the case where an upgrade is required
 */
contract RedTokenCore is RedTokenOwnership{

  constructor() public {
    ceoAddress = msg.sender;
    cooAddress = msg.sender;
    cfoAddress = msg.sender;
  }

  function() external {
    assert(false);
  }
}