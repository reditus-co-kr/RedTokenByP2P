pragma solidity 0.5.4;

library Strings {
  // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
  function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
    bytes memory _ba = bytes(_a);
    bytes memory _bb = bytes(_b);
    bytes memory _bc = bytes(_c);
    bytes memory _bd = bytes(_d);
    bytes memory _be = bytes(_e);
    string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
    bytes memory babcde = bytes(abcde);
    uint k = 0;
    for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
    for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
    for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
    for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
    for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
    return string(babcde);
  }

  function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
    return strConcat(_a, _b, _c, _d, "");
  }

  function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
    return strConcat(_a, _b, _c, "", "");
  }

  function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
    return strConcat(_a, _b, "", "", "");
  }

  function uint2str(uint i) internal pure returns (string memory) {
    if (i == 0) return "0";
    uint j = i;
    uint len;
    while (j != 0){
        len++;
        j /= 10;
    }
    bytes memory bstr = new bytes(len);
    uint k = len - 1;
    while (i != 0){
        bstr[k--] = byte(uint8(48 + i % 10));
        i /= 10;
    }
    return string(bstr);
  }

  /*
   * ref : https://gitter.im/ethereum/solidity?at=56b8a608939ffd5d15f66e99
   */
  function toBytes(uint _num) internal pure returns (bytes memory _ret) {
    assembly {
      _ret := mload(0x10)
      mstore(_ret, 0x20)
      mstore(add(_ret, 0x20), _num)
    }
  }


}
