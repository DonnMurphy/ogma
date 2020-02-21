pragma solidity >=0.5.0 <0.6.2;
/**
 * @title SheepOwnership
 * @dev This Smart Contract Handles the Methods mapping sheep SheepOwnership
 * @dev This Smart Contract is based on the Cryptozombies Tutorial Series
 * @dev https://cryptozombies.io/en/lesson/6
 * @dev This Code has been modified for the purposes of this project
 */
import "./erc721.sol";
import "./safemath.sol";
import "./sheepHelper.sol";

/// TODO: Replace this with natspec descriptions
contract SheepOwnership is SheepHelper, ERC721 {

  using SafeMath for uint256;

  mapping (uint => address) sheepApprovals;

  function balanceOf(address _owner) external view  override returns (uint256) {
    return ownerSheepCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view  override returns (address) {
    return sheepToOwner[_tokenId];
  }



  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerSheepCount[_to] = ownerSheepCount[_to].add(1);
    ownerSheepCount[msg.sender] = ownerSheepCount[msg.sender].sub(1);
    sheepToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external override payable {
    require (sheepToOwner[_tokenId] == msg.sender || sheepApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external  override payable onlyOwnerOf(_tokenId) {
    sheepApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

}
