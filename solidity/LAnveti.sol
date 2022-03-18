//SPDX-License-Identifier: Apache-2.0

pragma solidity >=0.8.0 <0.9.0;


library LAnveti { 

    function append(uint256[] memory a, uint256[] memory b) pure internal returns (uint256 [] memory) {        
        uint256 [] memory c = new uint256[](b.length+a.length); 
        uint256 y = 0; 
        for(uint256 x = 0; x < c.length; x++) {
            c[x] = a[x];
            if(x >= a.length ){
                c[x] = b[y];
                y++;
            }
        }
        return c; 
    }


    function append(uint256 a, uint256[] memory b) pure internal returns (uint256 [] memory) {        
        uint256 [] memory c = new uint256[](b.length+1); 
        for(uint256 x = 0; x < c.length; x++) {
            if(x == b.length){
                c[x] = a; 
            }
            c[x] = b[x];
        }
        return c; 
    }

    function isContained(uint256 z, uint256 [] memory y) pure internal returns (bool) {
        
        for(uint x = 0 ; x < y.length; x++){
            if(y[x] == z){
                return true; 
            }
        }
        return false; 
    }

    function remove(uint256 a, uint256[] memory b) pure internal returns (uint256 [] memory){
        uint256 [] memory c = new uint256[](b.length-1);
        uint256 y = 0; 
        for(uint256 x = 0; x < b.length; x++) {
            uint256 d = b[x];
            if( a != d){    
                if(y == c.length){ // i.e. element not found
                    return b; 
                } 
                c[y] = d; 
                y++;
            }
        }
        return c; 
    }

    function remove(address a, address[] memory b) pure internal returns (address [] memory){
        address [] memory c = new address[](b.length-1);
        uint256 y = 0; 
        for(uint256 x = 0; x < b.length; x++) {
            address d = b[x];
            if( a != d){     
                if(y == c.length){ // i.e. element not found
                    return b; 
                }
                c[y] = d; 
                y++;
           
            }
        }
        return c; 
    }

}