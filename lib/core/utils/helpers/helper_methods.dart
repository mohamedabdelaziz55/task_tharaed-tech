import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

void navigateTo(Widget page, {bool canPop = true, int? delayInSeconds}) {
  void action() {
    if (canPop) {
      navKey.currentState?.push(
        MaterialPageRoute(builder: (context) => page),
      );
    } else {
      navKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => page),
            (route) => false,
      );
    }
  }

  if (delayInSeconds != null) {
    Future.delayed(Duration(seconds: delayInSeconds), action);
  } else {
    action();
  }
}
