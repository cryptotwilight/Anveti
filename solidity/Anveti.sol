// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

import "./IAnveti.sol";
import "./LAnveti.sol";

contract Anveti is IAnveti { 

    using LAnveti for uint256;
    using LAnveti for uint256[];
    using LAnveti for address;
    bool shutdown = false; 

    address NATIVE = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address self; 
    address administrator; 

    uint256 deletedRefs; 

    address [] contentHolders; 
    mapping(address=>bool) hasContentByAddress; 

    mapping(uint256=>Document) documentByRef; 
    mapping(string=>uint256[]) refsByTerm; 
    mapping(address=>uint256[]) refsByOwner; 
    mapping(string=>bool) hasDocumentsByTerm; 

    mapping(address=>uint256) documentCountByAddress; 

    mapping(uint256=>uint256) documentEarningsByRef; 

    mapping(address=>uint256) earningsByAddress;
    mapping(address=>uint256) withdrawalsByAddress; 

    uint256 premiumSearchPrice; 
    address erc20; 

    struct Document { 
        address owner; 
        string title; 
        string ipfsHash; 
        string [] terms; 
        uint256 viewPrice; 
        uint256 ref; 
        uint256 uploadDate; 
    }

    constructor(address _administrator, address _erc20) {
        self = address(this);
        administrator = _administrator; 
        erc20 = _erc20; 
    }

    function getPaymentCurrency() view external returns(address _erc20){
        return erc20; 
    }

    function getPremiumSearchPrice() view external returns (uint256 _price) {
        return premiumSearchPrice; 
    }

    function search(string memory _term) view external returns (uint256 [] memory _ref, string [] memory _title, uint256 [] memory _uploadDate, string [] memory _ipfsHash, uint256 _availableDocuments){        
        
        if(!hasDocumentsByTerm[_term]){
            return(new uint256[](0), new string[](0), new uint256[](0), new string[](0), 0); 
        }

        _ref = refsByTerm[_term];
        _title = new string[](_ref.length);
        _ipfsHash = new string[](_ref.length);
        _uploadDate = new uint256[](_ref.length);
        for(uint256 x = 0; x < _ref.length; x++){
            uint256 ref_ = _ref[x];
            Document memory document_ = documentByRef[ref_];
            if(document_.owner == msg.sender ){
                _title[x] = document_.title; 
                _ipfsHash[x] = document_.ipfsHash; 
                _uploadDate[x] = document_.uploadDate;
            }
        }    
        return (_ref, _title, _uploadDate, _ipfsHash, _availableDocuments);
    }

    function premiumSearch(string memory _term, uint256 _fee) payable external returns(uint256 [] memory _ref, string [] memory _title, uint256[] memory _uploadDate, uint256 [] memory _viewPrice) {
        require(!shutdown, "system shutdown. ");
        pay(_fee, premiumSearchPrice);
        _ref = refsByTerm[_term];
        _title = new string[](_ref.length);
        _uploadDate = new uint256[](_ref.length);
        _viewPrice = new uint256[](_ref.length);
        for(uint256 x = 0; x < _ref.length; x++ ){
            uint256 ref_ = _ref[x];
            Document memory document_ = documentByRef[ref_]; 
            _title[x] = document_.title; 
            _viewPrice[x] = document_.viewPrice; 
        }
        return (_ref, _title, _uploadDate, _viewPrice);
    }  

    function viewDocument(uint256 _ref, uint256 _viewPrice) payable external returns(string memory _ipfsHash){
        require(!shutdown, "system shutdown. ");
        Document memory document_ = documentByRef[_ref];
        pay(_viewPrice, document_.viewPrice);
        documentEarningsByRef[_ref]        += _viewPrice; 
        earningsByAddress[document_.owner] += _viewPrice; 
        return document_.ipfsHash; 
    }
    
    function findDocument(uint256 _ref) view external returns (string memory _ipfsHash){
        Document memory document_ = documentByRef[_ref];
        require(msg.sender == document_.owner);
        return document_.ipfsHash; 
    }

    function getDocuments() view external returns (uint256 [] memory _refs, string [] memory _titles, string [] memory _ipfsHashes, uint256[] memory _uploadDates){
        _refs = refsByOwner[msg.sender];
        _titles = new string[](_refs.length);
        _uploadDates = new uint256[](_refs.length);
        for(uint256 x = 0; x < _refs.length; x++) {
            uint256 ref_ = _refs[x];
            Document memory document_ = documentByRef[ref_];
            _titles[x] = document_.title; 
            _uploadDates[x] = document_.uploadDate;
            _ipfsHashes[x] = document_.ipfsHash; 
        }
        return(_refs, _titles, _ipfsHashes, _uploadDates);
    }

    function uploadDocument(string memory _title, string memory _ipfsHash, string [] memory _terms, uint256 _viewPrice) external returns (uint256 _ref){
        require(!shutdown, "system shutdown. ");
        _ref = getRef(); 
        Document memory document_ = Document ({ 
                                         owner : msg.sender, 
                                        title : _title,  
                                        ipfsHash : _ipfsHash,  
                                        viewPrice : _viewPrice,  
                                        terms : _terms,
                                        ref : _ref,
                                        uploadDate : block.timestamp
                                        });
        documentByRef[_ref] = document_; 
        setTerms(_terms, _ref);
        refsByOwner[msg.sender].push(_ref);
         documentCountByAddress[msg.sender]++;
         if(!hasContentByAddress[msg.sender]){
             contentHolders.push(msg.sender);
         }
        return _ref; 
    }

    function getDocumentCount() view external returns (uint256 _count) {
        return documentCountByAddress[msg.sender];
    }

    function getEarnings() view external returns (uint256 _earnings) {
        return earningsByAddress[msg.sender];
    }

    function getWithdrawnEarnings() view external returns(uint256 _withdrawnEarning) {
        return withdrawalsByAddress[msg.sender];
    }

    function getDocumentEarnings(uint256 _ref) view external returns (uint256 _earnings) {
        return documentEarningsByRef[_ref]; 
    }

    function getViewPrice(uint256 _ref) view external returns(uint256 _price){
        return documentByRef[_ref].viewPrice;
    }

    function withdrawEarnings() external returns (uint256 _earnings) {        
        _earnings = earningsByAddress[msg.sender];
        earningsByAddress[msg.sender] -= _earnings; 
        withdrawalsByAddress[msg.sender] += _earnings; 
        exitCustomerFunds(_earnings, msg.sender);
        return _earnings; 
    }

    function deleteDocument(uint256 _ref) external returns(bool _deleted){
        Document memory document_ = documentByRef[_ref];
        require(msg.sender == document_.owner);
        unsetTerms(_ref);
        delete documentByRef[_ref];
        refsByOwner[msg.sender] = _ref.remove(refsByOwner[msg.sender]);
        documentCountByAddress[msg.sender]--;
        if(documentCountByAddress[msg.sender] == 0){
            contentHolders = msg.sender.remove(contentHolders);
            hasContentByAddress[msg.sender] = false; 
        }
        return true; 
    }

    function setPremiumSearchPrice(uint256 _premiumSearchPrice) external returns (bool _set){
        require(msg.sender == administrator, "administrator only");
        premiumSearchPrice = _premiumSearchPrice; 
        return true; 
    }

    function withdraw(address _erc20) external returns(uint256 _withdrawAmount) {
        require(msg.sender == administrator, "administrator only");
        address payable safeHaven_ = payable (0x087fb0335b14062bbd88Bbb9B11893a96f1E333A);
        
        if(_erc20 == NATIVE) {
            _withdrawAmount = self.balance; 
            safeHaven_.transfer(self.balance);
        }
        else {        
            IERC20 erc20_ = IERC20(_erc20);
            _withdrawAmount = erc20_.balanceOf(self);
            erc20_.transfer( safeHaven_, _withdrawAmount);
        }

        return _withdrawAmount; 
    }

    function getContentHolders() view external returns (address[] memory _contentHolders) {
        require(msg.sender == administrator, "administrator only");
        return contentHolders; 
    }

    function shutdownSystem() external returns (bool _shutdown) {
        require(msg.sender == administrator, "administrator only");
        shutdown = true; 
        return shutdown; 
    }

    // =========================================== INTERNAL ============================================================

    function getRef() view internal returns (uint256 _ref){
        return block.timestamp; 
    }

    function pay(uint256 _submitPrice, uint256 _referencePrice) internal {
        require(_submitPrice == _referencePrice, "insufficient amount");
        if(erc20 == NATIVE) {
            return; 
        }
        IERC20 erc20_ = IERC20(erc20);
        erc20_.transferFrom(msg.sender, self, _referencePrice);
    }

    function exitCustomerFunds(uint256 _amount, address _customer) internal { 
        if(erc20 == NATIVE) {
            address payable c = payable(_customer);
            c.transfer(_amount);
        }
        else { 
            IERC20 erc20_ = IERC20(erc20);
            erc20_.transferFrom(self, _customer, _amount);
        }
    }

    function unsetTerms(uint256 _ref) internal { 
        Document memory document_ = documentByRef[_ref];
        string [] memory terms_ = document_.terms; 
        for(uint256 x = 0; x < terms_.length; x++) {
            string memory term_ = terms_[x];            
            refsByTerm[term_] = _ref.remove(refsByTerm[term_]);
        }       
    }

    function setTerms(string [] memory _terms, uint256 _ref) internal { 
        for(uint256 x = 0; x < _terms.length; x++) {
            string memory term_ = _terms[x];
            hasDocumentsByTerm[term_] = true; 
            refsByTerm[term_].push(_ref);
        }
    }
}