

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'db_helper.dart';
import 'home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoteScreen extends StatefulWidget {
  String? title;
  String? des;
  int? id;

  final Function(ThemeMode)? toggleTheme; // Nullable callback

  NoteScreen({super.key, this.title, this.des, this.id, this.toggleTheme});

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  String appbarTitle = "";

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      titleController.text = widget.title ?? '';
      descriptionController.text = widget.des ?? '';
    }
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final DbHelper dbHelper = DbHelper();

  void saveAndupdate() {
    if (widget.id == null) {

      dbHelper.insertNote(titleController.text, descriptionController.text).then((onValue) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.notes_added)));
        titleController.clear();
        descriptionController.clear();

        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(builder: (BuildContext context) => HomeScreen(toggleTheme: widget.toggleTheme)),
          ModalRoute.withName('/'),
        );
      }).catchError((onError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${AppLocalizations.of(context)!.insertion_failed} $onError")));
      });
    } else {

      dbHelper.updateNotes(titleController.text, descriptionController.text, widget.id!).then((onValue) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.notes_updated)));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(toggleTheme: widget.toggleTheme)),
        );
      }).catchError((onError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${AppLocalizations.of(context)!.updation_failed} $onError")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(AppLocalizations.of(context)!.appbar_title),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: dbHelper.database, // Ensure the database is initialized
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration:  InputDecoration(
                        labelText: AppLocalizations.of(context)!.title,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: descriptionController,
                      minLines: 3,
                      maxLines: 10,
                      decoration:  InputDecoration(
                        labelText: AppLocalizations.of(context)!.description,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        String title = titleController.text.trim();
                        String description = descriptionController.text.trim();
                        if (title.isEmpty || description.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text('Title and description cannot be empty.',)),
                          );
                          return;
                        }
                        saveAndupdate();
                      },

                      child:  Text(AppLocalizations.of(context)!.save),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
