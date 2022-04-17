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
    struct BigInt
    {
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

        function initBI(int value) public returns (BigInt memory bigInt)
    {
        uint[] memory data = new uint[](1);

        BigInt memory result;
        result.data = data;
        result.signState = getSignStateByVal(value);

        return result;
    }

    /// @dev A private function to get correst SignState item by int256 value
    function getSignStateByVal(int value) private returns (SignState)
    {
        if(value == 0)
        return SignState.Zero;
        else if (value > 0)
        return SignState.Positive;
        else
        return SignState.Negative;
    }

    //Todo: add NatSpec
    function getSingStateBI(BigInt memory bigInt) public returns(SignState signState)
    {
        return bigInt.signState;
    }
}