// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;


interface IAnveti { 

    function search(string memory _term) external returns (uint256 [] memory _ref, string [] memory _title, string [] memory _ipfsHash, uint256 _availableDocuments, uint256 _retrievePrice);

    function searchExtended(string [] memory _terms, uint256 _fee) payable external returns(uint256 [] memory ref, string [] memory title, uint256 [] memory _viewPrice);    

    function viewDocument(uint256 _ref, uint256 _viewPrice) payable external returns(string memory _document);
    
    function findDocument(uint256 _ref) view external returns (string memory _document);

    function uploadDocument(string memory _title, string memory _document, string [] memory _terms, uint256 _viewPrice) external returns (uint256 _ref);

    function deleteDocument(uint256 _ref) external returns(bool _deleted);

}