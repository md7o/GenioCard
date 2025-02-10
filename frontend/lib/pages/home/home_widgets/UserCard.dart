import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../theme/ThemeHelper.dart';
import '../../questions/Questions_page.dart';

class UserCard extends StatefulWidget {
  final List<Map<String, dynamic>> userList;
  final List<Map<String, dynamic>> deleteCard;

  const UserCard({super.key, required this.userList, required this.deleteCard});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.userList.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          var questsData = widget.userList[index];

          return GestureDetector(
            onTap: () {
              print("Questions to Pass: ${questsData['questions']}");

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return QuestionsPage(
                      quesAndAnsw: questsData['questions'],
                      numQuestions: questsData['numQuestions'],
                      language: questsData['language'],
                      difficulty: questsData['difficulty'],
                    );
                  },
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: ThemeHelper.getCardColor(context),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${questsData["sectionTitle"]}",
                            style: TextStyle(
                              fontSize: 20,
                              color: ThemeHelper.getTextColor(context),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Questions: ${questsData["numQuestions"]}",
                            style: TextStyle(
                              fontSize: 18,
                              color: ThemeHelper.getSecondaryTextColor(context),
                            ),
                          ),
                          Text(
                            "Language: ${questsData["language"]}",
                            style: TextStyle(
                              fontSize: 18,
                              color: ThemeHelper.getSecondaryTextColor(context),
                            ),
                          ),
                          Text(
                            "Difficulty: ${questsData["difficulty"]}",
                            style: TextStyle(
                              fontSize: 18,
                              color: ThemeHelper.getSecondaryTextColor(context),
                            ),
                          ),
                          Text(
                            "date: ${questsData["createdAt"]}",
                            style: TextStyle(
                              fontSize: 18,
                              color: ThemeHelper.getSecondaryTextColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ThemeHelper.getSquareCardColor(context),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            try {
                              String docId = questsData['docId'];
                              await FirebaseFirestore.instance.collection('questions').doc(docId).delete();

                              setState(() {
                                widget.deleteCard.removeAt(index);
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Section deleted successfully")),
                              );
                            } catch (e) {
                              print("Error deleting document: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Failed to delete section")),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: ThemeHelper.getSquareCardColor(context),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: ThemeHelper.getSecondaryTextColor(context),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
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
