// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library ProjectLibrary{
     function getEthPrice() internal view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int answer,,,) = priceFeed.latestRoundData();
        return uint256(answer*1e10);
    }
    function getUsdPrice(uint256 price) internal view returns(uint256){
        uint256 ethPrice = getEthPrice();
        return (price*ethPrice)/1e18;
    }
}