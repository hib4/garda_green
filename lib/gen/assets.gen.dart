/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/background_menu_desktop.png
  AssetGenImage get backgroundMenuDesktop =>
      const AssetGenImage('assets/images/background_menu_desktop.png');

  /// File path: assets/images/background_menu_mobile.png
  AssetGenImage get backgroundMenuMobile =>
      const AssetGenImage('assets/images/background_menu_mobile.png');

  /// File path: assets/images/pause.png
  AssetGenImage get pause => const AssetGenImage('assets/images/pause.png');

  /// File path: assets/images/tilemap_packed.png
  AssetGenImage get tilemapPacked =>
      const AssetGenImage('assets/images/tilemap_packed.png');

  /// File path: assets/images/tilemap_test.png
  AssetGenImage get tilemapTest =>
      const AssetGenImage('assets/images/tilemap_test.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        backgroundMenuDesktop,
        backgroundMenuMobile,
        pause,
        tilemapPacked,
        tilemapTest
      ];
}

class $AssetsLicensesGen {
  const $AssetsLicensesGen();

  $AssetsLicensesPressStart2pGen get pressStart2p =>
      const $AssetsLicensesPressStart2pGen();
}

class $AssetsMusicGen {
  const $AssetsMusicGen();

  /// File path: assets/music/background.wav
  String get background => 'assets/music/background.wav';

  /// File path: assets/music/gameplay.mp3
  String get gameplay => 'assets/music/gameplay.mp3';

  /// List of all assets
  List<String> get values => [background, gameplay];
}

class $AssetsSfxGen {
  const $AssetsSfxGen();

  /// File path: assets/sfx/collect.wav
  String get collect => 'assets/sfx/collect.wav';

  /// File path: assets/sfx/hurt.wav
  String get hurt => 'assets/sfx/hurt.wav';

  /// File path: assets/sfx/jump.wav
  String get jump => 'assets/sfx/jump.wav';

  /// List of all assets
  List<String> get values => [collect, hurt, jump];
}

class $AssetsTilesGen {
  const $AssetsTilesGen();

  /// File path: assets/tiles/level_1.tmx
  String get level1 => 'assets/tiles/level_1.tmx';

  /// File path: assets/tiles/level_2.tmx
  String get level2 => 'assets/tiles/level_2.tmx';

  /// File path: assets/tiles/level_3.tmx
  String get level3 => 'assets/tiles/level_3.tmx';

  /// List of all assets
  List<String> get values => [level1, level2, level3];
}

class $AssetsLicensesPressStart2pGen {
  const $AssetsLicensesPressStart2pGen();

  /// File path: assets/licenses/press_start_2p/OFL.txt
  String get ofl => 'assets/licenses/press_start_2p/OFL.txt';

  /// List of all assets
  List<String> get values => [ofl];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLicensesGen licenses = $AssetsLicensesGen();
  static const $AssetsMusicGen music = $AssetsMusicGen();
  static const $AssetsSfxGen sfx = $AssetsSfxGen();
  static const $AssetsTilesGen tiles = $AssetsTilesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
