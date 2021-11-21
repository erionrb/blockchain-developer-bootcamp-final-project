<template>
  <div class="mkt-panel">
    <button class="button-no-border" @click="fillValues">Fill Out</button>
    <br /><br />
    <div>
      <label for="mkt-id">Id: </label>
      <input id="mkt-id" type="text" placeholder="Token' Id" v-model="id" />
      <br /><br />
      <label for="mkt-name">Name: </label>
      <input
        id="mkt-name"
        type="text"
        placeholder="Music name"
        v-model="name"
      />
    </div>
    <br />
    <img src="https://tinyurl.com/nftimg00101" style="height: 50vh" />
    <h3>
      Click bellow to bring it to the most incredible music community from
      metaverse :)
    </h3>
    <button class="nft-button" @click="addToken">Create NFT</button>
  </div>
</template>

<script>
import { useRoute } from "vue-router";
import { ethers } from "ethers";
import Web3Modal from "web3modal";

import Marketplace from "../../artifacts/contracts/marketplace/Marketplace.sol/Marketplace.json";

const MARKETPLACE_ADDRESS = process.env.VUE_APP_MARKETPLACE_ADDRESS;

export default {
  data() {
    return {
      id: 0,
      url: "",
      name: "",
      description: "",
      contract: "",
    };
  },
  created() {
    const route = useRoute();
    this.contract = route.params.contract;
  },
  methods: {
    fillValues() {
      this.id = 1;
      this.url = "http://localhost:6000/nft/1";
      this.name = "Bitter Taste";
      this.description = "Bitter Taste description";
    },

    async addToken() {

      if(!this.contract) {
        alert("Please go back to Dashboard to get album contract again");
        return;
      }

      const web3Modal = new Web3Modal();
      const connection = await web3Modal.connect();
      const provider = new ethers.providers.Web3Provider(connection);
      const signer = provider.getSigner();

      const marketplace = new ethers.Contract(
        MARKETPLACE_ADDRESS,
        Marketplace.abi,
        signer
      );
      this.price = 10;
      const _price = ethers.utils.parseUnits(this.price + "", "ether");
      console.log(`Creating token with contract ${this.contract}`);
      console.log(`Creating token with id ${this.id}`);
      console.log(`Creating token with name ${this.name}`);
      console.log(`Creating token with description ${this.description}`);
      console.log(`Creating token with url ${this.url}`);
      console.log(`Creating token with price ${_price}`);
      const tx = await marketplace.addToken(
        this.contract,
        this.name,
        _price,
        this.id
      );
      await tx.wait();
    },
  },
};
</script>

<style scoped>
.mkt-panel {
  width: min-content;
  padding: 10px;
  border: 1px solid #111111;
  border-radius: 0.5em;
}
</style>
