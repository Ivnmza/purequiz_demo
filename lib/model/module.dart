import 'package:isar/isar.dart';

import 'quiz.dart';

part 'module.g.dart';

@Collection()
class Module{
  Id id = Isar.autoIncrement;

  late String moduleTitle;
  final quizzes = IsarLinks<Quiz>();
  
}