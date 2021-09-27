require('dotenv').config();

async function main() {
    const myDate = new Date("Sept 26, 2021 13:20:00"); // Your timezone!
    const myEpoch = myDate.getTime()/1000.0;
    console.log(myEpoch)


    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    console.log("Account balance:", (await deployer.getBalance()).toString());

    const Auction = await ethers.getContractFactory("MyAuction")
  
    // Start deployment, returning a promise that resolves to a contract object
    const auction = await Auction.deploy(
        myEpoch, 
        process.env.PUBLIC_KEY, 
        "Tata",   
        "99999999999"
    )
    console.log("Auction Contract deployed to address:", auction.address)
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })
  