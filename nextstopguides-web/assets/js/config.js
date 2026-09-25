/* =====================================================================
   NextStopGuides — SİTE AYARLARI (config.js)
   ---------------------------------------------------------------------
   Sitedeki TÜM dış linkler ve fiyatlar burada. Sadece tırnak ("...")
   içindeki değerleri değiştirin. Virgülleri ve süslü parantezleri silmeyin.

   "BURAYA_" ile başlayan her değer henüz doldurulmamış demektir.
   Doldurulmamış linke tıklanınca site "Bu link yakında aktif" uyarısı
   gösterir; yani site bozulmaz.
   ===================================================================== */

window.NSG_CONFIG = {

  /* ---- Mağazalar --------------------------------------------------- */
  shops: {
    etsy:    "BURAYA_ETSY_MAGAZA_LINKI",      // örn: https://www.etsy.com/shop/NextStopGuides
    shopier: "BURAYA_SHOPIER_MAGAZA_LINKI"    // örn: https://www.shopier.com/NextStopGuides
  },

  /* ---- Rehberler (ürünler) ------------------------------------------
     price    : Etsy / uluslararası fiyat (sitede büyük yazılır)
     priceTRY : Shopier fiyatı (sitede küçük yazılır)
     etsy     : O ürünün Etsy ürün sayfası linki
     shopier  : O ürünün Shopier ürün sayfası linki
     NOT: Fiyatı değiştirirseniz index.html içindeki JSON-LD bölümündeki
     "price" değerini de güncelleyin (README'de anlatılıyor).            */
  products: {
    istanbul: {
      price:    "$9.99",
      priceTRY: "₺349",
      etsy:     "BURAYA_ETSY_ISTANBUL_URUN_LINKI",
      shopier:  "BURAYA_SHOPIER_ISTANBUL_URUN_LINKI"
    },
    cappadocia: {
      price:    "$8.99",
      priceTRY: "₺299",
      etsy:     "BURAYA_ETSY_KAPADOKYA_URUN_LINKI",
      shopier:  "BURAYA_SHOPIER_KAPADOKYA_URUN_LINKI"
    },
    antalya: {
      price:    "$8.99",
      priceTRY: "₺299",
      etsy:     "BURAYA_ETSY_ANTALYA_URUN_LINKI",
      shopier:  "BURAYA_SHOPIER_ANTALYA_URUN_LINKI"
    },
    europe: {
      price:    "$12.99",
      priceTRY: "₺449",
      etsy:     "BURAYA_ETSY_AVRUPA_URUN_LINKI",
      shopier:  "BURAYA_SHOPIER_AVRUPA_URUN_LINKI"
    }
  },

  /* ---- Affiliate (ortaklık) linkleri -------------------------------
     Partner programlarından aldığınız size özel takip linkleri.       */
  affiliates: {
    airalo:       "BURAYA_AIRALO_AFFILIATE_LINKI",
    booking:      "BURAYA_BOOKING_AFFILIATE_LINKI",
    getyourguide: "BURAYA_GETYOURGUIDE_AFFILIATE_LINKI"
  },

  /* ---- Sosyal medya ------------------------------------------------ */
  social: {
    instagram: "BURAYA_INSTAGRAM_LINKI",
    tiktok:    "BURAYA_TIKTOK_LINKI",
    youtube:   "BURAYA_YOUTUBE_LINKI",
    pinterest: "BURAYA_PINTEREST_LINKI"
  },

  /* ---- İletişim ---------------------------------------------------- */
  contact: {
    email: "BURAYA_ILETISIM_EPOSTA"           // örn: hello@nextstopguides.com
  },

  /* ---- Bülten (newsletter) formu -----------------------------------
     Sitenin kendi sunucusu yok. E-posta toplamak için ücretsiz bir
     servis kullanın (Mailchimp, Brevo, MailerLite, Formspree...).
     O servisin verdiği "form action" adresini buraya yapıştırın.
     emailFieldName: servisin beklediği alan adı
       - Mailchimp: "EMAIL"   - Formspree / Brevo / çoğu: "email"
     Doldurulmazsa form gönderilmez, sadece bilgi mesajı gösterir.     */
  newsletter: {
    action:         "BURAYA_BULTEN_FORM_ACTION_LINKI",
    method:         "POST",
    emailFieldName: "email"
  }
};
