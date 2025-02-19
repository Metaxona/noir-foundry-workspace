// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import {UltraVerifier} from "../circuits/target/AVerifier.sol";
import "../contract/Starter.sol";

contract VerifyScript is Script {
    Starter public starter;
    UltraVerifier public verifier;

    function setUp() public {}

    function run() public returns (bool) {
        uint256 deployerPrivateKey = vm.envUint("LOCALHOST_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        verifier = new UltraVerifier();
        starter = new Starter(address(verifier));

        string memory proof = vm.readLine("./circuits/target/a_proof");
        bytes memory proofBytes = vm.parseBytes(proof);

        bytes32[] memory correct = new bytes32[](2);
        correct[0] = bytes32(0x0000000000000000000000000000000000000000000000000000000000000003);
        correct[1] = correct[0];

        bool equal = starter.verifyEqual(proofBytes, correct);
        return equal;
    }
}
