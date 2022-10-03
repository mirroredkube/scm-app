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

    event TransferOwnership(uint32 indexed productId);

    function addParticipant(string memory _name, string memory _pass, string memory _participantType, address _participantAddress) public returns (uint32) {
        uint32 userId = participantId++;
        participants[userId].userName = _name;
        participants[userId].password = _pass;
        participants[userId].participantType = _participantType;
        participants[userId].participantAddress = _participantAddress;

        return userId;
    }

    function getParticipant(uint32 _participantId) public view returns (string memory, string memory, address) {
        return (participants[_participantId].userName,
                participants[_participantId].participantType,
                participants[_participantId].participantAddress);
    }

    function addProduct(uint32 _ownerId,
                        string memory _modelNumber,
                        string memory _partNumber,
                        string memory _serialNumber,
                        uint32 _productCost) public returns (uint32) {
        if(keccak256(abi.encodePacked(participants[_ownerId].participantType)) == keccak256("Manufacturer")) {
            uint32 _productId = productId++;

            products[_productId].modelNumber = _modelNumber;
            products[_productId].partNumber = _partNumber;
            products[_productId].serialNumber = _serialNumber;
            products[_productId].cost = _productCost;
            products[_productId].productOwner = participants[_ownerId].participantAddress;
            products[_productId].mfgTimestamp = uint32(block.timestamp);

            return _productId;
        }

       return 0;
    }

    modifier onlyOwner(uint32 _productId) {
         require(msg.sender == products[_productId].productOwner,"");
         _;
    }

    function getProduct(uint32 _productId) public view returns (string memory, string memory, string memory, uint32, address, uint32){
        return (products[_productId].modelNumber,
                products[_productId].partNumber,
                products[_productId].serialNumber,
                products[_productId].cost,
                products[_productId].productOwner,
                products[_productId].mfgTimestamp);
    }

    function newOwner(uint32 _user1Id,uint32 _user2Id, uint32 _prodId) onlyOwner(_prodId) public returns (bool) {
        participant memory p1 = participants[_user1Id];
        participant memory p2 = participants[_user2Id];
        uint32 ownership_id = ownerId++;

        if(keccak256(abi.encodePacked(p1.participantType)) == keccak256("Manufacturer")
            && keccak256(abi.encodePacked(p2.participantType))==keccak256("Supplier")){
            ownerships[ownership_id].productId = _prodId;
            ownerships[ownership_id].productOwner = p2.participantAddress;
            ownerships[ownership_id].ownerId = _user2Id;
            ownerships[ownership_id].txTimestamp = uint32(block.timestamp);
            products[_prodId].productOwner = p2.participantAddress;
            productTrack[_prodId].push(ownership_id);
            emit TransferOwnership(_prodId);

            return (true);
        }
        else if(keccak256(abi.encodePacked(p1.participantType)) == keccak256("Supplier") 
            && keccak256(abi.encodePacked(p2.participantType))==keccak256("Supplier")){
            ownerships[ownership_id].productId = _prodId;
            ownerships[ownership_id].productOwner = p2.participantAddress;
            ownerships[ownership_id].ownerId = _user2Id;
            ownerships[ownership_id].txTimestamp = uint32(block.timestamp);
            products[_prodId].productOwner = p2.participantAddress;
            productTrack[_prodId].push(ownership_id);
            emit TransferOwnership(_prodId);

            return (true);
        }
        else if(keccak256(abi.encodePacked(p1.participantType)) == keccak256("Supplier") 
            && keccak256(abi.encodePacked(p2.participantType))==keccak256("Consumer")){
            ownerships[ownership_id].productId = _prodId;
            ownerships[ownership_id].productOwner = p2.participantAddress;
            ownerships[ownership_id].ownerId = _user2Id;
            ownerships[ownership_id].txTimestamp = uint32(block.timestamp);
            products[_prodId].productOwner = p2.participantAddress;
            productTrack[_prodId].push(ownership_id);
            emit TransferOwnership(_prodId);

            return (true);
        }

        return (false);
    }

    function getProvenance(uint32 _productId) external view returns (uint32[] memory) {

       return productTrack[_productId];
    }

    function getOwnership(uint32 _regId)  public view returns (uint32, uint32, address, uint32) {

        ownership memory r = ownerships[_regId];
        return (r.productId,r.ownerId,r.productOwner,r.txTimestamp);
    }

    function authenticateParticipant(uint32 _uid,
                                    string memory _uname,
                                    string memory _pass,
                                    string memory _utype) public view returns (bool){
        if(keccak256(abi.encodePacked(participants[_uid].participantType)) == keccak256(abi.encodePacked(_utype))) {
            if(keccak256(abi.encodePacked(participants[_uid].userName)) == keccak256(abi.encodePacked(_uname))) {
                if(keccak256(abi.encodePacked(participants[_uid].password)) == keccak256(abi.encodePacked(_pass))) {
                    return (true);
                }
            }
        }

        return (false);
    }
}
