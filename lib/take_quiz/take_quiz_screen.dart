import 'dart:async';
import 'package:flutter/material.dart';
import '../model/question.dart';
import '../model/quiz.dart';
import '../services/isar_service.dart';

class TakeQuizScreen extends StatefulWidget {
  const TakeQuizScreen({super.key, required this.quiz});
  final Quiz quiz;
  @override
  State<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  /// declare a cound variable with initial value
  List<Question> quizList = [];

  @override
  void initState() {
    super.initState();
    _getList();
  }

  Future<void> _getList() async {
    quizList = await db.getQuestions(widget.quiz);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.quiz.title)),
        body: QuizQuestionListView(quiz: widget.quiz));
  }
}

class QuizQuestionListView extends StatelessWidget {
  const QuizQuestionListView({super.key, required this.quiz});
  final Quiz quiz;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FutureBuilder<List<Question>>(
              future: db.getQuestions(quiz),
              builder: (context, snapshot) => PageView(
                scrollDirection: Axis.vertical,
                children: snapshot.hasData
                    ? snapshot.data!.map((question) {
                        return QuizQuestionInstance(question: question);
                      }).toList()
                    : [],
              ))))]);}
}

class QuizQuestionInstance extends StatelessWidget {
  const QuizQuestionInstance({super.key, required this.question});
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
        child: Text(question.question, style: const TextStyle(fontSize: 40)),
      ),
    );
  }
}

void _showAnswerModalSheet(context, question) async {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            Center(
              child:
                  Text(question.answer, style: const TextStyle(fontSize: 40)),
            )]));});
}
