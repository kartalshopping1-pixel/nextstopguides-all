import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_theme.dart';
import '../../settings/state/settings_controller.dart';
import '../state/site_link_opener.dart';

/// "Plan a real trip" card that sends players to the NextStopGuides
/// printable itineraries. Shown on Home and Results when
/// [AppConfig.showGuidePromo] is on.
class GuidePromoCard extends StatelessWidget {
  const GuidePromoCard({super.key, this.showPackingList = false});

  /// Also show the secondary "Free Japan packing list" link (Results screen).
  final bool showPackingList;

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BrandColors.sunset.withAlpha(28),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: BrandColors.sunset.withAlpha(110)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('🗾', style: TextStyle(fontSize: 34)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.t('promo_title'),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.t('promo_body'),
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilledButton.icon(
                key: const ValueKey('promo_guides'),
                style: FilledButton.styleFrom(
                    backgroundColor: BrandColors.sunsetDark),
                onPressed: () => openSiteLink(context, SiteLink.guides),
                icon: const Icon(Icons.map_outlined),
                label: Text(s.t('promo_cta')),
              ),
              if (showPackingList)
                TextButton.icon(
                  key: const ValueKey('promo_packingList'),
                  onPressed: () => openSiteLink(context, SiteLink.packingList),
                  icon: const Icon(Icons.luggage_outlined),
                  label: Text(s.t('promo_packingList')),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
