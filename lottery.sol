//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery {
    address payable[] public players;
    address public manager;
    
    constructor() {
        manager = msg.sender;
    }
    
    receive() external payable {
        require(msg.value == 100000000000000000);
        players.push(payable(msg.sender));
    }
    
    function getBalance() public view returns(uint) {
        require(msg.sender == manager);
        return address(this).balance;
    }
    
    function pickWinner() public {
        require(msg.sender == manager);
        require(players.length >= 3);

        uint winner_ix = random() % players.length;
        players[winner_ix].transfer(getBalance());
        
        reset();
    }
    
    function reset() public {
        players = new address payable[] (0);
    }
    
    function random() internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }
    
}