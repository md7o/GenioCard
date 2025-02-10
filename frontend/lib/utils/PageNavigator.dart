import 'package:flutter/material.dart';

void pageNavigator(BuildContext context, Widget newScreen) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => newScreen,
      ));
}
