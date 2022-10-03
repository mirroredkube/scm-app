let erc20Token = artifacts.require('./erc20Token.sol');

contract('erc20Token', function(accounts) {
  it("should assert true", function(done) {
    erc20Token.deployed();
    assert.isTrue(true);
    done();
  });
});
