import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_note/service/teacher_services.dart';
import 'package:google_fonts/google_fonts.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController schoolIdController = TextEditingController();
  TextEditingController subjectController = TextEditingController();

  TeacherServices firestoreServices = TeacherServices();

  void showTeacherBox(
      String? emailToEdit,
      String? nameToEdit,
      String? schoolIdToEdit,
      String? subjectToEdit,
      String? docId,
      Timestamp? time) {
    emailController.text = emailToEdit ?? '';
    nameController.text = nameToEdit ?? '';
    schoolIdController.text = schoolIdToEdit ?? '';
    subjectController.text = subjectToEdit ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            docId == null ? "Add Teacher" : "Update Teacher",
            style: GoogleFonts.alexandria(fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Email'),
                style: GoogleFonts.alexandria(),
                controller: emailController,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(hintText: 'Name'),
                style: GoogleFonts.alexandria(),
                controller: nameController,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(hintText: 'School ID'),
                style: GoogleFonts.alexandria(),
                controller: schoolIdController,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(hintText: 'Subject'),
                style: GoogleFonts.alexandria(),
                controller: subjectController,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (emailController.text.isNotEmpty &&
                    nameController.text.isNotEmpty &&
                    schoolIdController.text.isNotEmpty &&
                    subjectController.text.isNotEmpty) {
                  if (docId == null) {
                    firestoreServices.addTeacher(
                      emailController.text,
                      nameController.text,
                      schoolIdController.text,
                      subjectController.text,
                    );
                  } else {
                    firestoreServices.updateTeacher(
                      docId,
                      emailController.text,
                      nameController.text,
                      schoolIdController.text,
                      subjectController.text,
                    );
                  }
                  emailController.clear();
                  nameController.clear();
                  schoolIdController.clear();
                  subjectController.clear();
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
          'Add Teacher',
          style: GoogleFonts.alexandria(fontSize: 18),
        ),
        icon: const Icon(Icons.add),
        onPressed: () {
          showTeacherBox(null, null, null, null, null, null);
        },
      ),
      body: StreamBuilder(
        stream: firestoreServices.showTeachers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List teacherList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: teacherList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = teacherList[index];
                String docId = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String email = data['email'] ?? '';
                String name = data['name'] ?? '';
                String schoolId = data['school_id'] ?? '';
                String subject = data['subject'] ?? '';
                Timestamp time = data['timestamps'] ?? Timestamp.now();

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
                            email,
                            style: GoogleFonts.alexandria(
                                textStyle: const TextStyle(
                                    color: Colors.blue, fontSize: 19)),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Name: $name \nSchool ID: $schoolId \nSubject: $subject',
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
                                showTeacherBox(email, name, schoolId, subject,
                                    docId, time);
                              },
                            ),
                            IconButton(
                              color: Colors.blue[400],
                              onPressed: () {
                                firestoreServices.deleteTeacher(docId);
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
              child: Text("Nothing to show... add a teacher"),
            );
          }
        },
      ),
    );
  }
}
