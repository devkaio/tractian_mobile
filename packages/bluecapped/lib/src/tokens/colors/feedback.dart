import 'dart:ui';

class FeedbackColors {
  FeedbackColors.lerp(FeedbackColors a, FeedbackColors b, double t)
      : danger = Color.lerp(a.danger, b.danger, t) ?? a.danger;

  const FeedbackColors.light() : danger = const Color(0xFFED3833);

  // TODO: set dark colors
  const FeedbackColors.dark() : danger = const Color(0xFFED3833);

  final Color danger;
}
