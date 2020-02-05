pragma solidity >=0.5.0 <0.6.2;

//import "https://github.com/OpenZeppelin/openzeppelin-contracts-ethereum-package/blob/master/contracts/math/SafeMath.sol";
import "./safemath.sol";
import "./ownable.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.3.0/contracts/token/ERC20/ERC20.sol";
//import "http://raw.githubusercontent.com//OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/math/SafeMath.sol";
//import "http://raw.githubusercontent.com//OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/ownership/Ownable.sol";
contract SheepFactory is Ownable{

  // SafeMath for uint256;
  //using SafeMath32 for uint32;
  //using SafeMath16 for uint16;

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

  function _createSheep(string memory _name, uint _dna, uint _hp, uint _dp) internal {
    string memory sheepPic = "https://image.shutterstock.com/image-vector/cute-funny-cartoon-kick-sheep-600w-1577287216.jpg";

    sheeps.push(Sheep(_name, _dna, _hp, _dp, sheepPic));
    sheepCount++;
    uint id = sheeps.length - 1;
    sheepToOwner[id] = tx.origin;
    ownerSheepCount[tx.origin]++;
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
    uint randHp = _generateRandomStats(_name, 1);
    uint randDp = _generateRandomStats(_name, 0);
    randDna = randDna - randDna % 100;

    _createSheep(_name, randDna, randHp, randDp);
  }
}
