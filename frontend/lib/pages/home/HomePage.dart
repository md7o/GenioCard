import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genio_card/components/UpperBar.dart';
import 'package:genio_card/pages/generate_file_widget/GenerateFilePage.dart';
import 'package:genio_card/pages/login/Login.dart';
import 'package:genio_card/pages/login/SignUp.dart';
import 'package:genio_card/pages/questions/Questions_page.dart';
import 'package:genio_card/provider/UserNameProvider.dart';
import 'package:genio_card/provider/questionsDataProvider.dart';
import 'package:genio_card/theme/CustomColors.dart';
import 'package:genio_card/theme/ThemeHelper.dart';
import 'package:genio_card/provider/ThemeProvider.dart';
import 'package:genio_card/utils/PageNavigator.dart';
import 'package:hive/hive.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Future<void> _authCheckFuture;

  @override
  void initState() {
    super.initState();
    _authCheckFuture = _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _fetchUsernameAndNavigate(user.uid);
    }
  }

  Future<void> _fetchUsernameAndNavigate(String uid) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        String username = userDoc['username'];

        ref.read(usernameProvider.notifier).state = username;
      }
    } catch (e) {
      print('Error fetching username: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final questions = ref.watch(questionsProvider);
    final isQuestionsData = questions.isNotEmpty;

    final numQuestions = ref.watch(numQuestionsProvider);
    final language = ref.watch(languageProvider);
    final difficulty = ref.watch(difficultyProvider);

    final username = ref.watch(usernameProvider);

    return FutureBuilder<void>(
      future: _authCheckFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: ThemeHelper.getBackgroundColor(context),
            body: Container(
              color: Colors.black54,
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: ThemeHelper.getTextColor(context),
                  size: 50,
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
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
              child: Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Image.asset(
                            "assets/images/GenioCardLogo.png",
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
                ),
              ),
            ),
            body: isQuestionsData
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuestionsPage(question: {}),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ThemeHelper.getCardColor(context),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Section 1",
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: ThemeHelper.getTextColor(context),
                                      ),
                                    ),
                                    Text(
                                      "Questions: $numQuestions",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: ThemeHelper.getSecondaryTextColor(context),
                                      ),
                                    ),
                                    Text(
                                      "Language: $language",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: ThemeHelper.getSecondaryTextColor(context),
                                      ),
                                    ),
                                    Text(
                                      "Difficulty: $difficulty",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: ThemeHelper.getSecondaryTextColor(context),
                                      ),
                                    ),
                                  ],
                                ),
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: ThemeHelper.getSquareCardColor(context),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                                      child: Text(
                                        "PDF",
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w400,
                                          color: ThemeHelper.getSecondaryTextColor(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : username.isNotEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "All sections will appear here",
                              style: TextStyle(
                                color: ThemeHelper.getSecondaryTextColor(context),
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Text(
                            'Hello, $username',
                            style: TextStyle(
                              color: ThemeHelper.getSecondaryTextColor(context),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "You need to sign up to generate the file",
                              style: TextStyle(
                                color: ThemeHelper.getSecondaryTextColor(context),
                                fontSize: 20,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUp(),
                                  ));
                            },
                            child: const Text(
                              'Sign up now',
                              style: TextStyle(
                                color: Color(0xFFD05972),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
            floatingActionButton: username.isNotEmpty
                ? FloatingActionButton(
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
                  )
                : null,
            floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          );
        }
      },
    );
  }
}
