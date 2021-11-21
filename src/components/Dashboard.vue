<template>
  <div style="padding: 10px">
    <span>Filter by: </span>
    <button class="filter-btn">Album</button>
    <button class="filter-btn">Media</button>
  </div>

  <div class="flex three content">
    <div v-for="album in albums" :key="album.contract">
      <article class="card">
        <header>
          <div>
            <span class="label success">{{ album.contract }}</span>
            <span class="label success">owned</span>
          </div>
          <div>
            <span>{{ album.name }}</span
            ><br />
          </div>
        </header>
        <img :src="album.img" />
        <p>Description: {{ album.description }}</p>
        <footer>
          <div style="padding: 10px">
            <router-link
              :to="{ name: 'TokenBuilder', params: { contract: album.contract } }"
              class="button button-no-border"
              >Add NFT</router-link
            >
          </div>
        </footer>
      </article>
    </div>
  </div>
</template>

<script>
import { ethers } from "ethers";
import Web3Modal from "web3modal";

import Marketplace from "../../artifacts/contracts/marketplace/Marketplace.sol/Marketplace.json";
const MARKETPLACE_ADDRESS = process.env.VUE_APP_MARKETPLACE_ADDRESS;

export default {
  data() {
    return {
      albums: [],
    };
  },
  created() {
    this.loadData();
  },
  methods: {
    async loadData() {

      console.log(`Loading data from ${MARKETPLACE_ADDRESS}`);

      const web3Modal = new Web3Modal();
      const connection = await web3Modal.connect();
      const provider = new ethers.providers.Web3Provider(connection);
      const signer = provider.getSigner();

      const marketplace = new ethers.Contract(
        MARKETPLACE_ADDRESS,
        Marketplace.abi,
        signer
      );

      const data = await marketplace.getSellerContracts();
      console.log(data);

      if (data) {
        const items = await Promise.all(
          data.map(async (album) => {
            return {
              owner: album.owner,
              contract: album.contractAddress,
              url: album.url,
              name: album.name,
              description: album.description.substring(0, 100) + "...",
              img: "https://tinyurl.com/nftimg00101",
            };
          })
        );
        this.albums = items;
        // this.$forceUpdate(); force redisplay
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
