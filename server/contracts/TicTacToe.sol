// SPDX-License-Identifier: MIT
pragma solidity >0.5.11;


// The game logic will be implemented in this file

contract TicTacToe{

    // Storing the Room Id as Global

    string public RoomID;

    // Created a Mapping Game which maps from string to address array

    mapping(string=>address[]) public Game;
    
    // Created Mapping BettAmt which maps from adddress to uint
    // It maps from address of player to bet amount

    mapping(address=>uint) public BettAmt;

    // Function for Setting the Room Id

    function setRoomID(string memory id) public{ 
        RoomID=id;
    }
    
    // Function which accept a payment from the user and creates a user

    function createPlayer() external payable{
        address sender = msg.sender;
        uint betamount= msg.value;
        Game[RoomID].push(sender);
        BettAmt[sender]=betamount;
    }

    // Function to send the bet amount to the winner

    function sendBetAmt(address payable winner,uint bettedAmt) public{
        winner.transfer(bettedAmt);
    }
    
    // Calculate the Total Bet Amount

    function TotalBet() public view returns(uint) {
        uint Bet0=BettAmt[Game[RoomID][0]];
        uint Bet1=BettAmt[Game[RoomID][1]];
        uint total=Bet0+Bet1;
        return total;
    }

    // Function to take the winner index as input
    // It calculates the Winner address and send total bet to the person
    
    function Winner(uint index) public{
        address payable winner_address=address(uint160(Game[RoomID][index]));
        uint totalBet=TotalBet();
        sendBetAmt(winner_address, totalBet);

    }

}