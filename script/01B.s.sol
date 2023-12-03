// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {strings} from "solidity-stringutils/strings.sol";

contract Script01B is Script {
    using strings for string;

    string[] public inputStrings;
    string[] public reversedStrings;

    string[] public firstDigs;
    string[] public reverseDigs;

    string[] public doubleDigs;

    function run() public {
        _populateArrays();

        // inputStrings and reversedStrings have same length
        for (uint256 l; l < inputStrings.length; ++l) {
            string memory str = inputStrings[l];
            string memory revStr = reversedStrings[l];

            bytes memory b = bytes(str);
            bytes memory revB = bytes(revStr);
            // b and revB have same length- search for first integer in both members at once
            for (uint256 m; m < b.length; ++m) {
                // check for digits
                if (b[m] >= bytes1('0') && b[m] <= bytes1('9')) {
                    firstDigs.push(string(abi.encodePacked(b[m])));
                    break;
                }

                if (b[m] == 'o') {
                    (bool isOne, string memory val) = _checkNamedOne(b, m);
                    if (isOne) {
                        firstDigs.push(val);
                        break;
                    }
                } else if (b[m] == 't') {
                    (bool isTwoOrThree, string memory val) = _checkNamedTwoOrThree(b, m);
                    if (isTwoOrThree) {
                        firstDigs.push(val);
                        break;
                    }
                } else if (b[m] == 'f') {
                    (bool isFourOrFive, string memory val) = _checkNamedFourOrFive(b, m);
                    if (isFourOrFive) {
                        firstDigs.push(val);
                        break;
                    }
                } else if (b[m] == 's') {
                    (bool isSixOrSeven, string memory val) =_checkNamedSixOrSeven(b, m);
                    if (isSixOrSeven) {
                        firstDigs.push(val);
                        break;
                    }
                } else if (b[m] == 'e') {
                    (bool isEight, string memory val) =_checkNamedEight(b, m);
                    if (isEight) {
                        firstDigs.push(val);
                        break;
                    }
                } else if (b[m] == 'n') {
                    (bool isNine, string memory val) =_checkNamedNine(b, m);
                    if (isNine) {
                        firstDigs.push(val);
                        break;
                    }
                }
            }

            // rinse and repeat for reversed words
            for (uint256 n; n < b.length; ++n) {
                // check for digits in reversed strings
                if (revB[n] >= '0' && revB[n] <= '9') {
                    reverseDigs.push(string(abi.encodePacked(revB[n])));
                    break;
                }

                if (revB[n] == 'e') {
                    (bool isEnorEerhtOrEvifOrEnin, string memory val) = _checkNamedEnoOrEerhtOrEvifOrEnin(revB, n);
                    if (isEnorEerhtOrEvifOrEnin) {
                        reverseDigs.push(val);
                        break;
                    }
                } else if (revB[n] == 'o') {
                    (bool isOwt, string memory val) = _checkNamedOwt(revB, n);
                    if (isOwt) {
                        reverseDigs.push(val);
                        break;
                    }
                } else if (revB[n] == 'r') {
                    (bool isRuof, string memory val) = _checkNamedRuof(revB, n);
                    if (isRuof) {
                        reverseDigs.push(val);
                        break;
                    }
                } else if (revB[n] == 'x') {
                    (bool isXis, string memory val) =_checkNamedXis(revB, n);
                    if (isXis) {
                        reverseDigs.push(val);
                        break;
                    }
                } else if (revB[n] == 'n') {
                    (bool isNeves, string memory val) =_checkNamedNeves(revB, n);
                    if (isNeves) {
                        reverseDigs.push(val);
                        break;
                    }
                } else if (revB[n] == 't') {
                    (bool isThgie, string memory val) =_checkNamedThgie(revB, n);
                    if (isThgie) {
                        reverseDigs.push(val);
                        break;
                    }
                }
            }
        }

        uint256 total = _concatenateAndAddArrayMembers();

        // answer!
        console2.logUint(total);
    }

    function _checkNamedOne(bytes memory _bWord, uint256 _index) internal returns (bool, string memory) {
        if (_bWord[_index + 1] == 'n' && _bWord[_index + 2] == 'e') {
            return (true, '1');
        }
    }

    function _checkNamedTwoOrThree(bytes memory _bWord, uint256 _index) internal returns (bool, string memory) {
        if (_bWord[_index + 1] == 'w' && _bWord[_index + 2] == 'o') {
            return (true, '2');
        } else if (_bWord[_index + 1] == 'h' && _bWord[_index + 2] == 'r' && _bWord[_index + 3] == 'e' && _bWord[_index + 4] == 'e') {
            return (true, '3');
        }
    }

    function _checkNamedFourOrFive(bytes memory _bWord, uint256 _index) internal returns (bool, string memory) {
        if (_bWord[_index + 1] == 'o' && _bWord[_index + 2] == 'u' && _bWord[_index + 3] == 'r') {
            return (true, '4');
        } else if (_bWord[_index + 1] == 'i' && _bWord[_index + 2] == 'v' && _bWord[_index + 3] == 'e') {
            return (true, '5');
        }
    }

    function _checkNamedSixOrSeven(bytes memory _bWord, uint256 _index) internal returns (bool, string memory) {
        if (_bWord[_index + 1] == 'i' && _bWord[_index + 2] == 'x') {
            return (true, '6');
        } else if (_bWord[_index + 1] == 'e' && _bWord[_index + 2] == 'v' && _bWord[_index + 3] == 'e' && _bWord[_index + 4] == 'n') {
            return (true, '7');
        }
    }

    function _checkNamedEight(bytes memory _bWord, uint256 _index) internal returns (bool, string memory) {
        if (_bWord[_index + 1] == 'i' && _bWord[_index + 2] == 'g' && _bWord[_index + 3] == 'h' && _bWord[_index + 4] == 't') {
            return (true, '8');
        }
    }

    function _checkNamedNine(bytes memory _bWord, uint256 _index) internal returns (bool, string memory) {
        if (_bWord[_index + 1] == 'i' && _bWord[_index + 2] == 'n' && _bWord[_index + 3] == 'e') {
            return (true, '9');
        }
    }

    function _checkNamedEnoOrEerhtOrEvifOrEnin(bytes memory _bReverseWord, uint256 _index) internal returns (bool, string memory) {
        if (_bReverseWord[_index + 1] == 'n' && _bReverseWord[_index + 2] == 'o') {
            return (true, '1');
        } else if (_bReverseWord[_index + 1] == 'e' && _bReverseWord[_index + 2] == 'r' && _bReverseWord[_index + 3] == 'h' && _bReverseWord[_index + 4] == 't') {
            return (true, '3');
        } else if (_bReverseWord[_index + 1] == 'v' && _bReverseWord[_index + 2] == 'i' && _bReverseWord[_index + 3] == 'f') {
            return (true, '5');
        } else if (_bReverseWord[_index + 1] == 'n' && _bReverseWord[_index + 2] == 'i' && _bReverseWord[_index + 3] == 'n') {
            return (true, '9');
        }
    }

    function _checkNamedOwt(bytes memory _bReverseWord, uint256 _index) internal returns (bool, string memory) {
        if (_bReverseWord[_index + 1] == 'w' && _bReverseWord[_index + 2] == 't') {
            return (true, '2');
        }
    }

    function _checkNamedRuof(bytes memory _bReverseWord, uint256 _index) internal returns (bool, string memory) {
        if (_bReverseWord[_index + 1] == 'u' && _bReverseWord[_index + 2] == 'o' && _bReverseWord[_index + 3] == 'f') {
            return (true, '4');
        }
    }

    function _checkNamedXis(bytes memory _bReverseWord, uint256 _index) internal returns (bool, string memory) {
        if (_bReverseWord[_index + 1] == 'i' && _bReverseWord[_index + 2] == 's') {
            return (true, '6');
        }
    }

    function _checkNamedNeves(bytes memory _bReverseWord, uint256 _index) internal returns (bool, string memory) {
        if (_bReverseWord[_index + 1] == 'e' && _bReverseWord[_index + 2] == 'v' && _bReverseWord[_index + 3] == 'e' && _bReverseWord[_index + 4] == 's') {
            return (true, '7');
        }
    }

    function _checkNamedThgie(bytes memory _bReverseWord, uint256 _index) internal returns (bool, string memory) {
        if (_bReverseWord[_index + 1] == 'h' && _bReverseWord[_index + 2] == 'g' && _bReverseWord[_index + 3] == 'i' && _bReverseWord[_index + 4] == 'e') {
            return (true, '8');
        }
    }


    function _populateArrays() internal {
        // same input as 01A
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
    }

    function _concatenateAndAddArrayMembers() internal returns (uint256) {
        uint256 _total;
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
            _total += integer;
        }

        return _total;
    }
}
