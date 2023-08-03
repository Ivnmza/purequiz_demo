import 'package:flutter/material.dart';
import 'package:purequiz_demo/common_widgets/common_widgets.dart';
import 'services/isar_service.dart';
import 'model/module.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({Key? key, required this.module, required this.db})
      : super(key: key);
  final Module module;
  final IsarService db;
  static void navigate(context, Module module, IsarService db) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return QuizListScreen(module: module, db: db);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(module.moduleTitle)),
      bottomNavigationBar: AddQuizButton(module: module),
      body: QuizGridView(module: module)
    );
  }
}
