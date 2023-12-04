// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {strings} from "solidity-stringutils/strings.sol";

contract Script04A is Script {
    using strings for string;

    string[] public inputRows;
    mapping (uint256 => uint256[]) winningNumbers;
    mapping (uint256 => uint256[]) playerNumbers;

    function run() public {
        _populateArrays();

        for (uint256 x; x < inputRows.length; ++x) {
            uint256[] memory winningNums = winningNumbers[x + 1];
            uint256[] memory playerNums = playerNumbers[x + 1];

            for (uint z; z < winningNums.length; ++z) console2.logUint(winningNums[z]);
        }

        uint256 score;
        for (uint256 i; i < inputRows.length; ++i) {
            uint256[] memory winningNums = winningNumbers[i + 1];
            uint256[] memory playerNums = playerNumbers[i + 1];

            // find number of matches per row
            uint256 matches;
            for (uint256 j; j < winningNums.length; ++j) {
                // console2.logString("div");
                console2.logUint(winningNums[j]);
                for (uint256 k; k < playerNums.length; ++k) {
                    if (winningNums[j] == playerNums[k]) ++matches;
                }
            }

            score += _calculateScore(matches);
        }

        // answer!
        console2.logUint(score);
    }

    function _populateArrays() internal {
        string memory input = vm.readFile("./input/04");
        
        strings.slice memory inputSlice = input.toSlice();
        strings.slice memory delim = string("\n").toSlice();
        
        string[] memory inputLines = new string[](strings.count(inputSlice, delim));
        for (uint256 i; i < inputLines.length; ++i) {
            strings.slice memory currentSlice = strings.split(inputSlice, delim);
            inputLines[i] = strings.toString(currentSlice);

            inputRows.push(inputLines[i]);
        }
        // pull out winning numbers
        for (uint256 j; j < inputLines.length; ++j) {
            strings.slice memory headerDelim = string(":").toSlice(); // leave preceding spaces to strip later
            strings.slice memory lineSlice = inputLines[j].toSlice();
            strings.split(lineSlice, headerDelim);

            // handle double spaces by replacing them with single space
            // while (strings.contains(lineSlice, string("  ").toSlice())) {
            strings.slice memory singleSpaceDelim = string(" ").toSlice();
            strings.slice memory doubleSpaceDelim = string("  ").toSlice();
            string memory result = "";
            while (strings.len(lineSlice) > 0) {
                strings.slice memory beforeDoubleSpace = strings.beyond(strings.split(lineSlice, doubleSpaceDelim), (string("").toSlice()));
                result = strings.concat(strings.toSlice(result), beforeDoubleSpace);
                if (strings.len(lineSlice) > 0) {
                    result = strings.concat(strings.toSlice(result), singleSpaceDelim);
                }
            }

            // strip leftover leading and trailing spaces for each line by copying it into a new string
            bytes memory bResult = bytes(result);
            bytes memory strBytes = new bytes(bResult.length - 1);
            for (uint256 k; k < strBytes.length; ++k) {
                strBytes[k] = bResult[k + 1];
            }
            string memory winningAndPlayerNumStr = string(strBytes);
            strings.slice memory winningAndPlayerSlice = strings.toSlice(winningAndPlayerNumStr); // relevant values
            
            strings.slice memory numsSeparator = string(" | ").toSlice();
            strings.slice memory winningNumsSlice = strings.split(winningAndPlayerSlice, numsSeparator);

            // push winning numbers into storage mapping
            strings.slice memory spaceDelim = string(" ").toSlice();
            uint256[] memory winningNums = new uint256[](strings.count(winningNumsSlice, spaceDelim) + 1);
            for (uint256 k; k < winningNums.length; ++k) {
                strings.slice memory currentSlice = strings.split(winningNumsSlice, spaceDelim);
                string memory currentNumString = strings.toString(currentSlice);
                winningNums[k] = _strToNum(currentNumString);
            }
            winningNumbers[j + 1] = winningNums; // k + 1 to match card IDs

            uint256[] memory playerNums = new uint256[](strings.count(winningAndPlayerSlice, spaceDelim) + 1);
            for (uint256 l; l < playerNums.length; ++l) {
                strings.slice memory currentSlice = strings.split(winningAndPlayerSlice, spaceDelim);
                string memory currentNumString = strings.toString(currentSlice);
                playerNums[l] = _strToNum(currentNumString);
            }
            playerNumbers[j + 1] = playerNums; // k + 1 to match card IDs
        }
    }

    function _strToNum(string memory numStr) internal returns (uint256) {
        // parse integer from string
        bytes memory bResult = bytes(numStr);
        // console2.logString(numStr);
        uint256 integer;
        for (uint256 i; i < bResult.length; ++i) {
            if (bResult[i] == bytes1(bytes(string(" ")))) console2.logString('hello');
            integer *= 10;
            integer += uint8(bResult[i]) - 48; // subtract 48 because ascii value for '0' == 48
        }
        return integer;
    }

    function _calculateScore(uint256 numMatches) internal returns (uint256 score) {
        if (numMatches <= 1) { 
            score = numMatches;
        } else {
            score = 2 ** (numMatches - 1);
        }
    } 
}