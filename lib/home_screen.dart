
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/language_provider.dart';
import 'db_helper.dart';
import 'add_note.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HomeScreen extends StatefulWidget {
  final Function(ThemeMode)? toggleTheme;

  HomeScreen({super.key, this.toggleTheme});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
enum Languages{english , urdu}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> notes = [];
  final DbHelper dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  void _fetchNotes() async {
    final data = await dbHelper.getAllNotes();
    setState(() {
      notes = data;
    });
  }

  void deleteNote(int id) async {
    await dbHelper.deleteNote(id);
    _fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: Switch(
          value: isDarkMode,
          onChanged: (isOn) {
            log("isDarkMode $isDarkMode");
            log(isOn.toString());
            if (widget.toggleTheme != null) {
              widget.toggleTheme!(isOn ? ThemeMode.dark : ThemeMode.light);

            }

          },
        ),
        backgroundColor: Colors.blueGrey,
        title: Text(AppLocalizations.of(context)!.notes ),
        centerTitle: true,
        actions: [
         switchLanguage(),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NoteScreen(toggleTheme: widget.toggleTheme)),
              );
            },
          ),
        ],
      ),
      body: notes.isEmpty? Center(child: Text(AppLocalizations.of(context)!.empty_note,style: TextStyle(fontSize: 14),),):
      ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteScreen(
                      title: notes[index]['title'],
                      des: notes[index]['description'],
                      id: notes[index]['id'],
                      toggleTheme: widget.toggleTheme,
                    ),
                  ),
                );
              },
              child: Card(
                color: Colors.amber,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notes[index]['title'],
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              notes[index]['description'],
                              style: const TextStyle(fontSize: 13),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(notes[index]['date']),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteNote(notes[index]['id']);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget switchLanguage(){
  return    Consumer<LanguageProvider>(builder: (context, provider, child) {
    return  PopupMenuButton(
        onSelected: (Languages item){
          if(Languages.english.name == item.name){
            log("lang.name ${Languages.english.name}" );
            log("item.name  ${item.name}");
            provider.changeLang(const Locale('en'));
          }
          else {
            provider.changeLang(const Locale('ur'));
          }
        },
        icon: Icon(Icons.language),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Languages>>[
          PopupMenuItem(
              value: Languages.english,
              child: Text(AppLocalizations.of(context)?.english ?? "")),
          PopupMenuItem(
              value: Languages.urdu,
              child: Text(AppLocalizations.of(context)!.urdu)),
        ]
    );
  });



}