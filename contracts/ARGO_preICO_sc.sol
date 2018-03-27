pragma solidity ^0.4.18;
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

// File: zeppelin-solidity/contracts/math/SafeMath.sol

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

// File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

// File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  uint256 totalSupply_;

  /**
  * @dev total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

}

// File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

// File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
contract MintableToken is StandardToken, Ownable {
  event Mint(address indexed to, uint256 amount);
  event MintFinished();

  bool public mintingFinished = false;


  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    emit Mint(_to, _amount);
    emit Transfer(address(0), _to, _amount);
    return true;
  }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() onlyOwner canMint public returns (bool) {
    mintingFinished = true;
    emit MintFinished();
    return true;
  }
}


// File: contracts/SimpleARGOTokenCoin.sol

contract SimpleARGOTokenCoin is MintableToken {

    string public constant name = "ARGO_Utility_Token";
    string public constant symbol = "ARGO";
    uint32 public constant decimals = 0;
    uint256 public INITIAL_SUPPLY = 586200000;
   
    function SimpleToken() public {
         totalSupply_ = INITIAL_SUPPLY;
         balances[msg.sender] = INITIAL_SUPPLY;
        emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
    }

}


contract ArgoshCrowdsale is Ownable {
    
    using SafeMath for uint;
    
    address public multisig;
 
    SimpleARGOTokenCoin public token = new SimpleARGOTokenCoin();
 
    uint public openingTime;

    uint public closingTime;

    uint public period;
 
    uint public hardcap;
 
    uint public softcap;

    uint public amountRaised;

    uint public rate;

    bool public fundingGoalReached;

    bool crowdsaleClosed = false;

    // ARGO Token Distribution
    // =============================
    uint256 public maxTokens = 586200000; // There will be total 586,2 mln  Tokens
    uint256 public tokensForEcosystem = 11500000;//11,5 mln –promotional reserves to early users and investors;
    uint256 public tokensForTeam = 91900000;//91,9 mln for the team
    uint256 public tokensForBounty = 57500000; // 57,5 mln
    uint256 public totalTokensForSale = 402300000; // 402,300,000 will be sold in Crowdsale
    uint256 public totalTokensForSaleDuringPreICO = 33200000; // 33,200,000 out of 586,2 mln ARGO will be sold during PreICO
    
    // Amount raised in PreICO
    // ==================
    uint256 public totalWeiRaisedDuringPreICO;

    enum CrowdsaleStage { Disabled, PreICO, CompletePreICO, ICO, Enabled, Migration }

    CrowdsaleStage   public stage = CrowdsaleStage.Disabled;

    mapping(address => uint) public balances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event NewState(CrowdsaleStage stage);

    modifier enabledState {
        require(stage == CrowdsaleStage.Enabled);
        _;
    }

    modifier enabledOrMigrationState {
        require(stage == CrowdsaleStage.Enabled || stage == CrowdsaleStage.Migration);
        _;
    }

    modifier ongoingICO{
        require(stage == CrowdsaleStage.PreICO || stage == CrowdsaleStage.ICO);
        _;
    }

    // Change Crowdsale Stage. Available : PreICO, ICO
    function setCrowdsaleStage(CrowdsaleStage _stage) public onlyOwner {

        stage = _stage;
        if (stage == CrowdsaleStage.PreICO) {
            setCurrentRate((uint256)(1 ether)/16000000000000);
        } else if (stage == CrowdsaleStage.ICO) {
            setCurrentRate((uint256)(1 ether)/23000000000000);
        }
    }

        // Change the current rate
    function setCurrentRate(uint256 _rate) private {
        rate = _rate;
    }

    function setStartDate(uint256 _startDate) private {
        openingTime = _startDate;
    }

    function setStartDate(uint256 _startDate) private {
        openingTime = _startDate;
    }

    function setPeriod (uint256 _period) private {
        period = _period;
    }

    function ArgoshCrowdsale() public{
      multisig = 0x202e4EA2995CE4d25BB7f5ca06C1B67de614617c;//multisig wallet address 
      
      openingTime = block.timestamp + 200; //PreICO start March26,2018 00:00:00
      closingTime = 1523836800;//PreICO ends at Human time (GMT): Monday, April 16, 2018 12:00:00 AM
      period = (closingTime - openingTime ) / 1 days;//amount of days

      hardcap = 531 * 1 ether;//531 ether
      softcap = 531 * 1 ether;//531 ether

      setCrowdsaleStage(CrowdsaleStage.PreICO);
    }
 
    modifier saleIsOn() {
      require(now >= openingTime && now <= closingTime);
      require(stage == CrowdsaleStage.PreICO || stage == CrowdsaleStage.ICO);

      _;
    }
	
    modifier isUnderHardCap() {
      require(multisig.balance <= hardcap);
      _;
    }

    /**
   * Check if goal was reached
   *
   * Checks if the goal or time limit has been reached and ends the campaign
   */
    modifier afterDeadline() {
        if (now >= closingTime)
        _;
    }

    function refund() public afterDeadline {
        address myAddress = this;
        
      require((myAddress.balance) < softcap);
      uint value = balances[msg.sender]; 
      balances[msg.sender] = 0; 
      msg.sender.transfer(value); 
    }
 
    function finishMinting(address _teamFund, address _ecosystemFund, address _bountyFund) public onlyOwner {
      address myAddress = this;
        
      if((myAddress.balance) > softcap) {
        multisig.transfer(myAddress.balance);

        token.transfer(_teamFund,tokensForTeam);
        token.transfer(_ecosystemFund,tokensForEcosystem);
        token.transfer(_bountyFund,tokensForBounty);
        fundingGoalReached = true;
        crowdsaleClosed = true;
      }
    }

    function _getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
        uint256 tokensThatWillBeMintedAfterPurchase = rate.mul(weiAmount).div(1 ether);
        uint bonusTokens = 0;
        if (stage == CrowdsaleStage.PreICO) {

            if(now < openingTime + (3 days)) {
                bonusTokens = tokensThatWillBeMintedAfterPurchase.div(100).mul(50);
            } else if(now >= openingTime + 3 days && now < openingTime + 4 days) {
                bonusTokens = tokensThatWillBeMintedAfterPurchase.div(100).mul(40);
            } else if(now >= openingTime + 4 days && now < openingTime + 5 days) {
                bonusTokens = tokensThatWillBeMintedAfterPurchase.div(100).mul(30);
            } else if(now >= openingTime + 5 days && now < openingTime + 6 days) {
                bonusTokens = tokensThatWillBeMintedAfterPurchase.div(100).mul(20);
            }
        }
        return tokensThatWillBeMintedAfterPurchase.add(bonusTokens);
    }

   function createTokens() isUnderHardCap saleIsOn payable public{
      
      uint256 tokens = _getTokenAmount(msg.value);
      
      totalWeiRaisedDuringPreICO = totalWeiRaisedDuringPreICO.add(msg.value);
      token.mint(msg.sender, tokens);
      balances[msg.sender] = balances[msg.sender].add(msg.value);
      
      balances[this] -= tokens;
      emit Transfer(this, msg.sender, tokens);
    }
 
    function() external payable {
      createTokens();
    }
    
}


