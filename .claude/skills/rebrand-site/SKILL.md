---
name: rebrand-site
description: Use when the user wants to launch/redesign a new brand on this Astro slot-site template — swapping in a new name, a docx content brief, and reference images (logo/banner/slides) in src/assets, while reusing the existing component library. Triggers on requests like "เว็บใหม่ชื่อ...", "redesign ตาม ref รูปที่แนบมา", "ตรวจสอบ SmoothCarousel/Promotion", or any ask to retheme index.astro from a new brand's assets + docx without deleting existing components.
---

# Rebrand this Astro site to a new brand

This repo is a shared Astro template reused across many Thai slot/casino
client sites (see the `NavbarStyle*`, `FooterStyle*`, `ContentBox*Premium/Cyber/Huay`
variants in `src/components`). "Launching a new brand" means: swap the
content and color palette to match a new client's docx brief and image
assets, while reusing the existing component tree — never deleting or
skipping a component `index.astro` already imports.

Work through these phases in order. Don't skip the verification phase —
every past run of this skill has caught at least one real bug there.

## Phase 1 — Gather brand inputs

1. **Find the brief.** Look for a `.docx` file dropped into `src/assets`
   or `src/components` (past runs named it `<brand>-content.docx`). The
   `Read` tool cannot open `.docx` directly — extract text with a
   zip+regex pass instead:
   ```bash
   unzip -o "<path-to.docx>" -d "$SCRATCHPAD/docx_extract"
   python -c "
   import re
   with open(r'$SCRATCHPAD/docx_extract/word/document.xml', encoding='utf-8') as f:
       xml = f.read()
   paras = re.findall(r'<w:p[ >].*?</w:p>', xml, re.DOTALL)
   out = [''.join(re.findall(r'<w:t[^>]*>(.*?)</w:t>', p, re.DOTALL)) for p in paras]
   print(chr(10).join(out))
   "
   ```
   On Windows/git-bash, pass Windows-style paths (`C:/Users/...`) to
   `python`, not `/c/Users/...` posix paths — the python.exe on this
   box doesn't resolve those. `unzip` may exit 2 with a harmless
   trailing-bytes warning; check the extracted files landed before
   worrying about it.
2. **Read every reference image** in `src/assets` with the `Read` tool
   (it renders images visually) — logo, banner(s), slide(s), bg. Note:
   - the dominant color palette (this becomes the new theme's accent
     colors, replacing the old brand's)
   - the mood/genre (ocean, neon-cyberpunk, gold-luxury, etc.) — this
     drives which existing component *variant* families
     (`*Premium`, `*Cyber`, `*Huay`, plain) best fit, if the user says
     you may pick from the wider component library
   - if the user pastes one specific image path as "ref", treat it as
     the primary hero reference (see Phase 4 hero-selection bug).
3. Confirm the new brand name and check `astro.config.mjs` `site:` —
   it's often already been updated to the new domain before you're
   asked to do the content work.

## Phase 2 — Map docx content onto existing component slots

List every component `src/pages/index.astro` currently imports and
uses. **Never remove one** — if an import is unused (check with Grep
for `<ComponentName` in the JSX body, not just the import line), that's
a bug in the current file: wire it up with real content instead of
deleting the import. (Past run: `Faq`/`FaqHuay` was imported but never
rendered, and its *default* prop content was a leftover FAQ from a
totally different old brand — fixed by passing a `faqs` prop with new
content, not by editing the shared component's defaults.)

Map each docx H1/H2/H3 section onto one existing slot 1:1 — most of
these templates have: hero title, an intro `ContentBox`, a two-column
`ContentBoxTwo` (often a login widget + a stats/provider table), a
three-column `ContentBox3Three`/`ContentBoxThreeColums`, one or two
image+text `ContentBoxSevenThree`/`ContentBox` blocks, a
`ContentBoxSpecial` two-half block, review cards, and a FAQ. Don't
invent new sections or duplicate content across two slots — if the
docx has fewer sections than slots, some slots keep more generic
copy; if it has a specific list of game providers/payment methods,
prefer real values in **both** the provider grid/table props and any
provider-name mentions in prose paragraphs, so they don't contradict.

## Phase 3 — Retheme every component index.astro touches

Identify the old brand's dominant Tailwind color family (grep the
component tree for a repeated hue like `red-` or `rose-`) and the old
brand name string. For every component actually rendered from
`index.astro` (plus the shared layout chrome — `MainLayout.astro`, the
active `Navbar*`/`Footer*`/`Navfoot.astro`), do a full-file `Write`
rewrite (cleaner than dozens of tiny edits) that:
- swaps every occurrence of the old hue family to the new palette's
  matching Tailwind shade number (`red-600` → `cyan-600`, `red-950` →
  `blue-950`, etc.) and matching `rgba(...)` glow values
- leaves unrelated semantic colors alone (LINE green `#00B900`, green
  "live"/success indicators, real bank brand colors) — only the old
  brand's *identity* color should move
- replaces the old brand name in visible text, `alt=`, and any
  hardcoded fallback text (logo fallback headings, footer copyright)

Also grep the whole `src/` tree for the old brand name after this pass
— report (don't silently fix) any hits in pages/components outside
`index.astro`'s scope, since those are likely a separate ask.

## Phase 4 — Fix stale asset references (the actual bug class this skill exists for)

The user will almost always call out `SmoothCarousel.astro` and
`promotion.astro` by name — both hardcode `import`s of specific asset
filenames/extensions that predate the new brand's asset drop, e.g.
`slide1.png` when only `slide1.webp` exists now. Grep for the stale
extension across `src/` and fix every hit, not just the two named
files:
```bash
grep -rlE "slide[0-9]\.png|banner[0-9]?\.png" src/
```

**The glob-selection trap:** `MainLayout.astro` (and similar) often
pick a hero/banner image via
`import.meta.glob("../assets/banner*.{png,webp,jpg,jpeg}")` and just
take `Object.keys(...)[0]`. If old `.png` originals are still sitting
in `src/assets` alongside the new `.webp` drop (common — the asset
swap usually keeps same-name old files around), **alphabetical sort
picks the stale file silently** — no build error, just the wrong
image rendering. Verify this by checking the actual rendered `<img
src>` in Phase 5, not just that the build succeeds. Fix by explicitly
preferring `.webp` and/or the specific file the user referenced as
"ref", with the naive alphabetical pick only as a last-resort fallback.

## Phase 5 — Verify (always do this, it's where bugs surface)

1. `npm run build` — must complete with 0 pages failing. A clean build
   only proves the code compiles, not that content/images are correct.
2. Start `npm run dev`, `curl` the built pages, and grep the rendered
   HTML:
   - old brand name must not appear anywhere in the response body
   - old hue's Tailwind classes must not appear inside any
     `class="..."` attribute (grep separately for `class="[^"]*` vs.
     raw hits — raw hits inside a bundled `<style>` block from an
     out-of-scope component are expected noise, not a bug)
   - every `<img src=.../_image?href=...>` should reference the
     *new* asset filenames — grep for the old ones to make sure the
     Phase 4 glob trap didn't resurface
   - grep for `undefined`, `NaN`, `[object Object]` as a cheap check
     for broken prop plumbing
   - if a FAQ/accordion was wired up, count its item markup to confirm
     all entries rendered
3. Stop the dev server when done (best effort — `pkill`/`taskkill`
   often aren't available in this sandbox; a leftover background dev
   server on port 4321 is harmless, don't fight it).

## Phase 6 — Update the workspec

Keep a `workspec.md` at the repo root as a running log of rebrand work:
goal, docx section inventory, file-by-file change list (grouped:
stale-asset fixes named by the user / layout chrome / component
retheme / content rewrite), the glob/asset bug found and how it was
fixed, verification steps actually run, and an explicit "out of scope"
section listing anything left untouched (other pages still on the old
brand, dead leftover asset files not deleted). Append a new dated
section for follow-up asks (e.g. a later single-component redesign)
rather than rewriting history.

## Phase 7 — Follow-up single-component redesign requests

After the initial rebrand, the user routinely comes back with a narrow
ask on one already-themed component: "re design Announcement6 again",
"เปลี่ยน card แบบใหม่" for the review section, etc. Treat these as a
distinct, smaller task — don't re-run the full rebrand:

1. **Read the file fresh first.** It may have been hand-edited (by the
   user or a formatter) since your last write — don't assume your last
   known version is current.
2. **Scope the change precisely from the user's wording.** "Redesign
   the card" or "เปลี่ยนชื่อ" is about markup/CSS/copy — never touch
   sibling components, the section that renders it, or unrelated
   files unless asked. If the user says "don't change the text/other
   parts anymore" after a prior redesign, that's a hard constraint:
   keep every string in any `const data = [...]` array byte-identical
   (names, roles, review content, numbers) and only rewrite
   markup/CSS. Verify this afterward with a literal grep of the built
   output for a couple of the preserved strings, not just a visual
   diff.
3. **Make the new version visibly different from the last one**, not
   just a recolor — change the actual layout shape (e.g. spotlight +
   list → equal grid with an accent spine, dashed ticket → glowing
   pill capsule). Reusing the exact same div structure with new class
   names isn't a redesign.
4. Reuse the established palette/motifs from Phase 3 (cyan/gold, "Live"
   pulse-dot pattern, porthole/wave/shark visual language) so the new
   version still feels like the same site, not a different brand.
5. Rebuild (`npm run build`) and re-verify per Phase 5 before reporting
   done — a redesign that breaks the build isn't done.
6. Append a dated `## Redesign: <ComponentName>` section to
   `workspec.md` (per Phase 6) describing what changed and why — even
   for a second/third pass on the same component, keep appending, keep
   old entries.
