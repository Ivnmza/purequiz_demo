import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../model/module.dart';
import '../model/question.dart';
import '../model/quiz.dart';

final db = IsarService();

class IsarService {
  late Future<Isar> database;

  IsarService() {
    database = openDB();
  }

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
    final isar = await database;
    await isar.writeTxn(() => isar.clear());
  }

// easy to  change
  Future<void> saveModule(Module newModule) async {
    final isar = await database;
    isar.writeTxnSync<int>(() => isar.modules.putSync(newModule));
  }

// easy
  Future<void> saveQuiz(Quiz newQuiz) async {
    final isar = await database;
    isar.writeTxnSync<int>(() => isar.quizs.putSync(newQuiz));
  }

// easy
  Future<void> saveQuestion(Question newQuestion) async {
    final isar = await database;
    isar.writeTxnSync<int>(() => isar.questions.putSync(newQuestion));
  }

// easy
  Future<List<Module>> getAllModules() async {
    final isar = await database;
    return await isar.modules.where().findAll();
  }

  Future<Module?> getSingleModule(String moduleTitle) async {
    final isar = await database;
    return await isar.modules
        .filter()
        .moduleTitleEqualTo(moduleTitle)
        .findFirst();
  }

//esasy
  Stream<List<Module>> listenToModules() async* {
    final isar = await database;
    yield* isar.modules.where().watch(fireImmediately: true);
  }

// here we need a backlink
  Future<List<Quiz>> getQuizzes(Module module) async {
    final isar = await database;
    return await isar.quizs
        .filter()
        .containingModule((q) => q.idEqualTo(module.id))
        .findAll();
  }

// easy
  Stream<List<Quiz>> listenToQuizzes(Module module) async* {
    final isar = await database;
    yield* isar.quizs
        .filter()
        .containingModule((q) => q.idEqualTo(module.id))
        .watch(fireImmediately: true);
  }

  //easy
  Future<List<Question>> getQuestions(Quiz quiz) async {
    final isar = await database;
    return await isar.questions
        .filter()
        .quiz((q) => q.idEqualTo(quiz.id))
        .findAll();
  }

  Stream<List<Question>> listenToQuestions(Quiz quiz) async* {
    final isar = await database;
    yield* isar.questions
        .filter()
        .quiz((q) => q.idEqualTo(quiz.id))
        .watch(fireImmediately: true);
  }

  ///////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////
  ///  ///////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////

  Future<List<Map<String, dynamic>>> exportAllToJSON() async {
    final isar = await database;
    return await isar.modules.where().exportJson();
  }

  Future<void> exportAllModulesToJsonFile() async {
    final isar = await database;
    Uint8List dataBytes;
    await isar.modules.where().exportJsonRaw((p0) {
      dataBytes = p0;
      DocumentFileSavePlus().saveMultipleFiles(dataList: [
        dataBytes
      ], fileNameList: [
        "PureQuizModulesExport.txt",
      ], mimeTypeList: [
        "text/plain"
      ]);
    });
  }

  Future<List<Map<String, dynamic>>> exportAllQuizlToJSON() async {
    final isar = await database;
    return await isar.quizs.where().exportJson();
  }

  Future<List<Map<String, dynamic>>> exportAllQuestionsToJSON() async {
    final isar = await database;
    return await isar.questions.where().exportJson();
  }

  Future<void> exportAllQuestionsToJSONFile() async {
    final isar = await database;
    Uint8List dataBytes;

    await isar.questions.where().exportJsonRaw((p0) {
      dataBytes = p0;
      DocumentFileSavePlus().saveMultipleFiles(dataList: [
        dataBytes
      ], fileNameList: [
        "PureQuizQuestionsExport.txt",
      ], mimeTypeList: [
        "text/plain"
      ]);
    });
  }

  clearThenAddQuestionsFromJson(File jsonFile) async {
    final isar = await database;
    final String jsonContents = jsonFile.readAsStringSync();
    final dynamic parsedJSON = jsonDecode(jsonContents);
    if (parsedJSON == null) {
    } else {
      await isar.writeTxn(() async {
        await isar.clear();
      });
      logger.d("Clearing then Adding...");
      logger.d("$parsedJSON");

      List<Map<String, dynamic>> info = List.from(parsedJSON);
      await isar.writeTxn(() async {
        await isar.questions.importJson(info);
        for (var element in info) {
          Module newModule = Module();
          newModule.moduleTitle = element['moduleString'];
          await isar.modules.put(newModule);
        }
      });
    }
  }

  addQuestionsFromJson(File jsonFile) async {
    final isar = await database;
    final String jsonContents = jsonFile.readAsStringSync();
    final dynamic parsedJSON = jsonDecode(jsonContents);
    if (parsedJSON == null) {
    } else {
      logger.d("Json being imported: $parsedJSON");
      List<Map<String, dynamic>> info = List.from(parsedJSON);

      // await isar.questions.importJson(info);
      for (var element in info) {
        Module newModule = Module();
        newModule.moduleTitle = element['moduleString'];
        isar.writeTxnSync<int>(() => isar.modules.putSync(newModule));
      }

      var moduleList = await getAllModules();
      for (var element in moduleList) {
        logger.d("here");
        for (var jsonElement in info) {
          isar.writeTxnSync<int>(() => isar.quizs.putSync(Quiz()
            ..title = jsonElement['quizString']
            ..containingModule.value = element
            ..containingModuleString = jsonElement['moduleString']));
        }
      }
    }
  }

  addQuestionsFromJson2(File jsonFile) async {
    final isar = await database;
    final String jsonContents = jsonFile.readAsStringSync();
    final dynamic parsedJSON = jsonDecode(jsonContents);
    if (parsedJSON == null) {
    } else {
      logger.d("Json being imported: $parsedJSON");
      List<Map<String, dynamic>> info = List.from(parsedJSON);

      // await isar.questions.importJson(info);
      for (var element in info) {
        Module newModule = Module();
        newModule.moduleTitle = element['moduleString'];
        isar.writeTxnSync<int>(() => isar.modules.putSync(newModule));
        // get  single module from a query
        isar.writeTxnSync<int>(() => isar.quizs.putSync(Quiz()
          ..title = element['quizString']
          ..containingModule.value = newModule
          ..containingModuleString = element['moduleString']));
      }
    }
  }

  addQuestionsFromJson4(File jsonFile) async {
    final isar = await database;
    final String jsonContents = jsonFile.readAsStringSync();
    final dynamic parsedJSON = jsonDecode(jsonContents);
    if (parsedJSON == null) {
    } else {
      logger.d("Json being imported: $parsedJSON");
      List<Map<String, dynamic>> info = List.from(parsedJSON);

      for (var element in info) {
        var currentQuestionModule = await getSingleModule(element['moduleString']);
        logger.d("isModulePresent?: $currentQuestionModule");
        if (currentQuestionModule == null) {
          logger.d("Module not present.. writing to db");
          Module newModule = Module();
          newModule.moduleTitle = element['moduleString'];
          isar.writeTxnSync<int>(() => isar.modules.putSync(newModule));
          isar.writeTxnSync<int>(() => isar.quizs.putSync(Quiz()
            ..title = element['quizString']
            ..containingModule.value = newModule
            ..containingModuleString = element['moduleString']));
        }
        logger.d("Module already present.. ");
        isar.writeTxnSync<int>(() => isar.quizs.putSync(Quiz()
          ..title = element['quizString']
          ..containingModule.value = currentQuestionModule
          ..containingModuleString = element['moduleString']));

        // get  single module from a query
      }
    }
  }

  addQuestionsFromJson3(File jsonFile) async {
    final isar = await database;
    final String jsonContents = jsonFile.readAsStringSync();
    final dynamic parsedJSON = jsonDecode(jsonContents);
    if (parsedJSON == null) {
    } else {
      logger.d("Json being imported: $parsedJSON");
      List<Map<String, dynamic>> info = List.from(parsedJSON);

      // await isar.questions.importJson(info);
      for (var element in info) {
        Module newModule = Module();
        newModule.moduleTitle = element['moduleString'];
        isar.writeTxnSync<int>(() => isar.modules.putSync(newModule));
      }

      var moduleList = await getAllModules();
      for (var element in moduleList) {
        logger.d("here");
        for (var jsonElement in info) {
          isar.writeTxnSync<int>(() => isar.quizs.putSync(Quiz()
            ..title = jsonElement['quizString']
            ..containingModule.value = element
            ..containingModuleString = jsonElement['moduleString']));
        }
      }
    }
  }

  addModulesFromJson(File jsonFile) async {
    final isar = await database;
    final String jsonContents = jsonFile.readAsStringSync();
    final dynamic parsedJSON = jsonDecode(jsonContents);
    if (parsedJSON == null) {
    } else {
      logger.d("$parsedJSON");
      List<Map<String, dynamic>> info = List.from(parsedJSON);
      await isar.writeTxn(() async {
        await isar.modules.importJson(info);
      });
    }
  }

  Future<dynamic> addFromJson(File jsonFile) async {
    final isar = await database;
    // importJson.3 make the modules list, some may be  empty
    // loop  through the module
    final String jSONfileContents = jsonFile.readAsStringSync();
    // loop through the json
    // importJSON.4 - parse json
    final parsedJsonDB = jsonDecode(jSONfileContents);
    logger.d("ParsedJson: $parsedJsonDB");
    logger.d("ParsedJSONRUNTYPE: ${parsedJsonDB.length}");

    List<Map<String, dynamic>>? info =
        parsedJsonDB != null ? List.from(parsedJsonDB) : null;
    logger.d("Decoded jSON: $info");

    info?.forEach((element) async {
      Question newQuestion = Question();
      newQuestion
        ..question = element['question']
        ..answer = element['answer']
        ..quizString = element['quizString']
        ..moduleString = element['moduleString'];
      logger.d("Questiontobeadded: $newQuestion");
      isar.writeTxnSync<int>(() => isar.questions.putSync(newQuestion));
    });
  }

  ///////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////
}
