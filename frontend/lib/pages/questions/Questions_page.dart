import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/gesture_flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:genio_card/theme/ThemeHelper.dart';

class QuestionsPage extends StatelessWidget {
  final List<Map<String, dynamic>> quesAndAnsw;
  final String numQuestions;
  final String language;
  final String difficulty;

  QuestionsPage({
    super.key,
    required this.quesAndAnsw,
    required this.numQuestions,
    required this.difficulty,
    required this.language,
  });

  final controller = FlipCardController();
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
          'Questions',
          style: TextStyle(
            color: ThemeHelper.getSecondaryTextColor(context),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: Text(
              "Questions data",
              style: TextStyle(color: ThemeHelper.getTextColor(context), fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ThemeHelper.getCardColor(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Language: $language",
                      style: TextStyle(color: ThemeHelper.getSecondaryTextColor(context), fontSize: 17),
                    ),
                    Text(
                      "Questions: $numQuestions",
                      style: TextStyle(color: ThemeHelper.getSecondaryTextColor(context), fontSize: 17),
                    ),
                    Text(
                      "Language: $difficulty",
                      style: TextStyle(color: ThemeHelper.getSecondaryTextColor(context), fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: Text(
              "Questions",
              style: TextStyle(color: ThemeHelper.getTextColor(context), fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: quesAndAnsw.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var question = quesAndAnsw[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: GestureFlipCard(
                    animationDuration: const Duration(milliseconds: 300),
                    axis: FlipAxis.vertical,
                    // controller: controller,
                    enableController: true,
                    frontWidget: Center(
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 100),
                        decoration: BoxDecoration(
                          color: ThemeHelper.getCardColor(context),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ThemeHelper.getTextColor(context), width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${index + 1}. ${question['question']}",
                                style: TextStyle(color: ThemeHelper.getTextColor(context), fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Flip card to see the Answer",
                                style: TextStyle(color: ThemeHelper.getSecondaryTextColor(context)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    backWidget: Container(
                      constraints: const BoxConstraints(minHeight: 100),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ThemeHelper.getCardColor(context),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ThemeHelper.getTextColor(context), width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${question['answer']}",
                                style: TextStyle(
                                  color: ThemeHelper.getAnswerColor(context),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Flip card to see the Question",
                                style: TextStyle(
                                  color: ThemeHelper.getSecondaryTextColor(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
