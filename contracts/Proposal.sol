pragma solidity ^0.8.4;

import "./capitol.sol";

contract Proposal {
    enum Vote{ABSTAIN, YES, NO}

    Capitol public capitol;
    bytes32 public paper;
    mapping(address => Vote) public votes;
    mapping(Vote => uint) public votesCount;

    constructor(address _capitolAddress, bytes32 _paper) {
        capitol = Capitol(_capitolAddress);
        paper = _paper;
    }

    function vote(address _voter, Vote _vote) public returns (uint, uint) {
        require(votes[_voter] == Vote.ABSTAIN, "You cannot change your vote.");
        require(_voter == msg.sender || capitol.delegations(_voter) == msg.sender, "You must be delegated to vote.");
        votes[msg.sender] = _vote;
        votesCount[_vote] = votesCount[_vote] + 1;
        return (votesCount[Vote.YES], votesCount[Vote.NO]);
    }

    function vote(Vote _vote) public returns (uint, uint) {
        return vote(msg.sender, _vote);
    }
}