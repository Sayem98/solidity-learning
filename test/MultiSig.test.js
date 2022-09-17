const MultiSig = artifacts.require("MultiSig");

contract("MultiSig", () => {
  before(() => {
    let instance = MultiSig.deployed();
    console.log(instance);
  });

  it("Should get the owners", async () => {
    console.log("Working...");
    const owner = await instance.owner();
    console.log(owner);
  });
});
