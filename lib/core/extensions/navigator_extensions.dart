import 'package:flutter/material.dart';

extension Navigate<T> on BuildContext {
  Future<T?> pushNamed(String routeName, {Object? arguments}) async {
    return await Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  void pop() {
    Navigator.of(this).pop();
  }
}
