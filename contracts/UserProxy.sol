pragma solidity >=0.6.0 <0.7.0;

import "./SupplyChain.sol";

contract UserProxy {

    address supplychain;

    constructor(address _supplychain) public {
        supplychain = _supplychain;
    }

    function placeItemForSale(string memory _item, uint _price) public returns(bool) {
        (bool success, ) = address(supplychain).call(abi.encodeWithSignature("addItem(string,uint256)",_item,_price));
        return success;
    }

    function purchaseItem(uint _sku, uint _offer) public payable returns(bool) {
        (bool success, ) = address(supplychain).call{gas: 1000000, value: _offer}(abi.encodeWithSignature("buyItem(uint256)",_sku));
        return success;
    }

    function shipItem(uint _sku) public returns(bool) {
        (bool success, ) = address(supplychain).call(abi.encodeWithSignature("shipItem(uint256)",_sku));
        return success;
    }

    function receiveItem(uint _sku) public returns(bool) {
        (bool success, ) = address(supplychain).call(abi.encodeWithSignature("receiveItem(uint256)",_sku));
        return success;
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    fallback() external payable {}

    receive() external payable {}

}