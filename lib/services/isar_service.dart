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

  ///////
  ///
  ///

  Future<void> deleteModule(String moduleTitle) async {
    final isar = await database;
    isar.writeTxn(() {
      isar.questions.filter().moduleStringEqualTo(moduleTitle).deleteAll();
      isar.quizs
          .filter()
          .containingModuleStringEqualTo(moduleTitle)
          .deleteAll();
      return isar.modules
          .filter()
          .moduleTitleEqualTo(moduleTitle)
          .deleteFirst();
    });
  }

Future<void> updateModule(Module module,String newModelTitle) async {
  final isar = await database;
  final moduleToUpdate = Module()..id = module.id..moduleTitle=newModelTitle;
  logger.d(module.id);

  isar.writeTxn(() async {

    await isar.modules.put(moduleToUpdate);
  });
}
  

//////////////////////////////////////////
//////////////////////////////////////////
  /// SAVING TO DB METHODS
//////////////////////////////////////////
//////////////////////////////////////////
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

///////////////////////////////////////////
///////////////////////////////////////////
  /// GETTING MODULES
//////////////////////////////////////////]
///////////////////////////////////////////
  Future<Module?> getSingleModule(String moduleTitle) async {
    final isar = await database;
    return await isar.modules
        .filter()
        .moduleTitleEqualTo(moduleTitle)
        .findFirst();
  }

// easy
  Future<List<Module>> getAllModules() async {
    final isar = await database;
    return await isar.modules.where().findAll();
  }

//esasy
  Stream<List<Module>> listenToModules() async* {
    final isar = await database;
    yield* isar.modules.where().watch(fireImmediately: true);
  }
///////////////////////////////////////////////

  Future<Quiz?> getSingleQuiz(String quiztitle) async {
    final isar = await database;
    return await isar.quizs.filter().titleEqualTo(quiztitle).findFirst();
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

  //////////////////////////////////////////////////
  ////////////////////////////////////////////////

  //easy

  Future<Question?> getSingleQuestion(String questionTitle) async {
    final isar = await database;
    return await isar.questions
        .filter()
        .questionEqualTo(questionTitle)
        .findFirst();
  }

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
  ///  EXPORT METHODS
  //////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////

  Future<List<Map<String, dynamic>>> exportAllToJSON() async {
    final isar = await database;
    return await isar.modules.where().exportJson();
  }

   Future<List<String>> getListModuleStrings() async {
    final isar = await database;
     List<String> listOfModules = [];
    var a = await isar.modules.where().exportJson();
        var hm = List.from(a);

    for (var element in hm) {
      listOfModules.add(element['moduleTitle']);
    }
    return listOfModules;
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

  clearImportJson(File jsonFile) async {
    final isar = await database;
    final String jsonContents = jsonFile.readAsStringSync();
    final dynamic parsedJSON = jsonDecode(jsonContents);
    if (parsedJSON == null) {
    } else {
      logger.d("Json being imported: $parsedJSON");
      List<Map<String, dynamic>> info = List.from(parsedJSON);

      for (var element in info) {
        var currentQuestionModule =
            await getSingleModule(element['moduleString']);
        var currentQuestionQuiz = await getSingleQuiz(element['quizString']);
        var currentQuestionInstance =
            await getSingleQuestion(element['question']);
        logger.d("isModulePresent?: $currentQuestionModule");
        if (currentQuestionModule == null) {
          logger.d("Module not present.. writing to db");

          Module newModule = Module();
          newModule.moduleTitle = element['moduleString'];
          Quiz newQuiz = Quiz();
          newQuiz.title = element['quizString'];
          newQuiz.containingModule.value = newModule;
          newQuiz.containingModuleString = element['quizString'];
          Question newQuestion = Question();
          newQuestion.question = element['question'];
          newQuestion.answer = element['answer'];
          newQuestion.quizString = element['quizString'];
          newQuestion.quiz.value = newQuiz;
          newQuestion.moduleString = element['moduleString'];
          newQuestion.module.value = newModule;

          isar.writeTxnSync<int>(() => isar.modules.putSync(newModule));

          if (currentQuestionQuiz == null) {
            logger.d("Quiz not present.. writing quiz to db ");
            isar.writeTxnSync<int>(() => isar.quizs.putSync(newQuiz));

            if (currentQuestionInstance == null) {
              isar.writeTxnSync<int>(() => isar.questions.putSync(newQuestion));
            }
          } else {
            logger.d("Quiz present. ");
            Question newQuestion = Question();
            newQuestion.question = element['question'];
            newQuestion.answer = element['answer'];
            newQuestion.quizString = element['quizString'];
            newQuestion.quiz.value = currentQuestionQuiz;
            newQuestion.moduleString = element['moduleString'];
            newQuestion.module.value = currentQuestionModule;

            if (currentQuestionInstance == null) {
              isar.writeTxnSync<int>(() => isar.questions.putSync(newQuestion));
            }
          }
        } else {
          logger.d("Module present.. Searching for Quiz");

          Quiz newQuiz = Quiz();
          newQuiz.title = element['quizString'];
          newQuiz.containingModule.value = currentQuestionModule;
          newQuiz.containingModuleString = element['quizString'];
          Question newQuestion = Question();
          newQuestion.question = element['question'];
          newQuestion.answer = element['answer'];
          newQuestion.quizString = element['quizString'];
          newQuestion.quiz.value = newQuiz;
          newQuestion.moduleString = element['moduleString'];
          newQuestion.module.value = currentQuestionModule;

          if (currentQuestionQuiz == null) {
            logger.d("Module Present.Quiz not present.. writing quiz to db ");
            isar.writeTxnSync<int>(() => isar.quizs.putSync(newQuiz));
          } else {
            Question newQuestion = Question();
            newQuestion.question = element['question'];
            newQuestion.answer = element['answer'];
            newQuestion.quizString = element['quizString'];
            newQuestion.quiz.value = currentQuestionQuiz;
            newQuestion.moduleString = element['moduleString'];
            newQuestion.module.value = currentQuestionModule;
            if (currentQuestionInstance == null) {
              isar.writeTxnSync<int>(() => isar.questions.putSync(newQuestion));
            }
          }
        }
      }
    }
  }

  importJson(File jsonFile) async {
    final isar = await database;
    final String jsonContents = jsonFile.readAsStringSync();
    final dynamic parsedJSON = jsonDecode(jsonContents);
    if (parsedJSON == null) {
    } else {
      logger.d("Json being imported: $parsedJSON");
      List<Map<String, dynamic>> info = List.from(parsedJSON);

      for (var element in info) {
        var currentQuestionModule =
            await getSingleModule(element['moduleString']);
        var currentQuestionQuiz = await getSingleQuiz(element['quizString']);
        var currentQuestionInstance =
            await getSingleQuestion(element['question']);
        logger.d("isModulePresent?: $currentQuestionModule");
        if (currentQuestionModule == null) {
          logger.d("Module not present.. writing to db");

          Module newModule = Module();
          newModule.moduleTitle = element['moduleString'];
          Quiz newQuiz = Quiz();
          newQuiz.title = element['quizString'];
          newQuiz.containingModule.value = newModule;
          newQuiz.containingModuleString = element['moduleString'];
          Question newQuestion = Question();
          newQuestion.question = element['question'];
          newQuestion.answer = element['answer'];
          newQuestion.quizString = element['quizString'];
          newQuestion.quiz.value = newQuiz;
          newQuestion.moduleString = element['moduleString'];
          newQuestion.module.value = newModule;

          isar.writeTxnSync<int>(() => isar.modules.putSync(newModule));

          if (currentQuestionQuiz == null) {
            logger.d("Quiz not present.. writing quiz to db ");
            isar.writeTxnSync<int>(() => isar.quizs.putSync(newQuiz));

            if (currentQuestionInstance == null) {
              isar.writeTxnSync<int>(() => isar.questions.putSync(newQuestion));
            }
          } else {
            logger.d("Quiz present. ");
            Question newQuestion = Question();
            newQuestion.question = element['question'];
            newQuestion.answer = element['answer'];
            newQuestion.quizString = element['quizString'];
            newQuestion.quiz.value = currentQuestionQuiz;
            newQuestion.moduleString = element['moduleString'];
            newQuestion.module.value = currentQuestionModule;

            if (currentQuestionInstance == null) {
              isar.writeTxnSync<int>(() => isar.questions.putSync(newQuestion));
            }
          }
        } else {
          logger.d("Module present.. Searching for Quiz");

          Quiz newQuiz = Quiz();
          newQuiz.title = element['quizString'];
          newQuiz.containingModule.value = currentQuestionModule;
          newQuiz.containingModuleString = element['quizString'];
          Question newQuestion = Question();
          newQuestion.question = element['question'];
          newQuestion.answer = element['answer'];
          newQuestion.quizString = element['quizString'];
          newQuestion.quiz.value = newQuiz;
          newQuestion.moduleString = element['moduleString'];
          newQuestion.module.value = currentQuestionModule;

          if (currentQuestionQuiz == null) {
            logger.d("Module Present.Quiz not present.. writing quiz to db ");
            isar.writeTxnSync<int>(() => isar.quizs.putSync(newQuiz));
          } else {
            Question newQuestion = Question();
            newQuestion.question = element['question'];
            newQuestion.answer = element['answer'];
            newQuestion.quizString = element['quizString'];
            newQuestion.quiz.value = currentQuestionQuiz;
            newQuestion.moduleString = element['moduleString'];
            newQuestion.module.value = currentQuestionModule;
            if (currentQuestionInstance == null) {
              isar.writeTxnSync<int>(() => isar.questions.putSync(newQuestion));
            }
          }
        }
      }
    }
  }

  importJson2(File jsonFile) async {
    final isar = await database;
    final String jsonContents = jsonFile.readAsStringSync();
    final dynamic parsedJSON = jsonDecode(jsonContents);
    if (parsedJSON == null) {
    } else {
      logger.d("Json being imported: $parsedJSON");
      List<Map<String, dynamic>> info = List.from(parsedJSON);

      for (var element in info) {
        var currentQuestionModule =
            await getSingleModule(element['moduleString']);
        var currentQuestionQuiz = await getSingleQuiz(element['quizString']);
        var currentQuestionInstance =
            await getSingleQuestion(element['question']);
        logger.d("isModulePresent?: $currentQuestionModule");
        if (currentQuestionModule == null) {
          logger.d("Module not present.. writing to db");

          Module newModule = Module();
          newModule.moduleTitle = element['moduleString'];
          Quiz newQuiz = Quiz();
          newQuiz.title = element['quizString'];
          newQuiz.containingModule.value = newModule;
          newQuiz.containingModuleString = element['quizString'];
          Question newQuestion = Question();
          newQuestion.question = element['question'];
          newQuestion.answer = element['answer'];
          newQuestion.quizString = element['quizString'];
          newQuestion.quiz.value = newQuiz;
          newQuestion.moduleString = element['moduleString'];
          newQuestion.module.value = newModule;

          isar.writeTxnSync<int>(() => isar.modules.putSync(newModule));

          if (currentQuestionQuiz == null) {
            logger.d("Quiz not present.. writing quiz to db ");
            isar.writeTxnSync<int>(() => isar.quizs.putSync(newQuiz));

            if (currentQuestionInstance == null) {
              isar.writeTxnSync<int>(() => isar.questions.putSync(newQuestion));
            }
          } else {
            logger.d("Quiz present. ");
            Question newQuestion = Question();
            newQuestion.question = element['question'];
            newQuestion.answer = element['answer'];
            newQuestion.quizString = element['quizString'];
            newQuestion.quiz.value = currentQuestionQuiz;
            newQuestion.moduleString = element['moduleString'];
            newQuestion.module.value = currentQuestionModule;
            isar.writeTxnSync<int>(() => isar.questions.putSync(newQuestion));
          }
        } else {
          logger.d("Module present.. Searching for Quiz");

          Quiz newQuiz = Quiz();
          newQuiz.title = element['quizString'];
          newQuiz.containingModule.value = currentQuestionModule;
          newQuiz.containingModuleString = element['quizString'];
          Question newQuestion = Question();
          newQuestion.question = element['question'];
          newQuestion.answer = element['answer'];
          newQuestion.quizString = element['quizString'];
          newQuestion.quiz.value = newQuiz;
          newQuestion.moduleString = element['moduleString'];
          newQuestion.module.value = currentQuestionModule;

          if (currentQuestionQuiz == null) {
            logger.d("Module Present.Quiz not present.. writing quiz to db ");
            isar.writeTxnSync<int>(() => isar.quizs.putSync(newQuiz));
          } else {
            Question newQuestion = Question();
            newQuestion.question = element['question'];
            newQuestion.answer = element['answer'];
            newQuestion.quizString = element['quizString'];
            newQuestion.quiz.value = currentQuestionQuiz;
            newQuestion.moduleString = element['moduleString'];
            newQuestion.module.value = currentQuestionModule;
            isar.writeTxnSync<int>(() => isar.questions.putSync(newQuestion));
          }
        }
      }
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
