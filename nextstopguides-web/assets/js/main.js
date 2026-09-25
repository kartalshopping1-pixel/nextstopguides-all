/* =====================================================================
   NextStopGuides — main.js (vanilla JavaScript, no libraries)
   ---------------------------------------------------------------------
   1. Links & prices from config.js
   2. Language selector (EN in index.html, other languages in i18n.js)
   3. Mobile menu, sticky header, FAQ accordion, newsletter, animations
   Load order in HTML: config.js → i18n.js → main.js (all with defer).
   ===================================================================== */
(function () {
  'use strict';

  var CFG = window.NSG_CONFIG || {};
  var I18N = window.NSG_I18N || { languages: { en: 'English' }, messages: {}, strings: {}, ogLocale: {} };
  var LANGS = Object.keys(I18N.languages || { en: 'English' });
  var currentLang = 'en';

  /* ---------------------------- helpers ---------------------------- */
  function $all(sel, root) { return Array.prototype.slice.call((root || document).querySelectorAll(sel)); }

  function getConfig(path) {
    return path.split('.').reduce(function (obj, key) {
      return obj && obj[key] !== undefined ? obj[key] : undefined;
    }, CFG);
  }

  function isPlaceholder(value) {
    return typeof value !== 'string' || value.trim() === '' || value.indexOf('BURAYA_') === 0;
  }

  /* Short UI message in the current language (falls back to English) */
  function msg(key) {
    var m = I18N.messages || {};
    return (m[currentLang] && m[currentLang][key]) || (m.en && m.en[key]) || '';
  }

  /* Page string in the current language, or undefined → keep English from HTML */
  function str(key) {
    if (currentLang === 'en') return undefined;
    var dict = (I18N.strings || {})[currentLang];
    return dict && dict[key] !== undefined ? dict[key] : undefined;
  }

  function storageGet(key) { try { return window.localStorage.getItem(key); } catch (e) { return null; } }
  function storageSet(key, val) { try { window.localStorage.setItem(key, val); } catch (e) { /* ignore */ } }

  var toastEl, toastTimer;
  function toast(message) {
    if (!toastEl) {
      toastEl = document.createElement('div');
      toastEl.className = 'nsg-toast';
      toastEl.setAttribute('role', 'status');
      toastEl.setAttribute('aria-live', 'polite');
      document.body.appendChild(toastEl);
    }
    toastEl.textContent = message;
    toastEl.classList.add('is-visible');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(function () { toastEl.classList.remove('is-visible'); }, 2800);
  }

  /* ------------------------ 1. links & prices ------------------------ */
  function applyLinks() {
    var missing = [];
    $all('[data-link]').forEach(function (a) {
      var path = a.getAttribute('data-link');
      var value = getConfig(path);
      if (isPlaceholder(value)) {
        a.setAttribute('href', '#');
        a.removeAttribute('target');
        a.classList.add('is-placeholder');
        a.setAttribute('data-placeholder', 'true');
        if (missing.indexOf(path) === -1) missing.push(path);
        return;
      }
      if (value.indexOf('@') > -1 && value.indexOf('://') === -1 && value.indexOf('mailto:') !== 0) {
        value = 'mailto:' + value;
      }
      a.setAttribute('href', value);
    });

    document.addEventListener('click', function (e) {
      var a = e.target.closest ? e.target.closest('a[data-placeholder="true"]') : null;
      if (a) { e.preventDefault(); toast(msg('linkSoon')); }
    });

    if (missing.length && window.console) {
      console.info('[NextStopGuides] config.js içinde doldurulmamış linkler / unfilled links:\n - ' + missing.join('\n - '));
    }
  }

  function applyPrices() {
    var products = CFG.products || {};
    $all('[data-price]').forEach(function (el) {
      var p = products[el.getAttribute('data-price')];
      if (p && p.price) el.textContent = p.price;
    });
    $all('[data-price-try]').forEach(function (el) {
      var p = products[el.getAttribute('data-price-try')];
      if (p && p.priceTRY) el.textContent = p.priceTRY;
    });
  }

  /* ------------------------ 2. language ------------------------ */
  var originals = new Map();      // element -> original English innerHTML
  var originalAttrs = new Map();  // element -> { attr: original English value }
  var metaDesc = document.querySelector('meta[name="description"]');
  var ogLocale = document.querySelector('meta[property="og:locale"]');
  var canonical = document.querySelector('link[rel="canonical"]');
  var original = {
    title: document.title,
    desc: metaDesc ? metaDesc.getAttribute('content') : '',
    canonical: canonical ? canonical.getAttribute('href').split('?')[0] : ''
  };

  var langBtn = document.getElementById('lang-btn');
  var langMenu = document.getElementById('lang-menu');
  var langMobile = document.getElementById('lang-mobile');

  function applyLanguage(lang, opts) {
    opts = opts || {};
    currentLang = LANGS.indexOf(lang) > -1 ? lang : 'en';
    document.documentElement.lang = currentLang;

    $all('[data-i18n]').forEach(function (el) {
      if (!originals.has(el)) originals.set(el, el.innerHTML);
      var t = str(el.getAttribute('data-i18n'));
      el.innerHTML = t !== undefined ? t : originals.get(el);
    });

    // data-i18n-attr="placeholder:nl.placeholder;aria-label:t.stars"
    $all('[data-i18n-attr]').forEach(function (el) {
      if (!originalAttrs.has(el)) originalAttrs.set(el, {});
      var store = originalAttrs.get(el);
      el.getAttribute('data-i18n-attr').split(';').forEach(function (pair) {
        var parts = pair.split(':');
        if (parts.length !== 2) return;
        var attr = parts[0].trim(), t = str(parts[1].trim());
        if (!(attr in store)) store[attr] = el.getAttribute(attr) || '';
        el.setAttribute(attr, t !== undefined ? t : store[attr]);
      });
    });

    document.title = str('meta.title') || original.title;
    if (metaDesc) metaDesc.setAttribute('content', str('meta.description') || original.desc);
    if (ogLocale && I18N.ogLocale && I18N.ogLocale[currentLang]) ogLocale.setAttribute('content', I18N.ogLocale[currentLang]);
    if (canonical && original.canonical) {
      canonical.setAttribute('href', original.canonical + (currentLang === 'en' ? '' : '?lang=' + currentLang));
    }

    updateLangControls();
    updateMenuLabel();
    storageSet('nsg-lang', currentLang);

    if (opts.updateUrl && window.history && window.history.replaceState) {
      try {
        var url = new URL(window.location.href);
        if (currentLang === 'en') url.searchParams.delete('lang'); else url.searchParams.set('lang', currentLang);
        window.history.replaceState(null, '', url.toString());
      } catch (e) { /* file:// or old browser — ignore */ }
    }
  }

  function detectLanguage() {
    var fromUrl = null;
    try { fromUrl = new URLSearchParams(window.location.search).get('lang'); } catch (e) { /* old browser */ }
    if (fromUrl && LANGS.indexOf(fromUrl.toLowerCase()) > -1) return fromUrl.toLowerCase();

    var saved = storageGet('nsg-lang');
    if (saved && LANGS.indexOf(saved) > -1) return saved;

    var prefs = (navigator.languages && navigator.languages.length) ? navigator.languages : [navigator.language || 'en'];
    for (var i = 0; i < prefs.length; i++) {
      var code = String(prefs[i] || '').toLowerCase().split('-')[0];
      if (LANGS.indexOf(code) > -1) return code;
    }
    return 'en';
  }

  /* Build dropdown items + mobile buttons from i18n.js → languages */
  function buildLangControls() {
    if (langMenu) {
      langMenu.innerHTML = '';
      LANGS.forEach(function (code) {
        var li = document.createElement('li');
        li.setAttribute('role', 'none');
        var b = document.createElement('button');
        b.type = 'button';
        b.setAttribute('role', 'menuitemradio');
        b.setAttribute('data-lang', code);
        b.setAttribute('lang', code);
        b.setAttribute('tabindex', '-1');
        b.className = 'lang-item flex w-full items-center justify-between gap-3 rounded-xl px-3 py-2 text-left text-sm text-ink transition hover:bg-sand-100 focus:bg-sand-100';
        b.innerHTML = '<span>' + I18N.languages[code] + '</span><span class="text-xs font-bold text-ink-soft">' + code.toUpperCase() + '</span>';
        li.appendChild(b);
        langMenu.appendChild(li);
      });
    }
    if (langMobile) {
      langMobile.innerHTML = '';
      LANGS.forEach(function (code) {
        var b = document.createElement('button');
        b.type = 'button';
        b.setAttribute('data-lang', code);
        b.setAttribute('lang', code);
        b.setAttribute('aria-label', I18N.languages[code]);
        b.className = 'lang-pill rounded-full border border-ink/15 px-2 py-2 text-xs font-bold tracking-wide text-ink transition hover:border-ocean-600';
        b.textContent = code.toUpperCase();
        langMobile.appendChild(b);
      });
    }
  }

  function updateLangControls() {
    $all('[data-lang-current]').forEach(function (el) { el.textContent = currentLang.toUpperCase(); });
    if (langBtn) langBtn.setAttribute('aria-label', msg('langLabel') + ': ' + (I18N.languages[currentLang] || currentLang));
    $all('[data-lang]').forEach(function (b) {
      var on = b.getAttribute('data-lang') === currentLang;
      if (b.getAttribute('role') === 'menuitemradio') b.setAttribute('aria-checked', String(on));
      else b.setAttribute('aria-pressed', String(on));
    });
  }

  function langItems() { return langMenu ? $all('[role="menuitemradio"]', langMenu) : []; }

  function openLangMenu(focusWhich) {
    if (!langBtn || !langMenu) return;
    langMenu.hidden = false;
    langBtn.setAttribute('aria-expanded', 'true');
    var items = langItems();
    var idx = items.findIndex(function (b) { return b.getAttribute('aria-checked') === 'true'; });
    if (focusWhich === 'last') idx = items.length - 1;
    if (idx < 0) idx = 0;
    if (items[idx]) items[idx].focus();
  }

  function closeLangMenu(returnFocus) {
    if (!langBtn || !langMenu || langMenu.hidden) return;
    langMenu.hidden = true;
    langBtn.setAttribute('aria-expanded', 'false');
    if (returnFocus) langBtn.focus();
  }

  function initLanguage() {
    // Only pages with a language selector (index.html) use the translation system.
    if (!langBtn && !langMobile) return;
    buildLangControls();
    applyLanguage(detectLanguage());

    // Any [data-lang] button (dropdown item or mobile pill) switches language
    document.addEventListener('click', function (e) {
      var b = e.target.closest ? e.target.closest('[data-lang]') : null;
      if (b) {
        applyLanguage(b.getAttribute('data-lang'), { updateUrl: true });
        closeLangMenu(b.getAttribute('role') === 'menuitemradio');
        return;
      }
      // click outside closes the dropdown
      if (langMenu && !langMenu.hidden && !(e.target.closest && e.target.closest('[data-lang-switcher]'))) closeLangMenu(false);
    });

    if (!langBtn || !langMenu) return;

    langBtn.addEventListener('click', function () {
      if (langMenu.hidden) openLangMenu(); else closeLangMenu(false);
    });
    langBtn.addEventListener('keydown', function (e) {
      if (e.key === 'ArrowDown') { e.preventDefault(); openLangMenu(); }
      if (e.key === 'ArrowUp') { e.preventDefault(); openLangMenu('last'); }
    });
    langMenu.addEventListener('keydown', function (e) {
      var items = langItems();
      var i = items.indexOf(document.activeElement);
      if (e.key === 'ArrowDown') { e.preventDefault(); items[(i + 1) % items.length].focus(); }
      else if (e.key === 'ArrowUp') { e.preventDefault(); items[(i - 1 + items.length) % items.length].focus(); }
      else if (e.key === 'Home') { e.preventDefault(); items[0].focus(); }
      else if (e.key === 'End') { e.preventDefault(); items[items.length - 1].focus(); }
      else if (e.key === 'Escape') { e.preventDefault(); closeLangMenu(true); }
      else if (e.key === 'Tab') { closeLangMenu(false); }
    });
  }

  /* ------------------------ 3. mobile menu ------------------------ */
  var menuBtn = document.getElementById('menu-btn');
  var menu = document.getElementById('mobile-menu');

  function updateMenuLabel() {
    if (!menuBtn) return;
    var open = menuBtn.getAttribute('aria-expanded') === 'true';
    menuBtn.setAttribute('aria-label', open ? msg('menuClose') : msg('menuOpen'));
  }

  function setMenu(open) {
    if (!menuBtn || !menu) return;
    menuBtn.setAttribute('aria-expanded', String(open));
    menu.classList.toggle('hidden', !open);
    updateMenuLabel();
  }

  function initMenu() {
    if (!menuBtn || !menu) return;
    menuBtn.addEventListener('click', function () {
      closeLangMenu(false);
      setMenu(menuBtn.getAttribute('aria-expanded') !== 'true');
    });
    $all('a', menu).forEach(function (a) { a.addEventListener('click', function () { setMenu(false); }); });
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && menuBtn.getAttribute('aria-expanded') === 'true') { setMenu(false); menuBtn.focus(); }
    });
    window.addEventListener('resize', function () { if (window.innerWidth >= 1024) setMenu(false); });
  }

  /* ------------------------ sticky header shadow ------------------------ */
  function initHeader() {
    var header = document.getElementById('site-header');
    if (!header) return;
    var onScroll = function () { header.classList.toggle('is-scrolled', window.scrollY > 8); };
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
  }

  /* ------------------------ FAQ accordion ------------------------ */
  function initFaq() {
    $all('.faq-btn').forEach(function (btn, i) {
      var panel = document.getElementById(btn.getAttribute('aria-controls'));
      if (!panel) return;
      // Without JS all answers are visible; with JS only the first starts open.
      var open = i === 0;
      btn.setAttribute('aria-expanded', String(open));
      panel.hidden = !open;
      btn.addEventListener('click', function () {
        var isOpen = btn.getAttribute('aria-expanded') === 'true';
        btn.setAttribute('aria-expanded', String(!isOpen));
        panel.hidden = isOpen;
      });
    });
  }

  /* ------------------------ newsletter ------------------------ */
  function initNewsletter() {
    var form = document.getElementById('newsletter-form');
    if (!form) return;
    var input = form.querySelector('input[type="email"]');
    var status = document.getElementById('nl-status');
    var nl = CFG.newsletter || {};
    var configured = !isPlaceholder(nl.action);

    if (configured) {
      form.setAttribute('action', nl.action);
      form.setAttribute('method', (nl.method || 'POST').toLowerCase());
      if (nl.emailFieldName && input) input.setAttribute('name', nl.emailFieldName);
      form.setAttribute('target', '_blank');
    }

    form.addEventListener('submit', function (e) {
      var valid = input && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(input.value.trim());
      if (!valid) {
        e.preventDefault();
        if (status) status.textContent = msg('nlInvalid');
        if (input) input.focus();
        return;
      }
      if (!configured) {
        // No email service connected yet (see config.js → newsletter.action)
        e.preventDefault();
        if (status) status.textContent = msg('nlDemo');
        form.reset();
        return;
      }
      if (status) status.textContent = msg('nlSending');
    });
  }

  /* ------------------------ reveal on scroll ------------------------ */
  function initReveal() {
    var items = $all('.reveal');
    var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (reduce || !('IntersectionObserver' in window)) {
      items.forEach(function (el) { el.classList.add('is-visible'); });
      return;
    }
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) { entry.target.classList.add('is-visible'); io.unobserve(entry.target); }
      });
    }, { rootMargin: '0px 0px -8% 0px', threshold: 0.08 });
    items.forEach(function (el) { io.observe(el); });
  }

  /* ------------------------ footer year ------------------------ */
  function initYear() {
    $all('[data-year]').forEach(function (el) { el.textContent = String(new Date().getFullYear()); });
  }

  /* ------------------------ privacy page: jump to visitor's language ------------------------ */
  function initFollowLang() {
    if (!document.body.hasAttribute('data-follow-lang')) return;
    // A #hash in the link (e.g. privacy.html#affiliate) wins; otherwise use the saved language.
    var id = window.location.hash ? decodeURIComponent(window.location.hash.slice(1)) : storageGet('nsg-lang');
    var target = id && id !== 'en' ? document.getElementById(id) : null;
    if (!target) return;
    // Wait until fonts + Tailwind styles have laid out the page, then jump instantly.
    var jump = function () { window.scrollTo({ top: target.getBoundingClientRect().top + window.scrollY - 80, behavior: 'instant' }); };
    if (document.readyState === 'complete') setTimeout(jump, 50);
    else window.addEventListener('load', function () { setTimeout(jump, 50); });
  }

  /* ------------------------ start ------------------------ */
  initFollowLang();
  applyLinks();
  applyPrices();
  initLanguage();
  initMenu();
  initHeader();
  initFaq();
  initNewsletter();
  initReveal();
  initYear();
})();
