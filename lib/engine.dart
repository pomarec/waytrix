import 'dart:async';

import 'package:flutter/widgets.dart';

class Component {
  Offset position = Offset.zero;
  init() {}
  onResize() {}
  onTick() {}
  paintOn(Canvas canvas) {}
}

class Scene extends CustomPainter with Component {
  static final Scene main = Scene();
  static final ValueNotifier<int> clock = ValueNotifier(0);
  static final Timer _mainTimer = Timer.periodic(
    Duration(milliseconds: (1000 / 30.0).round()),
    (_) => clock.value++,
  );

  var _initialized = false;
  final _components = <Component>[];

  Scene() : super(repaint: clock) {
    clock.addListener(onTick);
    _mainTimer; // trick to avoid treeshaking
  }

  Size size = Size.zero;

  clockModulus(double mod) => (clock.value % mod.ceil()).toDouble();

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  add(Component c) {
    _components.add(c);
    if (_initialized) {
      c.init();
      c.onResize();
    }
  }

  remove(Component c) {
    _components.removeWhere((e) => e == c);
  }

  Widget get widget => CustomPaint(painter: this);

  @override
  @mustCallSuper
  init() => _components.toList().forEach((c) => c.init());

  @override
  @mustCallSuper
  onResize() => _components.toList().forEach((c) => c.onResize());

  @override
  @mustCallSuper
  onTick() => _components.toList().forEach((c) => c.onTick());

  @override
  @mustCallSuper
  void paint(Canvas canvas, Size size) {
    if (this.size != size) {
      this.size = size;
      onResize();
      if (!_initialized) {
        _initialized = true;
        init();
      }
    }
    for (var c in _components) {
      canvas.translate(c.position.dx, c.position.dy);
      c.paintOn(canvas);
      canvas.translate(-c.position.dx, -c.position.dy);
    }
  }
}
