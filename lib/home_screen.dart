import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'add_note.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

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
  void  deleteNote(int id) async {
   await dbHelper.deleteNote(id);

   _fetchNotes() ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Notes'),
        actions: [

          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NoteScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: InkWell( onTap: (){
              // dbHelper.updateNotes(notes[index]['title'], notes[index]['description'], notes[index]['id']);
            Navigator.push(context, MaterialPageRoute(builder: (context) => NoteScreen(title: notes[index]['title'],des:  notes[index]['description'],id:  notes[index]['id']  ,)));
            }


              ,
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
                            Text(notes[index]['title'],style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          Text(notes[index]['description'],style: const TextStyle(fontSize: 13),),
                            Align( alignment: Alignment.bottomRight,
                                child: Text(notes[index]['date']))


                        ],),
                      ),
                      IconButton(onPressed: (){

                        deleteNote(notes[index]['id']);

                      }, icon: Icon(Icons.delete)),
                    ],
                  )



                ),),
            ),
          );
        },
      ),
    );
  }
}

