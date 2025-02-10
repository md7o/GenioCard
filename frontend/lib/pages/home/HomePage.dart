import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genio_card/components/UpperBar.dart';
import 'package:genio_card/pages/home/home_widgets/SideBar.dart';
import 'package:genio_card/pages/home/home_widgets/UserCard.dart';
import 'package:genio_card/pages/login/SignUp.dart';
import 'package:genio_card/provider/UserNameProvider.dart';
import 'package:genio_card/theme/ThemeHelper.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'home_widgets/FloatingButton.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<Map<String, dynamic>> allQuestions = [];
  List<Map<String, dynamic>> filteredQuestions = [];
  late Future<void> _authCheckFuture;

  @override
  void initState() {
    super.initState();
    _authCheckFuture = _initializeAppData();
  }

  Future<void> _initializeAppData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _fetchUserData(user);
      await _fetchQuestions(user.uid);
    }
  }

  Future<void> _fetchUserData(User user) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        ref.read(usernameProvider.notifier).state = userDoc['username'] ?? 'User';
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Consider adding error handling UI here
    }
  }

  Future<void> _fetchQuestions(String userId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('questions').where('userId', isEqualTo: userId).get();

      final fetchedSections = querySnapshot.docs.map((doc) {
        final data = doc.data();
        // final section = data['section'] as Map<String, dynamic>? ?? {};
        final questions = (data['quest'] as List<dynamic>? ?? []).map((q) {
          return {
            'question': q['question']?.toString() ?? '',
            'answer': q['answer']?.toString() ?? '',
          };
        }).toList();

        final createdAt = (data['createdAt'] as Timestamp?)?.toDate();

        return {
          'docId': doc.id,
          'sectionTitle': data['sectionTitle'] ?? 'Untitled',
          'numQuestions': data['numQuestions'] ?? 'N/A',
          'language': data['language'] ?? 'Unknown',
          'difficulty': data['difficulty'] ?? 'Medium',
          'createdAt': createdAt != null ? DateFormat('dd/MM/yy').format(createdAt) : 'Unknown',
          'questions': questions,
        };
      }).toList();

      setState(() {
        allQuestions = fetchedSections;
        filteredQuestions = fetchedSections;
      });
    } catch (e) {
      print('Error fetching questions: $e');
      // Consider showing error to user
    }
  }

  void handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredQuestions = allQuestions; // Show all questions if query is empty
      } else {
        filteredQuestions = allQuestions.where((question) {
          return question["sectionTitle"].toLowerCase().contains(query.toLowerCase()); // Filter based on sectionTitle
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              actions: [
                Header(
                  onSearch: handleSearch,
                ),
              ],
            ),
            drawer: Drawer(
              backgroundColor: ThemeHelper.getBackgroundColor(context),
              child: const Padding(padding: EdgeInsets.only(top: 49, bottom: 20), child: SideBar()),
            ),
            body: allQuestions.isNotEmpty
                ? Column(
                    children: [
                      const SizedBox(height: 15),
                      UserCard(
                        userList: filteredQuestions,
                        deleteCard: allQuestions,
                      )
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
            floatingActionButton: username.isNotEmpty ? const FloatingButton() : null,
            floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          );
        }
      },
    );
  }
}
