import 'package:flutter/material.dart';
import 'package:genio_card/theme/ThemeHelper.dart';

class QuestionsPage extends StatelessWidget {
  final List<Map<String, dynamic>> questions; // List of questions, adjust type as needed

  const QuestionsPage({super.key, required this.questions});

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
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          var question = questions[index]; // Get each question

          return Container(
            decoration: BoxDecoration(
              color: ThemeHelper.getCardColor(context),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Q: ${question['question']}",
                    style: TextStyle(color: ThemeHelper.getTextColor(context)),
                  ),
                  Text(
                    "A: ${question['answer']}",
                    style: TextStyle(color: ThemeHelper.getSecondaryTextColor(context)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
