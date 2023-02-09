import 'dart:ui';

class Palette {
  static const light = Color(0xFFFFFFFF);
  static const dark = Color(0xFF181B1F);
  static const red = Color(0xFFCA736C);
  static const orange = Color(0xFFBA823A);
  static const yellow = Color(0xFF8D9741);
  static const green = Color(0xFF47A477);
  static const cyan = Color(0xFF00A2AF);
  static const blue = Color(0xFF5794D0);
  static const purple = Color(0xFF9481CC);
  static const magenta = Color(0xFFBC73A4);

  static const colors = [
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

  static const charSize = Size.fromRadius(5);
}
