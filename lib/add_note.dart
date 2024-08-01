

import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'home_screen.dart';

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
      appbarTitle = "Add Note";
      dbHelper.insertNote(titleController.text, descriptionController.text).then((onValue) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Notes Added Successfully")));
        titleController.clear();
        descriptionController.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(toggleTheme: widget.toggleTheme)),
        );
      }).catchError((onError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Insertion Failed $onError")));
      });
    } else {
      appbarTitle = "Update Note";
      dbHelper.updateNotes(titleController.text, descriptionController.text, widget.id!).then((onValue) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Notes Updated Successfully")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(toggleTheme: widget.toggleTheme)),
        );
      }).catchError((onError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Updation Failed $onError")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(appbarTitle),
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
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: descriptionController,
                      minLines: 3,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        labelText: 'Description',
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
                            const SnackBar(content: Text('Title and description cannot be empty.')),
                          );
                          return;
                        }
                        saveAndupdate();
                      },
                      child: const Text("Save"),
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
