pragma solidity ^0.6;
/// @title Handles creating auctions for sale of sheep
/// @ref - code based on public example of Cryptokitties KittyOwnership Smart Contract (To Align with Auctions)
/// https://github.com/cryptocopycats/awesome-cryptokitties/blob/master/contracts/KittyAuctions.sol
///Code has been heavily modified to move from ERC721 Implementation (Blockchain Only) to UID Based Approach
import "./SaleClockAuction.sol";
contract SheepAuction is SaleClockAuction {
    /// @dev Put a sheep up for auction.
    //USED TO BE EXTENRAL
    function createSaleAuction(uint256 _sheepId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, string memory _seller ) public {
        // NOTE THE BELOW LINE IS INCORRECT AND I WILL NEED TO FIND A WAY TO CHECK IF THE SHEEP IS ON AUCTION
        //require(_owns(msg.sender, _sheepId));
        //@dev sort out approvals plz
        //_approve(_kittyId, saleAuction);
        // Sale auction throws if inputs are invalid
        createAuction(
            _sheepId,
            _startingPrice,
            _endingPrice,
            _duration,
            _seller
        );
    }

    function getTotalAuctions() external view returns (uint){
      return auctions.length;
    }

    function isAuctionActive(uint _auctionId) external view returns (bool){
       // Auction storage tempAuction = getAuctionById(_auctionId);
      return _isOnAuction(auctions[_auctionId]);
    }
    //CORRECTION REMOVE IF IT IS NOT CHANGED TO AUCTION ID
    function getAuctionIDByTokenId(uint tokenId) external view returns (uint256){
      Auction memory tempAuction = tokenIdToAuction[tokenId];
      return tempAuction.auctionId;
    }

}
