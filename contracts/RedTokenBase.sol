pragma solidity 0.5.7;

import "./math/SafeMath.sol";
import "./RedTokenAccessControl.sol";

/*
 * @title RedTokenBase
 * @notice This contract defines the RedToken data structure and how to read from it / functions
 */
contract RedTokenBase is RedTokenAccessControl {
  using SafeMath for uint256;

  /*
   * @notice Product defines a RedToken
   */ 
  struct RedToken {
    uint256 tokenId;
    string rmsBondNo;
    uint256 bondAmount;
    uint256 listingAmount;
    uint256 collectedAmount;
    uint createdTime;
    bool isValid;
  }

  /*
   * @notice tokenId for share users by listingAmount
   */
  mapping (uint256 => mapping(address => uint256)) shareUsers;

  /*
   * @notice tokenid by share accounts in shareUsers list iterator.
   */
  mapping (uint256 => address []) shareUsersKeys;

  /** events **/
  event RedTokenCreated(
    address account, 
    uint256 tokenId, 
    string rmsBondNo, 
    uint256 bondAmount, 
    uint256 listingAmount, 
    uint256 collectedAmount, 
    uint createdTime
  );
  
  /*
   * @notice All redTokens in existence.
   * @dev The ID of each redToken is an index in this array.
   */
  RedToken[] redTokens;
  
  /*
   * @notice Get a redToken RmsBondNo
   * @param _tokenId the token id
   */
  function redTokenRmsBondNo(uint256 _tokenId) external view returns (string memory) {
    return redTokens[_tokenId].rmsBondNo;
  }

  /*
   * @notice Get a redToken BondAmount
   * @param _tokenId the token id
   */
  function redTokenBondAmount(uint256 _tokenId) external view returns (uint256) {
    return redTokens[_tokenId].bondAmount;
  }

  /*
   * @notice Get a redToken ListingAmount
   * @param _tokenId the token id
   */
  function redTokenListingAmount(uint256 _tokenId) external view returns (uint256) {
    return redTokens[_tokenId].listingAmount;
  }
  
  /*
   * @notice Get a redToken CollectedAmount
   * @param _tokenId the token id
   */
  function redTokenCollectedAmount(uint256 _tokenId) external view returns (uint256) {
    return redTokens[_tokenId].collectedAmount;
  }

  /*
   * @notice Get a redToken CreatedTime
   * @param _tokenId the token id
   */
  function redTokenCreatedTime(uint256 _tokenId) external view returns (uint) {
    return redTokens[_tokenId].createdTime;
  }

  /*
   * @notice isValid a redToken
   * @param _tokenId the token id
   */
  function isValidRedToken(uint256 _tokenId) public view returns (bool) {
    return redTokens[_tokenId].isValid;
  }

  /*
   * @notice info a redToken
   * @param _tokenId the token id
   */
  function redTokenInfo(uint256 _tokenId)
    external view returns (uint256, string memory, uint256, uint256, uint256, uint)
  {
    require(isValidRedToken(_tokenId));
    RedToken memory _redToken = redTokens[_tokenId];

    return (
        _redToken.tokenId,
        _redToken.rmsBondNo,
        _redToken.bondAmount,
        _redToken.listingAmount,
        _redToken.collectedAmount,
        _redToken.createdTime
    );
  }
  
  /*
   * @notice info a token of share users
   * @param _tokenId the token id
   */
  function redTokenInfoOfshareUsers(uint256 _tokenId) external view returns (address[] memory, uint256[] memory) {
    require(isValidRedToken(_tokenId));

    uint256 keySize = shareUsersKeys[_tokenId].length;

    address[] memory addrs   = new address[](keySize);
    uint256[] memory amounts = new uint256[](keySize);

    for (uint index = 0; index < keySize; index++) {
      addrs[index]   = shareUsersKeys[_tokenId][index];
      amounts[index] = shareUsers[_tokenId][addrs[index]];
    }
    
    return (addrs, amounts);
  }
}