pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract SimpleARGOTokenCoin is StandardToken {

    string public constant name = "ARGO_Utility_Token";
    string public constant symbol = "ARGO";
    uint32 public constant decimals = 0;
    uint256 public INITIAL_SUPPLY = 586200000;

    function SimpleARGOTokenCoin() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
    }

}

