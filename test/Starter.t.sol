// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../contract/Starter.sol";
import {UltraVerifier as AVerifier } from "../circuits/target/AVerifier.sol";
import {UltraVerifier as BVerifier} from "../circuits/target/BVerifier.sol";
import {Test, console2} from "forge-std/Test.sol";
import {NoirHelper} from "foundry-noir-helper/NoirHelper.sol";


contract StarterTest is Test {
    Starter public startera;
    Starter public starterb;
    AVerifier public averifier;
    BVerifier public bverifier;
    NoirHelper public noirHelper;

    function setUp() public {
        noirHelper = new NoirHelper();
        averifier = new AVerifier();
        bverifier = new BVerifier();
        startera = new Starter(address(averifier));
        starterb = new Starter(address(bverifier));
    }

    function test_verifyProof() public {
        // starter a and starter b are verifiers for different circuits.
        // a
        noirHelper
            .withInput("x", 1)
            .withInput("y", 1)
            .withProjectPath("circuits/a")
            .withProofOutputPath("circuits/target/");
        // num of public inputs to circuit is 1.
        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_verifyProof", 1);
        startera.verifyEqual(proof, publicInputs);

        // b
        noirHelper
            .withInput("x", 1)
            .withInput("y", 1)
            .withProjectPath("circuits/b");
        // num of public inputs to circuit is 1.
        (publicInputs, proof) = noirHelper.generateProof("test_verifyProof", 1);
        starterb.verifyEqual(proof, publicInputs);
    }

    function test_wrongProof() public {
        // a
        noirHelper
            .withInput("x", 1)
            .withInput("y", 5)
            .withProjectPath("circuits/a")
            .withProofOutputPath("circuits/target/");
        
        // for failed constraints NoirHelper emits `FailedConstraintWithError()`. 
        vm.expectEmit(true, true, true, true);
        emit NoirHelper.FailedConstraintWithError();
        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_wrongProof", 1);

        // Somewhat unintuitively, this will always revert with `PUBLIC_INPUT_COUNT_INVALID` because Noir
        // does not generate invalid proofs. Additionally, `NoirHelper` returns an empty `bytes` string
        // for proofs and an empty `bytes32[]` for `publicInputs` if any constraints fail. same for b.
        vm.expectRevert();
        startera.verifyEqual(proof, publicInputs);

        // b
        noirHelper
            .withInput("x", 1)
            .withInput("y", 5)
            .withProjectPath("circuits/b");

        // for failed constraints NoirHelper emits `FailedConstraintWithError()`.
        vm.expectEmit(true, true, true, true);
        emit NoirHelper.FailedConstraintWithError();
        (publicInputs, proof) = noirHelper.generateProof("test_wrongProof", 1);

        vm.expectRevert();
        starterb.verifyEqual(proof, publicInputs);
    }
}