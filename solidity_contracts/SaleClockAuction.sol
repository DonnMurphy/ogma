pragma solidity ^0.6;
import "./ClockAuctionBase.sol";

/// @title Sale Implementation of ClockAuctionBase
// ref - code based on publically available xample of Cryptokitties SaleClockAUCTION
/// https://github.com/cryptocopycats/awesome-cryptokitties/blob/master/contracts/SaleClockAuction.sol
///Code has been heavily modified to move from ERC721 Implementation (Blockchain ONly) to UID Based Approach
contract SaleClockAuction is ClockAuctionBase {

    bool public isSaleClockAuction = true;

    /// @dev Creates and begins a new auction.
    /// @param _tokenId - ID of token to auction, sender must be owner.
    /// @param _startingPrice - Price of item (in DonieBucks) at beginning of auction.
    /// @param _endingPrice - Price of item (in DonieBucks) at end of auction.
    /// @param _duration - Length of auction (in seconds).
    /// @param _seller - Seller,
    // NOTE USED TO BE EXTERNAL
    function createAuction(
        uint256 _tokenId,
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration,
        string memory _seller
    )
        public
    {
      //Temporarily Transferrs ownership of the sheep to the Escrow user for the Auction (To Prevent Transfer while in auction ;)
        _escrow(_seller, _tokenId);
        Auction memory auction = Auction(
            _tokenId,
            _seller,
            uint128(_startingPrice),
            uint128(_endingPrice),
            uint64(_duration),
            uint64(now),
            "LIVE",//Because All Auctions are Live on Creation
            0,
            19000, //AuctionID that will never be reached
            "N/A"
        );
        _addAuction(_tokenId, auction);
    }

    //USED TO BE EXTERNAL
    function bid(uint256 _tokenId, uint256 _bidAmount, string memory _bidderId)
        public
    {
        // _bid will throw if the bid or funds transfer fails
        _bid(_tokenId, _bidAmount, _bidderId);
        _transfer(_bidderId, _tokenId);
    }

    /// @dev Cancels an auction that hasn't been won yet.
    ///  Returns the sheep to original owner.
    /// @param _tokenId - ID of token on auction,
    //NOTE USED TO BE EXTERNAL
    function cancelAuction(uint256 _tokenId, string memory _sellerId)
        public
    {
        Auction storage tempAuction = tokenIdToAuction[_tokenId];
        Auction storage auction = auctions[tempAuction.auctionId];
        require(_isOnAuction(auction));
        string memory seller = auction.seller;
        require (keccak256(abi.encodePacked(_sellerId)) == keccak256(abi.encodePacked(seller)));
        _cancelAuction(_tokenId, seller);
        auction.auctionStatus = "CANCELLED";
    }
    /// @dev Returns auction info for an sheep on auction.
    /// @param _tokenId - ID of sheep on auction.
    function getAuction(uint256 _tokenId)
        external
        view
        returns
    (
        uint256 tokenId,
        string memory seller,
        uint256 startingPrice,
        uint256 endingPrice,
        uint256 duration,
        uint256 startedAt,
        string memory auctionStatus,
        uint256 winningBidPrice,
        uint256 auctionId,
        string memory auctionWinner
    ) {
        Auction storage auction = tokenIdToAuction[_tokenId];
        require(_isOnAuction(auction));
        return (
            auction.tokenId,
            auction.seller,
            auction.startingPrice,
            auction.endingPrice,
            auction.duration,
            auction.startedAt,
            auction.auctionStatus,
            auction.finalBidPrice,
            auction.auctionId,
            auction.auctionWinner
        );
    }

    /// @dev Returns auction info for an auction.
    /// Includes Cancelled and Completed Auctions
    /// NOTE Maybe return extra info - TokenId, Auction Status etc
    /// @param _auctionId - ID of the auction.
    function getAuctionById(uint256 _auctionId)
        public
        view
        returns
    (
        uint256 tokenId,
        string memory seller,
        uint256 startingPrice,
        uint256 endingPrice,
        uint256 duration,
        uint256 startedAt,
        string memory auctionStatus,
        uint256 winningBidPrice,
        uint256 auctionId,
        string memory auctionWinner
    ) {
        Auction storage auction = auctions[_auctionId];
        //require(_isOnAuction(auction));
        return (
          auction.tokenId,
          auction.seller,
          auction.startingPrice,
          auction.endingPrice,
          auction.duration,
          auction.startedAt,
          auction.auctionStatus,
          auction.finalBidPrice,
          auction.auctionId,
          auction.auctionWinner
        );
    }

    /// @dev Returns the current price of an auction.
    /// @param _tokenId - ID of the token price we are checking.
    function getCurrentPrice(uint256 _tokenId)
        external
        view
        returns (uint256)
    {
        Auction storage auction = tokenIdToAuction[_tokenId];
        require(_isOnAuction(auction));
        return _currentPrice(auction);
    }
}
