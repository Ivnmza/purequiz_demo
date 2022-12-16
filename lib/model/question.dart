import 'package:isar/isar.dart';

import 'module.dart';
import 'quiz.dart';

part 'question.g.dart';

@Collection()
class Question{
  Id id = Isar.autoIncrement;
  late String question;
  late String answer;
  
  final quiz = IsarLink<Quiz>();
  final module = IsarLink<Module>();
}