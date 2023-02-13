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
    // Generate new lines
    final nextX = nextLineColumn();
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
  void paintOn(Canvas canvas) {
    // Paint background
    backgroundHeightPerColumn.enumerated((i, height) {
      canvas.drawRect(
        Rect.fromLTWH(i * Palette.charSize.toDouble(), 0,
            Palette.charSize.toDouble(), height),
        Palette.darkPaint,
      );
    });

    super.paintOn(canvas);
  }

  // Try to equilibrate the number of lines per column
  int? nextLineColumn() {
    final columnsNotOverlappingTopBorder = columns.where(
      (c) => !c.any((l) => l.doesOverlapTopBorder()),
    );
    if (columnsNotOverlappingTopBorder.isEmpty) {
      return null;
    } else {
      final minNumberOfLines = columnsNotOverlappingTopBorder
          .map(
            (c) => c.length,
          )
          .reduce(min);
      final candidates = columnsNotOverlappingTopBorder
          .whereMapEnumerated(
            (i, e) => e.length == minNumberOfLines ? i : null,
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

  // generateFirstRowOfFullWidth() {
  //   for (var i = 0; i < nbColumns; i++) {
  //     final line = VerticalWord(x: i.toDouble() * charSize)..speed = 30;
  //     columns[i].add(line);
  //     if (i > 0) {
  //       // final lastLine = columns[i - 1].last;
  //       line.leadingY = Random().nextDouble() * -10 * charSize.toDouble();
  //     }
  //   }
  // }
}
