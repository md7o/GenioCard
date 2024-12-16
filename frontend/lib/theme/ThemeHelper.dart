import 'package:flutter/material.dart';
import 'package:genio_card/theme/CustomColors.dart';

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

  static Color getFloatButtonColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? AppColors.lightFloatButtonColor : AppColors.darkFloatButtonColor;
  }

  static Color getAnswerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? AppColors.lightAnswerColor : AppColors.darkAnswerColor;
  }
}
