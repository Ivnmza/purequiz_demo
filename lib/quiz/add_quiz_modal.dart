import 'package:flutter/material.dart';
import 'package:purequiz_demo/model/quiz.dart';
import '../model/module.dart';
import '/services/isar_service.dart';

class AddQuizModal extends StatefulWidget {
  final IsarService db;
  final Module module;
  const AddQuizModal(this.db, this.module, {Key? key}) : super(key: key);

  @override
  State<AddQuizModal> createState() => _AddQuizModalState();
}

class _AddQuizModalState extends State<AddQuizModal> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  void _enterQuiz() {
    if (_formKey.currentState!.validate()) {
      widget.db.saveQuiz(Quiz()
        ..title = _textController.text.trim()
        ..containingModule.value = widget.module
        ..containingModuleString = widget.module.moduleTitle);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("New Quiz '${_textController.text}' saved in DB")));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 15),
                Text("Enter Quiz:",
                    style: Theme.of(context).textTheme.headlineSmall),
                TextFormField(
                  controller: _textController,
                  autofocus: true,
                  onFieldSubmitted: (value) {
                    _enterQuiz();
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty || value.isEmpty) {
                      return "Quiz title not allowed to be empty";
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      _enterQuiz();
                    },
                    child: const Text("Add new Quiz"))
              ],
            ),
          ),
        )
      ],
    );
  }
}


