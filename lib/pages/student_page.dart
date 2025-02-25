import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_note/service/student_services.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController classController = TextEditingController();
  StudentServices firestoreServices = StudentServices();

  void showStudentBox(String? nameToEdit, int? ageToEdit, String? classToEdit,
      String? docId, Timestamp? time) {
    if (nameToEdit != null) {
      nameController.text = nameToEdit;
    }
    if (ageToEdit != null) {
      ageController.text = ageToEdit.toString();
    }
    if (classToEdit != null) {
      classController.text = classToEdit;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            docId == null ? "Add Student" : "Update Student",
            style: GoogleFonts.alexandria(fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Student Name'),
                style: GoogleFonts.alexandria(),
                controller: nameController,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(hintText: 'Age'),
                keyboardType: TextInputType.number,
                style: GoogleFonts.alexandria(),
                controller: ageController,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(hintText: 'Class Name'),
                style: GoogleFonts.alexandria(),
                controller: classController,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    ageController.text.isNotEmpty &&
                    classController.text.isNotEmpty) {
                  int age = int.tryParse(ageController.text) ?? 0;
                  if (docId == null) {
                    firestoreServices.addStudent(
                        age, classController.text, nameController.text);
                  } else {
                    firestoreServices.updateStudent(
                        docId, age, classController.text, nameController.text);
                  }
                  nameController.clear();
                  ageController.clear();
                  classController.clear();
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
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[50],
        title: Text(
          "C R U D",
          style: GoogleFonts.alexandria(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue[100],
        label: Text(
          'Add Student',
          style: GoogleFonts.alexandria(fontSize: 18),
        ),
        icon: const Icon(Icons.add),
        onPressed: () {
          showStudentBox(null, null, null, null, null);
        },
      ),
      body: StreamBuilder(
        stream: firestoreServices.showStudents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List studentList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: studentList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = studentList[index];
                String docId = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String name =
                    data['name'] ?? '';
                int age = data['age'] ?? 0; 
                String className =
                    data['className'] ?? ''; 

                Timestamp time = data['timestamp'];

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        tileColor: Colors.blue[100],
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            name,
                            style: GoogleFonts.alexandria(
                                textStyle: const TextStyle(
                                    color: Colors.blue, fontSize: 19)),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Age: $age\nClass: $className',
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
                              color: Colors.blue[400],
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showStudentBox(
                                    name, age, className, docId, time);
                              },
                            ),
                            IconButton(
                              color: Colors.blue[400],
                              onPressed: () {
                                firestoreServices.deleteStudent(docId);
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
                                color: Colors.blue,
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
              child: Text("Nothing to show... add a Student"),
            );
          }
        },
      ),
    );
  }
}
