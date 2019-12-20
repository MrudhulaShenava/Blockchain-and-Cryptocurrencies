pragma solidity ^0.4.10;

contract EscrowService {
    uint balance;
    address public buyer;
    address public seller;
    address public escrow;
    uint private start;
    uint buy_ok=1;
    uint sell_ok=1;
    bool buyer_Ok;
    bool seller_Ok;


    function EscrowService(address Buyer, address Seller, address Escrow){
        buyer = Buyer;
        seller = Seller;
        escrow = Escrow;
    }


  /*  function getBuyerAddress() public returns (address){ //. Calling a view cannot alter the behaviour of future interactions with any contract. This means such functions cannot use SSTORE, cannot send or receive ether and can only call other view or pure functions.
        return buyer;
    }
    function getSellerAddress() public returns (address){ //. Calling a view cannot alter the behaviour of future interactions with any contract. This means such functions cannot use SSTORE, cannot send or receive ether and can only call other view or pure functions.
        return seller;
    }

    function getDepositedAmount() public returns (uint){
        return balance;
    } */
//buyer / seller agrees
    function agreement() public {
        if (msg.sender == buyer) {
            buy_ok = 2;
            
        } 
        if (msg.sender == seller) {
            sell_ok = 2;
        }
        if (buy_ok==2){
            buyer_Ok = true;
        }
        else {
            buyer_Ok = false;
        }
        if (sell_ok==2){
            seller_Ok = true;
        }
        else {
            seller_Ok = false;
        }
        // If buyer and seller agrees then transfer fund to buyer
        if (buyer_Ok && seller_Ok) {
            payBalance(seller);
        } 
        //if seller agrees but buyer disagrees, wait for two minutes and sort dispute. Buyer refunded
       // if (buyeroki == 3  && selleroki == 2 ){//&& now > start + 2 minutes) {
          // Freeze 2 mins before release to buyer. The buyer has to call this method after freeze period.
          // payBalanceto(buyer);
         // disputeSolver();
    //   }
       //if buyer agrees but seller disagrees, escrow kills the transaction and sort dispute. Buyer refunded
      // if (buyeroki == 2  && selleroki == 3) {
         //  kill();
      // }
    }
    
     //if seller agrees but buyer disagrees, wait for two minutes and sort dispute. 
     //Buyer refunded by escrow
    function disputeTimeout() payable{
        if(msg.sender == escrow){
            if (buy_ok == 3  && sell_ok == 2 ){
                if(now > start + 2 minutes){
                    payBalance(buyer);
                 }
             }
         }    
    }

  /*  function payBalancetoSeller() payable{
        //sending escrow (contract creator) a fee
        escrow.transfer(this.balance / 100);

        if (seller.send(this.balance)) {// if send fails it returns false. This is to reset the balance to 0
            balance = 0;
        } else {
            throw;
            //When a contract is firing an exception (via throw / require / assert) 
            //the transaction and all change to the state are reverted . 
            //Any ether that was sent during the transaction will not be transferred.

        }
    } */

    function deposit() public payable {
            balance += msg.value;
            buy_ok = 1;
            sell_ok = 1;
            start = now;
    }

//buyer / seller agrees
    function disagreement() public {
        if (msg.sender == buyer) {
            buy_ok = 3;
            
        } 
        if (msg.sender == seller) {
            sell_ok = 3;
        }
        if (buy_ok==3){
            buyer_Ok = false;
        }
        else {
            buyer_Ok = true;
        }
        if (sell_ok==3){
            seller_Ok = false;
        }
        else {
            seller_Ok = true;
        }
        // if both buyer and seller would like to cancel, money is returned to buyer
        if (!buyer_Ok && !seller_Ok) {
           payBalance(buyer);
        }
        //if seller agrees but buyer disagrees, wait for two minutes and sort dispute. Buyer refunded
       // if (buyeroki == 3  && selleroki == 2 && now > start + 2 minutes) {
          // Freeze 2 mins before release to buyer. The customer has to remember to call this method after freeze period.
         //  payBalanceto(buyer);
     //  }
         //if buyer agrees but seller disagrees, escrow kills the transaction and sort dispute. Buyer refunded
      // if (buyeroki == 2  && selleroki == 3) {
         //  kill();
     //  }
    }
    
function payBalance(address refundTo) payable{
        //sending escrow (contract creator) a fee
        escrow.transfer(this.balance / 100);

        if (refundTo.send(this.balance)) {
            // if send fails it returns false. This is to reset the balance to 0.
            balance = 0;
        } else {
            throw;
            //When a contract is firing an exception (via throw / require / assert) 
            //the transaction and all change to the state are reverted . 
            //Any ether that was sent during the transaction will not be transferred.
        }
    }
    
    
  /* function refundBuyer() private {// only we (the escrow can refund the buyer if there is a dispute )
        if (msg.sender == escrow) {
            escrow.transfer(this.balance / 100);
           // selfdestruct(buyer);
        }
    }*/

    function kill() public payable{
        //if buyer agrees but seller disagrees
        //scrow kills the transaction and sort dispute. 
        //Buyer refunded by escrow
       if (buy_ok == 2  && sell_ok == 3) { 
           if(msg.sender == escrow){
            payBalance(buyer);
           }
       }
          // { 
               //payBalanceto(buyer);
         //  }
          // selfdestruct(buyer);
    }
}
