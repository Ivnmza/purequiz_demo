import 'package:flutter/material.dart';
import 'package:purequiz_demo/constants/constants.dart';
import 'module_modal.dart';
import 'model/module.dart';
import 'quiz_list_screen.dart';
import 'services/isar_service.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purequiz Demo',
      theme: kThemeData,
      debugShowCheckedModeBanner: false,
      home: ModuleScreen(),
    );
  }
}

class ModuleScreen extends StatelessWidget {
  ModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PureQuiz"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              _logAll();
              _saveFile();
            },
          )
        ],
      ),
      bottomNavigationBar: _addTopicBottomSheet(context),
      body: Column(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<List<Module>>(
              stream: db.listenToModules(),
              builder: (context, snapshot) => GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                scrollDirection: Axis.vertical,
                children: snapshot.hasData
                    ? snapshot.data!.map((module) {
                        return _topicButton(context, module, db);
                      }).toList()
                    : [],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _addTopicText() {
    return const Text(
      "Add Topic",
      style: TextStyle(fontSize: 25),
    );
  }

  Widget _topicButton(context, module, db) {
    return ElevatedButton(
      onPressed: () {
        QuizListScreen.navigate(context, module, db);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 89, 80, 253),
        padding: const EdgeInsets.all(15.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      child: Text(
        module.moduleTitle,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  final db = IsarService();

  void _saveFile() {
    db.exportAllQuestionsToJSONFile();
  }

  void _logAll() async {
    await db
        .exportAllToJSON()
        .then((value) => logger.d("MODULES JSON: $value"));
    await db
        .exportAlQuizlToJSON()
        .then((value) => logger.d("QUIZS JSON: $value"));
    await db
        .exportAllQuestionsToJSON()
        .then((value) => logger.d("QUESTIONS JSON: $value"));
  }

  Widget _addTopicBottomSheet(context) {
    return SizedBox(
      height: 105,
      child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return ModuleModal(db);
                });
          },
          child: _addTopicText()),
    );
  }
}


// 0: First imported package and checked main dart file to see  if any initialization code is necessary(as  it  was for hive)
  //:  
//  1: Create Models
//  copied  models  and modified
//  2: Generate isar model code
//  3: write isar service code to interact with db
// copied service  code and modified
//  4: write main screen ui
// write modal -easy
//  5: write quiz screen ui
// modal easy but  still a bit  difficult

// 12.16 10pm -2am - having trouble assigning the containing module to the quiz instance and displaying it
// fixed by running  the tutorial app and seeing that the correct way of accessing and setting the moodule was the .value variable

// 12.16 2pm
// implementing question screen
// first is implement add question modal in quiz/moduledetail screen
//12/28 modified passing service and routes to pass through module and quiz information for storage into a json object
//12.29 implementing local storage of question list json to   get ready for cloud storage


//12.29 7.20pm - 