const { expect } = require("chai");

const { ethers } = require("hardhat");

let erc20;
let owner, addr1, addr2;

describe("ERC 20 contract test", () => {
  beforeEach(async () => {
    [owner, addr1, addr2] = await ethers.getSigners();

    const ERC20 = await ethers.getContractFactory("ERC20");
    erc20 = await ERC20.deploy(1000, "IBRIZ", "IBZ");
    await erc20.waitForDeployment();
  });

  it("Deployment of contract should assign the total tokens to the owner", async () => {
    expect(await erc20.balanceOf(owner.address)).to.equal(1000);
  });

  it("Should transfer tokens between accounts", async () => {
    //transfer from owner to another address
    await erc20.transfer(addr1.address, 100);
    const addr1balance = await erc20.balanceOf(addr1.address);
    expect(addr1balance).to.equal(100);

    //transfer from one address to another address
    await erc20.connect(addr1).transfer(addr2.address, 100);
    const addr2balance = await erc20.balanceOf(addr2.address);
    expect(addr2balance).to.equal(100);
  });

  it("Transfer should fail if sender doesn't have enough tokens", async () => {
    const initialOwnerBalance = await erc20.balanceOf(owner.address);
    expect(
      await erc20.connect(addr1).transfer(owner.address, 10)
    ).to.be.revertedWithReason("You can't transfer tokens more than you have");

    await erc20.connect(addr1).transfer(owner.address, 10);

    //as it is reverted, the amount shouldn't change for owner
    expect(initialOwnerBalance).to.equal(await erc20.balanceof(owner.address));
  });

  it("Should approve tokens to another account for transer", async () => {
    await erc20.approve(addr1.address, 10);
    expect(await erc20.allowance(owner.address, addr1.address)).to.equal(10);
  });

  it("Should handle the transfer by delegated accounts", async () => {
    await erc20.approve(addr1.address, 20);
    await erc20.connect(addr1).transferFrom(owner.address, addr2.address, 10);
    expect(await erc20.balanceOf(owner.address)).to.equal(990);
    expect(await erc20.balanceOf(addr2.address)).to.equal(10);
    expect(await erc20.allowance(owner.address, addr1)).to.equal(10);
  });

  it("Minting should mint new tokens", async function () {
    await erc20.mint(addr1.address, 100);
    expect(await erc20.balanceOf(addr1.address)).to.equal(100);
  });

  it("Burning should burn tokens", async function () {
    await erc20.burn(100);
    expect(await erc20.totalSupply()).to.equal(900);
  });
});
