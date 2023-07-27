import 'dart:convert';
import 'dart:typed_data';

import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:isar/isar.dart';
import 'package:purequiz_demo/main.dart';
import '../model/module.dart';
import '../model/question.dart';
import '../model/quiz.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }
// easy to  change
  Future<void> saveModule(Module newModule) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.modules.putSync(newModule));
  }

// easy
  Future<void> saveQuiz(Quiz newQuiz) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.quizs.putSync(newQuiz));
  }

// easy
  Future<void> saveQuestion(Question newQuestion) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.questions.putSync(newQuestion));
  }

// easy
  Future<List<Module>> getAllModules() async {
    final isar = await db;
    return await isar.modules.where().findAll();
  }

//esasy
  Stream<List<Module>> listenToModules() async* {
    final isar = await db;
    yield* isar.modules.where().watch(fireImmediately: true);
  }

// here we need a backlink
  Future<List<Quiz>> getQuizzes(Module module) async {
    final isar = await db;
    return await isar.quizs
        .filter()
        .containingModule((q) => q.idEqualTo(module.id))
        .findAll();
  }

// easy
  Stream<List<Quiz>> listenToQuizzes(Module module) async* {
    final isar = await db;
    yield* isar.quizs
        .filter()
        .containingModule((q) => q.idEqualTo(module.id))
        .watch(fireImmediately: true);
  }

  //easy
  Future<List<Question>> getQuestions(Quiz quiz) async {
    final isar = await db;
    return await isar.questions
        .filter()
        .quiz((q) => q.idEqualTo(quiz.id))
        .findAll();
  }

  Stream<List<Question>> listenToQuestions(Quiz quiz) async* {
    final isar = await db;
    yield* isar.questions 
        .filter()
        .quiz((q) => q.idEqualTo(quiz.id))
        .watch(fireImmediately: true);
  }

  ///////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////
  


Future<List<Map<String,dynamic>>> exportAllToJSON() async{
  final isar = await db;
    return await isar.modules.where().exportJson();
}


Future<List<Map<String,dynamic>>> exportAlQuizlToJSON() async{
  final isar = await db;
    return await isar.quizs.where().exportJson();
}


Future<List<Map<String,dynamic>>> exportAllQuestionsToJSON() async{
  final isar = await db;
    return await isar.questions.where().exportJson();
}


Future <void> exportAllQuestionsToJSONFile() async  {
  final isar = await db;

    List<int> textBytes = utf8.encode("Some data");
    Uint8List textBytes1 = Uint8List.fromList(textBytes);
    Uint8List dataBytes;

     await isar.questions.where().exportJsonRaw((p0) {

      dataBytes = p0;
      DocumentFileSavePlus().saveMultipleFiles(
      dataList: [dataBytes, textBytes1],
      fileNameList: ["myQuizData.txt", "textfile.txt"],
      mimeTypeList: ["text/plain", "text/plain"],

    );  
  });
}



  ///////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [ModuleSchema, QuizSchema, QuestionSchema],
        inspector: true,
      );
    }

    return Future.value(Isar.getInstance());
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

}

