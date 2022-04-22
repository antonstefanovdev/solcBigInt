//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {SolcBigInt} from "./solcbigint.sol";

contract Sample {
    using SolcBigInt for *;
    SolcBigInt.BigInt public bigInt;
    SolcBigInt.BigInt public bigInt2;

    //test-zone #1
    function initU(uint value) public
    {
        bigInt = SolcBigInt.initBI(value);
    }

    function init(int value) public
    {
        bigInt = SolcBigInt.initBI(value);
    }

    function getSignStateAsU() public view returns(uint)
    {
        SolcBigInt.SignState state = SolcBigInt.getSingStateBI(bigInt);
        return uint(state);
    }

    function getNegSignStateAsU() public view returns(uint)
    {
        SolcBigInt.SignState state = SolcBigInt.getSingStateBI(bigInt);
        state = SolcBigInt.negSignStateBI(state);
        return uint(state);
    }

    function getIsPositiveFlag() public view returns(bool)
    {
        return SolcBigInt.isPositive(bigInt);
    }

    function getIsNegativeFlag() public view returns(bool)
    {
        return SolcBigInt.isNegative(bigInt);
    }

    function getIsZeroFlag() public view returns(bool)
    {
        return SolcBigInt.isZero(bigInt);
    }

    function getIsPositiveOrZeroFlag() public view returns(bool)
    {
        return SolcBigInt.isPositiveOrZero(bigInt);
    }

    function getIsNegativeOrZeroFlag() public view returns(bool)
    {
        return SolcBigInt.isNegativeOrZero(bigInt);
    }

    //test-zone #2
    function getIsInt() public view returns(bool)
    {
        return SolcBigInt.isApplicableToInt256(bigInt);
    }

    function getIsUInt() public view returns(bool)
    {
        return SolcBigInt.isApplicableToUInt256(bigInt);
    }

    function getInt() public view returns(int)
    {
        return SolcBigInt.convertToInt256FromBI(bigInt);
    }

    function getUInt() public view returns(uint)
    {
        return SolcBigInt.convertToUInt256FromBI(bigInt);
    }

    function getIntSafe() public view returns(int)
    {
        return SolcBigInt.safeConvertToInt256FromBI(bigInt);
    }

    function getUIntSafe() public view returns(uint)
    {
            return SolcBigInt.safeConvertToUInt256FromBI(bigInt);
    }

    function getAbsSafe() public view returns(uint)
    {
        return SolcBigInt.safeConvertToUInt256FromBI(SolcBigInt.absBI(bigInt));
    }

    //test-zone #3
    function initU2(uint value) public
    {
        bigInt2 = SolcBigInt.initBI(value);
    }

    function init2(int value) public
    {
        bigInt2 = SolcBigInt.initBI(value);
    }

    function e() public view returns(bool)
    {
        return SolcBigInt.isEqualBI(bigInt, bigInt2);
    }

    function g() public view returns(bool)
    {
        return SolcBigInt.isGreaterBI(bigInt, bigInt2);
    }

    function l() public view returns(bool)
    {
        return SolcBigInt.isLessBI(bigInt, bigInt2);
    }

    function ge() public view returns(bool)
    {
        return SolcBigInt.isGreaterOrEqualBI(bigInt, bigInt2);
    }

    function le() public view returns(bool)
    {
        return SolcBigInt.isLessOrEqualBI(bigInt, bigInt2);
    }

    function maxValI() public view returns(int)
    {
        return SolcBigInt.safeConvertToInt256FromBI(SolcBigInt.maxBI(bigInt, bigInt2));
    }

    function minValI() public view returns(int)
    {
        return SolcBigInt.safeConvertToInt256FromBI(SolcBigInt.minBI(bigInt, bigInt2));
    }

    function maxValIAbs() public view returns(int)
    {
        return SolcBigInt.safeConvertToInt256FromBI(SolcBigInt.maxAbsBI(bigInt, bigInt2));
    }

    function minValIAbs() public view returns(int)
    {
        return SolcBigInt.safeConvertToInt256FromBI(SolcBigInt.minAbsBI(bigInt, bigInt2));
    }

    //test-zone #4

    function addShort() public view returns(int)
    {
        return SolcBigInt.safeConvertToInt256FromBI(SolcBigInt.addBI(bigInt, bigInt2));
    }

    function subShort() public view returns(int)
    {
        return SolcBigInt.safeConvertToInt256FromBI(SolcBigInt.subBI(bigInt, bigInt2));
    }
}