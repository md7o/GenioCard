import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genio_card/components/UpperBar.dart';
import 'package:genio_card/pages/generate_file_widget/GenerateFilePage.dart';
import 'package:genio_card/theme/CustomColors.dart';
import 'package:genio_card/theme/ThemeHelper.dart';
import 'package:genio_card/provider/ThemeProvider.dart';
import 'package:genio_card/utils/PageNavigator.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: const [
          Header(),
        ],
      ),
      drawer: Drawer(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        child: ListView(
          children: <Widget>[
            Image.asset(
              "assets/images/GenioCardLogo.png",
              height: 50,
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(
                Icons.attach_file,
                color: ThemeHelper.getTextColor(context),
              ),
              title: Text(
                'Upload File',
                style: TextStyle(
                  color: ThemeHelper.getTextColor(context),
                ),
              ),
              onTap: () {
                PageNavigator(context, const GenerateFilePage());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.dark_mode_outlined,
                color: ThemeHelper.getTextColor(context),
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                  color: ThemeHelper.getTextColor(context),
                ),
              ),
              onTap: () {
                // Handle navigation to Settings
                Navigator.pop(context);
              },
              trailing: Switch(
                value: isDarkMode,
                onChanged: (bool value) {
                  setState(
                    () {
                      ref.read(themeProvider.notifier).state = value;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "All section will appear here",
              style: TextStyle(
                color: ThemeHelper.getSecondaryTextColor(context),
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: null, // Disable default action
        backgroundColor: ThemeHelper.getCardColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: PopupMenuButton<int>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          icon: Icon(
            Icons.add_rounded,
            size: 40,
            color: Theme.of(context).brightness == Brightness.dark ? AppColors.lightSecondaryTextColor : AppColors.darkTextColor,
          ),
          color: ThemeHelper.getCardColor(context),
          offset: const Offset(65, 5), // Adjust vertical offset to appear above
          onSelected: (int result) {
            switch (result) {
              case 0:
                PageNavigator(context, const GenerateFilePage());
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
