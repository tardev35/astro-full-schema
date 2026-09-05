// @ts-check
import { defineConfig } from "astro/config";

import tailwindcss from "@tailwindcss/vite";

import sitemap from "@astrojs/sitemap";

import { readFile } from "node:fs/promises";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

const DIST = fileURLToPath(new URL("./dist/", import.meta.url));

// Bank and provider marks render at 30px; the smallest thing worth submitting
// is a game cover at 221.
const MIN_INDEXED_WIDTH = 200;

// Astro emits name.SOURCEHASH_VARIANTHASH.ext — one source image per srcset
// width. Dropping the trailing variant hash collapses them back to one entry.
const VARIANT_HASH = /_[^_./]+(\.[a-z0-9]+)$/i;

const attr = (tag, name) => (tag.match(new RegExp(`\\s${name}="([^"]*)"`, "i")) || [])[1] || "";

async function indexedImages(pageUrl) {
  let html;
  try {
    html = await readFile(join(DIST, decodeURIComponent(new URL(pageUrl).pathname), "index.html"), "utf8");
  } catch {
    return [];
  }

  const widest = new Map();
  for (const [tag] of html.matchAll(/<img\b[^>]*>/g)) {
    const src = attr(tag, "src");
    const width = Number(attr(tag, "width")) || 0;
    if (!src || !attr(tag, "alt").trim() || width < MIN_INDEXED_WIDTH) continue;

    const url = new URL(src, pageUrl).href;
    const key = url.replace(VARIANT_HASH, "$1");
    if (!widest.has(key) || width > widest.get(key).width) widest.set(key, { url, width });
  }

  return [...widest.values()].sort((a, b) => b.width - a.width).map(({ url }) => ({ url }));
}

// https://astro.build/config
export default defineConfig({
  vite: {
    plugins: [tailwindcss()],
  },

  image: {
    service: { entrypoint: "./tools/avif-quality-service.mjs" },
  },

  build: {
    // "auto" (Astro's default) externalises anything over ~4 kB and keeps the
    // genuinely tiny page-level blocks inline.
    //
    // This used to be "always", which is a good setting for a small stylesheet
    // and a bad one for this project's: the sheet is ~227 kB, so 82% of every
    // byte of HTML the site shipped was the same CSS pasted into each page —
    // 1.83 MB across the build, none of it cacheable, and re-downloaded on
    // every navigation. It also pushed the hero <img> ~230 kB down the
    // document, so the preload scanner reached the LCP image late on the one
    // request where it matters.
    //
    // The trade is one render-blocking request on a cold visit. With
    // public/_headers marking /_astro/* immutable for a year, that is paid once
    // per visitor instead of once per page view.
    inlineStylesheets: "auto",
  },

  redirects: {
    "/line": "https://tinyurl.com/suhng",
  },

  site: "https://pigauto-main.net",
  integrations: [
    sitemap({
      // /login, /register and /line are forwarding pages that all ship
      // noindex. Listing a noindex URL in the sitemap is a contradiction —
      // it asks Google to crawl a page it is simultaneously told to drop, and
      // Search Console reports it as "Submitted URL marked noindex". These
      // three are also the only pages carrying the affiliate and LINE short
      // links, so there is nothing here to gain from the crawl either.
      // Match against the pathname, anchored at the front. The old form tested
      // the whole URL unanchored, so a future page whose path merely ENDED in
      // one of these words — /promotion/login, say — would have been dropped
      // from the sitemap silently.
      filter: (page) => !/^\/(login|register|line)\/?$/.test(new URL(page).pathname),

      // Only <image:loc> is emitted: Google deprecated caption, title,
      // geo_location and license in May 2022 and ignores them now.
      serialize: async (item) => {
        const img = await indexedImages(item.url);
        return img.length ? /** @type {any} */ ({ ...item, img }) : item;
      },
    }),
  ],
});
