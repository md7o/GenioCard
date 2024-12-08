import 'package:flutter/material.dart';
import 'package:genio_card/theme/ThemeHelper.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Creating Questions...',
              style: TextStyle(color: ThemeHelper.getTextColor(context), fontSize: 15),
            ),
            const SizedBox(height: 20 ),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
