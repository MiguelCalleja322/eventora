import 'package:eventora/Widgets/custom_textfield.dart';
import 'package:eventora/controllers/note_controller.dart';
import 'package:eventora/utils/custom_flutter_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Widgets/custom_appbar.dart';

class CreateNotesPage extends StatefulWidget {
  const CreateNotesPage({Key? key}) : super(key: key);

  @override
  State<CreateNotesPage> createState() => _CreateNotesPageState();
}

class _CreateNotesPageState extends State<CreateNotesPage> {
  final TextEditingController noteTitle = TextEditingController();
  final TextEditingController noteDescription = TextEditingController();
  late FocusNode titleNode = FocusNode();
  late FocusNode descrioptionNode = FocusNode();

  void saveNote(context) async {
    if (noteTitle.text.isEmpty) {
      titleNode.requestFocus();
      return;
    }

    if (noteDescription.text.isEmpty) {
      descrioptionNode.requestFocus();
      return;
    }

    Map<String, dynamic> note = {
      'title': noteTitle.text,
      'description': noteDescription.text,
    };

    Map<String, dynamic>? response = await NoteController().store(note);

    if (response!.isNotEmpty) {
      CustomFlutterToast.showErrorToast(response['message']);
      noteTitle.clear();
      noteDescription.clear();
      Navigator.popAndPushNamed(context, '/list_notes');
      return;
    }
  }

  @override
  void dispose() {
    noteTitle.dispose();
    noteDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveNote(context);
        },
        backgroundColor: Colors.grey[850],
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
      appBar: const CustomAppBar(
        title: 'Create Note',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              CustomTextField(
                textAlign: TextAlign.left,
                letterSpacing: 1.0,
                label: 'Title',
                controller: noteTitle,
                focusNode: titleNode,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                maxLine: 9,
                textAlign: TextAlign.left,
                letterSpacing: 1.0,
                label: 'Description',
                controller: noteDescription,
                focusNode: descrioptionNode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
