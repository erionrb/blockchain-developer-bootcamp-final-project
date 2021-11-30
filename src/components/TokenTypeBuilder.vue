<template>
  <div style="padding: 10px">
    <router-link
      :to="{
        name: 'TokenBuilder',
        params: { contract: contract },
      }"
      class="button button-no-border"
      >Back</router-link
    >
  </div>

  <div class="container content" style="padding: 10px">
    <div>
      <label for="tokenId">Token Id: </label>
      <input id="tokenId" type="text" placeholder="Token' Id" v-model="id" />
      <br /><br />
      <label for="tokenFile">Music: </label>
      <input type="file" name="music" @change="onFileSelected" />
      <img
        v-if="selectedFile"
        src="https://siasky.net/GABcWFNGHh5UpeHLJADge-wBHiK8CltFVLs_TwlA57VIPw"
        style="height: 50vh"
      />
      <button class="nft-button" @click="addTokenType">Create NFT Type</button>
    </div>
  </div>

  <div id="uploadModal" class="modal">
    <!-- Modal content -->
    <div class="modal-content">
      <span class="close" @click="closeModal('uploadModal')">&times;</span>
      <h1>Please wait uploading music..</h1>
    </div>
  </div>

  <div id="successModal" class="modal">
    <!-- Modal content -->
    <div class="modal-content">
      <span
        class="close"
        @click="closeModal('successModal', redirectTokenBuilder)"
        >&times;</span
      >
      <h1>NFT Token Type created</h1>
    </div>
  </div>

  <div id="errorModal" class="modal">
    <!-- Modal content -->
    <div class="modal-content">
      <span class="close" @click="closeModal('errorModal')">&times;</span>
      <h1>{{ errorMessage }}</h1>
    </div>
  </div>
</template>

<script>
import { useRoute } from "vue-router";
import { ethers } from "ethers";
import Web3Modal from "web3modal";
import { create as ipfsHttpClient } from "ipfs-http-client";

import MusichainNFT from "../../artifacts/contracts/nft/MusichainNFT.sol/MusichainNFT.json";
const client = ipfsHttpClient("https://ipfs.infura.io:5001/api/v0");

export default {
  data() {
    return {
      id: 0,
      url: "",
      tokenUri: "",
      selectedFile: undefined,
      contract: undefined,
      uploadModalActivated: false,
      errorMessage: "",
    };
  },
  created() {
    const route = useRoute();
    this.contract = route.params.contract;
  },
  methods: {
    onFileSelected(event) {
      this.openModal("uploadModal");
      this.selectedFile = event.target.files[0];
      this.uploadNftFile();
    },

    openModal(_modalId) {
      var modal = document.getElementById(_modalId);
      modal.style.display = "block";
    },

    closeModal(_modalId, callback) {
      var modal = document.getElementById(_modalId);
      modal.style.display = "none";
      if (callback) callback();
    },

    redirectTokenBuilder() {
      this.$router.push({
        name: "TokenBuilder",
        params: { contract: this.contract },
      });
    },

    async uploadNftFile() {
      const file = this.selectedFile;
      try {
        const added = await client.add(file, {
          progress: (prog) => console.log(`received: ${prog}`),
        });
        const _url = `https://ipfs.infura.io/ipfs/${added.path}`;
        this.url = _url;
        this.tokenUri = added.path;
        console.log(_url);
        this.closeModal("uploadModal");
      } catch (error) {
        console.log("Error uploading image to ipfs: ", error);
      }
    },

    async addTokenType() {
      if (!this.contract) {
        alert("Please go back to Dashboard to get album contract again");
        return;
      }

      const web3Modal = new Web3Modal();
      const connection = await web3Modal.connect();
      const provider = new ethers.providers.Web3Provider(connection);
      const signer = provider.getSigner();

      const nftContract = new ethers.Contract(
        this.contract,
        MusichainNFT.abi,
        signer
      );

      try {
        const tx = await nftContract.addTokenType(this.id, this.tokenUri);
        await tx.wait();
        this.openModal("successModal");
      } catch (error) {
        this.errorMessage = error.message;
        this.openModal("errorModal");
      }
    },
  },
};
</script>

<style scoped>
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
