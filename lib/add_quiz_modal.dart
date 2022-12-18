import 'package:flutter/material.dart';
import 'package:purequiz_demo/model/quiz.dart';
import '/model/module.dart';
import '/services/isar_service.dart';

class AddQuizModal extends StatefulWidget {
  final IsarService service;
  final Module module;
  const AddQuizModal(this.service, this.module, {Key? key}) : super(key: key);

  @override
  State<AddQuizModal> createState() => _AddQuizModalState();
}

class _AddQuizModalState extends State<AddQuizModal> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Enter Quiz",
                style: Theme.of(context).textTheme.headlineSmall),
            TextFormField(
              controller: _textController,
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Quiz title not allowed to be empty";
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    widget.service.saveQuiz(Quiz()
                      ..title = _textController.text
                      ..containingModule.value = widget.module);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "New Quiz '${_textController.text}' saved in DB")));

                    Navigator.pop(context);
                  }
                },
                child: const Text("Add new Quiz"))
          ],
        ),
      ),
    );
  }
}
