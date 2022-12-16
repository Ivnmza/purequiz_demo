import 'package:flutter/material.dart';
import 'package:purequiz_demo/model/quiz.dart';
import 'package:purequiz_demo/module_modal.dart';

import 'model/module.dart';
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
        child: const Text("Add Course"),
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
                              print("Going to Module details screen");
                              ModuleDetailScreen.navigate(context, module, service);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 89, 80, 253),
                              padding: EdgeInsets.all(5.0),
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



class ModuleDetailScreen extends StatelessWidget {
  const ModuleDetailScreen({Key? key, required this.module, required this.service}): super(key: key);
  final Module module;
  final IsarService service;

  static void navigate(context, Module module, IsarService service) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ModuleDetailScreen(module: module, service: service);
      }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(module.moduleTitle)),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                // build QuizModal
                return ModuleModal(service);
              });
        },
        child: const Text("Add Quiz"),
      ),
      body: Column(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Quiz>>(
              future: service.getQuizzes(module),
              builder: (context, snapshot) => GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                scrollDirection: Axis.vertical,
                children: snapshot.hasData
                    ? snapshot.data!.map((quiz) {
                        return ElevatedButton(
                            onPressed: () {
                              print("Going to Quiz");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 89, 80, 253),
                              padding: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            child: Text(quiz.title),
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

//  1: Create Models
//  2: Generate isar model code
//  3: write isar service code to interact with db
//  4: write main screen ui
//  5: write quiz screen ui