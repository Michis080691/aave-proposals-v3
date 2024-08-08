// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Metis} from 'aave-address-book/AaveV3Metis.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/ProtocolV3TestBase.sol';
import {AaveV3Metis_StaticATokenUpgrade_20240808} from './AaveV3Metis_StaticATokenUpgrade_20240808.sol';

/**
 * @dev Test for AaveV3Metis_StaticATokenUpgrade_20240808
 * command: FOUNDRY_PROFILE=metis forge test --match-path=src/20240808_Multi_StaticATokenUpgrade/AaveV3Metis_StaticATokenUpgrade_20240808.t.sol -vv
 */
contract AaveV3Metis_StaticATokenUpgrade_20240808_Test is ProtocolV3TestBase {
  AaveV3Metis_StaticATokenUpgrade_20240808 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('metis'), 18015405);
    proposal = new AaveV3Metis_StaticATokenUpgrade_20240808();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest('AaveV3Metis_StaticATokenUpgrade_20240808', AaveV3Metis.POOL, address(proposal));
  }
}
