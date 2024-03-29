import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Viewport;
import 'package:garda_green/game/components/input.dart';
import 'package:garda_green/game/game.dart';

class Hud extends PositionComponent
    with ParentIsA<Viewport>, HasGameReference<GardaGreenGame> {
  Hud({
    required this.playerSprite,
    required this.starSprite,
    this.input,
    this.onPausePressed,
  });

  final Sprite playerSprite;
  final Sprite starSprite;
  final VoidCallback? onPausePressed;

  late final SpriteComponent _player;
  late final SpriteComponent _star;

  late final JoystickComponent? _joystick;
  final Input? input;

  late final TextComponent _life;
  late final TextComponent _score;

  @override
  FutureOr<void> onLoad() async {
    _life = TextComponent(
      text: 'x3',
      anchor: Anchor.centerLeft,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Press Start 2P',
          fontSize: game.isMobile ? 6 : 8,
        ),
      ),
    );

    _score = TextComponent(
      text: 'x0',
      anchor: Anchor.centerLeft,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Press Start 2P',
          fontSize: game.isMobile ? 6 : 8,
        ),
      ),
    );

    _player = SpriteComponent(
      sprite: playerSprite,
      anchor: Anchor.center,
      scale: Vector2.all(game.isOffTrail ? 0.6 : 1.0),
    );

    _star = SpriteComponent(
      sprite: starSprite,
      anchor: Anchor.center,
      scale: Vector2.all(game.isOffTrail ? 0.6 : 1.0),
    );

    final top = game.top <= 10.0 ? 10.0 : game.top / 2;

    _player.position.setValues(
      16,
      game.isMobile ? top : parent.virtualSize.y - 20,
    );

    _life.position.setValues(
      _player.position.x + 8,
      _player.position.y,
    );

    _star.position.setValues(
      parent.virtualSize.x - 35,
      _player.y,
    );

    _score.position.setValues(
      _star.position.x + 8,
      _star.position.y,
    );

    await addAll([_player, _life, _star, _score]);

    if (game.isMobile) {
      _joystick = JoystickComponent(
        anchor: Anchor.center,
        position: parent.virtualSize * 0.5,
        knob: CircleComponent(
          radius: 7,
          paint: Paint()..color = Colors.black.withOpacity(0.08),
        ),
        background: CircleComponent(
          radius: 18,
          paint: Paint()
            ..color = Colors.black.withOpacity(0.05)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4,
        ),
      );

      _joystick?.position.y = parent.virtualSize.y - _joystick.knobRadius * 1.5;
      await _joystick?.addToParent(this);

      final pauseButton = HudButtonComponent(
        button: SpriteComponent.fromImage(
          await game.images.load('pause.png'),
          size: Vector2.all(12),
        ),
        anchor: Anchor.bottomRight,
        position: parent.virtualSize,
        onPressed: onPausePressed,
      );
      await add(pauseButton);
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (input?.active ?? false) {
      input?.hAxis = lerpDouble(
        input!.hAxis,
        _joystick!.isDragged ? _joystick.relativeDelta.x * input!.maxHAxis : 0,
        input!.sensitivity * dt,
      )!;
    }
    super.update(dt);
  }

  void updateStarCollected(int count) {
    _score.text = 'x$count';

    _star.add(
      RotateEffect.by(
        pi / 8,
        RepeatedEffectController(
          ZigzagEffectController(period: 0.2),
          2,
        ),
      ),
    );

    _score.add(
      ScaleEffect.by(
        Vector2.all(1.5),
        EffectController(
          duration: 0.1,
          alternate: true,
        ),
      ),
    );
  }

  void updateLifeCount(int count) {
    _life.text = 'x$count';

    _player.add(
      RotateEffect.by(
        pi / 8,
        RepeatedEffectController(
          ZigzagEffectController(period: 0.2),
          2,
        ),
      ),
    );

    _life.add(
      ScaleEffect.by(
        Vector2.all(1.5),
        EffectController(
          duration: 0.1,
          alternate: true,
        ),
      ),
    );
  }
}
