import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../provider/ThemeProvider.dart';
import '../../../provider/UserNameProvider.dart';
import '../../../theme/ThemeHelper.dart';
import '../../../utils/PageNavigator.dart';
import '../../generate_file_widget/GenerateFilePage.dart';
import '../../login/Login.dart';
import '../../login/SignUp.dart';

class SideBar extends ConsumerStatefulWidget {
  const SideBar({super.key});

  @override
  ConsumerState<SideBar> createState() => _SideBarState();
}

class _SideBarState extends ConsumerState<SideBar> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final username = ref.watch(usernameProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Top section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Image.asset(
                "assets/images/GenioCardLogoV2.png",
                height: 50,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
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
                    pageNavigator(context, const GenerateFilePage());
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
                    Navigator.pop(context);
                  },
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (bool value) {
                      setState(
                        () {
                          ref.read(themeProvider.notifier).state = value;
                          Hive.box('localBox').put('isDarkMode', value);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        // Bottom section
        username.isEmpty
            ? ListTile(
                leading: Icon(
                  Icons.person_outline,
                  color: ThemeHelper.getTextColor(context),
                ),
                title: Text(
                  'Sign up now',
                  style: TextStyle(
                    color: ThemeHelper.getTextColor(context),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ),
                  );
                },
              )
            : ListTile(
                leading: Icon(
                  Icons.person_outline,
                  color: ThemeHelper.getTextColor(context),
                ),
                title: Text(
                  'Sign Out',
                  style: TextStyle(
                    color: ThemeHelper.getTextColor(context),
                  ),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
              )
      ],
    );
  }
}
