import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:waytrix/extensions.dart';
import 'package:waytrix/palette.dart';

void main() {
  runApp(
    const MatrixApp(),
  );
}

class MatrixApp extends StatefulWidget {
  const MatrixApp({super.key});

  @override
  State<MatrixApp> createState() => _MatrixAppState();
}

class _MatrixAppState extends State<MatrixApp> {
  late Timer _clockTimer;
  List<Widget> children = [];
  Size size = Size.zero;

  final columns = <List<Line>>[];

  @override
  void initState() {
    _clockTimer = Timer.periodic(
      const Duration(milliseconds: 1000 ~/ 30),
      (_) => onTick(),
    );
    _clockTimer;
    super.initState();
  }

  onResize() async {
    columns.ensureLength(
      (size.width / Palette.charSize.width).ceil(),
      (_) => <Line>[],
    );
  }

  onTick() async {
    if (columns.isNotEmpty) {
      final xIndex = randomBetween(0, columns.length - 1);
      final column = columns[xIndex];
      column.add(
        Line(x: xIndex * Palette.charSize.width),
      );
    }
    for (var c in columns) {
      for (var l in c) {
        l.increment();
      }
    }

    children = columns
        .expand(
          (c) => c.expand((l) => l.chars),
        )
        .toList();
    setState(() {});
  }

  final stackKey = const Key('a');
  @override
  Widget build(BuildContext context) => LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxHeight != size.height ||
            constraints.maxWidth != size.width) {
          size = Size(constraints.maxWidth, constraints.maxHeight);
          onResize();
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Container(
            // color: Palette.dark,
            child: Stack(
              key: stackKey,
              children: children,
            ),
          ),
        );
      });
}

class Line {
  final chars = <Char>[];
  final length = randomBetween(10, 20);
  final Color color = Palette.colors.random();
  final double x;

  Line({required this.x}) {
    chars.add(
      Char(
        color: color,
        position: Offset(x, 0),
      ),
    );
  }

  increment() {
    final maxY = chars.map((c) => c.position.dy).reduce(max);
    chars.add(Char(
      color: color,
      position: Offset(x, maxY + Palette.charSize.height),
    ));
    if (chars.length > length) {
      chars.removeRange(0, chars.length - length);
    }
  }
}

class Char extends StatelessWidget {
  final Color color;
  final Offset position;
  @override
  // late final Key key;

  Char({
    required this.color,
    required this.position,
  }) : super(key: Key("Char $color $position.dx $position.dy"));

  @override
  Widget build(BuildContext context) => Positioned(
        key: key,
        left: position.dx,
        top: position.dy,
        child: Container(
          width: Palette.charSize.width,
          height: Palette.charSize.height,
          color: color,
        ),
      );

  Char copyWith(double yIncrement) => Char(
        color: color,
        position: Offset(
          position.dx,
          position.dy + yIncrement,
        ),
      );
}
