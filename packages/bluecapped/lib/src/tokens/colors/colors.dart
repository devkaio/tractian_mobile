import 'package:bluecapped/src/tokens/colors/feedback.dart';
import 'package:bluecapped/src/tokens/colors/neutral.dart';
import 'package:bluecapped/src/tokens/colors/primary.dart';
import 'package:bluecapped/src/tokens/colors/ui.dart';

export 'feedback.dart';
export 'neutral.dart';
export 'primary.dart';
export 'ui.dart';

class AppColors {
  const AppColors.light()
      : primary = const PrimaryColors.light(),
        feedback = const FeedbackColors.light(),
        neutral = const NeutralColors.light(),
        ui = const UIColors.light();

  const AppColors.dark()
      : primary = const PrimaryColors.dark(),
        feedback = const FeedbackColors.dark(),
        neutral = const NeutralColors.dark(),
        ui = const UIColors.dark();

  final PrimaryColors primary;
  final FeedbackColors feedback;
  final NeutralColors neutral;
  final UIColors ui;
}
