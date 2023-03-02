// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract Revieweru {

    struct reviewer{
        address reviewer;
        string name;
        string field;
        uint experience;
        uint reputation;
        uint totalReward;
        uint requests;
    }

    mapping(uint => reviewer) reviewers;
    uint numberOfReviewers;

    struct request{
        uint id;
        address author;
        bool state;
    }

    mapping(address => request[]) ReviewRequests;
    mapping(address => uint) numberOfRequests;

    function getAddress(uint _id) public view returns(address){
        return reviewers[_id].reviewer;
    }

    function checkAddress(address _reviewer) public view returns(bool){
        for(uint i=0; i<numberOfReviewers; i++){
            if(reviewers[i].reviewer == _reviewer){
                return true;
            }
        }
        return false;
    }

    function signUp(string memory _name, string memory _field, uint _experience) public {
        if(!checkAddress(msg.sender)){
            reviewers[numberOfReviewers] = reviewer(msg.sender, _name, _field, _experience, 0, 0, 0);
        }
        
    }

    function reviewRequest(uint _id, address _author, address _reviewe) public{
        request memory newItem = request(_id, _author, true);
        ReviewRequests[_reviewe].push(newItem);
        numberOfRequests[_author]++;
    }

    function rejectRequest(address _reviewer, uint _id) public{
        ReviewRequests[_reviewer][_id].state = false;
    }

}
