pragma solidity ^0.6;
/// @title Baseclass of A Decreasing Price Clock Auction
/// @ref - code based on publically available example of Cryptokitties Clock AUCTION
/// https://github.com/cryptocopycats/awesome-cryptokitties/blob/master/contracts/ClockAuctionBase.sol
///Code has been heavily modified to move from ERC721 Implementation (Blockchain ONly) to UID Based Approach

import "./sheepOwnership.sol";
contract ClockAuctionBase is SheepOwnership {

    //enum AuctionStatus {LIVE, COMPLETE, CANCELLED}
    // Represents an auction on an sheep
    struct Auction {
        uint tokenId;
        // Current owner of sheep
        string seller;
        // Price (in DonieBucks) at beginning of auction
        uint startingPrice;
        // Price (in DonieBucks) at end of auction
        uint endingPrice;
        // Duration (in seconds) of auction
        uint64 duration;
        // Time when auction started
        // NOTE: 0 if this auction has been concluded
        uint64 startedAt;

        string auctionStatus;

        uint finalBidPrice;

        uint auctionId;

        string auctionWinner;
    }
    // Array of all Auctions ever created
    Auction[] public auctions;
    // Map from token ID to their corresponding auction.
    mapping (uint256 => Auction) tokenIdToAuction;
    mapping (uint256 => uint256) auctionIdToTokenId;

    event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
    event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, string winner);
    event AuctionCancelled(uint256 tokenId);

    /// @dev Escrows the sheep, assigning ownership to this contract.
    function _escrow(string memory _owner, uint256 _tokenId) internal {
        transfer(escrowUser,_owner , _tokenId);
    }

    /// @dev Transfers an sheep owned by this contract to another user.
    function _transfer(string memory _receiver, uint256 _tokenId) internal {
        // it will throw if transfer fails
        // WAIT CHECK THAT THE CURRENT OWNER IS EQUAL TO ESCROW - For Above also
        transfer(_receiver, escrowUser, _tokenId);
    }

    /// @dev Adds an auction to the list of open auctions. Also fires the
    ///  AuctionCreated event.
    /// @param _tokenId The ID of the token to be put on auction.
    /// @param _auction Auction to add.
    function _addAuction(uint256 _tokenId, Auction memory _auction) internal {
        // Require that all auctions have a duration of
        // at least one minute. (Prevents Spam that would drain managing account)
        require(_auction.duration >= 1 minutes);




        uint auctionId = auctions.length;
        _auction.auctionId = auctionId;
        auctions.push(_auction);

        auctionIdToTokenId[auctionId] = _tokenId;
        tokenIdToAuction[_tokenId] = _auction;

        //NOTE change the Auction Created Event to include the id of the auction
        emit AuctionCreated(
            uint256(_tokenId),
            uint256(_auction.startingPrice),
            uint256(_auction.endingPrice),
            uint256(_auction.duration)
        );
    }

    /// @dev Cancels an auction unconditionally.
    function _cancelAuction(uint256 _tokenId, string memory _seller) internal {

        _removeAuction(_tokenId);

        _transfer(_seller, _tokenId);
        emit AuctionCancelled(_tokenId);

    }

    /// @dev Computes the price and transfers winnings.
    /// Does NOT transfer ownership of token.
    function _bid(uint256 _tokenId, uint256 _bidAmount, string memory _winner)
        internal
        returns (uint256)
    {
        // Get a reference to the auction struct
        Auction memory tempAuction = tokenIdToAuction[_tokenId];
        Auction storage auction = auctions[tempAuction.auctionId];

        // Explicitly check that this auction is currently live.
        require(_isOnAuction(auction));

        // Check that the bid is greater than or equal to the current price
        uint256 price = _currentPrice(auction);
        require(_bidAmount >= price);
        string memory seller = auction.seller;

        auction.auctionStatus = "COMPLETED";
        auction.finalBidPrice = _bidAmount;
        auction.auctionWinner = _winner;

        _removeAuction(_tokenId);
        // Transfer proceeds to seller
        if (price > 0) {
            uint256 sellerProceeds = price;
            //NOTE NEED TO FIGURE OUT HOW TO ADD THE VALUES TO THE wINNING ACCOUNT??
            // MAYBE INSTEAD OF THE FIREBASE WE JUST STORE THEM ON THE BLOCKCHAIN??
        }


        // Broadcast Successful Auction Event - Can use this for Extenal Fund Allocation
        emit AuctionSuccessful(_tokenId, price, _winner);

        return price;
    }

    /// @dev Removes an auction from the list of open auctions.
    /// @param _tokenId - ID of sheep on auction.
    function _removeAuction(uint256 _tokenId) internal {
        //Auction storage tempAuction = tokenIdToAuction[_tokenId];
        //tempAuction.startedAt = 0;
        delete tokenIdToAuction[_tokenId];
    }

    /// @dev Returns true if the auction is live.
    /// @param _auction - Auction to check.
    function _isOnAuction(Auction storage _auction) internal view returns (bool) {
        //uint256 auctionTokenID = auctionIdToTokenId
      // OK need to test this
        return (keccak256(abi.encodePacked(_auction.auctionStatus)) == keccak256(abi.encodePacked("LIVE")));
    }

    /// @dev Returns current price of an sheep on auction.
    //NOTE MAKE EXTERNAL GETCURRENTPRICE(AUCTIONID)
    function _currentPrice(Auction storage _auction)
        internal
        view
        returns (uint256)
    {
        uint256 secondsPassed = 0;
        if (now > _auction.startedAt) {
            secondsPassed = now - _auction.startedAt;
        }

        return _computeCurrentPrice(
            _auction.startingPrice,
            _auction.endingPrice,
            _auction.duration,
            secondsPassed
        );
    }

    /// @dev Computes the current price of an auction.
    function _computeCurrentPrice(
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration,
        uint256 _secondsPassed
    )
        internal
        pure
        returns (uint256)
    {
        if (_secondsPassed >= _duration) {
            // We've reached the end of the dynamic pricing portion
            // of the auction, just return the end price.
            return _endingPrice;
        } else {
            // Starting price can be higher than ending price (and often is!), so
            // this delta can be negative.
            int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
            int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
            // currentPriceChange can be negative, but if so, will have a magnitude
            // less that _startingPrice. Thus, this result will always end up positive.
            int256 currentPrice = int256(_startingPrice) + currentPriceChange;

            return uint256(currentPrice);
        }
    }
}
