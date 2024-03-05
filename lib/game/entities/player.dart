import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/animation.dart';
import 'package:garda_green/audio/audio.dart';
import 'package:garda_green/game/game.dart';

class Player extends PositionComponent
    with
        HasGameReference<GardaGreenGame>,
        HasAncestor<GardaGreenGame>,
        HasTimeScale {
  Player({required Sprite sprite, super.position, super.priority})
      : _body = SpriteComponent(sprite: sprite, anchor: Anchor.center);

  late final SpriteComponent _body;
  final _moveDirection = Vector2(0, 1);

  late final _trailParticlePaint = Paint()
    ..color = const Color(0XFFFFFFFF).withOpacity(0.7);
  late final _offsetLeft = Vector2(-_body.width * 0.25, 0);
  late final _offsetRight = Vector2(_body.width * 0.25, 0);

  double speed = 0;
  static const _maxSpeed = 100.0;
  static const _acceleration = 0.5;

  bool _isOnGround = true;

  @override
  FutureOr<void> onLoad() async {
    await add(_body);
    await add(
      CircleHitbox.relative(
        1,
        parentSize: _body.size,
        anchor: Anchor.center,
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _moveDirection
      ..x = ancestor.input.hAxis
      ..y = 1
      ..normalize();
    speed = lerpDouble(speed, _maxSpeed, _acceleration * dt)!;

    angle = _moveDirection.screenAngle() + pi;
    position.addScaled(_moveDirection, speed * dt);

    if (_isOnGround && !game.isOffTrail) {
      parent?.add(
        ParticleSystemComponent(
          position: position,
          particle: Particle.generate(
            count: 2,
            lifespan: 1.5,
            generator: (index) => TranslatedParticle(
              child: CircleParticle(
                paint: _trailParticlePaint,
                radius: 0.8,
              ),
              offset: index == 0 ? _offsetLeft : _offsetRight,
            ),
          ),
        ),
      );
    }
    super.update(dt);
  }

  void resetTo(Vector2 resetPosition) {
    position.setFrom(resetPosition);
    speed += 0.5;
  }

  double jump() {
    game.audioController.playSfx(Sfx.jump);
    _isOnGround = false;

    final jumpFactor = speed / _maxSpeed;
    final jumpScale = lerpDouble(1.0, 1.2, jumpFactor)!;
    final jumpDuration = lerpDouble(0.0, 0.8, jumpFactor)!;

    _body.add(
      ScaleEffect.by(
        Vector2.all(jumpScale),
        EffectController(
          duration: jumpDuration,
          alternate: true,
          curve: Curves.easeInOut,
        ),
        onComplete: () => _isOnGround = true,
      ),
    );

    return jumpFactor;
  }
}
