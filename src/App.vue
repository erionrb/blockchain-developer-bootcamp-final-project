<template>
  <HeaderComp></HeaderComp>
  <router-view></router-view>
</template>

<script scoped>
import HeaderComp from "./components/HeaderComp.vue";

export default {
  name: "App",
  components: { HeaderComp },
};
</script>
