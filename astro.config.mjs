// @ts-check
import { defineConfig } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
  vite: {
    plugins: [tailwindcss()]
  },
  build: {
    inlineStylesheets: 'always', 
  },
  redirects: {
    '/signin': 'https://tinyurl.com/SFpat', 
    '/signup': 'https://tinyurl.com/SFpat',
    
    '/line': 'https://tinyurl.com/linesiam',
  },
  site: 'https://mahagame66auto.com'
});