import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import 'char.dart';
import 'main.dart';
import 'palette.dart';

class Line extends TimerComponent with HasGameRef<MatrixApp> {
  late final double x;
  late final int length;
  late final Color color;
  int step = 0;

  Line({
    required super.period,
    super.repeat = true,
  });

  @override
  Future<void> onLoad() async {
    x = randomBetween(0, gameRef.size.x.toInt()).toDouble();
    length = randomBetween(5, 30);
    color = Palette
        .charEntries[randomBetween(0, Palette.charEntries.length - 1)].color;
    await onTick();
  }

  @override
  Future onTick() async {
    children
        .take(max(0, children.length - length))
        .forEach((c) => c.removeFromParent());

    if (children.isNotEmpty) {
      (children.last as Char).color = color;

      if ((children.first as PositionComponent).y > gameRef.size.y) {
        removeFromParent();
      }
    }

    final double lastChildY = children.isEmpty
        ? 0
        : (children.last as PositionComponent).y +
            (children.last as PositionComponent).height +
            15;
    await add(
      Char(x, lastChildY),
    );
  }
}
