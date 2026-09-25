import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_config.dart';
import '../../../core/l10n/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/responsive_center.dart';
import '../../../services/analytics/analytics_service.dart';
import '../../../services/purchase/purchase_service.dart';
import '../../profile/state/progress_controller.dart';
import '../../settings/state/settings_controller.dart';
import '../state/shop_controller.dart';

/// Shop: lists products from the PurchaseService. With the default
/// NoopPurchaseService every product is shown as "coming soon".
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShopController>(
      create: (context) => ShopController(
        purchases: context.read<PurchaseService>(),
        progress: context.read<ProgressController>(),
        analytics: context.read<AnalyticsService>(),
      )..loadProducts(),
      child: const _ShopView(),
    );
  }
}

class _ShopView extends StatelessWidget {
  const _ShopView();

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final shop = context.watch<ShopController>();
    final hints = context.select<ProgressController, int>((p) => p.progress.hints);
    final purchasesEnabled = context.read<AppConfig>().purchasesEnabled;
    final storeReady = purchasesEnabled && shop.isStoreAvailable;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(s.t('shop_title'))),
      body: ResponsiveCenter(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: BrandColors.sunsetGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 36)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      s.t('shop_balance', {'count': hints}),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!storeReady) ...[
              const SizedBox(height: 12),
              Card(
                elevation: 0,
                color: scheme.secondaryContainer,
                child: ListTile(
                  leading: const Icon(Icons.construction),
                  title: Text(s.t('shop_comingSoon')),
                  subtitle: Text(s.t('shop_comingSoonBody')),
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (shop.isLoading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              for (final product in shop.products)
                _ProductTile(
                  product: product,
                  strings: s,
                  enabled: storeReady && product.available,
                  owned: shop.isOwned(product),
                  busy: shop.busyProductId == product.id,
                ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              color: scheme.surfaceContainerHighest,
              child: ListTile(
                leading: const Text('🎁', style: TextStyle(fontSize: 26)),
                title: Text(s.t('shop_earnFree')),
                subtitle: Text(s.t('shop_earnRules')),
              ),
            ),
            if (storeReady) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: shop.restore,
                child: Text(s.t('shop_restore')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.product,
    required this.strings,
    required this.enabled,
    required this.owned,
    required this.busy,
  });

  final StoreProduct product;
  final AppStrings strings;
  final bool enabled;
  final bool owned;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Widget action;
    if (owned) {
      action = Chip(label: Text(strings.t('shop_owned')));
    } else if (!enabled) {
      action = Chip(label: Text(strings.t('shop_comingSoon')));
    } else if (busy) {
      action = const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else {
      action = FilledButton(
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          final result = await context.read<ShopController>().buy(product);
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                result.isSuccess
                    ? strings.t('shop_purchaseSuccess')
                    : strings.t('shop_purchaseFailed'),
              ),
            ),
          );
        },
        child: Text(product.price ?? strings.t('shop_buy')),
      );
    }

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          leading: Text(product.emoji, style: const TextStyle(fontSize: 30)),
          title: Text(
            strings.productTitle(product.id, product.title),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          subtitle: Text(strings.productDescription(product.id, product.description)),
          trailing: action,
        ),
      ),
    );
  }
}
