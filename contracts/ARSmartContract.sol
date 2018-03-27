pragma solidity ^0.4.18;

//import 'github.com/OpenZeppelin/zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol';
//import 'github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';
//import 'github.com/OpenZeppelin/zeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol';

import 'zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol';
import 'zeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol';
import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import './SimpleARGOTokenCoin.sol';

contract ARSmartContract is RefundableCrowdsale {

    mapping(address => uint) public balances;

    using SafeMath for uint;
    uint public _openingTime = 1567535400;
    uint256 public _closingTime =1567517400;
    uint256 _rate = ((uint)(1 ether)/16000000000000);
    enum CrowdsaleStage { Disabled, PreICO, ICO }
    CrowdsaleStage public _stage = CrowdsaleStage.PreICO;
    uint public _cap =   3 * 1 ether ;//3 ether
    uint public _goal = 10 * 1 ether ;//10 ether
    address _wallet =0xD62Eb006845962D6D2EC8Cbe40c1E161B1bc610B;//multysig wallet for storing
    bool public initialized = false;
    MintableToken token = SimpleARGOTokenCoin(0x4a8caEF31B99632f30eBE7310dB1c2e3c54c2FEe);//0x4a8caEF31B99632f30eBE7310dB1c2e3c54c2FEe address for ARGO Coin Token
    enum CrowdsaleStage { PreICO, ICO }
    CrowdsaleStage public stage = CrowdsaleStage.PreICO;

    // ARGO Token Distribution
    // =============================
    uint256 public maxTokens = 586200000; // There will be total 586,2 mln  Tokens
    uint256 public tokensForEcosystem = 11500000;//11,5 mln –promotional reserves to early users and investors;
    uint256 public tokensForTeam = 91900000;//91,9 mln for the team
    uint256 public tokensForBounty = 57500000; // 57,5 mln
    uint256 public totalTokensForSale = 402300000; // 402,300,000 will be sold in Crowdsale
    uint256 public totalTokensForSaleDuringPreICO = 33200000; // 33,200,000 out of 586,2 mln ARGO will be sold during PreICO
    // ==============================
    function ARSmartContract()
        RefundableCrowdsale(_goal)
        TimedCrowdsale(_openingTime, _closingTime)
        Crowdsale(_rate, _wallet, token) public
    {
        setCrowdsaleStage(CrowdsaleStage.PreICO);
        initialized = true;
        isFinalized = false;
    }

     // Change Crowdsale Stage. Available : PreICO, ICO
    function setCrowdsaleStage(CrowdsaleStage _stage) public onlyOwner {

        stage = _stage;
        if (stage == CrowdsaleStage.PreICO) {
            _rate = ((uint256)(1 ether)/16000000000000);
        } else if (stage == CrowdsaleStage.ICO) {
            _rate = ((uint256)(1 ether)/23000000000000);
        }
    }

    function _getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
        uint256 tokensThatWillBeMintedAfterPurchase = _rate.mul(weiAmount);
        uint bonusTokens = 0;

            if(now <= _openingTime + (2 hours)) {
                bonusTokens = tokensThatWillBeMintedAfterPurchase.div(100).mul(50);
            } else if(now >= _openingTime + 3 hours && now < _openingTime + 4 hours) {
                bonusTokens = tokensThatWillBeMintedAfterPurchase.div(100).mul(40);
            } else if(now >= _openingTime + 5 hours && now < _openingTime + 6 hours) {
                bonusTokens = tokensThatWillBeMintedAfterPurchase.div(100).mul(30);
            } else if(now >= _openingTime + 7 hours && now < _openingTime + 8 hours) {
                bonusTokens = tokensThatWillBeMintedAfterPurchase.div(100).mul(20);
            }
        return tokensThatWillBeMintedAfterPurchase.add(bonusTokens);
    }

    function finalization() internal {
        super.finalization();
    }

}