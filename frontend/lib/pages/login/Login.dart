import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genio_card/pages/home/HomePage.dart';
import 'package:genio_card/pages/login/signup.dart';
import 'package:genio_card/pages/login/login_widgets/AuthTextField.dart';
import 'package:genio_card/provider/UserNameProvider.dart';
import 'package:genio_card/theme/ThemeHelper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  Future<void> loginUser(BuildContext context, WidgetRef ref) async {
    setState(() {
      _isLoading = true;
    });

    final String email = usernameController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        String username = userDoc['username'];

        ref.read(usernameProvider.notifier).state = username;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        throw "User data not found!";
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrect Username or Password")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Login",
                  style: TextStyle(color: ThemeHelper.getTextColor(context), fontSize: 30),
                ),
                const SizedBox(height: 30),
                AuthTextField(
                  label: 'Email',
                  titleLabel: 'Email Address',
                  keyType: TextInputType.emailAddress,
                  authController: usernameController,
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                AuthTextField(
                  label: 'Password',
                  titleLabel: 'Password',
                  keyType: TextInputType.text,
                  authController: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    loginUser(context, ref);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFD05972),
                          Color(0xFF8F4555),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account?  ",
                      style: TextStyle(color: ThemeHelper.getSecondaryTextColor(context), fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _isLoading = true; // Show loading indicator
                        });

                        await Future.delayed(const Duration(seconds: 1)); // Simulate a delay

                        setState(() {
                          _isLoading = false; // Hide loading indicator
                        });

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUp()),
                        );
                      },
                      child: const Text(
                        "Sign Up now",
                        style: TextStyle(color: Color(0xFFD05972), fontSize: 16),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: ThemeHelper.getSecondaryTextColor(context), width: 1),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "OR",
                        style: TextStyle(fontSize: 15, color: ThemeHelper.getSecondaryTextColor(context)),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: ThemeHelper.getSecondaryTextColor(context), width: 1),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/goolge-icon.png",
                          height: 20,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Continue with Google",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: ThemeHelper.getTextColor(context),
                  size: 50,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
