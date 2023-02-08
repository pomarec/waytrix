import 'package:flutter/material.dart';

import 'matrix.dart';

void main() {
  // final app = MatrixApp();
  // runApp(
  //   Container(
  //     // color: Palette.dark.color,
  //     color: Colors.transparent,
  //     child: GameWidget(game: app),
  //   ),
  // );

  runApp(CustomPaint(
    painter: MatrixPainter(),
  ));
}
