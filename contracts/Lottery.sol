// SDPX-License-Identifier: MIT

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.6.6;

enum LOTTERY_STATE {
    OPEN,
    CLOSED,
    CALCULATING_WINNER
}

contract Lottery is Ownable {
    address payable[] public players;
    uint256 public usdEntryFee;
    AggregatorV3Interface public priceFeed;
    LOTTERY_STATE public lotteryState;

    constructor(address _priceFreed) public {
        usdEntryFee = 50 * (10**18);
        priceFeed = AggregatorV3Interface(_priceFreed);
        lotteryState = LOTTERY_STATE.CLOSED;
    }

    function enter() public payable {
        require(lotteryState == LOTTERY_STATE.OPEN);
        require(msg.value >= getEntranceFee(), "Not enough ETH!");
        players.push(msg.sender);
    }

    function getEntranceFee() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        uint256 adjustedPrice = uint256(price) * (10**18);
        uint256 fee = (usdEntryFee * 10**18) / adjustedPrice;
        return fee;
    }

    function startLottery() public onlyOwner {
        require(
            lotteryState == LOTTERY_STATE.CLOSED,
            "Cannot start new lottery yet!"
        );
        lotteryState = LOTTERY_STATE.OPEN;
    }
}
