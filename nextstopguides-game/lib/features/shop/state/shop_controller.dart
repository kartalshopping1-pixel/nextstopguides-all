import 'package:flutter/foundation.dart';

import '../../../services/analytics/analytics_service.dart';
import '../../../services/purchase/purchase_service.dart';
import '../../profile/state/progress_controller.dart';

/// Loads the product catalog and delivers purchases (hints, remove ads).
class ShopController extends ChangeNotifier {
  ShopController({
    required PurchaseService purchases,
    required ProgressController progress,
    required AnalyticsService analytics,
  })  : _purchases = purchases,
        _progress = progress,
        _analytics = analytics;

  final PurchaseService _purchases;
  final ProgressController _progress;
  final AnalyticsService _analytics;

  List<StoreProduct> _products = const [];
  bool _isLoading = true;
  String? _busyProductId;
  bool _disposed = false;

  List<StoreProduct> get products => _products;
  bool get isLoading => _isLoading;
  bool get isStoreAvailable => _purchases.isAvailable;
  String? get busyProductId => _busyProductId;

  Future<void> loadProducts() async {
    if (!_isLoading) {
      _isLoading = true;
      _notify();
    }
    try {
      _products = await _purchases.loadProducts();
    } catch (error) {
      debugPrint('Could not load products: $error');
      _products = const [];
    }
    _isLoading = false;
    _notify();
  }

  bool isOwned(StoreProduct product) =>
      product.id == ProductIds.removeAds && _progress.progress.adsRemoved;

  Future<PurchaseResult> buy(StoreProduct product) async {
    if (!product.available || _busyProductId != null) {
      return PurchaseResult(PurchaseStatus.notAvailable, productId: product.id);
    }
    _busyProductId = product.id;
    _notify();
    final result = await _purchases.buy(product.id);
    if (result.isSuccess) {
      await deliver(product.id);
      _analytics.logEvent('purchase', {'product': product.id});
    }
    _busyProductId = null;
    _notify();
    return result;
  }

  Future<void> restore() async {
    final restored = await _purchases.restorePurchases();
    for (final id in restored) {
      if (id == ProductIds.removeAds) {
        await deliver(id);
      }
    }
  }

  /// Grants the content of a purchased product.
  Future<void> deliver(String productId) async {
    final hints = ProductIds.hintsFor(productId);
    if (hints > 0) {
      await _progress.addHints(hints);
    } else if (productId == ProductIds.removeAds) {
      await _progress.setAdsRemoved(true);
    }
    // ProductIds.premiumGuides: unlock extra question packs here once they
    // exist (e.g. load assets/data/packs/<pack>.json in the repository).
  }

  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
