// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;
import {ProjectLibrary} from './ProjectLibrary.sol';

error NotAuthorized();

contract Fundme{
    using ProjectLibrary for uint256;
    uint256 public constant MIN_USD = 5e18;
    address[]  public funders;
    mapping(address=>uint256) public addressToCrypto;
    address public immutable i_owner;
    
    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable{
        require(msg.value.getUsdPrice()>=MIN_USD,"Not enough token sent by you");
        funders.push(msg.sender);
        addressToCrypto[msg.sender]= addressToCrypto[msg.sender] + msg.value;
    } 
    
    function withdraw() public only_owner{
        for(uint256 funderIndex=0;funderIndex<funders.length;funderIndex++){
            address funder = funders[funderIndex];
            addressToCrypto[funder] = 0;
        }
        funders = new address[](0);
        (bool callSuccess,) = payable(msg.sender).call{value:address(this).balance}("");
        require(callSuccess,"Withdrawal failed");
    }

    modifier only_owner(){
        // require(msg.sender==i_owner,"Unauthorized access");
        if(msg.sender!=i_owner){
           revert NotAuthorized();
        }
        _;
    }
    receive() external payable {
        fund();
     }
     fallback() external payable { 
        fund();
     }
}