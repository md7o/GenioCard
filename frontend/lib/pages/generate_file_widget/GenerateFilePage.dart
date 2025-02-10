import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genio_card/pages/home/HomePage.dart';
import 'package:genio_card/provider/questionsDataProvider.dart';
import 'package:genio_card/theme/RightCheck.dart';
import 'package:genio_card/theme/ThemeHelper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'generate_file_widgets/OptionForm.dart';

class GenerateFilePage extends ConsumerStatefulWidget {
  const GenerateFilePage({super.key});

  @override
  ConsumerState<GenerateFilePage> createState() => _GenerateFilePageState();
}

class _GenerateFilePageState extends ConsumerState<GenerateFilePage> {
  String? filePath;
  bool isLoading = false;
  bool loadingDone = false;

  TextEditingController sectionTitleController = TextEditingController();

  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        filePath = result.files.single.path;
      });
    }
  }

  Future<void> createQuestions(BuildContext context) async {
    if (filePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a PDF file first.")),
      );
      return;
    }

    // Start loading
    if (mounted) {
      setState(() {
        isLoading = true;
        loadingDone = false;
      });
    }

    try {
      // Prepare request data
      String sectionTitleValue = sectionTitleController.text;
      String numQuestions = ref.read(numQuestionsProvider);
      String language = ref.read(languageProvider);
      String difficulty = ref.read(difficultyProvider);
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not logged in.");
      }

      String userId = user.uid;
      File file = File(filePath!);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://10.0.2.2:3000/pdf/upload"),
      );
      request.fields.addAll({
        'sectionTitle': sectionTitleValue,
        'numQuestions': numQuestions,
        'language': language,
        'difficulty': difficulty,
        'userId': userId,
      });
      request.files.add(await http.MultipartFile.fromPath('pdfFile', file.path));

      print("Sending request with file: ${file.path}");

      // Send request
      var response = await request.send();

      // Check response status
      if (response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData) as Map<String, dynamic>;

        // Debugging the response
        print('Response data: $jsonResponse');

        List<Map<String, String>> fetchedQuestions = List<Map<String, String>>.from(
          jsonResponse['questions'].map((questionData) {
            return {
              'question': questionData['question'] as String,
              'answer': questionData['answer'] as String,
            };
          }),
        );

        ref.read(questionsProvider.notifier).state = fetchedQuestions;

        if (mounted) {
          setState(() {
            loadingDone = true;
          });
        }
      } else {
        var responseBody = await response.stream.bytesToString();
        print('Failed request body: $responseBody');
        throw Exception("Failed to generate questions. Server error: ${response.statusCode}");
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating questions: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      await Future.delayed(const Duration(seconds: 2));
      if (mounted && loadingDone) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: isLoading || loadingDone ? Colors.black54 : Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: ThemeHelper.getTextColor(context),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'File Generator',
          style: TextStyle(
            color: ThemeHelper.getTextColor(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Center(
                  child: GestureDetector(
                    onTap: pickPdf,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: ThemeHelper.getCardColor(context),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
                        child: Text(
                          "PDF",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: filePath != null ? FontWeight.w600 : FontWeight.w400,
                            color: filePath != null ? Colors.green.shade400 : ThemeHelper.getSecondaryTextColor(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: pickPdf,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFD05972),
                          Color(0xFF8F4555),
                        ],
                      ),
                    ),
                    child: const Text(
                      "Attach File",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    filePath != null ? "Selected File: ${filePath!.split('/').last}" : "No File Selected",
                    style: TextStyle(color: ThemeHelper.getSecondaryTextColor(context), fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 20),

                // ============ Form Area ===============
                OptionForm(
                  sectionTitleController: sectionTitleController,
                  ref: ref,
                ),

                GestureDetector(
                  onTap: () async {
                    await createQuestions(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                          "Create Questions",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading || loadingDone)
            Container(
              color: Colors.black54,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: isLoading
                        ? LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.white, // Red when loading, green when done
                            size: 50,
                          )
                        : const AnimatedCheck(),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    isLoading ? "Generating" : "Generating complete",
                    style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
