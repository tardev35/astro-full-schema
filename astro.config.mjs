// @ts-check
import { defineConfig } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';

import sitemap from '@astrojs/sitemap';

// https://astro.build/config
export default defineConfig({
  vite: {
    plugins: [tailwindcss()]
  },

  build: {
    inlineStylesheets: 'always', 
  },

  redirects: {
    '/line': 'https://tinyurl.com/linepigpg'
  },

  site: 'https://xn---88-3mlb0cgdfwtee4czmi4ztb.com',
  integrations: [sitemap()]
});