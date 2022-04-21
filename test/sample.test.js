const { inputToConfig } = require("@ethereum-waffle/compiler")
const {expext, expect} = require("chai")
const {ethers} = require("hardhat")

describe("Sample", function(){
    let account
    let sample
    let lib

    beforeEach(async function () {        
        account = await ethers.getSigners()

        const Lib = await ethers.getContractFactory("SolcBigInt", account)
        lib = await Lib.deploy()
        await lib.deployed()

        const Sample = await ethers.getContractFactory("Sample",
        {
            libraries: {
                SolcBigInt: lib.address
            }
        },
        account)
        sample = await Sample.deploy()
        await sample.deployed()
        console.log(sample.address)
    })

    it("should be deployed", async function() {
        expect(sample.address).to.be.properAddress
    })

    it("should be correst SolcBigInt public functions: test #1", async function() {        
        
        //positive uint
        await sample.initU(25)
        expect(await sample.getSignStateAsU()).to.eq(0)
        expect(await sample.getNegSignStateAsU()).to.eq(1)

        expect(await sample.getIsPositiveFlag()).to.eq(true)
        expect(await sample.getIsNegativeFlag()).to.eq(false)
        expect(await sample.getIsZeroFlag()).to.eq(false)
        expect(await sample.getIsPositiveOrZeroFlag()).to.eq(true)
        expect(await sample.getIsNegativeOrZeroFlag()).to.eq(false)
        
        //zero uint
        await sample.initU(0)
        expect(await sample.getSignStateAsU()).to.eq(2)
        expect(await sample.getNegSignStateAsU()).to.eq(2)

        expect(await sample.getIsPositiveFlag()).to.eq(false)
        expect(await sample.getIsNegativeFlag()).to.eq(false)
        expect(await sample.getIsZeroFlag()).to.eq(true)
        expect(await sample.getIsPositiveOrZeroFlag()).to.eq(true)
        expect(await sample.getIsNegativeOrZeroFlag()).to.eq(true)

        //positive int
        await sample.init(100)
        expect(await sample.getSignStateAsU()).to.eq(0)
        expect(await sample.getNegSignStateAsU()).to.eq(1)

        expect(await sample.getIsPositiveFlag()).to.eq(true)
        expect(await sample.getIsNegativeFlag()).to.eq(false)
        expect(await sample.getIsZeroFlag()).to.eq(false)
        expect(await sample.getIsPositiveOrZeroFlag()).to.eq(true)
        expect(await sample.getIsNegativeOrZeroFlag()).to.eq(false)

        //zero int
        await sample.init(0)
        expect(await sample.getSignStateAsU()).to.eq(2)
        expect(await sample.getNegSignStateAsU()).to.eq(2)

        expect(await sample.getIsPositiveFlag()).to.eq(false)
        expect(await sample.getIsNegativeFlag()).to.eq(false)
        expect(await sample.getIsZeroFlag()).to.eq(true)
        expect(await sample.getIsPositiveOrZeroFlag()).to.eq(true)
        expect(await sample.getIsNegativeOrZeroFlag()).to.eq(true)

        //negative int
        await sample.init(-250)
        expect(await sample.getSignStateAsU()).to.eq(1)
        expect(await sample.getNegSignStateAsU()).to.eq(0)

        expect(await sample.getIsPositiveFlag()).to.eq(false)
        expect(await sample.getIsNegativeFlag()).to.eq(true)
        expect(await sample.getIsZeroFlag()).to.eq(false)
        expect(await sample.getIsPositiveOrZeroFlag()).to.eq(false)
        expect(await sample.getIsNegativeOrZeroFlag()).to.eq(true)
    })
})