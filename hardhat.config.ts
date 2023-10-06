import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-foundry";

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.11",
      }, 
      {
        version: "0.8.0",
      }, 
      {
        version: "0.5.0",
      },
      {
        version: "0.4.25",
      },
    ],
    settings: {
      optimizer: {
        enabled: true,
      },
    },
  },
  networks: { 
    hardhat: {
      allowUnlimitedContractSize: true,
    }
  },
};

export default config;