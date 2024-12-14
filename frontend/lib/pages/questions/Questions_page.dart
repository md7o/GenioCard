import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/flipcard/gesture_flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:genio_card/theme/ThemeHelper.dart';

class QuestionsPage extends StatelessWidget {
  // final List<Map<String, dynamic>> questions;
  List<Map<String, dynamic>> quesAndAnsw;
  List<Map<String, dynamic>> allQuestions;
  QuestionsPage({super.key, required this.quesAndAnsw, required this.allQuestions});

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
      body: ListView.builder(
        itemCount: quesAndAnsw.length,
        itemBuilder: (context, index) {
          var question = quesAndAnsw[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: GestureFlipCard(
              animationDuration: const Duration(milliseconds: 300),
              axis: FlipAxis.horizontal,
              // controller: controller,
              enableController: false,
              frontWidget: Center(
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 100),
                  decoration: BoxDecoration(
                    color: ThemeHelper.getCardColor(context),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Q${index + 1}: ${question['question']}",
                          style: TextStyle(color: ThemeHelper.getTextColor(context), fontSize: 15),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Show Answer",
                          style: TextStyle(color: ThemeHelper.getSecondaryTextColor(context)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              backWidget: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ThemeHelper.getCardColor(context),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "A: ${question['answer']}",
                    style: TextStyle(color: ThemeHelper.getSecondaryTextColor(context)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
