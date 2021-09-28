# Solidity Auction Contract
This is a very simple contract that manages a p2p auction.
Someone initiates an auction and allows others to bid.
This is purely for learning Solidity.
Do not use this on the live Ethereum network.

Features:
- Initiate an auction by deploying the contract.
- Run the auction for a set period of time.
- Accept bids.
- Cancel the auction.
- Withdraw the losing bid funds.

To run locally against the ropsten network:
1. npm init
2. npm install .
3. Add the relevant values to the .env variables.
4. npx hardhat compile
5. node scripts/test.js


