import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/form/CustomDropdown.dart';
import '../../../provider/questionsDataProvider.dart';
import '../../../theme/ThemeHelper.dart';

class OptionForm extends StatelessWidget {
  final TextEditingController sectionTitleController;
  final WidgetRef ref;

  const OptionForm({
    super.key,
    required this.sectionTitleController,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: TextField(
            controller: sectionTitleController,
            style: TextStyle(
              color: ThemeHelper.getTextColor(context),
            ),
            decoration: InputDecoration(
              hintText: 'Section Title',
              hintStyle: TextStyle(
                color: ThemeHelper.getSecondaryTextColor(context),
              ),
              filled: true,
              fillColor: ThemeHelper.getCardColor(context),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
          ),
        ),
        CustomDropdown<String>(
          label: 'Select Number of Questions',
          items: List.generate(
            15,
            (index) => DropdownMenuItem(
              value: (index + 1).toString(),
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
    );
  }
}
