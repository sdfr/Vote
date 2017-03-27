pragma solidity ^0.4.6;
// We have to specify what version of compiler this code will compile with

contract Voting {


	address owner=0x004fEf376f2E29f1aF441CA0D64650380b022F89;

    struct Member{

        address name;

        uint8 numberOfVotes;

        bool proposed;

        uint balance;

    }



    struct Proposal{

        bytes32 name;

        address creator;

        bytes32 description;

        uint8 numberOfVotes;

    }


    Proposal public prop;

    Proposal[] public proposals;

    Member public member;

    mapping(address => Member) public members;

    uint current_block_number;

    uint deadline;
  
    mapping (bytes32 => uint8) public votesReceived;
  
    bytes32[] public projectList;



    function Voting(bytes32[] projectNames) {

	current_block_number =block.number;
    	
	projectList = projectNames;

	for(uint i = 0; i < projectList.length; i++) {

		prop.name = projectList[i];

		proposals.push(prop);

	}

    }



  // This function returns the total votes a candidate has received so far

    function totalVotesFor(bytes32 projectName) returns (uint8) {
    
	if (validProject(projectName) == false) throw;
    
	return votesReceived[projectName];
  
    }


  // This function increments the vote count for the specified candidate. This
  // is equivalent to casting a vote
    function voteForProject(bytes32 projectName) {
	
	if (validProject(projectName) == false) throw;
    
	votesReceived[projectName] += 1;
  
    }


  function validProject(bytes32 projectName) returns (bool) {

	for(uint i = 0; i < projectList.length; i++) {

		if (projectList[i] == projectName) {

			return true;

		}

	}
	return false;
  }



    //@notice Create a new member

    function CreateMember(){

        member.numberOfVotes=0;

        member.proposed=false;

        member.name=msg.sender;

        member.balance=0;

    }



    //@notice create a new proposal if this is possible

    function CreateProposal(bytes32 _name, bytes32 _descr){

        if (!members[msg.sender].proposed){

            prop.name=_name;

            prop.creator=msg.sender;

            prop.description=_descr;

            prop.numberOfVotes=votesReceived[_name];

            if (proposals.length<5){

                proposals.length++;

                proposals[proposals.length-1]=prop;

            }

            if (proposals.length==5){

                deadline = current_block_number + 556070; //A deadline of 1 month

            }

        }

    }



    function addTokenToBalance(uint j){

      members[msg.sender].balance+=j;

    }


    function WinningProposal() returns(bytes32){

        if(current_block_number>deadline){

            uint max=0;

            for (uint i=0;i<proposals.length;i++){

                if (proposals[i].numberOfVotes>proposals[max].numberOfVotes){

                    max=i;

                }

            }

            return proposals[i].name;

        }

        return "No winner yet !";

    }



    

    function kill(){if (msg.sender==owner) selfdestruct(owner); }


}
