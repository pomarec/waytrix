import 'package:flutter/widgets.dart';
import 'package:random_string/random_string.dart';
import 'package:waytrix/engine.dart';
import 'package:waytrix/extensions.dart';
import 'package:waytrix/matrix_scene.dart';
import 'package:waytrix/palette.dart';

class VerticalWord extends Component {
  MatrixComponent parent;
  double x;
  double leadingY;
  int speed;
  int colorIndex;
  late List<TextPainter> chars;

  VerticalWord({
    required this.parent,
    this.x = 0,
  })  : leadingY = 0,
        speed = randomBetween(4, 9),
        colorIndex = randomBetween(0, Palette.entries.length - 1) {
    chars = List.generate(
      randomBetween(5, 30),
      (_) => Palette.textPainterCache[Palette.randomChar]![colorIndex],
    );
  }

  bool doesOverlapTopBorder() =>
      leadingY - chars.length * Palette.charSize <= 0;

  @override
  onTick() {
    super.onTick();

    // Move down
    if (Scene.main.clockModulus(10 / speed.toDouble()) == 0) {
      leadingY += Palette.charSize;
      chars = chars
          .skip(1)
          .map(
            (e) => Palette
                .textPainterCache[(e.text as TextSpan).text!]![colorIndex],
          )
          .toList()
        ..addAll([
          Palette.textPainterLightCache[Palette.randomChar]!,
        ]);
    }

    // Dispose if reached end
    if (leadingY - (chars.length * Palette.charSize) > Scene.main.size.height) {
      parent.remove(this);
    }
  }

  @override
  paintOn(Canvas canvas) {
    chars.enumerated(
      (i, e) => e.paint(
        canvas,
        Offset(
          x + (Palette.charSize - e.size.width) / 2,
          leadingY - (chars.length - i) * Palette.charSize,
        ),
      ),
    );
  }
}
