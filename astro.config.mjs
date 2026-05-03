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
    '/register': 'https://tinyurl.com/tarpigpg', 
    '/login': 'https://tinyurl.com/tarpigpg',
    
    '/line': 'https://tinyurl.com/linepigpg',
  },

  site: 'https://xn--45-7ritb3eucc.com',
  integrations: [sitemap()]
});