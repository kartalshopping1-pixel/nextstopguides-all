/// In-app purchase abstraction used by the Shop.
///
/// HOW TO PLUG IN REAL PURCHASES (in_app_purchase) - Android & iOS:
///
/// 1. `flutter pub add in_app_purchase`
/// 2. Create the products in the stores with EXACTLY the ids in [ProductIds]:
///    - Google Play Console > your app > Monetize > Products
///      (remove_ads = one-time "managed product"; hint packs = consumable)
///    - App Store Connect > your app > In-App Purchases
///      (remove_ads = Non-Consumable, hint packs = Consumable,
///       premium_guides = Non-Consumable or Auto-Renewable Subscription)
/// 3. Create lib/services/purchase/store_purchase_service.dart:
///
///    class StorePurchaseService implements PurchaseService {
///      initialize() -> listen to InAppPurchase.instance.purchaseStream;
///                      for every PurchaseDetails with status purchased /
///                      restored: deliver it (see ShopController), then call
///                      InAppPurchase.instance.completePurchase(details).
///      loadProducts() -> InAppPurchase.instance.queryProductDetails(ids)
///                      and map each ProductDetails to a StoreProduct
///                      (price = details.price, available = true).
///      buy(id) -> buyConsumable(...) for hint packs,
///                 buyNonConsumable(...) for remove_ads / premium_guides.
///      restorePurchases() -> InAppPurchase.instance.restorePurchases().
///    }
///
/// 4. In lib/core/di/service_locator.dart return StorePurchaseService() when
///    config.purchasesEnabled is true (not on web).
/// 5. Enable the flag in lib/core/config/app_config.dart or build with
///    --dart-define=IAP_ENABLED=true
/// 6. For real money safety, verify receipts on a server before granting
///    premium content.
library;

enum ProductKind { consumable, nonConsumable, subscription }

/// Product ids - must match Google Play Console / App Store Connect.
class ProductIds {
  ProductIds._();

  static const String removeAds = 'remove_ads';
  static const String hintsPack10 = 'hints_pack_10';
  static const String hintsPack50 = 'hints_pack_50';
  static const String premiumGuides = 'premium_guides';

  static const List<String> all = [removeAds, hintsPack10, hintsPack50, premiumGuides];

  /// How many hints a consumable product grants (0 = not a hint pack).
  static int hintsFor(String productId) => switch (productId) {
        hintsPack10 => 10,
        hintsPack50 => 50,
        _ => 0,
      };
}

class StoreProduct {
  const StoreProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    this.price,
    this.available = false,
    this.emoji = '🎁',
  });

  final String id;
  final String title;
  final String description;
  final ProductKind kind;

  /// Localized price string from the store, e.g. "₺49,99". Null = unknown.
  final String? price;

  /// False when the store is not connected ("coming soon" in the UI).
  final bool available;
  final String emoji;
}

enum PurchaseStatus { success, cancelled, error, notAvailable }

class PurchaseResult {
  const PurchaseResult(this.status, {this.productId, this.message});

  final PurchaseStatus status;
  final String? productId;
  final String? message;

  bool get isSuccess => status == PurchaseStatus.success;
}

abstract class PurchaseService {
  Future<void> initialize();

  /// True when a real store is connected.
  bool get isAvailable;

  Future<List<StoreProduct>> loadProducts();

  Future<PurchaseResult> buy(String productId);

  /// Restores non-consumable purchases (required by Apple).
  Future<List<String>> restorePurchases();

  void dispose();
}

/// Default implementation: shows the planned catalog as "coming soon".
class NoopPurchaseService implements PurchaseService {
  const NoopPurchaseService();

  static const List<StoreProduct> catalog = [
    StoreProduct(
      id: ProductIds.hintsPack10,
      title: '10 hints',
      description: 'A small bag of hints.',
      kind: ProductKind.consumable,
      emoji: '💡',
    ),
    StoreProduct(
      id: ProductIds.hintsPack50,
      title: '50 hints',
      description: 'Best value hint pack.',
      kind: ProductKind.consumable,
      emoji: '🧳',
    ),
    StoreProduct(
      id: ProductIds.removeAds,
      title: 'Remove ads',
      description: 'An ad-free journey.',
      kind: ProductKind.nonConsumable,
      emoji: '🚫',
    ),
    StoreProduct(
      id: ProductIds.premiumGuides,
      title: 'Premium guide packs',
      description: 'Themed question packs.',
      kind: ProductKind.nonConsumable,
      emoji: '🗺️',
    ),
  ];

  @override
  Future<void> initialize() async {}

  @override
  bool get isAvailable => false;

  @override
  Future<List<StoreProduct>> loadProducts() async => catalog;

  @override
  Future<PurchaseResult> buy(String productId) async =>
      PurchaseResult(PurchaseStatus.notAvailable, productId: productId);

  @override
  Future<List<String>> restorePurchases() async => const [];

  @override
  void dispose() {}
}
