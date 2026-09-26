/* =====================================================================
   NextStopGuides — SİTE AYARLARI (config.js)
   ---------------------------------------------------------------------
   Mağaza, affiliate, sosyal medya ve iletişim linkleri burada.
   Sadece tırnak ("...") içindeki değerleri değiştirin. Virgülleri ve
   süslü parantezleri silmeyin.

   "BURAYA_" ile başlayan her değer henüz doldurulmamış demektir.
   Doldurulmamış linke tıklanınca site "Bu link yakında aktif" uyarısı
   gösterir; yani site bozulmaz.

   REHBERLER (ürünler) artık burada DEĞİL: assets/data/guides.js
   AMAZON paketleme listesi: assets/data/packing.js
   ===================================================================== */

window.NSG_CONFIG = {

  /* ---- Site adresi (canonical, sitemap ve paylaşım linkleri için) --- */
  site: {
    url: "https://thenextstopguides.com"      // sonunda / OLMADAN
  },

  /* ---- Mağazalar --------------------------------------------------- */
  shops: {
    etsy:    "https://www.etsy.com/shop/TheNextStopGuides",
    shopier: "https://www.shopier.com/NextStopGuides"   // Türkçe baskıların satıldığı mağaza
  },

  /* ---- Affiliate (ortaklık) linkleri -------------------------------
     Partner programlarından aldığınız size özel takip linkleri.
     Doldurulmamış (BURAYA_...) kartlarda "Yakında" etiketi görünür.
     Travelpayouts marker (referans için): 777810                      */
  affiliates: {
    airalo:         "https://airalo.tpo.mx/xrqDdjIy",   // Travelpayouts → Airalo (Sub ID "site")
    airaloCode:     "",                                 // (isteğe bağlı) indirim/tavsiye kodu; doluysa kartta "Kopyala" kutusu çıkar
    klook:          "https://klook.tpo.mx/L75DmiXc",    // Travelpayouts → Klook (Japonya sayfası)
    welcomepickups: "https://tpo.mx/4NHBkmvm",          // Travelpayouts → Welcome Pickups
    hotels:         "https://klook.tpo.mx/gMjopC2i"     // Klook otelleri (Travelpayouts, Sub ID: site-hotels)
  },

  /* ---- Partner adları ----------------------------------------------
     "Oteller" kartının altında küçük "Partner: ..." yazısı çıkar.
     Otel partneriniz belli olunca adını yazın (örn. "Booking.com",
     "Hotellook", "Agoda"). Doldurulmazsa bu satır hiç görünmez.       */
  partners: {
    hotelsProvider: "Klook",
    travelpayoutsMarker: "777810"
  },

  /* ---- Sosyal medya ------------------------------------------------ */
  social: {
    instagram: "BURAYA_INSTAGRAM_LINKI",
    tiktok:    "BURAYA_TIKTOK_LINKI",
    youtube:   "BURAYA_YOUTUBE_LINKI",
    pinterest: "BURAYA_PINTEREST_LINKI"
  },

  /* ---- İletişim ----------------------------------------------------
     Doldurulursa "Destinasyon iste" butonu bu adrese e-posta açar.    */
  contact: {
    email: "BURAYA_ILETISIM_EPOSTA"           // örn: hello@thenextstopguides.com
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
