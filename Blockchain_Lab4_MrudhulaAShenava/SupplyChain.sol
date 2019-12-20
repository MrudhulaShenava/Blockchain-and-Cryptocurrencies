pragma solidity ^0.4.2;
 
contract SupplyChain {
    string id;
    address public buyer;
    address public seller;
    address private bank;
    uint balance;
    uint newbalance;
    bool buyerok;
    bool sellerok;
    uint check =0;
    uint storeBalance=0;

    
    //5000000000000000000
    struct Asset {
    string pro_name;
    uint pro_price;
    bool initialized;    
    bool isDelivered;
    bool isTransit;
    }
    function SupplyChain(address buyer_address, address seller_address, address bank_address, uint product_price, string product_name){
        buyer = buyer_address;
        seller = seller_address;
        bank = bank_address;
        assets[buyer].pro_price= product_price;
        assets[buyer].pro_name= product_name;
        
    }
    
    function status() public returns (bool, bool, bool, uint, uint, uint, uint ){ //. Calling a view cannot alter the behaviour of future interactions with any contract. This means such functions cannot use SSTORE, cannot send or receive ether and can only call other view or pure functions.
        return (assets[buyer].initialized, assets[buyer].isTransit, assets[buyer].isDelivered, check, balance, storeBalance, assets[buyer].pro_price);
    }
    
    function accept() public {
        if (msg.sender == buyer) {
            buyerok = true;
        } 
        if (msg.sender == seller) {
            sellerok = true;
        }
        if (buyerok && sellerok) {
             assets[buyer].isTransit = true;
             assets[buyer].initialized = false;
             assets[buyer].isDelivered = false;
             sellerok = false;
        } 
    }
    mapping(address => Asset ) public assets;
    
     function deposit() public payable {
        if (msg.sender == buyer) {
        assets[buyer].initialized = true;
        if(msg.sender ==buyer)
        {
           balance += msg.value;
           storeBalance += msg.value;
          //  buyerOk= true;
          bank.transfer(this.balance);
         
            
    }
     }
     }
     function Shipment() public payable {
         check = 1;
        if(assets[buyer].pro_price == storeBalance){
            check =2;
        if(assets[buyer].isTransit == true)
        {
            check =3;
             if(msg.sender == bank)
              {
                  check = 4;
                newbalance += msg.value;
                assets[buyer].initialized = false;
                assets[buyer].isTransit = false;
                assets[buyer].isDelivered = true;
                seller.transfer(newbalance);
            }
        }
        }  
     }
}
