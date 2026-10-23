# Move & Metal — site

Static business site for Move & Metal (Jay's junk removal / scrap pickup /
moving-help business, Winnipeg MB). Red/black theme, no build step, no
JavaScript frameworks — plain HTML/CSS/vanilla JS.

Live:
- **https://move-and-metal-site.pages.dev** (Cloudflare Pages, main address; canonical URLs and sitemap point here)
- https://move-and-metal.onrender.com (Render mirror)
- https://jaykk99.github.io/move-and-metal-site/ (GitHub Pages mirror)

Photos are free-licence stock from Pexels, linked from images.pexels.com. Swap in real job photos as they come in.

## Pages

| File | What |
|---|---|
| `index.html` | Home: hero, how-it-works, services grid, pricing tiers, load-size guide, prep-for-pickup guide, ballpark estimator, FAQ (13 Q&As), why-us, areas, contact |
| `services.html` | Per-service detail: what's included, price ranges, take/don't-take lists, service-area breakdown, rush-pickup note |
| `quote.html` | 4-step quote wizard (service → size → details → ballpark) |
| `service-areas.html` | Winnipeg neighbourhoods + surrounding towns served |
| `gallery.html` | Before/after gallery, driven by `gallery-data.js` (empty until real job photos exist) |
| `reviews.html` | Review wall (honest empty state until real reviews come in) + review form that composes an SMS/email on the visitor's own device |
| `blog/` | `index.html` listing + posts: junk-removal cost, scrap-metal pickup, mattress disposal |
| `404.html` | Themed 404 for GitHub Pages |
| `robots.txt` / `sitemap.xml` | Crawl config; sitemap lists all pages |
| `validate.sh` | Quality gate: HTML parse, JSON-LD validity, internal links, sitemap coverage, no em-dashes, phone-number consistency, og:title presence, no lorem, inline-JS syntax |

## Quote wizard (front-end only)

`quote.html` and the estimator on `index.html` compute a ballpark price range
in the browser. **Nothing is sent or stored anywhere** — no POST, no
analytics, no backend. The "Text us this quote" button builds an `sms:` link
with the quote pre-written; the visitor's own messaging app sends it.

## Conventions

- Contact facts: phone/text **204-972-0325** (`tel:+12049720325`, `sms:+12049720325`);
  footer email `metalmoovers@hotmail.com` (stays as-is).
- SEO: LocalBusiness JSON-LD on every content page (+ FAQPage on `index.html`),
  per-page OG/Twitter meta, canonical URLs, per-page meta descriptions, sitemap.
- Mobile: sticky call/text bar under 640px, 400px breakpoint, `prefers-reduced-motion`.
- Validate before pushing: `./validate.sh` must print ALL CHECKS PASSED.

## Validate locally

```bash
./validate.sh   # run before every push; must print ALL CHECKS PASSED
```

## Deploy

Push to `master` — GitHub Pages rebuilds automatically. No build command,
no environment variables.
