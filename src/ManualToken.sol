// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

contract ManualToken {
    mapping(address => uint) private s_balances;

    function name() public pure returns (string memory) {
        return "Manual Token";
    }

    function totalSupply() public pure returns (uint) {
        return 100 ether;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint balance) {
        return s_balances[_owner];
    }

    function transfer(address _to, uint _amount) public {
        uint previousBalance = balanceOf(msg.sender) + balanceOf(_to);
        s_balances[msg.sender] -= _amount;
        s_balances[_to] += _amount;
        require(balanceOf(msg.sender) + balanceOf(_to) == previousBalance);
    }
}
