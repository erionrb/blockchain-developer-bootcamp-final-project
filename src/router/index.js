import { createWebHistory, createRouter } from "vue-router";
import ContentBuy from "../components/ContentBuy.vue";
import MediaCreation from "../components/MediaCreation.vue";
import AlbumCreation from "../components/AlbumCreation.vue";

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
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
