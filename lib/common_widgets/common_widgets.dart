import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';
import '../constants/constants.dart';
import '../main.dart';
import '../model/module.dart';
import '../quiz_list_screen.dart';
import '../services/isar_service.dart';

class ActionTextButton extends StatelessWidget {
  const ActionTextButton({super.key, required this.text, this.onPressed});
  final String text;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
      child: TextButton(
        onPressed: onPressed,
        child: Text(text,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white)),
      ),
    );
  }
}

class TopicButton extends StatelessWidget {
  const TopicButton({super.key, required this.module, required this.db});
  final IsarService db;
  final Module module;
  @override
  Widget build(BuildContext context) {
    logger.d(module.moduleTitle);
    return ElevatedButton(
      onPressed: () => QuizListScreen.navigate(context, module, db),
      style: ElevatedButton.styleFrom(
          backgroundColor: kPurple,
          padding: const EdgeInsets.all(Sizes.p16),
          shape: kTopicShape),
      child: Text(
        module.moduleTitle,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}