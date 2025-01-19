import 'package:bluecapped/bluecapped.dart';
import 'package:flutter/material.dart';

export 'app_colors_theme_extension.dart';

class BlueCappedTheme {
  const BlueCappedTheme._(this._lightData, this._darkData);

  factory BlueCappedTheme() {
    return const BlueCappedTheme._(
      AppColors.light(),
      AppColors.dark(),
    );
  }

  final AppColors _lightData;
  final AppColors _darkData;

  ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      extensions: [
        AppColorsThemeExtension(
          primary: _lightData.primary,
          warning: _lightData.feedback,
          neutral: _lightData.neutral,
          ui: _lightData.ui,
        )
      ],
    );
  }

  ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      extensions: [
        AppColorsThemeExtension(
          primary: _darkData.primary,
          warning: _darkData.feedback,
          neutral: _darkData.neutral,
          ui: _darkData.ui,
        )
      ],
    );
  }
}
