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


contract DSCEngine {
    function depositCollateralAndMintDSC() external {}

    function depositCollateral() external {}

    function redeemCollateralForDSC() external {}

    function redeemCollateral() external {}

    function mintDSC() external {}

    function burnDSC() external {}

    function liquidate() external {}
    
    function getHealthFactor() external view returns(uint256) {}
}