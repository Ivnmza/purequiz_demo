import 'package:flutter/material.dart';
import 'package:purequiz_demo/model/question.dart';
import 'package:purequiz_demo/model/quiz.dart';
import '/services/isar_service.dart';

class AddQuestionModal extends StatefulWidget {
  final IsarService service;
  final Quiz quiz;
  const AddQuestionModal(this.service, this.quiz, {Key? key}) : super(key: key);
  @override
  State<AddQuestionModal> createState() => _AddQuestionModalState();
}

class _AddQuestionModalState extends State<AddQuestionModal> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _questionFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _questionFormKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Enter Question",
                style: Theme.of(context).textTheme.headlineSmall),
            TextFormField(
              controller: _questionController,
              autofocus: true,
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Answer not allowed to be empty";
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_questionFormKey.currentState!.validate()) {
                    widget.service.saveQuestion(Question()
                      ..question = _questionController.text
                      ..answer = _answerController.text
                      ..quiz.value = widget.quiz);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Add new question"))
          ],
        ),
      ),
    );
  }
}
