//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title A library that realise long arithmetic for big numbers expressed as BigInt structure
/// @author Anton Stefanov
/// @notice Here is basic arithmetic operations and basic convertors
/// @dev Use init or chainInit instead of parse to save gas
library SolcBigInt {

    /// @notice Use Zero to mark something which holds 0 or Negative|Positive in other case to express a sign
    enum SignState {
        Positive, Negative, Zero
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
    function initBI(int value) public view returns (BigInt memory bigInt) {
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
    function initBI(uint value) public view returns (BigInt memory bigInt) {
        uint[] memory data = new uint[](1);
        data[0] = value;

        BigInt memory result;
        result.data = data;
        if(value == 0)
            result.signState = SignState.Zero;
        else   
            result.signState = SignState.Positive;

        bigInt = result;
    }

    /// @dev A private function to get correst SignState item by int256 value
    function getSignStateByVal(int value) private view returns (SignState) {
        if(value == 0)
        return SignState.Zero;
        else if (value > 0)
        return SignState.Positive;
        else
        return SignState.Negative;
    }

    //Todo: add NatSpec
    function getSingStateBI(BigInt memory bigInt) public view returns(SignState signState) {
        signState = bigInt.signState;
    }

    function negSignStateBI(SignState signState) public view returns(SignState negSignState)
    {
        if(signState == SignState.Zero)
        negSignState = signState;
        else if(signState == SignState.Positive)
        negSignState = SignState.Negative;
        else
        negSignState = SignState.Positive;
    }

    function isPositive(BigInt memory bigInt) public view returns(bool flag) {
        return bigInt.signState == SignState.Positive;
    }

    function isNegative(BigInt memory bigInt) public view returns(bool flag) {
        return bigInt.signState == SignState.Negative;
    }

    function isPositiveOrZero(BigInt memory bigInt) public view returns(bool flag) {
        return !isNegative(bigInt);
    }

    function isNegativeOrZero(BigInt memory bigInt) public view returns(bool flag) {
        return !isPositive(bigInt);
    }

    function isZero(BigInt memory bigInt) public view returns(bool flag) {
        return bigInt.signState == SignState.Zero;
    }

    function isApplicableToInt256(BigInt memory bigInt) public view returns(bool flag) {
        if(isZero(bigInt))
        flag = true;
        else if(bigInt.data.length > 1)
        flag = false;
        else if(isPositive(bigInt))
        flag = bigInt.data[0] < (2**255-1);
        else
        flag = bigInt.data[0] < 2**255;
    }

    function isApplicableToUInt256(BigInt memory bigInt) public view returns(bool flag) {
        if(isNegative(bigInt))
        flag = false;
        else if(isZero(bigInt))
        flag = true;
        else if(bigInt.data.length == 1)
        flag = true;
        else
        flag = false;
    }

        function getSignMultiplier(BigInt memory bigInt) private view returns(int) {
        if(isPositive(bigInt))
        return 1;
        else if(isNegative(bigInt))
        return -1;
        else
        return 0;
    }

    function convertToInt256FromBI(BigInt memory bigInt) public view returns(int256 int256Value) {
        if(isZero(bigInt))
        int256Value = 0;
        else
        int256Value = int256(bigInt.data[0]) * getSignMultiplier(bigInt);
    }

    function convertToUInt256FromBI(BigInt memory bigInt) public view returns(uint256 uInt256Value) {
        if(isZero(bigInt))
            uInt256Value = 0;
        else
            uInt256Value = bigInt.data[0];
    }

    function safeConvertToInt256FromBI(BigInt memory bigInt) public view returns(int256 int256Value) {
        if(isApplicableToInt256(bigInt))
        int256Value = convertToInt256FromBI(bigInt);
        else
        int256Value = 0;
    }

    function safeConvertToUInt256FromBI(BigInt memory bigInt) public view returns(uint256 uInt256Value) {
        if(isApplicableToUInt256(bigInt))
        uInt256Value = convertToUInt256FromBI(bigInt);
        else
        uInt256Value = 0;
    }

    function absBI(BigInt memory bigInt) public view returns(BigInt memory positiveBigInt) {
        if(isNegative(bigInt))
        {
            BigInt memory result = bigInt;
            result.signState = SignState.Positive;
            positiveBigInt = result;
        }
        else
        positiveBigInt = bigInt;        
    }

    function isEqualBI(BigInt memory arg1, BigInt memory arg2) public view returns(bool isEqualFlag) {
        if(arg1.signState != arg2.signState)
        return false;
        else if(arg1.data.length != arg2.data.length)
        return false;
        else
        {
            bool isEqual = true;
            for(uint i = 0; i < arg1.data.length; i++)
                if(arg1.data[i] != arg2.data[i])
                    isEqual = false;
            isEqualFlag = isEqual;
        }        
    }

    function isGreaterBI(BigInt memory arg1, BigInt memory arg2) public view returns(bool isGreaterFlag) {
        if(arg1.signState != arg2.signState)
        {
            if(arg1.signState == SignState.Positive)
            isGreaterFlag = true;
            else
            if(arg1.signState == SignState.Negative)
            isGreaterFlag = false;
            else
            if(arg2.signState == SignState.Negative)
            isGreaterFlag = true;
            else
            isGreaterFlag = false;
        }
    }

    function isLessBI(BigInt memory arg1, BigInt memory arg2) public view returns(bool isLessFlag) {
        isLessFlag = isGreaterBI(arg2, arg1);
    }

    function isGreaterOrEqualBI(BigInt memory arg1, BigInt memory arg2) 
        public view returns(bool isGreaterOfEqFlag) {
            isGreaterOfEqFlag = !isLessBI(arg1, arg2);
        }

    function isLessOrEqualBI(BigInt memory arg1, BigInt memory arg2) 
        public view returns(bool isLessOfEqFlag) {
            isLessOfEqFlag = !isGreaterBI(arg1, arg2);
        }        

    function maxBI(BigInt memory arg1, BigInt memory arg2) public view returns(BigInt memory maxBigInt) {
        if(isGreaterOrEqualBI(arg1, arg2))
        maxBigInt = arg1;
        else
        maxBigInt = arg2;
    }

    function maxAbsBI(BigInt memory arg1, BigInt memory arg2) public view returns(BigInt memory maxBigInt) {
        maxBigInt = maxBI(absBI(arg1), absBI(arg2));
    }

    function minBI(BigInt memory arg1, BigInt memory arg2) public view returns(BigInt memory minBigInt) {
        if(isLessOrEqualBI(arg1, arg2))
        minBigInt = arg1;
        else
        minBigInt = arg2;
    }

    function minAbsBI(BigInt memory arg1, BigInt memory arg2) public view returns(BigInt memory maxBigInt) {
        maxBigInt = minBI(absBI(arg1), absBI(arg2));
    }

    function addAbsBI(BigInt memory arg1, BigInt memory arg2) private view returns(BigInt memory sumBigInt) {
        BigInt memory result = maxAbsBI(arg1, arg2);
        BigInt memory term = minAbsBI(arg1, arg2);
        uint offsetData = 0;
        uint module = 2 ** 128;
        for(uint i = 0; i < result.data.length; i++)
        {
            uint menorResult = result.data[i] % module;            
            uint menorTerm;
            if(i < term.data.length)
                menorTerm = term.data[i] % module;

            uint majorResult = result.data[i] / module;
            uint majorTerm;            
            if(i < term.data.length)
                majorTerm = term.data[i] / module;     

            menorResult+=offsetData;
            if(menorResult >= module)
            {
                majorResult++;
                menorResult -= module;
            }

            offsetData = 0;
            if(majorResult >= module)
            {
                offsetData++;
                majorResult -= module;
            }

            menorResult += menorTerm;
            if(menorResult >= module)
            {
                majorResult++;
                menorResult -= module;
            }

            if(majorResult >= module)
            {
                offsetData++;
                majorResult -= module;
            }

            majorResult += majorTerm;
            if(majorResult >= module)
            {
                offsetData++;
                majorResult -= module;
            }

            result.data[i] = majorResult * module + menorResult;
        }

        if(offsetData > 0)
        {
            BigInt memory correctedResult;
            correctedResult.signState = SignState.Positive;
            correctedResult.data = new uint[](result.data.length + 1);
            correctedResult.data [correctedResult.data.length - 1] = offsetData;
            for(uint i = 0; i < correctedResult.data.length - 1; i++)            
                correctedResult.data[i] = result.data[i];
            sumBigInt = correctedResult;
        }
        else
        sumBigInt = result;

    }
    
    function subAbsBI(BigInt memory arg1, BigInt memory arg2) private view returns(BigInt memory diffBigInt) {
        BigInt memory result = maxAbsBI(arg1, arg2);
        BigInt memory term = minAbsBI(arg1, arg2);
        int offsetData = 0;
        int module = 2 ** 128;
        uint umodule = uint(module);
        for(uint i = 0; i < result.data.length; i++)
        {
            int menorResult = int(result.data[i] % umodule);            
            int menorTerm;
            if(i < term.data.length)
                menorTerm = int(term.data[i] % umodule);

            int majorResult = int(result.data[i] / umodule);
            int majorTerm;            
            if(i < term.data.length)
                majorTerm = int(term.data[i] / umodule);     

            menorResult -= offsetData;
            if(menorResult < 0)
            {
                majorResult--;
                menorResult += module;
            }

            offsetData = 0;
            if(majorResult < 0)
            {
                offsetData++;
                majorResult += module;
            }

            menorResult -= menorTerm;
            if(menorResult < 0)
            {
                majorResult--;
                menorResult += module;
            }

            if(majorResult < 0)
            {
                offsetData++;
                majorResult += module;
            }

            majorResult -= majorTerm;
            if(majorResult < 0)
            {
                offsetData++;
                majorResult += module;
            }

            result.data[i] = uint(majorResult) * umodule + uint(menorResult);
        }
        
        diffBigInt = result;

    }

    function addBI(BigInt memory arg1, BigInt memory arg2) public view returns(BigInt memory sumBigInt) {
        if(isZero(arg1))
        sumBigInt = arg2;
        else if(isZero(arg2))
        sumBigInt = arg1;
        else if(arg1.signState == arg2.signState)
        {
            BigInt memory result = addAbsBI(arg1, arg2);

            result.signState = arg1.signState;            
            sumBigInt = result;
        }
        else
        {
            BigInt memory result = subAbsBI(arg1, arg2);

            if(isEqualBI(maxAbsBI(arg1, arg2), absBI(arg1)))
            result.signState = arg1.signState;
            else
            result.signState = arg2.signState;            
            sumBigInt = result;
        }
    }

    function subBI(BigInt memory arg1, BigInt memory arg2) public view returns(BigInt memory diffBigInt) {
        if(isZero(arg1))
        diffBigInt = arg2;
        else if(isZero(arg2))
        diffBigInt = arg1;
        else if(arg1.signState != arg2.signState)
        {
            BigInt memory result = addAbsBI(arg1, arg2);

            result.signState = arg1.signState;            
            diffBigInt = result;
        }
        else
        {
            BigInt memory result = subAbsBI(arg1, arg2);

            if(isEqualBI(maxAbsBI(arg1, arg2), absBI(arg1)))
            result.signState = arg1.signState;
            else
            result.signState = negSignStateBI(arg1.signState);            
            diffBigInt = result;
        }
    }
}