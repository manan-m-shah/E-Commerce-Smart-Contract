//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

contract Ecommerce {
    struct Product {
        string title;
        string description;
        uint256 price;
        address payable seller;
        uint256 productId;
        address buyer;
        bool delivered;
    }

    uint256 counter = 0;
    Product[] public products;

    function register(
        string memory _title,
        string memory _description,
        uint256 _price
    ) public {
        require(_price > 0);

        Product memory newProduct;

        newProduct.title = _title;
        newProduct.description = _description;
        newProduct.price = _price * 10**18;
        newProduct.seller = payable(msg.sender);
        newProduct.productId = counter;

        products.push(newProduct);
    }

    function buy(uint256 _productId) public payable {
        require(
            products[_productId].price == msg.value,
            "Incorrect price paid."
        );
        require(
            products[_productId].seller != msg.sender,
            "You either purchase OR sell!"
        );

        products[_productId].buyer = msg.sender;
    }

    function delivered(uint256 _productId) public {
        require(
            products[_productId].buyer == msg.sender,
            "Only buyer can confirm delivery."
        );

        products[_productId].delivered = true;

        products[_productId].seller.transfer(products[_productId].price);
    }
}
