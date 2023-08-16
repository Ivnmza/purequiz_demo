import 'package:flutter/material.dart';
import 'add_quiz_modal.dart';
import 'model/quiz.dart';
import 'question_list_screen.dart';
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



class QuizGridView extends StatelessWidget {
  const QuizGridView({super.key, required this.module});
  final Module module;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<List<Quiz>>(
              stream: db.listenToQuizzes(module),
              builder: (context, snapshot) => GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                scrollDirection: Axis.vertical,
                children: snapshot.hasData
                    ? snapshot.data!.map((quiz) {
                        return GoToQuizButton(quiz: quiz, module: module);
                      }).toList()
                    : [],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GoToQuizButton extends StatelessWidget {
  const GoToQuizButton({super.key, required this.quiz, required this.module});
  final Quiz quiz;
  final Module module;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        QuestionListScreen.navigate(context, quiz, module, db);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 89, 80, 253),
        padding: const EdgeInsets.all(5.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      child: Text(quiz.title),
    );
  }
}

class AddQuizButton extends StatelessWidget {
  const AddQuizButton({super.key, required this.module});
  final Module module;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return AddQuizModal(db, module);
            },
          );
        },
        child: const Text(
          "Add Quiz",
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}