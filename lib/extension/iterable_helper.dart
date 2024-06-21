import 'package:flutter/material.dart';

extension IterableHelper<E> on Iterable<E> {
  T? doWhenFirst<T>(T Function(E first) action, {T? Function()? orElse}) {
    for (E element in this) {
      return action(element);
    }
    if (orElse != null) return orElse();
    return null;
  }

  String maybeValueOf(
    int index, {
    required String Function() orElse,
  }) {
    if (index >= 0 && index < length) {
      return elementAt(index).toString();
    } else {
      return orElse();
    }
  }
}

extension DuplicateOfIterable on Iterable {
  bool get containsDuplicateValues => toSet().length != length;
}

extension InsertWidgetSeparator on Iterable<Widget> {
  insertSeparator(Widget separator,
      {castToList = true, bool skipHead = false, bool skipLast = false}) {
    final result = <Widget>[separator];
    if (skipHead) {
      result.clear();
    }
    // print('[InsertWidgetSeparator] start :result : $result');
    for (final element in this) {
      // print('InsertWidgetSeparator] add element: $element');
      result.add(element);
      if (skipLast && element == last) break;
      result.add(separator);
      // print('InsertWidgetSeparator] add separator: $separator');
      // print('InsertWidgetSeparator] start :result : $result');
    }
    return castToList ? result.toList() : result;
  }
}

extension IterableFilterNull<T> on Iterable<T?> {
  Iterable<T> filterNull() {
    return where((element) => element != null).cast<T>();
  }
}
