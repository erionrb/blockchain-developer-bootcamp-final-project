<template>
  <div class="contract-content">
    <div><button class="primary" @click="fillValues">Mock 1</button></div>
    <div class="contract-crud">
      <h2>Create a new Album</h2>
      <fieldset>
        <label for="contract-name">Name:</label>
        <input
          id="contract-name"
          type="text"
          placeholder="Name"
          v-model="name"
        />
        <!-- <label for="contract-url">Base URL:</label>
        <input id="contract-url" type="text" placeholder="URL" v-model="url" /> -->
      </fieldset>
      <br />
      <label for="contract-desc">Description:</label>
      <textarea
        id="contract-desc"
        placeholder="Album description..."
        v-model="desc"
      />
    </div>
    <p class="info">
      *** Each new album will represent a whole new NFT smart contract in the
      marketplace
    </p>
    <div>
      <button class="primary" @click="createNFTContract">Create</button>
    </div>
  </div>

  <div id="commonModal" class="modal">
    <!-- Modal content -->
    <div class="modal-content">
      <span
        class="close"
        @click="closeModal('commonModal', redirectToDashboard)"
        >&times;</span
      >
      <h1>Contract Created</h1>
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
import MusichainNFT from "../../artifacts/contracts/nft/MusichainNFT.sol/MusichainNFT.json";

const MARKETPLACE_ADDRESS = process.env.VUE_APP_MARKETPLACE_ADDRESS;

export default {
  data() {
    return {
      url: "https://ipfs.infura.io/ipfs",
      name: "",
      desc: "",
      errorMessage: "",
    };
  },
  methods: {
    openModal(_modalId) {
      var modal = document.getElementById(_modalId);
      modal.style.display = "block";
    },

    closeModal(_modalId, callback) {
      var modal = document.getElementById(_modalId);
      modal.style.display = "none";
      callback();
    },

    redirectToDashboard() {
      this.$router.push("/dashboard");
    },

    fillValues() {
      this.name = "Life Starts Now";
      this.desc =
        "Life Starts Now is the third studio album by Canadian rock band Three Days Grace. The album was released on September 22, 2009. The album was produced by Howard Benson. This is the second time in a row the band has worked with him, after the commercially successful One-X. Life Starts Now expresses a lighter lyrical mood compared to the band's previous album. It is the first Three Days Grace album to be released under Sony Music Entertainment and the last to be released through Jive Records, as Sony disbanded the label in 2011.";
    },

    async createNFTContract() {
      const web3Modal = new Web3Modal();
      const connection = await web3Modal.connect();
      const provider = new ethers.providers.Web3Provider(connection);
      const signer = provider.getSigner();
      //const userAddress = await signer.getAddress();

      // Marketplace contract
      const marketplace = new ethers.Contract(
        MARKETPLACE_ADDRESS,
        Marketplace.abi,
        signer
      );

      try {
        // Create a new NFT contract
        let tx = await marketplace.addContract(this.url, this.name, this.desc);
        const result = await tx.wait();
        console.log(result);

        // Log event result
        // let logs = result.events.filter(
        //   (e) => e.event === "MarketplaceContractAdded"
        // );
        // const { _seller, _contract } = logs[0].args;
        // console.log(`_seller> ${_seller}`);
        // console.log(`_contract> ${_contract}`);

        this.openModal("commonModal");
      } catch (e) {
        this.errorMessage = e.message;
        this.openModal("errorModal");
      }
    },
  },
};
</script>

<style scoped>
.contract-content {
  padding: 10px;
}

.contract-crud {
  padding: 10px;
  align-items: center;
  background: white;
  border-radius: 0.2em;
  border: 1px solid black;
  font-weight: bold;
  color: black;
}

.content {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  padding: 10px;
  padding-left: 10px;
}

.info {
  font-weight: bold;
  font-size: 10px;
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
