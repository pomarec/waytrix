import 'dart:math';

import 'package:flutter/painting.dart';

class Palette {
  static const light = Color(0xFFFFFFFF);
  static const dark = Color(0xFF181B1F);
  static final darkPaint = Paint()..color = dark;

  static const red = Color(0xFFCA736C);
  static const orange = Color(0xFFBA823A);
  static const yellow = Color(0xFF8D9741);
  static const green = Color(0xFF47A477);
  static const cyan = Color(0xFF00A2AF);
  static const blue = Color(0xFF5794D0);
  static const purple = Color(0xFF9481CC);
  static const magenta = Color(0xFFBC73A4);

  static final colors = [
    Palette.red,
    Palette.orange,
    Palette.yellow,
    Palette.green,
    Palette.cyan,
    Palette.blue,
    Palette.purple,
    Palette.magenta,
  ];

  static final alphas = [
    10 * 255 ~/ 100,
    15 * 255 ~/ 100,
    25 * 255 ~/ 100,
    50 * 255 ~/ 100,
    60 * 255 ~/ 100,
    70 * 255 ~/ 100,
    85 * 255 ~/ 100,
    100 * 255 ~/ 100,
  ];

  static const charSize = 10;

  static const chars = [
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

  static const fontFamily = "Kawkab Mono Bold";

  static TextPainter textPainterCache(
    String char, [
    int? colorIndex, // null for light color
    int? alphaIndex,
  ]) =>
      _textPainterCache[char]![colorIndex ?? Palette.colors.length]
          [min(alphaIndex ?? alphas.length - 1, alphas.length - 1)];

  static final Map<String, List<List<TextPainter>>> _textPainterCache = {
    for (String char in Palette.chars)
      char: [
        for (Color color in Palette.colors.toList()..add(Palette.light))
          [
            for (int alpha in Palette.alphas)
              TextPainter(
                textDirection: TextDirection.ltr,
                text: TextSpan(
                  text: char,
                  style: TextStyle(
                    fontFamily: Palette.fontFamily,
                    color: color.withAlpha(alpha),
                  ),
                ),
              )..layout()
          ]
      ]
  };
}
