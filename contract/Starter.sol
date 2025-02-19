// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {UltraVerifier} from "../circuits/target/AVerifier.sol";

contract Starter {
    UltraVerifier public verifier;

    constructor(address _verifier) {
        verifier = UltraVerifier(_verifier);
    }

    function verifyEqual(bytes calldata proof, bytes32[] calldata y) public view returns (bool) {
        bool proofResult = verifier.verify(proof, y);
        require(proofResult, "Proof is not valid");
        return proofResult;
    }
}
