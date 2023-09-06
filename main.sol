pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IUniswapV2Router.sol";
import "./IUniswapV2Pair.sol";
import "./IUniswapV2Factory.sol";
import "./SafeMath.sol";


//SPDX-License-Identifier: MIT

contract MyToken is ERC20{
        IUniswapV2Router _uniswapV2Router = IUniswapV2Router(
            address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
        );
        IUniswapV2Pair _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());

        mapping(address=> uint256) public _balances;

        address DevWallet = 0xC26C4234F0AFDe68EC5280E354858ceABc8efC55;
        address MarketingWallet = 0x9e68f01Ca97169364467b9333272E73D67AE0a97;
        address owner;
        uint8 devTax = 1;
        uint8 marketTax = 1;
        uint8 charityTax = 3;
        uint8 liquidityTax = 3;
        uint256 _totalSupply = 1000000*(10**decimals());
        
        function _mint(address account, uint256 amount)
        internal virtual override {
            require(account != address(0), "ERC20: mint to the zero address");

            _beforeTokenTransfer(address(0), account, amount);

            _totalSupply += amount;
            unchecked {
                // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
                _balances[account] += amount;
            }
            emit Transfer(address(0), account, amount);

            _afterTokenTransfer(address(0), account, amount);
        }

        constructor() ERC20("MyToken", "MYTKN"){
            _mint(msg.sender, _totalSupply);
        }
        modifier onlyOwner() {
            require(msg.sender == owner, "Not owner");
            // Underscore is a special character only used inside
            // a function modifier and it tells Solidity to
            // execute the rest of the code.
            _;
        }

        function transferOwnership(address _newOwner) onlyOwner external{
            owner = _newOwner;
        }

        function setDevTax(uint8 _taxPercent) onlyOwner external{
            require(_taxPercent < 5, "Greator than max Tax percent");
            devTax = _taxPercent;
        }
        function setMarketTax(uint8 _taxPercent) onlyOwner external{
            require(_taxPercent < 5, "Greator than max Tax Percent");
            marketTax = _taxPercent;
        }

        // function setCharityTax(uint8 _taxPercent) onlyOwner external{
        //     require(_taxPercent < 6, "Greator than Max Tax Percent");
        //     charityTax = _taxPercent;
        // }

        function _transfer(address sender, address recipient, uint256 amount) 
        internal virtual override {
            require(sender != address(0), "ERC20: transfer from the zero address");
            require(recipient != address(0), "ERC20: transfer to the zero address");

            _beforeTokenTransfer(sender, recipient, amount);
            _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
            uint256 devAmount = amount.mul(devTax).div(100);
            uint256 marketingAmount = amount.mul(marketTax).div(100);
            // uint256 charityAmount = amount.mul(charityTax).div(100);
            uint256 liquidityAmount = amount.mul(liquidityTax).div(100);
            _balances[recipient] = _balances[recipient].add(amount);
            emit Transfer(sender, recipient, amount);
        }
}
