// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {strings} from "solidity-stringutils/strings.sol";

contract Script01A is Script {
    using strings for string;

    string[] public inputStrings;
    string[] public reversedStrings;

    string[] public firstDigs;
    string[] public reverseDigs;

    string[] public doubleDigs;

    function run() public {
        string memory input = vm.readFile("./input/01");
        
        strings.slice memory inputSlice = input.toSlice();
        strings.slice memory delim = string("\n").toSlice();
        
        string[] memory inputParts = new string[](strings.count(inputSlice, delim));
        for (uint256 i; i < inputParts.length; ++i) {
            strings.slice memory currentSlice = strings.split(inputSlice, delim);
            inputParts[i] = strings.toString(currentSlice);

            inputStrings.push(inputParts[i]);
        }

        for (uint256 j; j < inputParts.length; ++j) {
            bytes memory _stringBytes = bytes(inputParts[j]);

            string memory _len = new string(_stringBytes.length);
            bytes memory _reversedBytes = bytes(_len);

            for (uint256 k; k < _stringBytes.length; ++k) {
                _reversedBytes[_stringBytes.length - k - 1] = _stringBytes[k];
            }

            reversedStrings.push(string(_reversedBytes));
        }
        
        // inputStrings and reversedStrings have same length
        for (uint256 l; l < inputStrings.length; ++l) {
            string memory str = inputStrings[l];
            string memory revStr = reversedStrings[l];

            bytes memory b = bytes(str);
            bytes memory revB = bytes(revStr);
            // b and revB have same length- search for first integer in both members at once
            for (uint256 m; m < b.length; ++m) {
                // push first digits of strings
                if (b[m] >= bytes1('0') && b[m] <= bytes1('9')) {
                    firstDigs.push(string(abi.encodePacked(b[m])));
                    break;
                }
            }

            for (uint256 n; n < b.length; ++n) {
                // push first digits of reversed strings
                if (revB[n] >= '0' && revB[n] <= '9') {
                    reverseDigs.push(string(abi.encodePacked(revB[n])));
                    break;
                } 
            }
        }

        uint256 total;
        // combine each member of both arrays into doubleDigs and sum
        for (uint n; n < firstDigs.length; ++n) {
            // populating array turned out not to be necessary
            string memory num = string.concat(firstDigs[n], reverseDigs[n]);
            doubleDigs.push(num);

            // parse integer from string
            bytes memory bResult = bytes(num);
            uint256 integer;
            for (uint256 o; o < bResult.length; ++o) {
                integer *= 10;
                integer += uint8(bResult[o]) - 48; // subtract 48 because ascii value for '0' == 48
            }
            total += integer;
        }

        // answer!
        console2.logUint(total);
    }
}
