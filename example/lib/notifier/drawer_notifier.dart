import 'package:flutter/material.dart';
import 'package:flutter_drawer_plus/flutter_drawer_plus.dart';

class DrawerNotifier extends ChangeNotifier {
  double swipeOffset = 0;
  bool onTapToClose = false;
  bool swipe = true;
  bool tapScaffold = true;
  DrawerPlusAnimation animationType = DrawerPlusAnimation.static;
  double offset = 0.4;
  Color colorTransition = Colors.black54;

  DrawerPlusDirection direction = DrawerPlusDirection.start;

  void setSwipeOffset(double value) {
    swipeOffset = value;
    notifyListeners();
  }

  void setSwipe(bool s) {
    swipe = s;
    notifyListeners();
  }

  void setTapScaffold(bool t) {
    tapScaffold = t;
    notifyListeners();
  }

  void setOnTapToClose(bool c) {
    onTapToClose = c;
    notifyListeners();
  }

  void setAnimationType(DrawerPlusAnimation t) {
    animationType = t;
    notifyListeners();
  }

  void setOffset(double o) {
    offset = o;
    notifyListeners();
  }

  void setDirection(DrawerPlusDirection d) {
    direction = d;
    notifyListeners();
  }

  void setColorTransition(Color c) {
    colorTransition = c;
    notifyListeners();
  }
}
