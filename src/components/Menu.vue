<template>
  <div class="nav-three">
    <nav class="demo nav-content">
      <a class="brand">
        <span class="brand-name">Musichain</span>
      </a>
      <router-link to="/album" class="menuItem">Album</router-link>
      <router-link to="/marketplace" class="menuItem">Marketplace</router-link>
      <router-link to="/dashboard" class="menuItem">My Dashboard</router-link>
    </nav>
  </div>
</template>

<script scoped>
export default {
  name: "HeaderComp",
  data() {
    return {
      title: "HeaderComp",
      message: "Hello Vue!",
    };
  },
  methods: {
    onClick() {
      this.message = "You clicked me!";
    },
  },
};
</script>

<style scoped>
.brand-name {
  font-size: 1.5em;
  font-weight: bold;
  color: #fff;
}

.menuItem {
  display: inline-block;
  padding: 0.5em 1em;
  margin: 0.2em;
  cursor: pointer;
  color: #fff;
  font-size: 1em;
  font-weight: bold;
}

.menuItem:hover {
  color: #111111;
}

.metamask-button {
  color: #fff !important;
  background-color: rgb(255, 72, 0) !important;
  font-weight: bold !important;
  border-radius: 0px !important;
  border: none !important;
}

.metamask-button:hover {
  color: #111111 !important;
  background-color: rgb(253, 176, 145) !important;
}

.nav-three {
  overflow: hidden;
  height: 70px;
}

.nav-content {
  background: #0074d9;
}
</style>
