import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_note/service/class_services.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({super.key});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  TextEditingController classController = TextEditingController();
  TextEditingController peopleController = TextEditingController();
  ClassServices firestoreServices = ClassServices();

  void showClassBox(
      String? textToEdit, int? peopleToEdit, String? docId, Timestamp? time) {
    if (textToEdit != null) {
      classController.text = textToEdit;
    }
    if (peopleToEdit != null) {
      peopleController.text = peopleToEdit.toString();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            docId == null ? "Add Class" : "Update Class",
            style: GoogleFonts.alexandria(fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Class Code'),
                style: GoogleFonts.alexandria(),
                controller: classController,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(hintText: 'Number of People'),
                keyboardType: TextInputType.number,
                style: GoogleFonts.alexandria(),
                controller: peopleController,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (classController.text.isNotEmpty &&
                    peopleController.text.isNotEmpty) {
                  int people = int.tryParse(peopleController.text) ?? 0;
                  if (docId == null) {
                    firestoreServices.addClass(classController.text, people);
                  } else {
                    firestoreServices.updateClass(
                        docId, classController.text, people, time!);
                  }
                  classController.clear();
                  peopleController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text(
                docId == null ? 'Add' : 'Update',
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
          'Add Class',
          style: GoogleFonts.alexandria(fontSize: 18),
        ),
        icon: const Icon(Icons.add),
        onPressed: () {
          showClassBox(null, null, null, null);
        },
      ),
      body: StreamBuilder(
        stream: firestoreServices.showClasses(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List classList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: classList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = classList[index];
                String docId = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String classCode = data['class_code'];
                int people = data['people'];
                Timestamp time = data['timestamp'];

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        tileColor: Colors.purple[100],
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            classCode,
                            style: GoogleFonts.alexandria(
                                textStyle: const TextStyle(
                                    color: Colors.purple, fontSize: 19)),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'People: $people',
                            style: GoogleFonts.alexandria(
                              textStyle: const TextStyle(
                                  color: Colors.black87, fontSize: 16),
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              color: Colors.purple[400],
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showClassBox(classCode, people, docId, time);
                              },
                            ),
                            IconButton(
                              color: Colors.purple[400],
                              onPressed: () {
                                firestoreServices.deleteClass(docId);
                              },
                              icon: const Icon(Icons.delete),
                            )
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
                            '${time.toDate().hour.toString().padLeft(2, '0')}:${time.toDate().minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return const Center(
              child: Text("Nothing to show... add a Class"),
            );
          }
        },
      ),
    );
  }
}
