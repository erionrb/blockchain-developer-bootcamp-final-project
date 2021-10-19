require('dotenv').config();

const HDWalletProvider = require('@truffle/hdwallet-provider');
const MNEMONIC  = process.env.MNEMONIC;
const INFURA_ID = process.env.INFURA_ID;

module.exports = {
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions. If you don't specify one truffle
   * will spin up a development blockchain for you on port 9545 when you
   * run `develop` or `test`. You can ask a truffle command to use a specific
   * network from the command line, e.g
   *
   * $ truffle test --network <network-name>
   */

  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
    },
    rinkeby: {
      provider: () => new HDWalletProvider(MNEMONIC, `https://rinkeby.infura.io/v3/${INFURA_ID}`),
      network_id: 4,
      confirmations: 1,
      timeoutBlocks: 200000000000,
      skipDryRun: true
    },
    ropsten: {
      provider: () => new HDWalletProvider(MNEMONIC, `https://ropsten.infura.io/v3/${INFURA_ID}`),
      network_id: 3,
      confirmations: 1,
      timeoutBlocks: 200000000000,
      skipDryRun: true
    }
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "^0.8.0",    // Fetch exact version from solc-bin (default: truffle's version)
    }
  },

  db: {
    enabled: false
  },
  
  plugins: [ 
    "truffle-security",
    "truffle-plugin-debugger"
  ]
};