require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");

const { API_URL, PRIVATE_KEY, PUBLIC_KEY, ETHERSCAN_API_KEY } = process.env;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.0",
  defaultNetwork: "ganache",
  networks: {
    //hardhat: {},
    //ropsten: {},
    ganache: {
      url: API_URL,
      gasLimit: 6000000000,
      defaultBalanceEther: 10
    }
  }
};
