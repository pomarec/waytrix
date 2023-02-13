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
        speed = randomBetween(20, 40),
        colorIndex = randomBetween(0, Palette.colors.length - 1) {
    chars = List.generate(
      randomBetween(10, 40),
      (i) => Palette.textPainterCache(Palette.chars.random(), colorIndex, i),
    );
  }

  bool doesOverlapTopBorder() =>
      leadingY - chars.length * Palette.charSize <= 0;

  @override
  onTick() {
    super.onTick();

    // Move down
    final yIncr = speed * (1 / Scene.tickDuration) * Palette.charSize;
    final nbNewChar = ((leadingY + yIncr) ~/ Palette.charSize) -
        (leadingY ~/ Palette.charSize);
    leadingY += yIncr;

    // Fill new chars
    chars = chars
        .skip(nbNewChar)
        .mapEnumerated(
          (i, e) => Palette.textPainterCache(
              (e.text as TextSpan).text!, colorIndex, i),
        )
        .toList()
      ..addAll(
        List.generate(
          nbNewChar,
          (i) => Palette.textPainterCache(
              Palette.chars.random(), i == nbNewChar - 1 ? null : colorIndex),
        ),
      );

    // Dispose if reached end
    if (leadingY - (chars.length * Palette.charSize) > Scene.main.size.height) {
      parent.remove(this);
    }
  }

  @override
  paintOn(Canvas canvas) {
    chars.enumerated((i, e) {
      e.paint(
        canvas,
        Offset(
          x + (Palette.charSize - e.size.width) / 2,
          ((leadingY ~/ Palette.charSize).toDouble() - (chars.length - i)) *
              Palette.charSize,
        ),
      );
    });
  }
}
