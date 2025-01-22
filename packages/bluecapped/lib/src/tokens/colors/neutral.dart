import 'dart:ui';

class NeutralColors {
  NeutralColors.lerp(NeutralColors a, NeutralColors b, double t)
      : white = Color.lerp(a.white, b.white, t) ?? a.white,
        grey200 = Color.lerp(a.grey200, b.grey200, t) ?? a.grey200;

  const NeutralColors.light()
      : white = const Color(0xFFFFFFFF),
        grey200 = const Color(0xFFD8DFE6);

  // TODO: set dark colors
  const NeutralColors.dark()
      : white = const Color(0xFFFFFFFF),
        grey200 = const Color(0xFFD8DFE6);

  final Color white;
  final Color grey200;
}
