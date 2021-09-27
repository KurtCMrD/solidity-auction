// SPDX-License-Identifier: GPL-3.0-or-later

// indicates the compiler version
// the ^ indicates that a older version cannot be used.
pragma solidity ^0.8.0;

// Interface to be used by child contracts.
contract AuctionInterface {
    // contract states.
    // variables to be stored on the blockchain.
    // <variable type> <varibale visibility> <variable name> 
    address internal auction_owner; // stores an account address for the auction owner
    uint256 public   auction_start; // uint256 | Unsigned Integer of length 256 | represents epoch time
    uint256 public   auction_end;   // represents epoch time
    uint256 public   highestBid;    // represents ether
    address public   highestBidder; // represents an account address/public key
    enum auction_state {
        CANCELLED,
        STARTED
    }

    // A structure of a car.
    // A struct is made up of different variables.
    // Very similar to objects in OOP.
    // Brand and Rbumber are struct members.
    struct car {
        string Brand;
        string Rnumber;
    }

    // A car object 
    car public MyCar; 
    
    // Arrays can be fixed or dynamic
    // A dynamic array of bidders' addresses
    address[] bidders; 

    // mappings are similar to dictionaries or hashmaps
    // map of bid addresses and bid amount
    // address is the Key.
    // uint is the Key Value  
    mapping(address => uint) public bids; 
    auction_state public STATE; // State of the auction. Started or cancelled.

    // Modifiers are special control methods.
    // they can modify the behaviour of a functions
    // Very similar to decorators.
    // The _ represents the function being modified.
    // This modifier checks whether an auction is still open.
    modifier an_ongoing_auction() {
        require(block.timestamp <= auction_end);
        _;
    }

    // This modifier gives special privileges to the auction owner.
    // require is part of Solidity's error handling.
    // Others: require() | assert() | revert()
    modifier only_owner() {
        require(msg.sender == auction_owner);
        _;
    }

    // functions are similar to methods in OOP.
    // Visibility is required. private | public | internal
    // Additional specifiers. Constant | Pure | Payable
    // Payable: function can receive ether.
    function bid() public virtual payable returns (bool) {}
    function withdraw() public virtual returns (bool) {}
    function cancel_auction() external virtual returns (bool) {}

    //
    event Bidevent(address indexed highestBidder, uint256 highestBid);
    event WithdrawalEvent(address withdrawer, uint256 amount);
    event CanceledEvent(string message, uint256 time);
} 

// Child contract
contract MyAuction is AuctionInterface {
    
    // Constructor that is only invoked once during the first deployment.
    // Contract constructors use the same name as the Contract.
    constructor (
        uint _biddingTime, 
        address _owner, 
        string memory _brand,   
        string memory _Rnumber
    ) {
        auction_owner = _owner;

        // now returns the block's timestamp. 
        // block.timestamp
        auction_start = block.timestamp;
        
        
        // _biddingTime represents a number of hours.
        auction_end   = auction_start + _biddingTime* 1 hours;
        STATE         = auction_state.STARTED;
        MyCar.Brand   = _brand;
        MyCar.Rnumber = _Rnumber;
    }

    function bid() public override payable an_ongoing_auction returns (bool) {
        require(
            bids[msg.sender] + msg.value > highestBid,
            "Can't bid. Please make a higher bid."
        );
        highestBidder    = msg.sender;
        highestBid       = msg.value;
        bids[msg.sender] = bids[msg.sender] + msg.value;
        
        bidders.push(msg.sender);

        emit Bidevent (highestBidder, highestBid);
        return true;
    }
    
    function withdraw() public override returns (bool) {
        require(block.timestamp > auction_end, "Can't withdraw, the auction is still open.");
        uint amount = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
        emit WithdrawalEvent(msg.sender, amount);
        return true;
    }

    function cancel_auction() external override only_owner an_ongoing_auction returns (bool) {
        STATE = auction_state.CANCELLED;
        emit CanceledEvent("Auction canceled", block.timestamp);
        return true;    
    }

}