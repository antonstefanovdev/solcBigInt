//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {SolcBigInt} from "./solcbigint.sol";

contract Sample {
    using SolcBigInt for *;
    SolcBigInt.BigInt public bigInt;

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
}