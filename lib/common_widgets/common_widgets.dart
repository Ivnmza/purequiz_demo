import 'dart:io';

import 'package:flutter/material.dart';

import '../add_question_modal.dart';
import '../add_quiz_modal.dart';
import '../constants/app_sizes.dart';
import '../constants/constants.dart';
import '../main.dart';
import '../model/module.dart';
import '../model/question.dart';
import '../model/quiz.dart';
import '../module_modal.dart';
import '../question_list_screen.dart';
import '../quiz_grid_screen.dart';
import '../services/isar_service.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';

class GoToTopicButton extends StatelessWidget {
  const GoToTopicButton({super.key, required this.module, required this.db});
  final IsarService db;
  final Module module;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => QuizListScreen.navigate(context, module, db),
      style: ElevatedButton.styleFrom(
          backgroundColor: kPurple,
          padding: const EdgeInsets.all(Sizes.p16),
          shape: kTopicShape),
      child: Text(
        module.moduleTitle,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}

class AddTopicButton extends StatelessWidget {
  const AddTopicButton({super.key});

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
              return ModuleModal(db);
            },
          );
        },
        child: const Text(
          "Add Topic",
          style: TextStyle(fontSize: 25),
        ),
      ),
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
        logger.d("Going to Quiz screen: " + quiz.title);
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

class QuestionInstanceButton extends StatelessWidget {
  const QuestionInstanceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
/////////////////////////////

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
            .exportAlQuizlToJSON()
            .then((value) => logger.d("QUIZS JSON: $value"));
        await db
            .exportAllQuestionsToJSON()
            .then((value) => logger.d("QUESTIONS JSON: $value"));
        db.exportAllQuestionsToJSONFile();
      },
    );
  }
}

class PickDocument extends StatelessWidget {
  const PickDocument({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.dock),
      onPressed: () async {
        // create a isar DB from this JSON
        final File myFile;
        final String? path = await FlutterDocumentPicker.openDocument();
        final String myFileContents;
        myFile = File(path!);
        logger.d("Path picked: $path");
        myFileContents = myFile.readAsStringSync();
        logger.d("Contents: $myFileContents");
      },
    );
  }
}

////////////////////////////////////////////////////
/////////////////////////////////////////////////

class ModuleGridView extends StatelessWidget {
  const ModuleGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: StreamBuilder<List<Module>>(
              stream: db.listenToModules(),
              builder: (context, snapshot) => GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                scrollDirection: Axis.vertical,
                children: snapshot.hasData
                    ? snapshot.data!.map((module) {
                        return GoToTopicButton(module: module, db: db);
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
