import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

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
  networks: { },
};

export default config;