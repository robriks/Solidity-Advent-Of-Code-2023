// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

contract Script01 is Script {

    function run() public {
        // vm.broadcast();
        string memory a = vm.readFile("./input/01");
        console2.logBytes(bytes(a));
    }
}
