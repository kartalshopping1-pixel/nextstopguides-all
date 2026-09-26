/* =====================================================================
   NextStopGuides — blog.js
   Switches blog titles, summaries, dates and article bodies when the
   visitor changes language. Article HTML is written by
   tools/build-guides.js (English in the page, other languages in
   <template data-post-lang="xx">). Load before main.js.
   ===================================================================== */
(function () {
  'use strict';
  var dataEl = document.getElementById('nsg-posts-data');
  if (!dataEl) return;
  var DATA = {};
  try { DATA = JSON.parse(dataEl.textContent); } catch (e) { return; }

  var body = document.querySelector('[data-post-body]');
  var enBody = body ? body.innerHTML : '';

  function pick(obj, lang) { return (obj && (obj[lang] || obj.en)) || ''; }
  function t(lang, key) {
    return window.NSG_CAT ? window.NSG_CAT.t(lang, key) : key;
  }
  function fmtDate(iso, lang) {
    try {
      return new Intl.DateTimeFormat(lang, { year: 'numeric', month: 'long', day: 'numeric' })
        .format(new Date(iso + 'T12:00:00'));
    } catch (e) { return iso; }
  }

  function apply(lang) {
    lang = lang || 'en';
    Array.prototype.forEach.call(document.querySelectorAll('[data-post-slug]'), function (el) {
      var p = DATA[el.getAttribute('data-post-slug')];
      if (!p) return;
      var f = el.getAttribute('data-post-field');
      if (f === 'title') el.textContent = pick(p.t, lang);
      else if (f === 'description') el.textContent = pick(p.d, lang);
      else if (f === 'date') el.textContent = fmtDate(p.date, lang);
    });

    var slug = document.body.getAttribute('data-post');
    if (!body || !slug || !DATA[slug]) return;

    var tpl = document.querySelector('template[data-post-lang="' + lang + '"]');
    var translated = lang === 'en' || !!tpl;
    body.innerHTML = tpl ? tpl.innerHTML : enBody;
    body.setAttribute('lang', tpl ? lang : 'en');
    var note = document.querySelector('[data-post-en-note]');
    if (note) note.hidden = translated;

    var p = DATA[slug];
    document.title = pick(p.t, lang) + ' — ' + t(lang, 'blog.titleSuffix');
    var md = document.querySelector('meta[name="description"]');
    if (md) md.setAttribute('content', pick(p.d, lang));

    var rel = document.querySelector('[data-post-guides]');
    if (rel && window.NSG_CAT && window.NSG_CATALOG) {
      var base = rel.getAttribute('data-base') || '';
      var slugs = (rel.getAttribute('data-post-guides') || '').split(',');
      rel.innerHTML = slugs.map(function (s) {
        var g = window.NSG_CATALOG.guides.filter(function (x) { return x.slug === s; })[0];
        return g ? window.NSG_CAT.cardHTML(g, lang, base) : '';
      }).join('');
    }
  }

  document.addEventListener('nsg:langchange', function (e) { apply(e.detail && e.detail.lang); });
  apply(document.documentElement.lang || 'en');
})();
