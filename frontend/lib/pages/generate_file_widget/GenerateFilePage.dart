import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genio_card/pages/generate_file_widget/generate_file_widgets/CustomDropdown.dart';
import 'package:genio_card/pages/home/HomePage.dart';
import 'package:genio_card/pages/questions/Questions_page.dart';
import 'package:genio_card/provider/questionsDataProvider.dart';
import 'package:genio_card/theme/ThemeHelper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GenerateFilePage extends ConsumerStatefulWidget {
  const GenerateFilePage({super.key});

  @override
  ConsumerState<GenerateFilePage> createState() => _GenerateFilePageState();
}

class _GenerateFilePageState extends ConsumerState<GenerateFilePage> {
  String? filePath;
  bool isLoading = false;

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

    setState(() {
      isLoading = true;
    });

    String numQuestions = ref.read(numQuestionsProvider);
    String language = ref.read(languageProvider);
    String difficulty = ref.read(difficultyProvider);
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in.")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    String userId = user.uid; // Get the user ID

    File file = File(filePath!);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:3000/upload-pdf'),
    );

    request.fields['numQuestions'] = numQuestions;
    request.fields['language'] = language;
    request.fields['difficulty'] = difficulty;
    request.fields['userId'] = userId; // Include userId in the request

    request.files.add(await http.MultipartFile.fromPath('pdfFile', file.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData) as Map<String, dynamic>;

        try {
          List<Map<String, String>> fetchedQuestions = List<Map<String, String>>.from(
            jsonResponse['questions'].map((questionData) {
              return {
                'question': questionData['question'] as String,
                'answer': questionData['answer'] as String,
              };
            }),
          );

          ref.read(questionsProvider.notifier).state = fetchedQuestions;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } catch (e) {
          print("Error during casting or updating state: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error processing questions: $e")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to generate questions. Server error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("Error during request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating questions: $e")),
      );
    } finally {
      setState(() {
        isLoading = false; // Set loading to false when the process is complete
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
            color: ThemeHelper.getSecondaryTextColor(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Center(
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
                      fontWeight: FontWeight.w400,
                      color: ThemeHelper.getSecondaryTextColor(context),
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
            Text(
              filePath != null ? "Selected File: ${filePath!.split('/').last}" : "No File Selected",
              style: TextStyle(color: ThemeHelper.getSecondaryTextColor(context), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Options",
                    style: TextStyle(
                      fontSize: 25,
                      color: ThemeHelper.getTextColor(context),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                //   child: TextField(
                //     controller: numQuestionsController,
                //     style: TextStyle(
                //       color: ThemeHelper.getTextColor(context),
                //     ),
                //     decoration: InputDecoration(
                //       labelText: 'Number',
                //       labelStyle: TextStyle(
                //         color: ThemeHelper.getSecondaryTextColor(context),
                //       ),
                //       filled: true,
                //       fillColor: ThemeHelper.getCardColor(context),
                //       contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                //     ),
                //   ),
                // ),
                CustomDropdown<String>(
                  label: 'Select Number of Questions',
                  items: List.generate(
                    15,
                    (index) => DropdownMenuItem(
                      value: (index + 1).toString(), // Values from 1 to 15
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  initialValue: ref.watch(numQuestionsProvider),
                  onChanged: (value) {
                    ref.read(numQuestionsProvider.notifier).state = value!;
                  },
                ),
                CustomDropdown<String>(
                  label: 'Language',
                  items: const [
                    DropdownMenuItem(
                      value: 'English',
                      child: Text('English', style: TextStyle(color: Colors.white)),
                    ),
                    DropdownMenuItem(
                      value: 'Arabic',
                      child: Text('Arabic', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                  initialValue: ref.watch(languageProvider),
                  onChanged: (value) {
                    ref.read(languageProvider.notifier).state = value!;
                  },
                ),
                CustomDropdown<String>(
                  label: 'Questions Difficulty',
                  items: const [
                    DropdownMenuItem(
                      value: 'Simple',
                      child: Text('Simple', style: TextStyle(color: Colors.white)),
                    ),
                    DropdownMenuItem(
                      value: 'Normal',
                      child: Text('Normal', style: TextStyle(color: Colors.white)),
                    ),
                    DropdownMenuItem(
                      value: 'Complicated',
                      child: Text('Complicated', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                  initialValue: ref.watch(difficultyProvider),
                  onChanged: (value) {
                    ref.read(difficultyProvider.notifier).state = value!;
                  },
                ),
              ],
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            GestureDetector(
              onTap: () async {
                await createQuestions(context);
                const CircularNotchedRectangle();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
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
    );
  }
}
