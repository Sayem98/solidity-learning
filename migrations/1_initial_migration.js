const Migrations = artifacts.require("Migrations");
const MultiSig = artifacts.require("MultiSig");
module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(
    MultiSig,
    [
      "0x16cba6c3a5497f4d1772062e667ff8e7c02fe04d",
      "0xb478cf45d6164f094d6c330b478b697fcd896ec0",
      "0xf69cb8773cb631a7fed4e9c55fcc90c67a8b2233",
    ],
    2
  );
};
