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
import 'package:garda_green/game/pause/pause.dart';
import 'package:garda_green/game/score/score.dart';
import 'package:garda_green/settings/settings.dart';
import 'package:garda_green/theme/theme.dart';

class TheRunnerGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  TheRunnerGame({
    required this.audioController,
    required this.settingsController,
    required this.aspectRatio,
    required this.isMobile,
    required this.top,
    super.children,
    super.world,
    super.camera,
  });

  final AudioController audioController;
  final SettingsController settingsController;
  final double aspectRatio;
  final bool isMobile;
  final double top;

  static const id = 'game_view';
  static const _timeScaleRate = 1.0;
  static const _bgmFadeRate = 1.0;
  static const _bgmMinVol = 0.1;
  static const _bgmMaxVol = 0.5;
  static const _sections = [
    'level_1.tmx',
    'level_2.tmx',
    'level_3.tmx',
  ];

  late final input = Input(
    keyCallbacks: {
      LogicalKeyboardKey.escape: _onGamePaused,
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

  late World _world;
  late CameraComponent _camera;
  late Player _player;
  late Vector2 _lastSafePosition;
  late RectangleComponent _fader;
  late SpriteSheet _spriteSheet;
  late Hud _hud;
  late TiledComponent<FlameGame<World>> map;

  int _totalSections = 1;
  int _currentSection = 0;
  int _nTrailTriggers = 0;
  int _nStarCollected = 0;
  int _nLives = 3;

  int get score => _nStarCollected * (_totalSections * 10);

  bool get isOffTrail => _nTrailTriggers == 0;

  bool _isLevelCompleted = false;
  bool _isGameOver = false;

  @override
  Color backgroundColor() => AppColors.background;

  @override
  FutureOr<void> onLoad() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    await _setupWorld();
    await _setupCamera();

    _fader = RectangleComponent(
      priority: 1,
      size: _camera.viewport.virtualSize,
      paint: Paint()..color = backgroundColor(),
      children: [
        OpacityEffect.fadeOut(
          LinearEffectController(1),
        ),
      ],
    );

    _hud = Hud(
      playerSprite: _spriteSheet.getSprite(0, 6),
      starSprite: _spriteSheet.getSprite(1, 6),
      input: isMobile ? input : null,
      onPausePressed: isMobile ? _onGamePaused : null,
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

    if (_isGameOver) {
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

  Future<void> _setupWorld() async {
    map = await TiledComponent.load(
      _sections[_currentSection],
      Vector2.all(16),
    );

    final tiles = images.fromCache('../images/garda_green_tilemap.png');
    _spriteSheet = SpriteSheet(
      image: tiles,
      srcSize: Vector2.all(16),
    );

    _world = World(children: [map, input]);
    await add(_world);

    await _handleSpawnPoints(map);
    await _handleTriggers(map);
  }

  Future<void> _setupCamera() async {
    final height = isMobile ? 200.0 : 180.0;
    final width = isMobile ? height * aspectRatio : 320.0;

    _camera = CameraComponent.withFixedResolution(
      width: width,
      height: height,
      world: _world,
    );
    await add(_camera);

    _camera.follow(_player);
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
              sprite: _spriteSheet.getSprite(0, 6),
            );
            await _world.add(_player);
            _lastSafePosition = Vector2(object.x, object.y);
          case 'Star':
            final star = Star(
              position: Vector2(object.x, object.y),
              sprite: _spriteSheet.getSprite(1, 6),
              onCollected: _onStarCollected,
            );
            await _world.add(star);
          case 'Trash':
            final trash = Trash(
              position: Vector2(object.x, object.y),
              sprite: _spriteSheet.getSprite(7, 0),
              onHit: _onHit,
            );
            await _world.add(trash);
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

  void _onGamePaused() {
    overlays.add(PausePage.id);
    pauseEngine();
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
      audioController.playSfx(Sfx.hurt);
      _player.resetTo(_lastSafePosition);
    } else {
      _isGameOver = true;
      _fader.add(OpacityEffect.fadeIn(LinearEffectController(1)));
      overlays.add(ScorePage.id);
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
    _fader.add(OpacityEffect.fadeIn(LinearEffectController(1)));
    input.active = false;
    _isLevelCompleted = true;
    _currentSection = (_currentSection + 1) % _sections.length;
    _totalSections++;
    _startNextLevel();
  }

  Future<void> _startNextLevel() async {
    await Future<void>.delayed(const Duration(seconds: 1));

    _world.removeWhere(
      (component) =>
          component is TiledComponent ||
          component is Player ||
          component is Star ||
          component is Trash,
    );

    map = await TiledComponent.load(
      _sections[_currentSection],
      Vector2.all(16),
    );

    input.hAxis = 0;

    _nTrailTriggers = 0;
    _isLevelCompleted = false;
    _isGameOver = false;

    await _world.add(map);
    await _handleSpawnPoints(map);
    await _handleTriggers(map);

    _camera.follow(_player);
    _camera.viewfinder.add(_cameraShake);
    _cameraShake.pause();

    _fader.add(OpacityEffect.fadeOut(LinearEffectController(1)));
  }

  void _onStarCollected() {
    ++_nStarCollected;
    _hud.updateStarCollected(_nStarCollected);
  }

  void _onHit() {
    --_nLives;
    _hud.updateLifeCount(_nLives);
    audioController.playSfx(Sfx.hit);
    if (_nLives < 1) {
      _isGameOver = true;
      _fader.add(OpacityEffect.fadeIn(LinearEffectController(1)));
      overlays.add(ScorePage.id);
    } else {
      _player.speed *= 0.5;
    }
  }
}
