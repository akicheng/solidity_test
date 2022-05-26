// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
  //function decimals() external view returns (uint8);
  //function description() external view returns (string memory);
  //function version() external view returns (uint256);

contract FundMe {
    mapping (address => uint256) public addressToAmountFunded;
    address[] public addressIndex;
    address public owner;

   constructor() {
       owner=msg.sender;
   }

    function fund() payable public{
        uint256  minUSD=1 * 10 **18; //unit wei
        require(getEth2Usd(msg.value) > minUSD, "You need to spend more Eth(wei)");
        addressIndex.push(msg.sender);
        addressToAmountFunded[msg.sender] +=msg.value;
    }

    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer, , ,)= priceFeed.latestRoundData();
        return uint256(answer * 10**10); //wei unit
    }

    function getEth2Usd(uint256 ethAmount) public view returns (uint256){
        uint256 curPrice = getPrice();
        return (ethAmount * curPrice / (10**18)); //ethAmoun unit=wei
    }

    modifier OnlyOwner{
        require(msg.sender == owner, "You have no permission!");
        _;
    }
    
    function withdraw() payable OnlyOwner public {
        //addressToAmountFunded[msg.sender] -=address(this).balance;
        for(uint i=0 ; i<addressIndex.length; i++)
        { 
            addressToAmountFunded[addressIndex[i]] =0;
        }
        payable(msg.sender).transfer(address(this).balance);
    }



    function getBalance()   public view returns (uint256){
        return (address(this).balance);
    }
    function getFundNum() public view returns (uint256){
        return addressIndex.length;
    }
}
