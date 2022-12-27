import 'package:flutter/material.dart';

import 'add_question_modal.dart';
import 'model/question.dart';
import 'model/quiz.dart';
import 'services/isar_service.dart';

class QuestionListScreen extends StatelessWidget {
  const QuestionListScreen(
      {super.key, required this.quiz, required this.service});
  //1: needs Quiz
  final Quiz quiz;
  //2: it needs the service
  final IsarService service;
  //3: create custom nav - customize from module nav
  //4:  created stream service method to listen for questions

  static void navigate(context, Quiz quiz, IsarService service) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return QuestionListScreen(quiz: quiz, service: service);
    }));
  }

// 4: create ui
//5: create bottom modal
// 6: create ui body
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(quiz.title)),
        bottomNavigationBar: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) => AddQuestionModal(service, quiz));
          },
          child: const Text("Add Question"),
        ),
        body: Column(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<List<Question>>(
                stream: service.listenToQuestions(quiz),
                builder: (context, snapshot) => ListView(
                  children: snapshot.hasData
                      ? snapshot.data!.map((question) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ElevatedButton(
                              onPressed: () {
                                print("Showing questions screen");
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 200,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(question.answer),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                                print(question.answer);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(25),
                              
                                backgroundColor: Color.fromARGB(255, 79, 79, 79),
                              ),
                              child: Text(question.question),
                            ),
                          );
                        }).toList()
                      : [],
                ),
              ),
            ),
          ),
        ]));
  }
}
