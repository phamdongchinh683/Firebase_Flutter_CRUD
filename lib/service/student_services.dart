import 'package:cloud_firestore/cloud_firestore.dart';

class StudentServices {
  final CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  Future<void> addStudent(
      int age, String className, String schoolId, String name) {
    return students.add({
      'age': age,
      'className': className,
      'name': name,
      'school_id': schoolId,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> showStudents() {
    return students.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> updateStudent(
      String docId, int age, String className, String schoolId, String name) {
    return students.doc(docId).update({
      'age': age,
      'className': className,
      'name': name,
      'school_id': schoolId,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteStudent(String docId) {
    return students.doc(docId).delete();
  }
}
