import 'package:flutter/material.dart';
import 'package:genio_card/components/UpperBar.dart';
import 'package:genio_card/theme/CustomColors.dart';
import 'package:genio_card/theme/ThemeHelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

bool _isSwitched = false; // Initially, the switch is off

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
                  value: _isSwitched,
                  onChanged: (bool value) {
                    setState(
                      () {
                        _isSwitched = value; // Update the switch state
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
