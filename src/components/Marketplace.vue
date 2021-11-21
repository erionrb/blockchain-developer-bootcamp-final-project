<template>
  <div style="padding: 10px">
    <span>Filter by: </span>
    <button class="market-btn">Not Owned</button>
    <button class="market-btn">Owned</button>
  </div>

  <div class="flex three content">
    <div v-for="item in marketItems" :key="item._$index">
      <article class="card">
        <header>
          <div class="flex two three-1000 demo">
            <div>
              <span>{{ item.name }}</span>
            </div>
            <div class="off-third-800 tag" style="">
              <span class="label warning">for sale</span>
            </div>
          </div>
        </header>
        <img :src="item.img" />
        <footer>
          <!-- <h3>{{ item.description }}</h3> -->
          <button class="nft-button">Buy</button>
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
      marketItems: [],
    };
  },
  created() {
    this.loadMarketItems();
  },
  methods: {
    async loadMarketItems() {
      const web3Modal = new Web3Modal();
      const connection = await web3Modal.connect();
      const provider = new ethers.providers.Web3Provider(connection);
      const signer = provider.getSigner();

      const marketplace = new ethers.Contract(
        MARKETPLACE_ADDRESS,
        Marketplace.abi,
        signer
      );

      const data = await marketplace.getAvailableTokens();
      let _index = 0;

      if (data) {
        const items = await Promise.all(
          data.map(async (_item) => {
            console.log(_item);
            return {
              _$index: _index++,
              owner: _item.owner,
              seller: _item.seller,
              contractAddress: _item.contractAddress,
              price: _item.price,
              tokenId: _item.tokenId,
              url: _item.url,
              // description: _item.description.substring(0, 100) + "...",
              name: _item.name,
              isContract: _item.isContract,
              img: "https://tinyurl.com/nftimg00101",
            };
          })
        );
        this.marketItems = items;
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

.market-btn {
  color: #111111 !important;
  background-color: #fff !important;
  border-radius: 0px !important;
  border: none !important;
}

.market-btn:hover {
  color: #fff !important;
  background-color: #0074d9 !important;
}

.content-filter span {
  color: #fff;
}

.tag {
  padding-left: 2em !important;
}
</style>
