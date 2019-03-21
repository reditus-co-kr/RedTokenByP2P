pragma solidity 0.5.4;

import "./RedTokenBase.sol";
import "./interfaces/ERC721.sol";
import "./interfaces/ERC721Metadata.sol";
import "./interfaces/ERC721Enumerable.sol";
import "./interfaces/ERC165.sol";
import "./strings/Strings.sol";
import "./interfaces/ERC721TokenReceiver.sol";

/*
 * @title RedTokenOwnership
 * @notice control by TokenBase.
 */
contract RedTokenOwnership is RedTokenBase, ERC721, ERC165, ERC721Metadata, ERC721Enumerable {
  using SafeMath for uint256;

  // Total amount of tokens
  uint256 private totalTokens;

  // Mapping from token ID to owner
  mapping (uint256 => address) private tokenOwner;

  // Mapping from owner to list of owned token IDs
  mapping (address => uint256[]) internal ownedTokens;

  // Mapping from token ID to index of the owner tokens list
  mapping (uint256 => uint256) internal ownedTokensIndex;

  // Mapping from token ID to approved address
  mapping (uint256 => address) internal tokenApprovals;

  // Mapping from owner address to operator address to approval
  mapping (address => mapping (address => bool)) internal operatorApprovals;

  /** events **/
  event calculateShareUsers(uint256 tokenId, address owner, address from, address to, uint256 amount);
  event CollectedAmountUpdate(uint256 tokenId, address owner, uint256 amount);

  /** Constants **/
  // Configure these for your own deployment
  string internal constant NAME = "RedToken";
  string internal constant SYMBOL = "REDT";
  string internal tokenMetadataBaseURI = "https://doc.reditus.co.kr/?docid=";

  /** structs **/
  function supportsInterface(
    bytes4 interfaceID) // solium-disable-line dotta/underscore-function-arguments
    external view returns (bool)
  {
    return
      interfaceID == this.supportsInterface.selector || // ERC165
      interfaceID == 0x5b5e139f || // ERC721Metadata
      interfaceID == 0x80ac58cd || // ERC-721
      interfaceID == 0x780e9d63; // ERC721Enumerable
  }

  /*
   * @notice Guarantees msg.sender is owner of the given token
   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
   */
  modifier onlyOwnerOf(uint256 _tokenId) {
    require(ownerOf(_tokenId) == msg.sender);
    _;
  }

  /** external functions **/  
  /*
   * @notice token's name
   */
  function name() external pure returns (string memory) {
    return NAME;
  }

  /*
   * @notice symbols's name
   */
  function symbol() external pure returns (string memory) {
    return SYMBOL;
  }

  /*
   * @notice tokenURI
   * @dev do not checked in array and used function isValidRedToken value is not important, only check in redTokens array
   */
  function tokenURI(uint256 _tokenId)
    external
    view
    returns (string memory infoUrl)
  {
    if ( isValidRedToken(_tokenId) ){
      return Strings.strConcat( tokenMetadataBaseURI, Strings.uint2str(_tokenId));
    }else{
      return Strings.strConcat( tokenMetadataBaseURI, Strings.uint2str(_tokenId));
    }
  }

  /*
   * @notice setTokenMetadataBaseURI
   */
  function setTokenMetadataBaseURI(string calldata _newBaseURI) external onlyCOO {
    tokenMetadataBaseURI = _newBaseURI;
  }

  /*
   * @notice Gets the total amount of tokens stored by the contract
   * @return uint256 representing the total amount of tokens
   */
  function totalSupply() public view returns (uint256) {
    return totalTokens;
  }

  /*
   * @dev Gets the owner of the specified token ID
   * @param _tokenId uint256 ID of the token to query the owner of
   * @return owner address currently marked as the owner of the given token ID
   */
  function ownerOf(uint256 _tokenId) public view returns (address) {
    address owner = tokenOwner[_tokenId];
    require(owner != address(0));
    return owner;
  }

  /*
   * @notice Gets the balance of the specified address
   * @param _owner address to query the balance of
   * @return uint256 representing the amount owned by the passed address
   */
  function balanceOf(address _owner) public view returns (uint256) {
    require(_owner != address(0));
    return ownedTokens[_owner].length;
  }

  /*
   * @notice Gets the list of tokens owned by a given address
   * @param _owner address to query the tokens of
   * @return uint256[] representing the list of tokens owned by the passed address
   */
  function tokensOf(address _owner) public view returns (uint256[] memory) {
    require(_owner != address(0));
    return ownedTokens[_owner];
  }

  /*
  * @notice Enumerate valid NFTs
  * @dev Our Licenses are kept in an array and each new License-token is just
  * the next element in the array. This method is required for ERC721Enumerable
  * which may support more complicated storage schemes. However, in our case the
  * _index is the tokenId
  * @param _index A counter less than `totalSupply()`
  * @return The token identifier for the `_index`th NFT
  */
  function tokenByIndex(uint256 _index) external view returns (uint256) {
    require(_index < totalSupply());
    return _index;
  }

  /*
   * @notice Enumerate NFTs assigned to an owner
   * @dev Throws if `_index` >= `balanceOf(_owner)` or if
   *  `_owner` is the zero address, representing invalid NFTs.
   * @param _owner An address where we are interested in NFTs owned by them
   * @param _index A counter less than `balanceOf(_owner)`
   * @return The token identifier for the `_index`th NFT assigned to `_owner`,
   */
  function tokenOfOwnerByIndex(address _owner, uint256 _index)
    external
    view
    returns (uint256 _tokenId)
  {
    require(_index < balanceOf(_owner));
    return ownedTokens[_owner][_index];
  }

  /*
   * @notice Gets the approved address to take ownership of a given token ID
   * @param _tokenId uint256 ID of the token to query the approval of
   * @return address currently approved to take ownership of the given token ID
   */
  function getApproved(uint256 _tokenId) public view returns (address) {
    return tokenApprovals[_tokenId];
  }

  /*
   * @notice Tells whether an operator is approved by a given owner
   * @param _owner owner address which you want to query the approval of
   * @param _operator operator address which you want to query the approval of
   * @return bool whether the given operator is approved by the given owner
   */
  function isApprovedForAll(address _owner, address _operator) public view returns (bool)
  {
    return operatorApprovals[_owner][_operator];
  }

  /*
   * @notice Approves another address to claim for the ownership of the given token ID
   * @param _to address to be approved for the given token ID
   * @param _tokenId uint256 ID of the token to be approved
   */
  function approve(address _to, uint256 _tokenId)
    external
    payable
    whenNotPaused
    whenNotPausedUser(msg.sender)
    onlyOwnerOf(_tokenId)
  {
    address owner = ownerOf(_tokenId);
    require(_to != owner);
    if (getApproved(_tokenId) != address(0) || _to != address(0)) {
      tokenApprovals[_tokenId] = _to;

      emit Approval(owner, _to, _tokenId);
    }
  }

  /*
   * @notice Enable or disable approval for a third party ("operator") to manage all your assets
   * @dev Emits the ApprovalForAll event
   * @param _to Address to add to the set of authorized operators.
   * @param _approved True if the operators is approved, false to revoke approval
   */
  function setApprovalForAll(address _to, bool _approved)
    external
    whenNotPaused
    whenNotPausedUser(msg.sender)
  {
    if(_approved) {
      approveAll(_to);
    } else {
      disapproveAll(_to);
    }
  }

  /*
   * @notice Approves another address to claim for the ownership of any tokens owned by this account
   * @param _to address to be approved for the given token ID
   */
  function approveAll(address _to)
    public
    payable
    whenNotPaused
    whenNotPausedUser(msg.sender)
  {
    require(_to != msg.sender);
    require(_to != address(0));
    operatorApprovals[msg.sender][_to] = true;

    emit ApprovalForAll(msg.sender, _to, true);
  }

  /*
   * @notice Removes approval for another address to claim for the ownership of any
   *  tokens owned by this account.
   * @dev Note that this only removes the operator approval and
   *  does not clear any independent, specific approvals of token transfers to this address
   * @param _to address to be disapproved for the given token ID
   */
  function disapproveAll(address _to)
    public
    payable
    whenNotPaused
    whenNotPausedUser(msg.sender)
  {
    require(_to != msg.sender);
    delete operatorApprovals[msg.sender][_to];
    
    emit ApprovalForAll(msg.sender, _to, false);
  }

  /*
   * @notice Transfer a token owned by another address, for which the calling address has
   *  previously been granted transfer approval by the owner.
   * @param _from The address that owns the token
   * @param _to The address that will take ownership of the token. Can be any address, including the caller
   * @param _tokenId The ID of the token to be transferred
   */
  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    public
    payable
    whenNotPaused
  {
    require(isSenderApprovedFor(_tokenId));
    require(ownerOf(_tokenId) == _from);
    _clearApprovalAndTransfer(ownerOf(_tokenId), _to, _tokenId);
  }

  /*
   * @notice Transfers the ownership of an NFT from one address to another address
   * @dev Throws unless `msg.sender` is the current owner, an authorized
   * operator, or the approved address for this NFT. Throws if `_from` is
   * not the current owner. Throws if `_to` is the zero address. Throws if
   * `_tokenId` is not a valid NFT. When transfer is complete, this function
   * checks if `_to` is a smart contract (code size > 0). If so, it calls
   * `onERC721Received` on `_to` and throws if the return value is not
   * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
   * @param _from The current owner of the NFT
   * @param _to The new owner
   * @param _tokenId The NFT to transfer
   * @param _data Additional data with no specified format, sent in call to `_to`
   */
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes memory _data
  )
    public
    payable
    whenNotPaused
    whenNotPausedUser(msg.sender)
  {
    require(_to != address(0));
    require(isValidRedToken(_tokenId));
    transferFrom(_from, _to, _tokenId);
    if (isContract(_to)) {
      bytes4 tokenReceiverResponse = ERC721TokenReceiver(_to).onERC721Received.gas(50000)(
        _from, _tokenId, _data
      );
      require(tokenReceiverResponse == bytes4(keccak256("onERC721Received(address,uint256,bytes)")));
    }
  }

  /*
   * @notice Tells whether the msg.sender is approved to transfer the given token ID or not
   * Checks both for specific approval and operator approval
   * @param _tokenId uint256 ID of the token to query the approval of
   * @return bool whether transfer by msg.sender is approved for the given token ID or not
   */
  function isSenderApprovedFor(uint256 _tokenId) public view returns (bool) {
    return
      ownerOf(_tokenId) == msg.sender ||
      getApproved(_tokenId) == msg.sender ||
      isApprovedForAll(ownerOf(_tokenId), msg.sender);
  }

  /*
   * @notice Transfers the ownership of a given token ID to another address
   * @param _to address to receive the ownership of the given token ID
   * @param _tokenId uint256 ID of the token to be transferred
   */
  function transfer(address _to, uint256 _tokenId)
    external
    payable
    whenNotPaused
    onlyOwnerOf(_tokenId)
  {
    _clearApprovalAndTransfer(msg.sender, _to, _tokenId);
  }
  
  /*
   * @notice Transfers the ownership of an NFT from one address to another address
   * @dev This works identically to the other function with an extra data parameter,
   *  except this function just sets data to ""
   * @param _from The current owner of the NFT
   * @param _to The new owner
   * @param _tokenId The NFT to transfer
  */
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    external
    payable
  {
    safeTransferFrom(_from, _to, _tokenId, "");
  }

  /*
   * @notice send amount shareUsers
   */
  function sendAmountShareUsers(
    uint256 _tokenId, 
    address _to, 
    uint256 _amount
  ) 
    external 
    onlyCOO
    returns (bool) 
  {
    require(_to != address(0));
    return _calculateShareUsers(_tokenId, ownerOf(_tokenId), _to, _amount);
  }

  /*
   * @notice send amount shareUsers
   */
  function sendAmountShareUsersFrom(
    uint256 _tokenId, 
    address _from, 
    address _to, 
    uint256 _amount
  ) 
    external 
    onlyCOO
    returns (bool) 
  {
    require(_to != address(0));
    return _calculateShareUsers(_tokenId, _from, _to, _amount);
  }

  /*
   * @notice update collectedAmount 
   */
  function updateCollectedAmount(uint256 _tokenId, uint256 _amount) external onlyCOO returns (bool) {
    require(isValidRedToken(_tokenId));
    require(_amount > 0);
    
    address owner = ownerOf(_tokenId);
    
    redTokens[_tokenId].collectedAmount = redTokens[_tokenId].collectedAmount.add(_amount);
    
    emit CollectedAmountUpdate(_tokenId, owner, _amount);
    return true;
  }

  /*
   * @notice createRedToken
   */
  function createRedToken(
    address _user, 
    string calldata _rmsBondNo, 
    uint256 _bondAmount, 
    uint256 _listingAmount
  ) 
    external 
    onlyCOO 
    returns (uint256) 
  {
    return _createRedToken(_user,_rmsBondNo,_bondAmount,_listingAmount);
  }

  /*
   * @notice burn amount a token by share users
   */
  function burnAmountByShareUser(
    uint256 _tokenId, 
    address _from, 
    uint256 _amount
  ) 
    external 
    onlyCOO 
    returns (bool) 
  {
    return _calculateShareUsers(_tokenId, _from, address(0), _amount);
  }
  
  /*
   * @notice burn RedToken
   */
  function burn(address _owner, uint256 _tokenId) external onlyCOO returns(bool) {
    require(_owner != address(0));
    return _burn(_owner, _tokenId);
  }

  /** internal function **/
  function isContract(address _addr) internal view returns (bool) {
    uint size;
    assembly { size := extcodesize(_addr) }
    return size > 0;
  }

  /*
   * @notice checked shareUser by shareUsersKeys
   */
  function isShareUser(uint256 _tokenId, address _from) internal onlyCOO view returns (bool) {
    bool chechedUser = false;
    for (uint index = 0; index < shareUsersKeys[_tokenId].length; index++) {
      if (  shareUsersKeys[_tokenId][index] == _from ){
        chechedUser = true;
        break;
      }
    }
    return chechedUser;
  }

  /*
  * @notice Internal function to clear current approval and transfer the ownership of a given token ID
  * @param _from address which you want to send tokens from
  * @param _to address which you want to transfer the token to
  * @param _tokenId uint256 ID of the token to be transferred
  */
  function _clearApprovalAndTransfer(
    address _from, 
    address _to, 
    uint256 _tokenId
  )
    whenNotPausedUser(msg.sender)
    internal 
  {
    require(_to != address(0));
    require(_to != ownerOf(_tokenId));
    require(ownerOf(_tokenId) == _from);
    require(isValidRedToken(_tokenId));

    _clearApproval(_from, _tokenId);
    _removeToken(_from, _tokenId);
    _addToken(_to, _tokenId);
    _changeTokenShareUserByOwner(_from, _to, _tokenId);

    emit Transfer(_from, _to, _tokenId);
  }

  /*
   * @notice change token owner rate sending
   * @param _from address which you want to change rate from
   * @param _to address which you want to change rate the token to
   * @param _tokenId uint256 ID of the token to be change rate
   */
  function _changeTokenShareUserByOwner(
    address _from, 
    address _to, 
    uint256 _tokenId
  ) 
    internal 
    onlyCOO 
  {
    uint256 amount = shareUsers[_tokenId][_from];
    delete shareUsers[_tokenId][_from];

    shareUsers[_tokenId][_to] = shareUsers[_tokenId][_to].add(amount);

    if ( !isShareUser(_tokenId, _to) ) {
      shareUsersKeys[_tokenId].push(_to);
    }
  }

  /*
   * @notice remove shareUsers
   */
  function _calculateShareUsers(
    uint256 _tokenId, 
    address _from, 
    address _to, 
    uint256 _amount
  ) 
    internal 
    onlyCOO
    returns (bool) 
  {
    require(_from != address(0));
    require(_from != _to);
    require(_amount > 0);
    require(shareUsers[_tokenId][_from] >= _amount);
    require(isValidRedToken(_tokenId));

    address owner = ownerOf(_tokenId);
    
    shareUsers[_tokenId][_from] = shareUsers[_tokenId][_from].sub(_amount);
    shareUsers[_tokenId][_to] = shareUsers[_tokenId][_to].add(_amount);

    if ( !isShareUser(_tokenId, _to) ) {
      shareUsersKeys[_tokenId].push(_to);
    }

    emit calculateShareUsers(_tokenId, owner, _from, _to, _amount);
    return true;
  }

  /*
  * @notice Internal function to clear current approval of a given token ID
  * @param _tokenId uint256 ID of the token to be transferred
  */
  function _clearApproval(address _owner, uint256 _tokenId) private {
    require(ownerOf(_tokenId) == _owner);
    tokenApprovals[_tokenId] = address(0);

    emit Approval(_owner, address(0), _tokenId);
  }

  function _createRedToken(address _user, string memory _rmsBondNo, uint256 _bondAmount, uint256 _listingAmount) private returns (uint256){
    require(_user != address(0));
    require(bytes(_rmsBondNo).length > 0);
    require(_bondAmount > 0);
    require(_listingAmount > 0);

    uint256 _newTokenId = redTokens.length;

    RedToken memory _redToken = RedToken({
      tokenId: _newTokenId,
      rmsBondNo: _rmsBondNo,
      bondAmount: _bondAmount,
      listingAmount: _listingAmount,
      collectedAmount: 0,
      createdTime: now,
      isValid:true
    });

    redTokens.push(_redToken) - 1;

    shareUsers[_newTokenId][_user] = shareUsers[_newTokenId][_user].add(_listingAmount);
    shareUsersKeys[_newTokenId].push(_user);

    _addToken(_user, _newTokenId);

    emit RedTokenCreated(_user,
                        _redToken.tokenId,
                        _redToken.rmsBondNo,
                        _redToken.bondAmount,
                        _redToken.listingAmount,
                        _redToken.collectedAmount,
                        _redToken.createdTime);
    
    return _newTokenId;
  }
  
  /*
  * @notice Internal function to add a token ID to the list of a given address
  * @param _to address representing the new owner of the given token ID
  * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
  */
  function _addToken(address _to, uint256 _tokenId) private {
    require(tokenOwner[_tokenId] == address(0));
    tokenOwner[_tokenId] = _to;
    uint256 length = balanceOf(_to);
    ownedTokens[_to].push(_tokenId);
    ownedTokensIndex[_tokenId] = length;
    totalTokens = totalTokens.add(1);
  }

  /*
  * @notice Internal function to remove a token ID from the list of a given address
  * @param _from address representing the previous owner of the given token ID
  * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
  */
  function _removeToken(address _from, uint256 _tokenId) private {
    require(ownerOf(_tokenId) == _from);

    uint256 tokenIndex = ownedTokensIndex[_tokenId];
    uint256 lastTokenIndex = balanceOf(_from).sub(1);
    uint256 lastToken = ownedTokens[_from][lastTokenIndex];

    tokenOwner[_tokenId] = address(0);
    ownedTokens[_from][tokenIndex] = lastToken;
    ownedTokens[_from][lastTokenIndex] = 0;
    // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
    // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
    // the lastToken to the first position, and then dropping the element placed in the last position of the list

    ownedTokens[_from].length--;
    ownedTokensIndex[_tokenId] = 0;
    ownedTokensIndex[lastToken] = tokenIndex;
    totalTokens = totalTokens.sub(1);
  }

  /*
   * @dev Internal function to burn a specific token
   * @dev Reverts if the token does not exist
   * @param _tokenId uint256 ID of the token being burned by the msg.sender
   */
  function _burn(address _owner, uint256 _tokenId) private returns(bool) {
    require(ownerOf(_tokenId) == _owner);
    _clearApproval(_owner, _tokenId);
    _removeToken(_owner, _tokenId);

    redTokens[_tokenId].isValid = false;

    emit Transfer(_owner, address(0), _tokenId);
    return true;
  }
}