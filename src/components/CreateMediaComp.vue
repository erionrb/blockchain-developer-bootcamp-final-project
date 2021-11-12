<template>
  <div class="alb-content">
    <div class="alb-crud">
      <h2>NFT Media Creation</h2>
      <fieldset>
        <label for="alb-name">name:</label>
        <input id="alb-name" type="text" placeholder="Name" />
        <label for="alb-url">Base URL:</label>
        <input id="alb-url" type="text" placeholder="URL" />
      </fieldset>
      <br />
      <label for="alb-desc">Description:</label>
      <textarea id="alb-desc" placeholder="Textarea"></textarea>
    </div>
  </div>
</template>

<style scoped>
.alb-content {
  padding: 10px;
}

.alb-crud {
  padding: 10px;
  align-items: center;
  background: #7285A5;
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
