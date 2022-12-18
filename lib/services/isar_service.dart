import 'package:isar/isar.dart';
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

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
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
    yield* isar.quizs.filter().containingModule((q) => q.idEqualTo(module.id)).watch(fireImmediately: true);
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
    yield* isar.questions.filter().quiz((q) => q.idEqualTo(quiz.id)).watch(fireImmediately: true);
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
}
