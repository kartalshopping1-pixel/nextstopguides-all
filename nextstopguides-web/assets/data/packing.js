/* =====================================================================
   NextStopGuides — PAKETLEME LİSTESİ / AMAZON (packing.js)
   ---------------------------------------------------------------------
   /packing-list/ sayfasındaki ürünler. Her ürün bir kayıt.

   • id: SABİT tutun! PDF rehberlerdeki linkler buna gider:
       https://thenextstopguides.com/packing-list/?lang=tr#adapter
   • links.us: amazon.com linki (tag=thenextstopgu-20)
     links.tr: amazon.com.tr linki (tag=nextstopguide-21)
     Türkçe ziyaretçiye amazon.com.tr, diğer dillere amazon.com ana
     buton olarak gösterilir; diğer mağaza küçük link olarak çıkar.
   • "BURAYA_" ile başlayan (doldurulmamış) linkler gösterilmez. İki linki
     de boş olan ürün sayfada hiç görünmez.
   • text.en zorunlu; diğer diller isteğe bağlı (yoksa İngilizce görünür).
   • Değişiklikten sonra:  node tools/build-guides.js
   ===================================================================== */

window.NSG_PACKING = {

  items: [
    {
      id: 'adapter', category: 'power', emoji: '🔌',
      links: {
        us: 'https://www.amazon.com/dp/B0BHQNMDNC?tag=thenextstopgu-20',
        tr: 'https://www.amazon.com.tr/s?k=seyahat+priz+adapt%C3%B6r%C3%BC&tag=nextstopguide-21'
      },
      text: {
        en: { name: 'Universal / Japan Type-A plug adapter', why: 'Japan uses two-flat-pin Type A/B sockets, so most European, UK and Turkish plugs won’t fit without one.' },
        tr: { name: 'Universal / Japonya A tipi priz adaptörü', why: 'Japonya’da iki yassı pimli A/B tipi prizler kullanılır; Türkiye ve Avrupa fişleri adaptörsüz takılmaz.' },
        de: { name: 'Universal-/Japan-Reiseadapter (Typ A)', why: 'In Japan gibt es Steckdosen vom Typ A/B mit zwei flachen Stiften – europäische Stecker passen ohne Adapter nicht.' },
        fr: { name: 'Adaptateur universel / Japon (type A)', why: 'Le Japon utilise des prises de type A/B à deux fiches plates : les prises européennes n’y entrent pas sans adaptateur.' },
        es: { name: 'Adaptador universal / Japón (tipo A)', why: 'En Japón los enchufes son de tipo A/B, con dos clavijas planas: los enchufes europeos no entran sin adaptador.' }
      }
    },
    {
      id: 'power-bank', category: 'power', emoji: '🔋',
      links: {
        us: 'https://www.amazon.com/dp/B0DP8VP65K?tag=thenextstopgu-20',
        tr: 'https://www.amazon.com.tr/s?k=powerbank+seyahat+10000+mah&tag=nextstopguide-21'
      },
      text: {
        en: { name: 'Portable charger (10,000 mAh, flight-safe)', why: 'Keeps maps, tickets and your camera going all day; 10,000 mAh is well within airline carry-on limits.' },
        tr: { name: 'Taşınabilir şarj cihazı (10.000 mAh, uçuşa uygun)', why: 'Harita, bilet ve kameran gün boyu çalışsın; 10.000 mAh, havayollarının kabin bagajı sınırlarının rahatça altında.' },
        de: { name: 'Powerbank (10.000 mAh, flugtauglich)', why: 'Hält Karten, Tickets und Kamera den ganzen Tag am Laufen; 10.000 mAh liegen deutlich unter den Handgepäck-Grenzen der Airlines.' },
        fr: { name: 'Batterie externe (10 000 mAh, compatible avion)', why: 'Cartes, billets et appareil photo tiennent toute la journée ; 10 000 mAh reste largement sous les limites des compagnies pour le bagage cabine.' },
        es: { name: 'Batería externa (10.000 mAh, apta para volar)', why: 'Mantiene mapas, entradas y cámara funcionando todo el día; 10.000 mAh está muy por debajo de los límites del equipaje de mano.' }
      }
    },
    {
      id: 'espresso', category: 'power', emoji: '☕',
      links: {
        us: 'https://www.amazon.com/dp/B0BRKFWPF3?tag=thenextstopgu-20',
        tr: 'https://www.amazon.com.tr/s?k=ta%C5%9F%C4%B1nabilir+%C5%9Farjl%C4%B1+espresso+makinesi&tag=nextstopguide-21'
      },
      text: {
        en: { name: 'Portable rechargeable espresso maker (USB-C)', why: 'Proper coffee in the hotel room or on an early train, charged over USB-C.' },
        tr: { name: 'Şarjlı taşınabilir espresso makinesi (USB-C)', why: 'Otel odasında ya da sabah erken trende gerçek bir kahve; USB-C ile şarj olur.' },
        de: { name: 'Tragbare Akku-Espressomaschine (USB-C)', why: 'Richtiger Kaffee im Hotelzimmer oder im frühen Zug – aufgeladen per USB-C.' },
        fr: { name: 'Machine à espresso portable rechargeable (USB-C)', why: 'Un vrai café dans la chambre d’hôtel ou dans le train du matin, rechargeable en USB-C.' },
        es: { name: 'Cafetera espresso portátil recargable (USB-C)', why: 'Un café de verdad en la habitación del hotel o en el tren de primera hora, con carga USB-C.' }
      }
    },
    {
      id: 'day-bag', category: 'out', emoji: '👜',
      links: {
        us: 'https://www.amazon.com/dp/B0D3Z58Y1P?tag=thenextstopgu-20',
        tr: 'https://www.amazon.com.tr/s?k=g%C3%BCvenlikli+seyahat+%C3%A7antas%C4%B1&tag=nextstopguide-21'
      },
      text: {
        en: { name: 'Anti-theft crossbody day bag', why: 'RFID-blocking pockets and a slash-resistant strap keep passport, cards and cash safe in crowded stations.' },
        tr: { name: 'Hırsızlığa karşı çapraz günlük çanta', why: 'RFID engelleyici cepler ve kesilmeye dayanıklı askı; kalabalık istasyonlarda pasaport, kart ve nakit güvende.' },
        de: { name: 'Diebstahlsichere Umhängetasche', why: 'RFID-blockierende Fächer und ein schnittfester Gurt schützen Pass, Karten und Bargeld in vollen Bahnhöfen.' },
        fr: { name: 'Sac bandoulière antivol', why: 'Poches anti-RFID et sangle anti-coupure : passeport, cartes et espèces restent en sécurité dans les gares bondées.' },
        es: { name: 'Bolso bandolera antirrobo', why: 'Bolsillos con bloqueo RFID y correa anticorte para llevar seguros pasaporte, tarjetas y efectivo en estaciones abarrotadas.' }
      }
    },
    {
      id: 'umbrella', category: 'out', emoji: '☂️',
      links: {
        us: 'https://www.amazon.com/dp/B0160HYB8S?tag=thenextstopgu-20',
        tr: 'https://www.amazon.com.tr/s?k=r%C3%BCzgara+dayan%C4%B1kl%C4%B1+mini+%C5%9Femsiye&tag=nextstopguide-21'
      },
      text: {
        en: { name: 'Compact windproof travel umbrella', why: 'Light enough to live in your day bag for sudden showers and the rainy season.' },
        tr: { name: 'Kompakt, rüzgâra dayanıklı seyahat şemsiyesi', why: 'Günlük çantanda taşıyabileceğin kadar hafif; ani sağanaklar ve yağmur mevsimi için ideal.' },
        de: { name: 'Kompakter, sturmfester Reiseschirm', why: 'Leicht genug, um immer in der Tagestasche zu bleiben – für plötzliche Schauer und die Regenzeit.' },
        fr: { name: 'Parapluie de voyage compact anti-vent', why: 'Assez léger pour rester dans votre sac, pour les averses soudaines et la saison des pluies.' },
        es: { name: 'Paraguas de viaje compacto antiviento', why: 'Tan ligero que puede ir siempre en la mochila, para chubascos repentinos y la temporada de lluvias.' }
      }
    },
    {
      id: 'blister', category: 'out', emoji: '🩹',
      links: {
        us: 'https://www.amazon.com/dp/B0DKXTXKZG?tag=thenextstopgu-20',
        tr: 'https://www.amazon.com.tr/s?k=nas%C4%B1r+band%C4%B1+hydrocolloid&tag=nextstopguide-21'
      },
      text: {
        en: { name: 'Hydrocolloid blister bandages', why: 'Japan days easily top 15,000 steps — these cushion hot spots and protect blisters so you keep walking.' },
        tr: { name: 'Hidrokolloid su toplaması bandı', why: 'Japonya’da günde 15.000 adımı aşmak çok kolay; bu bantlar sürtünen noktaları korur ve su toplamasını rahatlatır.' },
        de: { name: 'Hydrokolloid-Blasenpflaster', why: 'In Japan kommen schnell 15.000 Schritte am Tag zusammen – die Pflaster polstern Druckstellen und schützen Blasen.' },
        fr: { name: 'Pansements hydrocolloïdes anti-ampoules', why: 'Au Japon, on dépasse vite 15 000 pas par jour : ces pansements protègent les zones de frottement et les ampoules.' },
        es: { name: 'Apósitos hidrocoloides para ampollas', why: 'En Japón es fácil superar los 15.000 pasos al día: protegen las rozaduras y amortiguan las ampollas.' }
      }
    },
    {
      id: 'packing-cubes', category: 'organise', emoji: '🧳',
      links: {
        us: 'https://www.amazon.com/dp/B0C5XH9P6H?tag=thenextstopgu-20',
        tr: 'https://www.amazon.com.tr/s?k=valiz+i%C3%A7i+d%C3%BCzenleyici+seyahat+organizer+seti&tag=nextstopguide-21'
      },
      text: {
        en: { name: 'Packing cubes / luggage organiser set', why: 'One cube per outfit or city makes multi-hotel trips far easier to pack and unpack.' },
        tr: { name: 'Bavul düzenleyici küp seti', why: 'Her kıyafete ya da şehre bir küp: birden fazla otelde kalınan gezilerde toplanmak çok kolaylaşır.' },
        de: { name: 'Packwürfel-Set / Koffer-Organizer', why: 'Ein Würfel pro Outfit oder Stadt – so packst du bei Reisen mit mehreren Hotels viel schneller.' },
        fr: { name: 'Cubes de rangement / organiseur de valise', why: 'Un cube par tenue ou par ville : faire et défaire sa valise d’hôtel en hôtel devient bien plus simple.' },
        es: { name: 'Set de organizadores de maleta', why: 'Un organizador por conjunto o por ciudad: hacer y deshacer la maleta de hotel en hotel es mucho más fácil.' }
      }
    },
    {
      id: 'bottles', category: 'organise', emoji: '🧴',
      links: {
        us: 'https://www.amazon.com/dp/B09FF7TNDN?tag=thenextstopgu-20',
        tr: 'https://www.amazon.com.tr/s?k=seyahat+%C5%9Fi%C5%9Fesi+seti+silikon+s%C4%B1zd%C4%B1rmaz&tag=nextstopguide-21'
      },
      text: {
        en: { name: 'Leak-proof silicone travel bottles (under 100 ml)', why: 'TSA-friendly sizes for shampoo and skincare in your carry-on, without leaks in the bag.' },
        tr: { name: 'Sızdırmaz silikon seyahat şişeleri (100 ml altı)', why: 'Kabin bagajına uygun boyutlarda şampuan ve cilt bakım ürünleri için; çantada sızıntı yok.' },
        de: { name: 'Auslaufsichere Silikon-Reiseflaschen (unter 100 ml)', why: 'Handgepäck-taugliche Größen für Shampoo und Pflege – ohne dass etwas im Koffer ausläuft.' },
        fr: { name: 'Flacons de voyage en silicone étanches (moins de 100 ml)', why: 'Formats autorisés en cabine pour shampoing et soins, sans fuite dans le sac.' },
        es: { name: 'Botes de viaje de silicona antigoteo (menos de 100 ml)', why: 'Tamaños aptos para el equipaje de mano para champú y cosmética, sin fugas en la maleta.' }
      }
    },
    {
      id: 'steam-iron', category: 'organise', emoji: '👕',
      links: {
        us: 'https://www.amazon.com/dp/B0BHZYFMJB?tag=thenextstopgu-20',
        tr: 'https://www.amazon.com.tr/s?k=mini+seyahat+%C3%BCt%C3%BCs%C3%BC+ta%C5%9F%C4%B1nabilir&tag=nextstopguide-21'
      },
      text: {
        en: { name: 'Mini travel steam iron', why: 'Refreshes creased clothes straight out of the suitcase — handy for nice dinners and special days.' },
        tr: { name: 'Mini seyahat buharlı ütüsü', why: 'Bavuldan buruşuk çıkan kıyafetleri hızla toparlar; akşam yemekleri ve özel günler için pratik.' },
        de: { name: 'Mini-Reisedampfbügeleisen', why: 'Macht zerknitterte Kleidung direkt aus dem Koffer wieder vorzeigbar – praktisch für Abendessen und besondere Tage.' },
        fr: { name: 'Mini fer à repasser vapeur de voyage', why: 'Défroisse vos vêtements à la sortie de la valise — pratique pour un dîner ou une occasion spéciale.' },
        es: { name: 'Mini plancha de vapor de viaje', why: 'Quita las arrugas de la ropa recién sacada de la maleta; ideal para cenas y días especiales.' }
      }
    }
  ],

  categories: {
    power:    { en: 'Power & tech', tr: 'Şarj ve teknoloji', de: 'Strom & Technik', fr: 'Énergie et high-tech', es: 'Energía y tecnología' },
    out:      { en: 'Out and about', tr: 'Gün boyu gezerken', de: 'Unterwegs', fr: 'En balade', es: 'De paseo' },
    organise: { en: 'Packing & organisation', tr: 'Bavul ve düzen', de: 'Packen & Ordnung', fr: 'Bagages et rangement', es: 'Equipaje y organización' }
  }
};
