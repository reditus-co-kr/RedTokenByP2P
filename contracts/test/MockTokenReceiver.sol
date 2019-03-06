pragma solidity 0.5.4;

import "../interfaces/ERC721TokenReceiver.sol";

contract MockTokenReceiver is ERC721TokenReceiver {
	function onERC721Received(address /* _from */, uint256 /* _tokenId */, bytes memory /*data */)
    public
    returns(bytes4)
  {
    return bytes4(keccak256("onERC721Received(address,uint256,bytes)"));
  }
}
