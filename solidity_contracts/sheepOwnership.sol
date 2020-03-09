pragma solidity ^0.6;
/// @title Contract to Control Sheep Ownership
/// @ref - code based on public example of Cryptokitties KittyOwnership Smart Contract (To Align with Auctions)
/// https://github.com/cryptocopycats/awesome-cryptokitties/blob/master/contracts/KittyOwnership.sol
///Code has been heavily modified to move from ERC721 Implementation (Blockchain Only) to UID Based Approach
import "./sheepFactory.sol";
contract SheepOwnership is SheepFactory {
    event Approval(string owner, string approved, uint256 tokenId);

    // Internal utility functions: These functions all assume that their input arguments
    // are valid. We leave it to public methods to sanitize their inputs and follow
    // the required logic.

    /// @dev Checks if a given Id is the current owner of a particular Sheep.
    function _owns(string memory _claimant, uint256 _tokenId) public view returns (bool) {
        return keccak256(abi.encodePacked((sheepIndexToOwner[_tokenId]))) == keccak256(abi.encodePacked((_claimant)));
    }

    /// @dev Checks if a given user currently has transferApproval for a particular Sheep.
    function _approvedFor(string memory _claimant, uint256 _tokenId) public view returns (bool) {
       return keccak256(abi.encodePacked((sheepIndexToApproved[_tokenId]))) == keccak256(abi.encodePacked((_claimant)));
    }

    /// @dev Marks an user as being approved for transferFrom() - Direct Transfer, overwriting any previous
    ///  approval. Setting _approved to address(0) clears all transfer approval.
    /// Note need to modify this to an enum??
    function _approve(uint256 _tokenId, string memory _approved) internal {
        sheepIndexToApproved[_tokenId] = _approved;
    }

    /// @notice Returns the number of Sheep owned by a specific user.
    function balanceOf(string memory _owner) public view returns (uint256 count) {
        return ownerSheepCount[_owner];
    }

    /// @notice Transfers a Sheep to another user.
    /// @param _to The UID of the recipient
    /// @param _tokenId The ID of the Sheep to transfer.
    //NOTE USED TO BE EXTERNAL
    function transfer(
        string memory _to,
        string memory _from,
        uint256 _tokenId
    )
        public
    {
        // Safety check to prevent against null values
        //NOTE MAKE SURE NOT NULL!!!
        require((bytes(_to).length != 0));

        // User can only send their own sheep.
        require(_owns(_from, _tokenId));

        // Reassign ownership, clear pending approvals, emit Transfer event.
        _transfer(_from, _to, _tokenId);
    }

    /// @notice Grant another user the right to transfer a specific Sheep via
    ///  transferFrom(). Can be used for Non-Auction P2P Sheep Transfer
    /// @param _to The UID  to be granted transfer approval. Pass address(0) to
    ///  clear all approvals. // CHECK THIS
    /// @param _tokenId The ID of the Sheep that can be transferred if this call succeeds.
    //NOte this function used to be external but remix caused issues - check to see if it breaks anything
    function approve(
        string memory _to,
        string memory _from,
        uint256  _tokenId
    )
        public
    {
        // Only an owner can grant transfer approval.
        require(_owns(_from, _tokenId));

        // Register the approval (replacing any previous approval).
        _approve(_tokenId, _to);

        // Emit approval event.
        emit Approval(_from, _to, _tokenId);
    }

    /// @notice Transfer a Sheep owned by another user, for which the calling user
    ///  has previously been granted transfer approval by the owner.
    /// @param _from The user that owns the Sheep to be transfered.
    /// @param _to The user that should take ownership of the Sheep. Can be any user,
    ///  including the caller.
    /// @param _tokenId The ID of the Sheep to be transferred.
    /// @dev Required for ERC-721 compliance.
    //NOTE USED TO BE EXTERNAL
    function transferFrom(
        string memory _from,
        string memory _to,
        uint256 _tokenId
    )
        public
    {
        ///require(_to != user(0));
        // Check for approval and valid ownership
        require(_approvedFor(_from, _tokenId));
        require(_owns(_from, _tokenId));

        // Reassign ownership (also clears pending approvals and emits Transfer event).
        _transfer(_from, _to, _tokenId);
    }

    /// @notice Returns the total number of Sheeps currently in existence.
    ///CHECKEER
    function totalSupply() public view returns (uint) {
        return sheeps.length - 1;
    }

    /// @notice Returns the user currently assigned ownership of a given Sheep.
    //CHECKKER
    function ownerOf(uint256 _tokenId)
        external
        view
        returns (string memory owner)
    {
        owner = sheepIndexToOwner[_tokenId];
        return owner;
        //CHECK THIS
        //require(owner != address(0));
        //COME BACK TO FIX THIS PLEASE MAJOR BUG
        //require(owner != '');
    }

}
