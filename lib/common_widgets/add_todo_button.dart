import 'package:flutter/material.dart';

import '../model/module.dart';
import '../services/isar_service.dart';
import 'custom_rect_tween.dart';
import 'hero_dialog_route.dart';

/// {@template add_todo_button}
/// Button to add a new [Todo].
///
/// Opens a [HeroDialogRoute] of [_AddTodoPopupCard].
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
class AddTodoButton extends StatelessWidget {
  /// {@macro add_todo_button}
  const AddTodoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return const Placeholder();
          }));
        },
        child: Hero(
          tag: _heroAddTodo,
          createRectTween: (begin, end) {
            return MaterialRectCenterArcTween(begin: begin, end: end);
          },
          child: Material(
            color: const Color(0xFFef8354),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: const Icon(
              Icons.add_rounded,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tag-value used for the add todo popup button.
const String _heroAddTodo = 'mod3';

/// {@template add_todo_popup_card}
/// Popup card to add a new [Todo]. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// {@endtemplate}
class AddTodoPopupCard extends StatefulWidget {
  /// {@macro add_todo_popup_card}
  const AddTodoPopupCard({super.key, required this.module, required this.db});
  final Module module;
  final IsarService db;

  @override
  State<AddTodoPopupCard> createState() => _AddTodoPopupCardState();
}

class _AddTodoPopupCardState extends State<AddTodoPopupCard> {
  final _textController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _updateModule() {
    setState(() {
      if (_formKey.currentState!.validate()) {
        widget.db.updateModule(widget.module, _textController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("New Module '${_textController.text}' saved in DB")));
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Hero(
          tag: widget.module.moduleTitle,
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
                  children: [
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            icon: const Icon(Icons.settings),
                            border: InputBorder.none,
                            hintText: widget.module.moduleTitle,
                            hintStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 32.0,
                            )),
                        controller: _textController,
                        autofocus: false,
                        onFieldSubmitted: (value) {
                          _updateModule();
                        },
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.isEmpty) {
                            return "Info not allowed to be empty";
                          }
                          return null;
                        },
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Write a note',
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.white,
                      maxLines: 6,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    TextButton(
                      onPressed: () {},
                      onLongPress: () {
                        widget.db.deleteModule(widget.module.moduleTitle);
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
