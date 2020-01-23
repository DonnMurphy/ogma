pragma solidity >=0.5.0 <0.6.2;

import "./ownable.sol";
import "./safemath.sol";

contract SheepFactory is Ownable {

  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  event NewSheep(uint sheepId, string name, uint dna);

  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  uint cooldownTime = 1 days;

  struct Sheep {
    string name;
    uint dna;
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
  }

  Sheep[] public sheeps;

  mapping (uint => address) public sheepToOwner;
  mapping (address => uint) ownerSheepCount;

  function _createSheep(string memory _name, uint _dna) internal {
    sheeps.push(Sheep(_name, _dna, uint32(now + cooldownTime), 0, 0));
    uint id = sheeps.length - 1;
    sheepToOwner[id] = msg.sender;
    ownerSheepCount[msg.sender] = ownerSheepCount[msg.sender].add(1);
    emit NewSheep(id, _name, _dna);
  }

  function _generateRandomDna(string memory _str) private view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    return rand % dnaModulus;
  }

  function createRandomSheep(string memory _name) public {
    require(ownerSheepCount[msg.sender] == 0);
    uint randDna = _generateRandomDna(_name);
    randDna = randDna - randDna % 100;
    _createSheep(_name, randDna);
  }

}
