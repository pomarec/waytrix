import 'package:flame/palette.dart';

class Palette {
  static const light = PaletteEntry(Color(0xFFFFFFFF));
  static const dark = PaletteEntry(Color(0xFF181B1F));

  static const red = PaletteEntry(Color(0xFFCA736C));
  static const orange = PaletteEntry(Color(0xFFBA823A));
  static const yellow = PaletteEntry(Color(0xFF8D9741));
  static const green = PaletteEntry(Color(0xFF47A477));
  static const cyan = PaletteEntry(Color(0xFF00A2AF));
  static const blue = PaletteEntry(Color(0xFF5794D0));
  static const purple = PaletteEntry(Color(0xFF9481CC));
  static const magenta = PaletteEntry(Color(0xFFBC73A4));

  static final charEntries = [
    Palette.red,
    Palette.orange,
    Palette.yellow,
    Palette.green,
    Palette.cyan,
    Palette.blue,
    Palette.purple,
    Palette.magenta,
  ];
}
