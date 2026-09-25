# NextStopGuides — Web Sitesi

**https://thenextstopguides.com** — Yazdırılabilir gezi planlarınızı (PDF) tanıtan ve ziyaretçiyi **Etsy** (İngilizce baskılar)
ve **Shopier** (Türkçe baskılar) mağazalarınıza gönderen, **5 dilli** (EN, TR, DE, FR, ES) ve mobil uyumlu site.
Ek gelir: Airalo, Klook, Welcome Pickups, otel partneri ve Amazon ortaklık linkleri.

> **Kod bilmenize gerek yok.** Çoğu iş tek bir dosyaya bir kayıt eklemek ve tek bir komut çalıştırmaktan ibaret.

---

## ⭐ Yeni rehber nasıl eklenir? (3 adım)

1. **`assets/data/guides.js`** dosyasını açın. `guides: [` listesindeki bir rehber kaydını (süslü parantezler `{ ... }` arası,
   sonundaki virgülle birlikte) kopyalayıp hemen altına yapıştırın. Sonra değerleri değiştirin:
   - `slug`: sayfa adresi, örn. `'italy-7-day-itinerary'` → `/guides/italy-7-day-itinerary/` (küçük harf, tire, Türkçe karakter yok)
   - `destination`: ülke, örn. `'italy'` (dosyanın altındaki listede 24 ülke hazır)
   - `days`, `cities`, `image` (Etsy ürün görselinin linki), `etsy` (Etsy ürün linki)
   - `shopier` + `priceTRY` (Türkçe baskı varsa; yoksa `''` bırakın → buton gizlenir)
   - `text.en` → başlık, kısa açıklama, öne çıkanlar (**zorunlu**). `tr`, `de`, `fr`, `es` isteğe bağlı (yoksa İngilizce görünür).
2. Klasörde terminal açın (klasörün adres çubuğuna `cmd` yazıp Enter) ve çalıştırın:
   ```bash
   node tools/build-guides.js
   ```
   Bu komut ana sayfayı, `/guides/` listesini, **yeni rehberin kendi SEO sayfasını** ve `sitemap.xml`'i otomatik günceller.
   (İsterseniz kontrol: `node tools/check-i18n.js` → "OK" yazmalı.)
3. Değişiklikleri **GitHub'a gönderin (commit + push)**. Cloudflare Pages birkaç dakika içinde siteyi günceller.

> Node.js yoksa: https://nodejs.org → "LTS" sürümünü kurun (bir kerelik).
> Hata mesajı çıkarsa genelde bir virgül, tırnak veya parantez eksiktir — mesaj hangi rehberde olduğunu söyler.

---

## 1. Dosyalar ne işe yarıyor?

```
nextstopguides-web/
├── index.html              → Ana sayfa            ┐
├── guides/index.html       → Tüm gezi planları    │ OTOMATİK ÜRETİLİR
├── guides/<slug>/index.html→ Her rehberin sayfası │ (node tools/build-guides.js)
├── packing-list/index.html → Bavul listesi (Amazon)│ Elle düzenlemeyin!
├── sitemap.xml, robots.txt → Google dosyaları     ┘
├── privacy.html            → Gizlilik + affiliate bildirimi (5 dil, elle düzenlenir)
├── 404.html                → "Sayfa bulunamadı" sayfası
├── favicon.svg, site.webmanifest
└── assets/
    ├── data/guides.js      → ⭐ REHBER KATALOĞU (her rehber = 1 kayıt)
    ├── data/packing.js     → ⭐ BAVUL LİSTESİ ürünleri + Amazon linkleri
    ├── js/config.js        → ⭐ Mağaza, partner, sosyal medya, iletişim linkleri
    ├── js/i18n.js          → ⭐ TÜM METİNLER, 5 dilde (İngilizce dahil)
    ├── js/catalog.js       → Kartlar, arama/filtre, rehber ve bavul sayfası (dokunmayın)
    ├── js/main.js          → Dil seçici, menü, SSS vb. (dokunmayın)
    ├── js/tw-config.js     → Marka renkleri (Tailwind)
    ├── css/styles.css      → Küçük ek tasarım ayarları
    └── img/README.md       → Hangi görselleri ekleyebileceğiniz
tools/
    ├── build-guides.js     → Sayfaları üreten program (npm paketi gerektirmez)
    └── check-i18n.js       → Çeviri + katalog kontrolü
```

---

## 2. Siteyi bilgisayarınızda görmek

`index.html` dosyasına **çift tıklayın**. Rehber kartları, rehber sayfaları, dil menüsü — hepsi dosyadan da çalışır.
Değişiklikten sonra tarayıcıda **F5**. (İnternet gerekir: tasarım ve yazı tipleri internetten yüklenir.)

---

## 3. Linkler (`assets/js/config.js`)

`"BURAYA_..."` ile başlayan değerler henüz doldurulmamıştır; tıklanınca "Bu link yakında aktif" mesajı çıkar, site bozulmaz.
Sadece tırnak içini değiştirin; tırnak, virgül ve parantezleri silmeyin. Config değişiklikleri **anında** geçerlidir
(yine de `node tools/build-guides.js` çalıştırmak Google'ın gördüğü sayfaları da günceller).

| Alan | Ne? | Durum |
|---|---|---|
| `shops.etsy`, `shops.shopier` | Mağaza ana sayfaları | ✅ dolu |
| `affiliates.airalo` | Travelpayouts → Airalo (Sub ID "site") | ✅ dolu |
| `affiliates.airaloCode` | (İsteğe bağlı) Airalo kodu → kartta "Kopyala" butonlu kutu çıkar (sonra build çalıştırın) | boş |
| `affiliates.klook` | Travelpayouts → Klook | ✅ dolu |
| `affiliates.welcomepickups` | Travelpayouts → Welcome Pickups | ✅ dolu |
| `affiliates.hotels` + `partners.hotelsProvider` | Otel partneri linki ve adı | ⏳ doldurulunca "Yakında" etiketi kalkar |
| `social.*` | Instagram, TikTok, YouTube, Pinterest | ⏳ |
| `contact.email` | Doldurulunca "Destinasyon iste" butonu e-posta açar | ⏳ |
| `newsletter.action` | Bülten servisi (Brevo/MailerLite/Formspree) form adresi | ⏳ |

**Bülten:** Formspree (en kolayı) `https://formspree.io/f/xxxx` verir → `newsletter.action`'a yapıştırın.
Mailchimp kullanırsanız `emailFieldName: "EMAIL"` yazın.

---

## 4. Metinler ve diller (`assets/js/i18n.js`)

- Tüm sabit metinler burada, **5 dilde** (`en`, `tr`, `de`, `fr`, `es` blokları). Her satır `'anahtar': 'metin',`.
- Bir metni değiştirdikten sonra `node tools/build-guides.js` çalıştırın (İngilizce metin sayfalara böyle yazılır).
- Metinde düz kesme işareti (') yerine tipografik `’` kullanın. `{n}` → sayı (örn. `'{n} gün'`).
- Rehberlerin başlık/açıklamaları `guides.js`'te, bavul ürünlerinin metinleri `packing.js`'te.
- Kontrol: `node tools/check-i18n.js` → eksik çeviri varsa listeler.

**Dil seçici:** sağ üstte 🌐 menü; telefonda ☰ içinde 5 dil butonu. Site tarayıcı diline göre açılır, seçim hatırlanır.
Link ile dil seçilebilir: `https://thenextstopguides.com/?lang=tr` (tr, de, fr, es, en).

**Yeni dil eklemek (örn. İtalyanca `it`):** `i18n.js` → `languages`'a `it: 'Italiano'`, `ogLocale`'a `it: 'it_IT'` ekleyin;
`messages` ve `strings` içinde `es` bloğunu kopyalayıp `it` yapın ve çevirin → `node tools/build-guides.js`
(hreflang ve sitemap otomatik güncellenir) → `node tools/check-i18n.js`. İsterseniz `privacy.html`'e de bir bölüm ekleyin.

---

## 5. Bavul listesi / Amazon (`assets/data/packing.js`)

- Her ürünün **sabit bir `id`'si** var (örn. `adapter`). PDF rehberlerdeki linkler buna gider:
  `https://thenextstopguides.com/packing-list/?lang=tr#adapter` → sayfa o ürüne kayar ve kısa süre vurgular.
  **`id`'leri değiştirmeyin**, yoksa PDF'teki linkler çalışmaz.
- Her ürünün iki linki var: `links.us` (amazon.com, `tag=thenextstopgu-20`) ve `links.tr` (amazon.com.tr, `tag=nextstopguide-21`).
  Türkçe ziyaretçiye amazon.com.tr, diğerlerine amazon.com ana buton olarak gösterilir; diğer mağaza küçük link olur.
- Linki `BURAYA_...` olan ürün gizlenir. Hiç ürün kalmazsa sayfa "yakında" der ve Google'a kapatılır (noindex).
- Amazon'un zorunlu bildirimi ("As an Amazon Associate I earn from qualifying purchases.") sayfada, altbilgide ve gizlilik sayfasında 5 dilde var.
- Değişiklikten sonra: `node tools/build-guides.js`.

Ana sayfadaki Airalo kartına da doğrudan link verilebilir: `https://thenextstopguides.com/?lang=tr#airalo`.

---

## 6. Yayınlama (Cloudflare Pages)

Site, GitHub deposundaki `nextstopguides-web` klasöründen **Cloudflare Pages** ile yayınlanıyor (build komutu yok).
Bu yüzden `node tools/build-guides.js`'in ürettiği dosyalar da **GitHub'a gönderilmelidir** (commit + push).
Yedek seçenekler: Netlify Drop (klasörü sürükle-bırak) veya GitHub Pages — ikisi de ücretsiz.

---

## 7. Partner programları

| Partner | Nasıl | Not |
|---|---|---|
| **Airalo** (eSIM) | Travelpayouts (marker 777810) | Link `affiliates.airalo`; isterseniz bir kod `affiliates.airaloCode` (indirim miktarı vaat edilmez) |
| **Klook** (tur/aktivite) | Travelpayouts (marker 777810) | Travelpayouts panelinden başka şehir/ürün linkleri de üretebilirsiniz |
| **Welcome Pickups** (havalimanı transferi) | Travelpayouts | |
| **Oteller** | Travelpayouts'taki bir otel programı (belli olunca) | Linki ve partner adını config'e yazın |
| **Amazon** | Amazon Associates (US + TR) | Linkler `packing.js`'te |

Affiliate linklere site otomatik `rel="sponsored"` ekler (Google kuralı). Bildirimler partner bölümünde, altbilgide ve `privacy.html`'de.

---

## 8. SEO kontrol listesi

- [ ] **Google Search Console** → mülk `thenextstopguides.com` → **Site haritaları** → `sitemap.xml` gönderin (yeni rehberden sonra otomatik güncellenir).
- [ ] Yapısal veri testi: https://search.google.com/test/rich-results → bir rehber sayfasının adresi (Product + Breadcrumb).
- [ ] (İsteğe bağlı) `assets/img/og-image.jpg` (1200×630) ekleyin — ana sayfa paylaşım görseli olur; yoksa ilk rehberin görseli kullanılır.
- [ ] Etsy'de USD fiyat netleşirse `guides.js` → `price: '$…'` yazın: kartta fiyat + "Buy on Etsy" görünür ve Google'a fiyat bildirilir.
- [ ] Alan adı değişirse sadece `config.js` → `site.url`'yi değiştirip build çalıştırın (privacy.html'deki 3 adresi elle değiştirin).
- [ ] Örnek yorumlar "Örnek" olarak işaretli; gerçek yorumlar gelince müşterinin izniyle `i18n.js` → `t.q1`, `t.w1`… değiştirin.

---

## 9. İleride: Tailwind CDN yerine derlenmiş CSS (isteğe bağlı, daha hızlı)

Tasarım şu an **Tailwind Play CDN** ile çalışıyor (tarayıcı konsolunda "production" uyarısı görülebilir; site yine çalışır).

```bash
npm init -y
npm install -D tailwindcss@3
npx tailwindcss init
```
`tailwind.config.js`: `content: ["./*.html", "./guides/**/*.html", "./packing-list/*.html", "./assets/js/*.js", "./tools/build-guides.js"]`
ve `theme` olarak `assets/js/tw-config.js`'teki `theme` bölümü. `assets/css/tailwind-input.css` içine
`@tailwind base; @tailwind components; @tailwind utilities;` yazın ve üretin:
```bash
npx tailwindcss -i ./assets/css/tailwind-input.css -o ./assets/css/tailwind.css --minify
```
Sonra `tools/build-guides.js` içindeki `head()` fonksiyonunda CDN ve `tw-config.js` satırlarını
`<link rel="stylesheet" href="${o.base}assets/css/tailwind.css">` ile değiştirin (privacy.html'de de) ve build'i çalıştırın.
(Komutlar **Tailwind v3** içindir.)

---

## 10. Sık karşılaşılan sorunlar

- **Build "okunamadı / could not be parsed" diyor** → Belirtilen dosyada eksik virgül/tırnak/parantez var.
- **Yeni rehber ana sayfada var ama sayfası açılmıyor** → `node tools/build-guides.js` çalıştırıp GitHub'a gönderin.
- **Bir yazı İngilizce kaldı** → `i18n.js`'te o dilde anahtar eksik; `node tools/check-i18n.js` hangisi olduğunu söyler.
- **Sayfa tasarımsız görünüyor** → İnternet bağlantısını kontrol edin.
