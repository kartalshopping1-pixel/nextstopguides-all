/* =====================================================================
   NextStopGuides — REHBER KATALOĞU (guides.js)
   ---------------------------------------------------------------------
   Sitedeki her rehber (ürün) bu listede TEK BİR KAYITTIR.

   YENİ REHBER EKLEMEK:
     1. Aşağıdaki "guides" listesinde bir kaydı kopyalayın, virgülüyle
        birlikte hemen altına yapıştırın ve değerleri değiştirin.
     2. Terminalde:  node tools/build-guides.js
     3. Değişiklikleri GitHub'a gönderin (push).

   ALANLAR
     slug        : Sayfa adresi → /guides/<slug>/  (küçük harf, tire; Türkçe karakter yok)
     destination : Ülke anahtarı (aşağıdaki "destinations" listesinden, örn. 'japan', 'italy')
     days        : Gün sayısı (sayı)
     cities      : Şehirler (arama ve kartta görünür)
     tags        : Arama için ek kelimeler (isteğe bağlı)
     image       : Kapak görseli linki (Etsy ürün görselinin linki olabilir)
     etsy        : Etsy ürün linki (zorunlu)
     shopier     : Shopier ürün linki — Türkçe baskı (yoksa "" bırakın, buton gizlenir)
     priceTRY    : Shopier fiyatı, örn. "₺279" (Shopier butonunun yanında görünür)
     price       : Etsy fiyatı, örn. "$12.99" (yoksa "" → buton sadece "View on Etsy" der)
     text.en     : İngilizce başlık, kısa açıklama, öne çıkanlar (ZORUNLU)
     text.tr/de/fr/es : Diğer diller (isteğe bağlı; yoksa İngilizce gösterilir)
   ===================================================================== */

window.NSG_CATALOG = {

  guides: [
    {
      slug: 'japan-10-day-itinerary',
      destination: 'japan',
      days: 10,
      cities: ['Tokyo', 'Kyoto', 'Osaka', 'Nara', 'Hiroshima', 'Miyajima', 'Hakone'],
      tags: ['first trip', 'day trips', 'onsen', 'ryokan', 'temples'],
      image: 'https://i.etsystatic.com/47032809/r/il/01e2fc/8567581068/il_340x270.8567581068_cgb9.jpg',
      etsy: 'https://www.etsy.com/listing/4581191988/japan-10-day-itinerary-pdf-tokyo-kyoto',
      shopier: 'https://www.shopier.com/NextStopGuides/51159845',
      priceTRY: '₺329',
      price: '',
      text: {
        en: {
          title: 'Japan 10-Day Itinerary',
          description: 'The full first-timer’s Japan: Tokyo, Kyoto and Osaka, day trips to Nara and Hiroshima & Miyajima, then two slow nights in Hakone with an onsen ryokan stay before you fly home.',
          highlights: [
            'Day-by-day route from Tokyo to a relaxing Hakone onsen finish',
            'Day trips to Nara and to Hiroshima & Miyajima',
            'Hotels in three budget levels, plus a ryokan-style onsen stay',
            'Breakfast and dinner picks, budget planner and an hour-by-hour version',
            'Interactive Google Map (QR code) with every stop pinned'
          ]
        },
        tr: {
          title: 'Japonya 10 Günlük Gezi Planı',
          description: 'İlk Japonya gezisinin tam hali: Tokyo, Kyoto ve Osaka; Nara ile Hiroşima & Miyajima’ya günübirlik geziler ve dönüşten önce Hakone’de onsenli bir ryokanda iki sakin gece.',
          highlights: [
            'Tokyo’dan Hakone’deki onsen molasına gün gün rota',
            'Nara ve Hiroşima & Miyajima’ya günübirlik geziler',
            'Üç bütçe seviyesinde otel ve ryokan tarzı onsen konaklaması',
            'Kahvaltı ve akşam yemeği önerileri, bütçe planlayıcı ve saat saat plan',
            'Tüm durakların işaretli olduğu interaktif Google Haritası (QR kod)'
          ]
        },
        de: {
          title: 'Japan-Reiseplan: 10 Tage',
          description: 'Japan komplett für Erstbesucher: Tokio, Kyoto und Osaka, Tagesausflüge nach Nara sowie Hiroshima & Miyajima – und zum Abschluss zwei entspannte Nächte in Hakone mit Onsen-Ryokan.',
          highlights: [
            'Tag-für-Tag-Route von Tokio bis zum entspannten Onsen-Finale in Hakone',
            'Tagesausflüge nach Nara und nach Hiroshima & Miyajima',
            'Hotels in drei Preisklassen plus Onsen-Übernachtung im Ryokan-Stil',
            'Frühstücks- und Abendessen-Tipps, Budgetplaner und Stundenplan',
            'Interaktive Google-Karte (QR-Code) mit allen Stationen'
          ]
        },
        fr: {
          title: 'Itinéraire Japon 10 jours',
          description: 'Le Japon complet pour une première visite : Tokyo, Kyoto et Osaka, des excursions à Nara et à Hiroshima & Miyajima, puis deux nuits au calme à Hakone dans un ryokan avec onsen avant le retour.',
          highlights: [
            'Itinéraire jour par jour, de Tokyo jusqu’à une fin en douceur dans un onsen à Hakone',
            'Excursions à Nara et à Hiroshima & Miyajima',
            'Hôtels dans trois gammes de prix, plus une nuit en ryokan avec onsen',
            'Adresses pour le petit-déjeuner et le dîner, budget et version heure par heure',
            'Carte Google interactive (QR code) avec toutes les étapes'
          ]
        },
        es: {
          title: 'Itinerario por Japón de 10 días',
          description: 'Japón completo para tu primer viaje: Tokio, Kioto y Osaka, excursiones a Nara y a Hiroshima y Miyajima, y dos noches tranquilas en Hakone en un ryokan con onsen antes de volver a casa.',
          highlights: [
            'Ruta día a día desde Tokio hasta un final relajado en un onsen de Hakone',
            'Excursiones a Nara y a Hiroshima y Miyajima',
            'Hoteles en tres niveles de precio y una noche en ryokan con onsen',
            'Dónde desayunar y cenar, planificador de presupuesto y versión hora a hora',
            'Mapa interactivo de Google (código QR) con todas las paradas'
          ]
        }
      }
    },

    {
      slug: 'japan-7-day-itinerary',
      destination: 'japan',
      days: 7,
      cities: ['Tokyo', 'Kyoto', 'Osaka', 'Nara'],
      tags: ['first trip', 'day trip', 'deer park', 'temples'],
      image: 'https://i.etsystatic.com/47032809/r/il/08a3b7/8615381315/il_340x270.8615381315_au91.jpg',
      etsy: 'https://www.etsy.com/listing/4581172515/japan-7-day-itinerary-pdf-tokyo-kyoto',
      shopier: 'https://www.shopier.com/NextStopGuides/51159606',
      priceTRY: '₺279',
      price: '',
      text: {
        en: {
          title: 'Japan 7-Day Itinerary',
          description: 'The classic Tokyo–Kyoto–Osaka route plus the day most first-timers wish they’d added: a full day in Nara with its free-roaming deer and the giant Buddha of Tōdai-ji.',
          highlights: [
            'Seven planned days across Tokyo, Kyoto and Osaka',
            'A full Nara day trip: deer park, Tōdai-ji and a mochi-pounding show',
            'Hotels in three budget levels for every city',
            'Hour-by-hour version, budget planner and packing checklist',
            'eSIM, IC card and JR Pass cost comparison'
          ]
        },
        tr: {
          title: 'Japonya 7 Günlük Gezi Planı',
          description: 'Klasik Tokyo–Kyoto–Osaka rotası ve ilk kez gidenlerin “keşke ekleseydik” dediği o gün: serbest dolaşan geyikleri ve Tōdai-ji’nin dev Buda heykeliyle tam gün Nara.',
          highlights: [
            'Tokyo, Kyoto ve Osaka’da planlanmış yedi gün',
            'Tam gün Nara: geyik parkı, Tōdai-ji ve mochi dövme gösterisi',
            'Her şehir için üç bütçe seviyesinde otel',
            'Saat saat plan, bütçe planlayıcı ve bavul listesi',
            'eSIM, IC kart ve JR Pass maliyet karşılaştırması'
          ]
        },
        de: {
          title: 'Japan-Reiseplan: 7 Tage',
          description: 'Die klassische Route Tokio–Kyoto–Osaka plus der Tag, den sich Erstbesucher fast immer wünschen: ein ganzer Tag in Nara mit frei laufenden Hirschen und dem großen Buddha im Tōdai-ji.',
          highlights: [
            'Sieben durchgeplante Tage in Tokio, Kyoto und Osaka',
            'Ganztägiger Ausflug nach Nara: Hirschpark, Tōdai-ji und Mochi-Show',
            'Hotels in drei Preisklassen für jede Stadt',
            'Stundenplan, Budgetplaner und Packliste',
            'Kostenvergleich für eSIM, IC-Karte und JR Pass'
          ]
        },
        fr: {
          title: 'Itinéraire Japon 7 jours',
          description: 'Le grand classique Tokyo–Kyoto–Osaka, plus la journée que presque tous les primo-visiteurs regrettent de ne pas avoir prévue : Nara, ses daims en liberté et le grand Bouddha du Tōdai-ji.',
          highlights: [
            'Sept jours planifiés entre Tokyo, Kyoto et Osaka',
            'Une journée complète à Nara : parc aux daims, Tōdai-ji et spectacle de mochi',
            'Hôtels dans trois gammes de prix pour chaque ville',
            'Version heure par heure, budget et check-list de voyage',
            'Comparatif eSIM, carte IC et JR Pass'
          ]
        },
        es: {
          title: 'Itinerario por Japón de 7 días',
          description: 'La ruta clásica Tokio–Kioto–Osaka más el día que casi todos los primerizos desearían haber añadido: un día completo en Nara, con sus ciervos en libertad y el gran Buda del Tōdai-ji.',
          highlights: [
            'Siete días planificados entre Tokio, Kioto y Osaka',
            'Excursión de un día a Nara: parque de ciervos, Tōdai-ji y espectáculo de mochi',
            'Hoteles en tres niveles de precio en cada ciudad',
            'Versión hora a hora, planificador de presupuesto y lista de equipaje',
            'Comparativa de eSIM, tarjeta IC y JR Pass'
          ]
        }
      }
    },

    {
      slug: 'japan-5-day-itinerary',
      destination: 'japan',
      days: 5,
      cities: ['Tokyo', 'Kyoto', 'Osaka'],
      tags: ['short trip', 'quick trip', 'long weekend', 'first trip'],
      image: 'https://i.etsystatic.com/47032809/r/il/c32cd2/8615225565/il_340x270.8615225565_eec6.jpg',
      etsy: 'https://www.etsy.com/listing/4581163500/japan-5-day-itinerary-pdf-tokyo-kyoto',
      shopier: 'https://www.shopier.com/NextStopGuides/51159170',
      priceTRY: '₺229',
      price: '',
      text: {
        en: {
          title: 'Japan 5-Day Itinerary',
          description: 'Tokyo, Kyoto and Osaka in five tight, well-paced days — the quickest version of our route, ready to follow from the moment you land.',
          highlights: [
            'Three cities in five days with no wasted travel time',
            'Hotels in three budget levels, plus breakfast and dinner picks',
            'Hour-by-hour version for tight planning',
            'Bonus: 6-page fillable kit with checklists and trackers',
            'Tax-free shopping guide and cultural etiquette tips'
          ]
        },
        tr: {
          title: 'Japonya 5 Günlük Gezi Planı',
          description: 'Tokyo, Kyoto ve Osaka’yı beş sıkı ama dengeli günde gör — rotamızın en kısa hali, indiğin andan itibaren takip etmeye hazır.',
          highlights: [
            'Beş günde üç şehir, boşa giden yolculuk günü yok',
            'Üç bütçe seviyesinde otel, kahvaltı ve akşam yemeği önerileri',
            'Sıkı planlama için saat saat versiyon',
            'Bonus: kontrol listeleri ve takip sayfalarıyla 6 sayfalık doldurulabilir kit',
            'Tax-free alışveriş rehberi ve kültürel görgü kuralları'
          ]
        },
        de: {
          title: 'Japan-Reiseplan: 5 Tage',
          description: 'Tokio, Kyoto und Osaka in fünf straffen, gut getakteten Tagen – die kürzeste Version unserer Route, direkt nach der Landung startklar.',
          highlights: [
            'Drei Städte in fünf Tagen – ohne verschenkte Reisetage',
            'Hotels in drei Preisklassen, Frühstücks- und Abendessen-Tipps',
            'Stundenplan für eine straffe Planung',
            'Bonus: 6-seitiges ausfüllbares Kit mit Checklisten und Trackern',
            'Tax-free-Shopping-Guide und Tipps zur Etikette'
          ]
        },
        fr: {
          title: 'Itinéraire Japon 5 jours',
          description: 'Tokyo, Kyoto et Osaka en cinq jours bien rythmés — la version la plus courte de notre itinéraire, prête à suivre dès l’atterrissage.',
          highlights: [
            'Trois villes en cinq jours, sans journée perdue en transport',
            'Hôtels dans trois gammes de prix, adresses pour le petit-déjeuner et le dîner',
            'Version heure par heure pour un planning serré',
            'Bonus : kit de 6 pages à remplir avec check-lists et suivis',
            'Guide du shopping détaxé et conseils de savoir-vivre'
          ]
        },
        es: {
          title: 'Itinerario por Japón de 5 días',
          description: 'Tokio, Kioto y Osaka en cinco días bien aprovechados: la versión más corta de nuestra ruta, lista para seguir desde que aterrizas.',
          highlights: [
            'Tres ciudades en cinco días, sin días perdidos en traslados',
            'Hoteles en tres niveles de precio y recomendaciones para desayunar y cenar',
            'Versión hora a hora para una planificación ajustada',
            'Extra: kit rellenable de 6 páginas con checklists y controles',
            'Guía de compras tax-free y consejos de etiqueta'
          ]
        }
      }
    }
  ],

  /* ===================================================================
     Aşağıdakileri normalde değiştirmeniz gerekmez.
     Listede olmayan bir ülke için rehber eklerseniz, buraya bir satır
     ekleyin (anahtar, kıta ve 5 dilde ülke adı).
     =================================================================== */

  destinations: {
    'japan':          { region: 'asia', name: { en: 'Japan', tr: 'Japonya', de: 'Japan', fr: 'Japon', es: 'Japón' } },
    'south-korea':    { region: 'asia', name: { en: 'South Korea', tr: 'Güney Kore', de: 'Südkorea', fr: 'Corée du Sud', es: 'Corea del Sur' } },
    'china':          { region: 'asia', name: { en: 'China', tr: 'Çin', de: 'China', fr: 'Chine', es: 'China' } },
    'thailand':       { region: 'asia', name: { en: 'Thailand', tr: 'Tayland', de: 'Thailand', fr: 'Thaïlande', es: 'Tailandia' } },
    'vietnam':        { region: 'asia', name: { en: 'Vietnam', tr: 'Vietnam', de: 'Vietnam', fr: 'Vietnam', es: 'Vietnam' } },
    'indonesia':      { region: 'asia', name: { en: 'Indonesia', tr: 'Endonezya', de: 'Indonesien', fr: 'Indonésie', es: 'Indonesia' } },
    'singapore':      { region: 'asia', name: { en: 'Singapore', tr: 'Singapur', de: 'Singapur', fr: 'Singapour', es: 'Singapur' } },
    'turkiye':        { region: 'europe', name: { en: 'Türkiye', tr: 'Türkiye', de: 'Türkei', fr: 'Turquie', es: 'Turquía' } },
    'italy':          { region: 'europe', name: { en: 'Italy', tr: 'İtalya', de: 'Italien', fr: 'Italie', es: 'Italia' } },
    'france':         { region: 'europe', name: { en: 'France', tr: 'Fransa', de: 'Frankreich', fr: 'France', es: 'Francia' } },
    'spain':          { region: 'europe', name: { en: 'Spain', tr: 'İspanya', de: 'Spanien', fr: 'Espagne', es: 'España' } },
    'portugal':       { region: 'europe', name: { en: 'Portugal', tr: 'Portekiz', de: 'Portugal', fr: 'Portugal', es: 'Portugal' } },
    'greece':         { region: 'europe', name: { en: 'Greece', tr: 'Yunanistan', de: 'Griechenland', fr: 'Grèce', es: 'Grecia' } },
    'united-kingdom': { region: 'europe', name: { en: 'United Kingdom', tr: 'Birleşik Krallık', de: 'Vereinigtes Königreich', fr: 'Royaume-Uni', es: 'Reino Unido' } },
    'germany':        { region: 'europe', name: { en: 'Germany', tr: 'Almanya', de: 'Deutschland', fr: 'Allemagne', es: 'Alemania' } },
    'netherlands':    { region: 'europe', name: { en: 'Netherlands', tr: 'Hollanda', de: 'Niederlande', fr: 'Pays-Bas', es: 'Países Bajos' } },
    'switzerland':    { region: 'europe', name: { en: 'Switzerland', tr: 'İsviçre', de: 'Schweiz', fr: 'Suisse', es: 'Suiza' } },
    'uae':            { region: 'middle-east', name: { en: 'United Arab Emirates', tr: 'Birleşik Arap Emirlikleri', de: 'Vereinigte Arabische Emirate', fr: 'Émirats arabes unis', es: 'Emiratos Árabes Unidos' } },
    'egypt':          { region: 'africa', name: { en: 'Egypt', tr: 'Mısır', de: 'Ägypten', fr: 'Égypte', es: 'Egipto' } },
    'morocco':        { region: 'africa', name: { en: 'Morocco', tr: 'Fas', de: 'Marokko', fr: 'Maroc', es: 'Marruecos' } },
    'usa':            { region: 'north-america', name: { en: 'United States', tr: 'Amerika Birleşik Devletleri', de: 'USA', fr: 'États-Unis', es: 'Estados Unidos' } },
    'mexico':         { region: 'north-america', name: { en: 'Mexico', tr: 'Meksika', de: 'Mexiko', fr: 'Mexique', es: 'México' } },
    'peru':           { region: 'south-america', name: { en: 'Peru', tr: 'Peru', de: 'Peru', fr: 'Pérou', es: 'Perú' } },
    'australia':      { region: 'oceania', name: { en: 'Australia', tr: 'Avustralya', de: 'Australien', fr: 'Australie', es: 'Australia' } }
  },

  regions: {
    'asia':          { en: 'Asia', tr: 'Asya', de: 'Asien', fr: 'Asie', es: 'Asia' },
    'europe':        { en: 'Europe', tr: 'Avrupa', de: 'Europa', fr: 'Europe', es: 'Europa' },
    'middle-east':   { en: 'Middle East', tr: 'Orta Doğu', de: 'Naher Osten', fr: 'Moyen-Orient', es: 'Oriente Medio' },
    'africa':        { en: 'Africa', tr: 'Afrika', de: 'Afrika', fr: 'Afrique', es: 'África' },
    'north-america': { en: 'North America', tr: 'Kuzey Amerika', de: 'Nordamerika', fr: 'Amérique du Nord', es: 'América del Norte' },
    'south-america': { en: 'South America', tr: 'Güney Amerika', de: 'Südamerika', fr: 'Amérique du Sud', es: 'América del Sur' },
    'oceania':       { en: 'Oceania', tr: 'Okyanusya', de: 'Ozeanien', fr: 'Océanie', es: 'Oceanía' }
  }
};
