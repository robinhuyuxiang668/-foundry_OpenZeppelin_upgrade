// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

import {ContractA} from '../src/ContractA.sol';
import {ContractB} from '../src/ContractB.sol';

import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

/**
部署命令行:
forge clean && forge script script/UpgradesScript.s.sol --rpc-url sepolia --private-key $PRIVATE_KEY --broadcast --verify --sender $SENDER

 */
contract UpgradesScript is Script {
	  function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // 部署代理、ProxyAdmin 和 ContractA
        address transparentProxy = Upgrades.deployTransparentProxy(
            "ContractA.sol",
            msg.sender,
            abi.encodeCall(ContractA.initialize, 10)
        );

    }
}