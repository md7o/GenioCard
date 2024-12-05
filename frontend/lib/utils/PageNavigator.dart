import 'package:flutter/material.dart';

void PageNavigator(BuildContext context, Widget newScreen) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => newScreen,
      ));
}
