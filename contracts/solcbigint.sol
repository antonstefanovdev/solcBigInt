//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title A library that realise long arithmetic for big numbers expressed as BigInt structure
/// @author Anton Stefanov
/// @notice Here is basic arithmetic operations and basic convertors
/// @dev Use init or chainInit instead of parse to save gas
library SolcBigInt {

    /// @notice Use Zero to mark something which holds 0 or Negative|Positive in other case to express a sign
    enum SignState {
        Negative, Positive, Zero
        }

    /** @title Main structure which express big integers (both negative and positive) 
    * and is used to process basic arithmetical operations with them
    */
    /// @notice Saves integers as uint arrays with some additional data (such as sign and isZero check)
    /// @dev has data field which is uint array and signState field which is enum SignState
    struct BigInt {
        uint[] data;
        SignState signState;
    }

    /// @notice A function that converts basic int256 value into BigInt
    /** @dev All of arithmetical functions here works only with BigInt structure
    * To do safe arithmetical operations with int256 and correctly save result when it is greater 
    * than 2**255-1 or less then 2**255 it is recomended to init BigInt for each argument first
    */
    /** @param value Express a value which we want to store in new BigInt variable
    * Should be an integer in (-2**255, 2**255-1)
    */
    /// @return bigInt Express value as a BigInt structure
    function initBI(int value) public returns (BigInt memory bigInt) {
        uint[] memory data = new uint[](1);
        if(value >= 0)
            data[0] = uint(value);
        else
            data[0] = uint(-value);
            
        BigInt memory result;
        result.data = data;
        result.signState = getSignStateByVal(value);

        bigInt = result;
    }

    /// @notice A function that converts basic uint256 value into BigInt
    /** @dev All of arithmetical functions here works only with BigInt structure
    * To do safe arithmetical operations with uint256 and correctly save result when it is greater 
    * than 2**256-1 or less then 0 it is recomended to init BigInt for each argument first
    */
    /** @param value Express a value which we want to store in new BigInt variable
    * Should be an integer in (0, 2**256-1)
    */
    /// @return bigInt Express value as a BigInt structure
    function initBI(uint value) public returns (BigInt memory bigInt) {
        uint[] memory data = new uint[](1);

        BigInt memory result;
        result.data = data;
        result.signState = SignState.Positive;

        bigInt = result;
    }

    /// @dev A private function to get correst SignState item by int256 value
    function getSignStateByVal(int value) private returns (SignState) {
        if(value == 0)
        return SignState.Zero;
        else if (value > 0)
        return SignState.Positive;
        else
        return SignState.Negative;
    }

    //Todo: add NatSpec
    function getSingStateBI(BigInt memory bigInt) public returns(SignState signState) {
        return bigInt.signState;
    }

    function isPositive(BigInt memory bigInt) public returns(bool flag) {
        return bigInt.signState == SignState.Positive;
    }

    function isNegative(BigInt memory bigInt) public returns(bool flag) {
        return bigInt.signState == SignState.Negative;
    }

    function isPositiveOrZero(BigInt memory bigInt) public returns(bool flag) {
        return !isNegative(bigInt);
    }

    function isNegativeOrZero(BigInt memory bigInt) public returns(bool flag) {
        return !isPositive(bigInt);
    }

    function isZero(BigInt memory bigInt) public returns(bool flag) {
        return bigInt.signState == SignState.Zero;
    }

    function isApplicableToInt256(BigInt memory bigInt) public returns(bool flag) {
        if(isZero(bigInt))
        flag = true;
        else if(bigInt.data.length == 1) {
            if(bigInt.signState == SignState.Negative && bigInt.data[0] > uint256(-type(int256).min))
            flag = false;
            else if(bigInt.signState == SignState.Positive && bigInt.data[0] > uint256(type(int256).max))  
            flag = false;
            else
            flag = true;          
        }
        else
        flag = false;
    }

    function isApplicableToUInt256(BigInt memory bigInt) public returns(bool flag) {
        if(isNegative(bigInt))
        flag = false;
        else if(isZero(bigInt))
        flag = true;
        else if(bigInt.data.length == 1)
        flag = true;
        else
        flag = false;
    }

        function getSignMultiplier(BigInt memory bigInt) private returns(int) {
        if(isPositive(bigInt))
        return 1;
        else if(isNegative(bigInt))
        return -1;
        else
        return 0;
    }

    function convertToInt256FromBI(BigInt memory bigInt) public returns(int256 int256Value) {
        if(isZero(bigInt))
        int256Value = 0;
        else
        int256Value = int256(bigInt.data[0]) * getSignMultiplier(bigInt);
    }

    function convertToUInt256FromBI(BigInt memory bigInt) public returns(uint256 uInt256Value) {
        if(isZero(bigInt))
        uInt256Value = 0;
        else
        uInt256Value = bigInt.data[0];
    }

    function safeConvertToInt256FromBI(BigInt memory bigInt) public returns(int256 int256Value) {
        if(isApplicableToInt256(bigInt))
        int256Value = convertToInt256FromBI(bigInt);
        else
        int256Value = 0;
    }

    function safeConvertToUInt256FromBI(BigInt memory bigInt) public returns(uint256 uInt256Value) {
        if(isApplicableToUInt256(bigInt))
        uInt256Value = convertToUInt256FromBI(bigInt);
        else
        uInt256Value = 0;
    }
}