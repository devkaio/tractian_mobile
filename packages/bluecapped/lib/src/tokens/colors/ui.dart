import 'dart:ui';

class UIColors {
  UIColors.lerp(UIColors a, UIColors b, double t)
      : platformHeader = Color.lerp(a.platformHeader, b.platformHeader, t) ??
            a.platformHeader;

  const UIColors.light() : platformHeader = const Color(0xFF17192D);

  // TODO: set dark colors
  const UIColors.dark() : platformHeader = const Color(0xFF17192D);

  final Color platformHeader;
}
