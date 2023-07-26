import 'package:isar/isar.dart';

import 'module.dart';
import 'quiz.dart';

part 'question.g.dart';

@Collection()
class Question{
  Id id = Isar.autoIncrement;
  late String question;
  late String answer;
  late String quizString;
  late String moduleString;
/*
    Question({
     required this.question,
     required this.answer, 
     required this.quizString,
     required this.moduleString
   });
   */
  
  final quiz = IsarLink<Quiz>();
  final module = IsarLink<Module>();

  Map<String, dynamic> toMap() {
    return {
      "question": question,
      "answer":answer,
      "quizString":quizString,
      "moduleString":moduleString,
      "id":id

    };
  }
}