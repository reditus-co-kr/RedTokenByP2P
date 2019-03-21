pragma solidity 0.5.4;

/*
 * @title RedTokenAccessControl
 * @notice This contract defines organizational roles and permissions.
 */
contract RedTokenAccessControl {

  event Paused();
  event Unpaused();
  event PausedUser(address indexed account);
  event UnpausedUser(address indexed account);

  /*
   * @notice CEO's address
   */
  address public ceoAddress;

  /*
   * @notice CFO's address
   */
  address public cfoAddress;

  /*
   * @notice COO's address
   */
  address public cooAddress;

  bool public paused = false;

  /*
   * @notice paused users status
   */
  mapping (address => bool) private pausedUsers;

  /*
   * @notice init constructor
   */
  constructor () internal {
      ceoAddress = msg.sender;
      cfoAddress = msg.sender;
      cooAddress = msg.sender;
  }

  /*
   * @dev Modifier to make a function only callable by the CEO
   */
  modifier onlyCEO() {
    require(msg.sender == ceoAddress);
    _;
  }

  /*
   * @dev Modifier to make a function only callable by the CFO
   */
  modifier onlyCFO() {
    require(msg.sender == cfoAddress);
    _;
  }

  /*
   * @dev Modifier to make a function only callable by the COO
   */
  modifier onlyCOO() {
    require(msg.sender == cooAddress);
    _;
  }

  /*
   * @dev Modifier to make a function only callable by C-level execs
   */
  modifier onlyCLevel() {
    require(
      msg.sender == cooAddress ||
      msg.sender == ceoAddress ||
      msg.sender == cfoAddress
    );
    _;
  }

  /*
   * @dev Modifier to make a function only callable by CEO or CFO
   */
  modifier onlyCEOOrCFO() {
    require(
      msg.sender == cfoAddress ||
      msg.sender == ceoAddress
    );
    _;
  }

  /*
   * @dev Modifier to make a function only callable by CEO or COO
   */
  modifier onlyCEOOrCOO() {
    require(
      msg.sender == cooAddress ||
      msg.sender == ceoAddress
    );
    _;
  }

  /*
   * @notice Sets a new CEO
   * @param _newCEO - the address of the new CEO
   */
  function setCEO(address _newCEO) external onlyCEO {
    require(_newCEO != address(0));
    ceoAddress = _newCEO;
  }

  /*
   * @notice Sets a new CFO
   * @param _newCFO - the address of the new CFO
   */
  function setCFO(address _newCFO) external onlyCEO {
    require(_newCFO != address(0));
    cfoAddress = _newCFO;
  }

  /*
   * @notice Sets a new COO
   * @param _newCOO - the address of the new COO
   */
  function setCOO(address _newCOO) external onlyCEO {
    require(_newCOO != address(0));
    cooAddress = _newCOO;
  }

  /* Pausable functionality adapted from OpenZeppelin **/
  /*
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /*
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /*
   * @notice called by any C-LEVEL to pause, triggers stopped state
   */
  function pause() external onlyCLevel whenNotPaused {
    paused = true;
    emit Paused();
  }

  /*
   * @notice called by any C-LEVEL to unpause, returns to normal state
   */
  function unpause() external onlyCLevel whenPaused {
    paused = false;
    emit Unpaused();
  }

  /* user Pausable functionality ref someting : openzeppelin/access/Roles.sol **/
  /*
   * @dev Modifier to make a function callable only when the user is not paused.
   */
  modifier whenNotPausedUser(address account) {
    require(account != address(0));
    require(!pausedUsers[account]);
    _;
  }

  /*
   * @dev Modifier to make a function callable only when the user is paused.
   */
  modifier whenPausedUser(address account) {
    require(account != address(0));
    require(pausedUsers[account]);
    _;
  }

  /*
    * @dev check if an account has this pausedUsers
    * @return bool
    */
  function has(address account) internal view returns (bool) {
      require(account != address(0));
      return pausedUsers[account];
  }
  
  /*
   * @notice _addPauseUser
   */
  function _addPauseUser(address account) internal {
      require(account != address(0));
      require(!has(account));

      pausedUsers[account] = true;

      emit PausedUser(account);
  }

  /*
   * @notice _unpausedUser
   */
  function _unpausedUser(address account) internal {
      require(account != address(0));
      require(has(account));

      pausedUsers[account] = false;
      emit UnpausedUser(account);
  }

  /*
   * @notice isPausedUser
   */
  function isPausedUser(address account) external view returns (bool) {
      return has(account);
  }

  /*
   * @notice called by the COO to pauseUser, triggers stopped user state
   */
  function pauseUser(address account) external onlyCOO whenNotPausedUser(account) {
    _addPauseUser(account);
  }

  /*
   * @notice called by any C-LEVEL to unpauseUser, returns to user state
   */
  function unpauseUser(address account) external onlyCLevel whenPausedUser(account) {
    _unpausedUser(account);
  }
}
