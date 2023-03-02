// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;
import "./Revieweru.sol";

contract Researcheru {
    Revieweru public reviewer = new Revieweru();
    mapping(uint => address) public Researchers;
    uint public numberOfResearchers;

    enum RevisionState {
        submitted,
        under_revision,
        rejected,
        done
    }
    uint public x=55;
    struct request{
        uint id;
        address author;
        string paper_hash;
        string field;
        string description;
        RevisionState state;
        uint reviewer;
        uint reward;
        uint deadline;
        string report_hash;
    }

    mapping(address => request[]) public requests;
    mapping(address => uint) public numberOfrequests;

    function checkAddress(address _researcher) public view returns(bool){
        for(uint i=0; i<numberOfResearchers; i++){
            if(Researchers[i] == _researcher){
                return true;
            }
        }
        return false;
    }

    function st2num(string memory numString) public pure returns(uint) {
        uint  val=0;
        bytes   memory stringBytes = bytes(numString);
        for (uint  i =  0; i<stringBytes.length; i++) {
            uint exp = stringBytes.length - i;
            bytes1 ival = stringBytes[i];
            uint8 uval = uint8(ival);
           uint jval = uval - uint(0x30);
   
           val +=  (uint(jval) * (10**(exp-1))); 
        }
      return val;
  }

    function signUp() public {
        if(!checkAddress(msg.sender)){
            Researchers[numberOfResearchers] = msg.sender;
            numberOfResearchers++;
        }
    }

    function submit(string memory _hash, string memory _field, string memory _description, string memory _reviewer, string memory _reward, string memory _deadline) public {
        uint reviewerid = st2num(_reviewer);
        uint reward = st2num(_reward);
        uint deadline = st2num(_deadline);
        if(checkAddress(msg.sender)){
            uint i = numberOfrequests[msg.sender];
            request memory newRequest = request(i, msg.sender, _hash, _field, _description, RevisionState.submitted, reviewerid, reward, deadline, "none");
            requests[msg.sender].push(newRequest);
            numberOfrequests[msg.sender] = (i+1);
        }
    }

    function updateState(address _author, uint _id, uint _state ) public {
        //retrieve reviewer address using ID
        //address reviewer = getaddress(requests[_author][_id].reviewer)
        address reviewerA = reviewer.getAddress(requests[_author][_id].reviewer);
        if(msg.sender == reviewerA){
            if(_state == 1){
                requests[_author][_id].state = RevisionState.under_revision;
            }
            else if(_state == 2){
                requests[_author][_id].state = RevisionState.rejected;
            }
            else if(_state == 3){
                requests[_author][_id].state = RevisionState.done;
            }
        }
    }

}
