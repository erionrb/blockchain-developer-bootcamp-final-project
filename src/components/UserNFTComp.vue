<template>
  <div style="padding: 10px">
    <span>Filter by: </span>
    <button class="filter-btn">Album</button>
    <button class="filter-btn">Media</button>
  </div>

  <div class="flex three content">
    <div v-for="nft in nfts" :key="nft.contract">
      <article class="card">
        <header>
          <div>
            <span class="label success">{{ nft.contract }}</span>
            <span class="label success">owned</span>
          </div>
          <div>
            <span>{{ nft.name }}</span
            ><br />
          </div>
        </header>
        <img :src="nft.img" />
        <p>Name: {{ nft.name }}</p>
        <p>URL: {{ nft.url }}</p>
        <p>Description: {{ nft.description }}</p>
        <footer>
          <p>Footer</p>
        </footer>
      </article>
    </div>
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
      nfts: [],
    };
  },
  created() {
    this.loadData();
  },
  methods: {
    async loadData() {
      const web3Modal = new Web3Modal();
      const connection = await web3Modal.connect();
      const provider = new ethers.providers.Web3Provider(connection);
      const signer = provider.getSigner();

      const nftFactory = new ethers.Contract(
        NFT_FACTORY_ADDRESS,
        NFTFactory.abi,
        signer
      );

      const data = await nftFactory.getNFTContracts();

      if (data) {
        const items = await Promise.all(
          data.map(async (_nft) => {
            console.log(_nft.url);
            return {
              contract: _nft.contractAddress,
              url: _nft.url,
              name: _nft.name,
              description: _nft.description.substring(0, 100) + "...",
              img: "https://thumbs.dreamstime.com/b/dynamic-radial-color-sound-equalizer-design-music-album-cover-template-abstract-circular-digital-data-form-vector-160916775.jpg"
            };
          })
        );
        this.nfts = items;
      }
    },
  },
};
</script>

<style scoped>
.content {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  padding: 10px;
}

.nft-button {
  border-radius: 0px !important;
  border: none !important;
}

.card header {
  background: #0074d9;
  color: #fff;
}

.content-filter {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  padding: 10px;
  background: #0074d9;
  border-radius: 0.2em;
  border: 1px solid #aaa;
}

.filter-btn {
  color: #111111 !important;
  background-color: #fff !important;
  border-radius: 0px !important;
  border: none !important;
}

.filter-btn:hover {
  color: #fff !important;
  background-color: #0074d9 !important;
}

.content-filter span {
  color: #fff;
}

.tag {
  padding-left: 2em !important;
}

footer {
    background: #5483ac;
    color: #fff;
}
</style>
