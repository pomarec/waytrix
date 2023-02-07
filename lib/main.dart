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
  final RectangleComponent backgroundComponent = RectangleComponent(
    position: Vector2.zero(),
    paint: Paint()..color = Colors.red,
  );
  final nbLinesPerColumn = <int>[];
  final backgroundPerColumn = <Component>[];

  int get nbColumns => (size.x / Char.charSize.x).round() + 1;

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    await add(backgroundComponent);
    await onResize();

    await add(
      TimerComponent(
        period: 2 / nbColumns,
        repeat: true,
        onTick: _onTick,
      ),
    );
  }

  _onTick() async {
    await add(
      Line(
        x: nextLineX(),
        period: 1 / randomBetween(40, 70).toDouble(),
      ),
    );
    // ignore: avoid_print
    print(
        "nbLinesPerColumn ${nbLinesPerColumn.length} \t backgroundComponent ${backgroundComponent.children.length} \t nbLines ${children.length - 1}");
  }

  /// Adjust nbLinesPerColumn & backgroundPerColumn size to screen size
  Future onResize() async {
    nbLinesPerColumn.ensureLength(nbColumns, (_) => 0);

    backgroundPerColumn.ensureLength(
      nbColumns,
      (i) => RectangleComponent(
        position: Vector2(i * Char.charSize.x, 0),
        size: Vector2(Char.charSize.x, 0),
        paint: Palette.dark.paint(),
      ),
    );
    backgroundComponent.removeAll(backgroundComponent.children);
    backgroundComponent.size = size;
    await backgroundComponent.addAll(backgroundPerColumn);
  }

  // Try to equilibrate the number of lines per column
  double nextLineX() {
    final minNumberOfLines = nbLinesPerColumn.reduce(min);
    final candidates = nbLinesPerColumn
        .whereMapEnumerated(
          (i, e) => e == minNumberOfLines ? i : null,
        )
        .toList();
    final nextX = candidates[randomBetween(0, candidates.length - 1)];
    nbLinesPerColumn[nextX] = nbLinesPerColumn[nextX] + 1;

    // avoid overflow
    if (nbLinesPerColumn[nextX] > 10000) {
      nbLinesPerColumn.replaceRange(
        0,
        nbLinesPerColumn.length,
        nbLinesPerColumn.map((e) => e - 10000).toList(),
      );
    }

    return nextX.toDouble() * Char.charSize.x;
  }

  darkenBackground(double x, double y) async {
    final column = (x / Char.charSize.x).round();
    final backgroundComponentSize =
        (backgroundPerColumn[column] as RectangleComponent).size;
    backgroundComponentSize.setValues(
      backgroundComponentSize.x,
      max(backgroundComponentSize.y, y + Char.charSize.y),
    );
  }
}
