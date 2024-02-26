import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:garda_green/audio/audio.dart';
import 'package:garda_green/game/entities/player.dart';
import 'package:garda_green/game/game.dart';

class Star extends PositionComponent
    with CollisionCallbacks, HasGameReference<TheRunnerGame> {
  Star({required Sprite sprite, super.position, this.onCollected})
      : _body = SpriteComponent(sprite: sprite, anchor: Anchor.center);

  final SpriteComponent _body;
  final VoidCallback? onCollected;

  late final _particlePaint = Paint()..color = const Color(0xFFFFFFFF);

  static final _random = Random();

  static Vector2 _randomVector(double scale) {
    return Vector2(
      2.0 * _random.nextDouble() - 1.0,
      2.0 * _random.nextDouble() - 1.0,
    )
      ..normalize()
      ..scale(scale);
  }

  @override
  FutureOr<void> onLoad() async {
    await add(_body);
    await add(
      CircleHitbox.relative(
        1,
        parentSize: _body.size,
        anchor: Anchor.center,
        collisionType: CollisionType.passive,
      ),
    );
    return super.onLoad();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is Player) {
      _collect();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _collect() {
    game.audioController.playSfx(Sfx.collect);
    addAll(
      [
        OpacityEffect.fadeOut(
          LinearEffectController(0.4),
          target: _body,
          onComplete: removeFromParent,
        ),
        ScaleEffect.by(
          Vector2.all(1.2),
          LinearEffectController(0.4),
        ),
      ],
    );
    parent?.add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: 30,
          lifespan: 1,
          generator: (index) => MovingParticle(
            child: ScalingParticle(
              to: 0,
              child: CircleParticle(
                paint: _particlePaint,
                radius: 2.0 + _random.nextDouble() * 3.0,
              ),
            ),
            to: _randomVector(16),
          ),
        ),
      ),
    );
    onCollected?.call();
  }
}
