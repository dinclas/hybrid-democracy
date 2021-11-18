pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Capitol is Ownable {
    mapping (address=>address) public delegations;
    uint public proposalDurationSeconds;
    
    event ProposalCreated(address indexed _proposalAddress, address indexed _owner, bytes32 indexed _paper);
    
    constructor(uint _proposalDurationSeconds) {
        proposalDurationSeconds = _proposalDurationSeconds;
    }

    function deletagate(address _to) public {
        require(msg.sender != _to, "You cannot delegate to yourself.");
        delegations[msg.sender] = _to;
    }
    
    function removeDelegation() public {
        delete delegations[msg.sender];
    }
    
    function register(address _proposal, address _owner, bytes32 _paper) public {
        emit ProposalCreated(_proposal, _owner, _paper);
    }
}