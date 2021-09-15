//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract USDTBroker is Ownable {

    IERC20 internal usdt_;
    bool internal active_;
    bool internal init_;

    
    // -------------------------------------------------------------------------
    // Events
    // -------------------------------------------------------------------------

    event mintTokens(
        address indexed buyer,      // The address of the buyer
        uint256 amount,             // The amount of bonded tokens to mint
        uint256 pricePaid,          // The price in collateral tokens 
        uint256 maxSpend            // The max amount of collateral to spend
    );

    // -------------------------------------------------------------------------
    // Modifiers
    // -------------------------------------------------------------------------

/**
      * @notice Requires the curve to be initialised and active.
      */
    modifier isActive() {
        require(active_ && init_, "Curve inactive");
        _;
    }

    /**
      * @notice Protects against re-entrancy attacks
      */
    modifier mutex() {
        require(status_ != _ENTERED, "ReentrancyGuard: reentrant call");
        // Any calls to nonReentrant after this point will fail
        status_ = _ENTERED;
        // Function executes
        _;
        // Status set to not entered
        status_ = _NOT_ENTERED;
    }

    // -------------------------------------------------------------------------
    // Constructor
    // -------------------------------------------------------------------------


    constructor(address _collateralToken) public Ownable() {
        usdt_ = IERC20(_collateralToken);
    }
    

    // -------------------------------------------------------------------------
    // View functions
    // -------------------------------------------------------------------------

    function greet() public view returns (string memory) {
        return greeting;
    }

    // -------------------------------------------------------------------------
    // State modifying functions
    // -------------------------------------------------------------------------

    function swapUsdt(uint256 amount, address receiver, int `) public {
        usdt_.transferFrom(msg.sender, address(this), amount);
    }

    function init(uint256 startingCollateral) external {
    
        require(
            usdt_.transferFrom(msg.sender, address(this), startingCollateral),
            "Failed to collateralized the broker"
        );
        active_ = true;
        init_ = true;
    }

}
