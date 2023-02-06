import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import 'line.dart';

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
  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    add(
      TimerComponent(
        period: 0.3,
        repeat: true,
        onTick: () {
          List.generate(
              3,
              (_) => add(
                    Line(
                      period: 1 / randomBetween(10, 20).toDouble(),
                    ),
                  ));
        },
      ),
    );
    // add(Line());
  }
}
