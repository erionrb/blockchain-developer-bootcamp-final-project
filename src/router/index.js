import { createWebHistory, createRouter } from "vue-router";
import Marketplace from "../components/Marketplace.vue";
import TokenBuilder from "../components/TokenBuilder.vue";
import TokenTypeBuilder from "../components/TokenTypeBuilder.vue";
import Album from "../components/ContractBuilder.vue";
import Dashboard from "../components/Dashboard.vue";

const routes = [
  {
    path: "/marketplace",
    name: "Marketplace",
    component: Marketplace,
  },
  {
    path: "/album",
    name: "Album",
    component: Album,
  },
  {
    path: "/dashboard",
    name: "Dashboard",
    component: Dashboard,
  },
  {
    path: "/addnft",
    name: "TokenBuilder",
    component: TokenBuilder
  },
  {
    path: "/addNftType",
    name: "TokenTypeBuilder",
    component: TokenTypeBuilder
  }
]
;

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
