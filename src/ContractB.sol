// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

//使用 @custom:oz-upgrades-from ContractA 注释，我们指定 ContractB 是 ContractA 的升级版本
/// @custom:oz-upgrades-from ContractA
contract ContractB is Initializable {
    uint256 public value;

  /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }
    
    function initialize(uint256 _setValue) public initializer {
        value = _setValue;
    }

    function increaseValue() public {
        value += 10;
    }
}
