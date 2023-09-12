import 'package:flutter/material.dart';

import '../common_widgets/hero_dialog_route.dart';
import '../constants/app_sizes.dart';
import '../constants/constants.dart';
import '../model/module.dart';
import 'module_modal.dart';
import '../quiz/quiz_grid_screen.dart';
import '../services/isar_service.dart';

class MySearch extends StatefulWidget {
  const MySearch({super.key});

  @override
  State<MySearch> createState() => _MySearchState();
}

class _MySearchState extends State<MySearch> {
  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
        viewLeading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            Navigator.of(context).pop();
          },
          style: const ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        ),
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
              return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10));
            }),
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
            trailing: <Widget>[
              Tooltip(
                message: 'Change brightness mode',
                child: IconButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      controller.text = '';
                    });
                  },
                  icon: const Icon(Icons.close),
                ),
              )
            ],
          );
        },
        suggestionsBuilder:
            (BuildContext context, SearchController controller) {
              List<ListTile> a = [];
              return a;
       
        });
  }
}

class ModuleGridView extends StatelessWidget {
  const ModuleGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MySearch(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: StreamBuilder<List<Module>>(
              stream: db.listenToModules(),
              builder: (context, snapshot) => GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                scrollDirection: Axis.vertical,
                children: snapshot.hasData
                    ? snapshot.data!.map((module) {
                        return GoToModuleButton(module: module, db: db);
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

class GoToModuleButton extends StatelessWidget {
  const GoToModuleButton({super.key, required this.module, required this.db});
  final IsarService db;
  final Module module;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: module.moduleTitle,
      child: ElevatedButton(
        onPressed: () => QuizScreen.navigate(context, module, db),
        onLongPress: () => {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return ModifyModuleDialog(module: module, db: db);
          }))
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: kPurple,
            padding: const EdgeInsets.all(Sizes.p16),
            shape: kTopicShape),
        child: Text(
          module.moduleTitle,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class AddModuleButton extends StatelessWidget {
  const AddModuleButton({super.key});

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
              return ModuleModal(db);
            },
          );
        },
        child: const Text(
          "Add Topic",
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}

class ModifyModuleDialog extends StatefulWidget {
  /// {@macro add_todo_popup_card}
  const ModifyModuleDialog({super.key, required this.module, required this.db});
  final Module module;
  final IsarService db;

  @override
  State<ModifyModuleDialog> createState() => _ModifyModuleDialogState();
}

class _ModifyModuleDialogState extends State<ModifyModuleDialog> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List listOfModules = [];

  @override
  void initState() {
    super.initState();
    getModuleStrings();
  }

  void getModuleStrings() async {
    listOfModules = await db.getListModuleStrings();
  }

  void _updateModule() {
    setState(() {
      if (_formKey.currentState!.validate()) {
        widget.db.updateModule(widget.module, _textController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Module updated: '${_textController.text}' in DB")));
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
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
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
                            return "Info not to be empty";
                          } else if (listOfModules.contains(value.trim())) {
                            return "Module already exists";
                          }
                          return null;
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      onLongPress: () {
                        widget.db.deleteModule(widget.module);
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
