import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:garda_green/game/game.dart';

class Input extends Component with KeyboardHandler, HasGameReference {
  Input({Map<LogicalKeyboardKey, VoidCallback>? keyCallbacks})
      : _keyCallbacks = keyCallbacks ?? <LogicalKeyboardKey, VoidCallback>{};

  final Map<LogicalKeyboardKey, VoidCallback> _keyCallbacks;

  bool _isLeftKeyPressed = false;
  bool _isRightKeyPressed = false;

  double hAxis = 0;
  double _leftInput = 0;
  double _rightInput = 0;

  final maxHAxis = 1.5;
  final sensitivity = 2.0;

  bool active = false;

  @override
  void update(double dt) {
    if (!TheRunnerGame.isMobile) {
      _leftInput = lerpDouble(
        _leftInput,
        (_isLeftKeyPressed && active) ? maxHAxis : 0,
        sensitivity * dt,
      )!;

      _rightInput = lerpDouble(
        _rightInput,
        (_isRightKeyPressed && active) ? maxHAxis : 0,
        sensitivity * dt,
      )!;
      hAxis = _rightInput - _leftInput;
    }
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (!TheRunnerGame.isMobile && !game.paused) {
      _isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
          keysPressed.contains(LogicalKeyboardKey.arrowLeft);
      _isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
          keysPressed.contains(LogicalKeyboardKey.arrowRight);

      if (event is RawKeyDownEvent && event.repeat == false) {
        for (final entry in _keyCallbacks.entries) {
          if (entry.key == event.logicalKey) {
            entry.value.call();
          }
        }
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }
}
