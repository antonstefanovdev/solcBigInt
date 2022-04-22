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

    it("should be correst SolcBigInt public functions: test #2", async function() {
        //positive uint
        await sample.initU(120)
        expect(await sample.getIsUInt()).to.eq(true)
        expect(await sample.getIsInt()).to.eq(true)
        expect(await sample.getUInt()).to.eq(120)
        expect(await sample.getInt()).to.eq(120)

        expect(await sample.getUIntSafe()).to.eq(120)
        expect(await sample.getIntSafe()).to.eq(120)
        expect(await sample.getAbsSafe()).to.eq(120)

        //zero uint
        await sample.initU(0)
        expect(await sample.getIsUInt()).to.eq(true)
        expect(await sample.getIsInt()).to.eq(true)
        expect(await sample.getUInt()).to.eq(0)
        expect(await sample.getInt()).to.eq(0)

        expect(await sample.getUIntSafe()).to.eq(0)
        expect(await sample.getIntSafe()).to.eq(0)
        expect(await sample.getAbsSafe()).to.eq(0)

        //positive int
        await sample.init(1200)
        expect(await sample.getIsUInt()).to.eq(true)
        expect(await sample.getIsInt()).to.eq(true)
        expect(await sample.getUInt()).to.eq(1200)
        expect(await sample.getInt()).to.eq(1200)

        expect(await sample.getUIntSafe()).to.eq(1200)
        expect(await sample.getIntSafe()).to.eq(1200)
        expect(await sample.getAbsSafe()).to.eq(1200)

        //zero int
        await sample.init(0)
        expect(await sample.getIsUInt()).to.eq(true)
        expect(await sample.getIsInt()).to.eq(true)
        expect(await sample.getUInt()).to.eq(0)
        expect(await sample.getInt()).to.eq(0)

        expect(await sample.getUIntSafe()).to.eq(0)
        expect(await sample.getIntSafe()).to.eq(0)
        expect(await sample.getAbsSafe()).to.eq(0)

        //negative int
        await sample.init(-5000)
        expect(await sample.getIsUInt()).to.eq(false)
        expect(await sample.getIsInt()).to.eq(true)
        expect(await sample.getInt()).to.eq(-5000)

        expect(await sample.getUIntSafe()).to.eq(0)
        expect(await sample.getIntSafe()).to.eq(-5000)
        expect(await sample.getAbsSafe()).to.eq(5000)
    })

    it("should be correst SolcBigInt public functions: test #3", async function()
    {
        //positive and negative: abs(pos) > abs(neg)
        await sample.init(15)
        await sample.init2(-5)
        expect(await sample.e()).to.eq(false)
        expect(await sample.g()).to.eq(true)
        expect(await sample.l()).to.eq(false)

        expect(await sample.ge()).to.eq(true)
        expect(await sample.le()).to.eq(false)

        expect(await sample.maxValI()).to.eq(15)
        expect(await sample.maxValIAbs()).to.eq(15)
        expect(await sample.minValI()).to.eq(-5)
        expect(await sample.minValIAbs()).to.eq(5)

        //negative and positive: abs(pos) < abs(neg)
        await sample.init(-100)
        await sample.initU2(20)
        expect(await sample.e()).to.eq(false)
        expect(await sample.g()).to.eq(false)
        expect(await sample.l()).to.eq(true)
        
        expect(await sample.ge()).to.eq(false)
        expect(await sample.le()).to.eq(true)
        
        expect(await sample.maxValI()).to.eq(20)
        expect(await sample.maxValIAbs()).to.eq(100)
        expect(await sample.minValI()).to.eq(-100)
        expect(await sample.minValIAbs()).to.eq(20)

        //two positives: int and uint
        await sample.init(50)
        await sample.initU2(9)
        expect(await sample.e()).to.eq(false)
        expect(await sample.g()).to.eq(true)
        expect(await sample.l()).to.eq(false)
        
        expect(await sample.ge()).to.eq(true)
        expect(await sample.le()).to.eq(false)
        
        expect(await sample.maxValI()).to.eq(50)
        expect(await sample.maxValIAbs()).to.eq(50)
        expect(await sample.minValI()).to.eq(9)
        expect(await sample.minValIAbs()).to.eq(9)

        //two equal negatives
        await sample.init(-1000)
        await sample.init2(-1000)
        expect(await sample.e()).to.eq(true)
        expect(await sample.g()).to.eq(false)
        expect(await sample.l()).to.eq(false)
        
        expect(await sample.ge()).to.eq(true)
        expect(await sample.le()).to.eq(true)
        
        expect(await sample.maxValI()).to.eq(-1000)
        expect(await sample.maxValIAbs()).to.eq(1000)
        expect(await sample.minValI()).to.eq(-1000)
        expect(await sample.minValIAbs()).to.eq(1000)

        //two negatives
        await sample.init(-1000)
        await sample.init2(-10000)
        expect(await sample.e()).to.eq(false)
        expect(await sample.g()).to.eq(true)
        expect(await sample.l()).to.eq(false)
        
        expect(await sample.ge()).to.eq(true)
        expect(await sample.le()).to.eq(false)
        
        expect(await sample.maxValI()).to.eq(-1000)
        expect(await sample.maxValIAbs()).to.eq(10000)
        expect(await sample.minValI()).to.eq(-10000)
        expect(await sample.minValIAbs()).to.eq(1000)

        //zero and negative
        await sample.init(0)
        await sample.init2(-110)
        expect(await sample.e()).to.eq(false)
        expect(await sample.g()).to.eq(true)
        expect(await sample.l()).to.eq(false)
        
        expect(await sample.ge()).to.eq(true)
        expect(await sample.le()).to.eq(false)
        
        expect(await sample.maxValI()).to.eq(0)
        expect(await sample.maxValIAbs()).to.eq(110)
        expect(await sample.minValI()).to.eq(-110)
        expect(await sample.minValIAbs()).to.eq(0)
    })

    it("should be correst SolcBigInt public functions: test #4", async function()
    {   
        //two positives
        await sample.init(20)
        await sample.init2(50)
        expect(await sample.addShort()).to.eq(70)
        expect(await sample.subShort()).to.eq(-30)

        await sample.init(50)
        await sample.init2(20)
        expect(await sample.addShort()).to.eq(70)
        expect(await sample.subShort()).to.eq(30)

        //two negatives
        await sample.init(-200)
        await sample.init2(-500)
        expect(await sample.addShort()).to.eq(-700)
        expect(await sample.subShort()).to.eq(300)
        
        await sample.init(-500)
        await sample.init2(-200)
        expect(await sample.addShort()).to.eq(-700)
        expect(await sample.subShort()).to.eq(-300)

        //positive and negative
        await sample.init(300)
        await sample.init2(-80)
        expect(await sample.addShort()).to.eq(220)
        expect(await sample.subShort()).to.eq(380)
                
        await sample.init(-80)
        await sample.init2(300)
        expect(await sample.addShort()).to.eq(220)
        expect(await sample.subShort()).to.eq(-380)
    })
})