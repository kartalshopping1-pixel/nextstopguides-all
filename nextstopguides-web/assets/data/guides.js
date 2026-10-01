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
     image       : Kapak görseli: Etsy görsel linki YA DA sitedeki dosya, örn.
                   'assets/img/guides/<slug>.jpg' (1200 px genişlik) + yanında '<slug>-480.jpg'
     etsy        : Etsy ürün linki (listing henüz yoksa '' → kartta buton yok,
                   rehber sayfasında "Etsy mağazamız" butonu mağazaya gider)
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
      priceTRY: '',
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
      priceTRY: '',
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
      priceTRY: '',
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
    },

    /* ---- Yeni rehberler (Ekim 2026). Etsy/Shopier listing'leri henüz yok:
       etsy/shopier '' → kartta buton yok, rehber sayfasında "Etsy mağazamız" butonu.
       Listing açılınca linkleri yapıştırıp node tools/build-guides.js çalıştırın. ---- */
    {
      slug: 'thailand-7-day-itinerary',
      destination: 'thailand',
      days: 7,
      cities: ['Bangkok', 'Krabi', 'Ao Nang', 'Phi Phi', 'Railay'],
      tags: ['beach', 'islands', 'temples', 'street food', 'floating market'],
      image: 'assets/img/guides/thailand-7-day-itinerary.jpg',
      etsy: 'https://www.etsy.com/listing/4586664518/thailand-itinerary-7-days-bangkok-krabi',
      shopier: '',   // TODO listing URL (Shopier ürün linki, Türkçe baskı)
      priceTRY: '',
      price: '',
      text: {
        en: {
          title: 'Thailand 7-Day Itinerary',
          description: 'Three nights of golden temples, Chinatown street food and floating markets in Bangkok, then four beach nights in Krabi with a speedboat day to the Phi Phi Islands and the cliffs of Railay.',
          highlights: [
            'Day-by-day route: 3 nights in Bangkok, 4 nights in Ao Nang (Krabi)',
            'Grand Palace, Wat Pho and Wat Arun, plus a floating market and the train market',
            'Phi Phi by speedboat, Railay & Phra Nang Cave Beach and the Tiger Cave Temple',
            'Hotels in three budget levels in Bangkok and Krabi, plus breakfast and dinner picks',
            'Hour-by-hour version, budget plan, useful Thai phrases and a fillable bonus kit'
          ]
        },
        tr: {
          title: 'Tayland 7 Günlük Gezi Planı',
          description: 'Bangkok’ta altın tapınaklar, Çin Mahallesi’nde sokak lezzetleri ve yüzen pazarlarla üç gece; ardından Krabi’de dört gece deniz, sürat teknesiyle Phi Phi Adaları ve Railay’in kayalıkları.',
          highlights: [
            'Gün gün rota: Bangkok’ta 3 gece, Ao Nang’da (Krabi) 4 gece',
            'Büyük Saray, Wat Pho ve Wat Arun; ayrıca yüzen pazar ve tren pazarı',
            'Sürat teknesiyle Phi Phi, Railay ve Phra Nang Mağara Plajı, Kaplan Mağarası Tapınağı',
            'Bangkok ve Krabi’de üç bütçe seviyesinde otel, kahvaltı ve akşam yemeği önerileri',
            'Saat saat plan, bütçe planı, işe yarar Tayca ifadeler ve doldurulabilir bonus kit'
          ]
        },
        de: {
          title: 'Thailand-Reiseplan: 7 Tage',
          description: 'Drei Nächte in Bangkok mit goldenen Tempeln, Streetfood in Chinatown und schwimmenden Märkten – danach vier Strandnächte in Krabi mit Speedboot-Tour zu den Phi-Phi-Inseln und den Felsen von Railay.',
          highlights: [
            'Tag-für-Tag-Route: 3 Nächte in Bangkok, 4 Nächte in Ao Nang (Krabi)',
            'Großer Palast, Wat Pho und Wat Arun, dazu ein schwimmender Markt und der Zugmarkt',
            'Phi Phi per Speedboot, Railay mit Phra Nang Cave Beach und der Tiger-Cave-Tempel',
            'Hotels in drei Preisklassen in Bangkok und Krabi, Frühstücks- und Abendessen-Tipps',
            'Stundenplan, Budgetplan, nützliche Thai-Sätze und ein ausfüllbares Bonus-Kit'
          ]
        },
        fr: {
          title: 'Itinéraire Thaïlande 7 jours',
          description: 'Trois nuits à Bangkok entre temples dorés, street food de Chinatown et marchés flottants, puis quatre nuits balnéaires à Krabi, avec une sortie en hors-bord aux îles Phi Phi et les falaises de Railay.',
          highlights: [
            'Itinéraire jour par jour : 3 nuits à Bangkok, 4 nuits à Ao Nang (Krabi)',
            'Grand Palais, Wat Pho et Wat Arun, plus un marché flottant et le marché sur les rails',
            'Phi Phi en hors-bord, Railay et la plage de Phra Nang, et le temple de la Grotte du Tigre',
            'Hôtels dans trois gammes de prix à Bangkok et à Krabi, adresses pour le petit-déjeuner et le dîner',
            'Version heure par heure, budget, phrases utiles en thaï et kit bonus à remplir'
          ]
        },
        es: {
          title: 'Itinerario por Tailandia de 7 días',
          description: 'Tres noches en Bangkok entre templos dorados, comida callejera en Chinatown y mercados flotantes; después, cuatro noches de playa en Krabi con excursión en lancha a las islas Phi Phi y los acantilados de Railay.',
          highlights: [
            'Ruta día a día: 3 noches en Bangkok y 4 noches en Ao Nang (Krabi)',
            'Gran Palacio, Wat Pho y Wat Arun, además de un mercado flotante y el mercado del tren',
            'Phi Phi en lancha rápida, Railay y la playa de Phra Nang, y el Templo de la Cueva del Tigre',
            'Hoteles en tres niveles de precio en Bangkok y Krabi, y dónde desayunar y cenar',
            'Versión hora a hora, presupuesto, frases útiles en tailandés y kit extra rellenable'
          ]
        }
      }
    },

    {
      slug: 'paris-3-day-itinerary',
      destination: 'france',
      days: 3,
      cities: ['Paris'],
      tags: ['first trip', 'city break', 'long weekend', 'Eiffel Tower', 'Louvre', 'Montmartre'],
      image: 'assets/img/guides/paris-3-day-itinerary.jpg',
      etsy: 'https://www.etsy.com/listing/4586670451/paris-itinerary-3-days-printable-paris',
      shopier: '',   // TODO listing URL (Shopier ürün linki, Türkçe baskı)
      priceTRY: '',
      price: '',
      text: {
        en: {
          title: 'Paris 3-Day Itinerary',
          description: 'A first-timer’s Paris, planned hour by hour: Notre-Dame and the Left Bank, the Louvre, the Champs-Élysées and the Eiffel Tower, then Montmartre, the Musée d’Orsay and Le Marais.',
          highlights: [
            'Three well-paced days: the islands & Left Bank, Louvre to Eiffel Tower, Montmartre & Le Marais',
            'Hotel picks in three budget levels across Paris’s best neighborhoods',
            'Day-by-day breakfast and dinner picks, plus a budget plan',
            'Getting in from CDG and Orly, and how metro tickets work in 2026',
            'Hour-by-hour version, useful French phrases and a fillable bonus kit'
          ]
        },
        tr: {
          title: 'Paris 3 Günlük Gezi Planı',
          description: 'İlk kez gidenler için saat saat planlanmış Paris: Notre-Dame ve Sol Yaka, Louvre, Champs-Élysées ve Eyfel Kulesi, ardından Montmartre, Orsay Müzesi ve Le Marais.',
          highlights: [
            'Dengeli üç gün: Adalar ve Sol Yaka, Louvre’dan Eyfel’e, Montmartre ve Le Marais',
            'Paris’in en iyi semtlerinde üç bütçe seviyesinde otel önerileri',
            'Her gün için kahvaltı ve akşam yemeği önerileri, ayrıca bütçe planı',
            'CDG ve Orly’den şehre ulaşım, 2026’da metro biletleri nasıl işliyor',
            'Saat saat plan, işe yarar Fransızca ifadeler ve doldurulabilir bonus kit'
          ]
        },
        de: {
          title: 'Paris-Reiseplan: 3 Tage',
          description: 'Paris für Erstbesucher, Stunde für Stunde geplant: Notre-Dame und das linke Seineufer, der Louvre, die Champs-Élysées und der Eiffelturm, dann Montmartre, das Musée d’Orsay und Le Marais.',
          highlights: [
            'Drei gut getaktete Tage: Inseln & Rive Gauche, Louvre bis Eiffelturm, Montmartre & Le Marais',
            'Hotels in drei Preisklassen in den besten Vierteln von Paris',
            'Frühstücks- und Abendessen-Tipps für jeden Tag, dazu ein Budgetplan',
            'Anreise von CDG und Orly und wie Metro-Tickets 2026 funktionieren',
            'Stundenplan, nützliche französische Sätze und ein ausfüllbares Bonus-Kit'
          ]
        },
        fr: {
          title: 'Itinéraire Paris 3 jours',
          description: 'Paris pour une première visite, planifié heure par heure : Notre-Dame et la rive gauche, le Louvre, les Champs-Élysées et la tour Eiffel, puis Montmartre, le musée d’Orsay et le Marais.',
          highlights: [
            'Trois jours bien rythmés : les îles et la rive gauche, du Louvre à la tour Eiffel, Montmartre et le Marais',
            'Hôtels dans trois gammes de prix, dans les meilleurs quartiers de Paris',
            'Adresses pour le petit-déjeuner et le dîner chaque jour, plus un budget',
            'Rejoindre Paris depuis CDG et Orly, et les tickets de métro en 2026',
            'Version heure par heure, phrases utiles en français et kit bonus à remplir'
          ]
        },
        es: {
          title: 'Itinerario por París de 3 días',
          description: 'París para tu primer viaje, planificado hora a hora: Notre-Dame y la orilla izquierda, el Louvre, los Campos Elíseos y la torre Eiffel, y después Montmartre, el Museo de Orsay y Le Marais.',
          highlights: [
            'Tres días bien repartidos: las islas y la orilla izquierda, del Louvre a la torre Eiffel, Montmartre y Le Marais',
            'Hoteles en tres niveles de precio en los mejores barrios de París',
            'Dónde desayunar y cenar cada día, además de un presupuesto',
            'Cómo llegar desde CDG y Orly, y cómo funcionan los billetes de metro en 2026',
            'Versión hora a hora, frases útiles en francés y kit extra rellenable'
          ]
        }
      }
    },

    {
      slug: 'paris-5-day-itinerary',
      destination: 'france',
      days: 5,
      cities: ['Paris', 'Versailles', 'Giverny'],
      tags: ['first trip', 'day trip', 'Versailles', 'Giverny', 'Eiffel Tower', 'Louvre'],
      image: 'assets/img/guides/paris-5-day-itinerary.jpg',
      etsy: 'https://www.etsy.com/listing/4586675821/paris-itinerary-5-days-with-versailles',
      shopier: '',   // TODO listing URL (Shopier ürün linki, Türkçe baskı)
      priceTRY: '',
      price: '',
      text: {
        en: {
          title: 'Paris 5-Day Itinerary',
          description: 'The classic three days in Paris plus a full day at the Palace of Versailles and a fifth day along Canal Saint-Martin, Père-Lachaise and the Marais museums — or Monet’s Giverny instead.',
          highlights: [
            'Notre-Dame, the Louvre, the Eiffel Tower, Montmartre and the Musée d’Orsay',
            'A full day trip to the Palace and Gardens of Versailles',
            'Canal Saint-Martin and Père-Lachaise, or swap in Monet’s Giverny',
            'Hotels in three budget levels, breakfast and dinner picks and a budget plan',
            'Hour-by-hour version, metro and airport tips, and a fillable bonus kit'
          ]
        },
        tr: {
          title: 'Paris 5 Günlük Gezi Planı',
          description: 'Klasik üç günlük Paris’e ek olarak Versay Sarayı’nda tam bir gün ve Canal Saint-Martin, Père-Lachaise ve Marais müzeleriyle beşinci gün — ya da onun yerine Monet’nin Giverny’si.',
          highlights: [
            'Notre-Dame, Louvre, Eyfel Kulesi, Montmartre ve Orsay Müzesi',
            'Versay Sarayı ve Bahçeleri’ne tam günlük gezi',
            'Canal Saint-Martin ve Père-Lachaise ya da onun yerine Monet’nin Giverny’si',
            'Üç bütçe seviyesinde otel, kahvaltı ve akşam yemeği önerileri, bütçe planı',
            'Saat saat plan, metro ve havalimanı ipuçları, doldurulabilir bonus kit'
          ]
        },
        de: {
          title: 'Paris-Reiseplan: 5 Tage',
          description: 'Die klassischen drei Tage Paris plus ein ganzer Tag im Schloss Versailles und ein fünfter Tag am Canal Saint-Martin, auf dem Père-Lachaise und in den Museen des Marais – oder stattdessen Monets Giverny.',
          highlights: [
            'Notre-Dame, Louvre, Eiffelturm, Montmartre und das Musée d’Orsay',
            'Ganztägiger Ausflug zu Schloss und Gärten von Versailles',
            'Canal Saint-Martin und Père-Lachaise – oder stattdessen Monets Giverny',
            'Hotels in drei Preisklassen, Frühstücks- und Abendessen-Tipps und Budgetplan',
            'Stundenplan, Tipps zu Metro und Flughafen und ein ausfüllbares Bonus-Kit'
          ]
        },
        fr: {
          title: 'Itinéraire Paris 5 jours',
          description: 'Les trois jours classiques à Paris, plus une journée complète au château de Versailles et un cinquième jour entre le canal Saint-Martin, le Père-Lachaise et les musées du Marais — ou Giverny et le jardin de Monet.',
          highlights: [
            'Notre-Dame, le Louvre, la tour Eiffel, Montmartre et le musée d’Orsay',
            'Une journée complète au château et dans les jardins de Versailles',
            'Le canal Saint-Martin et le Père-Lachaise, ou Giverny à la place',
            'Hôtels dans trois gammes de prix, adresses pour le petit-déjeuner et le dîner, budget',
            'Version heure par heure, conseils métro et aéroport, kit bonus à remplir'
          ]
        },
        es: {
          title: 'Itinerario por París de 5 días',
          description: 'Los tres días clásicos en París, más un día completo en el Palacio de Versalles y un quinto día por el Canal Saint-Martin, Père-Lachaise y los museos de Le Marais, o Giverny, el jardín de Monet, en su lugar.',
          highlights: [
            'Notre-Dame, el Louvre, la torre Eiffel, Montmartre y el Museo de Orsay',
            'Excursión de un día completo al Palacio y los Jardines de Versalles',
            'Canal Saint-Martin y Père-Lachaise, o Giverny de Monet en su lugar',
            'Hoteles en tres niveles de precio, dónde desayunar y cenar, y presupuesto',
            'Versión hora a hora, consejos de metro y aeropuerto, y kit extra rellenable'
          ]
        }
      }
    },

    {
      slug: 'georgia-5-day-itinerary',
      destination: 'georgia',
      days: 5,
      cities: ['Tbilisi', 'Kazbegi', 'Batumi'],
      tags: ['Caucasus', 'mountains', 'wine', 'Kakheti', 'Black Sea', 'sulphur baths', 'day trip'],
      image: 'assets/img/guides/georgia-5-day-itinerary.jpg',
      etsy: 'https://www.etsy.com/listing/4586678691/georgia-itinerary-5-days-tbilisi-kazbegi',
      shopier: '',   // TODO listing URL (Shopier ürün linki, Türkçe baskı)
      priceTRY: '',
      price: '',
      text: {
        en: {
          title: 'Georgia 5-Day Itinerary',
          description: 'Old Tbilisi and its sulphur baths, a Caucasus day trip to Kazbegi along the Georgian Military Highway (or Kakheti wine country instead), then the train to Batumi on the Black Sea.',
          highlights: [
            'Three nights in Tbilisi and two in Batumi, planned hour by hour',
            'Kazbegi day trip: Ananuri Fortress and Gergeti Trinity Church below Mount Kazbek',
            'A Kakheti wine-day alternative (Bodbe and Sighnaghi), handy in winter',
            'Batumi’s Botanical Garden, the Argo cable car and the fish market',
            'Hotels in three budget levels, plus a reverse route if you arrive overland from Türkiye'
          ]
        },
        tr: {
          title: 'Gürcistan 5 Günlük Gezi Planı',
          description: 'Eski Tiflis ve kükürtlü hamamları, Gürcü Askeri Yolu üzerinden Kazbegi’ye bir günlük Kafkasya turu (ya da Kaheti şarap bölgesi), ardından trenle Karadeniz kıyısındaki Batum.',
          highlights: [
            'Tiflis’te üç, Batum’da iki gece; saat saat planlanmış',
            'Kazbegi turu: Ananuri Kalesi ve Kazbek Dağı eteğindeki Gergeti Sameba Kilisesi',
            'Alternatif Kaheti şarap günü (Bodbe ve Sighnaghi); kışın ideal',
            'Batum Botanik Bahçesi, Argo teleferiği ve balık pazarı',
            'Üç bütçe seviyesinde otel ve Sarp’tan karayoluyla gelenler için ters rota'
          ]
        },
        de: {
          title: 'Georgien-Reiseplan: 5 Tage',
          description: 'Die Altstadt von Tiflis mit ihren Schwefelbädern, ein Tagesausflug in den Kaukasus nach Kasbegi über die Georgische Heerstraße (oder stattdessen ins Weinland Kachetien), dann mit dem Zug nach Batumi ans Schwarze Meer.',
          highlights: [
            'Drei Nächte in Tiflis und zwei in Batumi, Stunde für Stunde geplant',
            'Ausflug nach Kasbegi: Festung Ananuri und die Gergeti-Dreifaltigkeitskirche am Kasbek',
            'Alternative: ein Weintag in Kachetien (Bodbe und Signagi), ideal im Winter',
            'Batumis Botanischer Garten, die Argo-Seilbahn und der Fischmarkt',
            'Hotels in drei Preisklassen plus umgekehrte Route bei Anreise über Land aus der Türkei'
          ]
        },
        fr: {
          title: 'Itinéraire Géorgie 5 jours',
          description: 'La vieille ville de Tbilissi et ses bains sulfureux, une excursion dans le Caucase jusqu’à Kazbegi par la route militaire géorgienne (ou la région viticole de Kakhétie), puis le train jusqu’à Batoumi, sur la mer Noire.',
          highlights: [
            'Trois nuits à Tbilissi et deux à Batoumi, planifiées heure par heure',
            'Excursion à Kazbegi : forteresse d’Ananouri et église de la Trinité de Guerguéti, au pied du Kazbek',
            'Une journée vins en Kakhétie (Bodbe et Signagi) en alternative, idéale en hiver',
            'Le jardin botanique de Batoumi, le téléphérique Argo et le marché aux poissons',
            'Hôtels dans trois gammes de prix, plus un itinéraire inversé si vous arrivez de Turquie par la route'
          ]
        },
        es: {
          title: 'Itinerario por Georgia de 5 días',
          description: 'El casco antiguo de Tiflis y sus baños de azufre, una excursión por el Cáucaso hasta Kazbegi por la carretera militar georgiana (o la región vinícola de Kajetia) y, después, el tren hasta Batumi, en el mar Negro.',
          highlights: [
            'Tres noches en Tiflis y dos en Batumi, planificadas hora a hora',
            'Excursión a Kazbegi: fortaleza de Ananuri e iglesia de la Trinidad de Gergeti, bajo el monte Kazbek',
            'Alternativa: un día de vinos en Kajetia (Bodbe y Sighnaghi), ideal en invierno',
            'El Jardín Botánico de Batumi, el teleférico Argo y el mercado de pescado',
            'Hoteles en tres niveles de precio y ruta inversa si llegas por tierra desde Turquía'
          ]
        }
      }
    },

    {
      slug: 'dubai-4-day-itinerary',
      destination: 'uae',
      days: 4,
      cities: ['Dubai', 'Abu Dhabi'],
      tags: ['Burj Khalifa', 'desert safari', 'souks', 'beach', 'Dubai Marina', 'Abu Dhabi'],
      image: 'assets/img/guides/dubai-4-day-itinerary.jpg',
      etsy: 'https://www.etsy.com/listing/4586684708/dubai-itinerary-4-days-printable-dubai',
      shopier: '',   // TODO listing URL (Shopier ürün linki, Türkçe baskı)
      priceTRY: '',
      price: '',
      text: {
        en: {
          title: 'Dubai 4-Day Itinerary',
          description: 'Skyscrapers, souks and sand dunes in four days planned around the heat — outdoors in the cool hours, air-conditioned sights at midday — plus an optional fifth day in Abu Dhabi.',
          highlights: [
            'Burj Khalifa at sunset, Old Dubai’s souks and an abra ride across the Creek',
            'Museum of the Future, Dubai Frame and an evening desert safari',
            'Jumeirah beaches and Dubai Marina, plus an optional Abu Dhabi day (Grand Mosque & Louvre)',
            'Hotels in three budget levels in Downtown, Dubai Marina and Old Dubai',
            'Metro and Nol card tips, an hour-by-hour version and a fillable bonus kit'
          ]
        },
        tr: {
          title: 'Dubai 4 Günlük Gezi Planı',
          description: 'Gökdelenler, çarşılar ve kum tepeleri; sıcağa göre planlanmış dört gün: serin saatlerde dışarıda, öğle sıcağında klimalı mekânlarda. Üstelik isteğe bağlı beşinci gün: Abu Dabi.',
          highlights: [
            'Gün batımında Burj Khalifa, Eski Dubai çarşıları ve abra ile Creek’i geçmek',
            'Museum of the Future, Dubai Frame ve akşam çöl safarisi',
            'Jumeirah plajları ve Dubai Marina; isteğe bağlı Abu Dabi günü (Büyük Cami ve Louvre)',
            'Downtown, Dubai Marina ve Eski Dubai’de üç bütçe seviyesinde otel',
            'Metro ve Nol kart ipuçları, saat saat plan ve doldurulabilir bonus kit'
          ]
        },
        de: {
          title: 'Dubai-Reiseplan: 4 Tage',
          description: 'Wolkenkratzer, Souks und Sanddünen in vier Tagen, rund um die Hitze geplant – draußen in den kühlen Stunden, klimatisierte Sehenswürdigkeiten am Mittag –, plus ein optionaler fünfter Tag in Abu Dhabi.',
          highlights: [
            'Burj Khalifa bei Sonnenuntergang, die Souks von Alt-Dubai und eine Abra-Fahrt über den Creek',
            'Museum of the Future, Dubai Frame und eine Wüstensafari am Abend',
            'Strände von Jumeirah und Dubai Marina, dazu ein optionaler Abu-Dhabi-Tag (Große Moschee & Louvre)',
            'Hotels in drei Preisklassen in Downtown, Dubai Marina und Alt-Dubai',
            'Tipps zu Metro und Nol-Karte, Stundenplan und ein ausfüllbares Bonus-Kit'
          ]
        },
        fr: {
          title: 'Itinéraire Dubaï 4 jours',
          description: 'Gratte-ciel, souks et dunes de sable en quatre jours pensés pour la chaleur — dehors aux heures fraîches, visites climatisées à midi —, avec un cinquième jour facultatif à Abou Dabi.',
          highlights: [
            'Burj Khalifa au coucher du soleil, les souks du vieux Dubaï et la traversée de la Creek en abra',
            'Museum of the Future, Dubai Frame et un safari dans le désert en soirée',
            'Plages de Jumeirah et Dubai Marina, plus une journée facultative à Abou Dabi (Grande Mosquée et Louvre)',
            'Hôtels dans trois gammes de prix à Downtown, Dubai Marina et dans le vieux Dubaï',
            'Conseils métro et carte Nol, version heure par heure et kit bonus à remplir'
          ]
        },
        es: {
          title: 'Itinerario por Dubái de 4 días',
          description: 'Rascacielos, zocos y dunas en cuatro días pensados para el calor (al aire libre en las horas frescas, visitas con aire acondicionado a mediodía), con un quinto día opcional en Abu Dabi.',
          highlights: [
            'El Burj Khalifa al atardecer, los zocos del viejo Dubái y un paseo en abra por el Creek',
            'Museum of the Future, Dubai Frame y un safari por el desierto al atardecer',
            'Playas de Jumeirah y Dubai Marina, y un día opcional en Abu Dabi (Gran Mezquita y Louvre)',
            'Hoteles en tres niveles de precio en Downtown, Dubai Marina y el viejo Dubái',
            'Consejos de metro y tarjeta Nol, versión hora a hora y kit extra rellenable'
          ]
        }
      }
    },

    {
      slug: 'egypt-cairo-luxor-5-day-itinerary',
      destination: 'egypt',
      days: 5,
      cities: ['Cairo', 'Giza', 'Luxor'],
      tags: ['pyramids', 'Grand Egyptian Museum', 'Valley of the Kings', 'Nile', 'ancient history', 'first trip'],
      image: 'assets/img/guides/egypt-cairo-luxor-5-day-itinerary.jpg',
      etsy: 'https://www.etsy.com/listing/4586687206/egypt-itinerary-5-days-cairo-giza-luxor',
      shopier: '',   // TODO listing URL (Shopier ürün linki, Türkçe baskı)
      priceTRY: '',
      price: '',
      text: {
        en: {
          title: 'Egypt 5-Day Itinerary: Cairo & Luxor',
          description: 'The pyramids at opening time, the new Grand Egyptian Museum, Islamic Cairo, Karnak and a sunrise over the Valley of the Kings — a first-timer’s Egypt, planned around the heat.',
          highlights: [
            'Three nights in Cairo & Giza and two in Luxor, with flight vs. sleeper train compared',
            'The pyramids, the Sphinx and the Grand Egyptian Museum in one day',
            'Islamic Cairo: the Citadel, Al-Muizz Street and Khan el-Khalili',
            'Karnak, Luxor Temple, a sunrise balloon ride and the Valley of the Kings',
            'Hotels in three budget levels, food picks, safety tips and an hour-by-hour version'
          ]
        },
        tr: {
          title: 'Mısır 5 Günlük Gezi Planı: Kahire ve Luksor',
          description: 'Kapılar açılırken piramitler, yeni Büyük Mısır Müzesi, İslami Kahire, Karnak ve Krallar Vadisi’nde gün doğumu — sıcağa göre planlanmış, ilk kez gidenler için bir Mısır rotası.',
          highlights: [
            'Kahire ve Gize’de üç, Luksor’da iki gece; uçak ve yataklı tren karşılaştırması',
            'Piramitler, Sfenks ve Büyük Mısır Müzesi aynı günde',
            'İslami Kahire: Kale, Muizz Caddesi ve Han el-Halili',
            'Karnak, Luksor Tapınağı, gün doğumunda balon ve Krallar Vadisi',
            'Üç bütçe seviyesinde otel, yemek önerileri, güvenlik ipuçları ve saat saat plan'
          ]
        },
        de: {
          title: 'Ägypten-Reiseplan: 5 Tage Kairo & Luxor',
          description: 'Die Pyramiden zur Öffnungszeit, das neue Große Ägyptische Museum, das islamische Kairo, Karnak und ein Sonnenaufgang über dem Tal der Könige – Ägypten für Erstbesucher, rund um die Hitze geplant.',
          highlights: [
            'Drei Nächte in Kairo & Gizeh, zwei in Luxor – Flug und Schlafwagen im Vergleich',
            'Pyramiden, Sphinx und das Große Ägyptische Museum an einem Tag',
            'Islamisches Kairo: Zitadelle, Al-Muizz-Straße und Khan el-Khalili',
            'Karnak, Luxor-Tempel, Ballonfahrt bei Sonnenaufgang und das Tal der Könige',
            'Hotels in drei Preisklassen, Essenstipps, Sicherheitshinweise und Stundenplan'
          ]
        },
        fr: {
          title: 'Itinéraire Égypte 5 jours : Le Caire et Louxor',
          description: 'Les pyramides dès l’ouverture, le nouveau Grand Musée égyptien, le Caire islamique, Karnak et un lever de soleil sur la Vallée des Rois — l’Égypte pour une première visite, pensée pour la chaleur.',
          highlights: [
            'Trois nuits au Caire et à Gizeh, deux à Louxor, avec avion et train de nuit comparés',
            'Les pyramides, le Sphinx et le Grand Musée égyptien en une journée',
            'Le Caire islamique : la Citadelle, la rue al-Muizz et Khan el-Khalili',
            'Karnak, le temple de Louxor, une montgolfière au lever du soleil et la Vallée des Rois',
            'Hôtels dans trois gammes de prix, adresses où manger, conseils de sécurité et version heure par heure'
          ]
        },
        es: {
          title: 'Itinerario por Egipto de 5 días: El Cairo y Lúxor',
          description: 'Las pirámides a la hora de apertura, el nuevo Gran Museo Egipcio, El Cairo islámico, Karnak y un amanecer sobre el Valle de los Reyes: Egipto para tu primer viaje, planificado según el calor.',
          highlights: [
            'Tres noches en El Cairo y Guiza y dos en Lúxor, con avión y tren nocturno comparados',
            'Las pirámides, la Esfinge y el Gran Museo Egipcio en un solo día',
            'El Cairo islámico: la Ciudadela, la calle al-Muizz y Jan el-Jalili',
            'Karnak, el templo de Lúxor, globo al amanecer y el Valle de los Reyes',
            'Hoteles en tres niveles de precio, dónde comer, consejos de seguridad y versión hora a hora'
          ]
        }
      }
    },

    {
      slug: 'egypt-hurghada-luxor-cairo-7-day-itinerary',
      destination: 'egypt',
      days: 7,
      cities: ['Hurghada', 'El Gouna', 'Luxor', 'Cairo', 'Giza'],
      tags: ['Red Sea', 'beach', 'snorkelling', 'pyramids', 'Grand Egyptian Museum', 'Valley of the Kings'],
      image: 'assets/img/guides/egypt-hurghada-luxor-cairo-7-day-itinerary.jpg',
      etsy: 'https://www.etsy.com/listing/4586704443/egypt-itinerary-7-days-hurghada-luxor',
      shopier: '',   // TODO listing URL (Shopier ürün linki, Türkçe baskı)
      priceTRY: '',
      price: '',
      text: {
        en: {
          title: 'Egypt 7-Day Itinerary: Hurghada, Luxor & Cairo',
          description: 'Red Sea reefs in Hurghada, Karnak and the Valley of the Kings in Luxor, then the pyramids and the Grand Egyptian Museum in Cairo — one route, no backtracking.',
          highlights: [
            'Three nights in Hurghada, two in Luxor and two in Cairo & Giza',
            'Giftun Island boat trip with snorkelling, old-town El Dahar and an evening in El Gouna',
            'By road to Luxor: Karnak, Luxor Temple, a sunrise balloon and the Valley of the Kings',
            'Fly to Cairo for the Grand Egyptian Museum and the pyramids at opening time',
            'Hotels in three budget levels at every stop, food picks and an hour-by-hour version'
          ]
        },
        tr: {
          title: 'Mısır 7 Günlük Gezi Planı: Hurghada, Luksor ve Kahire',
          description: 'Hurghada’da Kızıldeniz resifleri, Luksor’da Karnak ve Krallar Vadisi, Kahire’de piramitler ve Büyük Mısır Müzesi — geri dönüşsüz tek rota.',
          highlights: [
            'Hurghada’da üç, Luksor’da iki, Kahire ve Gize’de iki gece',
            'Giftun Adası tekne turu ve şnorkel, eski şehir El Dahar ve El Gouna’da bir akşam',
            'Karayoluyla Luksor: Karnak, Luksor Tapınağı, gün doğumunda balon ve Krallar Vadisi',
            'Kahire’ye uçuş: Büyük Mısır Müzesi ve kapılar açılırken piramitler',
            'Her durakta üç bütçe seviyesinde otel, yemek önerileri ve saat saat plan'
          ]
        },
        de: {
          title: 'Ägypten-Reiseplan: 7 Tage Hurghada, Luxor & Kairo',
          description: 'Riffe am Roten Meer in Hurghada, Karnak und das Tal der Könige in Luxor, dann die Pyramiden und das Große Ägyptische Museum in Kairo – eine Route ohne Umwege.',
          highlights: [
            'Drei Nächte in Hurghada, zwei in Luxor und zwei in Kairo & Gizeh',
            'Bootsausflug zur Insel Giftun mit Schnorcheln, Altstadt El Dahar und ein Abend in El Gouna',
            'Auf der Straße nach Luxor: Karnak, Luxor-Tempel, Ballonfahrt bei Sonnenaufgang und Tal der Könige',
            'Flug nach Kairo: Großes Ägyptisches Museum und die Pyramiden zur Öffnungszeit',
            'Hotels in drei Preisklassen an jeder Station, Essenstipps und Stundenplan'
          ]
        },
        fr: {
          title: 'Itinéraire Égypte 7 jours : Hurghada, Louxor et Le Caire',
          description: 'Les récifs de la mer Rouge à Hurghada, Karnak et la Vallée des Rois à Louxor, puis les pyramides et le Grand Musée égyptien au Caire — un seul itinéraire, sans retour en arrière.',
          highlights: [
            'Trois nuits à Hurghada, deux à Louxor et deux au Caire et à Gizeh',
            'Sortie en bateau à l’île de Giftun avec snorkeling, la vieille ville d’El Dahar et une soirée à El Gouna',
            'Par la route jusqu’à Louxor : Karnak, le temple de Louxor, une montgolfière à l’aube et la Vallée des Rois',
            'Vol pour Le Caire : le Grand Musée égyptien et les pyramides dès l’ouverture',
            'Hôtels dans trois gammes de prix à chaque étape, adresses où manger et version heure par heure'
          ]
        },
        es: {
          title: 'Itinerario por Egipto de 7 días: Hurghada, Lúxor y El Cairo',
          description: 'Arrecifes del mar Rojo en Hurghada, Karnak y el Valle de los Reyes en Lúxor y, después, las pirámides y el Gran Museo Egipcio en El Cairo: una sola ruta, sin volver sobre tus pasos.',
          highlights: [
            'Tres noches en Hurghada, dos en Lúxor y dos en El Cairo y Guiza',
            'Excursión en barco a la isla de Giftun con esnórquel, el casco antiguo de El Dahar y una tarde en El Gouna',
            'Por carretera a Lúxor: Karnak, el templo de Lúxor, globo al amanecer y el Valle de los Reyes',
            'Vuelo a El Cairo: el Gran Museo Egipcio y las pirámides a la hora de apertura',
            'Hoteles en tres niveles de precio en cada parada, dónde comer y versión hora a hora'
          ]
        }
      }
    },

    {
      slug: 'egypt-sharm-cairo-luxor-8-day-itinerary',
      destination: 'egypt',
      days: 8,
      cities: ['Cairo', 'Giza', 'Luxor', 'Sharm El Sheikh'],
      tags: ['Red Sea', 'beach', 'snorkelling', 'Ras Mohammed', 'Mount Sinai', 'pyramids', 'Valley of the Kings'],
      image: 'assets/img/guides/egypt-sharm-cairo-luxor-8-day-itinerary.jpg',
      etsy: 'https://www.etsy.com/listing/4586699833/egypt-itinerary-8-days-sharm-el-sheikh',
      shopier: '',   // TODO listing URL (Shopier ürün linki, Türkçe baskı)
      priceTRY: '',
      price: '',
      text: {
        en: {
          title: 'Egypt 8-Day Itinerary: Cairo, Luxor & Sharm El Sheikh',
          description: 'Culture first, beach last: the pyramids and the Grand Egyptian Museum, Karnak and a sunrise over the Valley of the Kings, then three days of Red Sea reefs in Sharm El Sheikh.',
          highlights: [
            'Two nights in Cairo & Giza, two in Luxor and three in Sharm El Sheikh, linked by domestic flights',
            'The pyramids, the Sphinx, the Grand Egyptian Museum and an evening in Islamic Cairo',
            'Karnak, Luxor Temple, a sunrise balloon and the Valley of the Kings',
            'Ras Mohammed National Park by boat, then the Tiran reefs or a Mount Sinai sunrise',
            'Hotels in three budget levels, Naama Bay and the Old Market, and an hour-by-hour version'
          ]
        },
        tr: {
          title: 'Mısır 8 Günlük Gezi Planı: Kahire, Luksor ve Şarm el-Şeyh',
          description: 'Önce kültür, sonra deniz: piramitler ve Büyük Mısır Müzesi, Karnak ve Krallar Vadisi’nde gün doğumu, ardından Şarm el-Şeyh’te üç gün Kızıldeniz resifleri.',
          highlights: [
            'Kahire ve Gize’de iki, Luksor’da iki, Şarm el-Şeyh’te üç gece; iç hat uçuşlarıyla bağlantılı',
            'Piramitler, Sfenks, Büyük Mısır Müzesi ve İslami Kahire’de bir akşam',
            'Karnak, Luksor Tapınağı, gün doğumunda balon ve Krallar Vadisi',
            'Tekneyle Ras Muhammed Milli Parkı, ardından Tiran resifleri ya da Sina Dağı’nda gün doğumu',
            'Üç bütçe seviyesinde otel, Naama Körfezi ve Eski Çarşı, saat saat plan'
          ]
        },
        de: {
          title: 'Ägypten-Reiseplan: 8 Tage Kairo, Luxor & Scharm El-Scheich',
          description: 'Erst Kultur, dann Strand: die Pyramiden und das Große Ägyptische Museum, Karnak und ein Sonnenaufgang über dem Tal der Könige, danach drei Tage an den Riffen des Roten Meeres in Scharm El-Scheich.',
          highlights: [
            'Zwei Nächte in Kairo & Gizeh, zwei in Luxor und drei in Scharm El-Scheich, verbunden durch Inlandsflüge',
            'Pyramiden, Sphinx, das Große Ägyptische Museum und ein Abend im islamischen Kairo',
            'Karnak, Luxor-Tempel, Ballonfahrt bei Sonnenaufgang und das Tal der Könige',
            'Mit dem Boot in den Ras-Mohammed-Nationalpark, dann die Tiran-Riffe oder Sonnenaufgang auf dem Berg Sinai',
            'Hotels in drei Preisklassen, Naama Bay und der Old Market sowie ein Stundenplan'
          ]
        },
        fr: {
          title: 'Itinéraire Égypte 8 jours : Le Caire, Louxor et Charm el-Cheikh',
          description: 'La culture d’abord, la plage ensuite : les pyramides et le Grand Musée égyptien, Karnak et un lever de soleil sur la Vallée des Rois, puis trois jours sur les récifs de la mer Rouge à Charm el-Cheikh.',
          highlights: [
            'Deux nuits au Caire et à Gizeh, deux à Louxor et trois à Charm el-Cheikh, reliées par des vols intérieurs',
            'Les pyramides, le Sphinx, le Grand Musée égyptien et une soirée dans le Caire islamique',
            'Karnak, le temple de Louxor, une montgolfière à l’aube et la Vallée des Rois',
            'Le parc national de Ras Mohammed en bateau, puis les récifs de Tiran ou le lever du soleil sur le mont Sinaï',
            'Hôtels dans trois gammes de prix, la baie de Naama et le vieux marché, et une version heure par heure'
          ]
        },
        es: {
          title: 'Itinerario por Egipto de 8 días: El Cairo, Lúxor y Sharm el-Sheij',
          description: 'Primero la cultura y al final la playa: las pirámides y el Gran Museo Egipcio, Karnak y un amanecer sobre el Valle de los Reyes y, después, tres días de arrecifes del mar Rojo en Sharm el-Sheij.',
          highlights: [
            'Dos noches en El Cairo y Guiza, dos en Lúxor y tres en Sharm el-Sheij, unidas por vuelos internos',
            'Las pirámides, la Esfinge, el Gran Museo Egipcio y una tarde en El Cairo islámico',
            'Karnak, el templo de Lúxor, globo al amanecer y el Valle de los Reyes',
            'El Parque Nacional de Ras Mohammed en barco y, después, los arrecifes de Tirán o el amanecer en el monte Sinaí',
            'Hoteles en tres niveles de precio, la bahía de Naama y el mercado viejo, y versión hora a hora'
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
    'georgia':        { region: 'europe', name: { en: 'Georgia', tr: 'Gürcistan', de: 'Georgien', fr: 'Géorgie', es: 'Georgia' } },
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
