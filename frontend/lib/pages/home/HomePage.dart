import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genio_card/components/UpperBar.dart';
import 'package:genio_card/theme/CustomColors.dart';
import 'package:genio_card/theme/ThemeHelper.dart';
import 'package:genio_card/provider/ThemeProvider.dart';

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
      drawer: Expanded(
        child: Drawer(
          backgroundColor: ThemeHelper.getBackgroundColor(context),
          child: ListView(
            children: <Widget>[
              const Text(
                "LOGO",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
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
                  // Handle navigation to Home
                  Navigator.pop(context);
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
        onPressed: () {},
        backgroundColor: ThemeHelper.getCardColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.add_rounded,
          size: 40,
          color: Theme.of(context).brightness == Brightness.dark ? AppColors.lightSecondaryTextColor : AppColors.darkTextColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
