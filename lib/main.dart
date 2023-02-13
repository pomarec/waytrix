import 'package:flutter/widgets.dart';
import 'package:waytrix/matrix_scene.dart';

import 'engine.dart';

void main() {
  Scene.main.add(MatrixComponent());
  runApp(Scene.main.widget);
}
