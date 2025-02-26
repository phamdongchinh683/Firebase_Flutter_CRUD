import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_note/service/school_services.dart';
import 'package:google_fonts/google_fonts.dart';

class SchoolPage extends StatefulWidget {
  const SchoolPage({super.key});

  @override
  State<SchoolPage> createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  SchoolServices firestoreServices = SchoolServices();

  void showSchoolBox(String? addressToEdit, String? nameToEdit,
      String? phoneToEdit, String? docId, Timestamp? time) {
    if (addressToEdit != null) {
      addressController.text = addressToEdit;
    }
    if (nameToEdit != null) {
      nameController.text = nameToEdit.toString();
    }
    if (phoneToEdit != null) {
      phoneController.text = phoneToEdit;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            docId == null ? "Add School" : "Update School",
            style: GoogleFonts.alexandria(fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'address'),
                style: GoogleFonts.alexandria(),
                controller: addressController,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(hintText: 'name'),
                keyboardType: TextInputType.number,
                style: GoogleFonts.alexandria(),
                controller: nameController,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(hintText: 'phone'),
                style: GoogleFonts.alexandria(),
                controller: phoneController,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    addressController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  if (docId == null) {
                    firestoreServices.addSchool(addressController.text,
                        nameController.text, phoneController.text);
                  } else {
                    firestoreServices.updateSchool(
                        docId,
                        addressController.text,
                        nameController.text,
                        phoneController.text);
                  }
                  nameController.clear();
                  addressController.clear();
                  phoneController.clear();
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
          'Add School',
          style: GoogleFonts.alexandria(fontSize: 18),
        ),
        icon: const Icon(Icons.add),
        onPressed: () {
          showSchoolBox(null, null, null, null, null);
        },
      ),
      body: StreamBuilder(
        stream: firestoreServices.showSchools(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List SchoolList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: SchoolList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = SchoolList[index];
                String docId = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String address = data['address'] ?? '';
                String name = data['name'] ?? '';
                String phone = data['phone'] ?? '';
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
                            address,
                            style: GoogleFonts.alexandria(
                                textStyle: const TextStyle(
                                    color: Colors.blue, fontSize: 19)),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'name: $name \n phone: $phone',
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
                                showSchoolBox(
                                    address, name, phone, docId, time);
                              },
                            ),
                            IconButton(
                              color: Colors.blue[400],
                              onPressed: () {
                                firestoreServices.deleteSchool(docId);
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
              child: Text("Nothing to show... add a School"),
            );
          }
        },
      ),
    );
  }
}
