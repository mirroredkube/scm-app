let SupplyChain = artifacts.require('./SupplyChain.sol');

contract('SupplyChain', async accounts => {
  it("should create a Participant", async () => {
    let instance = await SupplyChain.deployed();
    await instance.addParticipant("A","passA","Manufacturer","0xd2c303F54115971aFD2F3E432Ad989C5fc9982B8");
    let participant = await instance.participants(0);
    assert.equal(participant[0], "A");
    assert.equal(participant[2], "Manufacturer");

    await instance.addParticipant("B","passB","Supplier","0xe5eEa17Ec4b75D1FdfF894D7A94fA6ea919e438B");
    participant = await instance.participants(1);
    assert.equal(participant[0], "B");
    assert.equal(participant[2], "Supplier");

    await instance.addParticipant("C","passC","Consumer","0x510Cf6Ea9550d3a4CAb3bDf5995E415994D96798");
    participant = await instance.participants(2);
    assert.equal(participant[0], "C");
    assert.equal(participant[2], "Consumer");
  });

  it("should return Participant details", async () => {
    let instance = await SupplyChain.deployed();
    let participantDetails = await instance.getParticipant(0);
    assert.equal(participantDetails[0], "A");

    instance = await SupplyChain.deployed();
    participantDetails = await instance.getParticipant(1);
    assert.equal(participantDetails[0], "B");

    instance = await SupplyChain.deployed();
    participantDetails = await instance.getParticipant(2);
    assert.equal(participantDetails[0], "C");
  })
});
