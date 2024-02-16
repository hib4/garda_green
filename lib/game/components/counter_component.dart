import 'package:flame/components.dart';
import 'package:garda_green/game/game.dart';

class CounterComponent extends PositionComponent
    with HasGameRef<GardaGreen> {
  CounterComponent({
    required super.position,
  }) : super(anchor: Anchor.center);

  late final TextComponent text;

  @override
  Future<void> onLoad() async {
    await add(
      text = TextComponent(
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: game.textStyle,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    text.text = gameRef.l10n.counterText(gameRef.counter);
  }
}
