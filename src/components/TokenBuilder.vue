<template>
  <div style="padding: 10px">
    <router-link
      :to="{
        name: 'TokenTypeBuilder',
        params: { contract: contract },
      }"
      class="button button-no-border"
      >Create Token Id</router-link
    >
  </div>
  <div class="container content" style="padding: 10px">
    <div>
      <label for="mkt-id">Token Id: </label>
      <input id="mkt-id" type="text" placeholder="Token' Id" v-model="id" />
      <br /><br />
      <label for="mkt-name">Name: </label>
      <input
        id="mkt-name"
        type="text"
        placeholder="Music name"
        v-model="name"
      />
      <br /><br />
      <label for="mkt-id">Price: </label>
      <input
        id="mkt-id"
        type="number"
        placeholder="Token price"
        v-model="price"
      />
    </div>
    <br />
    <h3>
      Click bellow to bring it to the most incredible music community from
      metaverse :)
    </h3>
    <button class="nft-button button-no-border" @click="addToken">Mint NFT</button>
    <span style="padding-left: 50px;"/>
    <router-link
      :to="{
        name: 'TokenTypeBuilder',
        params: { contract: contract },
      }"
      class="button button-no-border error"
      >Cancel</router-link
    >
  </div>
</template>

<script>
import { useRoute } from "vue-router";
import { ethers } from "ethers";
import Web3Modal from "web3modal";
import { create as ipfsHttpClient } from "ipfs-http-client";

import Marketplace from "../../artifacts/contracts/marketplace/Marketplace.sol/Marketplace.json";

const MARKETPLACE_ADDRESS = process.env.VUE_APP_MARKETPLACE_ADDRESS;
const client = ipfsHttpClient("https://ipfs.infura.io:5001/api/v0");

export default {
  data() {
    return {
      id: 0,
      name: "",
      price: 0,
      contract: "",
    };
  },
  created() {
    const route = useRoute();
    this.contract = route.params.contract;
  },
  methods: {
    async addToken() {
      if (!this.contract) {
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

      const tx = await marketplace.addToken(
        this.contract,
        this.name,
        this.id,
        await ethers.utils.parseEther("" + this.price)
      );

      await tx.wait();
    },
  },
};
</script>
