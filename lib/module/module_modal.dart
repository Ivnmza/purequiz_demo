import 'package:flutter/material.dart';
import '../model/module.dart';
import '/services/isar_service.dart';

class ModuleModal extends StatefulWidget {
  final IsarService db;
  const ModuleModal(this.db, {Key? key}) : super(key: key);

  @override
  State<ModuleModal> createState() => _ModuleModalState();
}

class _ModuleModalState extends State<ModuleModal> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  List listOfModules = [];

  @override
  void initState() {
    super.initState();
    getModuleStrings();
  }

  void getModuleStrings() async {
    listOfModules = await db.getListModuleStrings();
  }

  void _addModule() {
    if (_formKey.currentState!.validate()) {
      widget.db.saveModule(Module()..moduleTitle = _textController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("New Module '${_textController.text}' saved in DB")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 15),
                Text("New Topic:",
                    style: Theme.of(context).textTheme.headlineSmall),
                TextFormField(
                  controller: _textController,
                  autofocus: true,
                  onFieldSubmitted: (value) {
                    _addModule();
                  },
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        value.isEmpty) {
                      return "Info not allowed to be empty";
                    } else if (listOfModules.contains(value.trim())) {
                      return "Module already exists";
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      _addModule();
                    },
                    child: const Text("Add new topic"))
              ],
            ),
          ),
        )
      ],
    );
  }
}
/*
Widget a() {
  return Column(
    children: [
      Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Enter Info",
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              TextFormField(
                controller: _textController,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Info not allowed to be empty";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      widget.service.saveModule(Module()..moduleTitle = _textController.text);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "New Module '${_textController.text}' saved in DB")));

                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add new topic"))
            ],
          ),
        ),
    ],
  );
}*/