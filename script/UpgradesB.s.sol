// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

import {ContractA} from '../src/ContractA.sol';
import {ContractB} from '../src/ContractB.sol';

import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";

/**
实现合约升级为B合约
部署命令行:
forge clean && forge script script/UpgradesScript.s.sol --rpc-url sepolia --private-key $PRIVATE_KEY --broadcast --verify --sender $SENDER

 */
contract UpgradesScript is Script {
	  function setUp() public {}

    function run() public {

    // 指定现有透明代理的地址
    address transparentProxy = 0x0D1bCba65fa795eac14a09Df818D16591e4902a3;

     // 设置验证升级的选项
    Options memory opts;
    opts.referenceContract = "ContractA.sol";

    // 验证升级的兼容性
    Upgrades.validateUpgrade("ContractB.sol", opts);

    // 升级到 ContractB 并尝试增加值
    Upgrades.upgradeProxy(transparentProxy, "ContractB.sol", abi.encodeCall(ContractB.increaseValue, ()));


    }
}


 