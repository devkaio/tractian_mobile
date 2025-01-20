import 'package:bluecapped/bluecapped.dart';
import 'package:flutter/material.dart';

class BCTopAppbar extends StatelessWidget implements PreferredSizeWidget {
  const BCTopAppbar({
    super.key,
    this.child,
    this.leading,
    this.title,
    this.showLeading = true,
  });

  final Widget? child;
  final Widget? leading;
  final String? title;
  final bool showLeading;

  @override
  Widget build(BuildContext context) {
    // TODO: review the rules of this AppBar
    return AppBar(
      backgroundColor: context.appColors.ui.platformHeader,
      automaticallyImplyLeading: false,
      title: Stack(
        alignment: Alignment.center,
        children: [
          if (showLeading)
            Align(
              alignment: Alignment.bottomLeft,
              child: leading ??
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.pop(context),
                    color: context.appColors.neutral.white,
                  ),
            ),
          Row(
            children: [
              if (title != null)
                Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: Text(
                      title!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: context.appColors.neutral.white,
                          ),
                    ),
                  ),
                )
              else
                child ??
                    Flexible(
                      fit: FlexFit.tight,
                      child: Icon(
                        BlueCappedIcons.company_logo,
                        color: Colors.white,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
