pragma solidity >=0.5.0 <0.6.2;

import "./sheepFactory.sol";
contract SheepHelper is SheepFactory {

//  function withdraw() external onlyOwner {
//    address payable _owner = owner();
//    _owner.transfer(address(this).balance);
//  }
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

}
