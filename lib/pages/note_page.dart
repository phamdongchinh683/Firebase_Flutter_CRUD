import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_note/service/firebase_services.dart';
import 'package:google_fonts/google_fonts.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  TextEditingController controller = TextEditingController();
  FirestoreServices firestoreServices = FirestoreServices();
  void showNoteBox(String? textToedit, String? docId, Timestamp? time) {
    showDialog(
      context: context,
      builder: (context) {
        if (textToedit != null) {
          controller.text = textToedit;
        }
        return AlertDialog(
          title: Text(
            "Add note",
            style: GoogleFonts.alexandria(fontSize: 16),
          ),
          content: TextField(
            decoration: InputDecoration(hintText: 'Note here...'),
            style: GoogleFonts.alexandria(),
            controller: controller,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (docId == null) {
                  firestoreServices.addNote(controller.text);
                } else {
                  firestoreServices.updateNotes(docId, controller.text, time!);
                }
                controller.clear();
                Navigator.pop(context);
              },
              child: Text(
                'add',
                style: GoogleFonts.alexandria(),
              ),
            )
          ],
        );
      },
    );
  }

  void showNoteUpdate(String? textToedit, String? docId, Timestamp? time) {
    showDialog(
      context: context,
      builder: (context) {
        if (textToedit != null) {
          controller.text = textToedit;
        }
        return AlertDialog(
          title: Text(
            "Update note",
            style: GoogleFonts.alexandria(fontSize: 16),
          ),
          content: TextField(
            decoration: InputDecoration(hintText: 'Note here...'),
            style: GoogleFonts.alexandria(),
            controller: controller,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (docId == null) {
                  firestoreServices.addNote(controller.text);
                } else {
                  firestoreServices.updateNotes(docId, controller.text, time!);
                }
                controller.clear();
                Navigator.pop(context);
              },
              child: Text(
                'update',
                style: GoogleFonts.alexandria(),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple[50],
        title: Text(
          "C R U D",
          style: GoogleFonts.alexandria(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purple[100],
        label: Text(
          'add note',
          style: GoogleFonts.alexandria(fontSize: 18),
        ),
        icon: Icon(Icons.add),
        onPressed: () async {
          showNoteBox(null, null, null);
        },
      ),
      body: StreamBuilder(
        stream: FirestoreServices().showNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List noteList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: noteList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = noteList[index];
                String docId = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String note = data['note'];
                Timestamp time = data['timestamp'];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        tileColor: Colors.purple[100],
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            note,
                            style: GoogleFonts.alexandria(
                                textStyle: TextStyle(
                                    color: Colors.purple[800], fontSize: 19)),
                          ),
                        ),
                        trailing: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  color: Colors.purple[400],
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    showNoteUpdate(note, docId, time);
                                  },
                                ),
                                IconButton(
                                    color: Colors.purple[400],
                                    onPressed: () {
                                      firestoreServices.deleteNote(docId);
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            time.toDate().hour.toString(),
                            style: const TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(":"),
                          Text(
                            time.toDate().minute.toString(),
                            style: const TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            );
          } else {
            return Center(
              child: Text("Nothing to show...add notes"),
            );
          }
        },
      ),
    );
  }
}
