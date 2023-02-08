extension IterableExtensions<T> on Iterable<T> {
  Iterable<V> mapEnumerated<V>(V Function(int i, T e) f) sync* {
    int i = 0;
    for (var item in this) {
      yield f(i, item);
      i++;
    }
  }

  enumerated<V>(Function(int i, T e) f) {
    int i = 0;
    for (var item in this) {
      f(i++, item);
    }
  }

  Iterable<V> whereMapEnumerated<V>(V? Function(int i, T e) f) sync* {
    int i = 0;
    for (var item in this) {
      final mapped = f(i, item);
      if (mapped != null) {
        yield mapped;
      }
      i++;
    }
  }
}

extension ListExtensions<T> on List<T> {
  ensureLength<V>(int newLength, T Function(int index) fill) {
    if (length > newLength) {
      removeRange(newLength, length);
    }
    for (int i = length; i < newLength; i++) {
      add(fill(i));
    }
  }
}
