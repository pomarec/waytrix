import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import 'package:random_string/random_string.dart';

class Palette {
  static const light = PaletteEntry(Color(0xFFFFFFFF));
  static const dark = PaletteEntry(Color(0xFF181B1F));
  static final darkPaint = Palette.dark.paint();

  static const red = PaletteEntry(Color(0xFFCA736C));
  static const orange = PaletteEntry(Color(0xFFBA823A));
  static const yellow = PaletteEntry(Color(0xFF8D9741));
  static const green = PaletteEntry(Color(0xFF47A477));
  static const cyan = PaletteEntry(Color(0xFF00A2AF));
  static const blue = PaletteEntry(Color(0xFF5794D0));
  static const purple = PaletteEntry(Color(0xFF9481CC));
  static const magenta = PaletteEntry(Color(0xFFBC73A4));

  static final entries = [
    Palette.red,
    Palette.orange,
    Palette.yellow,
    Palette.green,
    Palette.cyan,
    Palette.blue,
    Palette.purple,
    Palette.magenta,
  ];

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

  static PaletteEntry get randomCharEntry =>
      entries[randomBetween(0, entries.length - 1)];
  static String get randomChar => chars[randomBetween(0, chars.length - 1)];

  static final Map<String, List<TextPainter>> textPainterCache = {
    for (String char in Palette.chars)
      char: Palette.entries
          .map(
            (e) => TextPainter(
              textDirection: TextDirection.ltr,
              text: TextSpan(
                text: char,
                style: TextStyle(
                  fontFamily: Palette.fontFamily,
                  color: e.color,
                ),
              ),
            )..layout(),
          )
          .toList(),
  };

  static final Map<String, TextPainter> textPainterLightCache = {
    for (String char in Palette.chars)
      char: TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: char,
          style: TextStyle(
            fontFamily: Palette.fontFamily,
            color: Palette.light.color,
          ),
        ),
      )..layout(),
  };

  static const charSize = 10;
}
