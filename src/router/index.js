import { createWebHistory, createRouter } from "vue-router";
import ContentBuy from "../components/ContentBuyComp.vue";
import MediaCreation from "../components/CreateMediaComp.vue";
import AlbumCreation from "../components/CreateAlbumComp.vue";
import UserNFTComp from "../components/UserNFTComp.vue";

const routes = [
  {
    path: "/buy",
    name: "Buy",
    component: ContentBuy,
  },
  {
    path: "/album",
    name: "Album",
    component: AlbumCreation,
  },
  {
    path: "/media",
    name: "Media",
    component: MediaCreation,
  },
  {
    path: "/user",
    name: "UserNFT",
    component: UserNFTComp,
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
