// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {strings} from "solidity-stringutils/strings.sol";

contract Script02B is Script {
    using strings for string;

    struct Turn {
        uint256 red;
        uint256 blue;
        uint256 green;
    }

    // "Game x :" has been stripped away since they can be inferred via array index
    string[] public inputGames; 

    mapping (uint256 => Turn[]) games;

    function run() public {
        _populateArrays();
        _populateGames();

        uint256 total;
        
        // find highest value of red, green, blue per game (over all turns)
        for (uint256 i; i < inputGames.length; ++i) {
            // mapping keys start at 1 to match game IDs
            Turn[] memory currentTurns = games[i + 1];
            uint256 highestRed;
            uint256 highestGreen;
            uint256 highestBlue;
            for (uint256 j; j < currentTurns.length; ++j) {
                if (currentTurns[j].red > highestRed) highestRed = currentTurns[j].red;
                if (currentTurns[j].green > highestGreen) highestGreen = currentTurns[j].green;
                if (currentTurns[j].blue > highestBlue) highestBlue = currentTurns[j].blue;
            }

            // multiply highest red, green, blue, add to total
            total += (highestRed * highestGreen * highestBlue);
        }

        // answer!
        console2.logUint(total);
    }

    function _populateArrays() internal {
        string memory input = vm.readFile("./input/02");
        
        strings.slice memory inputSlice = input.toSlice();
        strings.slice memory delim = string("\n").toSlice();
        
        string[] memory inputParts = new string[](strings.count(inputSlice, delim));
        for (uint256 i; i < inputParts.length; ++i) {
            strings.slice memory currentSlice = strings.split(inputSlice, delim);
            strings.slice memory stripHeaderDelim = string(":").toSlice();
            strings.split(currentSlice, stripHeaderDelim); // strip headers from currentSlice

            inputGames.push(strings.toString(currentSlice)); // push to storage
        }
    }

    function _stringToInteger(string memory _num) internal returns (uint256) {
        // parse integer from string
        bytes memory bResult = bytes(_num);
        uint256 integer;
        for (uint256 i; i < bResult.length; ++i) {
            integer *= 10;
            integer += uint8(bResult[i]) - 48; // subtract 48 because ascii value for '0' == 48
        }

        return integer;
    }

    function _populateGames() internal {
        // loop over each line ("Game: x" headers discarded)
        for (uint256 i; i < inputGames.length; ++i) {
            strings.slice memory currentGame = inputGames[i].toSlice();
            strings.slice memory turnsDelim = string(";").toSlice();
            Turn[] memory currentTurns = new Turn[](strings.count(currentGame, turnsDelim) + 1);

            // create array of Turns for each game
            for (uint256 j; j < currentTurns.length; ++j) {
                strings.slice memory currentTurnsSlice = strings.split(currentGame, turnsDelim);
                strings.slice memory valuesDelim = string(",").toSlice();
                
                // create array of colors for each turn; we are interested in 3 colors always
                strings.slice[] memory colorValues = new strings.slice[](3);
                Turn memory currentTurn;
                for (uint256 k; k < colorValues.length; ++k) {
                    strings.slice memory currentColorValue = strings.split(currentTurnsSlice, valuesDelim);
                    colorValues[k] = currentColorValue;
                    if (bytes(strings.toString(colorValues[k])).length == 0) continue;

                    // chop value into (number, colorString)
                    strings.slice memory numDelim = string(" ").toSlice();
                    string[] memory numberAndValue = new string[](2);
                    strings.toString(strings.split(currentColorValue, numDelim));
                    numberAndValue[0] = strings.toString(strings.split(currentColorValue, numDelim));
                    numberAndValue[1] = strings.toString(currentColorValue);


                    if (bytes(numberAndValue[1])[0] == 'r') {
                        currentTurn.red = _stringToInteger(numberAndValue[0]);
                    } else if (bytes(numberAndValue[1])[0] == 'g') {
                        currentTurn.green = _stringToInteger(numberAndValue[0]);
                    } else if (bytes(numberAndValue[1])[0] == 'b') {
                        currentTurn.blue = _stringToInteger(numberAndValue[0]);
                    }
                }
                currentTurns[j] = currentTurn;
            }

            // populate games mapping, starting from key 1 to match game IDs
            for (uint256 l; l < currentTurns.length; ++l) {
                games[i + 1].push(currentTurns[l]);
            }
        }
    }
}
