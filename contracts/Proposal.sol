pragma solidity ^0.8.4;

import "./capitol.sol";

contract Proposal {
    modifier isNotExpired {
        require(block.timestamp < expiresAt, "This proposal has expired.");
        _;
    }
    
        modifier isExpired {
        require(block.timestamp >= expiresAt, "This proposal is in progress.");
        _;
    }
    
    
    enum Vote{ABSTAIN, YES, NO}
    enum Result{APPROVE, DENIED, DRAW}

    Capitol public capitol;
    bytes32 public paper;
    mapping(address => Vote) public votes;
    mapping(Vote => uint) public votesCount;
    uint public expiresAt;

    constructor(address _capitolAddress, bytes32 _paper) {
        capitol = Capitol(_capitolAddress);
        paper = _paper;
        expiresAt = block.timestamp + capitol.proposalDurationSeconds();
    }

    function vote(address _voter, Vote _vote) public isNotExpired returns (uint, uint) {
        require(votes[_voter] == Vote.ABSTAIN, "You cannot change your vote.");
        require(_voter == msg.sender || capitol.delegations(_voter) == msg.sender, "You must be delegated to vote.");
        votes[msg.sender] = _vote;
        votesCount[_vote] = votesCount[_vote] + 1;
        return (votesCount[Vote.YES], votesCount[Vote.NO]);
    }

    function vote(Vote _vote) public isNotExpired returns (uint, uint) {
        return vote(msg.sender, _vote);
    }
    
    function result() public view isExpired returns (Result) {
        if(votesCount[Vote.YES] == votesCount[Vote.NO]) {
            return Result.DRAW;
        } else if (votesCount[Vote.YES] > votesCount[Vote.NO]) {
            return Result.APPROVE;
        } else {
            return Result.DENIED;
        }
    }
}