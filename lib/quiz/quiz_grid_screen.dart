import 'package:flutter/material.dart';
import 'package:purequiz_demo/common_widgets/hero_dialog_route.dart';
import 'package:purequiz_demo/take_quiz/take_quiz_screen.dart';
import '../main.dart';
import 'add_quiz_modal.dart';
import '../model/quiz.dart';
import '../question/question_list_screen.dart';
import '../services/isar_service.dart';
import '../model/module.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key, required this.module, required this.db})
      : super(key: key);
  final Module module;
  final IsarService db;
  static void navigate(context, Module module, IsarService db) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return QuizScreen(module: module, db: db);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(module.moduleTitle)),
        bottomNavigationBar: AddQuizButton(module: module),
        body: QuizGridView(module: module));
  }
}

class QuizGridView extends StatelessWidget {
  const QuizGridView({super.key, required this.module});
  final Module module;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<List<Quiz>>(
              stream: db.listenToQuizzes(module),
              builder: (context, snapshot) => GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                scrollDirection: Axis.vertical,
                children: snapshot.hasData
                    ? snapshot.data!.map((quiz) {
                        return GoToQuizButton(quiz: quiz, module: module);
                      }).toList()
                    : [],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GoToQuizButton extends StatelessWidget {
  const GoToQuizButton({super.key, required this.quiz, required this.module});
  final Quiz quiz;
  final Module module;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: quiz.title,
      child: ElevatedButton(
        onPressed: () {
          QuestionListScreen.navigate(context, quiz, module, db);
        },
        onLongPress: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return UpdateQuizDialog(module: module, quiz: quiz, db: db);
          }));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 89, 80, 253),
          padding: const EdgeInsets.all(5.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        child: Text(quiz.title),
      ),
    );
  }
}

class AddQuizButton extends StatelessWidget {
  const AddQuizButton({super.key, required this.module});
  final Module module;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return AddQuizModal(db, module);
            },
          );
        },
        child: const Text(
          "Add Quiz",
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}

class UpdateQuizDialog extends StatefulWidget {
  const UpdateQuizDialog(
      {super.key, required this.module, required this.quiz, required this.db});
  final Module module;
  final Quiz quiz;
  final IsarService db;

  @override
  State<UpdateQuizDialog> createState() => _UpdateQuizDialogState();
}

class _UpdateQuizDialogState extends State<UpdateQuizDialog> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List listOfQuizzes = [];

  @override
  void initState() {
    super.initState();
    getListQuizzesStrings();
  }

  void getListQuizzesStrings() async {
    listOfQuizzes = await db.getListQuizzesStrings();
    logger.d("$listOfQuizzes");
  }

  void _updateQuiz() {
    if (_formKey.currentState!.validate()) {
      widget.db.updateQuiz(widget.quiz, _textController.text.trim());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Hero(
          tag: widget.quiz.title,
          createRectTween: (begin, end) {
            return MaterialRectCenterArcTween(begin: begin, end: end);
          },
          child: Material(
            color: const Color.fromARGB(255, 89, 80, 253),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                        ),
                        decoration: InputDecoration(
                            icon: const Icon(Icons.settings),
                            border: InputBorder.none,
                            hintText: widget.quiz.title,
                            hintStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 32.0,
                            )),
                        controller: _textController,
                        autofocus: false,
                        onFieldSubmitted: (value) {
                          _updateQuiz();
                        },
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.isEmpty) {
                            return "Info not to be empty";
                          } else if (listOfQuizzes.contains(value.trim())) {
                            return "Quiz already exists";
                          }
                          return null;
                        },
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return  TakeQuizScreen(quiz: widget.quiz);
                        }));
                      },
                      child: const Text('Quiz'),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      onLongPress: () {
                        widget.db.deleteQuiz(widget.quiz);
                        Navigator.pop(context);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
