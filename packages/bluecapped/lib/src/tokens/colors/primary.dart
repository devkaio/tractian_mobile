import 'dart:ui';

class PrimaryColors {
  PrimaryColors.lerp(PrimaryColors a, PrimaryColors b, double t)
      : blue = Color.lerp(a.blue, b.blue, t) ?? a.blue,
        blue2 = Color.lerp(a.blue2, b.blue2, t) ?? a.blue2;

  const PrimaryColors.light()
      : blue = const Color(0xFF2188FF),
        blue2 = const Color(0xFF2188FF);

  // TODO: set dark colors
  const PrimaryColors.dark()
      : blue = const Color.fromARGB(255, 50, 51, 51),
        blue2 = const Color.fromARGB(255, 153, 157, 161);

  final Color blue, blue2;
}
