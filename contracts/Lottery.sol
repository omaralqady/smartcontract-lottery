// SDPX-License-Identifier: MIT

pragma solidity ^0.6.6;

contract Lottery {
    address payable[] public players;

    function enter() public payable {
        players.push(msg.sender);
    }
}
