import 'package:flutter/material.dart';
import 'package:purequiz_demo/module_modal.dart';

import 'model/module.dart';
import 'quiz_list_screen.dart';
import 'services/isar_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PureQuiz")),
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
                              print("Going to Quiz List screen");
                              print(module.moduleTitle);
                              QuizListScreen.navigate(context, module, service);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 89, 80, 253),
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

// 12.1610pm -2am - having trouble assigning the containing module to the quiz instance and displaying it
// fixed by running  the tutorial app and seeing that the correct way of accessing and setting the moodule was the .value variable

// 12.16 2pm
// implementing question screen
// first is implement add question modal in quiz/moduledetail screen