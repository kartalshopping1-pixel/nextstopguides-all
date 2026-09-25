# NextStop Trivia 🌍✈️
### NextStopGuides markalı seyahat bilgi yarışması oyunu

Ülkeleri, başkentleri, bayrakları ve ünlü yerleri tahmin ettiğin bir seyahat oyunu.
Tek bir kod ile **web sitesinde**, **Android** ve **iPhone (iOS)** telefonlarda çalışır.

---

## İçindekiler
1. [Oyunda neler var?](#1-oyunda-neler-var)
2. [Flutter nedir?](#2-flutter-nedir)
3. [Bilgisayara kurulum (Windows)](#3-bilgisayara-kurulum-windows)
4. [Projeyi ilk kez hazırlamak (tek seferlik)](#4-projeyi-ilk-kez-hazırlamak-tek-seferlik)
5. [Oyunu tarayıcıda çalıştırmak](#5-oyunu-tarayıcıda-çalıştırmak)
6. [Testleri çalıştırmak](#6-testleri-çalıştırmak)
7. [Web sitesinde yayınlamak](#7-web-sitesinde-yayınlamak)
8. [Android (Google Play) yolu](#8-android-google-play-yolu)
9. [iPhone (App Store) yolu](#9-iphone-app-store-yolu)
10. [Reklamları (AdMob) açmak](#10-reklamları-admob-açmak)
11. [Uygulama içi satın almayı (IAP) açmak](#11-uygulama-içi-satın-almayı-iap-açmak)
12. [Yeni ülke ve şehir eklemek](#12-yeni-ülke-ve-şehir-eklemek)
13. [Metinleri, dilleri ve renkleri değiştirmek](#13-metinleri-dilleri-ve-renkleri-değiştirmek)
14. [Sorun giderme](#14-sorun-giderme)

---

## 1. Oyunda neler var?

**6 oyun modu**

| Mod | Açıklama |
|---|---|
| 🧭 **Ülkeyi Tahmin Et** | İpuçları sırayla açılır: kıta → nüfus → dil → para birimi → ünlü yer → başkent → bayrak. Ne kadar az ipucuyla bilirsen o kadar çok puan! |
| 🏛️ **Başkent Bilmecesi** | "Türkiye'nin başkenti neresi?" gibi çoktan seçmeli sorular (orta/zor seviyede ters sorular da gelir). |
| 🚩 **Bayrak Bilmecesi** | Bayrak emojisine bakıp ülkeyi bul. |
| 🗼 **Simgeler ve Şehirler** | "Sagrada Família hangi şehirde?" gibi sorular. |
| ❤️ **Hayatta Kalma** | Sonsuz soru, 3 can. Yanlış yaptıkça can gider. |
| 📅 **Günlük Meydan Okuma** | Her gün herkese **aynı** 10 soru (tarihe göre üretilir). Her gün oynayınca "günlük seri" büyür. |

**Uzun süre oynanması için**
- 3 zorluk seviyesi (Kolay / Orta / Zor). Zor seviyede yanlış şıklar aynı kıtadan seçilir.
- Rastgele soru üretimi + "son sorulan 300 soruyu hatırlama" → sorular nadiren tekrar eder.
- XP, seviye ve unvanlar (Turist → Sırt Çantalı Gezgin → Kaşif → Dünya Gezgini → Seyahat Elçisi).
- Seri (streak) bonusu, mod başına rekorlar.
- Her kıta için **pasaport damgaları** (Bronz 10, Gümüş 50, Altın 150 doğru cevap).
- **İpucu** para birimi: yanlış şıkların yarısını siler. Oynayarak kazanılır (seviye atlama +2, günün ilk Günlük Meydan Okuması +1, art arda 10 doğru +1). İleride mağazadan satılabilir.
- İngilizce + Türkçe arayüz, Ayarlar'dan dil değiştirilebilir. Açık/koyu tema.
- Tüm ilerleme cihazda saklanır (internet gerekmez).

**Veri:** 136 ülke ve 113 şehir, `assets/data/` klasöründeki JSON dosyalarında.

---

## 2. Flutter nedir?

**Flutter**, Google'ın ücretsiz bir uygulama geliştirme aracıdır. Bir kez yazılan kod;
web sitesi, Android uygulaması ve iPhone uygulaması olarak derlenebilir.
Kodlar **Dart** adlı bir dilde yazılır (`.dart` dosyaları).

Bu projede senin bilmen gereken sadece birkaç komut var; aşağıda adım adım anlatıldı.
Komutları **PowerShell** veya **Komut İstemi** penceresine yazacaksın.

---

## 3. Bilgisayara kurulum (Windows)

> Bir kez yapılır. Yaklaşık 30–60 dakika sürer.

1. **Git'i kur:** https://git-scm.com/download/win → indir, hep "Next" diyerek kur.
2. **Google Chrome** kurulu olsun (web'de test için).
3. **Flutter SDK'yı indir:** https://docs.flutter.dev/get-started/install/windows
   - "Web" veya "Android" hedefini seç, sayfadaki **zip** dosyasını indir.
   - Zip'i `C:\src\flutter` klasörüne çıkar (Program Files içine **koyma**).
4. **PATH'e ekle** (Windows'un `flutter` komutunu tanıması için):
   - Başlat menüsüne *"ortam değişkenleri"* yaz → "Sistem ortam değişkenlerini düzenleyin".
   - "Ortam Değişkenleri…" → üstteki listede **Path** → Düzenle → Yeni →
     `C:\src\flutter\bin` yaz → Tamam.
   - Açık PowerShell pencerelerini kapatıp yenisini aç.
5. Kontrol et:
   ```powershell
   flutter --version
   flutter doctor
   ```
   `flutter doctor` eksikleri listeler. Web için "Chrome" satırında ✓ görmen yeterli.
6. (Tavsiye) **Visual Studio Code** kur: https://code.visualstudio.com → Eklentiler (Extensions)
   bölümünden **Flutter** eklentisini kur. Dosyaları rahatça düzenlemeni sağlar.
7. (Android için, isteğe bağlı) **Android Studio** kur: https://developer.android.com/studio
   ve `flutter doctor --android-licenses` komutuyla lisansları kabul et.

---

## 4. Projeyi ilk kez hazırlamak (tek seferlik)

Bu proje, Flutter kurulu olmayan bir bilgisayarda elle hazırlandı. Bu yüzden
**iOS ve Android klasörleri henüz yok**. Flutter'ı kurduktan sonra **bir kez**
aşağıdaki komutları çalıştır:

```powershell
cd C:\Users\MONSTER\NextStopGuides\nextstopguides-game
flutter create . --org com.nextstopguides --project-name nextstopguides_game --platforms web,ios,android
flutter pub get
```

- `flutter create .` → eksik olan `android/`, `ios/` klasörlerini ve web ikonlarını oluşturur.
  **Mevcut dosyalarımızın üzerine yazmaz.**
- `flutter pub get` → gerekli paketleri (provider, shared_preferences) indirir.

---

## 5. Oyunu tarayıcıda çalıştırmak

```powershell
cd C:\Users\MONSTER\NextStopGuides\nextstopguides-game
flutter run -d chrome
```

Chrome açılır ve oyun başlar. Kod değiştirirsen, terminalde **r** tuşuna basınca
değişiklik anında görünür (hot reload). Kapatmak için **q**.

Telefon görünümünü denemek için Chrome'da **F12** → üstteki telefon simgesi (cihaz araç çubuğu).

Android telefonda denemek: telefonda "Geliştirici seçenekleri → USB hata ayıklama"yı aç,
USB ile bağla, `flutter devices` ile gör, `flutter run` ile çalıştır.

---

## 6. Testleri çalıştırmak

```powershell
flutter analyze   # kodda hata/uyarı var mı?
flutter test      # otomatik testler (soru üretici, puanlama, veri dosyaları...)
```

`flutter test`, JSON veri dosyalarını da kontrol eder (eksik alan, bilinmeyen ülke kodu vb.).
**Veri dosyalarını her düzenledikten sonra çalıştırman tavsiye edilir.**

---

## 7. Web sitesinde yayınlamak

1. Yayın sürümünü üret:
   ```powershell
   flutter build web --release
   ```
   Sonuç `build\web\` klasöründedir. Bu klasördeki **tüm dosyalar** senin oyunundur.

2. Bir yere yükle (birini seç):
   - **Kendi siteniz (ör. nextstopguides.com/oyun):**
     ```powershell
     flutter build web --release --base-href /oyun/
     ```
     sonra `build\web` içindekileri FTP / hosting paneli ile sitedeki `oyun` klasörüne yükle.
     (`--base-href` değeri klasör adıyla aynı olmalı, başında ve sonunda `/` ile.)
   - **Netlify (en kolay, ücretsiz):** https://app.netlify.com/drop adresine `build\web`
     klasörünü sürükle-bırak. Sonra kendi alan adını bağlayabilirsin.
   - **Firebase Hosting (ücretsiz katman):** `npm install -g firebase-tools`,
     `firebase login`, `firebase init hosting` (public klasörü: `build/web`), `firebase deploy`.
   - **GitHub Pages:** `build/web` içeriğini bir depoya yükle ve Pages'i aç
     (`--base-href /depo-adi/` ile derle).

3. WordPress sitene gömmek istersen, oyunu bir alt klasörde yayınlayıp sayfaya
   `<iframe src="https://nextstopguides.com/oyun/" width="100%" height="800"></iframe>` ekleyebilirsin.

> Not: Web'de ilerleme, tarayıcının yerel hafızasında (localStorage) tutulur.

---

## 8. Android (Google Play) yolu

1. Android Studio kurulu olsun (bkz. Bölüm 3).
2. Uygulama adı/ikon: `android/app/src/main/AndroidManifest.xml` içindeki `android:label`,
   ikonlar için `flutter_launcher_icons` paketi kullanılabilir.
3. İmza anahtarı oluştur ve yayın paketi üret:
   https://docs.flutter.dev/deployment/android
   ```powershell
   flutter build appbundle --release
   ```
4. Google Play Console hesabı (tek seferlik **25 $**) → yeni uygulama → `.aab` dosyasını yükle.

---

## 9. iPhone (App Store) yolu

iOS uygulaması **Windows'ta derlenemez**. İki seçenek var:

**A) Mac bilgisayar ile**
1. Mac + **Xcode** (App Store'dan ücretsiz).
2. **Apple Developer Program** üyeliği: yıllık **99 $** (https://developer.apple.com/programs/).
3. Mac'e Flutter kur, projeyi kopyala, `flutter build ipa`.
4. Xcode / Transporter ile App Store Connect'e yükle, TestFlight ile test et, incelemeye gönder.
   Rehber: https://docs.flutter.dev/deployment/ios

**B) Mac olmadan, bulut servisi ile (tavsiye)**
- **Codemagic** (https://codemagic.io) — Flutter için hazır; projeyi GitHub'a yükle,
  Codemagic'e bağla, Apple Developer hesabını tanıt; iOS derlemesini onların Mac'leri yapar
  ve App Store Connect'e gönderir. Ücretsiz aylık dakika kotası vardır.
- Alternatifler: Bitrise, GitHub Actions (macOS runner).
- Apple Developer üyeliği (99 $/yıl) yine **gereklidir**.

Bundle ID: `com.nextstopguides.nextstopguidesGame` (flutter create bunu otomatik üretir;
istersen Xcode'da değiştirebilirsin).

---

## 10. Reklamları (AdMob) açmak

Reklam altyapısı hazır, ama varsayılan olarak **kapalı** ("Noop" = hiçbir şey yapmayan servis).
AdMob sadece **Android ve iOS**'ta çalışır (web'de çalışmaz).

Hazır olan yerler:
- Alt kısımda **banner** alanı (`lib/features/home/presentation/home_shell.dart`)
- Her N oyunda bir **geçiş reklamı** (`GameController.finish()`)
- Hayatta Kalma modunda **"Ekstra can için reklam izle"** (ödüllü reklam)

**Adımlar:**
1. https://admob.google.com → hesap aç → uygulama ekle (Android ve iOS ayrı) →
   **App ID** ve reklam birimleri (banner, geçiş, ödüllü) oluştur.
2. Paketi ekle:
   ```powershell
   flutter pub add google_mobile_ads
   ```
3. **Android:** `android/app/src/main/AndroidManifest.xml` içinde `<application>` etiketinin
   içine ekle:
   ```xml
   <meta-data
       android:name="com.google.android.gms.ads.APPLICATION_ID"
       android:value="ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY"/>
   ```
   **iOS:** `ios/Runner/Info.plist` içine `GADApplicationIdentifier` anahtarıyla aynı App ID'yi ekle.
4. Yeni dosya oluştur: `lib/services/ads/admob_ads_service.dart` → `AdsService`
   arayüzünü uygulayan `AdMobAdsService` sınıfı. Ne yazılacağı adım adım
   **`lib/services/ads/ads_service.dart`** dosyasının başındaki açıklamada yazıyor.
   Geliştirirken Google'ın **test reklam kimliklerini** kullan; kendi reklamına asla tıklama.
5. **`lib/core/di/service_locator.dart`** içinde
   `const AdsService ads = NoopAdsService();` satırını şöyle değiştir:
   ```dart
   final AdsService ads = (config.adsEnabled && !kIsWeb) ? AdMobAdsService() : const NoopAdsService();
   ```
   (`import 'package:flutter/foundation.dart';` ve yeni dosyanın import'unu ekle.)
6. Özelliği aç: **`lib/core/config/app_config.dart`** içinde `adsEnabled` bayrağını `true` yap
   **veya** derlerken: `flutter run --dart-define=ADS_ENABLED=true`
7. Yayından önce: gizlilik politikası sayfası ve AB kullanıcıları için izin (GDPR/UMP) ekranı gerekir.

`AppConfig` içindeki diğer ayarlar: `interstitialEveryNGames` (kaç oyunda bir geçiş reklamı),
`rewardedExtraLifeEnabled` (ekstra can reklamı).

---

## 11. Uygulama içi satın almayı (IAP) açmak

Mağaza ekranı hazır; şu an ürünleri **"Çok yakında"** olarak gösteriyor.
Planlanan ürünler (`lib/services/purchase/purchase_service.dart` → `ProductIds`):

| Ürün kimliği | Tür | İçerik |
|---|---|---|
| `remove_ads` | Tüketilmeyen (bir kez alınır) | Reklamları kaldırır |
| `hints_pack_10` | Tüketilen | 10 ipucu |
| `hints_pack_50` | Tüketilen | 50 ipucu |
| `premium_guides` | Tüketilmeyen / abonelik | NextStopGuides temalı ekstra soru paketleri |

**Adımlar:**
1. Ürünleri mağazalarda **aynı kimliklerle** oluştur:
   - Google Play Console → uygulaman → *Para kazanma → Ürünler*
   - App Store Connect → uygulaman → *In-App Purchases*
2. Paketi ekle:
   ```powershell
   flutter pub add in_app_purchase
   ```
3. Yeni dosya: `lib/services/purchase/store_purchase_service.dart` → `PurchaseService`
   arayüzünü uygulayan `StorePurchaseService`. Ne yazılacağı
   **`lib/services/purchase/purchase_service.dart`** dosyasının başında adım adım anlatılıyor.
4. Satın alınan ürünün teslimi (ipucu eklemek, reklamları kaldırmak) zaten yazılı:
   **`lib/features/shop/state/shop_controller.dart` → `deliver()`**.
   Premium paketler eklendiğinde de buraya eklenir.
5. **`lib/core/di/service_locator.dart`** içinde `NoopPurchaseService` yerine
   `StorePurchaseService` döndür (web hariç).
6. **`lib/core/config/app_config.dart`** içinde `purchasesEnabled: true` yap
   **veya** `--dart-define=IAP_ENABLED=true` ile derle.
7. Test: Android'de "lisans test kullanıcıları", iOS'ta "Sandbox" hesapları ile.
   Gerçek para güvenliği için satın alma makbuzlarını ileride bir sunucuda doğrulaman önerilir.

---

## 12. Yeni ülke ve şehir eklemek

Tüm oyun verisi iki dosyadadır. Not Defteri veya VS Code ile açabilirsin.

**`assets/data/countries.json`** — her satır bir ülke:
```json
{"code": "TR", "name": "Türkiye", "capital": "Ankara", "continent": "Europe", "flag": "🇹🇷",
 "currency": "Turkish lira", "languages": ["Turkish"], "population": "50M-100M",
 "landmarks": ["Hagia Sophia", "Cappadocia"], "funFact": "…", "tier": 1},
```

| Alan | Açıklama |
|---|---|
| `code` | 2 harfli ISO ülke kodu (benzersiz olmalı) |
| `name`, `capital` | Ülke adı ve başkenti |
| `continent` | `Africa`, `Asia`, `Europe`, `North America`, `South America`, `Oceania` |
| `flag` | Bayrak emojisi (https://emojipedia.org adresinden kopyalanabilir) |
| `currency`, `languages` | Para birimi, diller (liste) |
| `population` | `<1M`, `1M-10M`, `10M-50M`, `50M-100M`, `100M+` |
| `landmarks` | Ünlü yerler (liste) |
| `funFact` | Cevaptan sonra gösterilen ilginç bilgi |
| `tier` | 1 = çok bilinen (Kolay), 2 = bilinen (Orta), 3 = uzman (Zor) |

**`assets/data/cities.json`** — her satır bir şehir:
```json
{"city": "Istanbul", "countryCode": "TR", "country": "Türkiye",
 "landmarks": ["Hagia Sophia", "Grand Bazaar"], "funFact": "…", "tier": 1},
```
- `countryCode` ve `country`, countries.json'daki ülkeyle **aynı** olmalı.
- En az bir ünlü yerin adında şehrin adı **geçmemeli** (yoksa soru cevabı ele verir).

**Dikkat edilecekler (JSON kuralları):**
- Her kayıt `{ … }` içinde, kayıtlar arasında **virgül** var; **son kaydın sonunda virgül yok**.
- Metinler çift tırnak `"…"` içinde. Metnin içinde tırnak gerekiyorsa tek tırnak `'` kullan.
- Kaydettikten sonra `flutter test` çalıştır; hata varsa hangi kayıtta olduğunu söyler.

Veriler şimdilik İngilizce. İleride veriler bir sunucudan (API) da çekilebilir:
`lib/data/datasources/travel_data_source.dart` içine `RemoteTravelDataSource` eklemek yeterli.

---

## 13. Metinleri, dilleri ve renkleri değiştirmek

- **Tüm arayüz metinleri:** `lib/core/l10n/strings.dart` (İngilizce `_en` ve Türkçe `_tr` listeleri).
  Bir metni değiştirmek için ilgili satırdaki tırnak içindeki yazıyı değiştir.
  Yeni dil eklemek için dosyanın başındaki açıklamaya bak.
- **Marka renkleri:** `lib/core/theme/app_theme.dart` → `BrandColors`
  (okyanus turkuazı, derin mavi, gün batımı turuncusu).
- **Oyun kuralları:** soru sayısı ve can sayısı `lib/core/constants/app_constants.dart`;
  puanlama `lib/domain/engine/scoring.dart`; ipucu ve damga eşikleri `lib/domain/engine/rewards.dart`;
  seviye eğrisi `lib/domain/engine/level_system.dart`.
- **Web sayfa başlığı / açıklaması:** `web/index.html`, `web/manifest.json`.

Klasör yapısının ayrıntılı açıklaması: **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)**

---

## 14. Sorun giderme

| Sorun | Çözüm |
|---|---|
| `flutter` tanınmıyor | PATH'e `C:\src\flutter\bin` eklendi mi? PowerShell'i kapatıp aç. |
| `flutter run -d chrome` Chrome'u bulamıyor | Chrome kurulu mu? `flutter devices` ile kontrol et. |
| Beyaz ekran / "Seyahat verileri yüklenemedi" | JSON dosyasında yazım hatası olabilir → `flutter test` çalıştır. |
| Bayraklar görünmüyor | Web'de ilk açılışta emoji fontu internetten indirilir, biraz bekle. |
| iOS/Android klasörü yok | Bölüm 4'teki `flutter create .` komutunu çalıştır. |
| İlerlemeyi sıfırlamak | Oyunda **Ayarlar → İlerlemeyi sıfırla**. |

---

© NextStopGuides. Seyahat bilgileri eğlence amaçlıdır; yolculuk öncesi resmi kaynakları kontrol edin.
