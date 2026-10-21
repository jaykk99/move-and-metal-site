# Move & Metal — site

Static business site for Move & Metal (Jay's junk removal / scrap pickup /
moving-help business, Winnipeg MB). Red/black theme, no build step, no
JavaScript frameworks — plain HTML/CSS/vanilla JS.

Live:
- **https://jaykk99.github.io/move-and-metal-site/** (GitHub Pages, auto-deploys on push to master)
- https://move-and-metal-site.pages.dev (Cloudflare Pages mirror)

## Pages

| File | What |
|---|---|
| `index.html` | Home: hero, how-it-works, services grid, pricing tiers, load-size guide, prep-for-pickup guide, FAQ (13 Q&As), why-us, areas, contact |
| `services.html` | Per-service detail: what's included, price ranges, take/don't-take lists, service-area breakdown, rush-pickup note |
| `quote.html` | 4-step quote wizard (service → size → details → ballpark) |
| `404.html` | Themed 404 for GitHub Pages |
| `robots.txt` / `sitemap.xml` | Crawl config; sitemap lists all pages |

## Quote wizard (front-end only)

`quote.html` and the estimator on `index.html` compute a ballpark price range
in the browser. **Nothing is sent or stored anywhere** — no POST, no
analytics, no backend. The "Text us this quote" button builds an `sms:` link
with the quote pre-written; the visitor's own messaging app sends it.

## Conventions

- Contact facts: phone/text **204-972-0325** (`tel:+12049720325`, `sms:+12049720325`);
  footer email `metalmoovers@hotmail.com` (stays as-is).
- SEO: LocalBusiness + FAQPage JSON-LD on `index.html`, canonical URLs,
  per-page meta descriptions, sitemap.
- Mobile: sticky call/text bar under 640px, 400px breakpoint, `prefers-reduced-motion`.
- Validate before pushing: every HTML file must parse clean (see below).

## Validate locally

```bash
python3 - <<'EOF'
from html.parser import HTMLParser
for fn in ('index.html','services.html','quote.html','404.html'):
    p = HTMLParser(); p.feed(open(fn).read())  # raises on bad markup
    print(fn, 'parses OK')
EOF
```

## Deploy

Push to `master` — GitHub Pages rebuilds automatically. No build command,
no environment variables.
