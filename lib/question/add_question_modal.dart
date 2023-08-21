import 'package:flutter/material.dart';
import 'package:purequiz_demo/model/question.dart';
import 'package:purequiz_demo/model/quiz.dart';
import '/services/isar_service.dart';
import '../model/module.dart';

class AddQuestionModal extends StatefulWidget {
  final IsarService service;
  final Quiz quiz;
  final Module module;
  const AddQuestionModal(this.service, this.quiz, this.module, {Key? key})
      : super(key: key);
  @override
  State<AddQuestionModal> createState() => _AddQuestionModalState();
}

class _AddQuestionModalState extends State<AddQuestionModal> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _questionFormKey = GlobalKey<FormState>();

  void _enterQuestion() {
    if (_questionFormKey.currentState!.validate()) {
      widget.service.saveQuestion(Question()
        ..question = _questionController.text
        ..answer = _answerController.text
        ..quiz.value = widget.quiz
        ..quizString = widget.quiz.title
        ..moduleString = widget.module.moduleTitle
        ..module.value = widget.module);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Padding(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _questionFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 15),
              Text("Question: ",
                  style: Theme.of(context).textTheme.headlineSmall),
              TextFormField(
                controller: _questionController,
                autofocus: true,
                onFieldSubmitted: (value) => _enterQuestion(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Question not allowed to be empty";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              const Text('Answer'),
              TextFormField(
                controller: _answerController,
                onFieldSubmitted: (value) => _enterQuestion(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Answer not allowed to be empty";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    _enterQuestion();
                  },
                  child: const Text("Add new question"))
            ],
          ),
        ),
      )
    ]);
  }
}
