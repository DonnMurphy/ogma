pragma solidity ^0.6;
/**
 * @title SheepHelper
 * @dev This Smart Contract Handles the Methods relating to Sheep Structures
 * @dev This Smart Contract is based on the Cryptozombies Tutorial Series
 * @dev https://cryptozombies.io/en/lesson/6
 * @dev This Code has been modified for the purposes of this project
 */
import "./sheepFactory.sol";
contract SheepHelper is SheepFactory {


modifier onlyOwnerOf(uint _sheepId){
  require(msg.sender == sheepToOwner[_sheepId]);
  _;
}
  function getSheepsByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerSheepCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < sheeps.length; i++) {
      if (sheepToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

  function getSheepById(uint _sheepId) public view returns(string memory, uint, uint, uint, string memory){
    Sheep memory sheep = sheeps[_sheepId];
    return (sheep.name, sheep.hp, sheep.dp, sheep.dna, sheep.imageAsset);
  }

  function getSheepTotal() external view returns (uint){
    return sheepCount;
  }

  function findMySheepTotal() external view returns (uint){
    return sheepCount;
  }
}
