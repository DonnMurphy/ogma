pragma solidity ^0.6;
/**
 * @title SheepFactory
 * @dev This Smart Contract Handles the Creation and Mapping's of Sheep Objects
 * @dev This Smart Contract is based on the Cryptozombies Tutorial Series
 * @dev https://cryptozombies.io/en/lesson/6
 * @dev This Code has been modified for the purposes of this project
 */
contract SheepFactory{

  event NewSheep(uint sheepId, string name, uint dna, uint hp, uint dp, string imageAsset);

  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  uint statModulus = 10 ** 1;

  struct Sheep {
    string name;
    uint dna;
    uint hp;
    uint dp;
    string imageAsset;
   }

  Sheep[] public sheeps;
  uint sheepCount = 0;
  mapping (uint => address) public sheepToOwner;
  mapping (address => uint) ownerSheepCount;

  function _createSheep(string memory _name, uint _dna, uint16 _hp, uint16 _dp) internal {
    string memory sheepPic = "https://image.shutterstock.com/image-vector/cute-funny-cartoon-kick-sheep-600w-1577287216.jpg";

    sheeps.push(Sheep(_name, _dna, _hp, _dp, sheepPic));
    sheepCount++;
    uint id = sheeps.length - 1;
    sheepToOwner[id] = tx.origin;
    ownerSheepCount[msg.sender]++;
    emit NewSheep(id, _name, _dna, _hp, _dp, sheepPic);
  }

  function _generateRandomDna(string memory _str) private view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    return rand % dnaModulus;
  }

  function _generateRandomStats(string memory _str, uint _statModifier) private view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    return (rand % statModulus) + _statModifier;
  }

  function createRandomSheep(string memory _name) public {
    //require(ownerSheepCount[msg.sender] == 0);
    uint randDna = _generateRandomDna(_name);
    uint16 randHp = 2;//_generateRandomStats(_name, 1);
    uint16 randDp = 1;//_generateRandomStats(_name, 0);
    randDna = randDna - randDna % 100;

    _createSheep(_name, randDna, randHp, randDp);
  }
}
