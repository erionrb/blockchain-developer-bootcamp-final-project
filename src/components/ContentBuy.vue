<template>
  <div style="padding: 10px">
    <span>Filter by: </span>
    <button class="filter-btn">Album</button>
    <button class="filter-btn">Media</button>
    <button class="filter-btn">My NFT</button>
  </div>

  <div class="flex three content">
    <div>
      <article class="card">
        <header>
          <div class="flex two three-1000 demo">
            <div><span>NFT Header</span></div>
            <div class="off-third-800 tag" style="">
              <span class="label success">owned</span>
            </div>
          </div>
        </header>
        <img src="https://picnicss.com/img/forest.jpg" />
        <footer>
          <h3>Some NFT Description</h3>
          <button class="nft-button">Buy NFT</button>
        </footer>
      </article>
    </div>

    <div>
      <article class="card">
        <header>
          <div class="flex two three-1000 demo">
            <div><span>NFT Header</span></div>
            <div class="off-third-800 tag" style="">
              <span class="label warning">for sale</span>
            </div>
          </div>
        </header>
        <img src="https://picnicss.com/img/forest.jpg" />
        <footer>
          <h3>Some NFT Description</h3>
          <button class="nft-button">Buy NFT</button>
        </footer>
      </article>
    </div>

    <div>
      <article class="card">
        <header>
          <div class="flex two three-1000 demo">
            <div><span>NFT Header</span></div>
            <div class="off-third-800 tag" style="">
              <span class="label warning">for sale</span>
            </div>
          </div>
        </header>
        <img src="https://picnicss.com/img/forest.jpg" />
        <footer>
          <h3>Some NFT Description</h3>
          <button class="nft-button">Buy NFT</button>
        </footer>
      </article>
    </div>
  </div>
</template>

<script>
export default {
  name: "ContentComp",
  data() {
    return {
      message: "Hello World",
    };
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
</style>
