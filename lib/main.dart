import 'package:flutter/material.dart';
import 'package:purequiz_demo/common_widgets/common_widgets.dart';
import 'package:purequiz_demo/constants/constants.dart';
import 'package:logger/logger.dart';
import 'package:purequiz_demo/heroanimtest.dart';

import 'module/module_widgets.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purequiz Demo',
      theme: kThemeData,
      debugShowCheckedModeBanner: false,
      home: const ModuleScreen(),
    );
  }
}

class ModuleScreen extends StatelessWidget {
  const ModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: kAppTitleText,
          actions: const [ExportJsonFileButton(), PickDocument()],
        ),
        bottomNavigationBar: const AddModuleButton(),
        body: const Stack(children: [
          ModuleGridView(),
          GoToAnimTestButton(),
        ]));
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