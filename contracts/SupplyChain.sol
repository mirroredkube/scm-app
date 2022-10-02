// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract SupplyChain {
    uint32 public productId = 0;        // Product identifier
    uint32 public participantId = 0;    // Participant identifier
    uint32 public ownerId = 0;          // Ownership identifier

    struct product {
        string modelNumber;
        string partNumber;
        string serialNumber;
        address productOwner;
        uint32 cost;
        uint32 mfgTimestamp;
    }
    mapping (uint32 => product) public products;

    struct ownership {
        uint32 productId;
        uint32 ownerId;
        uint32 txTimestamp;
        address productOwner;
    }
    mapping (uint32 => ownership) public ownerships;    // track ownerships by ownership ID
    mapping (uint32 => uint32[]) public productTrack;   // track ownerships by product ID

    struct participant {
        string userName;
        string password;
        string participantType;
        address participantAddress;
    }
    mapping (uint32 => participant) public participants;


}
