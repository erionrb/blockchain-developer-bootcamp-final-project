<template>
  <Menu></Menu>
  <router-view></router-view>
</template>

<script>
import Menu from "./components/Menu.vue";

export default {
  name: "App",
  components: { Menu },
};
</script>

<style>
.button-no-border {
  border-radius: 0px !important;
}
</style>
