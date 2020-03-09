pragma solidity ^0.6;
/**
 * @title SheepHelper
 * @dev This Smart Contract Handles supporting methods for Cryotids app functions
 * @dev This Smart Contract is based on the Cryptozombies Tutorial Series
 * @dev https://cryptozombies.io/en/lesson/6
 * @dev This Code has been modified for the purposes of this project
 */
import "./sheepAuctions.sol";
contract SheepHelper is SheepAuction {

modifier onlyOwnerOf(uint _sheepId, string memory userID){
  //@dev move this modifier to the SheepFactory to allow for inheritence from all contracts
  require(keccak256(abi.encodePacked(userID)) == keccak256(abi.encodePacked((sheepIndexToOwner[_sheepId]))));
  _;
}
//USED TO BE EXTERNAL
// @dev used to return the ids of all sheep owned by a user (For viewing their deck)
  function getSheepsByOwner(string memory _owner) public view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerSheepCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < sheeps.length; i++) {
      if (keccak256(abi.encodePacked(sheepIndexToOwner[i])) == keccak256(abi.encodePacked(_owner))){
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

  //@dev returns a specific sheep when given an Id
  function getSheepById(uint _sheepId) public view returns(
    uint sheep_id,
    string memory sheep_name,
    uint sheep_uid,
    uint sheep_hp,
    uint sheep_dp,
    uint sheep_dna,
    string memory sheep_imagelink,
    string memory sheep_ownerid,
    uint sheep_mint_time
    )
    {
    Sheep memory sheep = sheeps[_sheepId];
    string memory ownerId = sheepIndexToOwner[_sheepId];
    return (sheep.id,sheep.name, sheep.uid, sheep.hp, sheep.dp, sheep.dna, sheep.imageAsset, ownerId, sheep.mintTime);
  }

  // @dev returns count of all sheep created by contract
  function getSheepTotal() external view returns (uint){
    return sheepCount;
  }

  function registerReleasedSheep(
      string memory _to,
      uint256 _tokenId
  )
      public
  {
      ///require(_to != user(0));
      // Check for approval and valid ownership
      //require(_approvedFor(_from, _tokenId));
      require(_owns(releasedUser, _tokenId));

      // Reassign ownership (also clears pending approvals and emits Transfer event).
      _transfer(releasedUser, _to, _tokenId);
  }


  function releaseRegisteredSheep(
      string memory _from,
      uint256 _tokenId
  )
      public
  {
      ///require(_to != user(0));
      // Check for approval and valid ownership
      //require(_approvedFor(_from, _tokenId));
      require(_owns(_from, _tokenId));

      // Reassign ownership (also clears pending approvals and emits Transfer event).
      _transfer(_from, releasedUser, _tokenId);
  }
}
