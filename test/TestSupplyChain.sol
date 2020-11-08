pragma solidity ^0.6.12;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SupplyChain.sol";
import "../contracts/UserProxy.sol";

contract TestSupplyChain {

    // Test for failing conditions in this contracts:
    // https://truffleframework.com/tutorials/testing-for-throws-in-solidity-tests

    UserProxy buyer;
    UserProxy seller;
    SupplyChain supplychain;
    uint public initialBalance = 1 gwei;

    function beforeEach() public {
        //supplychain = SupplyChain(DeployedAddresses.SupplyChain());
        supplychain = new SupplyChain();
        buyer = new UserProxy(address(supplychain));
        address(buyer).transfer(1000);
        seller = new UserProxy(address(supplychain));
        address(seller).transfer(1000);

    }

    // buyItem
    // test for failure if user does not send enough funds
    function testUserDoesNotSendEnoughFunds() public {
        seller.placeItemForSale("Book", 100);
        Assert.isFalse(buyer.purchaseItem(0, 50), "user does not send enough funds");
    }


    // test for purchasing an item that is not for Sale
    function testItemisNotForSale() public {
        seller.placeItemForSale("Book", 100);
        buyer.purchaseItem(0, 100);
        Assert.isFalse(buyer.purchaseItem(0, 100), "purchasing an item that is not for Sale");
    }

    // shipItem

    // test for calls that are made by not the seller
    function testOnlySellrCanShipItem() public {
        seller.placeItemForSale("Book", 100);
        buyer.purchaseItem(0, 100);
        Assert.isFalse(buyer.shipItem(0), "only seller Can ship item");
    }

    // test for trying to ship an item that is not marked Sold
    function testItemThatIsNotMarkedSold() public {
        seller.placeItemForSale("Book", 1000);
        Assert.isFalse(seller.shipItem(0), "trying to ship an item that is not marked Sold");
    }

    // receiveItem
    
    // test calling the function from an address that is not the buyer
    function testOnlyBuyerCanReceiveItem() public {
        seller.placeItemForSale("Book", 1000);
        buyer.purchaseItem(0, 1000);
        seller.shipItem(0);
        Assert.isFalse(seller.receiveItem(0), "that is not the buyer");
    }

    // test calling the function on an item not marked Shipped
    function testItemThatIsNotShipped() public {
        seller.placeItemForSale("Book", 1000);
        buyer.purchaseItem(0, 1000);
        Assert.isFalse(buyer.receiveItem(0), "item not marked Shipped");
    }
}
