import 'package:flutter/material.dart';
import 'package:purequiz_demo/common_widgets/common_widgets.dart';
import 'model/module.dart';
import 'model/quiz.dart';
import 'services/isar_service.dart';

class QuestionListScreen extends StatelessWidget {
  const QuestionListScreen(
      {super.key,
      required this.quiz,
      required this.db,
      required this.module});
  //1: needs Quiz
  final Quiz quiz;
  final Module module;
  //2: it needs the service
  final IsarService db;
  //3: create custom nav - customize from module nav
  //4:  created stream service method to listen for questions

  static void navigate(context, Quiz quiz, Module module, IsarService db) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return QuestionListScreen(quiz: quiz, db: db, module: module);
    }));
  }

// 4: create ui
//5: create bottom modal
// 6: create ui body
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(quiz.title)),
      bottomNavigationBar: AddQuestionButton(module: module, quiz: quiz),
      body: QuestionListView(quiz: quiz)
    );
  }
}