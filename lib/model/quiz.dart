import 'package:isar/isar.dart';

import 'module.dart';
import 'question.dart';

part 'quiz.g.dart';

@Collection()
class Quiz {
  Id id = Isar.autoIncrement;

  late String title;
  late String containingModuleString;

  @Backlink(to: "quiz")
  final questions = IsarLinks<Question>();
  final containingModule = IsarLink<Module>();
}
