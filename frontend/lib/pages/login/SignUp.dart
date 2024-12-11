import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genio_card/pages/home/HomePage.dart';
import 'package:genio_card/pages/login/Login.dart';
import 'package:genio_card/pages/login/login_widgets/AuthTextField.dart';
import 'package:genio_card/provider/UserNameProvider.dart';
import 'package:genio_card/theme/ThemeHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signUp(String email, String password, String username, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
        'createdAt': DateTime.now(),
      });

      ref.read(usernameProvider.notifier).state = username;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Get Your Free Account",
              style: TextStyle(color: ThemeHelper.getTextColor(context), fontSize: 30),
            ),
            const SizedBox(height: 30),
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
            AuthTextField(
              label: 'username',
              titleLabel: 'Username',
              keyType: TextInputType.name,
              authController: usernameController,
              obscureText: false,
            ),
            const SizedBox(height: 10),
            AuthTextField(
              label: 'example@gmail.com',
              titleLabel: 'Email Address',
              keyType: TextInputType.emailAddress,
              authController: emailController,
              obscureText: false,
            ),
            const SizedBox(height: 10),
            AuthTextField(
              label: 'password',
              titleLabel: 'Password',
              keyType: TextInputType.name,
              authController: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                final username = usernameController.text.trim();

                if (username.isEmpty || email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("All fields are required.")),
                  );
                  return;
                }

                signUp(email, password, username, context);
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
                    "Sign Up",
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
                  "Already have an account?  ",
                  style: TextStyle(color: ThemeHelper.getSecondaryTextColor(context), fontSize: 15),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Color(0xFFD05972), fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
