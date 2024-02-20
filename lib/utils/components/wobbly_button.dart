import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

class WobblyButton extends StatefulWidget {
  const WobblyButton({
    required this.child,
    this.onPressed,
    this.type = NesButtonType.primary,
    super.key,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final NesButtonType type;

  @override
  State<WobblyButton> createState() => _WobblyButtonState();
}

class _WobblyButtonState extends State<WobblyButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        _controller.repeat();
      },
      onExit: (event) {
        _controller.stop(canceled: false);
      },
      child: RotationTransition(
        turns: _controller.drive(const _MySineTween(0.005)),
        child: NesButton(
          type: widget.type,
          onPressed: widget.onPressed,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
            child: Center(
              widthFactor: 1,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

class _MySineTween extends Animatable<double> {
  const _MySineTween(this.maxExtent);

  final double maxExtent;

  @override
  double transform(double t) {
    return sin(t * 2 * pi) * maxExtent;
  }
}
