// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WordToken is ERC20, Ownable {
    constructor(address owner) ERC20("Word", "WORD") Ownable(owner) {}
    
    function mintWords(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burnWords(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}
