pragma solidity ^0.4.0;

contract CharityMerchantUser {
    // Charities that can be approved by the owner
    // Badges that can be issued by the charities to the user

    address owner;
    mapping(address => uint) public charityType; // Charity and badge association
    mapping (uint => string) badgeAsString; // Mapping from badge types as integer to strings like 'Health' for example
    uint indexOfOfferFromUser; // The index of the offer which is incremented each time the user initiates an offer
    //
    mapping (address => uint) escrowBalanceByMerchant; // This is the balance in the escrow pledged by the merchant
//    //    // Key in the following variables represents the index of an offer initiated by a user
    mapping (uint => uint) indexToAmount; // Ether offered by merchant to charity in exchange for user's input to survey (1st address is merchant, 2nd address is user)
    mapping (uint => address) indexToCharity;
    mapping (uint => address) indexToUser; // index of the transaction initiated mapped to the user address
    mapping (uint => address) indexToMerchant; // index of the transaction initiated mapped to the merchant address
    mapping (uint => bool) indexToMerchantHasAcceptedUsersProposalAndCommitment; // Step 3 // Merchant is happy with amounts specified, charity and response offchain
    // mapping (uint => string) responseFromUser // Step 4 // This is a yes or no answer to the survey question from the user (not immediate)
    mapping (uint => bool) indexToIsTransactionComplete; // This is set to true when the transaction is complete

    // @TODO Define business logic for issuing badges (which charities can issue badges?)
    // @TODO Handle transaction gas costs needed for transferring from contract
    // @TODO Write a withdraw function from escrow funds

    // User story 1
    // 1. Merchant sets aside escrow of funds.
    // 2. User initiates offer to answer question posed by merchant (user specifies amount and specifies charity as well as merchant).
    // 3. Merchant accepts the offer from the user.
    // 4. User fulfills the promise with yes or no question. (consolidated in step 3)
    // 5. User is awarded a badge and his social credit score increases.
    // 6. Ether is moved from escrow account to charity.
    // 7. Merchant is awarded a badge.

    // register as charity
    // register qs merchant

    function CharityMerchantUser(){
        owner=msg.sender;
    }

    // This function is for user story 1 step 1
    function () payable { // This function is executed when the contract recieves ether
        uint valueToAdd = msg.value;
        escrowBalanceByMerchant[msg.sender] = escrowBalanceByMerchant[msg.sender] + valueToAdd;
    }

    // This function is for user story 1 step 2
    function userInitiatesOfferToMerchant(uint amount, address merchant, address charity){
        indexOfOfferFromUser = indexOfOfferFromUser + 1;
        indexToAmount[indexOfOfferFromUser] = amount;
        indexToCharity[indexOfOfferFromUser] = charity;
        indexToMerchant[indexOfOfferFromUser] = merchant;
        indexToUser[indexOfOfferFromUser] = msg.sender;
    }

    // This function is for user story 1 step 3 through 7
    function acceptOfferFromUser(uint index) {
        if (msg.sender == indexToMerchant[index] && escrowBalanceByMerchant[indexToMerchant[index]] >= indexToAmount[index]){
            indexToMerchantHasAcceptedUsersProposalAndCommitment[index] = true;
            // We transfer the ether to the charity
            escrowBalanceByMerchant[indexToMerchant[index]] = escrowBalanceByMerchant[indexToMerchant[index]] - indexToAmount[index];
            indexToCharity[index].transfer(indexToAmount[index]);
            indexToIsTransactionComplete[index] = true; // Finalizes the transaction
        }
    }

    function withdrawEscrow(){ // Write this function to withdraw ether from the escrow account

    }
}
