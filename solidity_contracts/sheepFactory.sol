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
  string releasedUser = "RELEASED";
  string escrowUser = "ESCROW";
  string defaultSheepUrl = "https://firebasestorage.googleapis.com/v0/b/cryptids-fyp.appspot.com/o/CardAssets%2Fcryptids_card_default.PNG?alt=media&token=ad11a1dc-6c61-4a34-b79c-537fb81dc6d3";

  struct Sheep {
    uint id;
    string name;
    uint uid;
    uint dna;
    uint hp;
    uint dp;
    string imageAsset;
    uint mintTime;
   }

  Sheep[] public sheeps;
  uint sheepCount = 0;
  mapping (uint => string) public sheepIndexToOwner;
  mapping (string => uint) ownerSheepCount;
  mapping (uint256 => string) public sheepIndexToApproved;

    /// @dev The CreateSheep event is fired whenever a new sheep is created.
   /// Used for Potentially Tracking / Notifing Clients of new sheep created?
    event CreateSheep(string owner, uint256 sheepId, uint256 genes);

    /// @dev Transfer event is a modified version of that the method
    ///as defined in current draft of ERC721 to account for Centralised UID Owners.
    /// Emitted every time a sheep ownership is assigned
    event Transfer(string from, string to, uint256 tokenId);

     /// @dev Assigns ownership of a specific Sheep to an address.
    function _transfer(string memory _from, string memory _to, uint256 _tokenId) internal {
        ownerSheepCount[_to]++;
        // transfer ownership
        sheepIndexToOwner[_tokenId] = _to;
        // Checks that the From field is not null
        if (bytes(_from).length != 0) {
            ownerSheepCount[_from]--;
            // clear any previously approved ownership exchange
           // delete SheepIndexToApproved[_tokenId];
        }
        // Emit the transfer event.
       emit Transfer(_from, _to, _tokenId);
    }

  function _createSheep(string memory _name, uint _uid, uint _dna, uint _hp, uint _dp) internal {
    string memory sheepPic = defaultSheepUrl;
    // NOTE should have a default link varible set (not value) in the main contract and a setDefaultCardLink() method which i can use to update
    // The default post contract deployement
    // Same goes for the Generic Developed owner & Auction Owner variables
    uint id = sheeps.length;
    sheeps.push(Sheep(id,_name, _uid, _dna, _hp, _dp, sheepPic, block.timestamp));
    sheepCount++;

    //Asigns the origional owner to the defined "Released" User - i.e is released without a proper owner
    sheepIndexToOwner[id] = releasedUser;
    ownerSheepCount[releasedUser]++;

    // Emits the CreateSheep Event
    emit CreateSheep(releasedUser, id, _dna);
  }

  //Used to generate randomized dna string used for Card QR Codes
  function _generateRandomDna(string memory _str) private view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    return rand % dnaModulus;
  }

  // Used to generated a Hp / DP Value that is randomized from 1 -10
  function _generateRandomStats(string memory _str, uint _statModifier) private view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    return (rand % statModulus) + _statModifier;
  }

  function setImageLink(uint _sheepId, string memory _newImageLink) public {
      Sheep storage tempSheep = sheeps[_sheepId];
      tempSheep.imageAsset = _newImageLink;
  }

  function createRandomSheep(string memory _name) public {
    //require(ownerSheepCount[msg.sender] == 0);
    // Replace the above requirement with an OnlyOwner
    uint randDna = _generateRandomDna(_name);
    // need to remplace this method with a new one for a uniqueid
    //Currently Same as Dna
     uint randUid = _generateRandomDna(_name);
    uint randHp = _generateRandomStats(_name, 1);
    uint randDp = _generateRandomStats(_name, 0);
    randDna = randDna - randDna % 100;

    _createSheep(_name, randUid, randDna, randHp, randDp);
  }
}
