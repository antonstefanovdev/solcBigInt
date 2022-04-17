//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {SolcBigInt} from "./solcbigint.sol";

contract Sample {
    using SolcBigInt for SolcBigInt.BigInt;
    SolcBigInt.BigInt public bigInt;
}