import 'package:flutter/material.dart';

import '../../../theme/ThemeHelper.dart';
import '../../../utils/PageNavigator.dart';
import '../../generate_file_widget/GenerateFilePage.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: null,
      backgroundColor: ThemeHelper.getFloatButtonColor(context),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: PopupMenuButton<int>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        icon: const Icon(
          Icons.add_rounded,
          size: 40,
          color: Colors.white,
        ),
        color: ThemeHelper.getCardColor(context),
        offset: const Offset(65, 5),
        onSelected: (int result) {
          switch (result) {
            case 0:
              pageNavigator(context, const GenerateFilePage());
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
          PopupMenuItem<int>(
            height: 5,
            value: 0,
            child: Row(
              children: [
                Icon(
                  Icons.attach_file,
                  color: ThemeHelper.getTextColor(context),
                ),
                const SizedBox(width: 10),
                Text(
                  'Upload File',
                  style: TextStyle(
                    color: ThemeHelper.getTextColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
