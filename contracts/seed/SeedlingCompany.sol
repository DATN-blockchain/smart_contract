// SPDX-License-Identifier: MIT
// import "@openzeppelin/contracts/access/Ownable.sol";
pragma solidity ^0.8.0;

import "../lib/Structs.sol";

interface ISeedlingCompany {
    function create(string memory id) external returns(CompanyInfo memory);
    function get_seedling_company_by_address(address address_company) external view returns (CompanyInfo memory);
    function get_seedling_company_by_id(string memory id) external  view returns (CompanyInfo memory);
}

contract SeedlingCompany is ISeedlingCompany {

    constructor(){}

    mapping (address => CompanyInfo) seedling_companys;
    mapping (string => CompanyInfo) companys_ms;
    CompanyInfo[] public companys;

    function create(string memory id) public returns(CompanyInfo memory) {
        seedling_companys[msg.sender] = CompanyInfo(id, msg.sender);
        companys.push(seedling_companys[msg.sender]);
        companys_ms[id] = seedling_companys[msg.sender];
        return seedling_companys[msg.sender];
    }

    function get_seedling_company_by_address(address address_company) public  view returns (CompanyInfo memory){
        return seedling_companys[address_company];
    }

    function get_seedling_company_by_id(string memory id) public  view returns (CompanyInfo memory){
        return companys_ms[id];
    }
}
