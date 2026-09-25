# assets/img — Görseller

Site şu an **hiç görsel olmadan** da güzel görünür (renk geçişleri, emoji ve SVG ikonlar kullanılıyor).
Aşağıdaki dosyaları eklediğinizde site daha profesyonel görünür. Dosya adlarını **aynen** kullanın.

| Dosya adı | Boyut | Ne için? | Öncelik |
|---|---|---|---|
| `og-image.jpg` | 1200 × 630 px | WhatsApp, Instagram, Facebook, X'te link paylaşınca çıkan önizleme görseli. Logo + "Printable Travel Itineraries" yazısı + bir Japonya fotoğrafı ideal. Eklenmezse ilk rehberin Etsy görseli kullanılır. | Orta |
| `apple-touch-icon.png` | 180 × 180 px | iPhone'da "Ana ekrana ekle" ikonu. `favicon.svg`'nin PNG hali olabilir. | Orta |
| `icon-512.png` | 512 × 512 px | (İsteğe bağlı) Android ikonu. Eklerseniz `site.webmanifest` içine de ekleyin. | Düşük |

## İpuçları
- Görselleri ücretsiz hazırlamak için: **Canva** (hazır "Open Graph / Facebook Post" şablonları var).
- Yüklemeden önce **https://squoosh.app** ile sıkıştırın (hedef: 200 KB altı).
- Kendi çektiğiniz veya lisansı size ait fotoğrafları kullanın (Unsplash/Pexels ücretsiz fotoğrafları da olur).
- Rehber kapak görselleri `assets/data/guides.js` → `image` alanından gelir (Etsy ürün görselinin linki yeterli; dosya yüklemeye gerek yok).
