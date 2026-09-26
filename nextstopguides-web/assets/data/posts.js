/* =====================================================================
   NextStopGuides — BLOG YAZILARI (posts.js)
   ---------------------------------------------------------------------
   Her blog yazısı bu listede TEK BİR KAYITTIR (en yenisi en üstte).
   Yazının METNİ ayrı dosyalarda:
       content/blog/<slug>/en.md   (İngilizce — zorunlu)
       content/blog/<slug>/tr.md   (Türkçe — önerilir)
       content/blog/<slug>/de.md, fr.md, es.md (isteğe bağlı; yoksa
       o dillerde İngilizce metin + "Bu yazı İngilizce" notu gösterilir)

   YENİ YAZI: README.md → "Yeni blog yazısı nasıl eklenir".

   ALANLAR
     slug   : adres → /blog/<slug>/ (küçük harf, tire, Türkçe karakter yok)
     date   : yayın tarihi 'YYYY-AA-GG'
     emoji  : kapak simgesi
     tags   : etiketler (arama/SEO için)
     guides : yazının sonunda önerilecek rehberlerin slug'ları
     text   : her dil için title (başlık) + description (kısa özet)
   Metin içindeki özel linkler (md dosyalarında):
     [metin](guide:japan-7-day-itinerary)  → rehber sayfası
     [metin](packing:adapter)              → bavul listesinde o ürün ([metin](packing:) = sayfanın kendisi)
     [metin](partner:airalo)               → config.js'teki partner linki (airalo, klook, hotels, welcomepickups)
     [metin](post:kyoto-in-2-days)         → başka bir blog yazısı
     [metin](page:guides/)                 → sitedeki bir sayfa
     [metin](https://...)                  → dış link
   ===================================================================== */

window.NSG_POSTS = [
  {
    slug: 'first-time-japan-mistakes',
    date: '2026-09-26',
    emoji: '🎌',
    tags: ['japan', 'first trip', 'tips', 'etiquette'],
    guides: ['japan-5-day-itinerary', 'japan-7-day-itinerary', 'japan-10-day-itinerary'],
    text: {
      en: { title: '12 First-Time Japan Mistakes (and How to Avoid Them)', description: 'From the JR Pass and cash to luggage, plugs and etiquette: the most common first-trip mistakes in Japan and simple ways to avoid them.' },
      tr: { title: 'Japonya’ya İlk Gidişte Yapılan 12 Hata (ve Nasıl Kaçınılır)', description: 'JR Pass ve nakitten bavul, priz ve görgü kurallarına: Japonya’ya ilk gidişte en sık yapılan hatalar ve bunlardan kaçınmanın basit yolları.' },
      de: { title: '12 typische Fehler bei der ersten Japanreise (und wie du sie vermeidest)', description: 'Vom JR Pass über Bargeld bis zu Gepäck, Steckdosen und Etikette: die häufigsten Fehler bei der ersten Japanreise und wie du sie einfach vermeidest.' },
      fr: { title: '12 erreurs à éviter lors d’un premier voyage au Japon', description: 'JR Pass, espèces, bagages, prises électriques et savoir-vivre : les erreurs les plus fréquentes lors d’un premier voyage au Japon et comment les éviter.' },
      es: { title: '12 errores del primer viaje a Japón (y cómo evitarlos)', description: 'Del JR Pass y el efectivo al equipaje, los enchufes y la etiqueta: los errores más comunes en un primer viaje a Japón y cómo evitarlos fácilmente.' }
    }
  },
  {
    slug: 'where-to-stay-in-tokyo',
    date: '2026-09-26',
    emoji: '🏙️',
    tags: ['japan', 'tokyo', 'hotels', 'neighborhoods'],
    guides: ['japan-7-day-itinerary', 'japan-5-day-itinerary'],
    text: {
      en: { title: 'Where to Stay in Tokyo: Neighborhoods Compared for First-Timers', description: 'Shinjuku, Shibuya, Tokyo Station, Asakusa, Ueno and more — an honest comparison of Tokyo’s best areas to stay, with pros, cons and airport tips.' },
      tr: { title: 'Tokyo’da Nerede Kalınır? İlk Kez Gidenler İçin Semt Karşılaştırması', description: 'Shinjuku, Shibuya, Tokyo İstasyonu, Asakusa, Ueno ve fazlası — Tokyo’da kalınacak en iyi bölgelerin artı ve eksileriyle dürüst bir karşılaştırması.' },
      de: { title: 'Wo übernachten in Tokio? Stadtviertel im Vergleich', description: 'Shinjuku, Shibuya, Tokyo Station, Asakusa, Ueno und mehr – ein ehrlicher Vergleich der besten Viertel in Tokio mit Vor- und Nachteilen und Flughafen-Tipps.' },
      fr: { title: 'Où loger à Tokyo ? Les quartiers comparés pour un premier séjour', description: 'Shinjuku, Shibuya, gare de Tokyo, Asakusa, Ueno et plus encore : une comparaison honnête des meilleurs quartiers où loger à Tokyo, avec avantages et inconvénients.' },
      es: { title: 'Dónde alojarse en Tokio: barrios comparados para tu primer viaje', description: 'Shinjuku, Shibuya, la estación de Tokio, Asakusa, Ueno y más: una comparación honesta de las mejores zonas para alojarse en Tokio, con pros y contras.' }
    }
  },
  {
    slug: 'kyoto-in-2-days',
    date: '2026-09-26',
    emoji: '⛩️',
    tags: ['japan', 'kyoto', 'itinerary', 'temples'],
    guides: ['japan-7-day-itinerary', 'japan-10-day-itinerary'],
    text: {
      en: { title: 'Kyoto in 2 Days: A Realistic Plan for First-Time Visitors', description: 'Fushimi Inari, Kiyomizu-dera, Gion, Arashiyama and the Golden Pavilion in two well-paced days — with timing tips to beat the crowds.' },
      tr: { title: 'Kyoto’da 2 Gün: İlk Kez Gidenler İçin Gerçekçi Bir Plan', description: 'Fushimi Inari, Kiyomizu-dera, Gion, Arashiyama ve Altın Köşk; iyi ayarlanmış iki günde — kalabalıktan kaçmak için zamanlama ipuçlarıyla.' },
      de: { title: 'Kyoto in 2 Tagen: ein realistischer Plan für Erstbesucher', description: 'Fushimi Inari, Kiyomizu-dera, Gion, Arashiyama und der Goldene Pavillon in zwei gut getakteten Tagen – mit Timing-Tipps gegen die Menschenmassen.' },
      fr: { title: 'Kyoto en 2 jours : un programme réaliste pour une première visite', description: 'Fushimi Inari, Kiyomizu-dera, Gion, Arashiyama et le Pavillon d’or en deux jours bien rythmés, avec des conseils d’horaires pour éviter la foule.' },
      es: { title: 'Kioto en 2 días: un plan realista para tu primera visita', description: 'Fushimi Inari, Kiyomizu-dera, Gion, Arashiyama y el Pabellón Dorado en dos días bien organizados, con consejos de horarios para evitar las multitudes.' }
    }
  },
  {
    slug: 'osaka-food-guide',
    date: '2026-09-26',
    emoji: '🐙',
    tags: ['japan', 'osaka', 'food', 'etiquette'],
    guides: ['japan-5-day-itinerary', 'japan-7-day-itinerary', 'japan-10-day-itinerary'],
    text: {
      en: { title: 'Osaka Food Guide: What to Eat and How to Order', description: 'Takoyaki, okonomiyaki, kushikatsu and more: what to eat in Osaka, where to find it, and how ticket machines, tablets and izakaya charges work.' },
      tr: { title: 'Osaka Yemek Rehberi: Ne Yenir, Nasıl Sipariş Verilir?', description: 'Takoyaki, okonomiyaki, kushikatsu ve fazlası: Osaka’da ne yenir, nerede bulunur; bilet makineleri, tabletler ve izakaya ücretleri nasıl işler?' },
      de: { title: 'Osaka Food Guide: was du essen solltest und wie du bestellst', description: 'Takoyaki, Okonomiyaki, Kushikatsu und mehr: was man in Osaka isst, wo man es findet und wie Ticketautomaten, Tablets und Izakaya-Gebühren funktionieren.' },
      fr: { title: 'Guide gourmand d’Osaka : que manger et comment commander', description: 'Takoyaki, okonomiyaki, kushikatsu et plus encore : que manger à Osaka, où le trouver et comment fonctionnent distributeurs de tickets, tablettes et frais d’izakaya.' },
      es: { title: 'Guía gastronómica de Osaka: qué comer y cómo pedir', description: 'Takoyaki, okonomiyaki, kushikatsu y más: qué comer en Osaka, dónde encontrarlo y cómo funcionan las máquinas de tickets, las tablets y los cargos de las izakayas.' }
    }
  },
  {
    slug: 'getting-around-japan',
    date: '2026-09-26',
    emoji: '🚄',
    tags: ['japan', 'transport', 'jr pass', 'ic card', 'shinkansen'],
    guides: ['japan-10-day-itinerary', 'japan-7-day-itinerary'],
    text: {
      en: { title: 'Getting Around Japan: IC Cards, the JR Pass and Regional Passes Explained', description: 'How IC cards, Shinkansen tickets and rail passes work — and a simple four-step method to decide whether the JR Pass is worth it for your route.' },
      tr: { title: 'Japonya’da Ulaşım: IC Kartlar, JR Pass ve Bölgesel Paslar', description: 'IC kartlar, Shinkansen biletleri ve tren pasları nasıl işler — ve JR Pass’in rotana değip değmeyeceğine karar vermek için basit dört adımlı yöntem.' },
      de: { title: 'Unterwegs in Japan: IC-Karten, JR Pass und regionale Pässe erklärt', description: 'Wie IC-Karten, Shinkansen-Tickets und Bahnpässe funktionieren – und eine einfache Vier-Schritte-Methode, um zu entscheiden, ob sich der JR Pass für deine Route lohnt.' },
      fr: { title: 'Se déplacer au Japon : cartes IC, JR Pass et pass régionaux', description: 'Comment fonctionnent les cartes IC, les billets de Shinkansen et les pass ferroviaires, et une méthode simple en quatre étapes pour savoir si le JR Pass vaut le coup.' },
      es: { title: 'Cómo moverse por Japón: tarjetas IC, JR Pass y pases regionales', description: 'Cómo funcionan las tarjetas IC, los billetes de Shinkansen y los pases de tren, y un método sencillo en cuatro pasos para decidir si el JR Pass compensa en tu ruta.' }
    }
  },
  {
    slug: 'japan-esim-vs-pocket-wifi',
    date: '2026-09-26',
    emoji: '📶',
    tags: ['japan', 'esim', 'internet', 'pocket wifi'],
    guides: ['japan-5-day-itinerary', 'japan-7-day-itinerary'],
    text: {
      en: { title: 'Japan eSIM vs Pocket Wi-Fi: Which Should You Choose?', description: 'eSIM, pocket Wi-Fi, SIM card or roaming? Pros and cons of each option for Japan, who each one suits, and how to set up an eSIM step by step.' },
      tr: { title: 'Japonya İçin eSIM mi Pocket Wi-Fi mı?', description: 'eSIM, pocket Wi-Fi, SIM kart ya da roaming? Japonya için her seçeneğin artı ve eksileri, kime uygun olduğu ve adım adım eSIM kurulumu.' },
      de: { title: 'Japan: eSIM oder Pocket-WLAN – was ist besser?', description: 'eSIM, Pocket-WLAN, SIM-Karte oder Roaming? Vor- und Nachteile jeder Option für Japan, für wen sie passt und wie du eine eSIM Schritt für Schritt einrichtest.' },
      fr: { title: 'Japon : eSIM ou pocket Wi-Fi, que choisir ?', description: 'eSIM, pocket Wi-Fi, carte SIM ou itinérance ? Avantages et inconvénients de chaque option au Japon, pour qui elle convient, et comment installer une eSIM pas à pas.' },
      es: { title: 'Japón: ¿eSIM o pocket Wi-Fi? Cuál elegir', description: '¿eSIM, pocket Wi-Fi, tarjeta SIM o roaming? Ventajas e inconvenientes de cada opción en Japón, para quién es cada una y cómo configurar una eSIM paso a paso.' }
    }
  },
  {
    slug: 'japan-packing-list',
    date: '2026-09-26',
    emoji: '🎒',
    tags: ['japan', 'packing', 'checklist'],
    guides: ['japan-7-day-itinerary', 'japan-10-day-itinerary'],
    text: {
      en: { title: 'Japan Packing List: What to Bring (and What to Leave at Home)', description: 'Plug adapters, power banks, walking shoes, rain gear and the small items that make Japan easier — plus what you can safely leave at home.' },
      tr: { title: 'Japonya Bavul Listesi: Neler Götürülmeli, Neler Evde Kalmalı?', description: 'Priz adaptörü, powerbank, yürüyüş ayakkabısı, yağmurluk ve Japonya’yı kolaylaştıran küçük eşyalar — bir de gönül rahatlığıyla evde bırakabileceklerin.' },
      de: { title: 'Packliste für Japan: was mit muss (und was zu Hause bleibt)', description: 'Reiseadapter, Powerbank, Wanderschuhe, Regenschutz und die kleinen Dinge, die Japan leichter machen – plus was du getrost zu Hause lassen kannst.' },
      fr: { title: 'Liste de bagages pour le Japon : quoi emporter (et quoi laisser)', description: 'Adaptateur, batterie externe, chaussures de marche, protection contre la pluie et les petits objets qui simplifient le Japon, plus ce que vous pouvez laisser chez vous.' },
      es: { title: 'Lista de equipaje para Japón: qué llevar (y qué dejar en casa)', description: 'Adaptador, batería externa, calzado cómodo, ropa para la lluvia y los pequeños objetos que facilitan el viaje, además de lo que puedes dejar en casa.' }
    }
  },
  {
    slug: 'best-time-to-visit-japan',
    date: '2026-09-26',
    emoji: '🌸',
    tags: ['japan', 'seasons', 'cherry blossom', 'autumn leaves', 'weather'],
    guides: ['japan-10-day-itinerary', 'japan-7-day-itinerary', 'japan-5-day-itinerary'],
    text: {
      en: { title: 'Best Time to Visit Japan: A Season-by-Season Guide', description: 'Cherry blossoms, rainy season, summer festivals, autumn leaves and winter snow — what each season is like in Japan and which holidays to plan around.' },
      tr: { title: 'Japonya’ya Gitmek İçin En İyi Zaman: Mevsim Mevsim Rehber', description: 'Kiraz çiçekleri, yağmur mevsimi, yaz festivalleri, sonbahar yaprakları ve kış karı — Japonya’da her mevsim nasıl ve hangi tatillere dikkat etmelisin?' },
      de: { title: 'Beste Reisezeit für Japan: ein Überblick nach Jahreszeiten', description: 'Kirschblüte, Regenzeit, Sommerfeste, Herbstlaub und Winterschnee – wie jede Jahreszeit in Japan ist und welche Feiertage du einplanen solltest.' },
      fr: { title: 'Quand partir au Japon ? Le guide saison par saison', description: 'Cerisiers en fleurs, saison des pluies, festivals d’été, feuillages d’automne et neige d’hiver : à quoi ressemble chaque saison au Japon et quelles fêtes anticiper.' },
      es: { title: 'Mejor época para viajar a Japón: guía estación por estación', description: 'Cerezos en flor, temporada de lluvias, festivales de verano, hojas de otoño y nieve invernal: cómo es cada estación en Japón y qué festivos tener en cuenta.' }
    }
  }
];
