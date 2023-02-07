extension Extensions<T> on Iterable<T> {
  Iterable<V> mapEnumerated<V>(V Function(int i, T e) f) sync* {
    int i = 0;
    for (var item in this) {
      yield f(i, item);
      i++;
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
