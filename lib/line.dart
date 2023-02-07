import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import 'char.dart';
import 'main.dart';
import 'palette.dart';

class Line extends TimerComponent with HasGameRef<MatrixApp> {
  final double x;
  late final int length;
  late final Color color;
  int step = 0;

  Line({
    required super.period,
    super.repeat = true,
    required this.x,
  });

  @override
  Future<void> onLoad() async {
    length = randomBetween(5, 30);
    color = Palette
        .charEntries[randomBetween(0, Palette.charEntries.length - 1)].color;
    await onTick();
  }

  @override
  Future onTick() async {
    final lastChar = children.isNotEmpty ? children.last as Char : null;

    // Add leading white char
    final double lastCharBottom =
        lastChar != null ? (lastChar.y + lastChar.height) : 0;
    await add(
      Char(x, lastCharBottom),
    );

    // Colorize previous leading char and darken background below him
    lastChar?.color = color;
    if (lastChar != null) {
      await gameRef.darkenBackground(x, lastChar.y);
    }

    // Fade out trailing chars
    children.take(max(0, children.length - length)).forEach(
          (c) => c.removeFromParent(),
        );

    // Self destroy when end reached
    if (children.isNotEmpty && (children.first as Char).y > gameRef.size.y) {
      removeFromParent();
    }
  }
}
