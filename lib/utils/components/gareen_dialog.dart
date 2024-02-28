import 'package:flutter/material.dart';
import 'package:garda_green/utils/utils.dart';
import 'package:nes_ui/nes_ui.dart';

class GareenDialog extends StatelessWidget {
  const GareenDialog({
    required this.child,
    this.isShowCloseButton = true,
    super.key,
  });

  final Widget child;
  final bool isShowCloseButton;

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isShowCloseButton = true,
  }) {
    final nesTheme = context.nesThemeExtension<NesTheme>();
    return showGeneralDialog<T>(
      context: context,
      barrierColor: Colors.transparent,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return MouseRegion(
          cursor: nesTheme.basicCursor,
          child: SizedBox.expand(
            child: Transform.scale(
              scaleY: animation.value,
              child: child,
            ),
          ),
        );
      },
      pageBuilder: (_, __, ___) => GareenDialog(
        isShowCloseButton: isShowCloseButton,
        child: builder(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            context.isSmall ? 24 : MediaQuery.of(context).size.width / 4,
        vertical: 24,
      ),
      child: Align(
        child: Material(
          child: IntrinsicWidth(
             stepHeight: 0.56,
            child: SizedBox.expand(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  NesContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: child,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isShowCloseButton,
                    child: Positioned(
                      right: -8,
                      top: -8,
                      child: NesButton(
                        type: NesButtonType.error,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: NesIcon(
                          size: const Size(16, 16),
                          iconData: NesIcons.close,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
