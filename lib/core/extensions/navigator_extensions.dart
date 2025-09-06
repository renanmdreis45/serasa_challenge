import 'package:flutter/material.dart';

extension Navigate<T> on BuildContext {
  Future<T?> pushNamed(String routeName, {Object? arguments}) async {
    return await Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<T?> pushReplacementNamed(String routeName, {Object? arguments}) async {
    return await Navigator.of(
      this,
    ).pushReplacementNamed(routeName, arguments: arguments);
  }

  void pop() {
    Navigator.of(this).pop();
  }
}
