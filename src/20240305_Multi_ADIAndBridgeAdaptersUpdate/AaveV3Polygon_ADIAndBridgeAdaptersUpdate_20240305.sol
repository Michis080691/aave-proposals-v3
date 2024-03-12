// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/interfaces/IProposalGenericExecutor.sol';
import {TransparentUpgradeableProxy} from 'solidity-utils/contracts/transparent-proxy/TransparentUpgradeableProxy.sol';
import {ProxyAdmin} from 'solidity-utils/contracts/transparent-proxy/ProxyAdmin.sol';
import {ChainIds} from 'aave-helpers/ChainIds.sol';
import {MiscPolygon} from 'aave-address-book/MiscPolygon.sol';
import {ICrossChainReceiver, ICrossChainForwarder} from 'aave-address-book/common/ICrossChainController.sol';
import {GovernanceV3Polygon} from 'aave-address-book/GovernanceV3Polygon.sol';

/**
 * @title aDI and bridge adapters update
 * @author BGD Labs @bgdlabs
 * - Snapshot: TODO
 * - Discussion: TODO
 */
contract AaveV3Polygon_ADIAndBridgeAdaptersUpdate_20240305 is IProposalGenericExecutor {
  address public constant CCIP_ADAPTER_TO_REMOVE = 0x95Fa2c817169E26956AB8795c84a225b55d7db5B;
  address public constant LZ_ADAPTER_TO_REMOVE = 0xDA4B6024aA06f7565BBcAaD9B8bE24C3c229AAb5;
  address public constant HL_ADAPTER_TO_REMOVE = 0x3c25b96fF62D21E90556869272a277eE2E229747;
  address public constant POL_ADAPTER_TO_REMOVE = 0xb13712De579E1f9943502FFCf72eab6ec348cF79;
  address public constant CCIP_NEW_ADAPTER = 0xe79757D55a1600eF28D816a893E78E9FCDE2019E;
  address public constant LZ_NEW_ADAPTER = 0x7FAE7765abB4c8f778d57337bB720d0BC53057e3;
  address public constant HL_NEW_ADAPTER = 0x3e72665008dC237bdd91C04C10782Ed1987a4019;
  address public constant POL_NEW_ADAPTER = 0x853649f897383f89d8441346Cf26a9ed02720B02;
  address public constant DESTINATION_CCIP_NEW_ADAPTER = 0xB7a6618df58626C3a122ABAFD6Ee63Af63f3Ef29;
  address public constant DESTINATION_LZ_NEW_ADAPTER = 0x8410d9BD353b420ebA8C48ff1B0518426C280FCC;
  address public constant DESTINATION_HL_NEW_ADAPTER = 0x01dcb90Cf13b82Cde4A0BAcC655585a83Af3cCC1;
  address public constant DESTINATION_POL_NEW_ADAPTER = 0x1562F1b2487F892BBA8Ef325aF054Fd157510a71;
  address public constant NEW_CROSS_CHAIN_CONTROLLER_IMPLEMENTATION =
    0x87a95917DE670088d81B9a8B30E3B36704Ba3043;

  function execute() external {
    // Update CrossChainController implementation
    ProxyAdmin(MiscPolygon.PROXY_ADMIN).upgradeAndCall(
      TransparentUpgradeableProxy(payable(GovernanceV3Polygon.CROSS_CHAIN_CONTROLLER)),
      NEW_CROSS_CHAIN_CONTROLLER_IMPLEMENTATION,
      abi.encodeWithSignature('initializeRevision()')
    );

    // remove old Receiver bridge adapter
    ICrossChainReceiver(GovernanceV3Polygon.CROSS_CHAIN_CONTROLLER).disallowReceiverBridgeAdapters(
      _getReceiverBridgeAdaptersToRemove()
    );

    // remove forwarding adapters
    ICrossChainForwarder(GovernanceV3Polygon.CROSS_CHAIN_CONTROLLER).disableBridgeAdapters(
      _getForwarderBridgeAdaptersToRemove()
    );

    // add receiver adapters
    ICrossChainReceiver(GovernanceV3Polygon.CROSS_CHAIN_CONTROLLER).allowReceiverBridgeAdapters(
      _getReceiverBridgeAdaptersToAllow()
    );

    // add forwarding adapters
    ICrossChainForwarder(GovernanceV3Polygon.CROSS_CHAIN_CONTROLLER).enableBridgeAdapters(
      _getForwarderBridgeAdaptersToEnable()
    );
  }

  function _getReceiverBridgeAdaptersToRemove()
    internal
    pure
    returns (ICrossChainReceiver.ReceiverBridgeAdapterConfigInput[] memory)
  {
    uint256[] memory chainIds = new uint256[](1);
    chainIds[0] = ChainIds.MAINNET;

    // remove old Receiver bridge adapter
    ICrossChainReceiver.ReceiverBridgeAdapterConfigInput[]
      memory bridgeAdaptersToRemove = new ICrossChainReceiver.ReceiverBridgeAdapterConfigInput[](4);

    bridgeAdaptersToRemove[0] = ICrossChainReceiver.ReceiverBridgeAdapterConfigInput({
      bridgeAdapter: CCIP_ADAPTER_TO_REMOVE,
      chainIds: chainIds
    });
    bridgeAdaptersToRemove[1] = ICrossChainReceiver.ReceiverBridgeAdapterConfigInput({
      bridgeAdapter: LZ_ADAPTER_TO_REMOVE,
      chainIds: chainIds
    });
    bridgeAdaptersToRemove[2] = ICrossChainReceiver.ReceiverBridgeAdapterConfigInput({
      bridgeAdapter: HL_ADAPTER_TO_REMOVE,
      chainIds: chainIds
    });
    bridgeAdaptersToRemove[3] = ICrossChainReceiver.ReceiverBridgeAdapterConfigInput({
      bridgeAdapter: POL_ADAPTER_TO_REMOVE,
      chainIds: chainIds
    });

    return bridgeAdaptersToRemove;
  }

  function _getForwarderBridgeAdaptersToRemove()
    internal
    pure
    returns (ICrossChainForwarder.BridgeAdapterToDisable[] memory)
  {
    uint256[] memory chainIds = new uint256[](1);
    chainIds[0] = ChainIds.MAINNET;

    ICrossChainForwarder.BridgeAdapterToDisable[]
      memory forwarderAdaptersToRemove = new ICrossChainForwarder.BridgeAdapterToDisable[](4);

    forwarderAdaptersToRemove[0] = ICrossChainForwarder.BridgeAdapterToDisable({
      bridgeAdapter: CCIP_ADAPTER_TO_REMOVE,
      chainIds: chainIds
    });
    forwarderAdaptersToRemove[1] = ICrossChainForwarder.BridgeAdapterToDisable({
      bridgeAdapter: LZ_ADAPTER_TO_REMOVE,
      chainIds: chainIds
    });
    forwarderAdaptersToRemove[2] = ICrossChainForwarder.BridgeAdapterToDisable({
      bridgeAdapter: HL_ADAPTER_TO_REMOVE,
      chainIds: chainIds
    });
    forwarderAdaptersToRemove[3] = ICrossChainForwarder.BridgeAdapterToDisable({
      bridgeAdapter: POL_ADAPTER_TO_REMOVE,
      chainIds: chainIds
    });

    return forwarderAdaptersToRemove;
  }

  function _getReceiverBridgeAdaptersToAllow()
    internal
    pure
    returns (ICrossChainReceiver.ReceiverBridgeAdapterConfigInput[] memory)
  {
    uint256[] memory chainIds = new uint256[](1);
    chainIds[0] = ChainIds.MAINNET;

    ICrossChainReceiver.ReceiverBridgeAdapterConfigInput[]
      memory bridgeAdapterConfig = new ICrossChainReceiver.ReceiverBridgeAdapterConfigInput[](4);

    bridgeAdapterConfig[0] = ICrossChainReceiver.ReceiverBridgeAdapterConfigInput({
      bridgeAdapter: CCIP_NEW_ADAPTER,
      chainIds: chainIds
    });
    bridgeAdapterConfig[1] = ICrossChainReceiver.ReceiverBridgeAdapterConfigInput({
      bridgeAdapter: LZ_NEW_ADAPTER,
      chainIds: chainIds
    });
    bridgeAdapterConfig[2] = ICrossChainReceiver.ReceiverBridgeAdapterConfigInput({
      bridgeAdapter: HL_NEW_ADAPTER,
      chainIds: chainIds
    });
    bridgeAdapterConfig[3] = ICrossChainReceiver.ReceiverBridgeAdapterConfigInput({
      bridgeAdapter: POL_NEW_ADAPTER,
      chainIds: chainIds
    });

    return bridgeAdapterConfig;
  }

  function _getForwarderBridgeAdaptersToEnable()
    internal
    pure
    returns (ICrossChainForwarder.ForwarderBridgeAdapterConfigInput[] memory)
  {
    ICrossChainForwarder.ForwarderBridgeAdapterConfigInput[]
      memory bridgeAdaptersToEnable = new ICrossChainForwarder.ForwarderBridgeAdapterConfigInput[](
        4
      );

    bridgeAdaptersToEnable[0] = ICrossChainForwarder.ForwarderBridgeAdapterConfigInput({
      currentChainBridgeAdapter: CCIP_NEW_ADAPTER,
      destinationBridgeAdapter: DESTINATION_CCIP_NEW_ADAPTER,
      destinationChainId: ChainIds.MAINNET
    });
    bridgeAdaptersToEnable[1] = ICrossChainForwarder.ForwarderBridgeAdapterConfigInput({
      currentChainBridgeAdapter: LZ_NEW_ADAPTER,
      destinationBridgeAdapter: DESTINATION_LZ_NEW_ADAPTER,
      destinationChainId: ChainIds.MAINNET
    });
    bridgeAdaptersToEnable[2] = ICrossChainForwarder.ForwarderBridgeAdapterConfigInput({
      currentChainBridgeAdapter: HL_NEW_ADAPTER,
      destinationBridgeAdapter: DESTINATION_HL_NEW_ADAPTER,
      destinationChainId: ChainIds.MAINNET
    });
    bridgeAdaptersToEnable[3] = ICrossChainForwarder.ForwarderBridgeAdapterConfigInput({
      currentChainBridgeAdapter: POL_NEW_ADAPTER,
      destinationBridgeAdapter: DESTINATION_POL_NEW_ADAPTER,
      destinationChainId: ChainIds.MAINNET
    });

    return bridgeAdaptersToEnable;
  }
}