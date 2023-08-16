import 'dart:io';

import 'package:flutter/material.dart';

import '../add_question_modal.dart';
import '../main.dart';
import '../model/module.dart';
import '../model/question.dart';
import '../model/quiz.dart';
import '../services/isar_service.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';



//////////////////////////////////////
////////////////////////////////

//////
///////
/////////////////

class QuestionInstance extends StatelessWidget {
  const QuestionInstance({super.key, required this.question});
  final Question question;
  @override
  Widget build(BuildContext context) {
    return ShowAnswerButton(context: context, question: question);
  }
}

class ShowAnswerButton extends StatelessWidget {
  const ShowAnswerButton(
      {super.key, required this.context, required this.question});
  final BuildContext context;
  final Question question;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        onPressed: () {
          _showAnswerModalSheet(context, question);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(25),
          backgroundColor: const Color.fromARGB(255, 79, 79, 79),
        ),
        child: Text(question.question),
      ),
    );
  }
}

void _showAnswerModalSheet(context, question) async {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return ShowAnswerModal(question: question);
    },
  );
}

class ShowAnswerModal extends StatelessWidget {
  const ShowAnswerModal({super.key, required this.question});
  final Question question;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(question.answer),
          ],
        ),
      ),
    );
  }
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

///////////////////////////////
///////////////////////////////
////////////////////////////

class ExportJsonFileButton extends StatelessWidget {
  const ExportJsonFileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () async {
        await db
            .exportAllToJSON()
            .then((value) => logger.d("MODULES JSON: $value"));
        await db
            .exportAllQuizlToJSON()
            .then((value) => logger.d("QUIZS JSON: $value"));
        await db
            .exportAllQuestionsToJSON()
            .then((value) => logger.d("QUESTIONS JSON: $value"));
        db.exportAllQuestionsToJSONFile();
        //db.exportAllModulesToJsonFile();
      },
    );
  }
}

class PickDocument extends StatefulWidget {
  const PickDocument({super.key});

  @override
  State<PickDocument> createState() => _PickDocumentState();
}

class _PickDocumentState extends State<PickDocument> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.dock),
      onPressed: () async {
        // importJson.1 create a isar DB from this JSON
        final File myFile;
        final String? path = await FlutterDocumentPicker.openDocument();
        if (path != null) {
          myFile = File(path);
          logger.d("Path picked: $path");
          // importJson.2  insert the contents into a method that will process the JSON
          if (context.mounted) {
            _showFileImportModalSheet(context, myFile);
          }
        } else {
          logger.d("No file picked");
        }
      },
    );
  }
}

void _showFileImportModalSheet(context, File file) async {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return ShowJsonImportModal(file: file);
    },
  );
}

class ShowJsonImportModal extends StatelessWidget {
  const ShowJsonImportModal({super.key, required this.file});
  final File file;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(
            height: 90,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => {db.clearImportJson(file)},
              child: const Text("Clear and Import"),
            ),
          )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () => {db.importJson(file)},
                child: const Text("Add To Current")),
          )),
          const SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////
/////////////////////////////////////////////////




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
