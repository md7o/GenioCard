import 'package:flutter/material.dart';
import 'package:genio_card/theme/ThemeHelper.dart';

class QuestionsPage extends StatelessWidget {
  final List<Map<String, String>> questions;

  const QuestionsPage({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Questions",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
              decoration: BoxDecoration(
                color: ThemeHelper.getCardColor(context),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Q: ${questions[index]['question']}",
                      style: TextStyle(color: ThemeHelper.getTextColor(context)),
                    ),
                    Text(
                      "A: ${questions[index]['answer']}",
                      style: TextStyle(color: ThemeHelper.getSecondaryTextColor(context)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
