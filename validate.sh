#!/usr/bin/env bash
# validate.sh — quality gate for move-and-metal-site. Run before every push.
# Checks: HTML parses, JSON-LD valid, internal links resolve, sitemap covers
# every page, no em-dashes (house style), phone numbers consistent, og:title
# present, no lorem ipsum, inline JS syntax OK.
set -u
cd "$(dirname "$0")"
fail=0
say() { printf '%s\n' "$1"; }
err() { say "FAIL: $1"; fail=1; }

# 1. HTML parse + JSON-LD + links + em-dash + lorem + og:title + phone
python3 - <<'PYEOF'
import glob, re, os, json, sys
from html.parser import HTMLParser

pages = sorted(glob.glob('*.html') + glob.glob('blog/*.html'))
fails = []
def fail(m): fails.append(m)

for fn in pages:
    src = open(fn, encoding='utf-8').read()
    try:
        HTMLParser().feed(src)
    except Exception as e:
        fail('%s: HTML parse error: %s' % (fn, e))
    for m in re.finditer(r'<script type="application/ld\+json">(.*?)</script>', src, re.S):
        try: json.loads(m.group(1))
        except Exception as e: fail('%s: bad JSON-LD: %s' % (fn, str(e)[:80]))
    if '—' in src: fail('%s: contains em-dash' % fn)
    if 'lorem' in src.lower(): fail('%s: contains lorem ipsum' % fn)
    if '<meta property="og:title"' not in src and fn != '404.html':
        fail('%s: missing og:title' % fn)
    for ph in set(re.findall(r'\+?1?[-.\s]?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}', src)):
        digits = re.sub(r'\D', '', ph)
        if digits not in ('12049720325', '2049720325'):
            fail('%s: unexpected phone number %r' % (fn, ph))

class LP(HTMLParser):
    def __init__(self): super().__init__(); self.links = []
    def handle_starttag(self, t, a):
        if t == 'a':
            h = dict(a).get('href', '')
            if h and not h.startswith(('http', 'tel:', 'sms:', 'mailto:', '#', 'data:')):
                self.links.append(h)

for fn in pages:
    base = os.path.dirname(fn)
    lp = LP(); lp.feed(open(fn, encoding='utf-8').read())
    for h in lp.links:
        if not os.path.exists(os.path.normpath(os.path.join(base, h))):
            fail('%s: broken link %s' % (fn, h))

# sitemap coverage (blog/index.html is served at /blog/)
import xml.etree.ElementTree as ET
locs = [u.find('{http://www.sitemaps.org/schemas/sitemap/0.9}loc').text
        for u in ET.parse('sitemap.xml').getroot()]
for fn in pages:
    if fn == '404.html': continue
    url = 'https://jaykk99.github.io/move-and-metal-site/' + (
        '' if fn == 'index.html' else ('blog/' if fn == 'blog/index.html' else fn))
    if url not in locs: fail('%s: missing from sitemap' % fn)

if fails:
    print('\n'.join('FAIL: ' + f for f in fails)); sys.exit(1)
print('python checks OK: %d pages' % len(pages))
PYEOF
[ $? -ne 0 ] && fail=1

# 2. inline JS syntax (node --check via vm compile)
node -e "
const fs=require('fs'), vm=require('vm'), glob=process.argv.slice(2);
let bad=0;
for (const f of glob.flatMap(p=>require('child_process').execSync('ls '+p).toString().trim().split('\n'))) {
  const h=fs.readFileSync(f,'utf8');
  (h.match(/<script>([\s\S]*?)<\/script>/g)||[]).forEach((s,i)=>{
    try{ new vm.Script(s.replace(/<\/?script>/g,'')); }
    catch(e){ console.log('FAIL: '+f+' inline JS #'+i+': '+e.message); bad=1; }
  });
}
if(!bad) console.log('inline JS syntax OK');
process.exit(bad);
" '*.html' 'blog/*.html' || fail=1

if [ "$fail" -ne 0 ]; then say "VALIDATION FAILED"; exit 1; fi
say "ALL CHECKS PASSED"
