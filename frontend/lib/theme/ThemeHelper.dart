import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genio_card/theme/CustomColors.dart'; // Assuming AppColors is imported from here

class ThemeHelper {
  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? AppColors.lightCardColor : AppColors.darkCardColor;
  }

  static Color getSquareCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? AppColors.lightSquareCardColor : AppColors.darkSquareCardColor;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? AppColors.lightTextColor : AppColors.darkTextColor;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? AppColors.lightSecondaryTextColor : AppColors.darkSecondaryTextColor;
  }

  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? AppColors.lightBackgroundColor : AppColors.darkBackgroundColor;
  }
}
