import 'package:flutter/material.dart';
import 'package:purequiz_demo/question_list_screen.dart';

import 'add_quiz_modal.dart';
import 'model/quiz.dart';
import 'services/isar_service.dart';
import 'model/module.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({Key? key, required this.module, required this.service})
      : super(key: key);
  final Module module;
  final IsarService service;
  static void navigate(context, Module module, IsarService service) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return QuizListScreen(module: module, service: service);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(module.moduleTitle)),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return AddQuizModal(service, module);
              });
        },
        child: const Text("Add Quiz"),
      ),
      body: Column(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<List<Quiz>>(
              stream: service.listenToQuizzes(module),
              builder: (context, snapshot) => GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                scrollDirection: Axis.vertical,
                children: snapshot.hasData
                    ? snapshot.data!.map((quiz) {
                        return ElevatedButton(
                          onPressed: () {
                            QuestionListScreen.navigate(
                                context, quiz, module, service);
                            logger.d("Going to Quiz screen: " + quiz.title);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 89, 80, 253),
                            padding: const EdgeInsets.all(5.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: Text(quiz.title),
                        );
                      }).toList()
                    : [],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
