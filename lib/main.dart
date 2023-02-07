import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import 'char.dart';
import 'extensions.dart';
import 'line.dart';
import 'palette.dart';

void main() {
  final app = MatrixApp();
  runApp(
    Container(
      // color: Palette.dark.color,
      color: Colors.transparent,
      child: GameWidget(game: app),
    ),
  );
}

class MatrixApp extends FlameGame {
  late final Component backgroundComponent;
  final nbLinesPerColumn = <int>[];

  int get nbColumns => (size.x / Char.charSize.x).round() + 1;

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    adjustNbLinePerColumnSize();

    backgroundComponent = Component();
    add(backgroundComponent);

    add(
      TimerComponent(
        period: 1,
        repeat: true,
        onTick: _onTick,
      ),
    );
    // add(
    //   Line(
    //     x: nextLineX(),
    //     period: 1 / randomBetween(10, 20).toDouble(),
    //   ),
    // );
  }

  _onTick() async {
    for (int i = 0; i < 15; i++) {
      await add(
        Line(
          x: nextLineX(),
          period: 1 / randomBetween(40, 70).toDouble(),
        ),
      );
    }
    print(
        "nbLinesPerColumn ${nbLinesPerColumn.length} \t backgroundComponent ${backgroundComponent.children.length}");
  }

  /// Adjust nbLinesPerColumn size to screen size
  void adjustNbLinePerColumnSize() {
    if (nbLinesPerColumn.length > nbColumns) {
      nbLinesPerColumn.removeRange(nbColumns, nbLinesPerColumn.length);
    } else if (nbLinesPerColumn.length < nbColumns) {
      nbLinesPerColumn.addAll(
        List.filled(nbColumns - nbLinesPerColumn.length, 0),
      );
    }
  }

  // Try to equilibrate the number of lines per column
  double nextLineX() {
    final minNumberOfLines = nbLinesPerColumn.reduce(min);
    final candidates = nbLinesPerColumn
        .whereMapEnumerated((i, e) => e == minNumberOfLines ? i : null)
        .toList();
    final nextX = candidates[randomBetween(0, candidates.length - 1)];
    nbLinesPerColumn[nextX] = nbLinesPerColumn[nextX] + 1;
    return nextX.toDouble() * Char.charSize.x;
  }

  darkenBackground(double x, double y) async {
    final backgroundColumn =
        backgroundComponent.componentsAtPoint(Vector2(x + 1, 0)).toList();
    if (backgroundColumn.isEmpty) {
      final backgroundComponent = RectangleComponent(
        position: Vector2(x, 0),
        size: Char.charSize,
        paint: Palette.dark.paint(),
      );
      await this.backgroundComponent.add(backgroundComponent);
      backgroundColumn.add(backgroundComponent);
    }

    final backgroundComponentSize =
        (backgroundColumn.first as RectangleComponent).size;
    backgroundComponentSize.y = max(backgroundComponentSize.y, y);
  }
}
