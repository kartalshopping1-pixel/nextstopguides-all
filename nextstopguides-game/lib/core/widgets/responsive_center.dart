import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// Centers content and limits its width so the game looks good on phones,
/// tablets and wide desktop browsers alike.
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    super.key,
    this.maxWidth = AppConstants.maxContentWidth,
    required this.child,
  });

  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
