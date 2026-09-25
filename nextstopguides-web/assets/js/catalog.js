/* =====================================================================
   NextStopGuides — catalog.js
   ---------------------------------------------------------------------
   Renders itinerary cards, the searchable/filterable catalog, guide-page
   language swaps, related guides and the Amazon packing list.
   The same card/packing templates are used by tools/build-guides.js to
   write static (SEO) HTML, so pages look identical with or without JS.
   Data: assets/data/guides.js, assets/data/packing.js · Text: i18n.js
   Load order: config.js → i18n.js → data files → catalog.js → main.js
   ===================================================================== */
(function (root) {
  'use strict';

  /* ---------------------------- helpers ---------------------------- */
  function isPlaceholder(v) { return typeof v !== 'string' || v.trim() === '' || v.indexOf('BURAYA_') === 0; }
  function isUrl(v) { return !isPlaceholder(v) && /^https?:\/\//i.test(v.trim()); }

  function esc(s) {
    return String(s == null ? '' : s)
      .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
  }

  function strings() { return (root.NSG_I18N && root.NSG_I18N.strings) || {}; }
  function data() { return root.NSG_CATALOG || { guides: [], destinations: {}, regions: {} }; }
  function packing() { return root.NSG_PACKING || { items: [], categories: {} }; }

  /* Translated UI string with English fallback; {n} → number */
  function t(lang, key, n) {
    var s = strings();
    var v = (s[lang] && s[lang][key] !== undefined) ? s[lang][key]
      : (s.en && s.en[key] !== undefined ? s.en[key] : key);
    return n === undefined ? v : String(v).replace(/\{n\}/g, n);
  }

  /* Guide text in a language, field by field falling back to English */
  function guideText(g, lang) {
    var en = (g.text && g.text.en) || {};
    var l = (g.text && g.text[lang]) || {};
    return {
      title: l.title || en.title || g.slug,
      description: l.description || en.description || '',
      highlights: (l.highlights && l.highlights.length) ? l.highlights : (en.highlights || [])
    };
  }

  function destName(g, lang) {
    if (g.destinationName) return g.destinationName[lang] || g.destinationName.en;
    var d = data().destinations[g.destination];
    if (!d) return String(g.destination || '').replace(/-/g, ' ').replace(/\b\w/g, function (c) { return c.toUpperCase(); });
    return d.name[lang] || d.name.en;
  }

  function regionOf(g) {
    if (g.region) return g.region;
    var d = data().destinations[g.destination];
    return d ? d.region : 'other';
  }

  function regionName(key, lang) {
    var r = data().regions[key];
    return r ? (r[lang] || r.en) : key;
  }

  /* Etsy thumbnails (il_340x270) → larger square version for guide pages / social images */
  function largeImage(url) { return String(url || '').replace(/\/il_\d+x\d+\./, '/il_794xN.'); }
  function socialImage(url) { return String(url || '').replace(/\/il_\d+x\d+\./, '/il_1200x1200.'); }

  function guideHref(base, slug) { return base + 'guides/' + slug + '/'; }

  function requestHref(base) {
    var c = (root.NSG_CONFIG && root.NSG_CONFIG.contact) || {};
    if (!isPlaceholder(c.email) && c.email.indexOf('@') > 0) {
      return 'mailto:' + c.email + '?subject=' + encodeURIComponent('Destination request — NextStopGuides');
    }
    return base + '#newsletter';
  }

  function sortGuides(list, mode, lang) {
    var out = list.slice();
    if (mode === 'daysAsc') out.sort(function (a, b) { return a.days - b.days; });
    else if (mode === 'daysDesc') out.sort(function (a, b) { return b.days - a.days; });
    else if (mode === 'az') out.sort(function (a, b) { return guideText(a, lang).title.localeCompare(guideText(b, lang).title, lang); });
    return out;
  }

  /* ---------------------------- templates ---------------------------- */
  function cardHTML(g, lang, base) {
    var tx = guideText(g, lang);
    var href = guideHref(base, g.slug);
    var price = isPlaceholder(g.price) ? '' : g.price;
    var h = '';
    h += '<article class="card-lift relative flex flex-col overflow-hidden rounded-3xl border border-ink/10 bg-white" data-slug="' + esc(g.slug) + '">';
    h += '<div class="aspect-[4/3] overflow-hidden bg-sand-100">';
    h += '<img src="' + esc(g.image) + '" alt="' + esc(tx.title) + '" width="340" height="270" loading="lazy" decoding="async" class="h-full w-full object-cover">';
    h += '</div>';
    h += '<div class="flex flex-1 flex-col p-5 sm:p-6">';
    h += '<div class="flex flex-wrap items-center gap-2 text-xs font-semibold">';
    h += '<span class="rounded-full bg-ocean-50 px-2.5 py-1 text-ocean-800">' + esc(destName(g, lang)) + '</span>';
    h += '<span class="rounded-full bg-sand-100 px-2.5 py-1 text-ink">' + esc(t(lang, 'card.days', g.days)) + '</span>';
    h += '</div>';
    h += '<h3 class="mt-3 font-display text-xl font-bold leading-snug"><a href="' + esc(href) + '" class="transition after:absolute after:inset-0 hover:text-ocean-700">' + esc(tx.title) + '</a></h3>';
    h += '<p class="mt-2 text-sm leading-relaxed text-ink-soft">' + esc(tx.description) + '</p>';
    if (g.cities && g.cities.length) {
      h += '<p class="mt-3 text-xs font-medium text-ink-soft"><span aria-hidden="true">📍</span> ' + esc(g.cities.join(' · ')) + '</p>';
    }
    h += '<div class="mt-auto pt-5">';
    if (price) h += '<p class="font-display text-2xl font-extrabold">' + esc(price) + '</p>';
    h += '<div class="relative z-10 mt-3 grid gap-2">';
    if (isUrl(g.etsy)) {
      h += '<a href="' + esc(g.etsy) + '" target="_blank" rel="noopener" class="rounded-full bg-ink px-4 py-2.5 text-center text-sm font-semibold text-white transition hover:bg-ink/85">'
        + esc(t(lang, price ? 'card.buyEtsy' : 'card.viewEtsy')) + ' <span aria-hidden="true">↗</span></a>';
    }
    if (isUrl(g.shopier)) {
      h += '<a href="' + esc(g.shopier) + '" target="_blank" rel="noopener" class="rounded-full border-2 border-ocean-700 px-4 py-2 text-center text-sm font-semibold text-ocean-700 transition hover:bg-ocean-700 hover:text-white">'
        + esc(t(lang, 'card.shopier')) + (isPlaceholder(g.priceTRY) ? '' : ' <span class="whitespace-nowrap">· ' + esc(g.priceTRY) + '</span>') + ' <span aria-hidden="true">↗</span></a>';
    }
    h += '<a href="' + esc(href) + '" class="py-1 text-center text-sm font-semibold text-ocean-700 underline-offset-4 hover:underline">' + esc(t(lang, 'card.details')) + ' <span aria-hidden="true">→</span></a>';
    h += '</div></div></div></article>';
    return h;
  }

  function soonCardHTML(lang, base) {
    return '<article class="flex flex-col items-start justify-center rounded-3xl border-2 border-dashed border-ocean-300 bg-ocean-50/60 p-6 sm:p-7">'
      + '<span class="text-4xl" aria-hidden="true">🧭</span>'
      + '<h3 class="mt-4 font-display text-xl font-bold">' + esc(t(lang, 'soon.title')) + '</h3>'
      + '<p class="mt-2 text-sm leading-relaxed text-ink-soft">' + esc(t(lang, 'soon.desc')) + '</p>'
      + '<a href="' + esc(requestHref(base)) + '" class="mt-5 inline-flex items-center gap-2 rounded-full bg-ocean-700 px-5 py-2.5 text-sm font-semibold text-white transition hover:bg-ocean-800">'
      + esc(t(lang, 'soon.cta')) + ' <span aria-hidden="true">→</span></a>'
      + '</article>';
  }

  function relatedFor(slug, limit) {
    var all = data().guides;
    var cur = all.filter(function (g) { return g.slug === slug; })[0];
    if (!cur) return [];
    return all.filter(function (g) { return g.slug !== slug; })
      .sort(function (a, b) {
        var sa = (a.destination === cur.destination ? 0 : 1000) + Math.abs(a.days - cur.days);
        var sb = (b.destination === cur.destination ? 0 : 1000) + Math.abs(b.days - cur.days);
        return sa - sb;
      })
      .slice(0, limit || 3);
  }

  /* Amazon store per language: amazon.com.tr for Turkish, amazon.com for everyone else */
  var STORES = { us: 'Amazon.com', tr: 'Amazon.com.tr' };
  function itemLinks(it) {
    var l = it.links || {};
    return { us: isUrl(l.us) ? l.us : '', tr: isUrl(l.tr) ? l.tr : '' };
  }
  function liveItems() { return packing().items.filter(function (it) { var l = itemLinks(it); return !!(l.us || l.tr); }); }

  function packingHTML(lang) {
    var items = liveItems();
    if (!items.length) {
      return '<p class="rounded-3xl bg-white p-8 text-center text-ink-soft ring-1 ring-ink/5">' + esc(t(lang, 'pk.empty')) + '</p>';
    }
    var cats = packing().categories;
    var order = Object.keys(cats);
    items.forEach(function (it) { if (order.indexOf(it.category) === -1) order.push(it.category); });
    var h = '';
    order.forEach(function (cat) {
      var group = items.filter(function (it) { return it.category === cat; });
      if (!group.length) return;
      var cname = cats[cat] ? (cats[cat][lang] || cats[cat].en) : cat;
      h += '<section class="mt-12 first:mt-0"><h2 class="font-display text-2xl font-bold">' + esc(cname) + '</h2>';
      h += '<ul class="mt-5 grid gap-4 sm:grid-cols-2">';
      group.forEach(function (it) {
        var tx = (it.text && (it.text[lang] || it.text.en)) || {};
        var en = (it.text && it.text.en) || {};
        var links = itemLinks(it);
        var primary = lang === 'tr' ? (links.tr ? 'tr' : 'us') : (links.us ? 'us' : 'tr');
        var secondary = primary === 'us' ? 'tr' : 'us';
        h += '<li id="' + esc(it.id) + '" data-deeplink class="pk-item flex scroll-mt-24 gap-4 rounded-3xl bg-white p-5 ring-1 ring-ink/5">'
          + '<span class="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-sand-100 text-2xl" aria-hidden="true">' + esc(it.emoji || '🧳') + '</span>'
          + '<div class="min-w-0 flex-1"><h3 class="font-semibold leading-snug">' + esc(tx.name || en.name) + '</h3>'
          + '<p class="mt-1 text-sm leading-relaxed text-ink-soft">' + esc(tx.why || en.why || '') + '</p>'
          + '<div class="mt-4 flex flex-wrap items-center gap-x-4 gap-y-2">'
          + '<a href="' + esc(links[primary]) + '" target="_blank" rel="sponsored nofollow noopener" class="inline-flex items-center gap-1.5 rounded-full bg-ink px-4 py-2 text-sm font-semibold text-white transition hover:bg-ink/85">'
          + esc(t(lang, 'pk.ctaStore').replace('{store}', STORES[primary])) + ' <span aria-hidden="true">↗</span></a>';
        if (links[secondary]) {
          h += '<a href="' + esc(links[secondary]) + '" target="_blank" rel="sponsored nofollow noopener" class="text-xs font-semibold text-ocean-700 underline-offset-4 hover:underline">'
            + esc(t(lang, 'pk.also').replace('{store}', STORES[secondary])) + '</a>';
        }
        h += '</div></div></li>';
      });
      h += '</ul></section>';
    });
    return h;
  }

  function norm(s) {
    return String(s || '').toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '').replace(/ı/g, 'i');
  }

  function haystack(g) {
    var parts = [g.slug, g.days + ' days', String(g.days)].concat(g.cities || [], g.tags || []);
    Object.keys(g.text || {}).forEach(function (l) { parts.push(g.text[l].title, g.text[l].description); });
    var d = data().destinations[g.destination];
    if (d) Object.keys(d.name).forEach(function (l) { parts.push(d.name[l]); });
    if (g.destinationName) Object.keys(g.destinationName).forEach(function (l) { parts.push(g.destinationName[l]); });
    var r = data().regions[regionOf(g)];
    if (r) Object.keys(r).forEach(function (l) { parts.push(r[l]); });
    return norm(parts.join(' '));
  }

  var api = {
    isPlaceholder: isPlaceholder, isUrl: isUrl, esc: esc, t: t,
    guideText: guideText, destName: destName, regionOf: regionOf, regionName: regionName,
    largeImage: largeImage, socialImage: socialImage, guideHref: guideHref,
    sortGuides: sortGuides, cardHTML: cardHTML, soonCardHTML: soonCardHTML,
    relatedFor: relatedFor, liveItems: liveItems, itemLinks: itemLinks, packingHTML: packingHTML
  };
  root.NSG_CAT = api;

  /* =================== browser-only behaviour =================== */
  if (typeof document === 'undefined') return;

  var currentLang = document.documentElement.lang || 'en';

  /* ---- Catalog (index + /guides/) ---- */
  function initCatalog() {
    var el = document.querySelector('[data-catalog]');
    if (!el) return null;
    var base = el.getAttribute('data-base') || '';
    var grid = el.querySelector('[data-catalog-grid]');
    var chips = el.querySelector('[data-catalog-chips]');
    var search = el.querySelector('[data-catalog-search]');
    var sort = el.querySelector('[data-catalog-sort]');
    var count = el.querySelector('[data-catalog-count]');
    var state = { filter: 'all', q: '', sort: 'featured' };
    var guides = data().guides;
    var hay = {};
    guides.forEach(function (g) { hay[g.slug] = haystack(g); });

    function filters(lang) {
      var opts = [{ id: 'all', label: t(lang, 'cat.all') }];
      var regions = [], dests = [];
      guides.forEach(function (g) {
        if (regions.indexOf(regionOf(g)) === -1) regions.push(regionOf(g));
        if (dests.indexOf(g.destination) === -1) dests.push(g.destination);
      });
      if (regions.length > 1) {
        regions.forEach(function (r) { opts.push({ id: 'region:' + r, label: regionName(r, lang) }); });
      }
      dests.forEach(function (d) {
        var sample = guides.filter(function (g) { return g.destination === d; })[0];
        opts.push({ id: 'dest:' + d, label: destName(sample, lang) });
      });
      return opts;
    }

    function matches(g) {
      if (state.filter.indexOf('dest:') === 0 && g.destination !== state.filter.slice(5)) return false;
      if (state.filter.indexOf('region:') === 0 && regionOf(g) !== state.filter.slice(7)) return false;
      if (state.q) {
        var tokens = norm(state.q).split(/\s+/).filter(Boolean);
        for (var i = 0; i < tokens.length; i++) if (hay[g.slug].indexOf(tokens[i]) === -1) return false;
      }
      return true;
    }

    function render(lang) {
      if (chips) {
        chips.innerHTML = filters(lang).map(function (f) {
          var on = f.id === state.filter;
          return '<button type="button" data-filter="' + esc(f.id) + '" aria-pressed="' + on + '" class="cat-chip rounded-full border border-ink/15 bg-white px-4 py-2 text-sm font-semibold text-ink transition hover:border-ocean-600">' + esc(f.label) + '</button>';
        }).join('');
      }
      var list = sortGuides(guides.filter(matches), state.sort, lang);
      var html = list.map(function (g) { return cardHTML(g, lang, base); }).join('');
      if (!list.length) {
        html = '<div class="col-span-full rounded-3xl bg-white p-8 text-center ring-1 ring-ink/5"><p class="text-ink-soft">' + esc(t(lang, 'cat.empty')) + '</p>'
          + '<button type="button" data-catalog-reset class="mt-4 rounded-full border border-ink/15 px-5 py-2 text-sm font-semibold hover:border-ocean-600">' + esc(t(lang, 'cat.reset')) + '</button></div>';
      }
      grid.innerHTML = html + soonCardHTML(lang, base);
      if (count) count.textContent = list.length === 1 ? t(lang, 'cat.countOne') : t(lang, 'cat.countMany', list.length);
    }

    if (search) search.addEventListener('input', function () { state.q = search.value; render(currentLang); });
    if (sort) sort.addEventListener('change', function () { state.sort = sort.value; render(currentLang); });
    el.addEventListener('click', function (e) {
      var chip = e.target.closest && e.target.closest('[data-filter]');
      if (chip) { state.filter = chip.getAttribute('data-filter'); render(currentLang); return; }
      if (e.target.closest && e.target.closest('[data-catalog-reset]')) {
        state = { filter: 'all', q: '', sort: state.sort };
        if (search) search.value = '';
        render(currentLang);
        if (search) search.focus();
      }
    });
    return render;
  }

  /* ---- Guide detail page ---- */
  function renderGuidePage(lang) {
    var slug = document.body.getAttribute('data-guide');
    if (!slug) return;
    var g = data().guides.filter(function (x) { return x.slug === slug; })[0];
    if (!g) return;
    var tx = guideText(g, lang);
    Array.prototype.forEach.call(document.querySelectorAll('[data-guide-field]'), function (el) {
      var f = el.getAttribute('data-guide-field');
      if (f === 'title') el.textContent = tx.title;
      else if (f === 'description') el.textContent = tx.description;
      else if (f === 'dest') el.textContent = destName(g, lang);
      else if (f === 'days') el.textContent = t(lang, 'card.days', g.days);
      else if (f === 'image-alt') el.setAttribute('alt', tx.title);
      else if (f === 'highlights') {
        el.innerHTML = tx.highlights.map(function (h) {
          return '<li class="flex gap-3"><span class="mt-0.5 text-ocean-600" aria-hidden="true">✓</span><span>' + esc(h) + '</span></li>';
        }).join('');
      }
    });
    document.title = tx.title + ' — ' + t(lang, 'gp.titleSuffix');
    var md = document.querySelector('meta[name="description"]');
    if (md) md.setAttribute('content', tx.description);
    var rel = document.querySelector('[data-related]');
    if (rel) rel.innerHTML = relatedFor(slug, 3).map(function (r) { return cardHTML(r, lang, rel.getAttribute('data-base') || ''); }).join('');
  }

  /* ---- Footer guide links + packing list ---- */
  function renderMisc(lang) {
    Array.prototype.forEach.call(document.querySelectorAll('[data-guide-title]'), function (el) {
      var g = data().guides.filter(function (x) { return x.slug === el.getAttribute('data-guide-title'); })[0];
      if (g) el.textContent = guideText(g, lang).title;
    });
    var pk = document.querySelector('[data-packing]');
    if (pk) pk.innerHTML = packingHTML(lang);
  }

  var renderCatalog = initCatalog();

  function renderAll(lang) {
    currentLang = lang || 'en';
    if (renderCatalog) renderCatalog(currentLang);
    renderGuidePage(currentLang);
    renderMisc(currentLang);
  }

  document.addEventListener('nsg:langchange', function (e) { renderAll(e.detail && e.detail.lang); });
  renderAll(currentLang);

  /* ---- Deep links like /packing-list/?lang=tr#adapter or /?lang=de#airalo ----
     Items are re-rendered after the language is applied and Tailwind styles
     the page late, so we scroll after 'load' and briefly highlight the item. */
  function focusHashTarget() {
    if (!window.location.hash) return;
    var id = decodeURIComponent(window.location.hash.slice(1));
    var el = document.getElementById(id);
    if (!el || !el.hasAttribute('data-deeplink')) return;
    // Show the target's section right away (scroll-reveal animations may lag behind a programmatic jump)
    var sec = el.closest('section') || el.parentNode;
    Array.prototype.forEach.call(sec.querySelectorAll('.reveal'), function (r) { r.classList.add('is-visible'); });
    window.scrollTo({ top: el.getBoundingClientRect().top + window.scrollY - 96, behavior: 'instant' });
    el.classList.remove('is-target');
    void el.offsetWidth; // restart the highlight animation
    el.classList.add('is-target');
    setTimeout(function () { el.classList.remove('is-target'); }, 2600);
  }
  if (document.readyState === 'complete') setTimeout(focusHashTarget, 60);
  else window.addEventListener('load', function () { setTimeout(focusHashTarget, 60); });
  window.addEventListener('hashchange', focusHashTarget);
})(typeof window !== 'undefined' ? window : this);
