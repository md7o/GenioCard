import 'package:flutter/material.dart';
import 'package:genio_card/components/UpperBar.dart';
import 'package:genio_card/theme/CustomColors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.lightBackgroundColor : AppColors.darkBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: const [
          Header(),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "All section will appear here",
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.lightSecondaryTextColor : AppColors.darkSecondaryTextColor,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.lightCardColor : AppColors.darkCardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.add_rounded,
          size: 40,
          color: Theme.of(context).brightness == Brightness.dark ? AppColors.lightSecondaryTextColor : AppColors.darkTextColor,
        ),
      ),
    );
  }
}
