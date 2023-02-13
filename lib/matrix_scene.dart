import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:random_string/random_string.dart';
import 'package:waytrix/engine.dart';
import 'package:waytrix/extensions.dart';
import 'package:waytrix/palette.dart';

import 'vertical_word.dart';

class MatrixComponent extends Component {
  final columns = <List<VerticalWord>>[];
  final backgroundHeightPerColumn = <double>[];

  remove(Component c) {
    for (var column in columns) {
      column.removeWhere((e) => e == c);
    }
    Scene.main.remove(c);
  }

  @override
  onResize() {
    super.onResize();
    final nbColumns = (Scene.main.size.width / Palette.charSize).round() + 1;
    columns.ensureLength(nbColumns, (index) => []);
    backgroundHeightPerColumn.ensureLength(nbColumns, (index) => 0);
  }

  @override
  onTick() {
    super.onTick();
    // Generate new words
    final nextX = nextWordColumn();
    if (nextX != null && Scene.main.clockModulus(10) == 0) {
      final word = VerticalWord(
        parent: this,
        x: nextX.toDouble() * Palette.charSize,
      );
      columns[nextX].add(word);
      Scene.main.add(word);
    }

    // Make background move
    columns.enumerated((i, column) {
      if (column.isNotEmpty) {
        backgroundHeightPerColumn[i] = min(
          Scene.main.size.height,
          max(
            backgroundHeightPerColumn[i],
            column.map((e) => e.leadingY).reduce(max),
          ),
        );
      }
    });
  }

  @override
  init() {
    super.init();
    // Generate a word per columns like a "curtain"
    for (var i = 0; i < columns.length; i++) {
      final word = VerticalWord(
        parent: this,
        x: i.toDouble() * Palette.charSize,
      )
        ..speed = 30
        ..leadingY = Random().nextDouble() * -10 * Palette.charSize.toDouble();

      columns[i].add(word);
      Scene.main.add(word);
    }
  }

  @override
  void paintOn(Canvas canvas) {
    // Paint background
    var path = Path();
    path.moveTo(0, backgroundHeightPerColumn.first);
    backgroundHeightPerColumn.enumerated((i, height) {
      final nextHeight = i < backgroundHeightPerColumn.length - 1
          ? (backgroundHeightPerColumn[i + 1] + height) / 2
          : 0;
      path.quadraticBezierTo(
        i * Palette.charSize.toDouble(),
        height,
        (i + 0.5) * Palette.charSize.toDouble(),
        height,
      );
      path.quadraticBezierTo(
        (i + 1) * Palette.charSize.toDouble(),
        height,
        (i + 1) * Palette.charSize.toDouble(),
        nextHeight.toDouble(),
      );
    });
    path.lineTo(0, 0);
    path.close();
    canvas.drawPath(path, Palette.darkPaint);

    super.paintOn(canvas);
  }

  // Try to equilibrate the number of words per column
  int? nextWordColumn() {
    final columnsNotOverlappingTopBorder = columns.where(
      (c) => !c.any((l) => l.doesOverlapTopBorder()),
    );
    if (columnsNotOverlappingTopBorder.isEmpty) {
      return null;
    } else {
      final minNumberOfWords = columnsNotOverlappingTopBorder
          .map(
            (c) => c.length,
          )
          .reduce(min);
      final candidates = columnsNotOverlappingTopBorder
          .whereMapEnumerated(
            (i, e) => e.length == minNumberOfWords ? i : null,
          )
          .toList();
      if (candidates.isEmpty) {
        return null;
      } else {
        final nextX = candidates[randomBetween(0, candidates.length - 1)];
        return nextX;
      }
    }
  }
}
