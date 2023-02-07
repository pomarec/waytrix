import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import 'palette.dart';

class Char extends PositionComponent {
  static const fontFamily = "Kawkab Mono Bold";
  static final charSize = Vector2.all(10);

  Char(double x, double y)
      : super(
          position: Vector2(x, y),
          size: charSize,
        );

  @override
  Future<void> onLoad() async {
    await add(
      TextComponent(
          text: chars[randomBetween(0, chars.length - 1)],
          textRenderer: TextPaint(
            style: TextStyle(
              color: Palette.light.color,
              fontFamily: fontFamily,
            ),
          )),
    );
  }

  set color(Color color) {
    if (children.isNotEmpty) {
      (children.first as TextComponent).textRenderer = TextPaint(
        style: TextStyle(
          color: color,
          // fontFamily: "Hack Nerd Font Mono",
          fontFamily: fontFamily,
        ),
      );
    }
  }
}

const chars = [
  'ب',
  'ج',
  'د',
  'ه',
  'و',
  'ز',
  'ح',
  'ط',
  'ي',
  'ك',
  'ل',
  'م',
  'ن',
  'س',
  'ع',
  'ف',
  'ص',
  'ق',
  'ر',
  'ش',
  'ت',
  'ث',
  'خ',
  'ذ',
  'ض',
  'ظ',
  'غ',
  'ء'
];
