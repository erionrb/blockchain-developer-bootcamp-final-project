<template>
  <div class="alb-content">
    <div><button class="primary" @click="fillAlbumValues">Mock 1</button></div>
    <div class="alb-crud">
      <h2>NFT Album Creation</h2>
      <fieldset>
        <label for="alb-name">name:</label>
        <input id="alb-name" type="text" placeholder="Name" v-model="name" />
        <label for="alb-url">Base URL:</label>
        <input id="alb-url" type="text" placeholder="URL" v-model="url" />
      </fieldset>
      <br />
      <label for="alb-desc">Description:</label>
      <textarea id="alb-desc" placeholder="Textarea" v-model="desc" />
    </div>
    <div><button class="primary" @click="createAlbum">Create</button></div>
  </div>
</template>

<script>
import { ethers } from "ethers";
import Web3Modal from "web3modal";

import NFTFactory from "../../artifacts/contracts/nft/NFTFactory.sol/NFTFactory.json";

const NFT_FACTORY_ADDRESS = process.env.VUE_APP_NFT_FACTORY_ADDRESS;

export default {
  data() {
    return {
      url: "",
      name: "",
      desc: "",
    };
  },
  methods: {
    fillAlbumValues() {
      this.name = "Life Starts Now";
      this.url = "http://localhost:6000/nft/{id}";
      this.desc =
        "Life Starts Now is the third studio album by Canadian rock band Three Days Grace. The album was released on September 22, 2009. The album was produced by Howard Benson. This is the second time in a row the band has worked with him, after the commercially successful One-X. Life Starts Now expresses a lighter lyrical mood compared to the band's previous album. It is the first Three Days Grace album to be released under Sony Music Entertainment and the last to be released through Jive Records, as Sony disbanded the label in 2011.";
    },

    async createAlbum() {
      console.log(`NFT_FACTORY_ADDRES is ${NFT_FACTORY_ADDRESS}`);
      const web3Modal = new Web3Modal();
      const connection = await web3Modal.connect();
      const provider = new ethers.providers.Web3Provider(connection);
      const signer = provider.getSigner();

      const nftFactory = new ethers.Contract(
        NFT_FACTORY_ADDRESS,
        NFTFactory.abi,
        signer
      );

      const tx = nftFactory.createAlbumNFT(this.url, this.name, this.desc);
      tx.then((tx$) => {
        console.log("Album Created");
        console.log(tx);
      });
    },
  },
};
</script>

<style>
.alb-content {
  padding: 10px;
}

.alb-crud {
  padding: 10px;
  align-items: center;
  background: #95c8d8;
  border-radius: 0.2em;
  border: 1px solid #aaa;
  font-weight: bold;
}

.content {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  padding: 10px;
  padding-left: 10px;
}
</style>
