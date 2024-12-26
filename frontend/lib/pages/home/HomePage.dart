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
import 'package:genio_card/theme/ThemeHelper.dart';
import 'package:genio_card/provider/ThemeProvider.dart';
import 'package:genio_card/utils/PageNavigator.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<Map<String, dynamic>> quesAndAnsw = [];
  List<Map<String, dynamic>> language = [];
  List<Map<String, dynamic>> numQuestions = [];
  List<Map<String, dynamic>> difficulty = [];
  List<Map<String, dynamic>> allQuestions = [];

  late Future<void> _authCheckFuture;

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

  Future<void> fetchQuestions(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('questions').where('userId', isEqualTo: userId).get();

      List<Map<String, dynamic>> fetchedSections = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('section') &&
            data['section'] is Map<String, dynamic> &&
            (data['section'] as Map<String, dynamic>).containsKey('quest') &&
            data['section']['quest'] is List) {
          List<dynamic> questionList = data['section']['quest'];
          Timestamp? createdAtTimestamp = data['createdAt'] as Timestamp?;

          fetchedSections.add({
            'docId': doc.id,
            'sectionTitle': data['sectionTitle'] ?? 'Unknown',
            'numQuestions': data['numQuestions'] ?? 'Unknown',
            'language': data['language'] ?? 'Unknown',
            'difficulty': data['difficulty'] ?? 'Unknown',
            'createdAt': createdAtTimestamp != null ? DateFormat('dd/MM/yy').format(createdAtTimestamp.toDate()) : 'Unknown',
            'questions': questionList.map<Map<String, String>>((q) {
              return {
                'question': q['question']?.toString() ?? '',
                'answer': q['answer']?.toString() ?? '',
              };
            }).toList(),
          });
        }
      }

      setState(() {
        quesAndAnsw = fetchedSections;
        numQuestions = fetchedSections;
        language = fetchedSections;
        difficulty = fetchedSections;
        allQuestions = fetchedSections;
      });
    } catch (e) {
      print("Error fetching sections: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _authCheckFuture = _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _fetchUsernameAndNavigate(user.uid);
      await fetchQuestions(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final username = ref.watch(usernameProvider);

    return FutureBuilder<void>(
      future: _authCheckFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: ThemeHelper.getBackgroundColor(context),
            body: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: ThemeHelper.getTextColor(context),
                size: 50,
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
            body: allQuestions.isNotEmpty
                ? Column(
                    children: [
                      const SizedBox(height: 15),
                      Expanded(
                        child: ListView.builder(
                          itemCount: allQuestions.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var questsData = allQuestions[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return QuestionsPage(
                                        quesAndAnsw: questsData['questions'],
                                        numQuestions: questsData['numQuestions'],
                                        language: questsData['language'],
                                        difficulty: questsData['difficulty'],
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: ThemeHelper.getCardColor(context),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${questsData["sectionTitle"]}",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: ThemeHelper.getTextColor(context),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Questions: ${questsData["numQuestions"]}",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: ThemeHelper.getSecondaryTextColor(context),
                                              ),
                                            ),
                                            Text(
                                              "Language: ${questsData["language"]}",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: ThemeHelper.getSecondaryTextColor(context),
                                              ),
                                            ),
                                            Text(
                                              "Difficulty: ${questsData["difficulty"]}",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: ThemeHelper.getSecondaryTextColor(context),
                                              ),
                                            ),
                                            Text(
                                              "date: ${questsData["createdAt"]}",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: ThemeHelper.getSecondaryTextColor(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: ThemeHelper.getSquareCardColor(context),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
                                          const SizedBox(height: 10),
                                          GestureDetector(
                                            onTap: () async {
                                              try {
                                                String docId = questsData['docId'];
                                                await FirebaseFirestore.instance.collection('questions').doc(docId).delete();

                                                setState(() {
                                                  allQuestions.removeAt(index);
                                                });

                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text("Section deleted successfully")),
                                                );
                                              } catch (e) {
                                                print("Error deleting document: $e");
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text("Failed to delete section")),
                                                );
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: ThemeHelper.getSquareCardColor(context),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: ThemeHelper.getSecondaryTextColor(context),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                "You need to sign up to generate the file",
                                style: TextStyle(
                                  color: ThemeHelper.getSecondaryTextColor(context),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
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
