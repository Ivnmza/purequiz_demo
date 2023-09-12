import 'package:flutter/material.dart';
import '../model/module.dart';
import '../model/question.dart';
import '../model/quiz.dart';
import '../services/isar_service.dart';
import 'add_question_modal.dart';

class QuestionListScreen extends StatelessWidget {
  const QuestionListScreen(
      {super.key, required this.quiz, required this.db, required this.module});
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
        body: QuestionListView(quiz: quiz));
  }
}

class QuestionListView extends StatelessWidget {
  const QuestionListView({super.key, required this.quiz});
  final Quiz quiz;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<List<Question>>(
              stream: db.listenToQuestions(quiz),
              builder: (context, snapshot) => ListView(
                children: snapshot.hasData
                    ? snapshot.data!.map((question) {
                        return QuestionInstance(question: question);
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

class QuestionInstance extends StatelessWidget {
  const QuestionInstance({super.key, required this.question});
  final Question question;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        onPressed: () {
          _showAnswerModalSheet(context, question);
        },
        onLongPress: () {
          db.deleteQuestion(question);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(25),
          backgroundColor: const Color.fromARGB(255, 79, 79, 79),
        ),
        child: Text(style: const TextStyle(fontSize: 20), question.question),
      ),
    );
  }
}

void _showAnswerModalSheet(context, question) async {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView(children: [
            Center(
                child: Text(question.answer,style: const TextStyle(fontSize: 20),)),
          ]),
        ),
      );
    },
  );
}

class AddQuestionButton extends StatelessWidget {
  const AddQuestionButton(
      {super.key, required this.quiz, required this.module});
  final Quiz quiz;
  final Module module;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => AddQuestionModal(db, quiz, module));
        },
        child: const Text("Add Question", style: TextStyle(fontSize: 25)),
      ),
    );
  }
}
