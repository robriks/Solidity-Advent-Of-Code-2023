// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {strings} from "solidity-stringutils/strings.sol";

contract Script02B is Script {
    using strings for string;

    string[] public inputRows;
    string[][] public array2D;

    function run() public {
        _populateArrays();

        array2D = new string[][](140); // input is 140 lines long
        for (uint256 i; i < inputRows.length; ++i) { // input is 140 lines long
            
            // populate intermediary column array to put in 2dArray
            string[] memory inputColumns = new string[](bytes(inputRows[i]).length); // all rows are the same length
            for (uint256 j; j < inputColumns.length; ++j) {
                inputColumns[j] = string(abi.encodePacked(bytes(inputRows[i])[j]));
            }

            array2D[i] = inputColumns;
        }

        uint256 total;
        for (uint256 k; k < array2D.length; ++k) {
            bool leftDigitPresent;
            bool isSymbolNeighbor;
            string memory numStr;

            for (uint256 l; l < array2D[k].length; ++l) {
                // prep for potential numStrings to the right
                // string memory numStr;
                // bool isSymbolNeighbor;

                // check if current element is a number
                string memory startCell = array2D[k][l];
                if (bytes(startCell)[0] >= bytes1('0') && bytes(startCell)[0] <= bytes1('9')) {
                    // bool isSymbolNeighbor;

                    // check neighboring 8 cells with 2 directional arrays for x and y
                    int8[8] memory xOffset = [int8(-1), int8(1), int8(0), int8(0),int8(-1),int8(-1), int8(1), int8(1)];
                    int8[8] memory yOffset = [ int8(0), int8(0),int8(-1), int8(1),int8(-1), int8(1),int8(-1), int8(1)];
                    // iterate using the 8 directions
                    for (uint256 m; m < xOffset.length; ++m) {
                        int256 newK = int256(k) + xOffset[m];
                        int256 newL = int256(l) + yOffset[m];
                        if (m == 2 && leftDigitPresent == true) continue;

                        console2.logString(string.concat("start:", startCell));
                        // make sure new offset K and L values don't overflow the array
                        if (newK >= 0 && newL >= 0 && uint256(newK) < array2D.length && uint256(newL) < array2D[k].length) {
                            // check if cell at array2D[newK][newL] is a symbol
                            string memory currentCell = array2D[uint256(newK)][uint256(newL)];
                            console2.logString(currentCell);
                            if (bytes(currentCell)[0] != bytes1('.') && (bytes(currentCell)[0] <= bytes1('0') || bytes(currentCell)[0] >= bytes1('9'))) {
                                isSymbolNeighbor = true;
                            }

                            // check if cell to the right is a number, grab full number only once on first iteration
                            if (m == 3 && bytes(numStr).length == 0 && !leftDigitPresent) { // characters to the right are read when m == 3
                                leftDigitPresent = true;
                                console2.logBool(leftDigitPresent);

                                numStr = array2D[k][l];
                                // console2.logString(string.concat("current numStr", numStr));
                                uint256 z;
                                uint256 tempL = uint256(newL);
                                string memory tempCell = array2D[k][tempL];
                                // console2.logString(string.concat("temp str", tempCell));
                                while (bytes(tempCell)[0] >= bytes1('0') && bytes(tempCell)[0] <= bytes1('9')) { //newL == l here
                                    numStr = string.concat(numStr, tempCell);
                                    ++tempL;
                                    tempCell = array2D[k][tempL];
                                }
                            }
                        }
                    }
                    if (isSymbolNeighbor && bytes(numStr).length > 0) {
                        // convert numStr to number and add it to total
                        bytes memory bResult = bytes(numStr);
                        uint256 integer;
                        for (uint256 o; o < bResult.length; ++o) {
                            integer *= 10;
                            integer += uint8(bResult[o]) - 48; // subtract 48 because ascii value for '0' == 48
                        }
                        total += integer;
                        console2.logString(string.concat('HERE', numStr));
                        console2.logUint(integer);
                        numStr = '';
                    }
                }
                // if (isSymbolNeighbor && bytes(numStr).length > 0) {
                //     // convert numStr to number and add it to total
                //     bytes memory bResult = bytes(numStr);
                //     uint256 integer;
                //     for (uint256 o; o < bResult.length; ++o) {
                //         integer *= 10;
                //         integer += uint8(bResult[o]) - 48; // subtract 48 because ascii value for '0' == 48
                //     }
                //     total += integer;
                //     console2.logString(string.concat('HERE', numStr));
                //     console2.logUint(integer);
                // }
            }
        }
        // answer!
        console2.logUint(total);
    }

    function _populateArrays() internal {
        // same input as 01A
        string memory input = vm.readFile("./input/03");
        
        strings.slice memory inputSlice = input.toSlice();
        strings.slice memory delim = string("\n").toSlice();
        
        string[] memory inputParts = new string[](strings.count(inputSlice, delim));
        for (uint256 i; i < inputParts.length; ++i) {
            strings.slice memory currentSlice = strings.split(inputSlice, delim);
            inputParts[i] = strings.toString(currentSlice);

            inputRows.push(inputParts[i]);
        }
    }
}