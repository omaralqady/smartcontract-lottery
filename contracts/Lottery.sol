// SDPX-License-Identifier: MIT

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

pragma solidity ^0.6.6;

contract Lottery {
    address payable[] public players;
    uint256 public usdEntryFee;
    AggregatorV3Interface public priceFeed;

    constructor(address _priceFreed) public {
        usdEntryFee = 50 * (10**18);
        priceFeed = AggregatorV3Interface(_priceFreed);
    }

    function enter() public payable {
        require(msg.value >= getEntranceFee(), "Not enough ETH!");
        players.push(msg.sender);
    }

    function getEntranceFee() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        uint256 adjustedPrice = uint256(price) * (10**18);
        uint256 fee = (usdEntryFee * 10**18) / adjustedPrice;
        return fee;
    }
}
