<template>
  <v-app>
    <!-- <v-navigation-drawer app>
  </v-navigation-drawer> -->

    <v-app-bar app>
      <!-- -->
      <v-toolbar-title
        ><a
          href="/"
          :style="{
            color: 'inherit',
            textDecoration: 'inherit',
          }"
          >Youtube-shuffle</a
        ></v-toolbar-title
      >

      <v-spacer />
      <span>shuffle and mix large Youtube playlists</span>
      <v-spacer />
      <div ref="coffeeHolder">
        <a href="https://www.buymeacoffee.com/boucaud" target="_blank"
          ><v-img
            src="https://cdn.buymeacoffee.com/buttons/v2/default-red.png"
            alt="Buy Me A Coffee"
            style="height: 60px !important; width: 217px !important"
        /></a>
      </div>
      <v-btn
        icon
        href="https://github.com/boucaud/youtube-shuffle"
        target="_blank"
        rel="noopener"
      >
        <v-icon>{{ githubIcon }}</v-icon>
      </v-btn>
    </v-app-bar>

    <!-- Provides the application the proper gutter -->
    <v-main>
      <ResponsiveLayout v-if="urlIdArray && urlIdArray.length">
        <template v-slot:player>
          <YoutubeVideo />
        </template>
        <template v-slot:playlist-information>
          <PlaylistInformation />
        </template>
        <template v-slot:playlist>
          <YoutubePlaylist />
        </template>
        <template v-slot:controls>
          <PlaybackSettings />
        </template>
      </ResponsiveLayout>
      <URLInput v-else />
    </v-main>

    <v-footer app>
      <!-- -->
    </v-footer>
  </v-app>
</template>

<script>
import PlaybackSettings from "@components/media/PlaybackSettings";
import URLInput from "@components/selection/URLInput";
import YoutubePlaylist from "@components/media/YoutubePlaylist";
import YoutubeVideo from "@components/media/YoutubeVideo";
import PlaylistInformation from "@components/media/PlaylistInformation";

import ResponsiveLayout from "@components/layouts/ResponsiveLayout";

import { mapActions, mapGetters } from "vuex";

import { mdiGithub } from "@mdi/js";

export default {
  name: "YoutubeShuffle",
  components: {
    ResponsiveLayout,
    PlaybackSettings,
    PlaylistInformation,
    URLInput,
    YoutubePlaylist,
    YoutubeVideo,
  },
  data: () => ({
    githubIcon: mdiGithub,
    origin: window.origin,
  }),
  computed: {
    ...mapGetters({ darkTheme: "getDarkTheme", urlIdArray: "getUrlIdArray" }),
  },
  watch: {
    darkTheme(val) {
      this.$vuetify.theme.dark = val;
    },
    urlIdArray() {
      this.requestVideoArray();
    },
  },
  mounted() {
    this.handleLocation();
    this.$vuetify.theme.dark = this.darkTheme;
    const darkTheme = window.localStorage.getItem('darkTheme');
    if (darkTheme) {
      this.$store.commit('setDarkTheme', true);
    }
  },
  methods: {
    ...mapActions(["handleLocation", "requestVideoArray"]),
  },
  metaInfo: () => {
    if (
      process.env.NODE_ENV === "production" &&
      window.location.host === "youtube-shuffle.boucaud.dev"
    ) {
      return {
        script: [
          {
            src: "https://plausible.boucaud.dev/js/plausible.js",
            async: true,
            defer: true,
            dataDomain: window.location.host,
          },
        ],
      };
    }
    return null;
  },
};
</script>

<style>
</style>