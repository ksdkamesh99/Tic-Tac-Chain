// SPDX-License-Identifier: MIT
pragma solidity >0.5.11;


// The game logic will be implemented in this file

contract TicTacToe{

    // Storing the commission as 5000 Wei

    uint commission=5000;

    // Created a Mapping Game which maps from string to address array

    mapping(string=>address[]) public Game;
    
    // Created Mapping BettAmt which maps from adddress to uint
    // It maps from address of player to bet amount

    mapping(address=>uint) public BettAmt;
    
    // Created Mapping to store the unique id vs room id string
    
    mapping(uint=>string) public RoomIDMap;
    
    // Created Mapping to store the room id string vs unique id
    
    mapping(string=>uint) public IDRoomMap;
    
    // Set a Unique ID
    
    uint public uniqueid;
    
    // Set the mappings with room id string vs unique id and unique id vs room id string
    
    function setid(string memory roomID) public{
        // If the room ID already exists in the mapping then it will not create a new one 
        if(IDRoomMap[roomID]==0){
            uniqueid=uniqueid+1;
            RoomIDMap[uniqueid]=roomID;
            IDRoomMap[roomID]=uniqueid;

        }
    }
    
    // Get Function which returns the unique id for given string id
    
    function getid(string memory roomID) public view returns(uint){
        return IDRoomMap[roomID];
    }
    
    // Function which accept a payment from the user and creates a user

    function createPlayer(uint ID) external payable{
        string storage RoomID=RoomIDMap[ID];
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

    function TotalBet(uint ID) public view returns(uint) {
        string storage RoomID=RoomIDMap[ID];
        uint Bet0=BettAmt[Game[RoomID][0]];
        uint Bet1=BettAmt[Game[RoomID][1]];
        uint total=Bet0+Bet1;
        return total;
    }

    // Function to take the winner index as input
    // It calculates the Winner address and send total bet to the person

    function Winner(uint ID,uint index) public{
        string storage RoomID=RoomIDMap[ID];
        address payable winner_address=address(uint160(Game[RoomID][index]));
        uint totalBet=TotalBet(ID)-2*commission;
        sendBetAmt(winner_address, totalBet);

    }

    // Function for Get Bet Amount By Address

    function getBet(address player) public view returns(uint){
        return BettAmt[player];
    }

    // Function to send money to both players if it is draw game
    
    function Draw(uint ID) public{
        string storage RoomID=RoomIDMap[ID];
        address payable player0_address=address(uint160(Game[RoomID][0]));
        uint bet0=getBet(Game[RoomID][0])-commission;
        address payable player1_address=address(uint160(Game[RoomID][1]));
        uint bet1=getBet(Game[RoomID][1])-commission;
        sendBetAmt(player0_address, bet0);
        sendBetAmt(player1_address, bet1);

        
    }

}