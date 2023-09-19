import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-foundry";

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.11",
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