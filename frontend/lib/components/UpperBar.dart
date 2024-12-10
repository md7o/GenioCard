import 'package:flutter/material.dart';
import 'package:genio_card/theme/ThemeHelper.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: ThemeHelper.getTextColor(context),
              size: 30,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12, left: 8),
              child: TextField(
                style: TextStyle(
                  color: ThemeHelper.getTextColor(context),
                ),
                decoration: InputDecoration(
                  hintText: 'Search your section',
                  hintStyle: TextStyle(
                    color: ThemeHelper.getSecondaryTextColor(context),
                  ),
                  filled: true,
                  fillColor: ThemeHelper.getCardColor(context),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
                ),
                onChanged: (value) {
                  print(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
