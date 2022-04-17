const { inputToConfig } = require("@ethereum-waffle/compiler")
const {expext, expect} = require("chai")
const {ethers} = require("hardhat")

describe("Sample", function(){
    let account
    let sample

    beforeEach(async function () {        
        account = await ethers.getSigners()
        const Sample = await ethers.getContractFactory("Sample",account)
        sample = await Sample.deploy()
        await sample.deployed()
        console.log(sample.address)
    })

    it("should be deployed", async function() {
        expect(sample.address).to.be.properAddress
    })
})