import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:random_string/random_string.dart';
import 'package:waytrix/extensions.dart';
import 'package:waytrix/palette.dart';

class MatrixPainter extends CustomPainter {
  // Code for tick() mechanism

  static final ValueNotifier<int> clock = ValueNotifier(0);
  static final Timer _mainTimer = Timer.periodic(
    Duration(milliseconds: (1000 / 30.0).round()),
    (_) => clock.value++,
  );
  var _initialized = false;

  MatrixPainter() : super(repaint: clock) {
    clock.addListener(onTick);
    _mainTimer; // trick to avoid treeshaking
  }

  Size size = Size.zero;

  clockModulus(double mod) => (clock.value % mod.ceil()).toDouble();

  // --------------------------

  static final Paint _darkPaint = Palette.dark.paint();
  static const charSize = 10;

  final columns = <List<LineData>>[];
  final backgroundHeightPerColumn = <double>[];

  int get nbColumns => (size.width / charSize).round() + 1;

  init() {
    generateFirstRowOfFullWidth();
  }

  onResize() {
    columns.ensureLength(nbColumns, (index) => []);
    backgroundHeightPerColumn.ensureLength(nbColumns, (index) => 0);
  }

  onTick() {
    // Generate new lines
    final nextX = nextLineColumn();
    if (nextX != null && clockModulus(10) == 0) {
      columns[nextX].add(
        LineData(x: nextX.toDouble() * charSize),
      );
    }

    // Make lines move
    columns.enumerated((i, column) {
      for (var line in column) {
        incrementLine(line);
      }

      if (column.isNotEmpty) {
        backgroundHeightPerColumn[i] = min(
          size.height,
          max(
            backgroundHeightPerColumn[i],
            column.map((e) => e.leadingY).reduce(max),
          ),
        );
      }

      column.removeWhere(
        (line) => line.leadingY - (line.chars.length * charSize) > size.height,
      );
    });
  }

  incrementLine(LineData line) {
    if (clockModulus(10 / line.speed.toDouble()) == 0) {
      line.leadingY += MatrixPainter.charSize;
      line.chars = line.chars
          .skip(1)
          .map(
            (e) => Palette
                .textPainterCache[(e.text as TextSpan).text!]![line.colorIndex],
          )
          .toList()
        ..addAll([
          Palette.textPainterLightCache[Palette.randomChar]!,
        ]);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (this.size != size) {
      this.size = size;
      onResize();
      if (!_initialized) {
        _initialized = true;
        init();
      }
    }
    // return;
    paintBackground(canvas);

    // Lines
    for (var column in columns) {
      for (var line in column) {
        paintLine(canvas, line);
      }
    }
  }

  void paintBackground(Canvas canvas) {
    backgroundHeightPerColumn.enumerated((i, height) {
      canvas.drawRect(
        Rect.fromLTWH(i * charSize.toDouble(), 0, charSize.toDouble(), height),
        _darkPaint,
      );
    });
  }

  void paintLine(Canvas canvas, LineData line) {
    line.chars.enumerated(
      (i, e) => e.paint(
        canvas,
        Offset(
          line.x + (charSize - e.size.width) / 2,
          line.leadingY - (line.chars.length - i) * charSize,
        ),
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  // Try to equilibrate the number of lines per column
  int? nextLineColumn() {
    final columnsNotOverlappingTopBorder = columns.where(
      (c) => !c.any((l) => l.doesOverlapTopBorder()),
    );
    if (columnsNotOverlappingTopBorder.isEmpty) {
      return null;
    } else {
      final minNumberOfLines = columnsNotOverlappingTopBorder
          .map(
            (c) => c.length,
          )
          .reduce(min);
      final candidates = columnsNotOverlappingTopBorder
          .whereMapEnumerated(
            (i, e) => e.length == minNumberOfLines ? i : null,
          )
          .toList();
      if (candidates.isEmpty) {
        return null;
      } else {
        final nextX = candidates[randomBetween(0, candidates.length - 1)];
        return nextX;
      }
    }
  }

  generateFirstRowOfFullWidth() {
    for (var i = 0; i < nbColumns; i++) {
      final line = LineData(x: i.toDouble() * charSize)..speed = 30;
      columns[i].add(line);
      if (i > 0) {
        // final lastLine = columns[i - 1].last;
        line.leadingY = Random().nextDouble() * -10 * charSize.toDouble();
      }
    }
  }
}

class LineData {
  double x;
  double leadingY;
  int speed;
  int colorIndex;
  late List<TextPainter> chars;

  LineData({this.x = 0})
      : leadingY = 0,
        speed = randomBetween(4, 9),
        colorIndex = randomBetween(0, Palette.entries.length - 1) {
    chars = List.generate(
      randomBetween(5, 30),
      (_) => Palette.textPainterCache[Palette.randomChar]![colorIndex],
    );
  }

  bool doesOverlapTopBorder() =>
      leadingY - chars.length * MatrixPainter.charSize <= 0;
}
