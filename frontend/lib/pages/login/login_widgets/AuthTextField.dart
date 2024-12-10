import 'package:flutter/material.dart';
import 'package:genio_card/theme/ThemeHelper.dart';

class AuthTextField extends StatelessWidget {
  final String titleLabel;
  final String label;
  final TextInputType? keyType;
  final TextEditingController? authController;
  final bool obscureText;
  const AuthTextField({
    super.key,
    required this.label,
    required this.titleLabel,
    required this.keyType,
    this.authController,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleLabel,
          style: TextStyle(
            fontSize: 15,
            color: ThemeHelper.getSecondaryTextColor(context),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: authController,
          keyboardType: keyType,
          obscureText: obscureText,
          style: TextStyle(
            color: ThemeHelper.getTextColor(context),
          ),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(color: ThemeHelper.getSecondaryTextColor(context)),
            labelStyle: TextStyle(
              color: ThemeHelper.getSecondaryTextColor(context),
            ),
            filled: true,
            fillColor: ThemeHelper.getCardColor(context),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
