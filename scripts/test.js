require("dotenv").config()

const { API_URL, PRIVATE_KEY, PUBLIC_KEY} = process.env;

const { createAlchemyWeb3 } = require("@alch/alchemy-web3")
const web3 = createAlchemyWeb3(API_URL)

const contract = require("../artifacts/contracts/auction_contract.sol/MyAuction.json")

//console.log(JSON.stringify(contract.abi))

const contractAddress = "0x1ECC5A43754dbCdF528eD9082294E14A50151f77";
const auctionContract = new web3.eth.Contract(contract.abi, contractAddress);


async function bidOnCar() {
    const nonce       = await web3.eth.getTransactionCount(PUBLIC_KEY, 'latest'); // get latest nonce
    const msg_data    = {
        'sender': PUBLIC_KEY,
        'value' : 100
    };
    const gasEstimate = await auctionContract.methods.bid().estimateGas(msg_data); // estimate gas

    const gasPrice = await web3.eth.getGasPrice();

    
    //return gasEstimate;
    //return gasPrice;

    // Create the transaction
    const tx = {
      'from': PUBLIC_KEY,
      'to': contractAddress,
      'nonce': nonce,
      'gas': gasEstimate * 3, 
      //'maxFeePerGas': gasPrice,
      'value': 100,
      'data': auctionContract.methods.bid().encodeABI()
    };

    // Sign the transaction
    const signPromise = web3.eth.accounts.signTransaction(tx, PRIVATE_KEY);
    signPromise.then((signedTx) => {
      web3.eth.sendSignedTransaction(signedTx.rawTransaction, function(err, hash) {
        if (!err) {
          console.log("The hash of your transaction is: ", hash, "\n Check Alchemy's Mempool to view the status of your transaction!");
        } else {
          console.log("Something went wrong when submitting your transaction:", err)
        }
      });
    }).catch((err) => {
      console.log("Promise failed:", err);
    });

}


async function main() {
    const output = await bidOnCar();
    console.log(">>>>>>>> <<<<<<<<" + output) 

}
main();
