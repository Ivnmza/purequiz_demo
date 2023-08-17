import 'package:flutter/material.dart';

import 'common_widgets/container_transition.dart';
import 'common_widgets/hero_dialog_route.dart';
import 'constants/app_sizes.dart';
import 'constants/constants.dart';
import 'model/module.dart';
import 'module_modal.dart';
import 'quiz_grid_screen.dart';
import 'services/isar_service.dart';
import 'common_widgets/add_todo_button.dart';

class ModuleGridView extends StatelessWidget {
  const ModuleGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        onPressed: () => QuizListScreen.navigate(context, module, db),
        onLongPress: () => {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return AddTodoPopupCard(module: module, db: db);
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
