<template>
  <div v-if="noAlbumsAvailable" class="flex three content">
    <h2>No albums available</h2>
  </div>

  <div v-if="mediaActive" style="padding: 10px">
    <button class="button button-no-border" @click="activeAlbum">Albums</button>
  </div>

  <div v-if="albumActive" class="flex three content">
    <div v-for="album in albums" :key="album.contract">
      <article class="card">
        <header>
          <div>
            <span class="label success">{{ album.contract }}</span>
          </div>
          <div>
            <span>{{ album.name }}</span
            ><br />
          </div>
        </header>
        <img :src="album.img" />
        <p>Description: {{ album.description }}</p>
        <footer>
          <div class="container">
            <div class="row">
              <div class="col-md-6">
                <router-link
                  :to="{
                    name: 'TokenBuilder',
                    params: { contract: album.contract },
                  }"
                  class="button button-no-border"
                  >Add NFT</router-link
                >
              </div>
              <div class="col-md-6">
                <button
                  class="button button-no-border"
                  @click="activeMedia(album.contract)"
                >
                  List NFT
                </button>
              </div>
            </div>
          </div>
        </footer>
      </article>
    </div>
  </div>

  <!-- Media ************************************************ -->
  <div v-if="mediaActive" class="flex three content">
    <div v-for="media in medias" :key="media._$index">
      <article class="card">
        <header>
          <div class="flex two three-1000 demo">
            <div>
              <span>{{ media.name }}</span>
            </div>
          </div>
        </header>
        <img :src="media.img" />
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
      medias: [],
      albumActive: true,
      mediaActive: false,
      activeContract: undefined,
      noAlbumsAvailable: true,
    };
  },
  created() {
    this.loadData();
  },
  methods: {
    async loadAlbum() {
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
      }
      this.noAlbumsAvailable = this.albums.length == 0;
    },

    async loadMedia() {
      const web3Modal = new Web3Modal();
      const connection = await web3Modal.connect();
      const provider = new ethers.providers.Web3Provider(connection);
      const signer = provider.getSigner();
      const userAddress = await signer.getAddress();

      const marketplace = new ethers.Contract(
        MARKETPLACE_ADDRESS,
        Marketplace.abi,
        signer
      );

      const data = await marketplace.getContractTokens(this.activeContract);
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
              sold: _item.sold,
              url: _item.url,
              name: _item.name,
              isContract: _item.isContract,
              img: "https://tinyurl.com/nftimg00101",
            };
          })
        );
        this.medias = items;
      }
    },

    async loadData() {
      if (this.albumActive) this.loadAlbum();
      else this.loadMedia();
    },

    activeAlbum() {
      this.albumActive = true;
      this.mediaActive = false;
      this.loadData();
    },

    activeMedia(_contract) {
      this.albumActive = false;
      this.mediaActive = true;
      this.activeContract = _contract;
      this.loadData();
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
