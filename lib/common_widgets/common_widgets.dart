import 'dart:io';

import 'package:flutter/material.dart';

import '../main.dart';
import '../services/isar_service.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';



//////////////////////////////////////
////////////////////////////////

//////
///////
/////////////////







///////////////////////////////
///////////////////////////////
////////////////////////////

class ExportJsonFileButton extends StatelessWidget {
  const ExportJsonFileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () async {
        await db
            .exportAllToJSON()
            .then((value) => logger.d("MODULES JSON: $value"));
        await db
            .exportAllQuizlToJSON()
            .then((value) => logger.d("QUIZS JSON: $value"));
        await db
            .exportAllQuestionsToJSON()
            .then((value) => logger.d("QUESTIONS JSON: $value"));
        db.exportAllQuestionsToJSONFile();
        //db.exportAllModulesToJsonFile();
      },
    );
  }
}

class PickDocument extends StatefulWidget {
  const PickDocument({super.key});

  @override
  State<PickDocument> createState() => _PickDocumentState();
}

class _PickDocumentState extends State<PickDocument> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.dock),
      onPressed: () async {
        // importJson.1 create a isar DB from this JSON
        final File myFile;
        final String? path = await FlutterDocumentPicker.openDocument();
        if (path != null) {
          myFile = File(path);
          logger.d("Path picked: $path");
          // importJson.2  insert the contents into a method that will process the JSON
          if (context.mounted) {
            _showFileImportModalSheet(context, myFile);
          }
        } else {
          logger.d("No file picked");
        }
      },
    );
  }
}

void _showFileImportModalSheet(context, File file) async {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return ShowJsonImportModal(file: file);
    },
  );
}

class ShowJsonImportModal extends StatelessWidget {
  const ShowJsonImportModal({super.key, required this.file});
  final File file;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(
            height: 90,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => {db.clearImportJson(file)},
              child: const Text("Clear and Import"),
            ),
          )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () => {db.importJson(file)},
                child: const Text("Add To Current")),
          )),
          const SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////
/////////////////////////////////////////////////



