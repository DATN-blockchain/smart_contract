// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    address public owner;

    enum ProductStatus { Created, Purchased, Shipped, Received }

    struct Product {
        uint256 id;
        string name;
        uint256 price;
        ProductStatus status;
        address farmer;
        address distributor;
        address retailer;
        address customer;
    }

    Product[] public products;
    uint256 public productCount = 0;

    event ProductCreated(uint256 indexed id, string name, uint256 price, address indexed farmer);
    event ProductPurchased(uint256 indexed id, address indexed distributor);
    event ProductShipped(uint256 indexed id, address indexed retailer);
    event ProductReceived(uint256 indexed id, address indexed customer);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createProduct(string memory _name, uint256 _price) public {
        Product memory newProduct = Product({
            id: productCount,
            name: _name,
            price: _price,
            status: ProductStatus.Created,
            farmer: msg.sender,
            distributor: address(0),
            retailer: address(0),
            customer: address(0)
        });

        products.push(newProduct);
        productCount++;

        emit ProductCreated(newProduct.id, newProduct.name, newProduct.price, newProduct.farmer);
    }

    function purchaseProduct(uint256 _productId) public payable {
        require(_productId < productCount, "Invalid product ID");
        Product storage product = products[_productId];
        require(product.status == ProductStatus.Created, "Product is not available for purchase");
        require(msg.value >= product.price, "Insufficient funds");

        product.status = ProductStatus.Purchased;
        product.distributor = msg.sender;

        emit ProductPurchased(product.id, product.distributor);
    }

    function shipProduct(uint256 _productId) public {
        require(_productId < productCount, "Invalid product ID");
        Product storage product = products[_productId];
        require(product.status == ProductStatus.Purchased, "Product is not purchased yet");
        require(msg.sender == product.farmer || msg.sender == product.distributor, "Only farmer or distributor can call this function");

        product.status = ProductStatus.Shipped;

        emit ProductShipped(product.id, msg.sender);
    }

    function receiveProduct(uint256 _productId) public {
        require(_productId < productCount, "Invalid product ID");
        Product storage product = products[_productId];
        require(product.status == ProductStatus.Shipped, "Product is not shipped yet");
        require(msg.sender == product.retailer || msg.sender == product.customer, "Only retailer or customer can call this function");

        product.status = ProductStatus.Received;

        emit ProductReceived(product.id, msg.sender);
    }

    function getProductInfo(uint256 _productId) public view returns (uint256 id, string memory name, uint256 price, ProductStatus status, address farmer, address distributor, address retailer, address customer) {
        require(_productId < productCount, "Invalid product ID");
        Product memory product = products[_productId];
        return (product.id, product.name, product.price, product.status, product.farmer, product.distributor, product.retailer, product.customer);
    }
}
