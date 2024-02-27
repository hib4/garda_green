import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:garda_green/game/entities/entities.dart';
import 'package:garda_green/game/game.dart';

class Trash extends PositionComponent
    with CollisionCallbacks, HasGameReference<TheRunnerGame> {
  Trash({required Sprite sprite, super.position, this.onHit})
      : _body = SpriteComponent(sprite: sprite, anchor: Anchor.center);

  final SpriteComponent _body;
  final VoidCallback? onHit;

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
      _hit();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _hit() {
    removeFromParent();
    onHit?.call();
  }
}
