import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide OverlayRoute, Route;
import 'package:garda_green/audio/audio.dart';
import 'package:garda_green/game/components/components.dart';
import 'package:garda_green/game/entities/entities.dart';
import 'package:garda_green/game/level/level.dart';
import 'package:garda_green/game/menu/menu.dart';
import 'package:garda_green/settings/settings.dart';

class TheRunnerGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  TheRunnerGame({
    required this.audioController,
    required this.settingsController,
    required this.mediaQuery,
    super.children,
    super.world,
    super.camera,
  });

  final AudioController audioController;
  final SettingsController settingsController;
  final MediaQueryData mediaQuery;

  static const isMobile = false;

  static const id = 'game_view';
  static const _timeScaleRate = 1.0;
  static const _bgmFadeRate = 1.0;
  static const _bgmMinVol = 0.0;
  static const _bgmMaxVol = 0.4;

  final int level = 1;

  late final input = Input(
    keyCallbacks: {
      LogicalKeyboardKey.escape: () {
        overlays.add(PauseMenu.id);
        pauseEngine();
      },
    },
  );

  late final _resetTimer = Timer(
    1,
    autoStart: false,
    onTick: _resetPlayer,
  );

  late final _cameraShake = MoveEffect.by(
    Vector2(0, 3),
    InfiniteEffectController(
      ZigzagEffectController(period: 0.2),
    ),
  );

  late final World _world;
  late final CameraComponent _camera;
  late final Player _player;
  late final Vector2 _lastSafePosition;
  late final RectangleComponent _fader;
  late final SpriteSheet _spriteSheet;
  late final Hud _hud;

  late final int _star1;
  late final int _star2;
  late final int _star3;

  int _nTrailTriggers = 0;
  int _nSnowmanCollected = 0;
  int _nLives = 3;

  bool get isOffTrail => _nTrailTriggers == 0;

  bool _isLevelCompleted = false;
  bool _isGameOver = false;

  @override
  Color backgroundColor() => const Color(0xFFA7E38E);

  @override
  FutureOr<void> onLoad() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final map = await TiledComponent.load(
      'level_$level.tmx',
      Vector2.all(16),
    );

    final tiles = images.fromCache('../images/tilemap_packed.png');
    _spriteSheet = SpriteSheet(
      image: tiles,
      srcSize: Vector2.all(16),
    );

    _star1 = map.tileMap.map.properties.getValue<int>('Star1')!;
    _star2 = map.tileMap.map.properties.getValue<int>('Star2')!;
    _star3 = map.tileMap.map.properties.getValue<int>('Star3')!;

    await _setupWorldAndCamera(map);
    await _handleSpawnPoints(map);
    await _handleTriggers(map);

    _fader = RectangleComponent(
      priority: 1,
      size: _camera.viewport.virtualSize,
      paint: Paint()..color = backgroundColor(),
      children: [
        OpacityEffect.fadeOut(
          LinearEffectController(1.5),
        ),
      ],
    );

    _hud = Hud(
      playerSprite: _spriteSheet.getSprite(5, 10),
      snowmanSprite: _spriteSheet.getSprite(5, 9),
      input: TheRunnerGame.isMobile ? input : null,
      onPausePressed: TheRunnerGame.isMobile ? () {} : null,
    );

    await _camera.viewport.addAll([_fader, _hud]);

    await _camera.viewfinder.add(_cameraShake);
    _cameraShake.pause();

    await audioController.changeMusic(Song.gameplay);

    await audioController.musicPlayer.setVolume(0);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (_isLevelCompleted || _isGameOver) {
      _player.timeScale = lerpDouble(
        _player.timeScale,
        0.0,
        _timeScaleRate * dt,
      )!;
    } else {
      if (isOffTrail && input.active) {
        _resetTimer.update(dt);
        if (!_resetTimer.isRunning()) {
          _resetTimer.start();
        }
        if (_cameraShake.isPaused) {
          _cameraShake.resume();
        }
      } else {
        if (_resetTimer.isRunning()) {
          _resetTimer.stop();
        }
        if (!_cameraShake.isPaused) {
          _cameraShake.pause();
        }
      }
    }

    if (_isLevelCompleted) {
      if (audioController.musicPlayer.volume > _bgmMinVol) {
        audioController.musicPlayer.setVolume(
          lerpDouble(
            audioController.musicPlayer.volume,
            _bgmMinVol,
            _bgmFadeRate * dt,
          )!,
        );
      }
    } else {
      if (audioController.musicPlayer.volume < _bgmMaxVol) {
        audioController.musicPlayer.setVolume(
          lerpDouble(
            audioController.musicPlayer.volume,
            _bgmMaxVol,
            _bgmFadeRate * dt,
          )!,
        );
      }
    }
    super.update(dt);
  }

  @override
  void onRemove() {
    audioController.musicPlayer.setVolume(0.3);
    super.onRemove();
  }

  Future<void> _setupWorldAndCamera(
    TiledComponent<FlameGame<World>> map,
  ) async {
    _world = World(children: [map, input]);
    await add(_world);

    final aspectRatio = mediaQuery.size.aspectRatio;
    const height = TheRunnerGame.isMobile ? 200.0 : 180.0;
    final width = TheRunnerGame.isMobile ? height * aspectRatio : 320.0;

    _camera = CameraComponent.withFixedResolution(
      width: width,
      height: height,
      world: _world,
    );
    await add(_camera);
  }

  Future<void> _handleSpawnPoints(TiledComponent<FlameGame<World>> map) async {
    final spawnPointsLayer = map.tileMap.getLayer<ObjectGroup>('SpawnPoints');
    final objects = spawnPointsLayer?.objects;

    if (objects != null) {
      for (final object in objects) {
        switch (object.class_) {
          case 'Player':
            _player = Player(
              position: Vector2(object.x, object.y),
              priority: 1,
              sprite: _spriteSheet.getSprite(5, 10),
            );
            await _world.add(_player);
            _camera.follow(_player);
            _lastSafePosition = Vector2(object.x, object.y);
          case 'Snowman':
            final snowman = Snowman(
              position: Vector2(object.x, object.y),
              sprite: _spriteSheet.getSprite(5, 9),
              onCollected: _onSnowmanCollected,
            );
            await _world.add(snowman);
        }
      }
    }
  }

  Future<void> _handleTriggers(TiledComponent<FlameGame<World>> map) async {
    final triggerLayer = map.tileMap.getLayer<ObjectGroup>('Triggers');
    final objects = triggerLayer?.objects;

    if (objects != null) {
      for (final object in objects) {
        switch (object.class_) {
          case 'Trail':
            final vertices = <Vector2>[];
            for (final point in object.polygon) {
              vertices.add(Vector2(point.x + object.x, point.y + object.y));
            }
            final hitbox = PolygonHitbox(
              vertices,
              collisionType: CollisionType.passive,
              isSolid: true,
            );

            hitbox.onCollisionStartCallback = (_, __) => _onTrailEnter();
            hitbox.onCollisionEndCallback = (_) => _onTrailExit();

            await map.add(hitbox);
          case 'Checkpoint':
            final checkpoint = RectangleHitbox(
              size: Vector2(object.width, object.height),
              position: Vector2(object.x, object.y),
              collisionType: CollisionType.passive,
            );

            checkpoint.onCollisionStartCallback =
                (_, __) => _onCheckpoint(checkpoint);

            await map.add(checkpoint);
          case 'Ramp':
            final ramp = RectangleHitbox(
              size: Vector2(object.width, object.height),
              position: Vector2(object.x, object.y),
              collisionType: CollisionType.passive,
            );

            ramp.onCollisionStartCallback = (_, __) => _onRamp();

            await map.add(ramp);
          case 'Start':
            final trailStart = RectangleHitbox(
              size: Vector2(object.width, object.height),
              position: Vector2(object.x, object.y),
              collisionType: CollisionType.passive,
            );

            trailStart.onCollisionStartCallback = (_, __) => _onTrailStart();

            await map.add(trailStart);
          case 'End':
            final trailEnd = RectangleHitbox(
              size: Vector2(object.width, object.height),
              position: Vector2(object.x, object.y),
              collisionType: CollisionType.passive,
            );

            trailEnd.onCollisionStartCallback = (_, __) => _onTrailEnd();

            await map.add(trailEnd);
        }
      }
    }
  }

  void _onTrailEnter() {
    ++_nTrailTriggers;
  }

  void _onTrailExit() {
    --_nTrailTriggers;
  }

  void _resetPlayer() {
    --_nLives;
    _hud.updateLifeCount(_nLives);
    if (_nLives > 0) {
      _player.resetTo(_lastSafePosition);
    } else {
      _isGameOver = true;
      _fader.add(OpacityEffect.fadeIn(LinearEffectController(1.5)));
      overlays.add(RetryMenu.id);
    }
  }

  void _onCheckpoint(RectangleHitbox checkpoint) {
    _lastSafePosition.setFrom(checkpoint.absoluteCenter);
    checkpoint.removeFromParent();
  }

  void _onRamp() {
    final jumpFactor = _player.jump();
    final jumpScale = lerpDouble(1.0, 1.2, jumpFactor)!;
    final jumpDuration = lerpDouble(0.0, 0.8, jumpFactor)!;

    _camera.viewfinder.add(
      ScaleEffect.by(
        Vector2.all(jumpScale),
        EffectController(
          duration: jumpDuration,
          alternate: true,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  void _onTrailStart() {
    input.active = true;
    _lastSafePosition.setFrom(_player.position);
  }

  void _onTrailEnd() {
    _fader.add(OpacityEffect.fadeIn(LinearEffectController(1.5)));
    input.active = false;
    _isLevelCompleted = true;

    if (_nSnowmanCollected >= _star3) {
      overlays.add(LevelComplete.id);
    } else if (_nSnowmanCollected >= _star2) {
      overlays.add(LevelComplete.id);
    } else if (_nSnowmanCollected >= _star1) {
      overlays.add(LevelComplete.id);
    } else {
      overlays.add(LevelComplete.id);
    }
  }

  void _onSnowmanCollected() {
    ++_nSnowmanCollected;
    _hud.updateSnowmanCollected(_nSnowmanCollected);
  }
}
