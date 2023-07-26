import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter/material.dart';

import 'model/question.dart';
import 'module_modal.dart';
import 'model/module.dart';
import 'quiz_list_screen.dart';
import 'services/isar_service.dart';
import 'package:logger/logger.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
      theme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: ModuleScreen(),
    );
  }
}

class ModuleScreen extends StatelessWidget {
  ModuleScreen({super.key});
  final service = IsarService();

  void _saveFile() {
    // DocumentFileSavePlus().saveFile(data, fileName, "text/plain");
    // save multiple files (case that file have same name). system will automatically append number to filename.
    // DocumentFileSave.saveMultipleFiles([htmlBytes, textBytes], ["file.txt", "file.txt"], ["text/html", "text/plain"]);

    // save single file
    //DocumentFileSavePlus().saveFile(textBytes1, "my test file", "text/plain");
  /// Helper method to convert a [User] to an [AppUser]
  //List<Map<String,dynamic>>? _convertUser(List<Map<String,dynamic>>? listofquestions) =>
     // listofquestions != null ? Question(listofquestions) : null;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PureQuiz"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
/*
              var allQuestions = await service.exportAllQuestionsToJSON();
              var  allQuestionsMap = allQuestions.map((e){
                return {
                  "question":e,
                  "answer":e[0],
                  "id":e[1],
                  "moduleString":e[2],
                  "quizString":e[4]
                };
              }).toList();
              String stringQuestions = json.encode(allQuestionsMap);
              logger.d("AllQuestions Json: $stringQuestions");
              */
              await service
                  .exportAllToJSON()
                  .then((value) => logger.d("MODULES JSON: $value"));
              await service
                  .exportAlQuizlToJSON()
                  .then((value) => logger.d("QUIZS JSON: $value"));
              await service
                  .exportAllQuestionsToJSON()
                  .then((value) => logger.d("QUESTIONS JSON: $value"));

              const filename = "test";
              final file = File(
                  '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
              service
                  .exportAllQuestionsToJSON()
                  .then((value) => file.writeAsString('$value'));
              logger.d("Location: $file");
              logger.d("File contents:${file.readAsStringSync()}");
              final exportedFile = file.readAsBytesSync();
              //service.exportAllQuestionsToJSON().then((value) => DocumentFileSavePlus().saveFile(Uint8List.fromList(utf8.encode(value.toString())),  DateTime.now().toString(), "text/plain"));
              //await Share.shareXFiles([XFile('$file')]);
              // DocumentFileSavePlus().saveFile(Uint8List.fromList(utf8.encode(service.exportAllQuestionsToJSON().toString())), DateTime.now().toString(), "text/plain");

              DocumentFileSavePlus().saveMultipleFiles(
                dataList: [ exportedFile],
                fileNameList: ["exportedPureQuiz.txt"],
                mimeTypeList: ["text/plain"],
              );
            },
          )
        ],
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return ModuleModal(service);
              });
        },
        child: const Text("Add Module"),
      ),
      body: Column(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<List<Module>>(
              stream: service.listenToModules(),
              builder: (context, snapshot) => GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                scrollDirection: Axis.vertical,
                children: snapshot.hasData
                    ? snapshot.data!.map((module) {
                        return ElevatedButton(
                          onPressed: () {
                            QuizListScreen.navigate(context, module, service);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 89, 80, 253),
                            padding: const EdgeInsets.all(5.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: Text(module.moduleTitle),
                        );
                      }).toList()
                    : [],
              ),
            ),
          ),
        ),
      ]),
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