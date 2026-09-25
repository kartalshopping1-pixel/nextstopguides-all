# NextStopGuides — Web Sitesi

Dijital seyahat rehberlerinizi (Etsy + Shopier) satan ve affiliate (ortaklık) linkleriyle gelir getiren,
**tek sayfalık, mobil uyumlu, 5 dilli (İngilizce, Türkçe, Almanca, Fransızca, İspanyolca)** tanıtım sitesi.

> **Kod bilmenize gerek yok.** Siteyi görmek için `index.html` dosyasına çift tıklamanız yeterli.
> Linkleri ve fiyatları değiştirmek için yalnızca **tek bir dosyayı** düzenleyeceksiniz: `assets/js/config.js`.

---

## 1. Dosyalar ne işe yarıyor?

```
nextstopguides-web/
├── index.html            → Ana sayfa (tüm bölümler burada, İngilizce metinler burada)
├── privacy.html          → Gizlilik politikası + affiliate bildirimi (EN, TR, DE, FR, ES)
├── 404.html              → "Sayfa bulunamadı" sayfası (yayınlayınca otomatik çalışır)
├── favicon.svg           → Tarayıcı sekmesindeki küçük logo
├── site.webmanifest      → Telefonda "ana ekrana ekle" ayarları
├── robots.txt            → Google'a "siteyi tarayabilirsin" diyen dosya
├── sitemap.xml           → Google için sayfa listesi
├── README.md             → Bu kılavuz
└── assets/
    ├── css/styles.css    → Küçük ek tasarım ayarları (animasyonlar vb.)
    ├── js/config.js      → ⭐ TÜM LİNKLER VE FİYATLAR (sizin düzenleyeceğiniz dosya)
    ├── js/i18n.js        → ⭐ ÇEVİRİLER (Türkçe, Almanca, Fransızca, İspanyolca)
    ├── js/main.js        → Sitenin çalışmasını sağlayan kod (dokunmanıza gerek yok)
    └── img/README.md     → Hangi görselleri ekleyeceğinizin listesi
tools/
    └── check-i18n.js     → (İsteğe bağlı) Çevirilerde eksik var mı kontrol eden küçük program
```

---

## 2. Siteyi bilgisayarınızda görmek

1. `nextstopguides-web` klasörünü açın.
2. **`index.html`** dosyasına **çift tıklayın** → Chrome/Edge'de açılır.
3. Değişiklik yaptıktan sonra tarayıcıda **F5** (yenile) tuşuna basın.

> İnternet bağlantısı gerekir (tasarım kütüphanesi Tailwind ve yazı tipleri internetten yüklenir).
> Sağ üstteki 🌐 **dil menüsüyle** (EN, TR, DE, FR, ES) dili değiştirebilirsiniz. Site, ziyaretçinin tarayıcı diline göre otomatik açılır.

---

## 3. Linkleri ve fiyatları değiştirmek (`assets/js/config.js`)

1. `assets/js/config.js` dosyasına **sağ tık → Birlikte aç → Not Defteri** (daha iyisi: ücretsiz **VS Code** ya da **Notepad++**).
2. `"BURAYA_..."` yazan her yeri kendi linkinizle değiştirin. **Sadece tırnak içini** değiştirin:

   ```js
   // ÖNCE
   etsy: "BURAYA_ETSY_ISTANBUL_URUN_LINKI",
   // SONRA
   etsy: "https://www.etsy.com/listing/1234567890/istanbul-3-day-guide",
   ```
3. Kaydedin (**Ctrl + S**) ve tarayıcıda **F5** yapın.

**Kurallar:** Tırnakları (`"`), virgülleri (`,`) ve süslü parantezleri (`{ }`) silmeyin.
Doldurulmamış bir linke tıklanırsa site bozulmaz; "Bu link yakında aktif olacak" mesajı çıkar.

### Doldurmanız gereken alanlar

| Bölüm | Alan | Ne yazılacak |
|---|---|---|
| `shops` | `etsy`, `shopier` | Mağazanızın ana sayfa linki |
| `products.istanbul` / `cappadocia` / `antalya` / `europe` | `etsy`, `shopier` | Her rehberin ürün sayfası linki |
| `products.*` | `price`, `priceTRY` | Fiyatlar (örn. `"$9.99"`, `"₺349"`) |
| `affiliates` | `airalo`, `booking`, `getyourguide` | Partner programlarından aldığınız size özel linkler |
| `social` | `instagram`, `tiktok`, `youtube`, `pinterest` | Sosyal medya profil linkleri |
| `contact` | `email` | İletişim e-postanız (otomatik `mailto:` linki olur) |
| `newsletter` | `action`, `emailFieldName` | Bülten servisinin form adresi (aşağıya bakın) |

### ⚠️ Fiyatı değiştirdiğinizde
Google'ın ürünlerinizi anlaması için fiyatlar `index.html` içindeki **JSON-LD** bölümünde de yazılı.
`index.html`'de **Ctrl + F** ile `"price": "9.99"` arayın ve yeni fiyatı yazın (dolar işareti **olmadan**, nokta ile: `"10.99"`).

### Bülten (newsletter) formu
Sitenin kendi sunucusu yok; e-postaları ücretsiz bir servis toplar:
- **Brevo** veya **MailerLite** (Türkçe arayüz, ücretsiz plan) → Form oluştur → "HTML embed" kodundaki `action="..."` adresini kopyalayın.
- **Mailchimp** → Audience → Signup forms → Embedded form → `action="..."` adresi. Mailchimp için `emailFieldName: "EMAIL"` yazın.
- **Formspree** (en kolayı) → yeni form → size `https://formspree.io/f/xxxx` verir → onu yapıştırın.

Doldurulmazsa form bir şey göndermez; ziyaretçiye "Kayıt çok yakında açılacak" der.

### Metinleri değiştirmek (5 dil: EN, TR, DE, FR, ES)
- **İngilizce** metinler: `index.html` içinde, doğrudan yazılı.
- **Türkçe, Almanca, Fransızca, İspanyolca** metinler: `assets/js/i18n.js` dosyasında, `strings:` altında
  `tr: { ... }`, `de: { ... }`, `fr: { ... }`, `es: { ... }` blokları.
  Her satır `'anahtar': 'metin',` şeklinde. Anahtar, `index.html`'deki `data-i18n="anahtar"` ile eşleşir.
  Örnek: İngilizce "Buy on Etsy" butonu `data-i18n="btn.etsy"` → Almancası `de` bloğundaki `'btn.etsy': 'Auf Etsy kaufen',` satırı.
- **Kısa uyarı mesajları** ("Bu link yakında aktif", bülten teşekkür mesajı vb.): aynı dosyada `messages:` altında, 5 dil için.
- Metinde düz kesme işareti (') kullanacaksanız metni çift tırnakla yazın: `"Etsy'den Satın Al"` — ya da tipografik `’` kullanın.
- Bir dilde bir anahtar eksikse o yazı İngilizce görünür (site bozulmaz).
- Sayfa başlığı ve Google açıklaması da dile göre değişir: `meta.title` ve `meta.description` anahtarları.

### Dil seçici nasıl çalışır?
- Sağ üstteki 🌐 **EN ▾** butonu bir menü açar (klavyeyle de kullanılabilir: ok tuşları, Enter, Esc). Telefonda ☰ menüsünün içinde de 5 dil butonu var.
- Site ziyaretçinin **tarayıcı diline** göre otomatik açılır (Almanca tarayıcı → Almanca). Ziyaretçinin seçimi hatırlanır.
- Link ile dil zorlanabilir: `https://www.nextstopguides.com/?lang=de` (tr, de, fr, es, en). Instagram/TikTok'ta Almanca kitleye bu linki verin.
- `privacy.html` 5 dilin hepsini alt alta içerir; üstteki dil butonlarıyla ilgili bölüme atlanır (ziyaretçi sitede bir dil seçtiyse sayfa otomatik o bölüme kayar).

### Yeni dil ekleme (örnek: İtalyanca `it`)
1. `assets/js/i18n.js` → `languages:` listesine `it: 'Italiano',` ekleyin (dil menüsüne otomatik eklenir).
2. Aynı dosyada `ogLocale:` içine `it: 'it_IT'` ekleyin.
3. `messages:` içine `es: { ... }` bloğunu kopyalayıp adını `it` yapın ve metinleri çevirin.
4. `strings:` içine `es: { ... }` bloğunun tamamını kopyalayıp adını `it` yapın ve **her satırı** çevirin (anahtarlara dokunmayın, sadece sağdaki metne).
5. `index.html` başındaki `hreflang` satırlarına bir tane ekleyin:
   `<link rel="alternate" hreflang="it" href="https://www.nextstopguides.com/?lang=it">`
   ve `og:locale:alternate` satırlarına `it_IT` ekleyin.
6. `sitemap.xml` içinde her `<url>` bloğuna `hreflang="it"` satırını ekleyin ve `?lang=it` için yeni bir `<url>` bloğu açın (mevcut bloklardan birini kopyalayın).
7. (İsteğe bağlı) `privacy.html` sonuna o dilde kısa bir bölüm ekleyin (`<section lang="it">`, `id="it"`).
8. Kontrol: sayfayı açın → dil menüsünden yeni dili seçin → İngilizce kalan yazı varsa o anahtar eksiktir.
   Bilgisayarınızda Node.js varsa klasörde `node tools/check-i18n.js` komutu eksik anahtarları listeler.

---

## 4. Siteyi ücretsiz yayınlamak

### Seçenek A — Netlify Drop (en kolayı, 2 dakika)
1. https://app.netlify.com/drop adresine gidin (ücretsiz hesap açın).
2. **`nextstopguides-web` klasörünü** sürükleyip sayfaya bırakın.
3. Size `https://rastgele-isim.netlify.app` gibi bir adres verir. **Site settings → Change site name** ile değiştirin.
4. Güncelleme: **Deploys** sekmesine klasörü tekrar sürükleyin.
5. Kendi alan adınız (örn. nextstopguides.com): **Domain management → Add a domain**.

### Seçenek B — GitHub Pages
1. https://github.com'da ücretsiz hesap → **New repository** → adı `nextstopguides-web` → Public.
2. **Add file → Upload files** → klasörün **içindeki** tüm dosyaları sürükleyin → **Commit changes**.
3. **Settings → Pages → Branch: main / root → Save**. Birkaç dakika içinde `https://kullaniciadi.github.io/nextstopguides-web/` adresinde yayında.
   > Not: Bu adreste 404 sayfasının logosu görünmeyebilir; kendi alan adınızı bağlayınca düzelir.

### Seçenek C — Cloudflare Pages
1. https://dash.cloudflare.com → **Workers & Pages → Create → Pages → Upload assets**.
2. Proje adı verin → klasörü yükleyin → **Deploy**. Adres: `https://proje-adi.pages.dev`.

---

## 5. Affiliate (ortaklık) linklerini almak

| Servis | Nereden başvurulur | Not |
|---|---|---|
| **Airalo** (eSIM) | airalo.com sayfasının alt kısmındaki **Partners / Affiliate** bağlantısı | Başvuru bir affiliate ağı üzerinden yürüyebilir; onaydan sonra panelden size özel link alırsınız. |
| **Booking.com** (otel) | booking.com sayfasının altındaki **Affiliate Program / Become an affiliate** bağlantısı | Bazı ülkelerde başvuru Awin/CJ gibi ağlara yönlendirilir. |
| **GetYourGuide** (tur) | **partner.getyourguide.com** | Onaydan sonra "Link creator" ile İstanbul/Kapadokya turlarına özel link üretebilirsiniz. |

💡 **Kolay yol:** **Travelpayouts** (travelpayouts.com) gibi seyahat affiliate platformlarında bu markaların birçoğu tek hesapta toplanır.

**İpuçları:**
- Başvuruda web sitenizin adresini ve sosyal medya hesaplarınızı gösterin — bu yüzden önce siteyi yayınlayın.
- Aldığınız linki `config.js` → `affiliates` içine yapıştırın. Site bu linklere otomatik `rel="sponsored"` ekler (Google kuralı).
- Programların koşulları değişebilir; başvurmadan önce güncel şartları okuyun.
- Affiliate bildirimi (disclosure) zaten sitede var: partner bölümünde, altbilgide ve `privacy.html`'de.

---

## 6. SEO kontrol listesi (Google'da çıkmak için)

Site şu an Cloudflare Pages'te yayında: **`https://nextstopguides-all.pages.dev`** ve dosyalardaki adresler buna göre ayarlı.
İleride kendi alan adınızı (örn. `https://www.nextstopguides.com`) bağladığınızda aşağıdaki dosyalarda
**Ctrl + H (Bul ve Değiştir)** ile `https://nextstopguides-all.pages.dev` yazan her yeri yeni adresle değiştirin:

- [ ] `index.html` → `canonical`, `hreflang`, `og:url`, `og:image`, `twitter:image` ve JSON-LD içindeki tüm adresler
- [ ] `privacy.html` → `canonical`, `og:url`, `og:image`
- [ ] `sitemap.xml` → tüm `<loc>` adresleri (+ tarihleri `<lastmod>`)
- [ ] `robots.txt` → `Sitemap:` satırı
- [ ] `assets/img/og-image.jpg` ekleyin (1200×630) — paylaşım önizlemesi için
- [ ] `privacy.html` içindeki `BURAYA_TARIH` yazısını bugünün tarihiyle değiştirin
- [ ] **Google Search Console**: https://search.google.com/search-console → "Mülk ekle" → alan adınızı doğrulayın → **Site haritaları** bölümüne `sitemap.xml` yazıp gönderin
- [ ] (İsteğe bağlı) **Bing Webmaster Tools**'a da aynı şekilde ekleyin (Search Console'dan içe aktarılabilir)
- [ ] Yapısal veriyi test edin: https://search.google.com/test/rich-results → sitenizin adresini yapıştırın
- [ ] Hız testi: https://pagespeed.web.dev
- [ ] Paylaşım önizlemesini test edin: https://www.opengraph.xyz

> Örnek yorumlar (testimonials) bölümü açıkça "Örnek" olarak işaretlidir. Gerçek müşteri yorumları geldikçe
> `index.html` ve `main.js` içindeki `t.q1`, `t.w1`... metinlerini **müşterinin izniyle** gerçekleriyle değiştirin ve
> "örnek" notunu kaldırın. Uydurma yorumu gerçekmiş gibi göstermeyin (yasal risk + güven kaybı).

---

## 7. İleride: Tailwind CDN yerine "derlenmiş" CSS (isteğe bağlı, daha hızlı)

Şu an tasarım, internetten yüklenen **Tailwind Play CDN** ile çalışıyor. Bu, kurulum gerektirmediği için idealdir,
ancak Tailwind bunu "geliştirme amaçlı" önerir (tarayıcı konsolunda bir uyarı görebilirsiniz; site yine çalışır).
Site büyüdüğünde veya hız puanını artırmak istediğinizde, bir geliştiriciye şunu yaptırabilir ya da kendiniz yapabilirsiniz:

1. **Node.js** kurun: https://nodejs.org (LTS sürümü).
2. `nextstopguides-web` klasöründe adres çubuğuna `cmd` yazıp Enter'a basın, sonra:

   ```bash
   npm init -y
   npm install -D tailwindcss@3
   npx tailwindcss init
   ```
3. Oluşan `tailwind.config.js` dosyasına, `index.html`'deki `tailwind.config = { ... }` içindeki `theme` bölümünü kopyalayın ve şunu ekleyin:

   ```js
   module.exports = {
     content: ["./*.html", "./assets/js/*.js"],
     theme: { /* index.html'deki theme bölümü buraya */ },
     plugins: [],
   };
   ```
4. `assets/css/tailwind-input.css` adında bir dosya oluşturun, içine:

   ```css
   @tailwind base;
   @tailwind components;
   @tailwind utilities;
   ```
5. CSS'i üretin:

   ```bash
   npx tailwindcss -i ./assets/css/tailwind-input.css -o ./assets/css/tailwind.css --minify
   ```
6. `index.html` ve `privacy.html` içinde `<script src="https://cdn.tailwindcss.com"></script>` satırını **ve** altındaki
   `tailwind.config = {...}` script'ini silin, yerine şunu yazın:

   ```html
   <link rel="stylesheet" href="assets/css/tailwind.css">
   ```
7. HTML'de her değişiklikten sonra 5. adımdaki komutu tekrar çalıştırın (veya `--watch` ekleyin).

> Not: Yukarıdaki komutlar **Tailwind v3** içindir (bu sitedeki ayar yapısıyla birebir uyumlu). Tailwind v4 farklı bir kurulum kullanır.

---

## 8. Sık karşılaşılan sorunlar

- **Sayfa tasarımsız (düz yazı) görünüyor** → İnternet bağlantınızı kontrol edin (Tailwind internetten yüklenir).
- **Linkim çalışmıyor** → `config.js`'te linkin `https://` ile başladığından ve tırnak içinde olduğundan emin olun. Tarayıcıda **F12 → Console** sekmesinde doldurulmamış linklerin listesi yazar.
- **Sayfa tamamen bozuldu** → Büyük ihtimalle `config.js`'te bir tırnak veya virgül silindi. Yaptığınız son değişikliği geri alın (Ctrl + Z).
- **Türkçe çeviride bir yazı İngilizce kaldı** → `main.js` içindeki `TR` listesinde o anahtar eksiktir; ekleyin.
