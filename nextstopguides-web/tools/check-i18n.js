/* =====================================================================
   Çeviri kontrolü / Translation check
   Kullanım (Node.js gerekir):   node tools/check-i18n.js
   - index.html'deki her data-i18n anahtarının her dilde dolu olduğunu,
   - dillerin hepsinde aynı anahtarların bulunduğunu,
   - kısa mesajların (messages) her dilde tam olduğunu,
   - hreflang ve sitemap.xml'in her dili içerdiğini kontrol eder.
   Sorun yoksa "OK" yazar; varsa listeler ve hata koduyla çıkar.
   ===================================================================== */
'use strict';
var fs = require('fs');
var path = require('path');
var vm = require('vm');

var root = path.join(__dirname, '..');
var read = function (f) { return fs.readFileSync(path.join(root, f), 'utf8'); };

var sandbox = { window: {} };
vm.createContext(sandbox);
vm.runInContext(read('assets/js/i18n.js'), sandbox);
var I18N = sandbox.window.NSG_I18N;

var html = read('index.html');
var sitemap = read('sitemap.xml');
var problems = [];

var htmlKeys = new Set();
html.replace(/data-i18n="([^"]+)"/g, function (_, k) { htmlKeys.add(k); });
html.replace(/data-i18n-attr="([^"]+)"/g, function (_, v) {
  v.split(';').forEach(function (pair) { var k = (pair.split(':')[1] || '').trim(); if (k) htmlKeys.add(k); });
});
// keys used from JS rather than HTML
['meta.title', 'meta.description'].forEach(function (k) { htmlKeys.add(k); });

var langs = Object.keys(I18N.languages);
var translated = langs.filter(function (l) { return l !== 'en'; });

// 1) every HTML key present and non-empty in every language
translated.forEach(function (l) {
  var dict = I18N.strings[l];
  if (!dict) { problems.push('[' + l + '] strings block missing'); return; }
  htmlKeys.forEach(function (k) {
    if (typeof dict[k] !== 'string' || dict[k].trim() === '') problems.push('[' + l + '] missing: ' + k);
  });
  // 2) keys that exist in the dictionary but not in the HTML (typos / leftovers)
  Object.keys(dict).forEach(function (k) {
    if (!htmlKeys.has(k)) problems.push('[' + l + '] unused key (not in index.html): ' + k);
  });
});

// 3) short JS messages complete in every language
var msgKeys = Object.keys(I18N.messages.en || {});
langs.forEach(function (l) {
  var m = I18N.messages[l];
  if (!m) { problems.push('[' + l + '] messages block missing'); return; }
  msgKeys.forEach(function (k) {
    if (typeof m[k] !== 'string' || m[k].trim() === '') problems.push('[' + l + '] missing message: ' + k);
  });
  if (!I18N.ogLocale || !I18N.ogLocale[l]) problems.push('[' + l + '] ogLocale missing');
});

// 4) SEO: hreflang + sitemap
langs.concat(['x-default']).forEach(function (l) {
  if (html.indexOf('hreflang="' + l + '"') === -1) problems.push('index.html: hreflang="' + l + '" missing');
});
translated.forEach(function (l) {
  if (sitemap.indexOf('?lang=' + l + '</loc>') === -1) problems.push('sitemap.xml: <loc> for ?lang=' + l + ' missing');
  if (sitemap.indexOf('hreflang="' + l + '"') === -1) problems.push('sitemap.xml: hreflang="' + l + '" missing');
});

console.log('Languages: ' + langs.join(', '));
console.log('Keys in index.html: ' + htmlKeys.size + ' | messages: ' + msgKeys.length);
translated.forEach(function (l) {
  console.log('  ' + l + ': ' + Object.keys(I18N.strings[l] || {}).length + ' strings, ' + Object.keys(I18N.messages[l] || {}).length + ' messages');
});
if (problems.length) {
  console.log('\nPROBLEMS (' + problems.length + '):\n - ' + problems.join('\n - '));
  process.exit(1);
}
console.log('\nOK — every key has a value in all ' + langs.length + ' languages.');
