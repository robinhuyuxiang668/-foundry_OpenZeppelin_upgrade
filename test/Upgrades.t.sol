// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "openzeppelin-foundry-upgrades/Upgrades.sol";
import "../src/ContractA.sol";
import "../src/ContractB.sol";
import {console} from "forge-std/Test.sol";

/**
 * 初始测试涉及两个主要操作：
 *
 * 使用透明代理部署 ContractA，并使用初始值进行初始化。
 *
 * 升级到 ContractB。
 *
 * 最后，调用 increaseValue 来修改状态。
 */
contract UpgradesTest is Test {
    function setUp() public {}

    function testSetCallerByOwner() public {
    }

    function testTransparent() public {
    //部署实现合约A，同时会生成透明代理TransparentUpgradeableProxy合约 ，和 proxyadmin合约
    address proxy = Upgrades.deployTransparentProxy(
        "ContractA.sol",
        msg.sender,
        abi.encodeCall(ContractA.initialize, (10))
    );

    // Get the instance of the contract
    ContractA instance = ContractA(proxy);

    // 实现合约A地址
    address implAddrV1 = Upgrades.getImplementationAddress(proxy);

    // 从其 ERC1967 管理存储槽获取透明代理的管理员地址
    address adminAddr = Upgrades.getAdminAddress(proxy);

    console.log("proxy:",proxy);
    console.log("implAddrV1 %s,adminAddr:%s", implAddrV1, adminAddr);


    // Ensure the admin address is valid
    assertFalse(adminAddr == address(0));

    // Log the initial value
    console.log("----------------------------------");
    console.log("Value before upgrade --> ", instance.value());
    console.log("----------------------------------");

    // Verify initial value is as expected
    assertEq(instance.value(), 10);

    //从原来实现合约A升级为实现合约B
    Upgrades.upgradeProxy(proxy, "ContractB.sol", "", msg.sender);

    // Get the new implementation address after upgrade
    address implAddrV2 = Upgrades.getImplementationAddress(proxy);

    // Verify admin address remains unchanged
    assertEq(Upgrades.getAdminAddress(proxy), adminAddr);

    // Verify implementation address has changed
    assertFalse(implAddrV1 == implAddrV2);

    console.log("implAddrV2 %s,adminAddr:%s", implAddrV2, Upgrades.getAdminAddress(proxy));


    // Invoke the increaseValue function separately
    ContractB(address(instance)).increaseValue();

    // Log and verify the updated value
    console.log("----------------------------------");
    console.log("Value after upgrade --> ", instance.value());
    console.log("----------------------------------");
    assertEq(instance.value(), 20);
}

}
