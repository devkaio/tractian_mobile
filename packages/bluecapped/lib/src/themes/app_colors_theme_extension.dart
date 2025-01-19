import 'package:bluecapped/bluecapped.dart';
import 'package:bluecapped/src/tokens/colors/feedback.dart';
import 'package:bluecapped/src/tokens/colors/neutral.dart';
import 'package:bluecapped/src/tokens/colors/ui.dart';
import 'package:flutter/material.dart';

class AppColorsThemeExtension extends ThemeExtension<AppColorsThemeExtension> {
  const AppColorsThemeExtension({
    required this.primary,
    required this.warning,
    required this.neutral,
    required this.ui,
  });

  final PrimaryColors primary;
  final FeedbackColors warning;
  final NeutralColors neutral;
  final UIColors ui;

  @override
  ThemeExtension<AppColorsThemeExtension> copyWith({
    PrimaryColors? primary,
    FeedbackColors? warning,
    NeutralColors? neutral,
    UIColors? ui,
  }) {
    return AppColorsThemeExtension(
      primary: primary ?? this.primary,
      warning: warning ?? this.warning,
      neutral: neutral ?? this.neutral,
      ui: ui ?? this.ui,
    );
  }

  @override
  ThemeExtension<AppColorsThemeExtension> lerp(
      covariant ThemeExtension<AppColorsThemeExtension>? other, double t) {
    if (other is! AppColorsThemeExtension) {
      return this;
    }
    return AppColorsThemeExtension(
      primary: PrimaryColors.lerp(primary, other.primary, t),
      warning: FeedbackColors.lerp(warning, other.warning, t),
      neutral: NeutralColors.lerp(neutral, other.neutral, t),
      ui: UIColors.lerp(ui, other.ui, t),
    );
  }
}

extension AppColorExtension on BuildContext {
  AppColorsThemeExtension get appColors {
    assert(Theme.of(this).extension<AppColorsThemeExtension>() != null,
        'No AppColorsThemeExtension found in the current theme');

    return Theme.of(this).extension<AppColorsThemeExtension>()!;
  }
}
