/* =====================================================================
   Çeviri ve katalog kontrolü / Translation & catalog check
   Kullanım (Node.js gerekir):   node tools/check-i18n.js
   Kontroller:
   - Tüm sayfalardaki (index, guides/, her rehber sayfası, packing-list/)
     ve catalog.js şablonlarındaki her metin anahtarı 5 dilde dolu mu?
   - Diller arasında eksik/fazla anahtar, {n}/{store} yer tutucuları
   - Kısa mesajlar (messages) her dilde tam mı?
   - Katalog (guides.js) ve Amazon listesi (packing.js) geçerli mi?
   - Her rehberin sayfası üretilmiş mi, hreflang ve sitemap tam mı?
   Sorun yoksa "OK" yazar; varsa listeler ve hata koduyla çıkar.
   Opsiyonel çeviri eksikleri (rehber metni vb.) sadece bilgi olarak yazılır.
   ===================================================================== */
'use strict';
const fs = require('fs');
const path = require('path');
const vm = require('vm');

const root = path.join(__dirname, '..');
const read = (f) => fs.readFileSync(path.join(root, f), 'utf8');
const exists = (f) => fs.existsSync(path.join(root, f));

const ctx = {};
ctx.window = ctx;
vm.createContext(ctx);
['assets/js/config.js', 'assets/js/i18n.js', 'assets/data/guides.js', 'assets/data/packing.js', 'assets/data/posts.js']
  .forEach((f) => vm.runInContext(read(f), ctx, { filename: f }));
const I18N = ctx.NSG_I18N, CAT = ctx.NSG_CATALOG, PACK = ctx.NSG_PACKING, CFG = ctx.NSG_CONFIG;
const POSTS = ctx.NSG_POSTS || [];
const langs = Object.keys(I18N.languages);
const problems = [];
const info = [];

/* ---------- pages ---------- */
const pages = ['index.html', 'guides/index.html', 'packing-list/index.html']
  .concat(CAT.guides.map((g) => `guides/${g.slug}/index.html`))
  .concat(POSTS.length ? ['blog/index.html'] : [], POSTS.map((p) => `blog/${p.slug}/index.html`));
const keys = new Set(['meta.title', 'meta.description'].concat(POSTS.length ? ['blog.toc'] : []));
pages.forEach((p) => {
  if (!exists(p)) { problems.push(`${p} yok / missing → run: node tools/build-guides.js`); return; }
  const html = read(p);
  html.replace(/data-i18n="([^"]+)"/g, (_, k) => keys.add(k));
  html.replace(/data-i18n-attr="([^"]+)"/g, (_, v) => v.split(';').forEach((pair) => {
    const k = (pair.split(':')[1] || '').trim(); if (k) keys.add(k);
  }));
  html.replace(/data-(?:title|desc)-key="([^"]+)"/g, (_, k) => { if (k !== 'none') keys.add(k); });
  langs.concat(['x-default']).forEach((l) => {
    if (!html.includes(`hreflang="${l}"`)) problems.push(`${p}: hreflang="${l}" missing`);
  });
});

/* ---------- keys used by JS templates (catalog.js: t(lang, 'key')) ---------- */
const catalogSrc = read('assets/js/catalog.js') + '\n' + (exists('assets/js/blog.js') ? read('assets/js/blog.js') : '');
catalogSrc.replace(/\bt\(\s*lang\s*,([^)]*)\)/g, (_, args) => {
  args.replace(/'([a-zA-Z]+\.[a-zA-Z0-9.]+)'/g, (__, k) => keys.add(k));
});

/* ---------- strings in every language ---------- */
const S = I18N.strings;
langs.forEach((l) => {
  const dict = S[l];
  if (!dict) { problems.push(`[${l}] strings block missing`); return; }
  keys.forEach((k) => {
    if (typeof dict[k] !== 'string' || dict[k].trim() === '') problems.push(`[${l}] missing: ${k}`);
  });
  Object.keys(dict).forEach((k) => {
    if (!(k in S.en)) problems.push(`[${l}] extra key not in English: ${k}`);
    ['{n}', '{store}'].forEach((ph) => {
      if (S.en[k] && S.en[k].includes(ph) && !dict[k].includes(ph)) problems.push(`[${l}] ${k}: placeholder ${ph} missing`);
    });
  });
});
Object.keys(S.en).forEach((k) => { if (!keys.has(k)) info.push(`unused English key (not on any page): ${k}`); });

/* ---------- JS messages ---------- */
const msgKeys = Object.keys(I18N.messages.en || {});
langs.forEach((l) => {
  const m = I18N.messages[l];
  if (!m) { problems.push(`[${l}] messages block missing`); return; }
  msgKeys.forEach((k) => { if (typeof m[k] !== 'string' || !m[k].trim()) problems.push(`[${l}] missing message: ${k}`); });
  if (!I18N.ogLocale || !I18N.ogLocale[l]) problems.push(`[${l}] ogLocale missing`);
});
const mainSrc = read('assets/js/main.js');
mainSrc.replace(/\bmsg\('([a-zA-Z]+)'\)/g, (_, k) => { if (!msgKeys.includes(k)) problems.push(`main.js uses message '${k}' which is missing in messages.en`); });

/* ---------- catalog ---------- */
const slugs = new Set();
CAT.guides.forEach((g, i) => {
  const w = `guides.js #${i + 1} (${g.slug})`;
  if (slugs.has(g.slug)) problems.push(`${w}: duplicate slug`);
  slugs.add(g.slug);
  const en = g.text && g.text.en;
  if (!en || !en.title || !en.description || !(en.highlights || []).length) problems.push(`${w}: text.en title/description/highlights required`);
  langs.filter((l) => l !== 'en').forEach((l) => {
    const t = g.text && g.text[l];
    if (!t) info.push(`${w}: no ${l} text (English is shown)`);
    else ['title', 'description', 'highlights'].forEach((f) => { if (!t[f] || (Array.isArray(t[f]) && !t[f].length)) info.push(`${w}: ${l}.${f} missing (English is shown)`); });
  });
  const d = CAT.destinations[g.destination];
  if (!d && !g.destinationName) problems.push(`${w}: unknown destination '${g.destination}'`);
  if (d) {
    langs.forEach((l) => { if (!d.name[l]) problems.push(`destinations.${g.destination}: name.${l} missing`); });
    const r = CAT.regions[d.region];
    if (!r) problems.push(`destinations.${g.destination}: unknown region '${d.region}'`);
    else langs.forEach((l) => { if (!r[l]) problems.push(`regions.${d.region}: ${l} missing`); });
  }
});

/* ---------- packing list ---------- */
const ids = new Set();
PACK.items.forEach((it, i) => {
  const w = `packing.js #${i + 1} (${it.id})`;
  if (!it.id || !/^[a-z0-9-]+$/.test(it.id)) problems.push(`${w}: id must be lowercase-with-dashes`);
  if (ids.has(it.id)) problems.push(`${w}: duplicate id`);
  ids.add(it.id);
  if (!it.text || !it.text.en || !it.text.en.name) problems.push(`${w}: text.en.name required`);
  langs.filter((l) => l !== 'en').forEach((l) => { if (!it.text || !it.text[l]) info.push(`${w}: no ${l} text (English is shown)`); });
  if (!PACK.categories[it.category]) problems.push(`${w}: unknown category '${it.category}'`);
});
Object.keys(PACK.categories).forEach((c) => langs.forEach((l) => { if (!PACK.categories[c][l]) problems.push(`packing categories.${c}: ${l} missing`); }));

/* ---------- blog posts ---------- */
const postSlugs = new Set();
POSTS.forEach((p, i) => {
  const w = `posts.js #${i + 1} (${p.slug})`;
  if (postSlugs.has(p.slug)) problems.push(`${w}: duplicate slug`);
  postSlugs.add(p.slug);
  langs.forEach((l) => {
    const t = p.text && p.text[l];
    if (!t || !t.title || !t.description) problems.push(`${w}: ${l} title/description missing`);
  });
  ['en', 'tr'].forEach((l) => {
    if (!exists(`content/blog/${p.slug}/${l}.md`)) problems.push(`${w}: content/blog/${p.slug}/${l}.md missing (full ${l} article required)`);
  });
  langs.filter((l) => !['en', 'tr'].includes(l)).forEach((l) => {
    if (!exists(`content/blog/${p.slug}/${l}.md`)) info.push(`${w}: no ${l}.md → English body + "available in English" note`);
  });
  (p.guides || []).forEach((s) => { if (!CAT.guides.some((g) => g.slug === s)) problems.push(`${w}: unknown guide '${s}'`); });
  if (exists(`content/blog/${p.slug}/en.md`)) {
    const words = read(`content/blog/${p.slug}/en.md`).replace(/\]\([^)]*\)/g, ']').split(/\s+/).filter(Boolean).length;
    if (words < 600) info.push(`${w}: English article is short (${words} words)`);
  }
});

/* ---------- sitemap ---------- */
const sitemap = exists('sitemap.xml') ? read('sitemap.xml') : '';
const site = CFG.site.url.replace(/\/$/, '');
[site + '/', site + '/guides/'].concat(CAT.guides.map((g) => `${site}/guides/${g.slug}/`))
  .concat(POSTS.length ? [site + '/blog/'] : [], POSTS.map((p) => `${site}/blog/${p.slug}/`)).forEach((u) => {
  langs.forEach((l) => {
    const loc = u + (l === 'en' ? '' : '?lang=' + l);
    if (!sitemap.includes(`<loc>${loc}</loc>`)) problems.push(`sitemap.xml: ${loc} missing → run build`);
  });
});

/* ---------- report ---------- */
console.log(`Languages: ${langs.join(', ')}`);
console.log(`Pages checked: ${pages.length} | text keys used: ${keys.size} | messages: ${msgKeys.length} | guides: ${CAT.guides.length} | packing items: ${PACK.items.length} | blog posts: ${POSTS.length}`);
langs.forEach((l) => console.log(`  ${l}: ${Object.keys(S[l] || {}).length} strings, ${Object.keys(I18N.messages[l] || {}).length} messages`));
if (info.length) console.log(`\nInfo (${info.length}):\n - ` + info.join('\n - '));
if (problems.length) {
  console.log(`\nPROBLEMS (${problems.length}):\n - ` + problems.join('\n - '));
  process.exit(1);
}
console.log(`\nOK — every key has a value in all ${langs.length} languages.`);
