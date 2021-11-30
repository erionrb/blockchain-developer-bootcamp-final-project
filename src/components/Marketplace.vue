<template>
  <div v-if="noMarketItems" class="flex three content">
    <h2>No items available</h2>
  </div>

  <div v-if="!noMarketItems" style="padding: 10px">
    <span>Filter by: </span>
    <button class="market-btn" @click="filterAllTokens">All</button>
    <button class="market-btn" @click="filterOwnedTokens">Owned</button>
    <button class="market-btn" @click="filterForSaleTokens">Not Owned</button>
  </div>

  <div v-if="!noMarketItems">
    <!-- All Tokens -->
    <div v-if="allTokensOnly">
      <div style="padding: 10px">All Tokens:</div>
      <div class="flex three content">
        <div v-for="item in allTokens" :key="item._$index">
          <article class="card">
            <header>
              <div>
                <span>{{ item.name }}</span>
                <span v-if="item.sold" class="label success">owned</span>
                <span v-else class="label warning">for sale</span>
                <span class="label success">Owner:{{ item.owner }}</span>
                <span class="label warning">Seller:{{ item.seller }}</span>
              </div>
            </header>
            <img :src="item.img" />
            <footer v-if="item.mine">
              <button
                v-if="!item.sold"
                class="nft-button"
                @click="buyToken(item)"
              >
                Buy
              </button>
              <audio controls>
                <source :src="item.url" type="audio/mp3" />
                Your browser does not support the audio element.
              </audio>
            </footer>
          </article>
        </div>
      </div>
    </div>

    <!-- Only Owned Tokens -->
    <div v-if="ownedTokensOnly">
      <div style="padding: 10px">My Tokens:</div>
      <div class="flex three content">
        <div v-for="item in ownedTokens" :key="item._$index">
          <article class="card">
            <header>
              <div>
                <span>{{ item.name }}</span>
                <span v-if="item.sold" class="label success">owned</span>
                <span v-else class="label warning">for sale</span>
                <span class="label success">Owner:{{ item.owner }}</span>
                <span class="label warning">Seller:{{ item.seller }}</span>
              </div>
            </header>
            <img :src="item.img" />
            <footer v-if="item.mine">
              <audio controls>
                <source :src="item.url" type="audio/mp3" />
                Your browser does not support the audio element.
              </audio>
            </footer>
          </article>
        </div>
      </div>
    </div>

    <!-- Only For Sale Tokens -->
    <div v-if="forSaleTokensOnly">
      <div style="padding: 10px">Tokens For Sale:</div>
      <div class="flex three content">
        <div v-for="item in forSaleTokens" :key="item._$index">
          <article class="card">
            <header>
              <div>
                <span>{{ item.name }}</span>
                <span v-if="item.sold" class="label success">owned</span>
                <span v-else class="label warning">for sale</span>
                <span class="label success">Owner:{{ item.owner }}</span>
                <span class="label warning">Seller:{{ item.seller }}</span>
              </div>
            </header>
            <img :src="item.img" />
            <footer>
              <button
                v-if="!item.mine"
                class="nft-button"
                @click="buyToken(item)"
              >
                Buy
              </button>
            </footer>
          </article>
        </div>
      </div>
    </div>
  </div>

  <div id="commonModal" class="modal">
    <!-- Modal content -->
    <div class="modal-content">
      <span class="close" @click="closeModal('commonModal', loadMarketItems)"
        >&times;</span
      >
      <h1>NFT bought with success</h1>
    </div>
  </div>

  <div id="errorModal" class="modal">
    <!-- Modal content -->
    <div class="modal-content">
      <span class="close" @click="closeModal('errorModal')">&times;</span>
      <h1>Error to create contract</h1>
      <h2>{{ errorMessage }}</h2>
    </div>
  </div>
</template>

<script>
import { ethers } from "ethers";
import Web3Modal from "web3modal";

import Marketplace from "../../artifacts/contracts/marketplace/Marketplace.sol/Marketplace.json";
const MARKETPLACE_ADDRESS = process.env.VUE_APP_MARKETPLACE_ADDRESS;
const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";

export default {
  data() {
    return {
      marketItems: [],
      allTokensOnly: true,
      ownedTokensOnly: false,
      forSaleTokensOnly: false,
      noMarketItems: true,
      errorMessage: "",
    };
  },
  created() {
    this.loadMarketItems();
  },
  methods: {
    openModal(_modalId) {
      var modal = document.getElementById(_modalId);
      modal.style.display = "block";
    },

    closeModal(_modalId, callback) {
      var modal = document.getElementById(_modalId);
      modal.style.display = "none";
      if (callback) callback();
    },

    setItemsVisibility() {
      if (this.marketItems.length > 0) {
        this.noMarketItems = false;
      }
    },
    getSong(token) {
      return [
        {
          name: token.name,
          url: token.url,
        },
      ];
    },
    filterAllTokens() {
      this.allTokensOnly = true;
      this.ownedTokensOnly = false;
      this.forSaleTokensOnly = false;
    },
    filterOwnedTokens() {
      this.allTokensOnly = false;
      this.ownedTokensOnly = true;
      this.forSaleTokensOnly = false;
    },
    filterForSaleTokens() {
      this.allTokensOnly = false;
      this.ownedTokensOnly = false;
      this.forSaleTokensOnly = true;
    },
    async loadMarketItems() {
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

      // const senderTokens = await marketplace.getSenderTokens();
      // const notSenderTokens = await marketplace.getNotSenderTokens();

      const tokens = await marketplace.getTokens();

      // if (senderTokens) {
      //   const items = await Promise.all(
      //     senderTokens.map(async (_item) => {

      //       console.log("url: ", _item.contractUri + "/" + _item.tokenUri);
      //       return {
      //         _$index: _item.marketTokenId,
      //         marketTokenId: _item.marketTokenId,
      //         name: _item.name,
      //         owner: _item.owner,
      //         seller: _item.seller,
      //         mine: _item.owner === userAddress,
      //         contractAddress: _item.contractAddress,
      //         price: _item.price,
      //         tokenId: _item.tokenId,
      //         sold: _item.sold,
      //         url: _item.contractUri + "/" + _item.tokenUri,
      //         img: "https://tinyurl.com/nftimg00101",
      //       };
      //     })
      //   );
      //   this.marketItems = this.marketItems.concat(items);
      // }

      // if (notSenderTokens) {
      //   const items = await Promise.all(
      //     notSenderTokens.map(async (_item) => {
      //       console.log("url: ", _item.contractUri + "/" + _item.tokenUri);
      //       return {
      //         _$index: _item.marketTokenId,
      //         marketTokenId: _item.marketTokenId,
      //         name: _item.name,
      //         owner: _item.owner,
      //         seller: _item.seller,
      //         mine: false,
      //         contractAddress: _item.contractAddress,
      //         price: _item.price,
      //         tokenId: _item.tokenId,
      //         sold: _item.sold,
      //         url: undefined,
      //         img: "https://tinyurl.com/nftimg00101",
      //       };
      //     })
      //   );
      //   this.marketItems = this.marketItems.concat(items);
      // }


      if (tokens) {
        const items = await Promise.all(
          tokens.map(async (_item) => {

            console.log("url: ", _item.contractUri + "/" + _item.tokenUri);
            return {
              _$index: _item.marketTokenId,
              marketTokenId: _item.marketTokenId,
              name: _item.name,
              owner: _item.owner,
              seller: _item.seller,
              mine: _item.owner === userAddress,
              contractAddress: _item.contractAddress,
              price: _item.price,
              tokenId: _item.tokenId,
              sold: _item.sold,
              url: _item.owner != userAddress ? undefined : _item.contractUri + "/" + _item.tokenUri,
              img: "https://tinyurl.com/nftimg00101",
            };
          })
        );
        this.marketItems = items;
      }

      this.setItemsVisibility();
    },

    async buyToken(token) {
      const web3Modal = new Web3Modal();
      const connection = await web3Modal.connect();
      const provider = new ethers.providers.Web3Provider(connection);
      const signer = provider.getSigner();

      const marketplace = new ethers.Contract(
        MARKETPLACE_ADDRESS,
        Marketplace.abi,
        signer
      );
      try {
        const _price = await new ethers.utils.formatUnits(
          "" + token.price,
          "ether"
        );
        console.log(token.price);
        console.log(token.marketTokenId);
        await marketplace.buyToken(token.marketTokenId, token.contractAddress, {
          value: token.price,
        });

      } catch (e) {
        this.errorMessage = e.message;
        this.openModal("errorModal");
      }
    },
  },
  computed: {
    allTokens() {
      if (this.marketItems.length == 0) this.loadMarketItems();
      this.setItemsVisibility();
      return this.marketItems;
    },
    ownedTokens() {
      if (this.marketItems.length == 0) this.loadMarketItems();
      this.setItemsVisibility();
      return this.marketItems.filter((token) => token.mine);
    },
    forSaleTokens() {
      if (this.marketItems.length == 0) this.loadMarketItems();
      this.setItemsVisibility();
      return this.marketItems.filter((token) => token.sold == false);
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

.modal {
  display: none; /* Hidden by default */
  position: fixed; /* Stay in place */
  z-index: 1; /* Sit on top */
  left: 0;
  top: 0;
  width: 100%; /* Full width */
  height: 100%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
  background-color: rgb(0, 0, 0); /* Fallback color */
  background-color: rgba(0, 0, 0, 0.4); /* Black w/ opacity */
}

/* Modal Content/Box */
.modal-content {
  background-color: #fefefe;
  margin: 15% auto; /* 15% from the top and centered */
  padding: 20px;
  border: 1px solid #888;
  width: 80%; /* Could be more or less, depending on screen size */
}

/* The Close Button */
.close {
  color: #aaa;
  float: right;
  font-size: 28px;
  font-weight: bold;
}

.close:hover,
.close:focus {
  color: black;
  text-decoration: none;
  cursor: pointer;
}
</style>
