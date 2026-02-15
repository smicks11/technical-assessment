import 'package:flutter/foundation.dart';

class AppLoading extends ChangeNotifier {
  int _count = 0;

  bool get isLoading => _count > 0;

  void show() {
    _count++;
    notifyListeners();
  }

  void hide() {
    if (_count > 0) _count--;
    notifyListeners();
  }
}
