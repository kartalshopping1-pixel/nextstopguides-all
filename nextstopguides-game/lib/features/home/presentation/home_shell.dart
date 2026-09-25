import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/ads/ads_service.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../profile/state/progress_controller.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../settings/state/settings_controller.dart';
import '../../shop/presentation/shop_screen.dart';
import 'home_screen.dart';

/// Main scaffold with tabs: bottom navigation on phones, a side rail on
/// wide screens (tablets, desktop browsers). Also hosts the ad banner slot.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final config = context.read<AppConfig>();
    final ads = context.read<AdsService>();
    final adsRemoved =
        context.select<ProgressController, bool>((p) => p.progress.adsRemoved);

    final tabs = <({Widget page, IconData icon, IconData selectedIcon, String label})>[
      (
        page: const HomeScreen(),
        icon: Icons.explore_outlined,
        selectedIcon: Icons.explore,
        label: s.t('nav_home'),
      ),
      (
        page: const ProfileScreen(),
        icon: Icons.menu_book_outlined,
        selectedIcon: Icons.menu_book,
        label: s.t('nav_passport'),
      ),
      if (config.showShop)
        (
          page: const ShopScreen(),
          icon: Icons.storefront_outlined,
          selectedIcon: Icons.storefront,
          label: s.t('nav_shop'),
        ),
      (
        page: const SettingsScreen(),
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        label: s.t('nav_settings'),
      ),
    ];
    final index = _index.clamp(0, tabs.length - 1).toInt();

    final body = IndexedStack(
      index: index,
      children: [for (final tab in tabs) tab.page],
    );
    final banner = config.adsEnabled && !adsRemoved ? ads.buildBanner() : null;
    final isWide =
        MediaQuery.sizeOf(context).width >= AppConstants.wideLayoutBreakpoint;

    if (isWide) {
      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              NavigationRail(
                selectedIndex: index,
                onDestinationSelected: (i) => setState(() => _index = i),
                labelType: NavigationRailLabelType.all,
                leading: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('🌍', style: TextStyle(fontSize: 32)),
                ),
                destinations: [
                  for (final tab in tabs)
                    NavigationRailDestination(
                      icon: Icon(tab.icon),
                      selectedIcon: Icon(tab.selectedIcon),
                      label: Text(tab.label),
                    ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: body),
                    if (banner != null) banner,
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (banner != null) banner,
          NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: [
              for (final tab in tabs)
                NavigationDestination(
                  icon: Icon(tab.icon),
                  selectedIcon: Icon(tab.selectedIcon),
                  label: tab.label,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
