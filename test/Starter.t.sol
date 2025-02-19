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
        noirHelper.withInput("x", 1).withInput("y", 1);
        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_verifyProof", 2);
        startera.verifyEqual(proof, publicInputs);
        starterb.verifyEqual(proof, publicInputs);
    }

    function test_wrongProof() public {
        noirHelper.clean();
        noirHelper.withInput("x", 1).withInput("y", 5);
        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_wrongProof", 2);
        vm.expectRevert();
        startera.verifyEqual(proof, publicInputs);
        starterb.verifyEqual(proof, publicInputs);
    }

    // function test_all() public {
    //     // forge runs tests in parallel which messes with the read/writes to the proof file
    //     // Run tests in wrapper to force them run sequentially
    //     verifyProof();
    //     wrongProof();
    // }

}
