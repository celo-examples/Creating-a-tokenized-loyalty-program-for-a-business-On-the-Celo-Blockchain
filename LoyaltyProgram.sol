// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract LoyaltyProgram is ERC20Capped, Ownable, Pausable {
    mapping(address => bool) private _merchants;
    mapping(address => uint256) private _discounts;

    event DiscountSet(address indexed merchant, uint256 discount);

    constructor(
        string memory name,
        string memory symbol,
        uint256 cap
    ) ERC20(name, symbol) ERC20Capped(cap) {}

    function mint(address recipient, uint256 amount) public onlyOwner {
        require(
            ERC20.totalSupply() + amount <= cap(),
            "ERC20Capped: cap exceeded"
        );
        _mint(recipient, amount);
    }

    function burn(address account, uint256 amount) public onlyOwner {
        _burn(account, amount);
    }

    function addMerchant(address merchant) public onlyOwner {
        _merchants[merchant] = true;
    }

    function removeMerchant(address merchant) public onlyOwner {
        _merchants[merchant] = false;
    }

    function isMerchant(address merchant) public view returns (bool) {
        return _merchants[merchant];
    }

    function setDiscount(address merchant, uint256 discount) public onlyOwner {
        require(_merchants[merchant], "Address is not a merchant");
        _discounts[merchant] = discount;
        emit DiscountSet(merchant, discount);
    }

    function getDiscount(address merchant) public view returns (uint256) {
        require(_merchants[merchant], "Address is not a merchant");
        return _discounts[merchant];
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override whenNotPaused returns (bool) {
        return super.transfer(recipient, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override whenNotPaused returns (bool) {
        return super.transferFrom(sender, recipient, amount);
    }
}
