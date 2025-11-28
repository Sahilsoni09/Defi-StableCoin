// SPDX-License-Identifier: MIT

// Layout of Contract:
// version
// imports
// interfaces, libraries, contracts
// errors
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

pragma solidity ^0.8.20;

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzepplin/contracts/security/ReentrancyGuard.sol";
import {IERC20} from "@openzepplin/contracts/token/ERC20/IERC20.sol";

/*
* @title DSCEngine
* @author Sahil Soni
* 
* This system is designed to be as minimal as possible, and have the token maintain a 1 token == $1 peg
* This stablecoin has the properties:
* -Exogenous Collateral
* -Dollar Pegged
* -Algorithmically Stable
* 
* it is similar to DAI if DAI had no governance, no fees, and was only backed by WETH and WBTC
*
* our DSC system should always be "overcollateralized". At no point, should the value of all collateral <= the $ backed value of all the DSC
*
* @notice This contract is the core of the DSC sytem. it handles all the logic for mining and redeeming DSC, as well as depositing and withdrawing collateral.
* @notice This contract is very loosely based on the MakerDAO DSS (DAI Stablecoin System)
*/

contract DSCEngine is ReentrancyGuard {
    /////////////
    /// Errors //
    /////////////

    error DSCEngine__NeedsMoreThanZero();
    error DSCEngine__TokenAddressesAndPriceFeedAddressMustBeOfSameLength();
    error DSCEngine__NotAllowedToken();
    error DSCEngine__TransferFailed();

    /////////////////////
    /// State Variable //
    /////////////////////

    mapping(address token => address priceFeed) private s_priceFeeds;
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;

    DecentralizedStableCoin private immutable i_dsc;

    ///////////////
    /// Events /// 
    ///////////////
    event CollateralDeposited(address indexed user, address indexed token, uint256 indexed amount);

    ////////////////
    /// Modifiers //
    ////////////////

    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert DSCEngine__NeedsMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address tokenAddress) {
        if (s_priceFeeds[tokenAddress] == address(0)) {
            revert DSCEngine__NotAllowedToken();
        }
        _;
    }

    ////////////////
    /// Functions //
    ////////////////

    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        // USD price feed
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__TokenAddressesAndPriceFeedAddressMustBeOfSameLength();
        }
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
        }

        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    /////////////////////////
    /// External Functions //
    /////////////////////////

    function depositCollateralAndMintDSC() external {}

    /**
     *  @param The address of the token to deposit as collateral
     *  @param amountCollateral The amount of collateral to deposit
     */
    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        external
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
        emit CollateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);

        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);

        if(!success) {
            revert DSCEngine__TransferFailed();
        }
    }

    function redeemCollateralForDSC() external {}

    function redeemCollateral() external {}

    function mintDSC() external {}

    function burnDSC() external {}

    function liquidate() external {}

    function getHealthFactor() external view returns (uint256) {}
}
