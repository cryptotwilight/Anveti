// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;


interface IAnveti { 


    function getPaymentCurrency() view external returns(address _erc20);

    function getDocumentCount() view external returns (uint256 _count);
    
    function getEarnings() view external returns (uint256 _earnings);

    function getPremiumSearchPrice() view external returns (uint256 _retrievePrice);

    function getDocumentEarnings(uint256 _ref) view external returns (uint256 _earnings);

    function withdrawEarnings() external returns (uint256 _earnings);
    
    function search(string memory _term) view external returns (uint256 [] memory _ref, string [] memory _title, uint256 [] memory _uploadDate, string [] memory _ipfsHash, uint256 _availableDocuments);

    function premiumSearch(string memory _term, uint256 _fee) payable external returns(uint256 [] memory _ref, string [] memory _title,  uint256 [] memory _uploadDate,  uint256 [] memory _viewPrice);    

    function getViewPrice(uint256 _ref) view external returns (uint256 _viewPrice);

    function viewDocument(uint256 _ref, uint256 _viewPrice) payable external returns(string memory _ipfsHash);
    
    function findDocument(uint256 _ref) view external returns (string memory _ipfsHash);

    function uploadDocument(string memory _title, string memory _ipfsHash, string [] memory _terms, uint256 _viewPrice) external returns (uint256 _ref);

    function deleteDocument(uint256 _ref) external returns(bool _deleted);

}