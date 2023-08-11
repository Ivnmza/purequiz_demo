import 'package:isar/isar.dart';

import 'module.dart';
import 'quiz.dart';

part 'question.g.dart';

@Collection()
class Question {
  Id id = Isar.autoIncrement;
  late String question;
  late String answer;
  late String quizString;
  late String moduleString;

  final quiz = IsarLink<Quiz>();
  final module = IsarLink<Module>();
}
