import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genio_card/provider/questionsDataProvider.dart';
import 'package:genio_card/theme/ThemeHelper.dart';

class QuestionsPage extends ConsumerStatefulWidget {
  const QuestionsPage({super.key, required question});

  @override
  ConsumerState<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends ConsumerState<QuestionsPage> {
  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(questionsProvider);
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Questions",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: ThemeHelper.getTextColor(context),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
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
